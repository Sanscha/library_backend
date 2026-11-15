<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Facility extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'library_id',
        'name',
        'category',
        'status',
        'details',
        'icon',
        'last_checked_at',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'last_checked_at' => 'datetime',
        ];
    }

    public function library(): BelongsTo
    {
        return $this->belongsTo(Library::class);
    }

    /**
     * Seed or return standard default facilities for a library.
     *
     * @return Collection<int, Facility>
     */
    public static function seedDefaultsForLibrary(int $libraryId): Collection
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
            static::create(array_merge($item, [
                'library_id' => $libraryId,
                'last_checked_at' => now(),
            ]));
        }

        return static::where('library_id', $libraryId)->get();
    }
}
