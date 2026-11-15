<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Library;
use App\Models\Notice;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NoticeController extends Controller
{
    /**
     * Get active Library Notices / Announcements.
     */
    public function notices(Request $request): JsonResponse
    {
        $libraryId = $request->query('library_id');

        $query = Notice::where('is_active', true)
            ->whereIn('type', ['notice', 'announcement', 'timing'])
            ->orderBy('priority', 'desc')
            ->latest();

        if ($libraryId) {
            $query->where(function ($q) use ($libraryId) {
                $q->where('library_id', $libraryId)->orWhereNull('library_id');
            });
        }

        $notices = $query->get();

        if ($notices->isEmpty()) {
            $this->seedDefaultRulesAndNotices($libraryId);
            $notices = $query->get();
        }

        return response()->json([
            'success' => true,
            'message' => 'Library notices retrieved successfully.',
            'data' => $notices,
        ], 200);
    }

    /**
     * Get Study Room Rules (Silence, Mobile phone policy, Desk hygiene, etc.).
     */
    public function rules(Request $request): JsonResponse
    {
        $libraryId = $request->query('library_id');

        $query = Notice::where('is_active', true)
            ->where('type', 'rule')
            ->orderBy('id');

        if ($libraryId) {
            $query->where(function ($q) use ($libraryId) {
                $q->where('library_id', $libraryId)->orWhereNull('library_id');
            });
        }

        $rules = $query->get();

        if ($rules->isEmpty()) {
            $this->seedDefaultRulesAndNotices($libraryId);
            $rules = $query->get();
        }

        return response()->json([
            'success' => true,
            'message' => 'Study room rules retrieved successfully.',
            'data' => $rules,
        ], 200);
    }

    /**
     * Staff/Admin: Create a new notice or rule.
     */
    public function store(Request $request): JsonResponse
    {
        $fields = $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'type' => 'required|in:rule,notice,announcement,timing',
            'priority' => 'nullable|in:normal,important,urgent',
            'library_id' => 'nullable|exists:libraries,id',
        ]);

        $notice = Notice::create([
            'title' => $fields['title'],
            'content' => $fields['content'],
            'type' => $fields['type'],
            'priority' => $fields['priority'] ?? 'normal',
            'library_id' => $fields['library_id'] ?? null,
            'is_active' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Notice / Rule published successfully.',
            'notice' => $notice,
        ], 201);
    }

    /**
     * Staff/Admin: Delete a notice.
     */
    public function destroy(int|string $id): JsonResponse
    {
        $notice = Notice::findOrFail($id);
        $notice->delete();

        return response()->json([
            'success' => true,
            'message' => 'Notice deleted successfully.',
        ], 200);
    }

    /**
     * Seed initial standard rules and notices if empty.
     */
    protected function seedDefaultRulesAndNotices(?int $libraryId): void
    {
        $rules = [
            ['title' => 'Strict Silence in Study Halls', 'content' => 'Pin-drop silence must be maintained in the reading area at all times. Group discussions are prohibited.', 'type' => 'rule', 'priority' => 'important'],
            ['title' => 'Mobile Phones on Silent Mode', 'content' => 'Keep your mobile phones on silent or flight mode. Attending phone calls inside the study room is strictly not allowed.', 'type' => 'rule', 'priority' => 'important'],
            ['title' => 'Clean Desk Policy', 'content' => 'Please keep your study table clean and throw trash in the designated waste bins before leaving.', 'type' => 'rule', 'priority' => 'normal'],
            ['title' => 'No Food or Drinks inside Reading Halls', 'content' => 'Only covered water bottles are permitted. Snacks and meals should only be consumed in the cafeteria / pantry.', 'type' => 'rule', 'priority' => 'normal'],
            ['title' => 'Personal Belongings Responsibility', 'content' => 'Do not leave laptops, tablets, or valuables unattended. Use assigned lockers for storage.', 'type' => 'rule', 'priority' => 'normal'],
            ['title' => 'Library Operating Timings', 'content' => 'Morning Shift: 8:00 AM - 2:00 PM | Evening Shift: 2:00 PM - 8:00 PM | Full Day: 8:00 AM - 10:00 PM.', 'type' => 'timing', 'priority' => 'important'],
            ['title' => 'High-Speed 5G Wi-Fi Upgraded', 'content' => 'Our campus Wi-Fi network has been upgraded with fiber 150 Mbps connection. Connect to "Library-5G" with your student login.', 'type' => 'notice', 'priority' => 'normal'],
        ];

        foreach ($rules as $r) {
            Notice::create(array_merge($r, [
                'library_id' => $libraryId,
                'is_active' => true,
            ]));
        }
    }
}
