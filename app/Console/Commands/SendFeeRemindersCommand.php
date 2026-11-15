<?php

namespace App\Console\Commands;

use App\Services\FeeReminderService;
use Illuminate\Console\Command;

class SendFeeRemindersCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'library:send-fee-reminders';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Dispatch automatic fee reminders (7, 3, 1 days before expiry) and pending payment alerts to students';

    /**
     * Execute the console command.
     */
    public function handle(FeeReminderService $service): int
    {
        $this->info('Running automatic library fee reminders...');

        $result = $service->sendReminders();

        $this->info("Dispatched {$result['expiry_reminders_sent']} expiry reminder(s) and {$result['pending_payment_reminders_sent']} pending payment reminder(s).");

        return self::SUCCESS;
    }
}
