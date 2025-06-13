import 'package:auction_app/repositories/user_profile_repo.dart';
import 'package:get/get.dart';
import '../model/user_profile.dart';
import '../repositories/auth_repo.dart';


//my code
class UserProfileVM extends GetxController {
  UserProfileRepository userProfileRepository = Get.find();
  AuthRepository authRepository = Get.find();

  var usersProfile = <UserProfile>[].obs;
  var selectedUser = Rxn<UserProfile>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Add this getter to easily access current user's admin status
  bool get isCurrentUserAdmin => selectedUser.value?.isAdmin ?? false;
  String get currentUserId => authRepository.getLoggedInUser()?.uid ?? '';

  Future<void> fetchUserById(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      UserProfile? user = await userProfileRepository.getUserById(userId);

      if (user != null) {
        selectedUser.value = user;
      } else {
        errorMessage.value = 'User not found';
        selectedUser.value = null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      errorMessage.value = 'Failed to fetch user: ${e.toString()}';
      selectedUser.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(bool isAdmin) async {
    String? uid = authRepository.getLoggedInUser()?.uid;
    if (uid == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    try {
      // Show loading state during update
      isLoading.value = true;

      // Update in database
      await userProfileRepository.updateStatus(uid, isAdmin);

      // CRITICAL: Update the local selectedUser immediately for live UI updates
      if (selectedUser.value != null) {
        // Create a new UserProfile object with updated admin status
        selectedUser.value = UserProfile(
          id: selectedUser.value!.id,
          email: selectedUser.value!.email,
          displayName: selectedUser.value!.displayName,
          isBidder: selectedUser.value!.isBidder,
          isAdmin: isAdmin, // This is the updated value
        );

        // Force UI refresh
        selectedUser.refresh();
      }

      Get.snackbar("Success", "Role updated to ${isAdmin ? 'Admin' : 'User'}");

    } catch (e) {
      Get.snackbar("Error", "Failed to update role: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Add method to toggle role easily
  Future<void> toggleUserRole() async {
    bool currentRole = selectedUser.value?.isAdmin ?? false;
    await updateStatus(!currentRole);
  }
}


