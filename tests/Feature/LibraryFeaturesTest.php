<?php

namespace Tests\Feature;

use App\Models\Booking;
use App\Models\Facility;
use App\Models\Library;
use App\Models\Notice;
use App\Models\Payment;
use App\Models\Plan;
use App\Models\Seat;
use App\Models\Subscription;
use App\Models\User;
use App\Models\Zone;
use App\Services\FeeReminderService;
use App\Services\SeatAlertService;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class LibraryFeaturesTest extends TestCase
{
    use RefreshDatabase;

    protected User $student;

    protected User $admin;

    protected Library $library;

    protected Zone $zone;

    protected Seat $seat;

    protected function setUp(): void
    {
        parent::setUp();

        $this->admin = User::create([
            'name' => 'Admin User',
            'email' => 'admin@test.com',
            'phone' => '9999999999',
            'role' => 'admin',
            'status' => 'active',
            'password' => bcrypt('password'),
        ]);

        $this->student = User::create([
            'name' => 'Student Rahul',
            'email' => 'student@test.com',
            'phone' => '8888888888',
            'role' => 'user',
            'status' => 'active',
            'email_verified_at' => now(),
            'password' => bcrypt('password'),
        ]);

        $this->library = Library::create([
            'user_id' => $this->admin->id,
            'name' => 'Central Study Hub',
            'slug' => 'central-study-hub',
            'address' => '100 MG Road',
            'city' => 'Pune',
            'status' => 'active',
            'payment_status' => 'paid',
        ]);

        $this->zone = Zone::create([
            'name' => 'Ground Floor Silent Hall',
            'code' => 'GF-SH',
        ]);

        $this->seat = Seat::create([
            'library_id' => $this->library->id,
            'zone_id' => $this->zone->id,
            'seat_number' => 'G-01',
            'status' => 'available',
        ]);
    }

    /**
     * Feature 1 & 8: Student Registration / Login & Student Profile
     */
    public function test_student_profile_and_stats(): void
    {
        $response = $this->actingAs($this->student, 'sanctum')
            ->getJson('/api/user/profile');

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('user.email', 'student@test.com')
            ->assertJsonStructure(['success', 'user', 'today_study_hours', 'stats']);

        // Profile Update
        $updateResponse = $this->actingAs($this->student, 'sanctum')
            ->putJson('/api/user/profile', [
                'name' => 'Rahul Updated',
            ]);

        $updateResponse->assertStatus(200)
            ->assertJsonPath('user.name', 'Rahul Updated');
    }

    /**
     * Feature 2 & 11: Seat Booking & Smart Seat Booking (Slot Grid)
     */
    public function test_smart_seat_grid_and_booking(): void
    {
        $today = Carbon::today()->toDateString();

        // 1. Smart Grid Check
        $gridResponse = $this->getJson("/api/seats/smart-grid?booking_date={$today}&shift=morning");
        $gridResponse->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('summary.available', 1);

        // 2. Book Seat
        $bookResponse = $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/bookings', [
                'seat_id' => $this->seat->id,
                'shift' => 'morning',
                'booking_date' => $today,
            ]);

        $bookResponse->assertStatus(201)
            ->assertJsonPath('success', true)
            ->assertJsonPath('booking.shift', 'morning');

        $this->assertDatabaseHas('bookings', [
            'user_id' => $this->student->id,
            'seat_id' => $this->seat->id,
            'status' => 'active',
        ]);
    }

    /**
     * Feature 3: Membership Plans (1 Month, 3 Months, 6 Months, 1 Year) & Subscriptions
     */
    public function test_membership_plans_and_subscription_flow(): void
    {
        $plan1Month = Plan::create([
            'name' => '1 Month Regular Pass',
            'price' => 2000.00,
            'duration_days' => 30,
            'shift' => 'all',
            'is_active' => true,
        ]);

        $plan3Months = Plan::create([
            'name' => '3 Months Prime Pass',
            'price' => 5400.00,
            'duration_days' => 90,
            'shift' => 'all',
            'is_active' => true,
        ]);

        // 1. Get plans
        $plansResponse = $this->getJson('/api/plans');
        $plansResponse->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonCount(2, 'data');

        // 2. Subscribe to 3 Months plan
        $subResponse = $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/plans/subscribe', [
                'plan_id' => $plan3Months->id,
                'library_id' => $this->library->id,
                'seat_id' => $this->seat->id,
            ]);

        $subResponse->assertStatus(201)
            ->assertJsonPath('success', true)
            ->assertJsonPath('subscription.status', 'active');

        // Verify end_date is exactly 90 days from today
        $expectedEndDate = Carbon::today()->addDays(90)->toDateString();
        $this->assertDatabaseHas('subscriptions', [
            'user_id' => $this->student->id,
            'plan_id' => $plan3Months->id,
            'status' => 'active',
        ]);
        $subRecord = Subscription::where('user_id', $this->student->id)->first();
        $this->assertEquals($expectedEndDate, $subRecord->end_date->toDateString());

        // 3. View my active subscription
        $mySubResponse = $this->actingAs($this->student, 'sanctum')
            ->getJson('/api/my-subscription');

        $mySubResponse->assertStatus(200)
            ->assertJsonPath('has_active_subscription', true)
            ->assertJsonPath('expiry_date', $expectedEndDate);
    }

    /**
     * Feature 4: Online Payment (UPI / QR Code & Payment History)
     */
    public function test_online_payment_upi_qr_intent_and_history(): void
    {
        // 1. Generate UPI / QR Intent
        $intentResponse = $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/payments/intent', [
                'amount' => 500.00,
                'type' => 'seat_booking',
                'payment_method' => 'upi',
            ]);

        $intentResponse->assertStatus(201)
            ->assertJsonPath('success', true)
            ->assertJsonStructure(['upi' => ['upi_intent_url', 'qr_code_data', 'transaction_id']]);

        $txnId = $intentResponse->json('upi.transaction_id');

        // 2. Confirm Payment
        $confirmResponse = $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/payments/verify', [
                'transaction_id' => $txnId,
                'status' => 'completed',
            ]);

        $confirmResponse->assertStatus(200)
            ->assertJsonPath('payment.status', 'completed');

        // 3. Check Payment History
        $historyResponse = $this->actingAs($this->student, 'sanctum')
            ->getJson('/api/my-payments');

        $historyResponse->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonCount(1, 'data');
    }

    /**
     * Feature 5 & 9: Seat Management Admin & Dashboard Metrics (with Expiry Date)
     */
    public function test_admin_seat_management_with_expiry_dates(): void
    {
        // Create booking with expiry
        Booking::create([
            'user_id' => $this->student->id,
            'seat_id' => $this->seat->id,
            'pass_code' => 'PASS-1234',
            'shift' => 'full_day',
            'booking_date' => Carbon::today()->toDateString(),
            'expires_at' => Carbon::today()->endOfDay(),
            'status' => 'active',
        ]);

        $this->seat->update(['status' => 'occupied']);

        // Check Admin Seats API
        $response = $this->actingAs($this->admin, 'sanctum')
            ->getJson('/api/admin/seats');

        $response->assertStatus(200)
            ->assertJsonPath('success', true);

        $seatData = collect($response->json('data'))->firstWhere('id', $this->seat->id);
        $this->assertNotNull($seatData);
        $this->assertEquals('Student Rahul', $seatData['booked_by']);
        $this->assertNotNull($seatData['expiry_date']);

        // Check Admin Dashboard Metrics API
        $dashboardResponse = $this->actingAs($this->admin, 'sanctum')
            ->getJson('/api/admin/dashboard');

        $dashboardResponse->assertStatus(200)
            ->assertJsonPath('metrics.total_seats', 1)
            ->assertJsonPath('metrics.occupied_seats', 1);
    }

    /**
     * Feature 6 & 12: Auto Fee Reminder (7 / 3 / 1 days before expiry)
     */
    public function test_auto_fee_reminder_dispatch(): void
    {
        $plan = Plan::create([
            'name' => 'Monthly AC Study Pass',
            'price' => 2000.00,
            'duration_days' => 30,
            'is_active' => true,
        ]);

        // Subscription expiring in exactly 3 days
        Subscription::create([
            'user_id' => $this->student->id,
            'plan_id' => $plan->id,
            'library_id' => $this->library->id,
            'start_date' => Carbon::today()->subDays(27)->toDateString(),
            'end_date' => Carbon::today()->addDays(3)->toDateString(),
            'status' => 'active',
        ]);

        $service = app(FeeReminderService::class);
        $result = $service->sendReminders();

        $this->assertEquals(1, $result['expiry_reminders_sent']);

        $this->assertDatabaseHas('notifications', [
            'user_id' => $this->student->id,
            'type' => 'fee_reminder',
            'badge' => 'Reminder',
        ]);
    }

    /**
     * Feature 7: Study Room Rules & Notices
     */
    public function test_study_room_rules_and_notices(): void
    {
        Notice::create([
            'library_id' => $this->library->id,
            'title' => 'Silence Required',
            'content' => 'Please maintain strict silence in the reading room.',
            'type' => 'rule',
            'is_active' => true,
        ]);

        Notice::create([
            'library_id' => $this->library->id,
            'title' => 'Library Timing Update',
            'content' => 'Library will remain open until 10 PM this weekend.',
            'type' => 'notice',
            'is_active' => true,
        ]);

        $rulesResponse = $this->getJson('/api/rules');
        $rulesResponse->assertStatus(200)
            ->assertJsonPath('success', true);

        $noticesResponse = $this->getJson('/api/notices');
        $noticesResponse->assertStatus(200)
            ->assertJsonPath('success', true);
    }

    /**
     * Feature 10: Complaints / Feedback Flow
     */
    public function test_complaints_and_feedback(): void
    {
        // 1. Student submits complaint
        $complaintResponse = $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/complaints', [
                'category' => 'ac_cooler',
                'subject' => 'AC not cooling properly',
                'description' => 'The temperature is high near seat G-01.',
                'library_id' => $this->library->id,
                'seat_id' => $this->seat->id,
            ]);

        $complaintResponse->assertStatus(201)
            ->assertJsonPath('success', true);

        $complaintId = $complaintResponse->json('complaint.id');

        // 2. Admin resolves complaint
        $resolveResponse = $this->actingAs($this->admin, 'sanctum')
            ->putJson("/api/admin/complaints/{$complaintId}", [
                'status' => 'resolved',
                'admin_remark' => 'AC technician serviced the unit.',
            ]);

        $resolveResponse->assertStatus(200)
            ->assertJsonPath('complaint.status', 'resolved');

        // 3. Student receives resolution notification
        $this->assertDatabaseHas('notifications', [
            'user_id' => $this->student->id,
            'badge' => 'Resolved',
        ]);
    }

    /**
     * Feature 13 & 15: QR Entry / Exit Scan & Study Hours Tracking
     */
    public function test_qr_entry_exit_and_study_hours(): void
    {
        // 1. Scan QR to Check In
        $checkInResponse = $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/attendance/scan-qr', [
                'library_id' => $this->library->id,
            ]);

        $checkInResponse->assertStatus(201)
            ->assertJsonPath('action', 'check_in');

        // 2. Scan QR again to Check Out
        $checkOutResponse = $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/attendance/scan-qr', [
                'library_id' => $this->library->id,
            ]);

        $checkOutResponse->assertStatus(200)
            ->assertJsonPath('action', 'check_out');

        // 3. Check Study Hours
        $studyResponse = $this->actingAs($this->student, 'sanctum')
            ->getJson('/api/study-hours/today');

        $studyResponse->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonStructure(['data' => ['today_minutes', 'today_formatted', 'is_currently_studying']]);
    }

    /**
     * Feature 14: Vacant Seat Alert (Waiting List)
     */
    public function test_vacant_seat_alert_waiting_list(): void
    {
        // 1. Student joins waiting list
        $joinResponse = $this->actingAs($this->student, 'sanctum')
            ->postJson('/api/waiting-list/join', [
                'library_id' => $this->library->id,
                'shift' => 'morning',
                'desired_date' => Carbon::today()->toDateString(),
            ]);

        $joinResponse->assertStatus(201)
            ->assertJsonPath('success', true)
            ->assertJsonPath('queue_position', 1);

        // 2. A seat opens -> trigger alert
        $service = app(SeatAlertService::class);
        $service->notifyWaitingList($this->seat, 'morning', Carbon::today()->toDateString());

        // 3. Student received Vacant Seat notification
        $this->assertDatabaseHas('notifications', [
            'user_id' => $this->student->id,
            'type' => 'vacant_seat',
            'badge' => 'Waiting List',
        ]);
    }

    /**
     * Feature 16: Facility Availability
     */
    public function test_facility_availability(): void
    {
        Facility::create([
            'library_id' => $this->library->id,
            'name' => 'High-Speed Wi-Fi',
            'category' => 'wifi',
            'status' => 'available',
            'details' => '150 Mbps Fiber',
        ]);

        $response = $this->getJson("/api/libraries/{$this->library->id}/facilities");

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('summary.available', 1);
    }

    /**
     * Feature 17: Smart Vacancy Alert with 5-minute fast-book countdown window
     */
    public function test_smart_vacancy_alert_and_fast_book(): void
    {
        // 1. Trigger Smart Vacancy Alert
        $service = app(SeatAlertService::class);
        $alert = $service->triggerSmartVacancyAlert($this->seat, 'full_day');

        $this->assertFalse($alert->isExpired());
        $this->assertGreaterThan(0, $alert->secondsRemaining());

        // 2. Fetch active alerts endpoint
        $alertsResponse = $this->getJson('/api/smart-vacancy-alerts');
        $alertsResponse->assertStatus(200)
            ->assertJsonPath('count', 1);

        // 3. Fast-book within the 5-minute window
        $claimResponse = $this->actingAs($this->student, 'sanctum')
            ->postJson("/api/smart-vacancy-alerts/{$alert->id}/fast-book");

        $claimResponse->assertStatus(201)
            ->assertJsonPath('success', true)
            ->assertJsonPath('booking.seat_id', $this->seat->id);

        $this->assertDatabaseHas('smart_vacancy_alerts', [
            'id' => $alert->id,
            'status' => 'claimed',
            'claimed_by' => $this->student->id,
        ]);
    }
}
