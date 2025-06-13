import 'package:auction_app/model/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileRepository {
  late CollectionReference userProfileCollection;

  UserProfileRepository() {
    userProfileCollection = FirebaseFirestore.instance.collection(
      "userProfile",
    );
  }

  Future<void> addUserProfile(UserProfile userProfile) async {
    await userProfileCollection.doc(userProfile.id).set(userProfile.toMap());
  }

  Future<UserProfile?> getUserById(String userProfileId) async {
    DocumentSnapshot snapshot =
        await userProfileCollection.doc(userProfileId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserProfile.fromMap(data, snapshot.id);
    }
    return null;
  }

  Future<List<UserProfile>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await userProfileCollection.get();

      List<UserProfile> users =
          querySnapshot.docs.map((doc) {
            return UserProfile.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<void> updateStatus(String uid, bool isAdmin) async {
    // var doc =
    await userProfileCollection.doc(uid).update({'isAdmin': isAdmin});
  }
}
