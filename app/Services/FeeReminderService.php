<?php

namespace App\Services;

use App\Models\Notification;
use App\Models\Payment;
use App\Models\Subscription;
use Carbon\Carbon;

class FeeReminderService
{
    /**
     * Scan active subscriptions and send reminders 7, 3, and 1 day(s) before expiry.
     * Also scan pending payments and send pending fee reminders.
     *
     * @return array{expiry_reminders_sent: int, pending_payment_reminders_sent: int}
     */
    public function sendReminders(): array
    {
        $today = Carbon::today();
        $expiryCount = 0;
        $pendingPaymentCount = 0;

        // 1. Process Subscription Expiries (7, 3, 1 days)
        $targetIntervals = [7, 3, 1];

        foreach ($targetIntervals as $days) {
            $targetDate = $today->copy()->addDays($days)->toDateString();

            $subscriptions = Subscription::with(['user', 'plan', 'library'])
                ->where('status', 'active')
                ->whereDate('end_date', $targetDate)
                ->get();

            foreach ($subscriptions as $subscription) {
                if (! $subscription->user) {
                    continue;
                }

                // Prevent duplicate reminder on same day for same interval
                $alreadySent = Notification::where('user_id', $subscription->user_id)
                    ->where('type', 'fee_reminder')
                    ->whereDate('created_at', $today->toDateString())
                    ->whereJsonContains('data->days_remaining', $days)
                    ->exists();

                if ($alreadySent) {
                    continue;
                }

                $badge = ($days === 1) ? 'Urgent' : 'Reminder';
                $planName = $subscription->plan->name ?? 'Membership';
                $msg = match ($days) {
                    1 => "Urgent: Your {$planName} subscription expires tomorrow! Renew today to retain your reserved seat.",
                    3 => "Reminder: Only 3 days left before your {$planName} subscription expires.",
                    7 => "Advance Notice: Your {$planName} subscription will expire in 7 days. Plan your renewal ahead.",
                    default => "Your subscription expires in {$days} days.",
                };

                Notification::create([
                    'user_id' => $subscription->user_id,
                    'title' => ($days === 1) ? 'Urgent: Subscription Expiring Tomorrow' : "Fee Reminder: {$days} Days Left",
                    'message' => $msg,
                    'type' => 'fee_reminder',
                    'badge' => $badge,
                    'data' => [
                        'subscription_id' => $subscription->id,
                        'days_remaining' => $days,
                        'end_date' => $subscription->end_date->toDateString(),
                        'plan_id' => $subscription->plan_id,
                        'plan_name' => $planName,
                    ],
                ]);

                $expiryCount++;
            }
        }

        // 2. Process Pending Payment Reminders
        $pendingPayments = Payment::with('user')
            ->where('status', 'pending')
            ->where('created_at', '<=', Carbon::now()->subHours(2)) // at least 2 hours pending
            ->get();

        foreach ($pendingPayments as $payment) {
            if (! $payment->user) {
                continue;
            }

            // Only 1 pending reminder per day
            $alreadyReminded = Notification::where('user_id', $payment->user_id)
                ->where('type', 'pending_payment')
                ->whereDate('created_at', $today->toDateString())
                ->exists();

            if ($alreadyReminded) {
                continue;
            }

            Notification::create([
                'user_id' => $payment->user_id,
                'title' => 'Pending Payment Reminder',
                'message' => "You have a pending payment of ₹{$payment->amount}. Please complete the transaction to activate your pass.",
                'type' => 'pending_payment',
                'badge' => 'Payment Due',
                'data' => [
                    'payment_id' => $payment->id,
                    'amount' => $payment->amount,
                    'currency' => $payment->currency,
                    'transaction_id' => $payment->transaction_id,
                ],
            ]);

            $pendingPaymentCount++;
        }

        return [
            'expiry_reminders_sent' => $expiryCount,
            'pending_payment_reminders_sent' => $pendingPaymentCount,
        ];
    }
}
