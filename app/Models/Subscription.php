<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Subscription extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'user_id',
        'plan_id',
        'library_id',
        'seat_id',
        'start_date',
        'end_date',
        'status',
        'auto_renew',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'start_date' => 'date',
            'end_date' => 'date',
            'auto_renew' => 'boolean',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function plan(): BelongsTo
    {
        return $this->belongsTo(Plan::class);
    }

    public function library(): BelongsTo
    {
        return $this->belongsTo(Library::class);
    }

    public function seat(): BelongsTo
    {
        return $this->belongsTo(Seat::class);
    }

    /**
     * Calculate days remaining until expiry.
     */
    public function daysRemaining(): int
    {
        if (! $this->end_date) {
            return 0;
        }

        $today = Carbon::today();
        $end = Carbon::parse($this->end_date);

        if ($end->lt($today)) {
            return 0;
        }

        return (int) $today->diffInDays($end, false);
    }

    /**
     * Check if subscription is actively valid.
     */
    public function isActive(): bool
    {
        return $this->status === 'active' && $this->daysRemaining() >= 0;
    }
}
