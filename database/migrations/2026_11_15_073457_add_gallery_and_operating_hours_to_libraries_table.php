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
        Schema::table('libraries', function (Blueprint $table) {
            if (! Schema::hasColumn('libraries', 'gallery')) {
                $table->json('gallery')->nullable()->after('image');
            }
            if (! Schema::hasColumn('libraries', 'operating_hours')) {
                $table->json('operating_hours')->nullable()->after('amenities');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('libraries', function (Blueprint $table) {
            if (Schema::hasColumn('libraries', 'operating_hours')) {
                $table->dropColumn('operating_hours');
            }
            if (Schema::hasColumn('libraries', 'gallery')) {
                $table->dropColumn('gallery');
            }
        });
    }
};
