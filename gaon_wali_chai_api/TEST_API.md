# Quick API Test Script

## Test Using PowerShell (Windows)

### 1. Test Server Health
```powershell
Invoke-WebRequest -Uri "http://localhost:8000" -Method GET
```

### 2. Test Registration Endpoint
```powershell
$body = @{
    name = "Test User"
    phone = "9876543210"
    password = "password123"
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "http://localhost:8000/api/auth/register" `
    -Method POST `
    -Headers @{"Content-Type"="application/json"; "Accept"="application/json"} `
    -Body $body

$response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

### 3. Check OTP in Logs
```powershell
Get-Content "storage\logs\laravel.log" -Tail 20
```

### 4. Test OTP Verification
```powershell
# Replace YOUR_OTP with the OTP from logs
$body = @{
    phone = "9876543210"
    otp = "YOUR_OTP"
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "http://localhost:8000/api/auth/verify-otp" `
    -Method POST `
    -Headers @{"Content-Type"="application/json"; "Accept"="application/json"} `
    -Body $body

$result = $response.Content | ConvertFrom-Json
$result | ConvertTo-Json -Depth 10

# Save the token
$token = $result.data.token
Write-Host "Token: $token"
```

### 5. Test Protected Endpoint (Get User)
```powershell
# Use the token from previous step
$response = Invoke-WebRequest -Uri "http://localhost:8000/api/auth/user" `
    -Method GET `
    -Headers @{
        "Accept"="application/json"
        "Authorization"="Bearer $token"
    }

$response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

### 6. Test Login
```powershell
$body = @{
    phone = "9876543210"
    password = "password123"
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "http://localhost:8000/api/auth/login" `
    -Method POST `
    -Headers @{"Content-Type"="application/json"; "Accept"="application/json"} `
    -Body $body

$result = $response.Content | ConvertFrom-Json
$result | ConvertTo-Json -Depth 10
```

---

## Complete Test Flow (Copy-Paste Ready)

```powershell
# Step 1: Register a new user
Write-Host "=== Step 1: Registering User ===" -ForegroundColor Green
$body = @{
    name = "Test User $(Get-Random)"
    phone = "98765$(Get-Random -Minimum 10000 -Maximum 99999)"
    password = "password123"
} | ConvertTo-Json

$registerResponse = Invoke-WebRequest -Uri "http://localhost:8000/api/auth/register" `
    -Method POST `
    -Headers @{"Content-Type"="application/json"; "Accept"="application/json"} `
    -Body $body

$registerData = $registerResponse.Content | ConvertFrom-Json
Write-Host "Registration Response:"
$registerData | ConvertTo-Json -Depth 10
$phone = ($body | ConvertFrom-Json).phone
Write-Host "`nPhone: $phone" -ForegroundColor Yellow

# Step 2: Get OTP from logs
Write-Host "`n=== Step 2: Getting OTP from Logs ===" -ForegroundColor Green
$logs = Get-Content "storage\logs\laravel.log" -Tail 30 | Select-String "OTP for $phone"
if ($logs) {
    Write-Host "Found OTP in logs:"
    $logs | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }
    
    # Extract OTP (assuming format "OTP for {phone}: {otp}")
    $otpMatch = $logs[-1] -match 'OTP for .+?: (\d{6})'
    if ($otpMatch) {
        $otp = $Matches[1]
        Write-Host "`nExtracted OTP: $otp" -ForegroundColor Yellow
        
        # Step 3: Verify OTP
        Write-Host "`n=== Step 3: Verifying OTP ===" -ForegroundColor Green
        $verifyBody = @{
            phone = $phone
            otp = $otp
        } | ConvertTo-Json
        
        $verifyResponse = Invoke-WebRequest -Uri "http://localhost:8000/api/auth/verify-otp" `
            -Method POST `
            -Headers @{"Content-Type"="application/json"; "Accept"="application/json"} `
            -Body $verifyBody
        
        $verifyData = $verifyResponse.Content | ConvertFrom-Json
        Write-Host "Verification Response:"
        $verifyData | ConvertTo-Json -Depth 10
        
        $token = $verifyData.data.token
        Write-Host "`nToken: $token" -ForegroundColor Yellow
        
        # Step 4: Get User Profile
        Write-Host "`n=== Step 4: Getting User Profile ===" -ForegroundColor Green
        $userResponse = Invoke-WebRequest -Uri "http://localhost:8000/api/auth/user" `
            -Method GET `
            -Headers @{
                "Accept"="application/json"
                "Authorization"="Bearer $token"
            }
        
        $userData = $userResponse.Content | ConvertFrom-Json
        Write-Host "User Profile:"
        $userData | ConvertTo-Json -Depth 10
        
        # Step 5: Logout
        Write-Host "`n=== Step 5: Logging Out ===" -ForegroundColor Green
        $logoutResponse = Invoke-WebRequest -Uri "http://localhost:8000/api/auth/logout" `
            -Method POST `
            -Headers @{
                "Accept"="application/json"
                "Authorization"="Bearer $token"
            }
        
        $logoutData = $logoutResponse.Content | ConvertFrom-Json
        Write-Host "Logout Response:"
        $logoutData | ConvertTo-Json -Depth 10
        
        Write-Host "`n=== All Tests Completed Successfully! ===" -ForegroundColor Green
    }
} else {
    Write-Host "Could not find OTP in logs. Check storage/logs/laravel.log manually" -ForegroundColor Red
}
```

---

## Expected Results

### Registration Response
```json
{
  "success": true,
  "message": "Registration successful. Please verify your phone number with the OTP sent.",
  "data": {
    "user": {
      "id": 1,
      "name": "Test User",
      "phone": "9876543210",
      "is_verified": false
    },
    "otp_sent": true
  }
}
```

### OTP Verification Response
```json
{
  "success": true,
  "message": "Phone number verified successfully",
  "data": {
    "user": {
      "id": 1,
      "name": "Test User",
      "phone": "9876543210",
      "email": null,
      "profile_image": null,
      "is_verified": true,
      "auth_provider": "phone"
    },
    "token": "1|abc123xyz...",
    "token_type": "Bearer"
  }
}
```

### User Profile Response
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "Test User",
      "phone": "9876543210",
      "email": null,
      "profile_image": null,
      "is_verified": true,
      "auth_provider": "phone"
    }
  }
}
```

---

## Troubleshooting

### Error: "Connection refused"
- Make sure server is running: `php artisan serve`

### Error: "Base table or view not found"
- Run migrations: `php artisan migrate`

### Can't find OTP in logs
- Check the log file: `type storage\logs\laravel.log`
- Make sure you're looking at the latest entries

### Error: "Invalid or expired OTP"
- OTPs expire after 10 minutes
- Each OTP can only be used once
- Generate a new OTP by resending

---

## Quick Links

- **API Documentation**: [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
- **Setup Guide**: [SETUP_GUIDE.md](SETUP_GUIDE.md)
- **Implementation Summary**: [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)
- **Flutter Integration**: [FLUTTER_INTEGRATION.md](FLUTTER_INTEGRATION.md)
