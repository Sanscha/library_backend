@extends('layouts.admin')

@section('title', 'Platform Dashboard')

@section('topbar_actions')
    <a href="{{ route('admin.libraries') }}" class="btn btn-secondary btn-sm">Libraries ({{ $totalLibraries }})</a>
    <a href="{{ route('admin.users') }}" class="btn btn-secondary btn-sm">Users ({{ $totalMembers }})</a>
    <a href="{{ route('admin.payments') }}" class="btn btn-primary btn-sm">Payments & Revenue</a>
@endsection

@section('content')

    <!-- Platform Wide Summary Cards -->
    <div class="grid grid-cols-4" style="margin-bottom: 24px;">
        <!-- Total Revenue Card -->
        <div class="card" style="padding: 18px 20px;">
            <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                <div>
                    <div style="font-size:12px; font-weight:500; color:var(--text-muted);">Total Revenue</div>
                    <div style="font-size:26px; font-weight:700; margin-top:4px; color:var(--text-primary);">
                        ₹{{ number_format($totalRevenue, 2) }}
                    </div>
                </div>
                <div style="width:38px; height:38px; border-radius:8px; background:#f0fdf4; color:#15803d; display:flex; align-items:center; justify-content:center;">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                </div>
            </div>
            <div style="margin-top:10px; font-size:11.5px; color:var(--text-secondary); display:flex; gap:6px; flex-wrap:wrap;">
                <span>Onboarding: <strong>₹{{ number_format($libraryRegRevenue, 0) }}</strong></span>
                <span>•</span>
                <span>Student Bookings: <strong>₹{{ number_format($studentBookingRevenue, 0) }}</strong></span>
            </div>
        </div>

        <!-- Total Libraries Card -->
        <div class="card" style="padding: 18px 20px;">
            <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                <div>
                    <div style="font-size:12px; font-weight:500; color:var(--text-muted);">Registered Libraries</div>
                    <div style="font-size:26px; font-weight:700; margin-top:4px; color:var(--text-primary);">
                        {{ $totalLibraries }}
                    </div>
                </div>
                <div style="width:38px; height:38px; border-radius:8px; background:var(--primary-light); color:var(--primary); display:flex; align-items:center; justify-content:center;">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20M4 19.5A2.5 2.5 0 0 0 6.5 22H20V2H6.5A2.5 2.5 0 0 0 4 4.5v15zM8 7h8M8 11h6"/></svg>
                </div>
            </div>
            <div style="margin-top:10px; display:flex; gap:8px; font-size:12px; color:var(--text-secondary);">
                <span><strong style="color:var(--success);">{{ $activeLibraries }}</strong> active</span>
                <span>•</span>
                <span><strong style="color:var(--warning);">{{ $pendingLibraries }}</strong> fee pending</span>
            </div>
        </div>

        <!-- Library Owners Card -->
        <div class="card" style="padding: 18px 20px;">
            <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                <div>
                    <div style="font-size:12px; font-weight:500; color:var(--text-muted);">Library Owners</div>
                    <div style="font-size:26px; font-weight:700; margin-top:4px; color:var(--text-primary);">
                        {{ $totalManagers }}
                    </div>
                </div>
                <div style="width:38px; height:38px; border-radius:8px; background:var(--info-light); color:var(--info); display:flex; align-items:center; justify-content:center;">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                </div>
            </div>
            <div style="margin-top:10px; font-size:12px; color:var(--text-muted);">
                Managing branches
            </div>
        </div>

        <!-- Registered Students / Users Card -->
        <div class="card" style="padding: 18px 20px;">
            <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                <div>
                    <div style="font-size:12px; font-weight:500; color:var(--text-muted);">Registered Students</div>
                    <div style="font-size:26px; font-weight:700; margin-top:4px; color:var(--text-primary);">
                        {{ $totalMembers }}
                    </div>
                </div>
                <div style="width:38px; height:38px; border-radius:8px; background:#f5f3ff; color:#6d28d9; display:flex; align-items:center; justify-content:center;">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                </div>
            </div>
            <div style="margin-top:10px; font-size:12px; color:var(--text-muted);">
                App users across all libraries
            </div>
        </div>
    </div>

    <!-- Main 2-Column Dashboard Grid: Payments & Libraries -->
    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:24px; margin-bottom:24px;">

        <!-- Recent Payments -->
        <div class="card">
            <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <div class="card-title">Recent Payments</div>
                    <div style="font-size:12px; color:var(--text-muted); margin-top:2px;">Incoming transactions</div>
                </div>
                <a href="{{ route('admin.payments') }}" class="btn btn-secondary btn-sm">View All Payments &rarr;</a>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Transaction</th>
                            <th>Type</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($recentPayments as $p)
                            <tr>
                                <td>
                                    <div style="font-weight:600; color:var(--text-primary); font-size:12.5px;">
                                        {{ $p->transaction_id ?? 'PAY-'.str_pad($p->id, 5, '0', STR_PAD_LEFT) }}
                                    </div>
                                    <div style="font-size:11px; color:var(--text-muted);">
                                        {{ $p->user->name ?? ($p->library->name ?? 'User') }} &bull; {{ $p->created_at->diffForHumans() }}
                                    </div>
                                </td>
                                <td>
                                    <span style="font-size:12px; text-transform:capitalize; color:var(--text-secondary);">
                                        {{ str_replace('_', ' ', $p->type ?? 'seat_booking') }}
                                    </span>
                                </td>
                                <td>
                                    <div style="font-weight:600; color:var(--text-primary); font-size:13px;">
                                        ₹{{ number_format($p->amount, 2) }}
                                    </div>
                                </td>
                                <td>
                                    <span class="badge badge-{{ $p->status === 'completed' ? 'active' : ($p->status === 'failed' ? 'suspended' : 'pending_payment') }}">
                                        {{ ucfirst($p->status) }}
                                    </span>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="4" style="text-align:center; padding:24px; color:var(--text-muted);">
                                    No transactions recorded yet.
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Recent Registered Libraries & Onboarding Fee -->
        <div class="card">
            <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <div class="card-title">Libraries & Owners</div>
                    <div style="font-size:12px; color:var(--text-muted); margin-top:2px;">Branch onboarding status</div>
                </div>
                <a href="{{ route('admin.libraries') }}" class="btn btn-secondary btn-sm">Manage All &rarr;</a>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Library</th>
                            <th>Owner / Contact</th>
                            <th>One-Time Fee</th>
                            <th>Fee Status</th>
                            <th style="text-align:right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($recentLibraries as $lib)
                            <tr>
                                <td>
                                    <div style="font-weight:600; color:var(--text-primary); font-size:13px;">{{ $lib->name }}</div>
                                    <div style="font-size:11px; color:var(--text-muted);">{{ $lib->city ?? 'N/A' }}</div>
                                </td>
                                <td>
                                    <div style="font-size:12.5px; color:var(--text-primary); font-weight:500;">{{ $lib->owner->name ?? 'N/A' }}</div>
                                    <div style="font-size:11px; color:var(--text-muted);">{{ $lib->owner->phone ?? 'N/A' }}</div>
                                </td>
                                <td>
                                    <div style="font-weight:600; color:var(--text-primary); font-size:13px;">
                                        ₹{{ number_format($lib->registration_fee, 2) }}
                                    </div>
                                </td>
                                <td>
                                    <span class="badge badge-{{ $lib->payment_status }}">
                                        {{ $lib->payment_status === 'paid' ? 'Paid' : 'Unpaid' }}
                                    </span>
                                </td>
                                <td style="text-align:right;">
                                    <a href="{{ route('admin.libraries.show', $lib->id) }}" class="btn btn-secondary btn-sm">
                                        View
                                    </a>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="5" style="text-align:center; padding:24px; color:var(--text-muted);">
                                    No libraries onboarded yet.
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <!-- Recent Students / Users Table -->
    <div class="card">
        <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
            <div>
                <div class="card-title">Recent Students & App Users</div>
                <div style="font-size:12px; color:var(--text-muted); margin-top:2px;">Registered students across the platform</div>
            </div>
            <a href="{{ route('admin.users') }}" class="btn btn-secondary btn-sm">View All Users &rarr;</a>
        </div>
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>User Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Registered Date</th>
                        <th>Account Status</th>
                        <th style="text-align:right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($recentUsers as $user)
                        <tr>
                            <td>
                                <div style="display:flex; align-items:center; gap:10px;">
                                    <div style="width:30px; height:30px; border-radius:50%; background:#eff6ff; color:#2563eb; display:flex; align-items:center; justify-content:center; font-weight:600; font-size:12px;">
                                        {{ strtoupper(substr($user->name, 0, 1)) }}
                                    </div>
                                    <div style="font-weight:500; color:var(--text-primary);">{{ $user->name }}</div>
                                </div>
                            </td>
                            <td>
                                <div style="color:var(--text-secondary); font-size:12.5px;">{{ $user->email }}</div>
                            </td>
                            <td>
                                <div style="color:var(--text-secondary); font-size:12.5px;">{{ $user->phone ?? 'N/A' }}</div>
                            </td>
                            <td>
                                <div style="color:var(--text-muted); font-size:12px;">{{ $user->created_at->format('M d, Y') }}</div>
                            </td>
                            <td>
                                <span class="badge badge-{{ $user->status ?? 'active' }}">
                                    {{ ucfirst($user->status ?? 'active') }}
                                </span>
                            </td>
                            <td style="text-align:right;">
                                <form action="{{ route('admin.users.toggle-status', $user->id) }}" method="POST" style="display:inline;">
                                    @csrf
                                    <button type="submit" class="btn btn-secondary btn-sm" onclick="return confirm('Toggle status for {{ $user->name }}?')">
                                        {{ ($user->status ?? 'active') === 'active' ? 'Block' : 'Unblock' }}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" style="text-align:center; padding:24px; color:var(--text-muted);">
                                No users registered yet.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

@endsection
