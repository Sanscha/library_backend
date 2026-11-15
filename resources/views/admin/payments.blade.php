@extends('layouts.admin')

@section('title', 'Payments & Transactions')

@section('topbar_actions')
    <button type="button" class="btn btn-primary btn-sm" onclick="openModal('recordPaymentModal')">Record Payment</button>
@endsection

@section('content')

    <!-- Financial Metrics Grid -->
    <div class="grid grid-cols-4" style="margin-bottom: 24px;">
        <div class="card" style="padding: 16px 20px;">
            <div style="font-size: 12px; font-weight: 500; color: var(--text-muted);">Total Revenue</div>
            <div style="font-size: 24px; font-weight: 600; margin-top: 4px; color: #15803d;">
                ₹{{ number_format($metrics['totalRevenue'], 2) }}
            </div>
            <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">
                Today: <strong style="color:var(--text-primary);">₹{{ number_format($metrics['todayRevenue'], 2) }}</strong>
            </div>
        </div>

        <div class="card" style="padding: 16px 20px;">
            <div style="font-size: 12px; font-weight: 500; color: var(--text-muted);">Onboarding Fees</div>
            <div style="font-size: 24px; font-weight: 600; margin-top: 4px; color: #0284c7;">
                ₹{{ number_format($metrics['libraryRegRevenue'], 2) }}
            </div>
            <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">
                Library registration fees
            </div>
        </div>

        <div class="card" style="padding: 16px 20px;">
            <div style="font-size: 12px; font-weight: 500; color: var(--text-muted);">Direct UPI QR</div>
            <div style="font-size: 24px; font-weight: 600; margin-top: 4px; color: var(--text-primary);">
                ₹{{ number_format($metrics['upiTotal'], 2) }}
            </div>
            <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">
                UPI QR collections
            </div>
        </div>

        <div class="card" style="padding: 16px 20px;">
            <div style="font-size: 12px; font-weight: 500; color: var(--text-muted);">Gateway &amp; Cash</div>
            <div style="font-size: 24px; font-weight: 600; margin-top: 4px; color: var(--text-primary);">
                ₹{{ number_format($metrics['onlineTotal'] + $metrics['cashTotal'], 2) }}
            </div>
            <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">
                Online: ₹{{ number_format($metrics['onlineTotal'], 0) }} • Cash: ₹{{ number_format($metrics['cashTotal'], 0) }}
            </div>
        </div>
    </div>

    <!-- Transactions History Table -->
    <div class="card">
        <div class="card-header" style="flex-wrap: wrap; gap: 12px;">
            <div class="card-title">Transactions ({{ $payments->total() }})</div>
            <form method="GET" action="{{ route('admin.payments') }}" style="display: flex; gap: 10px; flex-wrap: wrap;">
                <input type="text" name="search" class="form-control" placeholder="Search by Txn ID, student, library..." value="{{ request('search') }}" style="max-width: 220px;">
                <select name="type" class="form-control" style="max-width: 160px;">
                    <option value="">All Types</option>
                    <option value="library_registration" {{ request('type') == 'library_registration' ? 'selected' : '' }}>Library Registration</option>
                    <option value="seat_booking" {{ request('type') == 'seat_booking' ? 'selected' : '' }}>Seat Pass</option>
                    <option value="membership_plan" {{ request('type') == 'membership_plan' ? 'selected' : '' }}>Membership Plan</option>
                </select>
                <select name="payment_method" class="form-control" style="max-width: 150px;">
                    <option value="">All Methods</option>
                    <option value="upi" {{ request('payment_method') == 'upi' ? 'selected' : '' }}>UPI QR</option>
                    <option value="online_razorpay" {{ request('payment_method') == 'online_razorpay' ? 'selected' : '' }}>Online Payment</option>
                    <option value="cash" {{ request('payment_method') == 'cash' ? 'selected' : '' }}>Cash</option>
                </select>
                <select name="status" class="form-control" style="max-width: 130px;">
                    <option value="">All Statuses</option>
                    <option value="completed" {{ request('status') == 'completed' ? 'selected' : '' }}>Completed</option>
                    <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                </select>
                <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                @if(request()->hasAny(['search', 'type', 'payment_method', 'status']))
                    <a href="{{ route('admin.payments') }}" class="btn btn-secondary btn-sm" style="color:var(--text-muted);">Reset</a>
                @endif
            </form>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>Transaction Ref</th>
                        <th>User / Library</th>
                        <th>Type / Description</th>
                        <th>Method</th>
                        <th>Amount</th>
                        <th>Collector</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($payments as $pay)
                        <tr>
                            <td>
                                <span style="font-family: monospace; font-weight: 500; color: #475569; font-size:12px;">
                                    {{ $pay->transaction_id ?? ('#TXN-' . $pay->id) }}
                                </span>
                            </td>
                            <td>
                                <div style="font-weight: 500; color: var(--text-primary);">{{ $pay->user->name ?? 'Guest User' }}</div>
                                <div style="font-size: 11.5px; color: var(--text-muted);">{{ $pay->user->phone ?? ($pay->user->email ?? '-') }}</div>
                                @if($pay->library)
                                    <div style="font-size: 11px; color: #0284c7; margin-top:1px;">
                                        🏛️ {{ $pay->library->name }}
                                    </div>
                                @endif
                            </td>
                            <td>
                                @if($pay->type === 'library_registration')
                                    <span class="badge badge-manager">Registration Fee</span>
                                    <div style="font-size: 11.5px; color: var(--text-muted); margin-top:2px;">{{ $pay->notes ?? 'Library onboarding' }}</div>
                                @else
                                    <div style="font-weight: 500; color: var(--text-primary);">{{ $pay->plan->name ?? ($pay->notes ?: 'Seat Pass') }}</div>
                                    @if($pay->booking)
                                        <div style="font-size: 11px; color: var(--text-muted);">Pass: {{ $pay->booking->pass_code }} (Seat {{ $pay->booking->seat->seat_number ?? '-' }})</div>
                                    @endif
                                @endif
                            </td>
                            <td>
                                <span class="badge badge-member" style="text-transform: uppercase;">
                                    {{ str_replace('online_', '', $pay->payment_method) }}
                                </span>
                            </td>
                            <td>
                                <strong style="color: #15803d; font-size: 13.5px;">₹{{ number_format($pay->amount, 2) }}</strong>
                            </td>
                            <td style="font-size: 12px; color:var(--text-muted);">
                                {{ $pay->collector->name ?? 'Online' }}
                            </td>
                            <td>
                                <span class="badge badge-{{ $pay->status }}">{{ $pay->status }}</span>
                            </td>
                            <td style="font-size: 12px; color: var(--text-muted);">
                                {{ $pay->created_at ? $pay->created_at->format('M d, Y h:i A') : '-' }}
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 32px;">No transactions found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if($payments->hasPages())
            <div style="padding: 14px 20px; border-top: 1px solid var(--border-color);">
                {{ $payments->links() }}
            </div>
        @endif
    </div>

    <!-- Record Manual Counter Payment Modal -->
    <div id="recordPaymentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Record Payment</h3>
                <button type="button" class="modal-close" onclick="closeModal('recordPaymentModal')">&times;</button>
            </div>
            <form action="{{ route('admin.payments.store') }}" method="POST">
                @csrf
                <div class="modal-body">
                    <div class="form-group">
                        <label for="payUser">Select Student / Member</label>
                        <select name="user_id" id="payUser" class="form-control" required>
                            <option value="">-- Choose Member --</option>
                            @foreach($users as $u)
                                <option value="{{ $u->id }}">{{ $u->name }} ({{ $u->phone }})</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="grid grid-cols-2">
                        <div class="form-group">
                            <label for="payPlan">Link Plan (Optional)</label>
                            <select name="plan_id" id="payPlan" class="form-control" onchange="updatePlanPrice(this)">
                                <option value="">-- Custom Amount --</option>
                                @foreach($plans as $pl)
                                    <option value="{{ $pl->id }}" data-price="{{ $pl->price }}">{{ $pl->name }} (₹{{ $pl->price }})</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="payAmount">Amount Paid (₹)</label>
                            <input type="number" step="0.01" name="amount" id="payAmount" class="form-control" placeholder="150" required>
                        </div>
                    </div>

                    <div class="grid grid-cols-2">
                        <div class="form-group">
                            <label for="payMethod">Payment Mode</label>
                            <select name="payment_method" id="payMethod" class="form-control" required>
                                <option value="cash">Counter Cash</option>
                                <option value="upi">Desk UPI QR</option>
                                <option value="card">Card POS</option>
                                <option value="online_razorpay">Online Payment</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="payStatus">Status</label>
                            <select name="status" id="payStatus" class="form-control" required>
                                <option value="completed">Completed</option>
                                <option value="pending">Pending</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="payTxn">Transaction Reference</label>
                        <input type="text" name="transaction_id" id="payTxn" class="form-control" placeholder="Optional for cash">
                    </div>

                    <div class="form-group">
                        <label for="payNotes">Notes / Description</label>
                        <input type="text" name="notes" id="payNotes" class="form-control" placeholder="e.g. Paid for Morning Shift Study Pass">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('recordPaymentModal')">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Payment</button>
                </div>
            </form>
        </div>
    </div>

@endsection

@section('scripts')
<script>
    function updatePlanPrice(select) {
        var opt = select.options[select.selectedIndex];
        var price = opt.getAttribute('data-price');
        if (price) {
            document.getElementById('payAmount').value = price;
        }
    }
</script>
@endsection
