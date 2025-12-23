<?php

namespace App\Services;

use App\Models\Otp;
use Illuminate\Support\Facades\Log;
use Twilio\Rest\Client;

class OtpService
{
    /**
     * Generate a 6-digit OTP code
     *
     * @return string
     */
    public function generateOtp(): string
    {
        return sprintf('%06d', mt_rand(100000, 999999));
    }

    /**
     * Store OTP in database
     *
     * @param string $phone
     * @param string $type
     * @return Otp
     */
    public function storeOtp(string $phone, string $type = 'registration'): Otp
    {
        // Invalidate previous OTPs
        Otp::where('phone', $phone)
            ->where('type', $type)
            ->where('is_used', false)
            ->update(['is_used' => true]);

        // Generate and store new OTP
        $otpCode = $this->generateOtp();
        
        return Otp::create([
            'phone' => $phone,
            'otp' => $otpCode,
            'type' => $type,
            'expires_at' => now()->addMinutes(10), // OTP expires in 10 minutes
            'is_used' => false,
        ]);
    }

    /**
     * Verify OTP
     *
     * @param string $phone
     * @param string $otp
     * @param string $type
     * @return bool
     */
    public function verifyOtp(string $phone, string $otp, string $type = 'registration'): bool
    {
        $otpRecord = Otp::where('phone', $phone)
            ->where('otp', $otp)
            ->where('type', $type)
            ->where('is_used', false)
            ->orderBy('created_at', 'desc')
            ->first();

        if (!$otpRecord) {
            return false;
        }

        if ($otpRecord->isExpired()) {
            return false;
        }

        // Mark OTP as used
        $otpRecord->update(['is_used' => true]);

        return true;
    }

    /**
     * Send OTP via SMS (implement your SMS provider here)
     *
     * @param string $phone
     * @param string $otp
     * @return bool
     */
    public function sendOtp(string $phone, string $otp): bool
    {
        // For development, log the OTP
        Log::info("OTP for {$phone}: {$otp}");

        // Twilio SMS Integration
        try {
            $twilio = new Client(config('services.twilio.sid'), config('services.twilio.token'));
            $twilio->messages->create(
                $phone,
                [
                    'from' => config('services.twilio.from'),
                    'body' => "Your Gaon Wali Chai verification code is: {$otp}. Valid for 10 minutes."
                ]
            );
            return true;
        } catch (\Exception $e) {
            Log::error('SMS sending failed: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Get last OTP for phone (for development/testing)
     *
     * @param string $phone
     * @return string|null
     */
    public function getLastOtp(string $phone): ?string
    {
        $otp = Otp::where('phone', $phone)
            ->where('is_used', false)
            ->orderBy('created_at', 'desc')
            ->first();

        return $otp?->otp;
    }
}
