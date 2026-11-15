<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Models\Booking;
use App\Models\Library;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AttendanceController extends Controller
{
    /**
     * QR Entry / Exit Scan: Students scan QR code through student app.
     * Toggles between Check-In and Check-Out.
     */
    public function scanQr(Request $request): JsonResponse
    {
        $fields = $request->validate([
            'library_id' => 'nullable|exists:libraries,id',
            'qr_token' => 'nullable|string', // scanned QR token from library entrance
        ]);

        $user = $request->user();
        $today = Carbon::today()->toDateString();
        $now = Carbon::now();

        // Check if student is currently checked in
        $activeSession = Attendance::where('user_id', $user->id)
            ->whereDate('date', $today)
            ->where('status', 'checked_in')
            ->latest('check_in_at')
            ->first();

        if ($activeSession) {
            // Already checked in -> Record Check-Out
            $activeSession->recordCheckout();

            $minutes = $activeSession->duration_minutes;
            $hours = floor($minutes / 60);
            $remMinutes = $minutes % 60;
            $formattedTime = ($hours > 0 ? "{$hours}h " : '')."{$remMinutes}m";

            return response()->json([
                'success' => true,
                'action' => 'check_out',
                'message' => "Checked out successfully at {$now->format('h:i A')}. Session study time: {$formattedTime}.",
                'attendance' => $activeSession,
                'today_study_hours' => $this->calculateTodayStudyTime($user->id),
            ], 200);
        }

        // Not checked in -> Record Check-In
        // Check if student has active booking today
        $activeBooking = Booking::where('user_id', $user->id)
            ->whereDate('booking_date', $today)
            ->where('status', 'active')
            ->first();

        $libraryId = $fields['library_id'] ?? ($activeBooking?->seat?->library_id ?? Library::value('id'));

        $attendance = Attendance::create([
            'user_id' => $user->id,
            'library_id' => $libraryId,
            'booking_id' => $activeBooking?->id,
            'check_in_at' => $now,
            'date' => $today,
            'status' => 'checked_in',
            'duration_minutes' => 0,
        ]);

        return response()->json([
            'success' => true,
            'action' => 'check_in',
            'message' => "Welcome to the library! Checked in at {$now->format('h:i A')}. Study session started.",
            'attendance' => $attendance,
            'active_booking' => $activeBooking ? $activeBooking->load('seat.zone') : null,
        ], 201);
    }

    /**
     * Staff/Reception Action: Scan student pass code for entry or exit.
     */
    public function verifyStaffPass(Request $request): JsonResponse
    {
        $fields = $request->validate([
            'pass_code' => 'required|string',
        ]);

        $booking = Booking::with(['user', 'seat.zone', 'seat.library'])
            ->where('pass_code', trim($fields['pass_code']))
            ->first();

        if (! $booking) {
            return response()->json([
                'success' => false,
                'valid' => false,
                'message' => 'Invalid pass code. No booking record found.',
            ], 404);
        }

        $today = Carbon::today()->toDateString();
        $now = Carbon::now();

        // Check if user currently checked in
        $activeSession = Attendance::where('user_id', $booking->user_id)
            ->whereDate('date', $today)
            ->where('status', 'checked_in')
            ->latest('check_in_at')
            ->first();

        if ($activeSession) {
            $activeSession->recordCheckout();
            $action = 'check_out';
            $msg = "Pass verified! Marked Check-Out for {$booking->user->name}.";
        } else {
            $activeSession = Attendance::create([
                'user_id' => $booking->user_id,
                'library_id' => $booking->seat?->library_id,
                'booking_id' => $booking->id,
                'check_in_at' => $now,
                'date' => $today,
                'status' => 'checked_in',
            ]);
            $action = 'check_in';
            $msg = "Pass verified! Marked Check-In for {$booking->user->name}.";
        }

        return response()->json([
            'success' => true,
            'valid' => true,
            'action' => $action,
            'message' => $msg,
            'booking' => $booking,
            'attendance' => $activeSession,
        ], 200);
    }

    /**
     * Study Hours Tracking: View how many hours the student has studied today.
     */
    public function todayStudyHours(Request $request): JsonResponse
    {
        $user = $request->user();
        $stats = $this->calculateTodayStudyTime($user->id);

        return response()->json([
            'success' => true,
            'data' => $stats,
        ], 200);
    }

    /**
     * Student's past attendance history.
     */
    public function history(Request $request): JsonResponse
    {
        $attendances = Attendance::with(['library', 'booking.seat.zone'])
            ->where('user_id', $request->user()->id)
            ->orderBy('date', 'desc')
            ->orderBy('check_in_at', 'desc')
            ->paginate(15);

        return response()->json([
            'success' => true,
            'data' => $attendances->items(),
            'pagination' => [
                'current_page' => $attendances->currentPage(),
                'last_page' => $attendances->lastPage(),
                'total' => $attendances->total(),
            ],
        ], 200);
    }

    /**
     * Helper to compute today's study minutes, ongoing duration, and weekly aggregate.
     *
     * @return array{today_minutes: int, today_formatted: string, is_currently_studying: bool, current_session_minutes: int, weekly_minutes: int, weekly_formatted: string}
     */
    protected function calculateTodayStudyTime(int $userId): array
    {
        $today = Carbon::today()->toDateString();
        $now = Carbon::now();

        $completedMinutes = (int) Attendance::where('user_id', $userId)
            ->whereDate('date', $today)
            ->where('status', 'checked_out')
            ->sum('duration_minutes');

        $ongoingSession = Attendance::where('user_id', $userId)
            ->whereDate('date', $today)
            ->where('status', 'checked_in')
            ->latest('check_in_at')
            ->first();

        $ongoingMinutes = 0;
        if ($ongoingSession && $ongoingSession->check_in_at) {
            $ongoingMinutes = (int) $ongoingSession->check_in_at->diffInMinutes($now);
        }

        $totalTodayMinutes = $completedMinutes + $ongoingMinutes;
        $hours = floor($totalTodayMinutes / 60);
        $remMinutes = $totalTodayMinutes % 60;
        $todayFormatted = ($hours > 0 ? "{$hours}h " : '0h ')."{$remMinutes}m";

        // Weekly calculation (last 7 days)
        $weekStart = Carbon::today()->subDays(6)->toDateString();
        $weeklyCompleted = (int) Attendance::where('user_id', $userId)
            ->whereBetween('date', [$weekStart, $today])
            ->where('status', 'checked_out')
            ->sum('duration_minutes');
        $weeklyTotal = $weeklyCompleted + $ongoingMinutes;
        $weekHours = floor($weeklyTotal / 60);
        $weekRemMinutes = $weeklyTotal % 60;
        $weeklyFormatted = ($weekHours > 0 ? "{$weekHours}h " : '0h ')."{$weekRemMinutes}m";

        return [
            'today_minutes' => $totalTodayMinutes,
            'today_formatted' => $todayFormatted,
            'is_currently_studying' => $ongoingSession !== null,
            'current_session_minutes' => $ongoingMinutes,
            'weekly_minutes' => $weeklyTotal,
            'weekly_formatted' => $weeklyFormatted,
        ];
    }
}
