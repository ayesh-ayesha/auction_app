import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  Future<UserCredential> login(String email, String password) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  bool isEmailVerified() {
    User? user = getLoggedInUser();
    if (user == null) return false;
    return user.emailVerified;
  }

  User? getLoggedInUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> resetPassword(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword(String newPassword) {
    User? user = getLoggedInUser();
    if (user == null) return Future.value();
    return user.updatePassword(newPassword);
  }

  Future<void> changeName(String name) {
    User? user = getLoggedInUser();
    if (user == null) return Future.value();
    return user.updateDisplayName(name);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
