@extends('layouts.admin')

@section('title', 'Platform Settings')

@section('content')

    <div style="max-width: 800px; margin: 0 auto;">

        <div style="margin-bottom: 24px;">
            <h1 style="font-size: 22px; font-weight: 700; color: var(--text-primary); margin: 0;">
                Platform Settings
            </h1>
            <p style="font-size: 13px; color: var(--text-muted); margin-top: 4px;">
                Configure the one-time registration fee library owners pay upon signup, along with platform details.
            </p>
        </div>

        <form action="{{ route('admin.settings.update') }}" method="POST">
            @csrf

            <!-- Primary Setting: One-Time Onboarding Fee -->
            <div class="card" style="margin-bottom: 24px; border: 1.5px solid #bfdbfe;">
                <div class="card-header" style="background: #eff6ff; border-bottom: 1px solid #dbeafe;">
                    <div style="display:flex; align-items:center; gap:10px;">
                        <div style="width:32px; height:32px; border-radius:6px; background:#2563eb; color:white; display:flex; align-items:center; justify-content:center;">
                            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                        </div>
                        <div>
                            <div class="card-title" style="color:#1e40af;">Library Onboarding Fee (One-Time)</div>
                            <div style="font-size: 12px; color: #3b82f6;">Charged to each library owner upon signup via Online / UPI</div>
                        </div>
                    </div>
                </div>
                <div class="card-body" style="padding: 24px;">
                    <div style="margin-bottom: 16px;">
                        <label style="font-size: 13px; font-weight: 600; color: var(--text-primary); display:block; margin-bottom: 8px;">
                            One-Time Registration Fee Amount (₹ INR) <span style="color:var(--danger);">*</span>
                        </label>
                        <div style="display:flex; align-items:center; max-width: 320px;">
                            <span style="background:var(--bg-elevated); border:1px solid var(--border-color); border-right:none; padding:10px 16px; border-radius:6px 0 0 6px; font-weight:600; font-size:16px; color:var(--text-secondary);">
                                ₹
                            </span>
                            <input type="number" step="0.01" min="0" name="library_registration_fee" 
                                value="{{ old('library_registration_fee', $settings['library_registration_fee'] ?? '999.00') }}" 
                                class="form-control" required 
                                style="border-radius:0 6px 6px 0; font-size:18px; font-weight:700; padding:10px 14px; color:var(--text-primary);">
                        </div>
                        @error('library_registration_fee')
                            <span style="color:var(--danger); font-size:12px; margin-top:4px; display:block;">{{ $message }}</span>
                        @enderror
                    </div>

                    <div style="padding: 14px 16px; background: #f8fafc; border: 1px dashed var(--border-color); border-radius: 6px; font-size: 12.5px; color: var(--text-secondary); line-height: 1.5;">
                        <strong style="color:var(--text-primary);">How this works:</strong>
                        When any new library owner registers their branch on the platform, this exact fee is charged. The owner is prompted to complete payment (UPI QR or Online payment) before their branch is activated.
                    </div>
                </div>
            </div>

            <!-- Platform General Settings -->
            <div class="card" style="margin-bottom: 24px;">
                <div class="card-header">
                    <div class="card-title">Platform Information & Support</div>
                </div>
                <div class="card-body" style="padding: 24px; display:flex; flex-direction:column; gap:16px;">
                    <div>
                        <label style="font-size: 13px; font-weight: 500; color: var(--text-primary); display:block; margin-bottom: 6px;">
                            Platform Brand Name
                        </label>
                        <input type="text" name="platform_name" 
                            value="{{ old('platform_name', $settings['platform_name'] ?? 'SeatSync') }}" 
                            class="form-control" style="max-width: 400px;">
                    </div>

                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:16px;">
                        <div>
                            <label style="font-size: 13px; font-weight: 500; color: var(--text-primary); display:block; margin-bottom: 6px;">
                                Support Email
                            </label>
                            <input type="email" name="support_email" 
                                value="{{ old('support_email', $settings['support_email'] ?? 'support@seatsync.com') }}" 
                                class="form-control">
                        </div>

                        <div>
                            <label style="font-size: 13px; font-weight: 500; color: var(--text-primary); display:block; margin-bottom: 6px;">
                                Support Phone / Helpline
                            </label>
                            <input type="text" name="support_phone" 
                                value="{{ old('support_phone', $settings['support_phone'] ?? '+91 9876543210') }}" 
                                class="form-control">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Submit Button -->
            <div style="display:flex; justify-content:flex-end; gap:12px; margin-bottom: 40px;">
                <a href="{{ route('admin.dashboard') }}" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary" style="padding: 9px 24px; font-size:14px; font-weight:600;">
                    Save Settings
                </button>
            </div>

        </form>

    </div>

@endsection
