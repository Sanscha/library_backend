<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Plan extends Model
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
        'price',
        'duration_days',
        'shift',
        'description',
        'is_active',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'is_active' => 'boolean',
            'duration_days' => 'integer',
        ];
    }

    /**
     * Get the library that owns this plan (null for global plans).
     */
    public function library(): BelongsTo
    {
        return $this->belongsTo(Library::class);
    }

    /**
     * Get the payments associated with this plan.
     */
    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class);
    }

    /**
     * Seed or return default membership plans for a specific library.
     *
     * @return Collection<int, Plan>
     */
    public static function seedDefaultsForLibrary(int $libraryId): Collection
    {
        $defaults = [
            [
                'name' => '1 Month Pass',
                'price' => 2000.00,
                'duration_days' => 30,
                'shift' => 'all',
                'description' => 'Dedicated seat access with all facilities for 1 Month.',
                'is_active' => true,
            ],
            [
                'name' => '3 Months Prime Pass',
                'price' => 5400.00,
                'duration_days' => 90,
                'shift' => 'all',
                'description' => 'Quarterly pass with priority seat reservation.',
                'is_active' => true,
            ],
            [
                'name' => '6 Months Executive Pass',
                'price' => 9900.00,
                'duration_days' => 180,
                'shift' => 'all',
                'description' => 'Half-yearly pass for competitive exam preparation.',
                'is_active' => true,
            ],
            [
                'name' => '1 Year Annual Pass',
                'price' => 18000.00,
                'duration_days' => 365,
                'shift' => 'all',
                'description' => 'Annual unlimited study access pass.',
                'is_active' => true,
            ],
        ];

        foreach ($defaults as $data) {
            static::create(array_merge($data, ['library_id' => $libraryId]));
        }

        return static::where('library_id', $libraryId)->orderBy('duration_days')->get();
    }
}
