<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Payment;
use App\Models\Plan;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class PaymentApiController extends Controller
{
    /**
     * Create UPI / QR Code Payment Intent for seat booking or membership plan.
     */
    public function createPaymentIntent(Request $request): JsonResponse
    {
        $fields = $request->validate([
            'amount' => 'required|numeric|min:1',
            'type' => 'required|in:seat_booking,membership_plan,library_registration',
            'plan_id' => 'nullable|exists:plans,id',
            'booking_id' => 'nullable|exists:bookings,id',
            'library_id' => 'nullable|exists:libraries,id',
            'payment_method' => 'nullable|in:upi,qr,online_razorpay,cash,card',
        ]);

        $user = $request->user();
        $amount = number_format((float) $fields['amount'], 2, '.', '');
        $txnId = 'TXN-UPI-'.strtoupper(Str::random(10));

        // Format UPI deep link & QR payload (UPI Standard protocol)
        $upiVpa = config('services.upi.vpa', 'library@okhdfcbank');
        $payeeName = urlencode(config('app.name', 'Library SeatSync'));
        $transactionNote = urlencode("Payment for {$fields['type']} - {$txnId}");
        $upiString = "upi://pay?pa={$upiVpa}&pn={$payeeName}&am={$amount}&cu=INR&tn={$transactionNote}&tr={$txnId}";

        $libraryId = $fields['library_id'] ?? null;
        if (! $libraryId && ! empty($fields['booking_id'])) {
            $booking = Booking::with('seat')->find($fields['booking_id']);
            $libraryId = $booking?->seat?->library_id;
        }
        if (! $libraryId && ! empty($fields['plan_id'])) {
            $plan = Plan::find($fields['plan_id']);
            $libraryId = $plan?->library_id;
        }

        $payment = Payment::create([
            'user_id' => $user->id,
            'booking_id' => $fields['booking_id'] ?? null,
            'plan_id' => $fields['plan_id'] ?? null,
            'library_id' => $libraryId,
            'amount' => $amount,
            'currency' => 'INR',
            'type' => $fields['type'],
            'payment_method' => $fields['payment_method'] ?? 'upi',
            'transaction_id' => $txnId,
            'status' => 'pending',
            'notes' => "Initiated online payment for {$fields['type']}",
        ]);

        return response()->json([
            'success' => true,
            'message' => 'UPI / QR Payment intent generated successfully.',
            'payment' => $payment,
            'upi' => [
                'vpa' => $upiVpa,
                'amount' => $amount,
                'currency' => 'INR',
                'transaction_id' => $txnId,
                'upi_intent_url' => $upiString,
                'qr_code_data' => $upiString,
            ],
        ], 201);
    }

    /**
     * Verify / confirm payment receipt.
     */
    public function verifyPayment(Request $request): JsonResponse
    {
        $fields = $request->validate([
            'transaction_id' => 'required|string|exists:payments,transaction_id',
            'gateway_reference' => 'nullable|string',
            'status' => 'nullable|in:completed,failed',
        ]);

        $payment = Payment::where('transaction_id', $fields['transaction_id'])->firstOrFail();
        $status = $fields['status'] ?? 'completed';

        $payment->status = $status;
        if (! empty($fields['gateway_reference'])) {
            $payment->notes = ($payment->notes ? $payment->notes.' | ' : '').'Ref: '.$fields['gateway_reference'];
        }
        $payment->save();

        return response()->json([
            'success' => true,
            'message' => "Payment marked as {$status}.",
            'payment' => $payment,
        ], 200);
    }

    /**
     * Get authenticated student's payment history.
     */
    public function myPayments(Request $request): JsonResponse
    {
        $payments = Payment::with(['plan', 'booking.seat.zone', 'library'])
            ->where('user_id', $request->user()->id)
            ->latest()
            ->paginate(15);

        return response()->json([
            'success' => true,
            'message' => 'Payment history retrieved successfully.',
            'data' => $payments->items(),
            'pagination' => [
                'current_page' => $payments->currentPage(),
                'last_page' => $payments->lastPage(),
                'total' => $payments->total(),
            ],
        ], 200);
    }
}
