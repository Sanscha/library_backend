<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Seat;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SeatController extends Controller
{
    /**
     * Public/Member View: Fetch live status of all seats grouped by zone.
     */
    public function getSeatGrid(): JsonResponse
    {
        $seats = Seat::with(['zone:id,name,code'])
            ->select('id', 'library_id', 'zone_id', 'seat_number', 'status')
            ->get();

        $summary = [
            'total' => $seats->count(),
            'available' => $seats->where('status', 'available')->count(),
            'occupied' => $seats->where('status', 'occupied')->count(),
            'reserved' => $seats->where('status', 'reserved')->count(),
            'maintenance' => $seats->where('status', 'maintenance')->count(),
        ];

        $grouped = $seats->groupBy(function ($seat) {
            return $seat->zone ? $seat->zone->name : 'Unassigned';
        });

        return response()->json([
            'success' => true,
            'summary' => $summary,
            'data' => $grouped,
        ], 200);
    }

    /**
     * Smart Seat Booking Grid: Students view available seats for their selected date & shift and book themselves.
     */
    public function getSmartGrid(Request $request): JsonResponse
    {
        $date = $request->query('booking_date', Carbon::today()->toDateString());
        $shift = $request->query('shift', 'morning'); // morning, evening, full_day
        $libraryId = $request->query('library_id');

        $query = Seat::with(['zone:id,name,code', 'library:id,name']);

        if ($libraryId) {
            $query->where('library_id', $libraryId);
        }

        $seats = $query->orderBy('seat_number')->get();

        // Get conflicting bookings for this date and shift
        $conflictingBookings = Booking::with('user:id,name')
            ->where('booking_date', $date)
            ->where('status', 'active')
            ->where(function ($q) use ($shift) {
                if ($shift === 'full_day') {
                    $q->whereIn('shift', ['morning', 'evening', 'full_day']);
                } else {
                    $q->where('shift', $shift)->orWhere('shift', 'full_day');
                }
            })
            ->get()
            ->keyBy('seat_id');

        $processedSeats = $seats->map(function ($seat) use ($conflictingBookings, $date, $shift) {
            $booking = $conflictingBookings->get($seat->id);
            $isUnderMaintenance = ($seat->status === 'maintenance');
            $isBooked = ($booking !== null);

            $slotStatus = 'available';
            if ($isUnderMaintenance) {
                $slotStatus = 'maintenance';
            } elseif ($isBooked) {
                $slotStatus = 'occupied';
            }

            return [
                'id' => $seat->id,
                'seat_number' => $seat->seat_number,
                'zone' => $seat->zone ? [
                    'id' => $seat->zone->id,
                    'name' => $seat->zone->name,
                    'code' => $seat->zone->code,
                ] : null,
                'library' => $seat->library ? [
                    'id' => $seat->library->id,
                    'name' => $seat->library->name,
                ] : null,
                'slot_status' => $slotStatus,
                'can_book' => ($slotStatus === 'available'),
                'selected_date' => $date,
                'selected_shift' => $shift,
                'booking_expiry' => $booking ? ($booking->expires_at ?? $booking->booking_date) : null,
            ];
        });

        $summary = [
            'total' => $processedSeats->count(),
            'available' => $processedSeats->where('slot_status', 'available')->count(),
            'occupied' => $processedSeats->where('slot_status', 'occupied')->count(),
            'maintenance' => $processedSeats->where('slot_status', 'maintenance')->count(),
        ];

        return response()->json([
            'success' => true,
            'selected_date' => $date,
            'selected_shift' => $shift,
            'summary' => $summary,
            'seats' => $processedSeats,
        ], 200);
    }

    /**
     * Staff Action: Update seat availability state instantly.
     */
    public function updateSeatStatus(Request $request, int|string $id): JsonResponse
    {
        $request->validate([
            'status' => 'required|in:available,occupied,reserved,maintenance',
        ]);

        $seat = Seat::with('zone:id,name,code')->findOrFail($id);
        $seat->status = $request->input('status');
        $seat->save();

        return response()->json([
            'success' => true,
            'message' => 'Seat status updated successfully',
            'seat' => $seat,
        ], 200);
    }
}
