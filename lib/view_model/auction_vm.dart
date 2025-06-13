import 'package:auction_app/model/auction.dart';
import 'package:auction_app/repositories/auction_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../repositories/media_repo.dart';

class AuctionViewModel extends GetxController {
  AuctionRepository auctionRepository = Get.find();
  MediaRepository mediaRepository = Get.find();

  // adding in the database variables
  Rxn<XFile> image = Rxn<XFile>();

  // Change this from Rx<GlobalKey<FormState>> to GlobalKey<FormState>
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<bool> status = false.obs;
  Rxn<DateTime> selectedEndTime = Rxn<DateTime>();

  // progress variables
  var isLoading = false.obs;
  var isSaving = false.obs;

  // fetching from database variables
  var auctionList = <Auction>[].obs;

  // holding the singleAuction that is derived from list
  final Rxn<Auction> selectedAuctionDetails = Rxn<Auction>();

  @override
  void onInit() {
    super.onInit();
    loadAllAuctions();
  }

  // deriving single auction for auction details screen

  Future<void> addUpdateAuctions(
    String title,
    String description,
    String startBid,
    Auction? auction,
  ) async {
    // Access formKey directly
    if (!formKey.currentState!.validate()) return;

    if (image.value == null && auction == null) {
      // Check if new image is needed for new auction
      Get.snackbar("Image Error", "Please pick an image");
      return;
    }

    if (selectedEndTime.value == null) {
      Get.snackbar("Date Time Error", "Please pick end date & time");
      return;
    }

    isSaving.value = true;

    try {
      if (auction == null) {
        Auction addAuction = Auction(
          id: '',
          title: title,
          description: description,
          imageUrl: '',
          startBid: int.parse(startBid),
          currentBid: int.parse(startBid),
          endTime: selectedEndTime.value!,
          highestBidderId: '',
          bidCount: 0,
          status: status.value,
        );

        await uploadImage(addAuction);
        await auctionRepository.addAuction(addAuction);

        Get.snackbar("Success", "Auction added successfully");
        // TODO:CREATING PROBLEM WHEN GET.OFFALL IS CALLED
        Get.offAllNamed('/home');
      } else {
        // Updating existing auction
        if (image.value != null) {
          await uploadImage(auction);
        }

        Auction updatedAuction = Auction(
          id: auction.id,
          title: title,
          description: description,
          imageUrl: auction.imageUrl,
          startBid: int.parse(startBid),
          currentBid: auction.currentBid,
          endTime: selectedEndTime.value ?? auction.endTime,
          highestBidderId: auction.highestBidderId,
          bidCount: auction.bidCount,
          status: status.value,
        );

        await auctionRepository.updateAuction(updatedAuction);
        Get.snackbar("Success", "Auction updated successfully");
        // TODO:CREATING PROBLEM WHEN GET.OFFALL IS CALLED
        Get.offAllNamed('/home');
      }

      // Reset the form values (not the key itself)
      image.value = null;
      selectedEndTime.value = null;
      formKey.currentState?.reset(); // Use reset on the current state
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  void loadAllAuctions() {
    print('load products called');
    auctionRepository.loadAllAuctions().listen((data) {
      auctionList.value = data;
      print('Auction List Loaded: ${data.length} items');
      print("Auction List ids ${data.map((e) => e.id)} items");
    });
  }

  // utility functions
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    image.value = await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadImage(Auction auction) async {
    if (image.value != null) {
      var imageResult = await mediaRepository.uploadImage(image.value!.path);
      if (imageResult.isSuccessful) {
        auction.imageUrl = imageResult.url!;
      } else {
        Get.snackbar(
          "Error uploading image",
          imageResult.error ?? 'could not upload image due to unknown error',
        );
      }
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        selectedEndTime.value = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
  }

  Future<void> deleteAuction(Auction auction) async {
    try {
      await auctionRepository.deleteAuction(auction);

      // Update UI after successful deletion
      auctionList.removeWhere((item) => item.id == auction.id);
      Get.snackbar("Success", "Auction and related bids deleted successfully");
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete auction and bids: ${e.toString()}",
      );
    }
  }
}
