<?php

use App\Http\Controllers\Web\AdminController;
use App\Mail\OtpVerificationMail;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Route;

// Redirect root to Admin Dashboard
Route::get('/', function () {
    return redirect()->route('admin.dashboard');
});

// Admin Authentication (supports both /login and /admin/login)
Route::get('/login', [AdminController::class, 'loginForm'])->name('admin.login');
Route::post('/login', [AdminController::class, 'login']);
Route::get('/admin/login', [AdminController::class, 'loginForm']);
Route::post('/admin/login', [AdminController::class, 'login']);
Route::post('/admin/logout', [AdminController::class, 'logout'])->name('admin.logout');
Route::post('/logout', [AdminController::class, 'logout']);

// Protected Staff & Admin Dashboard Routes
Route::middleware('staff')->prefix('admin')->name('admin.')->group(function () {
    Route::get('/', [AdminController::class, 'dashboard'])->name('dashboard');

    // Libraries & Owners Platform Management
    Route::get('/libraries', [AdminController::class, 'libraries'])->name('libraries');
    Route::get('/libraries/{id}', [AdminController::class, 'showLibrary'])->name('libraries.show');
    Route::get('/libraries/{id}/details-json', [AdminController::class, 'getLibraryJson'])->name('libraries.details-json');
    Route::post('/libraries/{id}/update-fee', [AdminController::class, 'updateLibraryFee'])->name('libraries.update-fee');
    Route::post('/libraries/{id}/toggle-status', [AdminController::class, 'toggleLibraryStatus'])->name('libraries.toggle-status');
    Route::post('/libraries/{id}/verify-payment', [AdminController::class, 'verifyLibraryPayment'])->name('libraries.verify-payment');

    // User Management
    Route::get('/users', [AdminController::class, 'users'])->name('users');
    Route::post('/users', [AdminController::class, 'storeUser'])->name('users.store');
    Route::post('/users/{id}/toggle-status', [AdminController::class, 'toggleUserStatus'])->name('users.toggle-status');

    // Seat & Zone Management
    Route::get('/seats', [AdminController::class, 'seats'])->name('seats');
    Route::post('/zones', [AdminController::class, 'storeZone'])->name('zones.store');
    Route::post('/seats', [AdminController::class, 'storeSeat'])->name('seats.store');
    Route::post('/seats/batch', [AdminController::class, 'batchCreateSeats'])->name('seats.batch');
    Route::post('/seats/{id}/status', [AdminController::class, 'updateSeatStatus'])->name('seats.update-status');

    // Bookings & QR Passes
    Route::get('/bookings', [AdminController::class, 'bookings'])->name('bookings');
    Route::post('/bookings/{id}/checkin', [AdminController::class, 'checkInBooking'])->name('bookings.checkin');
    Route::post('/bookings/{id}/cancel', [AdminController::class, 'cancelBooking'])->name('bookings.cancel');

    // Payments & Billing Module
    Route::get('/payments', [AdminController::class, 'payments'])->name('payments');
    Route::post('/payments', [AdminController::class, 'storePayment'])->name('payments.store');

    // Platform Settings (One-Time Library Registration Fee, etc.)
    Route::get('/settings', [AdminController::class, 'settings'])->name('settings');
    Route::post('/settings', [AdminController::class, 'updateSettings'])->name('settings.update');
});

// Hosting migration helper (convenient for shared hosting like InfinityFree with no SSH access)
Route::get('/system/migrate', function () {
    $secret = request('key');
    if (! $secret || $secret !== config('app.key')) {
        abort(403, 'Unauthorized. Please provide ?key= matching your APP_KEY.');
    }

    try {
        Artisan::call('migrate', ['--force' => true]);
        $output = Artisan::output();

        if (request()->has('seed')) {
            Artisan::call('db:seed', ['--force' => true]);
            $output .= "\n".Artisan::output();
        }

        return response('<pre style="font-family:monospace; background:#0f172a; color:#38bdf8; padding:20px; border-radius:8px;">'.e($output).'</pre>');
    } catch (Throwable $e) {
        return response('<pre style="font-family:monospace; background:#450a0a; color:#f87171; padding:20px; border-radius:8px;">Migration Error: '.e($e->getMessage()).'</pre>', 500);
    }
});

// System cache clearing helper (clears bootstrap/cache/config.php and view/route cache)
Route::get('/system/clear-cache', function () {
    $secret = request('key');
    if (! $secret || $secret !== config('app.key')) {
        abort(403, 'Unauthorized. Please provide ?key= matching your APP_KEY.');
    }

    try {
        $cachedConfig = app()->getCachedConfigPath();
        $deleted = false;
        if (file_exists($cachedConfig)) {
            $deleted = @unlink($cachedConfig);
        }

        Artisan::call('config:clear');
        Artisan::call('cache:clear');
        Artisan::call('route:clear');
        Artisan::call('view:clear');

        $output = "✅ All caches successfully cleared!\n";
        $output .= 'Cached config file removed: '.($deleted ? 'Yes' : 'Was not cached')."\n";
        $output .= 'Active Mailer: '.config('mail.default')."\n";
        $output .= 'Active SMTP Host: '.config('mail.mailers.smtp.host')."\n";

        return response('<pre style="font-family:monospace; background:#0f172a; color:#4ade80; padding:20px; border-radius:8px;">'.e($output).'</pre>');
    } catch (Throwable $e) {
        return response('<pre style="font-family:monospace; background:#450a0a; color:#f87171; padding:20px; border-radius:8px;">Cache Clear Error: '.e($e->getMessage()).'</pre>', 500);
    }
});

// Hosting SMTP test helper (instant testing in browser with error diagnostics)
Route::get('/system/test-email', function () {
    $secret = request('key');
    if (! $secret || $secret !== config('app.key')) {
        abort(403, 'Unauthorized. Please provide ?key= matching your APP_KEY.');
    }

    // Auto-remove cached config if it was present
    $cachedConfig = app()->getCachedConfigPath();
    if (file_exists($cachedConfig)) {
        @unlink($cachedConfig);
        try {
            Artisan::call('config:clear');
        } catch (Throwable $e) {
        }

        return response('<pre style="font-family:monospace; background:#0f172a; color:#38bdf8; padding:20px; border-radius:8px;">⚡ Laravel configuration cache was detected and has been automatically DELETED!&#10;&#10;Please REFRESH this page now (or press F5) so Laravel reloads your new .env SMTP settings into memory.</pre>');
    }

    $to = request('to');
    if (! $to || ! filter_var($to, FILTER_VALIDATE_EMAIL)) {
        return response('<pre style="font-family:monospace; background:#450a0a; color:#f87171; padding:20px; border-radius:8px;">Please provide a valid recipient email: ?to=your_email@gmail.com&key=YOUR_APP_KEY</pre>', 400);
    }

    $mailer = config('mail.default');
    $host = config('mail.mailers.smtp.host');
    $port = config('mail.mailers.smtp.port');
    $username = config('mail.mailers.smtp.username');

    if ($mailer === 'log') {
        return response('<pre style="font-family:monospace; background:#78350f; color:#fef08a; padding:20px; border-radius:8px;">⚠️ NOTICE: MAIL_MAILER is still set to "log" (Host: '.$host.':'.$port.').&#10;&#10;In your .env file on Hostinger, make sure you have:&#10;MAIL_MAILER=smtp&#10;MAIL_HOST=smtp.gmail.com (or smtp.hostinger.com)&#10;MAIL_PORT=587 (or 465)&#10;&#10;Also check if there are DUPLICATE lines in .env (remove the old MAIL_MAILER=log line if there are two).</pre>', 200);
    }

    try {
        $otp = (string) random_int(100000, 999999);
        Mail::to($to)->send(new OtpVerificationMail($otp, 15));

        return response('<pre style="font-family:monospace; background:#0f172a; color:#4ade80; padding:20px; border-radius:8px;">✅ Success! Test verification email with OTP '.$otp.' was sent to '.$to.' using mailer: '.$mailer.' (Host: '.$host.':'.$port.', User: '.$username.')</pre>');
    } catch (Throwable $e) {
        return response('<pre style="font-family:monospace; background:#450a0a; color:#f87171; padding:20px; border-radius:8px;">❌ SMTP Error: '.e($e->getMessage()).'&#10;&#10;Mailer: '.$mailer.'&#10;Host: '.$host.':'.$port.'&#10;Username: '.$username.'</pre>', 500);
    }
});
