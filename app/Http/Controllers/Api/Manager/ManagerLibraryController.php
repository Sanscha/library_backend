<?php

namespace App\Http\Controllers\Api\Manager;

use App\Http\Controllers\Controller;
use App\Models\Facility;
use App\Models\Library;
use App\Models\Plan;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ManagerLibraryController extends Controller
{
    /**
     * Get manager's library full profile including photos, timings, facilities, and seat summary.
     */
    public function getProfile(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        // Ensure facilities are initialized
        $facilities = $library->facilities()->get();
        if ($facilities->isEmpty()) {
            $facilities = Facility::seedDefaultsForLibrary($library->id);
        }

        // Ensure membership pricing plans are initialized
        $plans = $library->plans()->orderBy('duration_days')->get();
        if ($plans->isEmpty()) {
            $plans = Plan::seedDefaultsForLibrary($library->id);
        }

        $seats = $library->seats;
        $seatStats = [
            'total_seats' => $seats->count(),
            'available_seats' => $seats->where('status', 'available')->count(),
            'occupied_seats' => $seats->where('status', 'occupied')->count(),
            'reserved_seats' => $seats->where('status', 'reserved')->count(),
            'maintenance_seats' => $seats->where('status', 'maintenance')->count(),
            'occupancy_percentage' => $seats->count() > 0
                ? round((($seats->whereIn('status', ['occupied', 'reserved'])->count()) / $seats->count()) * 100, 1)
                : 0,
        ];

        return response()->json([
            'success' => true,
            'library' => $library,
            'owner' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone,
                'email_verified' => $user->isEmailVerified(),
            ],
            'photos' => [
                'cover_image' => $library->image ? asset('storage/'.$library->image) : null,
                'cover_path' => $library->image,
                'gallery' => $library->gallery ?? [],
            ],
            'operating_hours' => $library->operating_hours ?? $this->getDefaultOperatingHours(),
            'facilities' => $facilities,
            'plans' => $plans,
            'seat_statistics' => $seatStats,
        ], 200);
    }

    /**
     * Update library listing details (Name, Address, Contact, Description, Amenities).
     */
    public function updateListing(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $fields = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'address' => 'sometimes|required|string',
            'city' => 'nullable|string|max:100',
            'state' => 'nullable|string|max:100',
            'pincode' => 'nullable|string|max:20',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'phone' => 'nullable|string|max:25',
            'email' => 'nullable|email|max:150',
            'description' => 'nullable|string',
            'amenities' => 'nullable',
        ]);

        if (isset($fields['name']) && $fields['name'] !== $library->name) {
            $library->name = $fields['name'];
        }

        if (isset($fields['address'])) {
            $library->address = $fields['address'];
        }
        if (array_key_exists('city', $fields)) {
            $library->city = $fields['city'];
        }
        if (array_key_exists('state', $fields)) {
            $library->state = $fields['state'];
        }
        if (array_key_exists('pincode', $fields)) {
            $library->pincode = $fields['pincode'];
        }
        if (array_key_exists('latitude', $fields)) {
            $library->latitude = $fields['latitude'];
        }
        if (array_key_exists('longitude', $fields)) {
            $library->longitude = $fields['longitude'];
        }
        if (array_key_exists('phone', $fields)) {
            $library->phone = $fields['phone'];
        }
        if (array_key_exists('email', $fields)) {
            $library->email = $fields['email'];
        }
        if (array_key_exists('description', $fields)) {
            $library->description = $fields['description'];
        }

        if (isset($fields['amenities'])) {
            $amenities = $fields['amenities'];
            if (is_string($amenities)) {
                $decoded = json_decode($amenities, true);
                if (is_array($decoded)) {
                    $amenities = $decoded;
                }
            }
            $library->amenities = $amenities;
        }

        $library->save();

        return response()->json([
            'success' => true,
            'message' => 'Library listing details updated successfully.',
            'library' => $library,
        ], 200);
    }

    /**
     * Upload & manage library listing photos (Cover Image and Gallery Photos).
     */
    public function uploadPhotos(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $request->validate([
            'cover_image' => 'nullable|file|image|max:10240', // 10MB max
            'cover_image_url' => 'nullable|string',
            'gallery_photos.*' => 'nullable|file|image|max:10240',
            'gallery_urls' => 'nullable|array',
            'gallery_urls.*' => 'string',
            'replace_gallery' => 'nullable|boolean',
        ]);

        // 1. Handle Cover Photo
        if ($request->hasFile('cover_image')) {
            $coverPath = $request->file('cover_image')->store('libraries', 'public');
            $library->image = $coverPath;
        } elseif ($request->filled('cover_image_url')) {
            $library->image = $request->input('cover_image_url');
        }

        // 2. Handle Gallery Photos
        $currentGallery = $library->gallery ?? [];
        if ($request->boolean('replace_gallery')) {
            $currentGallery = [];
        }

        // Add uploaded photo files
        if ($request->hasFile('gallery_photos')) {
            foreach ($request->file('gallery_photos') as $file) {
                $path = $file->store('libraries/gallery', 'public');
                $currentGallery[] = $path;
            }
        }

        // Add photo URLs if passed
        if ($request->filled('gallery_urls')) {
            foreach ($request->input('gallery_urls') as $url) {
                if (! in_array($url, $currentGallery, true)) {
                    $currentGallery[] = $url;
                }
            }
        }

        $library->gallery = array_values(array_unique($currentGallery));
        $library->save();

        return response()->json([
            'success' => true,
            'message' => 'Library photos updated successfully.',
            'photos' => [
                'cover_image' => $library->image,
                'gallery' => $library->gallery,
                'total_gallery_count' => count($library->gallery),
            ],
            'library' => $library,
        ], 200);
    }

    /**
     * Delete a photo from library gallery or remove cover image.
     */
    public function deletePhoto(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $fields = $request->validate([
            'photo_path' => 'nullable|string',
            'remove_cover' => 'nullable|boolean',
        ]);

        if ($request->boolean('remove_cover')) {
            if ($library->image && Storage::disk('public')->exists($library->image)) {
                Storage::disk('public')->delete($library->image);
            }
            $library->image = null;
        }

        if (! empty($fields['photo_path'])) {
            $target = $fields['photo_path'];
            $gallery = $library->gallery ?? [];

            $newGallery = array_filter($gallery, function ($item) use ($target) {
                return $item !== $target;
            });

            if (Storage::disk('public')->exists($target)) {
                Storage::disk('public')->delete($target);
            }

            $library->gallery = array_values($newGallery);
        }

        $library->save();

        return response()->json([
            'success' => true,
            'message' => 'Photo removed successfully.',
            'photos' => [
                'cover_image' => $library->image,
                'gallery' => $library->gallery ?? [],
            ],
        ], 200);
    }

    /**
     * Get library operating timings & shifts.
     */
    public function getTimings(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $timings = $library->operating_hours ?? $this->getDefaultOperatingHours();

        return response()->json([
            'success' => true,
            'library_name' => $library->name,
            'timings' => $timings,
        ], 200);
    }

    /**
     * Update library operating timings & shift hours.
     */
    public function updateTimings(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $fields = $request->validate([
            'opening_time' => 'required|string',
            'closing_time' => 'required|string',
            'days_open' => 'nullable', // array or string e.g. ["Mon", "Tue"...] or "Mon-Sun"
            'shifts' => 'nullable|array',
            'shifts.morning' => 'nullable|array',
            'shifts.morning.start' => 'nullable|string',
            'shifts.morning.end' => 'nullable|string',
            'shifts.evening' => 'nullable|array',
            'shifts.evening.start' => 'nullable|string',
            'shifts.evening.end' => 'nullable|string',
            'shifts.full_day' => 'nullable|array',
            'shifts.full_day.start' => 'nullable|string',
            'shifts.full_day.end' => 'nullable|string',
            'notes' => 'nullable|string|max:500',
        ]);

        $defaultTimings = $this->getDefaultOperatingHours();

        $operatingHours = [
            'opening_time' => $fields['opening_time'],
            'closing_time' => $fields['closing_time'],
            'days_open' => $fields['days_open'] ?? $defaultTimings['days_open'],
            'shifts' => [
                'morning' => [
                    'start' => $fields['shifts']['morning']['start'] ?? '07:00',
                    'end' => $fields['shifts']['morning']['end'] ?? '13:00',
                    'label' => 'Morning Shift',
                ],
                'evening' => [
                    'start' => $fields['shifts']['evening']['start'] ?? '13:00',
                    'end' => $fields['shifts']['evening']['end'] ?? '19:00',
                    'label' => 'Evening Shift',
                ],
                'full_day' => [
                    'start' => $fields['shifts']['full_day']['start'] ?? '07:00',
                    'end' => $fields['shifts']['full_day']['end'] ?? '22:00',
                    'label' => 'Full Day',
                ],
            ],
            'notes' => $fields['notes'] ?? ($library->operating_hours['notes'] ?? 'Open 7 days a week.'),
            'updated_at' => Carbon::now()->toIso8601String(),
        ];

        $library->operating_hours = $operatingHours;
        $library->save();

        return response()->json([
            'success' => true,
            'message' => 'Library timings updated successfully.',
            'operating_hours' => $operatingHours,
            'library' => $library,
        ], 200);
    }

    /**
     * Get list of facilities/suvidha available in manager's library.
     */
    public function getFacilities(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $facilities = $library->facilities()->orderBy('id')->get();
        if ($facilities->isEmpty()) {
            $facilities = Facility::seedDefaultsForLibrary($library->id);
        }

        $summary = [
            'total' => $facilities->count(),
            'available' => $facilities->where('status', 'available')->count(),
            'limited' => $facilities->where('status', 'limited')->count(),
            'maintenance' => $facilities->where('status', 'maintenance')->count(),
            'unavailable' => $facilities->where('status', 'unavailable')->count(),
        ];

        return response()->json([
            'success' => true,
            'library_name' => $library->name,
            'summary' => $summary,
            'facilities' => $facilities,
        ], 200);
    }

    /**
     * Add a custom facility to the manager's library.
     */
    public function storeFacility(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $fields = $request->validate([
            'name' => 'required|string|max:255',
            'category' => 'required|in:wifi,charging,locker,ac_cooler,water,washroom_gents,washroom_ladies,other',
            'status' => 'nullable|in:available,limited,unavailable,maintenance',
            'details' => 'nullable|string|max:255',
            'icon' => 'nullable|string|max:50',
        ]);

        $facility = Facility::create([
            'library_id' => $library->id,
            'name' => $fields['name'],
            'category' => $fields['category'],
            'status' => $fields['status'] ?? 'available',
            'details' => $fields['details'] ?? null,
            'icon' => $fields['icon'] ?? 'check-circle',
            'last_checked_at' => Carbon::now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => "Facility '{$facility->name}' added successfully.",
            'facility' => $facility,
        ], 201);
    }

    /**
     * Update facility status and details (Wi-Fi, AC, Charging, Lockers, Water, Washrooms).
     */
    public function updateFacility(Request $request, int|string $id): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $facility = $library->facilities()->findOrFail($id);

        $fields = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'status' => 'required|in:available,limited,unavailable,maintenance',
            'details' => 'nullable|string|max:255',
            'icon' => 'nullable|string|max:50',
        ]);

        if (isset($fields['name'])) {
            $facility->name = $fields['name'];
        }
        $facility->status = $fields['status'];
        if (array_key_exists('details', $fields)) {
            $facility->details = $fields['details'];
        }
        if (array_key_exists('icon', $fields)) {
            $facility->icon = $fields['icon'];
        }
        $facility->last_checked_at = Carbon::now();
        $facility->save();

        return response()->json([
            'success' => true,
            'message' => "Facility '{$facility->name}' updated to '{$facility->status}'.",
            'facility' => $facility,
        ], 200);
    }

    /**
     * Delete a facility from the manager's library.
     */
    public function destroyFacility(Request $request, int|string $id): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $facility = $library->facilities()->findOrFail($id);
        $name = $facility->name;
        $facility->delete();

        return response()->json([
            'success' => true,
            'message' => "Facility '{$name}' deleted successfully.",
        ], 200);
    }

    /**
     * Get live seat availability and detailed seat grid for manager's library.
     */
    public function getSeatAvailability(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $seats = $library->seats()
            ->with(['activeBooking.user:id,name,phone'])
            ->orderBy('seat_number')
            ->get();

        $stats = [
            'total' => $seats->count(),
            'available' => $seats->where('status', 'available')->count(),
            'occupied' => $seats->where('status', 'occupied')->count(),
            'reserved' => $seats->where('status', 'reserved')->count(),
            'maintenance' => $seats->where('status', 'maintenance')->count(),
            'occupancy_percentage' => $seats->count() > 0
                ? round((($seats->whereIn('status', ['occupied', 'reserved'])->count()) / $seats->count()) * 100, 1)
                : 0,
        ];

        $seatData = $seats->map(function ($seat) {
            return [
                'id' => $seat->id,
                'seat_number' => $seat->seat_number,
                'status' => $seat->status,
                'zone_id' => $seat->zone_id,
                'is_occupied' => in_array($seat->status, ['occupied', 'reserved'], true),
                'active_booking' => $seat->activeBooking ? [
                    'id' => $seat->activeBooking->id,
                    'user_name' => $seat->activeBooking->user?->name,
                    'shift' => $seat->activeBooking->shift,
                    'booking_date' => $seat->activeBooking->booking_date,
                    'expires_at' => $seat->activeBooking->expires_at,
                ] : null,
            ];
        });

        return response()->json([
            'success' => true,
            'library_name' => $library->name,
            'summary' => $stats,
            'seats' => $seatData,
        ], 200);
    }

    /**
     * Get all membership pricing plans for manager's library.
     */
    public function getPlans(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $plans = $library->plans()->orderBy('duration_days')->get();
        if ($plans->isEmpty()) {
            $plans = Plan::seedDefaultsForLibrary($library->id);
        }

        return response()->json([
            'success' => true,
            'library_id' => $library->id,
            'library_name' => $library->name,
            'total_plans' => $plans->count(),
            'plans' => $plans,
            'data' => $plans,
        ], 200);
    }

    /**
     * Create a new pricing / membership plan for manager's library.
     */
    public function storePlan(Request $request): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $fields = $request->validate([
            'name' => 'required|string|max:100',
            'price' => 'required|numeric|min:0',
            'duration_days' => 'required|integer|min:1|max:1000',
            'shift' => 'nullable|in:morning,evening,full_day,all',
            'description' => 'nullable|string|max:500',
        ]);

        $plan = Plan::create([
            'library_id' => $library->id,
            'name' => $fields['name'],
            'price' => (float) $fields['price'],
            'duration_days' => (int) $fields['duration_days'],
            'shift' => $fields['shift'] ?? 'all',
            'description' => $fields['description'] ?? null,
            'is_active' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => "Plan '{$plan->name}' created successfully.",
            'plan' => $plan,
            'data' => $plan,
        ], 201);
    }

    /**
     * Update an existing membership plan for manager's library.
     */
    public function updatePlan(Request $request, int|string $id): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $plan = $library->plans()->findOrFail($id);

        $fields = $request->validate([
            'name' => 'sometimes|required|string|max:100',
            'price' => 'sometimes|required|numeric|min:0',
            'duration_days' => 'sometimes|required|integer|min:1|max:1000',
            'shift' => 'nullable|in:morning,evening,full_day,all',
            'description' => 'nullable|string|max:500',
            'is_active' => 'nullable|boolean',
        ]);

        if (isset($fields['name'])) {
            $plan->name = $fields['name'];
        }
        if (isset($fields['price'])) {
            $plan->price = (float) $fields['price'];
        }
        if (isset($fields['duration_days'])) {
            $plan->duration_days = (int) $fields['duration_days'];
        }
        if (array_key_exists('shift', $fields)) {
            $plan->shift = $fields['shift'] ?? 'all';
        }
        if (array_key_exists('description', $fields)) {
            $plan->description = $fields['description'];
        }
        if (array_key_exists('is_active', $fields)) {
            $plan->is_active = (bool) $fields['is_active'];
        }

        $plan->save();

        return response()->json([
            'success' => true,
            'message' => "Plan '{$plan->name}' updated successfully.",
            'plan' => $plan,
            'data' => $plan,
        ], 200);
    }

    /**
     * Toggle a plan's active status.
     */
    public function togglePlan(Request $request, int|string $id): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $plan = $library->plans()->findOrFail($id);
        $plan->is_active = ! $plan->is_active;
        $plan->save();

        return response()->json([
            'success' => true,
            'message' => "Plan '{$plan->name}' is now ".($plan->is_active ? 'active' : 'disabled').'.',
            'plan' => $plan,
            'data' => $plan,
        ], 200);
    }

    /**
     * Delete a custom plan from manager's library.
     */
    public function destroyPlan(Request $request, int|string $id): JsonResponse
    {
        $user = $request->user();
        $library = $user->library;

        if (! $library) {
            return response()->json([
                'success' => false,
                'message' => 'No library linked to this manager account.',
            ], 404);
        }

        $plan = $library->plans()->findOrFail($id);
        $name = $plan->name;
        $plan->delete();

        return response()->json([
            'success' => true,
            'message' => "Plan '{$name}' deleted successfully.",
        ], 200);
    }

    /**
     * Standard default operating hours if not configured yet.
     *
     * @return array<string, mixed>
     */
    protected function getDefaultOperatingHours(): array
    {
        return [
            'opening_time' => '07:00',
            'closing_time' => '22:00',
            'days_open' => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
            'shifts' => [
                'morning' => ['start' => '07:00', 'end' => '13:00', 'label' => 'Morning Shift'],
                'evening' => ['start' => '13:00', 'end' => '19:00', 'label' => 'Evening Shift'],
                'full_day' => ['start' => '07:00', 'end' => '22:00', 'label' => 'Full Day'],
            ],
            'notes' => 'Open on all days including weekends and public holidays.',
        ];
    }
}
