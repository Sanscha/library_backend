<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Models\Booking;
use App\Models\Complaint;
use App\Models\Facility;
use App\Models\Library;
use App\Models\Payment;
use App\Models\Seat;
use App\Models\Setting;
use App\Models\Subscription;
use App\Models\User;
use App\Models\WaitingList;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AdminApiController extends Controller
{
    /**
     * List all users (students / members) for Admin.
     */
    public function getUsers(Request $request): JsonResponse
    {
        $query = User::whereIn('role', ['user', 'member'])->withCount(['bookings', 'payments'])->latest();

        if ($search = $request->input('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        if ($status = $request->input('status')) {
            $query->where('status', $status);
        }

        $users = $query->paginate(20)->withQueryString();

        return response()->json([
            'success' => true,
            'total' => $users->total(),
            'data' => $users->items(),
            'pagination' => [
                'current_page' => $users->currentPage(),
                'last_page' => $users->lastPage(),
            ],
        ], 200);
    }

    /**
     * List all registered libraries and their owners for Admin.
     */
    public function getLibraries(Request $request): JsonResponse
    {
        $query = Library::with(['owner:id,name,email,phone,status,created_at'])
            ->withCount([
                'seats as total_seats_count',
                'seats as available_seats_count' => function ($q) {
                    $q->where('status', 'available');
                },
                'seats as occupied_seats_count' => function ($q) {
                    $q->where('status', 'occupied');
                },
            ])
            ->latest();

        if ($search = $request->input('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('address', 'like', "%{$search}%")
                    ->orWhere('city', 'like', "%{$search}%")
                    ->orWhereHas('owner', function ($oq) use ($search) {
                        $oq->where('name', 'like', "%{$search}%")
                            ->orWhere('email', 'like', "%{$search}%")
                            ->orWhere('phone', 'like', "%{$search}%");
                    });
            });
        }

        if ($paymentStatus = $request->input('payment_status')) {
            $query->where('payment_status', $paymentStatus);
        }

        if ($status = $request->input('status')) {
            $query->where('status', $status);
        }

        $libraries = $query->paginate(20)->withQueryString();

        return response()->json([
            'success' => true,
            'total' => $libraries->total(),
            'data' => $libraries->items(),
            'pagination' => [
                'current_page' => $libraries->currentPage(),
                'last_page' => $libraries->lastPage(),
            ],
        ], 200);
    }

    /**
     * Enter or update one-time onboarding fee for a library.
     */
    public function updateLibraryFee(Request $request, int|string $id): JsonResponse
    {
        $fields = $request->validate([
            'registration_fee' => 'required|numeric|min:0',
        ]);

        $library = Library::findOrFail($id);
        $library->registration_fee = (float) $fields['registration_fee'];
        $library->save();

        return response()->json([
            'success' => true,
            'message' => "One-time registration fee for '{$library->name}' updated to ₹".number_format($library->registration_fee, 2).'.',
            'library' => $library,
        ], 200);
    }

    /**
     * Inspect full library details, photos, timings, facilities/suvidha, and seat availability.
     */
    public function getLibrary(int|string $id): JsonResponse
    {
        $library = Library::with(['owner:id,name,email,phone,status,created_at,email_verified_at'])
            ->findOrFail($id);

        // Facilities (seed defaults if not seeded yet)
        $facilities = $library->facilities()->orderBy('id')->get();
        if ($facilities->isEmpty()) {
            $facilities = Facility::seedDefaultsForLibrary($library->id);
        }

        // Seats & Availability breakdown
        $seats = $library->seats()->with(['activeBooking.user:id,name,phone,email'])->orderBy('seat_number')->get();
        $seatsSummary = [
            'total' => $seats->count(),
            'available' => $seats->where('status', 'available')->count(),
            'occupied' => $seats->where('status', 'occupied')->count(),
            'reserved' => $seats->where('status', 'reserved')->count(),
            'maintenance' => $seats->where('status', 'maintenance')->count(),
            'occupancy_percentage' => $seats->count() > 0
                ? round((($seats->whereIn('status', ['occupied', 'reserved'])->count()) / $seats->count()) * 100, 1)
                : 0,
        ];

        return response()->json([
            'success' => true,
            'library' => $library,
            'owner' => $library->owner,
            'photos' => [
                'cover_image' => $library->image ? asset('storage/'.$library->image) : null,
                'cover_path' => $library->image,
                'gallery' => $library->gallery ?? [],
                'gallery_count' => count($library->gallery ?? []),
            ],
            'operating_hours' => $library->operating_hours ?? [
                'opening_time' => '07:00',
                'closing_time' => '22:00',
                'days_open' => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                'shifts' => [
                    'morning' => ['start' => '07:00', 'end' => '13:00', 'label' => 'Morning Shift'],
                    'evening' => ['start' => '13:00', 'end' => '19:00', 'label' => 'Evening Shift'],
                    'full_day' => ['start' => '07:00', 'end' => '22:00', 'label' => 'Full Day'],
                ],
                'notes' => 'Open on all days.',
            ],
            'facilities' => [
                'summary' => [
                    'total' => $facilities->count(),
                    'available' => $facilities->where('status', 'available')->count(),
                    'limited' => $facilities->where('status', 'limited')->count(),
                    'maintenance' => $facilities->where('status', 'maintenance')->count(),
                    'unavailable' => $facilities->where('status', 'unavailable')->count(),
                ],
                'data' => $facilities,
            ],
            'seats' => [
                'summary' => $seatsSummary,
                'data' => $seats->map(function ($seat) {
                    return [
                        'id' => $seat->id,
                        'seat_number' => $seat->seat_number,
                        'status' => $seat->status,
                        'is_available' => $seat->status === 'available',
                        'active_booking' => $seat->activeBooking ? [
                            'id' => $seat->activeBooking->id,
                            'user_name' => $seat->activeBooking->user?->name,
                            'user_phone' => $seat->activeBooking->user?->phone,
                            'shift' => $seat->activeBooking->shift,
                            'expires_at' => $seat->activeBooking->expires_at,
                        ] : null,
                    ];
                }),
            ],
        ], 200);
    }

    /**
     * View seats and availability across all libraries for Admin.
     */
    public function getSeatsOverview(Request $request): JsonResponse
    {
        $libraryId = $request->input('library_id');

        $seatQuery = Seat::with(['library:id,name', 'zone:id,name', 'activeBooking.user:id,name,email,phone']);

        if ($libraryId) {
            $seatQuery->where('library_id', $libraryId);
        }

        if ($status = $request->input('status')) {
            $seatQuery->where('status', $status);
        }

        $seats = $seatQuery->paginate(30)->withQueryString();

        $allSeats = Seat::query();
        if ($libraryId) {
            $allSeats->where('library_id', $libraryId);
        }

        $summary = [
            'total' => (clone $allSeats)->count(),
            'available' => (clone $allSeats)->where('status', 'available')->count(),
            'occupied' => (clone $allSeats)->where('status', 'occupied')->count(),
            'reserved' => (clone $allSeats)->where('status', 'reserved')->count(),
            'maintenance' => (clone $allSeats)->where('status', 'maintenance')->count(),
        ];

        $items = collect($seats->items())->map(function ($seat) {
            $data = $seat->toArray();
            $data['expiry_date'] = $seat->activeBooking ? ($seat->activeBooking->expires_at ?? $seat->activeBooking->booking_date) : null;
            $data['booked_by'] = $seat->activeBooking?->user?->name;

            return $data;
        });

        return response()->json([
            'success' => true,
            'summary' => $summary,
            'data' => $items,
            'pagination' => [
                'current_page' => $seats->currentPage(),
                'last_page' => $seats->lastPage(),
                'total' => $seats->total(),
            ],
        ], 200);
    }

    /**
     * Comprehensive Admin Dashboard Key Metrics.
     */
    public function getDashboardMetrics(): JsonResponse
    {
        $today = date('Y-m-d');

        $metrics = [
            'total_members' => User::whereIn('role', ['user', 'member'])->count(),
            'total_seats' => Seat::count(),
            'available_seats' => Seat::where('status', 'available')->count(),
            'occupied_seats' => Seat::where('status', 'occupied')->count(),
            'reserved_seats' => Seat::where('status', 'reserved')->count(),
            'maintenance_seats' => Seat::where('status', 'maintenance')->count(),
            'today_bookings' => Booking::where('booking_date', $today)->where('status', 'active')->count(),
            'active_subscriptions' => Subscription::where('status', 'active')->where('end_date', '>=', $today)->count(),
            'pending_complaints' => Complaint::where('status', 'pending')->count(),
            'waiting_list_count' => WaitingList::where('status', 'waiting')->count(),
            'today_checkins' => Attendance::where('date', $today)->count(),
            'today_revenue' => (float) Payment::whereDate('created_at', $today)->where('status', 'completed')->sum('amount'),
            'total_revenue' => (float) Payment::where('status', 'completed')->sum('amount'),
        ];

        return response()->json([
            'success' => true,
            'metrics' => $metrics,
        ], 200);
    }

    /**
     * View all payments for Admin (Library registration fees via QR/Razorpay & student bookings).
     */
    public function getPayments(Request $request): JsonResponse
    {
        $query = Payment::with(['user:id,name,email,phone', 'library:id,name', 'plan:id,name', 'booking.seat'])
            ->latest();

        if ($libraryId = $request->input('library_id')) {
            $query->where('library_id', $libraryId);
        }

        if ($type = $request->input('type')) {
            $query->where('type', $type);
        }

        if ($method = $request->input('payment_method')) {
            $query->where('payment_method', $method);
        }

        if ($status = $request->input('status')) {
            $query->where('status', $status);
        }

        $payments = $query->paginate(20)->withQueryString();

        // Calculate metrics (scoped to library if requested)
        $metricsQuery = Payment::where('status', 'completed');
        if ($libraryId = $request->input('library_id')) {
            $metricsQuery->where('library_id', $libraryId);
        }

        $metrics = [
            'total_revenue' => (float) (clone $metricsQuery)->sum('amount'),
            'library_registration_fees' => (float) (clone $metricsQuery)->where('type', 'library_registration')->sum('amount'),
            'seat_booking_fees' => (float) (clone $metricsQuery)->where('type', 'seat_booking')->sum('amount'),
            'membership_plan_fees' => (float) (clone $metricsQuery)->where('type', 'membership_plan')->sum('amount'),
            'upi_total' => (float) (clone $metricsQuery)->where('payment_method', 'upi')->sum('amount'),
            'razorpay_total' => (float) (clone $metricsQuery)->where('payment_method', 'online_razorpay')->sum('amount'),
            'cash_total' => (float) (clone $metricsQuery)->where('payment_method', 'cash')->sum('amount'),
        ];

        return response()->json([
            'success' => true,
            'metrics' => $metrics,
            'data' => $payments->items(),
            'pagination' => [
                'current_page' => $payments->currentPage(),
                'last_page' => $payments->lastPage(),
                'total' => $payments->total(),
            ],
        ], 200);
    }

    /**
     * Get platform settings via API.
     */
    public function getSettings(): JsonResponse
    {
        $settings = Setting::getAll();

        return response()->json([
            'success' => true,
            'settings' => $settings,
        ], 200);
    }

    /**
     * Update platform settings (e.g. library registration fee) via API.
     */
    public function updateSettings(Request $request): JsonResponse
    {
        $fields = $request->validate([
            'library_registration_fee' => 'required|numeric|min:0',
            'platform_name' => 'nullable|string|max:100',
            'support_email' => 'nullable|email|max:150',
            'support_phone' => 'nullable|string|max:30',
        ]);

        Setting::set('library_registration_fee', (string) $fields['library_registration_fee'], 'pricing', 'One-time onboarding fee for library owners');

        if (array_key_exists('platform_name', $fields)) {
            Setting::set('platform_name', $fields['platform_name'] ?? 'SeatSync', 'general', 'Platform Name');
        }
        if (array_key_exists('support_email', $fields)) {
            Setting::set('support_email', $fields['support_email'] ?? '', 'general', 'Support Email');
        }
        if (array_key_exists('support_phone', $fields)) {
            Setting::set('support_phone', $fields['support_phone'] ?? '', 'general', 'Support Phone');
        }

        return response()->json([
            'success' => true,
            'message' => 'Settings updated successfully.',
            'settings' => Setting::getAll(),
        ], 200);
    }
}
