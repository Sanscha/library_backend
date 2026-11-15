<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Complaint;
use App\Models\Notification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ComplaintController extends Controller
{
    /**
     * Student submits a Complaint or Feedback.
     */
    public function store(Request $request): JsonResponse
    {
        $fields = $request->validate([
            'category' => 'required|in:cleanliness,noise,ac_cooler,wifi,charging_point,water,washroom,seat_issue,other',
            'subject' => 'required|string|max:255',
            'description' => 'required|string',
            'library_id' => 'nullable|exists:libraries,id',
            'seat_id' => 'nullable|exists:seats,id',
        ]);

        $user = $request->user();

        $complaint = Complaint::create([
            'user_id' => $user->id,
            'library_id' => $fields['library_id'] ?? null,
            'seat_id' => $fields['seat_id'] ?? null,
            'category' => $fields['category'],
            'subject' => $fields['subject'],
            'description' => $fields['description'],
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Your complaint/feedback has been submitted successfully. Our library team will attend to it shortly.',
            'complaint' => $complaint->load(['seat', 'library']),
        ], 201);
    }

    /**
     * View student's submitted complaints.
     */
    public function myComplaints(Request $request): JsonResponse
    {
        $complaints = Complaint::with(['seat', 'library'])
            ->where('user_id', $request->user()->id)
            ->latest()
            ->paginate(15);

        return response()->json([
            'success' => true,
            'data' => $complaints->items(),
            'pagination' => [
                'current_page' => $complaints->currentPage(),
                'last_page' => $complaints->lastPage(),
                'total' => $complaints->total(),
            ],
        ], 200);
    }

    /**
     * Staff/Admin: List all complaints with filtering.
     */
    public function adminIndex(Request $request): JsonResponse
    {
        $query = Complaint::with(['user:id,name,email,phone', 'seat.zone', 'library'])->latest();

        if ($status = $request->input('status')) {
            $query->where('status', $status);
        }

        if ($category = $request->input('category')) {
            $query->where('category', $category);
        }

        $complaints = $query->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $complaints->items(),
            'pagination' => [
                'current_page' => $complaints->currentPage(),
                'last_page' => $complaints->lastPage(),
                'total' => $complaints->total(),
            ],
        ], 200);
    }

    /**
     * Staff/Admin: Resolve / update complaint status with admin reply.
     */
    public function adminResolve(Request $request, int|string $id): JsonResponse
    {
        $fields = $request->validate([
            'status' => 'required|in:pending,in_progress,resolved,closed',
            'admin_remark' => 'nullable|string',
        ]);

        $complaint = Complaint::with('user')->findOrFail($id);
        $complaint->status = $fields['status'];
        if (isset($fields['admin_remark'])) {
            $complaint->admin_remark = $fields['admin_remark'];
        }
        $complaint->save();

        // Notify student of resolution
        if ($complaint->user_id) {
            Notification::create([
                'user_id' => $complaint->user_id,
                'title' => "Complaint Status Updated: {$complaint->status}",
                'message' => "Your complaint '{$complaint->subject}' is now marked as {$complaint->status}.".($complaint->admin_remark ? " Remark: {$complaint->admin_remark}" : ''),
                'type' => 'general',
                'badge' => ucfirst($complaint->status),
                'data' => ['complaint_id' => $complaint->id],
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => "Complaint status updated to {$complaint->status}.",
            'complaint' => $complaint,
        ], 200);
    }
}
