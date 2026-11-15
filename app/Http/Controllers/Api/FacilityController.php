<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Facility;
use App\Models\Library;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FacilityController extends Controller
{
    /**
     * Get real-time Facility Availability for a library.
     */
    public function index(Request $request, ?int $libraryId = null): JsonResponse
    {
        $targetLibraryId = $libraryId ?? $request->query('library_id');

        if (! $targetLibraryId) {
            $targetLibraryId = Library::where('status', 'active')->value('id');
        }

        $facilities = Facility::where('library_id', $targetLibraryId)
            ->orderBy('id')
            ->get();

        // If no facilities seeded yet for this library, return auto-generated standard list
        if ($facilities->isEmpty()) {
            $facilities = $this->getDefaultFacilities($targetLibraryId);
        }

        $summary = [
            'total' => $facilities->count(),
            'available' => $facilities->where('status', 'available')->count(),
            'limited' => $facilities->where('status', 'limited')->count(),
            'maintenance' => $facilities->where('status', 'maintenance')->count(),
        ];

        return response()->json([
            'success' => true,
            'library_id' => $targetLibraryId,
            'summary' => $summary,
            'data' => $facilities,
        ], 200);
    }

    /**
     * Staff / Admin Action: Update status and real-time details of a facility.
     */
    public function updateStatus(Request $request, int|string $id): JsonResponse
    {
        $fields = $request->validate([
            'status' => 'required|in:available,limited,unavailable,maintenance',
            'details' => 'nullable|string|max:255',
        ]);

        $facility = Facility::findOrFail($id);
        $facility->status = $fields['status'];
        if (isset($fields['details'])) {
            $facility->details = $fields['details'];
        }
        $facility->last_checked_at = Carbon::now();
        $facility->save();

        return response()->json([
            'success' => true,
            'message' => "Facility '{$facility->name}' status updated to {$facility->status}.",
            'facility' => $facility,
        ], 200);
    }

    /**
     * Return standard default facilities structure if none exist in DB yet.
     *
     * @return Collection<int, Facility>
     */
    protected function getDefaultFacilities(?int $libraryId): Collection
    {
        $defaults = [
            ['name' => 'High-Speed Wi-Fi', 'category' => 'wifi', 'status' => 'available', 'details' => '150 Mbps Fiber (5GHz & 2.4GHz)', 'icon' => 'wifi'],
            ['name' => 'Charging Points', 'category' => 'charging', 'status' => 'available', 'details' => 'Individual universal socket at every desk', 'icon' => 'zap'],
            ['name' => 'Personal Lockers', 'category' => 'locker', 'status' => 'available', 'details' => '16 of 24 Lockers Available', 'icon' => 'lock'],
            ['name' => 'AC & Air Cooling', 'category' => 'ac_cooler', 'status' => 'available', 'details' => 'Central AC operational (22°C maintained)', 'icon' => 'wind'],
            ['name' => 'Drinking Water / Aqua', 'category' => 'water', 'status' => 'available', 'details' => 'RO Purified Cold & Normal Water', 'icon' => 'droplet'],
            ['name' => 'Washroom (Gents)', 'category' => 'washroom_gents', 'status' => 'available', 'details' => 'Clean & Sanitized (Checked 30m ago)', 'icon' => 'user'],
            ['name' => 'Washroom (Ladies)', 'category' => 'washroom_ladies', 'status' => 'available', 'details' => 'Clean & Sanitized (Checked 30m ago)', 'icon' => 'user-check'],
        ];

        foreach ($defaults as $item) {
            Facility::create(array_merge($item, [
                'library_id' => $libraryId,
                'last_checked_at' => Carbon::now(),
            ]));
        }

        return Facility::where('library_id', $libraryId)->get();
    }
}
