<?php

namespace Tests\Feature;

use App\Models\Library;
use App\Models\Plan;
use App\Models\User;
use App\Models\Zone;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AdminPanelTest extends TestCase
{
    use RefreshDatabase;

    public function test_guest_is_redirected_to_login(): void
    {
        $response = $this->get('/admin');
        $response->assertRedirect(route('admin.login'));
    }

    public function test_staff_can_login_via_web_form(): void
    {
        $staff = User::factory()->create([
            'email' => 'staff_web@library.com',
            'password' => bcrypt('password123'),
            'role' => 'staff',
            'status' => 'active',
        ]);

        $response = $this->post('/admin/login', [
            'email' => 'staff_web@library.com',
            'password' => 'password123',
        ]);

        $response->assertRedirect('/admin');
        $this->assertAuthenticatedAs($staff);
    }

    public function test_admin_can_login_via_web_form(): void
    {
        $admin = User::factory()->create([
            'email' => 'admin_web@library.com',
            'password' => bcrypt('password123'),
            'role' => 'admin',
            'status' => 'active',
        ]);

        $response = $this->post('/admin/login', [
            'email' => 'admin_web@library.com',
            'password' => 'password123',
        ]);

        $response->assertRedirect('/admin');
        $this->assertAuthenticatedAs($admin);
    }

    public function test_member_denied_from_logging_into_admin_panel(): void
    {
        User::factory()->create([
            'email' => 'member_web@library.com',
            'password' => bcrypt('password123'),
            'role' => 'member',
            'status' => 'active',
        ]);

        $response = $this->post('/admin/login', [
            'email' => 'member_web@library.com',
            'password' => 'password123',
        ]);

        $response->assertSessionHas('error');
        $this->assertGuest();
    }

    public function test_staff_can_view_dashboard(): void
    {
        $staff = User::factory()->create(['role' => 'staff']);

        $response = $this->actingAs($staff)->get('/admin');

        $response->assertStatus(200)
            ->assertSee('Total Razorpay Revenue')
            ->assertSee('Registered Libraries');
    }

    public function test_staff_can_create_user(): void
    {
        $staff = User::factory()->create(['role' => 'staff']);

        $response = $this->actingAs($staff)->post('/admin/users', [
            'name' => 'New Student',
            'email' => 'newstudent@example.com',
            'phone' => '9876500112',
            'role' => 'member',
            'password' => 'secret123',
        ]);

        $response->assertSessionHas('success');
        $this->assertDatabaseHas('users', [
            'email' => 'newstudent@example.com',
            'role' => 'member',
        ]);
    }

    public function test_staff_can_batch_generate_seats(): void
    {
        $staff = User::factory()->create(['role' => 'staff']);
        $zone = Zone::create(['name' => 'Quiet Zone', 'code' => 'QZ']);

        $response = $this->actingAs($staff)->post('/admin/seats/batch', [
            'zone_id' => $zone->id,
            'prefix' => 'Q-',
            'start' => 1,
            'end' => 5,
        ]);

        $response->assertSessionHas('success');
        $this->assertDatabaseHas('seats', ['seat_number' => 'Q-01', 'zone_id' => $zone->id]);
        $this->assertDatabaseHas('seats', ['seat_number' => 'Q-05', 'zone_id' => $zone->id]);
    }

    public function test_staff_can_record_manual_payment(): void
    {
        $staff = User::factory()->create(['role' => 'staff']);
        $member = User::factory()->create(['role' => 'member']);
        $plan = Plan::create([
            'name' => 'Daily Pass',
            'price' => 100.00,
            'duration_days' => 1,
            'shift' => 'morning',
            'is_active' => true,
        ]);

        $response = $this->actingAs($staff)->post('/admin/payments', [
            'user_id' => $member->id,
            'plan_id' => $plan->id,
            'amount' => 100.00,
            'payment_method' => 'cash',
            'status' => 'completed',
            'notes' => 'Reception desk cash collection',
        ]);

        $response->assertSessionHas('success');
        $this->assertDatabaseHas('payments', [
            'user_id' => $member->id,
            'amount' => 100.00,
            'payment_method' => 'cash',
            'collected_by' => $staff->id,
        ]);
    }

    public function test_staff_can_view_libraries_management_page(): void
    {
        $staff = User::factory()->create(['role' => 'staff']);
        $owner = User::factory()->create(['role' => 'manager', 'name' => 'Owner Vikram']);
        $library = Library::create([
            'user_id' => $owner->id,
            'name' => 'Apex Central Library',
            'slug' => 'apex-central-library',
            'address' => 'Station Road, Pune',
            'city' => 'Pune',
            'phone' => '9822001122',
            'registration_fee' => 999.00,
            'payment_status' => 'unpaid',
            'status' => 'pending_payment',
        ]);

        $response = $this->actingAs($staff)->get('/admin/libraries');

        $response->assertStatus(200)
            ->assertSee('Apex Central Library')
            ->assertSee('Owner Vikram');
    }

    public function test_staff_can_toggle_library_status(): void
    {
        $staff = User::factory()->create(['role' => 'staff']);
        $owner = User::factory()->create(['role' => 'manager']);
        $library = Library::create([
            'user_id' => $owner->id,
            'name' => 'City Book Haven',
            'slug' => 'city-book-haven',
            'address' => 'FC Road',
            'status' => 'active',
            'payment_status' => 'paid',
        ]);

        $response = $this->actingAs($staff)->post("/admin/libraries/{$library->id}/toggle-status");

        $response->assertSessionHas('success');
        $this->assertDatabaseHas('libraries', [
            'id' => $library->id,
            'status' => 'suspended',
        ]);
    }

    public function test_staff_can_verify_library_onboarding_payment(): void
    {
        $staff = User::factory()->create(['role' => 'staff']);
        $owner = User::factory()->create(['role' => 'manager']);
        $library = Library::create([
            'user_id' => $owner->id,
            'name' => 'Scholars Den',
            'slug' => 'scholars-den',
            'address' => 'MG Road',
            'registration_fee' => 999.00,
            'payment_status' => 'unpaid',
            'status' => 'pending_payment',
        ]);

        $response = $this->actingAs($staff)->post("/admin/libraries/{$library->id}/verify-payment", [
            'payment_method' => 'upi',
        ]);

        $response->assertSessionHas('success');
        $this->assertDatabaseHas('libraries', [
            'id' => $library->id,
            'payment_status' => 'paid',
            'status' => 'active',
        ]);
        $this->assertDatabaseHas('payments', [
            'library_id' => $library->id,
            'type' => 'library_registration',
            'status' => 'completed',
        ]);
    }

    public function test_staff_can_update_one_time_library_registration_fee_via_web(): void
    {
        $staff = User::factory()->create(['role' => 'staff']);
        $owner = User::factory()->create(['role' => 'manager']);
        $library = Library::create([
            'user_id' => $owner->id,
            'name' => 'Elite Study Hub',
            'slug' => 'elite-study-hub',
            'address' => 'JM Road, Pune',
            'registration_fee' => 999.00,
            'payment_status' => 'unpaid',
            'status' => 'pending_payment',
        ]);

        $response = $this->actingAs($staff)->post("/admin/libraries/{$library->id}/update-fee", [
            'registration_fee' => 1499.00,
        ]);

        $response->assertSessionHas('success');
        $this->assertDatabaseHas('libraries', [
            'id' => $library->id,
            'registration_fee' => 1499.00,
        ]);
    }

    public function test_admin_can_update_one_time_library_registration_fee_via_api(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $owner = User::factory()->create(['role' => 'manager']);
        $library = Library::create([
            'user_id' => $owner->id,
            'name' => 'Apex Reading Lounge',
            'slug' => 'apex-reading-lounge',
            'address' => 'Kothrud, Pune',
            'registration_fee' => 999.00,
            'payment_status' => 'unpaid',
            'status' => 'pending_payment',
        ]);

        $token = $admin->createToken('admin_token')->plainTextToken;

        $response = $this->withHeader('Authorization', 'Bearer '.$token)
            ->putJson("/api/admin/libraries/{$library->id}/fee", [
                'registration_fee' => 499.00,
            ]);

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('library.registration_fee', '499.00');

        $this->assertDatabaseHas('libraries', [
            'id' => $library->id,
            'registration_fee' => 499.00,
        ]);
    }
}
