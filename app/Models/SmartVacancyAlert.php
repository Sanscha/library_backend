<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SmartVacancyAlert extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'library_id',
        'seat_id',
        'shift',
        'alert_date',
        'title',
        'message',
        'expires_at',
        'status',
        'claimed_by',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'alert_date' => 'date',
            'expires_at' => 'datetime',
        ];
    }

    public function library(): BelongsTo
    {
        return $this->belongsTo(Library::class);
    }

    public function seat(): BelongsTo
    {
        return $this->belongsTo(Seat::class);
    }

    public function claimedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'claimed_by');
    }

    /**
     * Check if 5-minute alert has expired.
     */
    public function isExpired(): bool
    {
        return Carbon::now()->greaterThan($this->expires_at);
    }

    /**
     * Remaining seconds inside the 5-minute countdown window.
     */
    public function secondsRemaining(): int
    {
        if ($this->isExpired()) {
            return 0;
        }

        return max(0, (int) Carbon::now()->diffInSeconds($this->expires_at, false));
    }
}
