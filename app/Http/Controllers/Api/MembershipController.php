<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Models\Plan;
use App\Models\Subscription;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MembershipController extends Controller
{
    /**
     * List active membership plans (optionally scoped to a specific library).
     */
    public function index(Request $request, int|string|null $id = null): JsonResponse
    {
        $targetLibId = $id ?? $request->route('id') ?? $request->route('libraryId') ?? $request->query('library_id');

        if ($targetLibId) {
            $libraryPlans = Plan::where('library_id', $targetLibId)
                ->where('is_active', true)
                ->orderBy('duration_days')
                ->get();

            if ($libraryPlans->isNotEmpty()) {
                return response()->json([
                    'success' => true,
                    'library_id' => (int) $targetLibId,
                    'message' => 'Library membership plans retrieved successfully.',
                    'data' => $libraryPlans,
                ], 200);
            }

            // Seed defaults for this library if none exist yet
            $libraryPlans = Plan::seedDefaultsForLibrary((int) $targetLibId);

            return response()->json([
                'success' => true,
                'library_id' => (int) $targetLibId,
                'message' => 'Library membership plans retrieved successfully.',
                'data' => $libraryPlans,
            ], 200);
        }

        $plans = Plan::where('is_active', true)
            ->whereNull('library_id')
            ->orderBy('duration_days')
            ->get();

        if ($plans->isEmpty()) {
            $plans = Plan::where('is_active', true)->orderBy('duration_days')->get();
        }

        return response()->json([
            'success' => true,
            'message' => 'Membership plans retrieved successfully.',
            'data' => $plans,
        ], 200);
    }

    /**
     * Student subscribes to a membership plan (with auto expiry calculation).
     */
    public function subscribe(Request $request): JsonResponse
    {
        $fields = $request->validate([
            'plan_id' => 'required|exists:plans,id',
            'library_id' => 'nullable|exists:libraries,id',
            'seat_id' => 'nullable|exists:seats,id',
            'start_date' => 'nullable|date_format:Y-m-d',
            'payment_method' => 'nullable|in:upi,qr,online_razorpay,cash,card',
            'auto_renew' => 'nullable|boolean',
        ]);

        $user = $request->user();
        $plan = Plan::findOrFail($fields['plan_id']);

        $startDate = ! empty($fields['start_date']) ? Carbon::parse($fields['start_date']) : Carbon::today();
        // Calculate expiry date based on plan duration (e.g. 30, 90, 180, 365 days)
        $endDate = $startDate->copy()->addDays($plan->duration_days);

        // Deactivate previous active subscription if user upgrades/renews
        Subscription::where('user_id', $user->id)
            ->where('status', 'active')
            ->update(['status' => 'expired']);

        $targetLibraryId = $fields['library_id'] ?? $plan->library_id;

        $subscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'library_id' => $targetLibraryId,
            'seat_id' => $fields['seat_id'] ?? null,
            'start_date' => $startDate->toDateString(),
            'end_date' => $endDate->toDateString(),
            'status' => 'active',
            'auto_renew' => $request->boolean('auto_renew', false),
        ]);

        // Generate payment transaction record
        $paymentMethod = $fields['payment_method'] ?? 'upi';
        $payment = Payment::create([
            'user_id' => $user->id,
            'library_id' => $targetLibraryId,
            'plan_id' => $plan->id,
            'amount' => $plan->price,
            'currency' => 'INR',
            'type' => 'membership_plan',
            'payment_method' => $paymentMethod,
            'transaction_id' => Payment::generateTransactionId('SUB'),
            'status' => 'completed',
            'notes' => "Subscribed to {$plan->name} ({$plan->duration_days} days)",
        ]);

        return response()->json([
            'success' => true,
            'message' => "Successfully subscribed to {$plan->name}! Valid until {$endDate->toDateString()}.",
            'subscription' => $subscription->load(['plan', 'library', 'seat']),
            'payment' => $payment,
            'days_remaining' => $subscription->daysRemaining(),
        ], 201);
    }

    /**
     * View student's current active membership subscription & expiry date.
     */
    public function mySubscription(Request $request): JsonResponse
    {
        $user = $request->user();

        $activeSub = Subscription::with(['plan', 'library', 'seat.zone'])
            ->where('user_id', $user->id)
            ->where('status', 'active')
            ->where('end_date', '>=', Carbon::today()->toDateString())
            ->latest('end_date')
            ->first();

        if (! $activeSub) {
            return response()->json([
                'success' => true,
                'has_active_subscription' => false,
                'message' => 'No active membership plan found. Browse our membership plans to subscribe.',
                'subscription' => null,
            ], 200);
        }

        return response()->json([
            'success' => true,
            'has_active_subscription' => true,
            'subscription' => $activeSub,
            'days_remaining' => $activeSub->daysRemaining(),
            'expiry_date' => $activeSub->end_date->toDateString(),
            'is_expiring_soon' => $activeSub->daysRemaining() <= 7,
        ], 200);
    }
}
