// lib/view_model/bid_vm.dart

import 'package:auction_app/view_model/auction_vm.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Required for Get.snackbar UI elements

// Import your models
import '../model/bid.dart';
import '../model/auction.dart'; // Make sure this path is correct for your Auction model
import '../model/user_profile.dart'; // Make sure this path is correct for your UserProfile model

// Import your repositories
import '../repositories/bid_repo.dart';
import '../repositories/user_profile_repo.dart'; // Ensure this path is correct
import '../repositories/auth_repo.dart'; // Ensure this path is correct

class BidViewModel extends GetxController {
  // Inject necessary repositories. ViewModels interact with Repositories, not other ViewModels for data.
  final BidRepository bidRepository = Get.find();
  final UserProfileRepository userProfileRepository = Get.find();
  final AuthRepository authRepository = Get.find();

  // Observable list for displaying bids (if you have a screen showing bid history)
  // You might want to filter this by auctionId later for a specific auction's bids.
  RxList<Bid> loadAllBidsList = <Bid>[].obs;
  // RxList<Bid> currentBidList = <Bid>[].obs;
  var loadAllBidsOfCurrentUserList = <Bid>[].obs;
  // var auctionList = <Auction>[].obs;

  // Loading state for UI feedback
  RxBool isPlacingBid = false.obs;

   String? get currentFirebaseUserId =>  authRepository.getLoggedInUser()?.uid;

   @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadAllBidsOfCurrentUser();
    loadAllBids();
  }


  // No need for a 'late Bid bid;' field here, as we create a new Bid object per action.

  // --- Core Method: Place a Bid ---
  // This method now correctly receives the specific Auction object
  // and the new bid amount from the UI or another orchestrating ViewModel/Service.
  Future<void> placeBid(Auction auction, double newBidAmount) async {
    isPlacingBid.value = true; // Indicate that a bid placement is in progress

    try {
      // 1. Get the current authenticated user's ID
      // This is done through the AuthRepository, which handles Firebase Auth specifics.

      if (currentFirebaseUserId == null) {
        Get.snackbar('Error', 'You must be logged in to place a bid.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return; // Exit if user is not logged in
      }

      // 2. Get the full UserProfile details (including username/displayName)
      // This is done through the UserProfileRepository.
      final UserProfile? currentUserProfile =
      await userProfileRepository.getUserById(currentFirebaseUserId!);

      if (currentUserProfile == null) {
        Get.snackbar('Error', 'Your user profile could not be loaded. Please try again.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return; // Exit if user profile is missing
      }

      // 3. Perform Client-Side Bid Validation
      // These checks ensure the bid is valid before attempting to write to Firestore.
      if (newBidAmount <= auction.currentBid) {
        Get.snackbar('Bid Error', 'Your bid ($newBidAmount) must be higher than the current bid (${auction.currentBid}).',
            backgroundColor: Colors.red, colorText: Colors.white);
        return; // Stop if bid is not high enough
      }
      if (auction.endTime.isBefore(DateTime.now())) {
        Get.snackbar('Bid Error', 'This auction has already ended.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return; // Stop if auction is over
      }
      if (auction.status ==false) {
        Get.snackbar('Bid Error', 'This auction is not active or has been cancelled.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return; // Stop if auction is not active
      }

      // 4. Create the new Bid object
      // 'bidId' is initially empty; the repository will assign a Firestore document ID.
      final Bid newBid = Bid(
        bidId: '',
        auctionId: auction.id,
        auctionTitle: auction.title,
        auctionImageUrl: auction.imageUrl, // Assuming 'imageUrl' exists in your Auction model
        bidderId: currentUserProfile.id, // Use the ID from the fetched user profile
        bidderUsername: currentUserProfile.displayName, // Use displayName from user profile
        amount: newBidAmount,
        bidDateTime: DateTime.now(), // Using client's local time; server timestamp is ideal with Cloud Functions.
        isWinningBid: false, // Default to false; updated when auction ends.
      );

      // 5. Call the BidRepository to perform the atomic update (bid + auction)
      // The repository handles the Firestore WriteBatch operation.
      await bidRepository.placeBidAndContemporaneouslyUpdateAuction(
        newBid,
        auction.id,
        newBidAmount,
        currentUserProfile.id,
      );

      // Success feedback
      Get.back();
      Get.snackbar('Success', 'Your bid has been placed successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);


      // Optional: If you need to update UI immediately or navigate away
      // e.g., Get.back();

    } catch (e) {
      // Catch any errors during the process
      print("Error in BidViewModel placeBid: $e"); // Log for debugging
      Get.snackbar('Error', 'Failed to place bid: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isPlacingBid.value = false; // Always reset loading state
    }
  }

  // void loadAllBids() {
  //   bidRepository.loadAllBids().listen((data) {
  //     bidList.value = data;
  //   });
  // }

void loadAllBidsOfCurrentUser(){
     if (currentFirebaseUserId==null) return;

    bidRepository.loadAllBidsOfCurrentUser(currentFirebaseUserId!).listen((data) {
      loadAllBidsOfCurrentUserList.value = data;
    });

}

void loadAllBids()  {
     bidRepository.loadAllBids().listen((data){
       loadAllBidsList.value=data;
     });

}
  void deleteBid(Bid bid) {
     bidRepository.deleteBid(bid);
  }
}