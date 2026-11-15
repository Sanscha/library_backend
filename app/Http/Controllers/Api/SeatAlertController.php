<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Seat;
use App\Models\SmartVacancyAlert;
use App\Models\WaitingList;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SeatAlertController extends Controller
{
    /**
     * Join the Waiting List for a vacant seat alert.
     */
    public function joinWaitingList(Request $request): JsonResponse
    {
        $fields = $request->validate([
            'library_id' => 'required|exists:libraries,id',
            'zone_id' => 'nullable|exists:zones,id',
            'seat_id' => 'nullable|exists:seats,id',
            'shift' => 'required|in:morning,evening,full_day,any',
            'desired_date' => 'nullable|date_format:Y-m-d',
        ]);

        $user = $request->user();
        $desiredDate = $fields['desired_date'] ?? Carbon::today()->toDateString();

        // Check if student already in waiting list for same date and shift
        $exists = WaitingList::where('user_id', $user->id)
            ->where('library_id', $fields['library_id'])
            ->whereDate('desired_date', $desiredDate)
            ->where('status', 'waiting')
            ->first();

        if ($exists) {
            return response()->json([
                'success' => true,
                'message' => 'You are already on the waiting list for this slot.',
                'waiting_list' => $exists,
            ], 200);
        }

        $entry = WaitingList::create([
            'user_id' => $user->id,
            'library_id' => $fields['library_id'],
            'zone_id' => $fields['zone_id'] ?? null,
            'seat_id' => $fields['seat_id'] ?? null,
            'shift' => $fields['shift'],
            'desired_date' => $desiredDate,
            'status' => 'waiting',
        ]);

        // Position in queue
        $queuePosition = WaitingList::where('library_id', $fields['library_id'])
            ->whereDate('desired_date', $desiredDate)
            ->where('status', 'waiting')
            ->where('id', '<=', $entry->id)
            ->count();

        return response()->json([
            'success' => true,
            'message' => "Added to waiting list! You are position #{$queuePosition} in line. We will notify you when a seat opens.",
            'waiting_list' => $entry,
            'queue_position' => $queuePosition,
        ], 201);
    }

    /**
     * View student's active waiting list entries.
     */
    public function myWaitingList(Request $request): JsonResponse
    {
        $entries = WaitingList::with(['library', 'zone', 'seat'])
            ->where('user_id', $request->user()->id)
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $entries,
        ], 200);
    }

    /**
     * Cancel/leave waiting list.
     */
    public function leaveWaitingList(Request $request, int|string $id): JsonResponse
    {
        $entry = WaitingList::where('user_id', $request->user()->id)->findOrFail($id);
        $entry->status = 'cancelled';
        $entry->save();

        return response()->json([
            'success' => true,
            'message' => 'Removed from waiting list.',
        ], 200);
    }

    /**
     * Get active Smart Vacancy Alerts (seats cancelled with 5-minute fast-book countdown).
     */
    public function smartVacancyAlerts(Request $request): JsonResponse
    {
        $libraryId = $request->query('library_id');
        $now = Carbon::now();

        $query = SmartVacancyAlert::with(['seat.zone', 'library'])
            ->where('status', 'active')
            ->where('expires_at', '>', $now)
            ->latest();

        if ($libraryId) {
            $query->where('library_id', $libraryId);
        }

        $alerts = $query->get()->map(function ($alert) {
            return [
                'id' => $alert->id,
                'title' => $alert->title,
                'badge' => 'New',
                'message' => $alert->message,
                'seat_id' => $alert->seat_id,
                'seat_number' => $alert->seat->seat_number ?? null,
                'zone' => $alert->seat->zone->name ?? null,
                'shift' => $alert->shift,
                'alert_date' => $alert->alert_date,
                'expires_at' => $alert->expires_at->toIso8601String(),
                'seconds_remaining' => $alert->secondsRemaining(),
                'library' => $alert->library ? [
                    'id' => $alert->library->id,
                    'name' => $alert->library->name,
                ] : null,
            ];
        });

        return response()->json([
            'success' => true,
            'message' => 'Active Smart Vacancy Alerts retrieved.',
            'count' => $alerts->count(),
            'data' => $alerts,
        ], 200);
    }

    /**
     * Fast-book a vacant seat inside the 5-minute countdown window.
     */
    public function fastBookVacancy(Request $request, int|string $id): JsonResponse
    {
        $user = $request->user();
        $alert = SmartVacancyAlert::with('seat')->findOrFail($id);

        if ($alert->status !== 'active' || $alert->isExpired()) {
            return response()->json([
                'success' => false,
                'message' => 'This smart vacancy window has expired or the seat has already been claimed.',
            ], 410);
        }

        $seat = $alert->seat;
        $bookingDate = $alert->alert_date->toDateString();
        $shift = $alert->shift;

        // Check if seat already booked
        $isBooked = Booking::where('seat_id', $seat->id)
            ->where('booking_date', $bookingDate)
            ->where('status', 'active')
            ->where(function ($q) use ($shift) {
                if ($shift === 'full_day') {
                    $q->whereIn('shift', ['morning', 'evening', 'full_day']);
                } else {
                    $q->where('shift', $shift)->orWhere('shift', 'full_day');
                }
            })
            ->exists();

        if ($isBooked) {
            $alert->status = 'claimed';
            $alert->save();

            return response()->json([
                'success' => false,
                'message' => 'Sorry, another student just booked this seat moments ago.',
            ], 409);
        }

        // Create booking
        $passCode = Booking::generatePassCode();
        $booking = Booking::create([
            'user_id' => $user->id,
            'seat_id' => $seat->id,
            'pass_code' => $passCode,
            'shift' => $shift,
            'booking_date' => $bookingDate,
            'status' => 'active',
        ]);

        $seat->status = 'reserved';
        $seat->save();

        // Mark alert as claimed
        $alert->status = 'claimed';
        $alert->claimed_by = $user->id;
        $alert->save();

        return response()->json([
            'success' => true,
            'message' => "Congratulations! You claimed Seat {$seat->seat_number} via Smart Vacancy Alert.",
            'booking' => $booking->load(['seat.zone']),
        ], 201);
    }
}
