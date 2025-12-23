<?php

namespace App\Http\Controllers;

use App\Http\Requests\ForgotPasswordRequest;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Requests\ResendOtpRequest;
use App\Http\Requests\ResetPasswordRequest;
use App\Http\Requests\SocialLoginRequest;
use App\Http\Requests\VerifyOtpRequest;
use App\Models\User;
use App\Services\OtpService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    protected OtpService $otpService;

    public function __construct(OtpService $otpService)
    {
        $this->otpService = $otpService;
    }

    /**
     * Register a new user
     *
     * @param RegisterRequest $request
     * @return JsonResponse
     */
    public function register(RegisterRequest $request): JsonResponse
    {
        try {
            // Create user (unverified)
            $user = User::create([
                'name' => $request->name,
                'phone' => $request->phone,
                'password' => $request->password,
                'auth_provider' => 'phone',
                'is_verified' => false,
            ]);

            // Generate and send OTP
            $otp = $this->otpService->storeOtp($request->phone, 'registration');
            $this->otpService->sendOtp($request->phone, $otp->otp);

            return response()->json([
                'success' => true,
                'message' => 'Registration successful. Please verify your phone number with the OTP sent.',
                'data' => [
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'phone' => $user->phone,
                        'is_verified' => $user->is_verified,
                    ],
                    'otp_sent' => true,
                    'otp' => config('app.debug') ? $otp->otp : null, // Only show OTP in development
                ],
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Registration failed',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Verify OTP
     *
     * @param VerifyOtpRequest $request
     * @return JsonResponse
     */
    public function verifyOtp(VerifyOtpRequest $request): JsonResponse
    {
        try {
            $isValid = $this->otpService->verifyOtp(
                $request->phone,
                $request->otp,
                'registration'
            );

            if (!$isValid) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid or expired OTP',
                ], 400);
            }

            // Find and update user
            $user = User::where('phone', $request->phone)->first();
            
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User not found',
                ], 404);
            }

            $user->update([
                'is_verified' => true,
                'phone_verified_at' => now(),
            ]);

            // Create authentication token
            $token = $user->createToken('auth-token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Phone number verified successfully',
                'data' => [
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'phone' => $user->phone,
                        'email' => $user->email,
                        'profile_image' => $user->profile_image,
                        'is_verified' => $user->is_verified,
                        'auth_provider' => $user->auth_provider,
                        'created_at' => $user->created_at,
                    ],
                    'token' => $token,
                    'token_type' => 'Bearer',
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'OTP verification failed',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Resend OTP
     *
     * @param ResendOtpRequest $request
     * @return JsonResponse
     */
    public function resendOtp(ResendOtpRequest $request): JsonResponse
    {
        try {
            // Generate and send new OTP
            $otp = $this->otpService->storeOtp($request->phone, $request->type);
            $this->otpService->sendOtp($request->phone, $otp->otp);

            return response()->json([
                'success' => true,
                'message' => 'OTP resent successfully',
                'data' => [
                    'otp_sent' => true,
                    'expires_at' => $otp->expires_at,
                    'otp' => config('app.debug') ? $otp->otp : null, // Only show OTP in development
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to resend OTP',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Login user
     *
     * @param LoginRequest $request
     * @return JsonResponse
     */
    public function login(LoginRequest $request): JsonResponse
    {
        try {
            $user = User::where('phone', $request->phone)->first();

            if (!$user || !Hash::check($request->password, $user->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid phone number or password',
                ], 401);
            }

            if (!$user->is_verified) {
                // Resend OTP for verification
                $otp = $this->otpService->storeOtp($request->phone, 'registration');
                $this->otpService->sendOtp($request->phone, $otp->otp);

                return response()->json([
                    'success' => false,
                    'message' => 'Phone number not verified. OTP sent to your phone.',
                    'data' => [
                        'requires_verification' => true,
                        'phone' => $user->phone,
                        'otp' => config('app.debug') ? $otp->otp : null, // Only show OTP in development
                    ],
                ], 403);
            }

            // Create authentication token
            $token = $user->createToken('auth-token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Login successful',
                'data' => [
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'phone' => $user->phone,
                        'email' => $user->email,
                        'profile_image' => $user->profile_image,
                        'is_verified' => $user->is_verified,
                        'auth_provider' => $user->auth_provider,
                        'created_at' => $user->created_at,
                    ],
                    'token' => $token,
                    'token_type' => 'Bearer',
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Login failed',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Forgot password - Send OTP
     *
     * @param ForgotPasswordRequest $request
     * @return JsonResponse
     */
    public function forgotPassword(ForgotPasswordRequest $request): JsonResponse
    {
        try {
            // Generate and send OTP for password reset
            $otp = $this->otpService->storeOtp($request->phone, 'forgot_password');
            $this->otpService->sendOtp($request->phone, $otp->otp);

            return response()->json([
                'success' => true,
                'message' => 'OTP sent to your phone number',
                'data' => [
                    'otp_sent' => true,
                    'expires_at' => $otp->expires_at,
                    'otp' => config('app.debug') ? $otp->otp : null, // Only show OTP in development
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to send OTP',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Reset password
     *
     * @param ResetPasswordRequest $request
     * @return JsonResponse
     */
    public function resetPassword(ResetPasswordRequest $request): JsonResponse
    {
        try {
            // Verify OTP
            $isValid = $this->otpService->verifyOtp(
                $request->phone,
                $request->otp,
                'forgot_password'
            );

            if (!$isValid) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid or expired OTP',
                ], 400);
            }

            // Find user and update password
            $user = User::where('phone', $request->phone)->first();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User not found',
                ], 404);
            }

            $user->update([
                'password' => $request->password,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Password reset successfully',
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Password reset failed',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get authenticated user
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function user(Request $request): JsonResponse
    {
        try {
            $user = $request->user();

            return response()->json([
                'success' => true,
                'data' => [
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'phone' => $user->phone,
                        'email' => $user->email,
                        'profile_image' => $user->profile_image,
                        'is_verified' => $user->is_verified,
                        'auth_provider' => $user->auth_provider,
                        'created_at' => $user->created_at,
                    ],
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch user',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Logout user
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function logout(Request $request): JsonResponse
    {
        try {
            // Revoke current token
            $request->user()->currentAccessToken()->delete();

            return response()->json([
                'success' => true,
                'message' => 'Logged out successfully',
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Logout failed',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Social Login (Google/Facebook)
     *
     * @param SocialLoginRequest $request
     * @return JsonResponse
     */
    public function socialLogin(SocialLoginRequest $request): JsonResponse
    {
        try {
            // Check if user exists with this provider_id
            $user = User::where('provider', $request->provider)
                ->where('provider_id', $request->provider_id)
                ->first();

            // If user doesn't exist, check by email
            if (!$user && $request->email) {
                $user = User::where('email', $request->email)->first();
                
                // Update provider info if user found by email
                if ($user) {
                    $user->update([
                        'provider' => $request->provider,
                        'provider_id' => $request->provider_id,
                        'is_verified' => true, // Auto-verify social login users
                    ]);
                }
            }

            // If still no user, create new one
            if (!$user) {
                $user = User::create([
                    'name' => $request->name,
                    'email' => $request->email,
                    'provider' => $request->provider,
                    'provider_id' => $request->provider_id,
                    'profile_image' => $request->profile_image,
                    'is_verified' => true, // Auto-verify social login users
                    'auth_provider' => $request->provider,
                    'phone' => null, // Social login users don't have phone initially
                ]);
            }

            // Generate token
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Login successful',
                'data' => [
                    'token' => $token,
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'phone' => $user->phone,
                        'email' => $user->email,
                        'profile_image' => $user->profile_image,
                        'is_verified' => $user->is_verified,
                        'auth_provider' => $user->auth_provider,
                        'created_at' => $user->created_at,
                    ],
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Social login failed',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Update user profile
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function updateProfile(Request $request): JsonResponse
    {
        try {
            $user = $request->user();

            $validated = $request->validate([
                'name' => 'sometimes|string|max:255',
                'email' => 'sometimes|email|unique:users,email,' . $user->id,
                'profile_image' => 'sometimes|string',
            ]);

            $user->update($validated);

            return response()->json([
                'success' => true,
                'message' => 'Profile updated successfully',
                'data' => [
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'phone' => $user->phone,
                        'email' => $user->email,
                        'profile_image' => $user->profile_image,
                        'is_verified' => $user->is_verified,
                        'auth_provider' => $user->auth_provider,
                        'created_at' => $user->created_at,
                    ],
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Profile update failed',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
