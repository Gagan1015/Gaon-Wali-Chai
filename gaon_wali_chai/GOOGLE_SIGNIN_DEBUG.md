# Google Sign-In Troubleshooting

When the Google account picker shows but nothing happens after selecting an account, it means the OAuth configuration is incorrect.

## Quick Fix Checklist:

### 1. Verify OAuth Client Configuration in Google Cloud Console

Go to: https://console.cloud.google.com/apis/credentials

**Check these EXACT values:**

- **Package Name:** `com.gaonwalichai.gaon_wali_chai`
- **SHA-1 Certificate:** `8B:E0:B3:45:9B:1E:A9:35:10:47:E8:AE:EF:1F:44:17:80:4D:27:BF`

### 2. Make Sure You Have ANDROID OAuth Client (Not Web)

In Google Cloud Console → Credentials:
- You should have an "Android" OAuth 2.0 Client ID
- NOT just a "Web application" client

### 3. Common Mistakes:

❌ Using Web client ID instead of Android client
❌ Wrong package name
❌ Wrong SHA-1 fingerprint
❌ Forgot to save changes in Google Console

### 4. How to Fix:

1. Go to Google Cloud Console: https://console.cloud.google.com/
2. Select your project
3. Go to "APIs & Services" → "Credentials"
4. Look for your OAuth 2.0 Client IDs
5. You should see one with type "Android"
6. Click on it to edit
7. Verify:
   - Application type: Android
   - Package name: `com.gaonwalichai.gaon_wali_chai`
   - SHA-1: `8B:E0:B3:45:9B:1E:A9:35:10:47:E8:AE:EF:1F:44:17:80:4D:27:BF`
8. Click "Save"

### 5. If You Don't Have Android OAuth Client:

**Create a new one:**
1. Click "Create Credentials" → "OAuth 2.0 Client ID"
2. Select "Android"
3. Name: "Gaonwali Chai Android"
4. Package name: `com.gaonwalichai.gaon_wali_chai`
5. SHA-1: `8B:E0:B3:45:9B:1E:A9:35:10:47:E8:AE:EF:1F:44:17:80:4D:27:BF`
6. Click "Create"

### 6. After Fixing Configuration:

**Important:** Changes may take 5-10 minutes to propagate!

Then:
```bash
cd c:\Projects\gaon_wali_chai
flutter clean
flutter run
```

### 7. Check Debug Logs

After rebuilding, when you tap Google Sign-In and select an account, check the terminal/logcat for these messages:

- "Starting Google Sign-In..."
- "Google user signed in: [email]"
- "Got authentication tokens"

If you see an error, it will tell you what's wrong.

### 8. Test Again

1. Tap Google Sign-In button
2. Select your account
3. Grant permissions
4. Should navigate to home screen

If it still shows nothing, check the debug console for error messages!

## Most Likely Issue:

You probably have a **Web OAuth client** but NOT an **Android OAuth client**. Create an Android one with the exact SHA-1 and package name above.
