// lib/view_model/bid_vm.dart

import 'package:flutter/material.dart'; // Required for Get.snackbar UI elements
import 'package:get/get.dart';

import '../model/auction.dart'; // Make sure this path is correct for your Auction model
// Import your models
import '../model/bid.dart';
import '../model/user_profile.dart'; // Make sure this path is correct for your UserProfile model
import '../repositories/auth_repo.dart'; // Ensure this path is correct
// Import your repositories
import '../repositories/bid_repo.dart';
import '../repositories/user_profile_repo.dart'; // Ensure this path is correct

class BidViewModel extends GetxController {
  // Inject necessary repositories. ViewModels interact with Repositories, not other ViewModels for data.
  final BidRepository bidRepository = Get.find();
  final UserProfileRepository userProfileRepository = Get.find();
  final AuthRepository authRepository = Get.find();

  // Observable list for displaying bids (if you have a screen showing bid history)
  RxList<Bid> loadAllBidsList = <Bid>[].obs;

  // RxList<Bid> currentBidList = <Bid>[].obs;
  var loadAllBidsOfCurrentUserList = <Bid>[].obs;

  // var auctionList = <Auction>[].obs;

  // Loading state for UI feedback
  RxBool isPlacingBid = false.obs;

  var liveBids = <Map<String, dynamic>>[].obs;

  String? get currentFirebaseUserId => authRepository.getLoggedInUser()?.uid;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadAllBidsOfCurrentUser();
    loadAllBids();
  }

  Future<void> placeBid(Auction auction, double newBidAmount) async {
    isPlacingBid.value = true; // Indicate that a bid placement is in progress

    try {
      // 1. Get the current authenticated user's ID
      // This is done through the AuthRepository, which handles Firebase Auth specifics.

      if (currentFirebaseUserId == null) {
        Get.snackbar(
          'Error',
          'You must be logged in to place a bid.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Exit if user is not logged in
      }

      // 2. Get the full UserProfile details (including username/displayName)
      // This is done through the UserProfileRepository.
      final UserProfile? currentUserProfile = await userProfileRepository
          .getUserById(currentFirebaseUserId!);

      if (currentUserProfile == null) {
        Get.snackbar(
          'Error',
          'Your user profile could not be loaded. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Exit if user profile is missing
      }

      // 3. Perform Client-Side Bid Validation
      // These checks ensure the bid is valid before attempting to write to Firestore.
      if (newBidAmount <= auction.currentBid) {
        Get.snackbar(
          'Bid Error',
          'Your bid ($newBidAmount) must be higher than the current bid (${auction.currentBid}).',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Stop if bid is not high enough
      }
      if (auction.endTime.isBefore(DateTime.now())) {
        Get.snackbar(
          'Bid Error',
          'This auction has already ended.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Stop if auction is over
      }
      if (auction.status == false) {
        Get.snackbar(
          'Bid Error',
          'This auction is not active or has been cancelled.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Stop if auction is not active
      }

      // 4. Create the new Bid object
      // 'bidId' is initially empty; the repository will assign a Firestore document ID.
      final Bid newBid = Bid(
        bidId: '',
        auctionId: auction.id,
        auctionTitle: auction.title,
        auctionImageUrl: auction.imageUrl,
        // Assuming 'imageUrl' exists in your Auction model
        bidderId: currentUserProfile.id,
        // Use the ID from the fetched user profile
        bidderUsername: currentUserProfile.displayName,
        // Use displayName from user profile
        amount: newBidAmount,
        bidDateTime: DateTime.now(),
        // Using client's local time; server timestamp is ideal with Cloud Functions.
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
      Get.snackbar(
        'Success',
        'Your bid has been placed successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Optional: If you need to update UI immediately or navigate away
      // e.g., Get.back();
    } catch (e) {
      // Catch any errors during the process
      print("Error in BidViewModel placeBid: $e"); // Log for debugging
      Get.snackbar(
        'Error',
        'Failed to place bid: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPlacingBid.value = false; // Always reset loading state
    }
  }

  void loadAllBidsOfCurrentUser() {
    if (currentFirebaseUserId == null) return;

    bidRepository.loadAllBidsOfCurrentUser(currentFirebaseUserId!).listen((
      data,
    ) {
      loadAllBidsOfCurrentUserList.value = data;
    });
  }

  void loadAllBids() {
    bidRepository.loadAllBids().listen((data) {
      loadAllBidsList.value = data;
    });
  }

  // utility function
  Map<String, List<Bid>> groupBidsByAuction(List<Bid> bids) {
    Map<String, List<Bid>> grouped = {};

    for (var bid in bids) {
      grouped.putIfAbsent(bid.auctionId, () => []).add(bid);
    }

    return grouped;
  }

  void sortGroupedBidsByAmount(Map<String, List<Bid>> grouped) {
    for (var bids in grouped.values) {
      if (bids.isEmpty) continue;

      // Sort descending: highest bid first
      bids.sort((a, b) => b.amount.compareTo(a.amount));

      // Set the highest bid's flag
      for (int i = 0; i < bids.length; i++) {
        bids[i].isWinningBid = (i == 0);
      }
    }
  }

  void deleteBid(Bid bid) {
    bidRepository.deleteBid(bid);
  }
}
