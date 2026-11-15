<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. Membership Subscriptions (1 Month, 3 Months, 6 Months, 1 Year)
        Schema::create('subscriptions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('plan_id')->constrained('plans')->onDelete('cascade');
            $table->foreignId('library_id')->nullable()->constrained('libraries')->onDelete('set null');
            $table->foreignId('seat_id')->nullable()->constrained('seats')->onDelete('set null');
            $table->date('start_date');
            $table->date('end_date'); // Expiry Date
            $table->enum('status', ['active', 'expired', 'cancelled', 'pending_payment'])->default('active');
            $table->boolean('auto_renew')->default(false);
            $table->timestamps();
        });

        // 2. Add expires_at column to bookings if not exists
        if (! Schema::hasColumn('bookings', 'expires_at')) {
            Schema::table('bookings', function (Blueprint $table) {
                $table->timestamp('expires_at')->nullable()->after('booking_date');
            });
        }

        // 3. QR Entry / Exit & Study Hours (Attendance Sessions)
        Schema::create('attendances', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('library_id')->nullable()->constrained('libraries')->onDelete('set null');
            $table->foreignId('booking_id')->nullable()->constrained('bookings')->onDelete('set null');
            $table->timestamp('check_in_at');
            $table->timestamp('check_out_at')->nullable();
            $table->integer('duration_minutes')->default(0);
            $table->date('date')->index();
            $table->enum('status', ['checked_in', 'checked_out'])->default('checked_in');
            $table->timestamps();
        });

        // 4. Vacant Seat Alert Waiting List
        Schema::create('waiting_lists', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('library_id')->nullable()->constrained('libraries')->onDelete('cascade');
            $table->foreignId('zone_id')->nullable()->constrained('zones')->onDelete('set null');
            $table->foreignId('seat_id')->nullable()->constrained('seats')->onDelete('set null');
            $table->enum('shift', ['morning', 'evening', 'full_day', 'any'])->default('full_day');
            $table->date('desired_date')->index();
            $table->enum('status', ['waiting', 'notified', 'fulfilled', 'cancelled'])->default('waiting');
            $table->timestamps();
        });

        // 5. Facility Availability (Wi-Fi, Charging, Lockers, AC/Cooler, Water, Washrooms Gents/Ladies)
        Schema::create('facilities', function (Blueprint $table) {
            $table->id();
            $table->foreignId('library_id')->nullable()->constrained('libraries')->onDelete('cascade');
            $table->string('name'); // e.g., 'High-Speed Wi-Fi', 'AC & Air Cooling'
            $table->enum('category', [
                'wifi',
                'charging',
                'locker',
                'ac_cooler',
                'water',
                'washroom_gents',
                'washroom_ladies',
                'other',
            ]);
            $table->enum('status', ['available', 'limited', 'unavailable', 'maintenance'])->default('available');
            $table->string('details')->nullable(); // e.g., '150 Mbps 5GHz', '12 Lockers Available'
            $table->string('icon')->nullable();
            $table->timestamp('last_checked_at')->nullable();
            $table->timestamps();
        });

        // 6. Smart Vacancy Alerts (Urgent 5-minute booking window upon seat cancellation)
        Schema::create('smart_vacancy_alerts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('library_id')->nullable()->constrained('libraries')->onDelete('cascade');
            $table->foreignId('seat_id')->constrained('seats')->onDelete('cascade');
            $table->enum('shift', ['morning', 'evening', 'full_day'])->default('full_day');
            $table->date('alert_date')->index();
            $table->string('title')->default('Library Seat Available!');
            $table->text('message');
            $table->timestamp('expires_at'); // 5 minutes window
            $table->enum('status', ['active', 'claimed', 'expired'])->default('active');
            $table->foreignId('claimed_by')->nullable()->constrained('users')->onDelete('set null');
            $table->timestamps();
        });

        // 7. Study Room Rules & Notices
        Schema::create('notices', function (Blueprint $table) {
            $table->id();
            $table->foreignId('library_id')->nullable()->constrained('libraries')->onDelete('cascade');
            $table->string('title');
            $table->text('content');
            $table->enum('type', ['rule', 'notice', 'announcement', 'timing'])->default('notice');
            $table->enum('priority', ['normal', 'important', 'urgent'])->default('normal');
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // 8. Complaints & Feedback
        Schema::create('complaints', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('library_id')->nullable()->constrained('libraries')->onDelete('set null');
            $table->foreignId('seat_id')->nullable()->constrained('seats')->onDelete('set null');
            $table->enum('category', [
                'cleanliness',
                'noise',
                'ac_cooler',
                'wifi',
                'charging_point',
                'water',
                'washroom',
                'seat_issue',
                'other',
            ])->default('other');
            $table->string('subject');
            $table->text('description');
            $table->enum('status', ['pending', 'in_progress', 'resolved', 'closed'])->default('pending');
            $table->text('admin_remark')->nullable();
            $table->timestamps();
        });

        // 9. In-App Notifications (Auto Fee Reminders, Vacant Alerts, Payment Reminders)
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('title');
            $table->text('message');
            $table->enum('type', [
                'fee_reminder',
                'pending_payment',
                'vacant_seat',
                'smart_vacancy_alert',
                'notice',
                'general',
            ])->default('general');
            $table->string('badge')->nullable(); // e.g. 'New', 'Urgent', 'Reminder'
            $table->json('data')->nullable();
            $table->boolean('is_read')->default(false);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('notifications');
        Schema::dropIfExists('complaints');
        Schema::dropIfExists('notices');
        Schema::dropIfExists('smart_vacancy_alerts');
        Schema::dropIfExists('facilities');
        Schema::dropIfExists('waiting_lists');
        Schema::dropIfExists('attendances');

        if (Schema::hasColumn('bookings', 'expires_at')) {
            Schema::table('bookings', function (Blueprint $table) {
                $table->dropColumn('expires_at');
            });
        }

        Schema::dropIfExists('subscriptions');
    }
};
