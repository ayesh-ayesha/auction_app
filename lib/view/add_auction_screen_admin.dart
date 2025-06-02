import 'dart:io';
import 'package:auction_app/view_model/auction_vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/auction.dart';

class AddAuctionScreenAdmin extends StatefulWidget {
  const AddAuctionScreenAdmin({super.key});

  @override
  State<AddAuctionScreenAdmin> createState() => AddAuctionScreenAdminState();
}

class AddAuctionScreenAdminState extends State<AddAuctionScreenAdmin> {
  // Public Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startBidController = TextEditingController();

  late AuctionViewModel auctionViewModel;
  Auction? auction;

  @override
  void initState() {
    super.initState();
    auctionViewModel = Get.find();
    auction = Get.arguments;



    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auction != null) {
        titleController.text = auction!.title;
        descriptionController.text = auction!.description;
        startBidController.text = auction!.startBid.toString();

        Future.delayed(Duration.zero, () {
          auctionViewModel.image.value = null;
          auctionViewModel.selectedEndTime.value = auction!.endTime;
          auctionViewModel.status.value = auction!.status;
        });
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startBidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // Remove Obx here
        child: Form(
          key: auctionViewModel.formKey, // Use formKey directly, not its .value
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              buildTextField(titleController, 'Title', 'Enter auction title'),
              buildTextField(
                descriptionController,
                'Description',
                'Enter description',
                maxLines: 3,
              ),
              buildTextField(
                startBidController,
                'Start Bid',
                'Enter starting bid',
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Image Picker
              Text(
                'Auction Image',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: auctionViewModel.pickImage,
                child: Obx(
                      () => Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      image: auctionViewModel.image.value != null
                          ? DecorationImage(
                        image: FileImage(
                            File(auctionViewModel.image.value!.path)),
                        fit: BoxFit.cover,
                      )
                          : auction != null
                          ? DecorationImage(
                        image: NetworkImage(auction!.imageUrl),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: auctionViewModel.image.value == null && auction == null
                        ? const Center(child: Text("Tap to select image"))
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // DateTime Picker
              Text('End Time', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => auctionViewModel.pickDateTime(context),
                child: Obx(
                      () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Text(
                      auctionViewModel.selectedEndTime.value != null
                          ? auctionViewModel.selectedEndTime.value
                          .toString() // You might want to format this
                          : 'Tap to select date & time',
                      style: TextStyle(
                        color: auctionViewModel.selectedEndTime.value != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Status Switch
              Obx(
                    () => SwitchListTile(
                  title: const Text('Active Status'),
                  value: auctionViewModel.status.value,
                  onChanged: (newValue) =>
                  auctionViewModel.status.value=newValue , // Directly update the RxBool
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                      () => auctionViewModel.isSaving.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      auctionViewModel.addUpdateAuctions(
                        titleController.text,
                        descriptionController.text,
                        startBidController.text,
                        auction,
                      );
                    },
                    child: Text(
                      auction == null ? 'Create Auction' : 'Update Auction',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller,
      String label,
      String hint, {
        int maxLines = 1,
        TextInputType inputType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: inputType,
        decoration: inputDecoration(hint).copyWith(labelText: label),
        validator: (value) =>
        value == null || value.isEmpty ? 'This field is required' : null,
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}