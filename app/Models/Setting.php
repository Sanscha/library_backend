<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'key',
        'value',
        'group',
        'description',
    ];

    /**
     * Retrieve a setting value by key, with optional fallback default.
     */
    public static function get(string $key, mixed $default = null): mixed
    {
        $setting = static::where('key', $key)->first();

        if (! $setting || $setting->value === null) {
            return $default;
        }

        return $setting->value;
    }

    /**
     * Set / update a setting value.
     */
    public static function set(string $key, mixed $value, string $group = 'general', ?string $description = null): self
    {
        return static::updateOrCreate(
            ['key' => $key],
            [
                'value' => (string) $value,
                'group' => $group,
                'description' => $description,
            ]
        );
    }

    /**
     * Get all settings grouped or as an associative array.
     *
     * @return array<string, mixed>
     */
    public static function getAll(): array
    {
        $defaults = [
            'library_registration_fee' => '999.00',
            'platform_name' => 'SeatSync',
            'support_email' => 'support@seatsync.com',
            'support_phone' => '+91 9876543210',
            'currency' => 'INR',
        ];

        $settings = static::pluck('value', 'key')->all();

        return array_merge($defaults, $settings);
    }
}
