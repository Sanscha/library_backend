<?php

namespace Tests\Feature;

use App\Models\Facility;
use App\Models\Library;
use App\Models\Seat;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class ManagerLibraryManagementTest extends TestCase
{
    use RefreshDatabase;

    protected User $manager;

    protected Library $library;

    protected User $admin;

    protected function setUp(): void
    {
        parent::setUp();

        Storage::fake('public');

        // Manager / Library Owner
        $this->manager = User::create([
            'name' => 'Owner Ganesh Patil',
            'email' => 'ganesh@library.com',
            'phone' => '9876543210',
            'role' => 'manager',
            'status' => 'active',
            'email_verified_at' => now(),
            'password' => bcrypt('password123'),
        ]);

        // Library owned by Ganesh
        $this->library = Library::create([
            'user_id' => $this->manager->id,
            'name' => 'Saraswati Abhyasika',
            'slug' => 'saraswati-abhyasika',
            'address' => 'Near Shivaji Nagar Metro, Pune',
            'city' => 'Pune',
            'state' => 'Maharashtra',
            'pincode' => '411005',
            'latitude' => 18.5204,
            'longitude' => 73.8567,
            'phone' => '9876543210',
            'email' => 'contact@saraswati.com',
            'description' => 'Quiet study room with 24/7 power backup.',
            'amenities' => ['WiFi', 'AC', 'Purified Water'],
            'total_seats' => 20,
            'registration_fee' => 999.00,
            'payment_status' => 'paid',
            'status' => 'active',
        ]);

        // Pre-create 5 seats
        for ($i = 1; $i <= 5; $i++) {
            Seat::create([
                'library_id' => $this->library->id,
                'seat_number' => 'S-'.str_pad((string) $i, 2, '0', STR_PAD_LEFT),
                'status' => $i === 1 ? 'occupied' : 'available',
            ]);
        }

        // Admin
        $this->admin = User::create([
            'name' => 'Platform Admin',
            'email' => 'admin@seat-sync.com',
            'phone' => '9999900000',
            'role' => 'admin',
            'status' => 'active',
            'email_verified_at' => now(),
            'password' => bcrypt('admin123'),
        ]);
    }

    public function test_manager_can_login_via_api_and_retrieve_profile(): void
    {
        $loginRes = $this->postJson('/api/manager/auth/login', [
            'login' => 'ganesh@library.com',
            'password' => 'password123',
        ]);

        $loginRes->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('manager.email', 'ganesh@library.com')
            ->assertJsonStructure(['token', 'manager', 'library']);

        $token = $loginRes->json('token');

        // Test GET /api/manager/me
        $meRes = $this->withHeader('Authorization', 'Bearer '.$token)
            ->getJson('/api/manager/me');

        $meRes->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('manager.name', 'Owner Ganesh Patil')
            ->assertJsonPath('library.id', $this->library->id);

        // Test GET /api/manager/library/profile
        $profileRes = $this->withHeader('Authorization', 'Bearer '.$token)
            ->getJson('/api/manager/library/profile');

        $profileRes->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('library.name', 'Saraswati Abhyasika')
            ->assertJsonPath('seat_statistics.total_seats', 5)
            ->assertJsonPath('seat_statistics.occupied_seats', 1)
            ->assertJsonPath('seat_statistics.available_seats', 4);
    }

    public function test_manager_can_update_library_listing_details(): void
    {
        $token = $this->manager->createToken('test_token')->plainTextToken;

        $response = $this->withHeader('Authorization', 'Bearer '.$token)
            ->putJson('/api/manager/library/listing', [
                'name' => 'Saraswati Premium Abhyasika',
                'address' => 'FC Road, Deccan, Pune',
                'city' => 'Pune',
                'state' => 'Maharashtra',
                'pincode' => '411004',
                'phone' => '9876543219',
                'description' => 'Updated 24/7 air-conditioned study hall with ergonomic chairs.',
                'amenities' => ['High-Speed WiFi', 'Individual Desks', 'Silent AC Zone'],
            ]);

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('library.name', 'Saraswati Premium Abhyasika')
            ->assertJsonPath('library.address', 'FC Road, Deccan, Pune');

        $this->assertDatabaseHas('libraries', [
            'id' => $this->library->id,
            'name' => 'Saraswati Premium Abhyasika',
            'address' => 'FC Road, Deccan, Pune',
        ]);
    }

    public function test_manager_can_upload_and_manage_photos_and_gallery(): void
    {
        $token = $this->manager->createToken('test_token')->plainTextToken;

        $coverFile = UploadedFile::fake()->create('cover.jpg', 100, 'image/jpeg');
        $galleryFile1 = UploadedFile::fake()->create('hall1.jpg', 100, 'image/jpeg');
        $galleryFile2 = UploadedFile::fake()->create('hall2.jpg', 100, 'image/jpeg');

        $response = $this->withHeader('Authorization', 'Bearer '.$token)
            ->postJson('/api/manager/library/photos', [
                'cover_image' => $coverFile,
                'gallery_photos' => [$galleryFile1, $galleryFile2],
            ]);

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('photos.total_gallery_count', 2);

        $this->library->refresh();
        $this->assertNotNull($this->library->image);
        $this->assertCount(2, $this->library->gallery);

        // Test delete photo from gallery
        $photoToDelete = $this->library->gallery[0];
        $delResponse = $this->withHeader('Authorization', 'Bearer '.$token)
            ->deleteJson('/api/manager/library/photos', [
                'photo_path' => $photoToDelete,
            ]);

        $delResponse->assertStatus(200)
            ->assertJsonPath('success', true);

        $this->library->refresh();
        $this->assertCount(1, $this->library->gallery);
    }

    public function test_manager_can_update_operating_hours_and_timings(): void
    {
        $token = $this->manager->createToken('test_token')->plainTextToken;

        $response = $this->withHeader('Authorization', 'Bearer '.$token)
            ->putJson('/api/manager/library/timings', [
                'opening_time' => '06:00',
                'closing_time' => '23:00',
                'days_open' => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
                'shifts' => [
                    'morning' => ['start' => '06:00', 'end' => '12:00'],
                    'evening' => ['start' => '12:00', 'end' => '18:00'],
                    'full_day' => ['start' => '06:00', 'end' => '23:00'],
                ],
                'notes' => 'Early bird opening from 6:00 AM.',
            ]);

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('operating_hours.opening_time', '06:00')
            ->assertJsonPath('operating_hours.closing_time', '23:00')
            ->assertJsonPath('operating_hours.shifts.morning.start', '06:00');

        $this->library->refresh();
        $this->assertEquals('06:00', $this->library->operating_hours['opening_time']);
    }

    public function test_manager_can_view_and_update_facilities_suvidha(): void
    {
        $token = $this->manager->createToken('test_token')->plainTextToken;

        // Fetch facilities (auto-seeds defaults if not seeded yet)
        $facRes = $this->withHeader('Authorization', 'Bearer '.$token)
            ->getJson('/api/manager/library/facilities');

        $facRes->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonStructure(['summary', 'facilities']);

        $facilities = $facRes->json('facilities');
        $this->assertNotEmpty($facilities);

        // Find wifi facility
        $wifi = collect($facilities)->firstWhere('category', 'wifi');
        $this->assertNotNull($wifi);

        // Update facility status & details
        $updateRes = $this->withHeader('Authorization', 'Bearer '.$token)
            ->putJson('/api/manager/library/facilities/'.$wifi['id'], [
                'status' => 'available',
                'details' => 'Upgraded to Jio Fiber 300 Mbps with backup router',
            ]);

        $updateRes->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('facility.details', 'Upgraded to Jio Fiber 300 Mbps with backup router');

        $this->assertDatabaseHas('facilities', [
            'id' => $wifi['id'],
            'status' => 'available',
            'details' => 'Upgraded to Jio Fiber 300 Mbps with backup router',
        ]);
    }

    public function test_manager_can_add_custom_facility(): void
    {
        $token = $this->manager->createToken('test_token')->plainTextToken;

        $response = $this->withHeader('Authorization', 'Bearer '.$token)
            ->postJson('/api/manager/library/facilities', [
                'name' => 'Silent Discussion Booth',
                'category' => 'other',
                'status' => 'available',
                'details' => 'Soundproof booth for calls and group study',
                'icon' => 'volume-x',
            ]);

        $response->assertStatus(201)
            ->assertJsonPath('success', true)
            ->assertJsonPath('facility.name', 'Silent Discussion Booth');

        $facilityId = $response->json('facility.id');

        // Delete custom facility
        $delRes = $this->withHeader('Authorization', 'Bearer '.$token)
            ->deleteJson('/api/manager/library/facilities/'.$facilityId);

        $delRes->assertStatus(200)
            ->assertJsonPath('success', true);
    }

    public function test_manager_can_manage_seat_availability(): void
    {
        $token = $this->manager->createToken('test_token')->plainTextToken;

        // View live seat availability
        $availRes = $this->withHeader('Authorization', 'Bearer '.$token)
            ->getJson('/api/manager/seats/availability');

        $availRes->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('summary.total', 5);

        // Toggle a seat to maintenance
        $seat = $this->library->seats()->where('status', 'available')->first();

        $statusRes = $this->withHeader('Authorization', 'Bearer '.$token)
            ->putJson('/api/manager/seats/'.$seat->id.'/status', [
                'status' => 'maintenance',
            ]);

        $statusRes->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('seat.status', 'maintenance');

        $this->assertDatabaseHas('seats', [
            'id' => $seat->id,
            'status' => 'maintenance',
        ]);
    }

    public function test_admin_can_inspect_all_changes_done_by_library_owner_via_api(): void
    {
        // 1. Library owner updates details, timings, and facilities
        $this->library->operating_hours = [
            'opening_time' => '06:30',
            'closing_time' => '22:30',
            'days_open' => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
            'shifts' => [
                'morning' => ['start' => '06:30', 'end' => '13:00', 'label' => 'Morning Shift'],
                'evening' => ['start' => '13:00', 'end' => '19:30', 'label' => 'Evening Shift'],
                'full_day' => ['start' => '06:30', 'end' => '22:30', 'label' => 'Full Day'],
            ],
            'notes' => 'Owner customized hours.',
        ];
        $this->library->gallery = ['libraries/gallery/test1.jpg', 'libraries/gallery/test2.jpg'];
        $this->library->save();

        Facility::create([
            'library_id' => $this->library->id,
            'name' => 'High-Speed Wi-Fi',
            'category' => 'wifi',
            'status' => 'available',
            'details' => '300 Mbps Fiber',
            'icon' => 'wifi',
            'last_checked_at' => now(),
        ]);

        // 2. Admin inspects library via GET /api/admin/libraries/{id}
        $adminToken = $this->admin->createToken('admin_token')->plainTextToken;

        $response = $this->withHeader('Authorization', 'Bearer '.$adminToken)
            ->getJson('/api/admin/libraries/'.$this->library->id);

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('library.id', $this->library->id)
            ->assertJsonPath('library.name', 'Saraswati Abhyasika')
            ->assertJsonPath('owner.name', 'Owner Ganesh Patil')
            ->assertJsonPath('photos.gallery_count', 2)
            ->assertJsonPath('operating_hours.opening_time', '06:30')
            ->assertJsonPath('seats.summary.total', 5)
            ->assertJsonStructure([
                'library',
                'owner',
                'photos',
                'operating_hours',
                'facilities' => ['summary', 'data'],
                'seats' => ['summary', 'data'],
            ]);
    }

    public function test_admin_can_view_library_details_page_in_web_panel(): void
    {
        $response = $this->actingAs($this->admin)
            ->get(route('admin.libraries.show', $this->library->id));

        $response->assertStatus(200)
            ->assertSee('Saraswati Abhyasika')
            ->assertSee('Listing Photos')
            ->assertSee('Library Operating Hours')
            ->assertSee('Library Suvidha')
            ->assertSee('Owner Ganesh Patil');
    }
}
