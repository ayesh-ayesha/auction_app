import 'package:firebase_auth/firebase_auth.dart';

class UserProfile{
  String id;
  String email;
  String displayName;
  bool isBidder;
  bool isAdmin;


  UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.isBidder,
    required this.isAdmin,}
  );

  Map<String, dynamic> toMap(){
    return {
      'email':email,
      'displayName':displayName,
      'isAdmin':isAdmin,
      'isBidder':isBidder,

    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String documentid) {
    return UserProfile(
      id: documentid,
      email:map['email'] ?? '',
     displayName:map['displayName']??'',
     isBidder:map['isBidder']??false,
     isAdmin:map['isAdmin']??false,// We pass the document ID separately
      // Get 'email' field, use empty string if null
    );
  }


}