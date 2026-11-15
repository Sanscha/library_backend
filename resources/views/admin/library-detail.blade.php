@extends('layouts.admin')

@section('title', $library->name . ' - Library Details')

@section('content')

    <!-- Header & Navigation -->
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px; flex-wrap:wrap; gap:12px;">
        <div style="display:flex; align-items:center; gap:12px;">
            <a href="{{ route('admin.libraries') }}" class="btn btn-secondary btn-sm" style="display:inline-flex; align-items:center; gap:6px;">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M15 19l-7-7 7-7"/></svg>
                Back to Libraries
            </a>
            <div>
                <h1 style="font-size:22px; font-weight:600; color:var(--text-primary); margin:0;">
                    {{ $library->name }}
                </h1>
                <div style="font-size:12px; color:var(--text-muted); margin-top:2px;">
                    Slug: <code>{{ $library->slug }}</code> &bull; Added {{ $library->created_at->format('M d, Y') }}
                </div>
            </div>
        </div>

        <div style="display:flex; align-items:center; gap:8px;">
            <span class="badge badge-{{ $library->status }}">
                {{ str_replace('_', ' ', $library->status) }}
            </span>
            <span class="badge badge-{{ $library->payment_status }}">
                {{ $library->payment_status === 'paid' ? 'Fee Paid' : 'Fee Pending' }}
            </span>

            @if($library->payment_status !== 'paid')
                <form action="{{ route('admin.libraries.verify-payment', $library->id) }}" method="POST" style="display:inline;">
                    @csrf
                    <button type="submit" class="btn btn-primary btn-sm" onclick="return confirm('Verify payment and activate {{ $library->name }}?')">
                        Verify Fee
                    </button>
                </form>
            @endif

            <form action="{{ route('admin.libraries.toggle-status', $library->id) }}" method="POST" style="display:inline;">
                @csrf
                <button type="submit" class="btn btn-secondary btn-sm" onclick="return confirm('Toggle status for {{ $library->name }}?')">
                    {{ $library->status === 'active' ? 'Suspend Library' : 'Activate Library' }}
                </button>
            </form>
        </div>
    </div>

    <!-- Seat Statistics Row -->
    <div class="grid grid-cols-4" style="margin-bottom: 24px;">
        <div class="card" style="padding: 16px 20px;">
            <div style="font-size:12px; font-weight:500; color:var(--text-muted);">Total Capacity</div>
            <div style="font-size:24px; font-weight:600; margin-top:4px; color:var(--text-primary);">{{ $seatStats['total'] }} Seats</div>
            <div style="margin-top:6px; font-size:12px; color:var(--text-muted);">Declared capacity</div>
        </div>

        <div class="card" style="padding: 16px 20px;">
            <div style="font-size:12px; font-weight:500; color:var(--text-muted);">Available Seats</div>
            <div style="font-size:24px; font-weight:600; margin-top:4px; color:#15803d;">{{ $seatStats['available'] }}</div>
            <div style="margin-top:6px; font-size:12px; color:var(--text-muted);">Ready for student booking</div>
        </div>

        <div class="card" style="padding: 16px 20px;">
            <div style="font-size:12px; font-weight:500; color:var(--text-muted);">Occupied / Reserved</div>
            <div style="font-size:24px; font-weight:600; margin-top:4px; color:#b45309;">{{ $seatStats['occupied'] + $seatStats['reserved'] }}</div>
            <div style="margin-top:6px; font-size:12px; color:var(--text-muted);">Active study sessions</div>
        </div>

        <div class="card" style="padding: 16px 20px;">
            <div style="font-size:12px; font-weight:500; color:var(--text-muted);">Maintenance / Blocked</div>
            <div style="font-size:24px; font-weight:600; margin-top:4px; color:var(--danger);">{{ $seatStats['maintenance'] }}</div>
            <div style="margin-top:6px; font-size:12px; color:var(--text-muted);">Under maintenance</div>
        </div>
    </div>

    <div style="display:grid; grid-template-columns: 2fr 1fr; gap:24px; margin-bottom:24px;">
        <!-- Left Column: Photos, Listing Info, Timings, Facilities -->
        <div style="display:flex; flex-direction:column; gap:24px;">

            <!-- Photos & Gallery Section -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">Listing Photos & Gallery</div>
                    <span style="font-size:12px; color:var(--text-muted);">Uploaded by Library Owner</span>
                </div>
                <div class="card-body">
                    <!-- Main Cover Photo -->
                    <div style="margin-bottom:16px;">
                        <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600; display:block; margin-bottom:6px;">Cover Photo</label>
                        @if($library->image)
                            <div style="max-width:380px; height:180px; border-radius:8px; overflow:hidden; border:1px solid var(--border-color); background:#f8fafc;">
                                <img src="{{ str_starts_with($library->image, 'http') ? $library->image : asset('storage/' . $library->image) }}" alt="Cover Photo" style="width:100%; height:100%; object-fit:cover;">
                            </div>
                        @else
                            <div style="padding:20px; background:#f8fafc; border:1px dashed var(--border-color); border-radius:8px; color:var(--text-muted); font-size:13px; text-align:center;">
                                No cover photo uploaded by owner.
                            </div>
                        @endif
                    </div>

                    <!-- Gallery Photos -->
                    <div>
                        <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600; display:block; margin-bottom:6px;">
                            Gallery Photos ({{ is_array($library->gallery) ? count($library->gallery) : 0 }})
                        </label>
                        @if(!empty($library->gallery) && count($library->gallery) > 0)
                            <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(130px, 1fr)); gap:10px;">
                                @foreach($library->gallery as $photo)
                                    <div style="height:100px; border-radius:6px; overflow:hidden; border:1px solid var(--border-color); background:#f8fafc;">
                                        <img src="{{ str_starts_with($photo, 'http') ? $photo : asset('storage/' . $photo) }}" alt="Gallery photo" style="width:100%; height:100%; object-fit:cover;">
                                    </div>
                                @endforeach
                            </div>
                        @else
                            <div style="padding:16px; background:#f8fafc; border:1px dashed var(--border-color); border-radius:8px; color:var(--text-muted); font-size:12px; text-align:center;">
                                No gallery photos uploaded yet.
                            </div>
                        @endif
                    </div>
                </div>
            </div>

            <!-- Operating Hours & Shift Timings -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">Library Operating Hours & Shift Timings</div>
                    <span style="font-size:12px; color:var(--text-muted);">Owner Managed</span>
                </div>
                <div class="card-body">
                    @php
                        $timings = $library->operating_hours ?? [
                            'opening_time' => '07:00',
                            'closing_time' => '22:00',
                            'days_open' => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                            'shifts' => [
                                'morning' => ['start' => '07:00', 'end' => '13:00', 'label' => 'Morning Shift'],
                                'evening' => ['start' => '13:00', 'end' => '19:00', 'label' => 'Evening Shift'],
                                'full_day' => ['start' => '07:00', 'end' => '22:00', 'label' => 'Full Day'],
                            ],
                            'notes' => 'Open 7 days a week.',
                        ];
                    @endphp

                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:16px; margin-bottom:16px;">
                        <div style="padding:12px; background:#f8fafc; border-radius:6px; border:1px solid var(--border-color);">
                            <div style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Daily Operating Hours</div>
                            <div style="font-size:16px; font-weight:600; color:var(--text-primary); margin-top:4px;">
                                {{ $timings['opening_time'] ?? '07:00' }} &mdash; {{ $timings['closing_time'] ?? '22:00' }}
                            </div>
                        </div>

                        <div style="padding:12px; background:#f8fafc; border-radius:6px; border:1px solid var(--border-color);">
                            <div style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Days Open</div>
                            <div style="font-size:13px; font-weight:500; color:var(--text-primary); margin-top:4px;">
                                @if(is_array($timings['days_open'] ?? null))
                                    {{ implode(', ', $timings['days_open']) }}
                                @else
                                    {{ $timings['days_open'] ?? 'Monday to Sunday' }}
                                @endif
                            </div>
                        </div>
                    </div>

                    <!-- Shifts -->
                    <div>
                        <div style="font-size:12px; font-weight:600; color:var(--text-primary); margin-bottom:8px;">Configured Shift Slots:</div>
                        <div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:10px;">
                            <div style="padding:10px; border-radius:6px; border:1px solid #bfdbfe; background:#eff6ff;">
                                <div style="font-size:11px; font-weight:600; color:#1e40af;">Morning Shift</div>
                                <div style="font-size:13px; font-weight:600; color:#1e3a8a; margin-top:2px;">
                                    {{ $timings['shifts']['morning']['start'] ?? '07:00' }} - {{ $timings['shifts']['morning']['end'] ?? '13:00' }}
                                </div>
                            </div>

                            <div style="padding:10px; border-radius:6px; border:1px solid #fed7aa; background:#fff7ed;">
                                <div style="font-size:11px; font-weight:600; color:#9a3412;">Evening Shift</div>
                                <div style="font-size:13px; font-weight:600; color:#7c2d12; margin-top:2px;">
                                    {{ $timings['shifts']['evening']['start'] ?? '13:00' }} - {{ $timings['shifts']['evening']['end'] ?? '19:00' }}
                                </div>
                            </div>

                            <div style="padding:10px; border-radius:6px; border:1px solid #bbf7d0; background:#f0fdf4;">
                                <div style="font-size:11px; font-weight:600; color:#166534;">Full Day</div>
                                <div style="font-size:13px; font-weight:600; color:#14532d; margin-top:2px;">
                                    {{ $timings['shifts']['full_day']['start'] ?? '07:00' }} - {{ $timings['shifts']['full_day']['end'] ?? '22:00' }}
                                </div>
                            </div>
                        </div>
                    </div>

                    @if(!empty($timings['notes']))
                        <div style="margin-top:12px; font-size:12px; color:var(--text-muted); font-style:italic;">
                            Note: {{ $timings['notes'] }}
                        </div>
                    @endif
                </div>
            </div>

            <!-- Suvidha / Facilities Available -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">Library Suvidha (Facilities & Amenities)</div>
                    <span style="font-size:12px; color:var(--text-muted);">Real-time Status</span>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Facility</th>
                                <th>Category</th>
                                <th>Live Status</th>
                                <th>Details</th>
                                <th>Last Checked</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($library->facilities as $fac)
                                <tr>
                                    <td>
                                        <div style="font-weight:500; color:var(--text-primary);">{{ $fac->name }}</div>
                                    </td>
                                    <td>
                                        <span style="font-size:12px; color:var(--text-muted); text-transform:capitalize;">
                                            {{ str_replace('_', ' ', $fac->category) }}
                                        </span>
                                    </td>
                                    <td>
                                        @if($fac->status === 'available')
                                            <span class="badge" style="background:#f0fdf4; color:#15803d; border:1px solid #bbf7d0;">Available</span>
                                        @elseif($fac->status === 'limited')
                                            <span class="badge" style="background:#fffbeb; color:#b45309; border:1px solid #fde68a;">Limited</span>
                                        @elseif($fac->status === 'maintenance')
                                            <span class="badge" style="background:#fef2f2; color:#b91c1c; border:1px solid #fecaca;">Maintenance</span>
                                        @else
                                            <span class="badge" style="background:#f1f5f9; color:#64748b; border:1px solid #e2e8f0;">Unavailable</span>
                                        @endif
                                    </td>
                                    <td>
                                        <div style="font-size:12.5px; color:var(--text-secondary);">
                                            {{ $fac->details ?? 'N/A' }}
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-size:11.5px; color:var(--text-muted);">
                                            {{ $fac->last_checked_at ? $fac->last_checked_at->diffForHumans() : 'Recently' }}
                                        </div>
                                    </td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="5" style="text-align:center; padding:20px; color:var(--text-muted);">
                                        No facilities recorded yet.
                                    </td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Seat Availability Breakdown & Layout -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">Seat Availability & Layout ({{ $library->seats->count() }})</div>
                    <span style="font-size:12px; color:var(--text-muted);">Managed by Library Owner</span>
                </div>
                <div class="card-body">
                    <div style="display:flex; flex-wrap:wrap; gap:8px;">
                        @forelse($library->seats as $seat)
                            <div style="
                                width:56px; 
                                height:52px; 
                                border-radius:6px; 
                                display:flex; 
                                flex-direction:column; 
                                align-items:center; 
                                justify-content:center;
                                font-weight:600;
                                font-size:12px;
                                border:1px solid;
                                @if($seat->status === 'available')
                                    background:#f0fdf4; border-color:#86efac; color:#15803d;
                                @elseif($seat->status === 'occupied')
                                    background:#fef2f2; border-color:#fca5a5; color:#b91c1c;
                                @elseif($seat->status === 'reserved')
                                    background:#fffbeb; border-color:#fde68a; color:#b45309;
                                @else
                                    background:#f1f5f9; border-color:#cbd5e1; color:#64748b;
                                @endif
                            " title="Seat {{ $seat->seat_number }} ({{ $seat->status }})">
                                <div>{{ $seat->seat_number }}</div>
                                <div style="font-size:9px; text-transform:uppercase; font-weight:500;">
                                    {{ substr($seat->status, 0, 3) }}
                                </div>
                            </div>
                        @empty
                            <div style="padding:20px; text-align:center; color:var(--text-muted); width:100%;">
                                No seats configured by the library owner yet.
                            </div>
                        @endforelse
                    </div>
                </div>
            </div>

        </div>

        <!-- Right Column: Owner Profile & Listing Info -->
        <div style="display:flex; flex-direction:column; gap:24px;">

            <!-- Owner / Manager Profile Card -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">Library Owner / Manager</div>
                </div>
                <div class="card-body">
                    @if($library->owner)
                        <div style="display:flex; align-items:center; gap:12px; margin-bottom:14px;">
                            <div style="width:44px; height:44px; border-radius:50%; background:#eff6ff; color:#2563eb; display:flex; align-items:center; justify-content:center; font-weight:600; font-size:16px; border:1px solid #bfdbfe;">
                                {{ strtoupper(substr($library->owner->name, 0, 1)) }}
                            </div>
                            <div>
                                <div style="font-weight:600; color:var(--text-primary); font-size:15px;">{{ $library->owner->name }}</div>
                                <div style="font-size:12px; color:var(--text-muted);">Library Owner Account</div>
                            </div>
                        </div>

                        <div style="display:flex; flex-direction:column; gap:10px; font-size:13px;">
                            <div>
                                <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Email</label>
                                <div style="color:var(--text-primary); margin-top:2px;">
                                    {{ $library->owner->email }}
                                    @if($library->owner->isEmailVerified())
                                        <span style="color:#15803d; font-size:11px; font-weight:600;">(Verified)</span>
                                    @else
                                        <span style="color:#b45309; font-size:11px;">(Unverified OTP)</span>
                                    @endif
                                </div>
                            </div>

                            <div>
                                <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Phone</label>
                                <div style="color:var(--text-primary); margin-top:2px;">
                                    {{ $library->owner->phone ?? 'N/A' }}
                                </div>
                            </div>

                            <div>
                                <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Account Status</label>
                                <div style="margin-top:2px;">
                                    <span class="badge badge-{{ $library->owner->status }}">
                                        {{ ucfirst($library->owner->status ?? 'active') }}
                                    </span>
                                </div>
                            </div>

                            <div>
                                <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Registered On</label>
                                <div style="color:var(--text-primary); margin-top:2px;">
                                    {{ $library->owner->created_at->format('M d, Y h:i A') }}
                                </div>
                            </div>
                        </div>
                    @else
                        <div style="color:var(--text-muted); font-size:13px;">
                            No owner account currently associated.
                        </div>
                    @endif
                </div>
            </div>

            <!-- Listing Details -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">Listing Address & Contact</div>
                </div>
                <div class="card-body">
                    <div style="display:flex; flex-direction:column; gap:12px; font-size:13px;">
                        <div>
                            <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Address</label>
                            <div style="color:var(--text-primary); margin-top:2px; line-height:1.4;">
                                {{ $library->address }}<br>
                                {{ $library->city ?? '' }}{{ $library->state ? ', ' . $library->state : '' }} {{ $library->pincode ?? '' }}
                            </div>
                        </div>

                        <div>
                            <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">GPS Coordinates</label>
                            <div style="color:var(--text-primary); margin-top:2px;">
                                Lat: {{ $library->latitude ?? 'N/A' }} &bull; Lng: {{ $library->longitude ?? 'N/A' }}
                            </div>
                        </div>

                        <div>
                            <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Listing Contact</label>
                            <div style="color:var(--text-primary); margin-top:2px;">
                                Phone: {{ $library->phone ?? 'N/A' }}<br>
                                Email: {{ $library->email ?? 'N/A' }}
                            </div>
                        </div>

                        <div>
                            <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">One-Time Onboarding Fee</label>
                            <div style="font-size:18px; font-weight:700; color:var(--text-primary); margin-top:2px;">
                                ₹{{ number_format($library->registration_fee, 2) }}
                            </div>
                            <form action="{{ route('admin.libraries.update-fee', $library->id) }}" method="POST" style="margin-top:8px; display:flex; gap:8px; align-items:center;">
                                @csrf
                                <div style="width:130px;">
                                    <input type="number" step="0.01" min="0" name="registration_fee" value="{{ $library->registration_fee }}" class="form-control" style="padding:5px 8px; font-size:13px; font-weight:600;" required>
                                </div>
                                <button type="submit" class="btn btn-secondary btn-sm" style="padding:5px 12px;">Save Fee</button>
                            </form>
                        </div>

                        <div>
                            <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Amenities Tagged</label>
                            <div style="display:flex; flex-wrap:wrap; gap:6px; margin-top:4px;">
                                @if(is_array($library->amenities) && count($library->amenities) > 0)
                                    @foreach($library->amenities as $amenity)
                                        <span style="background:#f1f5f9; padding:2px 8px; border-radius:4px; font-size:11px; border:1px solid #e2e8f0; color:#334155;">
                                            {{ $amenity }}
                                        </span>
                                    @endforeach
                                @else
                                    <span style="color:var(--text-muted); font-size:12px;">None specified</span>
                                @endif
                            </div>
                        </div>

                        <div>
                            <label style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Description</label>
                            <div style="color:var(--text-secondary); margin-top:2px; font-size:12.5px; line-height:1.4;">
                                {{ $library->description ?? 'No description provided.' }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

@endsection
