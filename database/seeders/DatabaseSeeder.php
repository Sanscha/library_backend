<?php

namespace Database\Seeders;

use App\Models\Attendance;
use App\Models\Booking;
use App\Models\Complaint;
use App\Models\Facility;
use App\Models\Library;
use App\Models\Notice;
use App\Models\Notification;
use App\Models\Payment;
use App\Models\Plan;
use App\Models\Seat;
use App\Models\SmartVacancyAlert;
use App\Models\Subscription;
use App\Models\User;
use App\Models\WaitingList;
use App\Models\Zone;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Create Staff Account
        $staff = User::create([
            'name' => 'Library Staff',
            'email' => 'staff@library.com',
            'phone' => '9876543210',
            'role' => 'staff',
            'status' => 'active',
            'password' => Hash::make('staff123'),
        ]);

        // 2. Create Admin Account
        $admin = User::create([
            'name' => 'Library Admin',
            'email' => 'admin@library.com',
            'phone' => '9876543211',
            'role' => 'admin',
            'status' => 'active',
            'password' => Hash::make('admin123'),
        ]);

        // 3. Create Sample Member Accounts
        $member = User::create([
            'name' => 'John Doe',
            'email' => 'member@library.com',
            'phone' => '9123456780',
            'role' => 'member',
            'status' => 'active',
            'password' => Hash::make('member123'),
        ]);

        $member2 = User::create([
            'name' => 'Priya Sharma',
            'email' => 'priya@example.com',
            'phone' => '9822334455',
            'role' => 'member',
            'status' => 'active',
            'password' => Hash::make('secret123'),
        ]);

        $member3 = User::create([
            'name' => 'Rahul Verma',
            'email' => 'rahul@example.com',
            'phone' => '9811223344',
            'role' => 'member',
            'status' => 'active',
            'password' => Hash::make('secret123'),
        ]);

        // 4. Create Library Zones / Floors
        $zoneA = Zone::create(['name' => 'Ground Floor - Silent Zone', 'code' => 'GF-SZ']);
        $zoneB = Zone::create(['name' => 'First Floor - AC Hall', 'code' => 'FF-AC']);
        $zoneC = Zone::create(['name' => 'Second Floor - Discussion Hall', 'code' => 'SF-DH']);

        // 5. Create Seats for Each Zone
        $zones = [
            ['zone' => $zoneA, 'prefix' => 'G-'],
            ['zone' => $zoneB, 'prefix' => 'F-'],
            ['zone' => $zoneC, 'prefix' => 'D-'],
        ];

        $reservedSeat = null;
        $occupiedSeat = null;

        foreach ($zones as $zoneData) {
            $z = $zoneData['zone'];
            $prefix = $zoneData['prefix'];

            for ($i = 1; $i <= 10; $i++) {
                $status = 'available';
                if ($i % 4 === 0) {
                    $status = 'occupied';
                } elseif ($i === 3 && $prefix === 'G-') {
                    $status = 'reserved';
                }

                $seat = Seat::create([
                    'zone_id' => $z->id,
                    'seat_number' => $prefix.str_pad((string) $i, 2, '0', STR_PAD_LEFT),
                    'status' => $status,
                ]);

                if ($seat->seat_number === 'G-03') {
                    $reservedSeat = $seat;
                }
                if ($seat->seat_number === 'G-04') {
                    $occupiedSeat = $seat;
                }
            }
        }

        // 6. Pricing & Membership Plans (1 Month, 3 Months, 6 Months, 1 Year + Daily Passes)
        $planMorning = Plan::create([
            'name' => 'Morning Shift Pass (8 AM - 2 PM)',
            'price' => 80.00,
            'duration_days' => 1,
            'shift' => 'morning',
            'description' => 'Single day entry for the silent study morning slot.',
            'is_active' => true,
        ]);

        $planEvening = Plan::create([
            'name' => 'Evening Shift Pass (2 PM - 8 PM)',
            'price' => 80.00,
            'duration_days' => 1,
            'shift' => 'evening',
            'description' => 'Single day entry for the evening slot.',
            'is_active' => true,
        ]);

        $planFullDay = Plan::create([
            'name' => 'Full Day Study Pass (8 AM - 8 PM)',
            'price' => 150.00,
            'duration_days' => 1,
            'shift' => 'full_day',
            'description' => 'Full access with high speed WiFi and power socket.',
            'is_active' => true,
        ]);

        $plan1Month = Plan::create([
            'name' => '1 Month Regular Pass (30 Days)',
            'price' => 2000.00,
            'duration_days' => 30,
            'shift' => 'all',
            'description' => 'Dedicated seat access with AC, high-speed Wi-Fi, and locker for 1 Month.',
            'is_active' => true,
        ]);

        $plan3Months = Plan::create([
            'name' => '3 Months Prime Pass (90 Days)',
            'price' => 5400.00,
            'duration_days' => 90,
            'shift' => 'all',
            'description' => 'Popular quarterly pack with free locker allocation and priority seat selection.',
            'is_active' => true,
        ]);

        $plan6Months = Plan::create([
            'name' => '6 Months Executive Pass (180 Days)',
            'price' => 9900.00,
            'duration_days' => 180,
            'shift' => 'all',
            'description' => 'Half-yearly pass tailored for competitive exam preparation with complimentary locker.',
            'is_active' => true,
        ]);

        $plan1Year = Plan::create([
            'name' => '1 Year VIP Annual Pass (365 Days)',
            'price' => 18000.00,
            'duration_days' => 365,
            'shift' => 'all',
            'description' => 'Ultimate 1-Year unlimited access pass with permanent seat reservation.',
            'is_active' => true,
        ]);

        $planMonthly = $plan1Month;

        // 7. Create Active Sample Bookings
        $booking1 = null;
        if ($reservedSeat) {
            $booking1 = Booking::create([
                'user_id' => $member->id,
                'seat_id' => $reservedSeat->id,
                'pass_code' => 'LIB-PASS-001',
                'shift' => 'morning',
                'booking_date' => date('Y-m-d'),
                'status' => 'active',
            ]);
        }

        if ($occupiedSeat) {
            Booking::create([
                'user_id' => $member2->id,
                'seat_id' => $occupiedSeat->id,
                'pass_code' => 'LIB-PASS-002',
                'shift' => 'full_day',
                'booking_date' => date('Y-m-d'),
                'status' => 'active',
            ]);
        }

        // 8. Sample Payment Transactions
        if ($booking1) {
            Payment::create([
                'user_id' => $member->id,
                'booking_id' => $booking1->id,
                'plan_id' => $planMorning->id,
                'collected_by' => $staff->id,
                'amount' => 80.00,
                'currency' => 'INR',
                'payment_method' => 'cash',
                'transaction_id' => 'TXN-CASH-1001',
                'status' => 'completed',
                'notes' => 'Counter cash payment paid to reception.',
            ]);
        }

        Payment::create([
            'user_id' => $member2->id,
            'booking_id' => null,
            'plan_id' => $planFullDay->id,
            'collected_by' => $staff->id,
            'amount' => 150.00,
            'currency' => 'INR',
            'payment_method' => 'upi',
            'transaction_id' => 'UPI-9822334455@okaxis-01',
            'status' => 'completed',
            'notes' => 'Direct QR scan UPI payment.',
        ]);

        Payment::create([
            'user_id' => $member3->id,
            'booking_id' => null,
            'plan_id' => $planMonthly->id,
            'collected_by' => null,
            'amount' => 2200.00,
            'currency' => 'INR',
            'payment_method' => 'online_razorpay',
            'transaction_id' => 'pay_rzp_'.substr(md5('rzp3'), 0, 14),
            'status' => 'completed',
            'notes' => 'Online payment via Razorpay checkout.',
        ]);

        // 9. Create Library Manager (Owner) and Sample Libraries
        $manager = User::create([
            'name' => 'Vikram Malhotra',
            'email' => 'manager@library.com',
            'phone' => '9822001122',
            'role' => 'manager',
            'status' => 'active',
            'password' => Hash::make('manager123'),
        ]);

        $manager2 = User::create([
            'name' => 'Sunil Deshmukh',
            'email' => 'sunil@studyhaven.in',
            'phone' => '9822003344',
            'role' => 'manager',
            'status' => 'active',
            'password' => Hash::make('manager123'),
        ]);

        $library1 = Library::create([
            'user_id' => $manager->id,
            'name' => 'Apex Central Study Hub',
            'slug' => 'apex-central-study-hub',
            'address' => '402 Prestige Point, Shukrawar Peth',
            'city' => 'Pune',
            'state' => 'Maharashtra',
            'pincode' => '411002',
            'phone' => '9822001122',
            'email' => 'contact@apexcentral.in',
            'description' => 'Premium air-conditioned study hall with high-speed WiFi and individual ergonomic seating.',
            'amenities' => ['High Speed WiFi', 'Air Conditioned', 'Power Outlets', 'RO Water Dispenser', 'CCTV Security'],
            'total_seats' => 60,
            'registration_fee' => 499.00,
            'payment_status' => 'paid',
            'status' => 'active',
        ]);

        $library2 = Library::create([
            'user_id' => $manager2->id,
            'name' => 'Study Haven Reading Room',
            'slug' => 'study-haven-reading-room',
            'address' => '12 Near Modern College, Shivajinagar',
            'city' => 'Pune',
            'state' => 'Maharashtra',
            'pincode' => '411005',
            'phone' => '9822003344',
            'email' => 'info@studyhaven.in',
            'description' => 'Dedicated silent reading room designed for UPSC and competitive exam aspirants.',
            'amenities' => ['Silent Zones', 'Newspaper Desk', 'Lockers', 'Power Sockets'],
            'total_seats' => 40,
            'registration_fee' => 499.00,
            'payment_status' => 'unpaid',
            'status' => 'pending_payment',
        ]);

        // Associate existing seats with library1
        Seat::whereNull('library_id')->update(['library_id' => $library1->id]);

        // 10. Seed Facilities for Library
        $facilities = [
            ['name' => 'High-Speed Wi-Fi', 'category' => 'wifi', 'status' => 'available', 'details' => '150 Mbps Fiber (Dual Band 5GHz & 2.4GHz)', 'icon' => 'wifi'],
            ['name' => 'Charging Points', 'category' => 'charging', 'status' => 'available', 'details' => 'Universal socket available at all individual study desks', 'icon' => 'zap'],
            ['name' => 'Personal Lockers', 'category' => 'locker', 'status' => 'available', 'details' => '18 of 24 Lockers Available for allotment', 'icon' => 'lock'],
            ['name' => 'AC & Air Cooling', 'category' => 'ac_cooler', 'status' => 'available', 'details' => 'Central Air Conditioners active (22°C maintained)', 'icon' => 'wind'],
            ['name' => 'Drinking Water / Aqua', 'category' => 'water', 'status' => 'available', 'details' => 'Aquaguard RO filtered cold and regular drinking water', 'icon' => 'droplet'],
            ['name' => 'Washroom (Gents)', 'category' => 'washroom_gents', 'status' => 'available', 'details' => 'Hygienic and sanitized regularly (Last checked 25m ago)', 'icon' => 'user'],
            ['name' => 'Washroom (Ladies)', 'category' => 'washroom_ladies', 'status' => 'available', 'details' => 'Clean, sanitized, and well-maintained', 'icon' => 'user-check'],
        ];

        foreach ($facilities as $f) {
            Facility::create(array_merge($f, [
                'library_id' => $library1->id,
                'last_checked_at' => now(),
            ]));
        }

        // 11. Study Room Rules & Notices
        $rulesAndNotices = [
            ['title' => 'Strict Silence in Study Halls', 'content' => 'Pin-drop silence must be maintained in the study hall at all times. Whispering and discussions are prohibited.', 'type' => 'rule', 'priority' => 'important'],
            ['title' => 'Mobile Phones Must Be on Silent', 'content' => 'All phone calls must be attended outside the study area in the designated balcony zone.', 'type' => 'rule', 'priority' => 'important'],
            ['title' => 'Clean Desk & Waste Disposal', 'content' => 'Please clear all papers and bottles into dustbins before leaving your desk.', 'type' => 'rule', 'priority' => 'normal'],
            ['title' => 'No Food / Beverages in Study Hall', 'content' => 'Snacks and lunch are only allowed in the student cafeteria / breakout lounge.', 'type' => 'rule', 'priority' => 'normal'],
            ['title' => 'Operating Hours Notice', 'content' => 'Morning Slot: 8:00 AM - 2:00 PM | Evening Slot: 2:00 PM - 8:00 PM | Full Day: 8:00 AM - 10:00 PM.', 'type' => 'timing', 'priority' => 'important'],
            ['title' => 'Campus High-Speed Wi-Fi Upgraded', 'content' => 'We upgraded to 150 Mbps fiber broadband. Log in with your registered phone number.', 'type' => 'notice', 'priority' => 'normal'],
        ];

        foreach ($rulesAndNotices as $rn) {
            Notice::create(array_merge($rn, [
                'library_id' => $library1->id,
                'is_active' => true,
            ]));
        }

        // 12. Active Membership Subscriptions (1 Month & 3 Months)
        Subscription::create([
            'user_id' => $member->id,
            'plan_id' => $plan1Month->id,
            'library_id' => $library1->id,
            'seat_id' => $reservedSeat?->id,
            'start_date' => now()->subDays(20)->toDateString(),
            'end_date' => now()->addDays(10)->toDateString(), // 10 days remaining
            'status' => 'active',
            'auto_renew' => true,
        ]);

        Subscription::create([
            'user_id' => $member2->id,
            'plan_id' => $plan3Months->id,
            'library_id' => $library1->id,
            'seat_id' => $occupiedSeat?->id,
            'start_date' => now()->subDays(87)->toDateString(),
            'end_date' => now()->addDays(3)->toDateString(), // 3 days remaining (triggers 3-day reminder!)
            'status' => 'active',
            'auto_renew' => false,
        ]);

        // 13. Study Hours & Attendance Sessions (Today)
        Attendance::create([
            'user_id' => $member->id,
            'library_id' => $library1->id,
            'booking_id' => $booking1?->id,
            'check_in_at' => now()->subHours(4),
            'check_out_at' => now()->subHours(1),
            'duration_minutes' => 180, // 3 hours
            'date' => now()->toDateString(),
            'status' => 'checked_out',
        ]);

        Attendance::create([
            'user_id' => $member->id,
            'library_id' => $library1->id,
            'booking_id' => $booking1?->id,
            'check_in_at' => now()->subMinutes(45),
            'check_out_at' => null,
            'duration_minutes' => 0,
            'date' => now()->toDateString(),
            'status' => 'checked_in', // Ongoing 45 min session
        ]);

        // 14. Waiting List
        WaitingList::create([
            'user_id' => $member3->id,
            'library_id' => $library1->id,
            'shift' => 'morning',
            'desired_date' => now()->toDateString(),
            'status' => 'waiting',
        ]);

        // 15. Smart Vacancy Alert (Urgent 5-minute countdown window)
        $freeSeat = Seat::where('status', 'available')->first();
        if ($freeSeat) {
            SmartVacancyAlert::create([
                'library_id' => $library1->id,
                'seat_id' => $freeSeat->id,
                'shift' => 'full_day',
                'alert_date' => now()->toDateString(),
                'title' => 'Library Seat Available!',
                'message' => "Seat {$freeSeat->seat_number} is now available! Book within 5 minutes.",
                'expires_at' => now()->addMinutes(5),
                'status' => 'active',
            ]);
        }

        // 16. Complaints / Feedback
        Complaint::create([
            'user_id' => $member->id,
            'library_id' => $library1->id,
            'seat_id' => $reservedSeat?->id,
            'category' => 'ac_cooler',
            'subject' => 'AC Temperature too low near desk G-03',
            'description' => 'The AC vent right above seat G-03 is blowing directly. Kindly adjust temperature to 24°C.',
            'status' => 'resolved',
            'admin_remark' => 'AC vent deflector adjusted and temperature set to 23°C.',
        ]);

        Complaint::create([
            'user_id' => $member2->id,
            'library_id' => $library1->id,
            'seat_id' => $occupiedSeat?->id,
            'category' => 'wifi',
            'subject' => 'Intermittent Wi-Fi on 2nd Floor',
            'description' => 'Speed dropped below 10 Mbps around 3 PM today.',
            'status' => 'in_progress',
            'admin_remark' => 'Network engineer is resetting the second floor access point.',
        ]);

        // 17. In-App Notifications (Auto Fee Reminders, Smart Vacancy Alerts)
        Notification::create([
            'user_id' => $member2->id,
            'title' => 'Fee Reminder: 3 Days Left',
            'message' => 'Reminder: Only 3 days left before your 3 Months Prime Pass subscription expires. Renew to retain your desk.',
            'type' => 'fee_reminder',
            'badge' => 'Reminder',
            'data' => ['days_remaining' => 3, 'plan_name' => '3 Months Prime Pass'],
            'is_read' => false,
        ]);

        if ($freeSeat) {
            Notification::create([
                'user_id' => $member->id,
                'title' => 'Library Seat Available!',
                'message' => "Seat {$freeSeat->seat_number} is now available! Book within 5 minutes.",
                'type' => 'smart_vacancy_alert',
                'badge' => 'New',
                'data' => [
                    'seat_number' => $freeSeat->seat_number,
                    'booking_window_minutes' => 5,
                ],
                'is_read' => false,
            ]);
        }

    }
}
