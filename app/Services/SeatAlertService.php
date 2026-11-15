<?php

namespace App\Services;

use App\Models\Notification;
use App\Models\Seat;
use App\Models\SmartVacancyAlert;
use App\Models\User;
use App\Models\WaitingList;
use Carbon\Carbon;
use Illuminate\Support\Collection;

class SeatAlertService
{
    /**
     * Trigger smart vacancy alert with urgent 5-minute countdown window when a seat becomes available / cancelled.
     */
    public function triggerSmartVacancyAlert(Seat $seat, string $shift = 'full_day', ?string $date = null): SmartVacancyAlert
    {
        $date = $date ?? Carbon::today()->toDateString();
        $expiresAt = Carbon::now()->addMinutes(5);

        $alert = SmartVacancyAlert::create([
            'library_id' => $seat->library_id,
            'seat_id' => $seat->id,
            'shift' => in_array($shift, ['morning', 'evening', 'full_day']) ? $shift : 'full_day',
            'alert_date' => $date,
            'title' => 'Library Seat Available!',
            'message' => "Seat {$seat->seat_number} is now available! Book within 5 minutes.",
            'expires_at' => $expiresAt,
            'status' => 'active',
        ]);

        // Send in-app notification to all active students/members of this library (or general members)
        $usersQuery = User::whereIn('role', ['user', 'member'])->where('status', 'active');
        $users = $usersQuery->take(50)->get(); // Broadcast to interested students

        foreach ($users as $user) {
            Notification::create([
                'user_id' => $user->id,
                'title' => 'Library Seat Available!',
                'message' => "Seat {$seat->seat_number} is now available! Book within 5 minutes.",
                'type' => 'smart_vacancy_alert',
                'badge' => 'New',
                'data' => [
                    'alert_id' => $alert->id,
                    'seat_id' => $seat->id,
                    'seat_number' => $seat->seat_number,
                    'library_id' => $seat->library_id,
                    'shift' => $shift,
                    'date' => $date,
                    'expires_at' => $expiresAt->toIso8601String(),
                    'booking_window_minutes' => 5,
                ],
            ]);
        }

        return $alert;
    }

    /**
     * Notify students on the waiting list when a seat becomes available.
     *
     * @return Collection<int, WaitingList>
     */
    public function notifyWaitingList(Seat $seat, string $shift = 'full_day', ?string $date = null): Collection
    {
        $date = $date ?? Carbon::today()->toDateString();

        $waitingEntries = WaitingList::with('user')
            ->where('status', 'waiting')
            ->where(function ($q) use ($seat) {
                if ($seat->library_id) {
                    $q->where('library_id', $seat->library_id);
                }
            })
            ->where(function ($q) use ($shift) {
                $q->where('shift', $shift)
                    ->orWhere('shift', 'any')
                    ->orWhere('shift', 'full_day');
            })
            ->whereDate('desired_date', $date)
            ->get();

        foreach ($waitingEntries as $entry) {
            $entry->status = 'notified';
            $entry->save();

            Notification::create([
                'user_id' => $entry->user_id,
                'title' => 'Vacant Seat Alert',
                'message' => "A seat ({$seat->seat_number}) matching your request is now available for {$shift} shift. Book immediately!",
                'type' => 'vacant_seat',
                'badge' => 'Waiting List',
                'data' => [
                    'waiting_list_id' => $entry->id,
                    'seat_id' => $seat->id,
                    'seat_number' => $seat->seat_number,
                    'library_id' => $seat->library_id,
                    'shift' => $shift,
                    'date' => $date,
                ],
            ]);
        }

        return $waitingEntries;
    }
}
