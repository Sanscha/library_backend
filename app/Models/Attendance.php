<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Attendance extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'user_id',
        'library_id',
        'booking_id',
        'check_in_at',
        'check_out_at',
        'duration_minutes',
        'date',
        'status',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'check_in_at' => 'datetime',
            'check_out_at' => 'datetime',
            'date' => 'date',
            'duration_minutes' => 'integer',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function library(): BelongsTo
    {
        return $this->belongsTo(Library::class);
    }

    public function booking(): BelongsTo
    {
        return $this->belongsTo(Booking::class);
    }

    /**
     * Calculate and save duration in minutes on checkout.
     */
    public function recordCheckout(): void
    {
        $now = Carbon::now();
        $this->check_out_at = $now;
        $this->status = 'checked_out';

        if ($this->check_in_at) {
            $this->duration_minutes = (int) $this->check_in_at->diffInMinutes($now);
        }

        $this->save();
    }
}
