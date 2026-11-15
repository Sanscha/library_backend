<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Models\Booking;
use App\Models\Notification;
use App\Models\Subscription;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserProfileController extends Controller
{
    /**
     * Get full Student Profile with subscription, current seat, study hours, and stats.
     */
    public function profile(Request $request): JsonResponse
    {
        $user = $request->user();
        $today = Carbon::today()->toDateString();
        $now = Carbon::now();

        // 1. Active Membership Subscription & Expiry
        $activeSub = Subscription::with(['plan', 'library', 'seat.zone'])
            ->where('user_id', $user->id)
            ->where('status', 'active')
            ->where('end_date', '>=', $today)
            ->latest('end_date')
            ->first();

        // 2. Active Seat Booking Today
        $activeBooking = Booking::with(['seat.zone', 'seat.library'])
            ->where('user_id', $user->id)
            ->where('booking_date', $today)
            ->where('status', 'active')
            ->first();

        // 3. Study Hours Today
        $completedMinutes = (int) Attendance::where('user_id', $user->id)
            ->where('date', $today)
            ->where('status', 'checked_out')
            ->sum('duration_minutes');

        $ongoingSession = Attendance::where('user_id', $user->id)
            ->where('date', $today)
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
        $studyFormatted = ($hours > 0 ? "{$hours}h " : '0h ')."{$remMinutes}m";

        // 4. Notifications Unread Count
        $unreadNotifications = Notification::where('user_id', $user->id)
            ->where('is_read', false)
            ->count();

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone,
                'avatar' => $user->avatar,
                'role' => $user->role,
                'status' => $user->status,
                'email_verified' => $user->isEmailVerified(),
                'created_at' => $user->created_at->toDateString(),
            ],
            'membership' => $activeSub ? [
                'plan_name' => $activeSub->plan->name ?? 'Standard',
                'duration_days' => $activeSub->plan->duration_days ?? 30,
                'start_date' => $activeSub->start_date->toDateString(),
                'expiry_date' => $activeSub->end_date->toDateString(),
                'days_remaining' => $activeSub->daysRemaining(),
                'is_expiring_soon' => $activeSub->daysRemaining() <= 7,
                'status' => $activeSub->status,
            ] : null,
            'today_booking' => $activeBooking ? [
                'id' => $activeBooking->id,
                'pass_code' => $activeBooking->pass_code,
                'shift' => $activeBooking->shift,
                'seat_number' => $activeBooking->seat->seat_number ?? null,
                'zone' => $activeBooking->seat->zone->name ?? null,
                'library' => $activeBooking->seat->library->name ?? null,
                'booking_date' => $activeBooking->booking_date,
            ] : null,
            'today_study_hours' => [
                'minutes' => $totalTodayMinutes,
                'formatted' => $studyFormatted,
                'is_currently_in_library' => $ongoingSession !== null,
                'checked_in_at' => $ongoingSession?->check_in_at?->format('h:i A'),
            ],
            'stats' => [
                'total_bookings' => $user->bookings()->count(),
                'total_payments' => $user->payments()->where('status', 'completed')->count(),
                'unread_notifications' => $unreadNotifications,
            ],
        ], 200);
    }

    /**
     * Update Student Profile.
     */
    public function updateProfile(Request $request): JsonResponse
    {
        $user = $request->user();

        $fields = $request->validate([
            'name' => 'nullable|string|max:255',
            'phone' => 'nullable|string|max:20|unique:users,phone,'.$user->id,
            'avatar' => 'nullable|string|max:500',
        ]);

        if (isset($fields['name'])) {
            $user->name = $fields['name'];
        }
        if (isset($fields['phone'])) {
            $user->phone = $fields['phone'];
        }
        if (isset($fields['avatar'])) {
            $user->avatar = $fields['avatar'];
        }

        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Profile updated successfully.',
            'user' => $user,
        ], 200);
    }
}
