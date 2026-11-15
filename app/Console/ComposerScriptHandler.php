<?php

namespace App\Console;

use Composer\Script\Event;
use Illuminate\Contracts\Console\Kernel;
use Illuminate\Foundation\ComposerScripts;
use Throwable;

class ComposerScriptHandler
{
    /**
     * Handle post-autoload-dump event without requiring proc_open.
     */
    public static function postAutoloadDump(Event $event): void
    {
        $vendorDir = $event->getComposer()->getConfig()->get('vendor-dir');
        require_once $vendorDir.'/autoload.php';

        // 1. Clear compiled cache files
        ComposerScripts::postAutoloadDump($event);

        // 2. In-process package discovery (safe for shared hosting where proc_open is disabled)
        try {
            $baseDir = dirname($vendorDir);
            $app = require $baseDir.'/bootstrap/app.php';
            $kernel = $app->make(Kernel::class);
            $kernel->call('package:discover');
        } catch (Throwable $e) {
            // Silently allow install to complete even if environment isn't fully bootstrapped yet
        }
    }
}
