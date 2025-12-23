import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Optional: Specify client ID explicitly for web support
    // For Android/iOS, it uses the native configuration
    // clientId: '171762632554-oq5aa29pfg8j5dbo8ql31ski1ma1ok41.apps.googleusercontent.com',
  );

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        print('User cancelled Google Sign-In');
        return null;
      }

      print('Google user signed in: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('Got authentication tokens');

      return {
        'provider': 'google',
        'provider_id': googleUser.id,
        'name': googleUser.displayName ?? '',
        'email': googleUser.email,
        'profile_image': googleUser.photoUrl,
        'id_token': googleAuth.idToken,
        'access_token': googleAuth.accessToken,
      };
    } catch (error) {
      print('Error signing in with Google: $error');
      print('Error type: ${error.runtimeType}');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
