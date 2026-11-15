<?php

use App\Http\Controllers\Api\Admin\AdminApiController;
use App\Http\Controllers\Api\AttendanceController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\ComplaintController;
use App\Http\Controllers\Api\FacilityController;
use App\Http\Controllers\Api\Manager\ManagerAuthController;
use App\Http\Controllers\Api\Manager\ManagerLibraryController;
use App\Http\Controllers\Api\Manager\ManagerPaymentController;
use App\Http\Controllers\Api\Manager\ManagerSeatController;
use App\Http\Controllers\Api\MembershipController;
use App\Http\Controllers\Api\NoticeController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\PaymentApiController;
use App\Http\Controllers\Api\SeatAlertController;
use App\Http\Controllers\Api\SeatController;
use App\Http\Controllers\Api\User\LibraryDiscoveryController;
use App\Http\Controllers\Api\User\UserAuthController;
use App\Http\Controllers\Api\UserProfileController;
use App\Services\FeeReminderService;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Public Routes - Legacy / General Auth & Live Grids
|--------------------------------------------------------------------------
*/
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Smart Seat Booking & Live Grids
Route::get('/seats/live-grid', [SeatController::class, 'getSeatGrid']);
Route::get('/seats/smart-grid', [SeatController::class, 'getSmartGrid']);

// Membership Plans (1M, 3M, 6M, 1Y)
Route::get('/plans', [MembershipController::class, 'index']);

// Study Room Rules & Notices
Route::get('/rules', [NoticeController::class, 'rules']);
Route::get('/notices', [NoticeController::class, 'notices']);

// Facility Availability (Wi-Fi, Charging, Lockers, AC/Cooler, Water, Washrooms)
Route::get('/facilities', [FacilityController::class, 'index']);
Route::get('/libraries/{id}/facilities', [FacilityController::class, 'index']);

// Smart Vacancy Alerts (seats with 5-minute fast-book countdown)
Route::get('/smart-vacancy-alerts', [SeatAlertController::class, 'smartVacancyAlerts']);

/*
|--------------------------------------------------------------------------
| Student / User Endpoints (Auth, Email OTP, Google Login, Nearby Libraries)
|--------------------------------------------------------------------------
*/
Route::prefix('user')->group(function () {
    // Auth & OTP
    Route::post('/auth/register', [UserAuthController::class, 'register']);
    Route::post('/auth/verify-otp', [UserAuthController::class, 'verifyOtp']);
    Route::post('/auth/resend-otp', [UserAuthController::class, 'resendOtp']);
    Route::post('/auth/login', [UserAuthController::class, 'login']);
    Route::post('/auth/google', [UserAuthController::class, 'googleLogin']);

    // Library Discovery & Live Seat Availability
    Route::get('/libraries', [LibraryDiscoveryController::class, 'index']);
    Route::get('/libraries/{id}', [LibraryDiscoveryController::class, 'show']);
});

/*
|--------------------------------------------------------------------------
| Library Manager Endpoints (Register, OTP, QR/Razorpay Payment, Seat Management)
|--------------------------------------------------------------------------
*/
Route::prefix('manager')->group(function () {
    // Manager Registration & Auth
    Route::post('/auth/register', [ManagerAuthController::class, 'register']);
    Route::post('/auth/verify-otp', [ManagerAuthController::class, 'verifyOtp']);
    Route::post('/auth/login', [ManagerAuthController::class, 'login']);

    // Manager Protected Controls
    Route::middleware(['auth:sanctum', 'manager'])->group(function () {
        // Manager Profile & Session
        Route::get('/me', [ManagerAuthController::class, 'me']);
        Route::post('/logout', [ManagerAuthController::class, 'logout']);

        // Listing Profile & Details
        Route::get('/library/profile', [ManagerLibraryController::class, 'getProfile']);
        Route::put('/library/listing', [ManagerLibraryController::class, 'updateListing']);
        Route::put('/library/profile', [ManagerLibraryController::class, 'updateListing']);

        // Listing Photos & Gallery Management
        Route::post('/library/photos', [ManagerLibraryController::class, 'uploadPhotos']);
        Route::delete('/library/photos', [ManagerLibraryController::class, 'deletePhoto']);

        // Library Operating Hours & Shift Timings
        Route::get('/library/timings', [ManagerLibraryController::class, 'getTimings']);
        Route::put('/library/timings', [ManagerLibraryController::class, 'updateTimings']);

        // Suvidha / Facilities Management (Wi-Fi, AC, Charging, Lockers, Water, Washrooms)
        Route::get('/library/facilities', [ManagerLibraryController::class, 'getFacilities']);
        Route::post('/library/facilities', [ManagerLibraryController::class, 'storeFacility']);
        Route::put('/library/facilities/{id}', [ManagerLibraryController::class, 'updateFacility']);
        Route::delete('/library/facilities/{id}', [ManagerLibraryController::class, 'destroyFacility']);

        // Seat Management & Live Availability
        Route::get('/dashboard', [ManagerSeatController::class, 'dashboard']);
        Route::get('/seats/availability', [ManagerLibraryController::class, 'getSeatAvailability']);
        Route::get('/seats', [ManagerSeatController::class, 'index']);
        Route::post('/seats/setup', [ManagerSeatController::class, 'setupSeats']);
        Route::post('/seats', [ManagerSeatController::class, 'store']);
        Route::put('/seats/{id}/status', [ManagerSeatController::class, 'updateStatus']);
        Route::delete('/seats/{id}', [ManagerSeatController::class, 'destroy']);

        // Onboarding Fee Payments
        Route::get('/payment/details', [ManagerPaymentController::class, 'getPaymentDetails']);
        Route::post('/payment/verify', [ManagerPaymentController::class, 'verifyPayment']);
    });
});

/*
|--------------------------------------------------------------------------
| Super Admin API Endpoints (Users, Libraries & Owners, Seats, Payments, Dashboard)
|--------------------------------------------------------------------------
*/
Route::prefix('admin')->middleware(['auth:sanctum', 'staff'])->group(function () {
    Route::get('/dashboard', [AdminApiController::class, 'getDashboardMetrics']);
    Route::get('/users', [AdminApiController::class, 'getUsers']);
    Route::get('/libraries', [AdminApiController::class, 'getLibraries']);
    Route::get('/libraries/{id}', [AdminApiController::class, 'getLibrary']);
    Route::put('/libraries/{id}/fee', [AdminApiController::class, 'updateLibraryFee']);
    Route::get('/seats', [AdminApiController::class, 'getSeatsOverview']);
    Route::get('/payments', [AdminApiController::class, 'getPayments']);

    // Platform Settings (One-Time Library Registration Fee, etc.)
    Route::get('/settings', [AdminApiController::class, 'getSettings']);
    Route::put('/settings', [AdminApiController::class, 'updateSettings']);

    // Admin Facility & Notice Management
    Route::put('/facilities/{id}', [FacilityController::class, 'updateStatus']);
    Route::post('/notices', [NoticeController::class, 'store']);
    Route::delete('/notices/{id}', [NoticeController::class, 'destroy']);

    // Admin Complaints Management
    Route::get('/complaints', [ComplaintController::class, 'adminIndex']);
    Route::put('/complaints/{id}', [ComplaintController::class, 'adminResolve']);

    // Admin Dispatch Fee Reminders
    Route::post('/fee-reminders/dispatch', function (FeeReminderService $service) {
        $result = $service->sendReminders();

        return response()->json([
            'success' => true,
            'message' => 'Fee reminders and pending payment alerts processed.',
            'result' => $result,
        ]);
    });
});

/*
|--------------------------------------------------------------------------
| Authenticated User Actions (Sanctum Protected)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Student Profile
    Route::get('/user/profile', [UserProfileController::class, 'profile']);
    Route::put('/user/profile', [UserProfileController::class, 'updateProfile']);

    // Seat Booking Actions
    Route::post('/bookings', [BookingController::class, 'store']);
    Route::get('/my-bookings', [BookingController::class, 'myBookings']);
    Route::post('/bookings/{id}/cancel', [BookingController::class, 'cancelBooking']);

    // Membership Subscriptions (1 Month, 3 Months, 6 Months, 1 Year)
    Route::post('/plans/subscribe', [MembershipController::class, 'subscribe']);
    Route::get('/my-subscription', [MembershipController::class, 'mySubscription']);

    // Online Payments (UPI / QR Code & Payment History)
    Route::post('/payments/intent', [PaymentApiController::class, 'createPaymentIntent']);
    Route::post('/payments/verify', [PaymentApiController::class, 'verifyPayment']);
    Route::get('/my-payments', [PaymentApiController::class, 'myPayments']);

    // QR Entry / Exit Scan & Study Hours Tracking
    Route::post('/attendance/scan-qr', [AttendanceController::class, 'scanQr']);
    Route::get('/study-hours/today', [AttendanceController::class, 'todayStudyHours']);
    Route::get('/attendance/history', [AttendanceController::class, 'history']);

    // Vacant Seat Alert (Waiting List)
    Route::post('/waiting-list/join', [SeatAlertController::class, 'joinWaitingList']);
    Route::get('/waiting-list/my', [SeatAlertController::class, 'myWaitingList']);
    Route::delete('/waiting-list/{id}', [SeatAlertController::class, 'leaveWaitingList']);

    // Smart Vacancy Alerts (Claim within 5 minutes)
    Route::post('/smart-vacancy-alerts/{id}/fast-book', [SeatAlertController::class, 'fastBookVacancy']);

    // Complaints / Feedback
    Route::post('/complaints', [ComplaintController::class, 'store']);
    Route::get('/my-complaints', [ComplaintController::class, 'myComplaints']);

    // In-app Notifications (Auto Fee Reminders, Seat Alerts, etc.)
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::post('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
    Route::post('/notifications/read-all', [NotificationController::class, 'markAllAsRead']);

    // Staff Reception Controls
    Route::middleware('staff')->group(function () {
        Route::put('/seats/{id}/status', [SeatController::class, 'updateSeatStatus']);
        Route::post('/bookings/verify-pass', [BookingController::class, 'verifyPass']);
        Route::post('/attendance/verify-pass', [AttendanceController::class, 'verifyStaffPass']);
    });
});
