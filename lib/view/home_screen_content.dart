import 'package:auction_app/model/auction.dart';
import 'package:auction_app/view/auction_details_screen_admin.dart';
import 'package:auction_app/view_model/UserProfile_vm.dart';
import 'package:auction_app/view_model/auction_vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auction_detail_screen_user.dart';

class HomeScreenContent extends StatefulWidget {
  HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // initializing variables
  late AuctionViewModel auctionViewModel;
  late UserProfileVM userProfileVM;

  // initState
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auctionViewModel = Get.find();
    userProfileVM = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading or empty state if needed
      // TODO: WHEN LAST AUCTION DELETED IT DOES NOT SHOW THIS TEXT LINE
      if (auctionViewModel.auctionList.isEmpty) {
        return const Center(child: Text("No auctions available",style: TextStyle(color: Colors.blueAccent,fontSize: 30),));
      }
      // if(auctionViewModel.auctionRepository.auctionCollection==null){
      //   return const Center(child: Text("No auctions available.",));
      // }
      return ListView.builder(
        itemCount: auctionViewModel.auctionList.length,
        itemBuilder: (context, index) {
          Auction auction = auctionViewModel.auctionList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and details as before
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    auction.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, _, __) => Container(
                          height: 50,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 40),
                          ),
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auction.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // short Description
                      Text(
                        auction.description.length > 100
                            ? '${auction.description.substring(0, 100)}...'
                            : auction.description,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        ' Current Bid:  ${auction.currentBid.toString()}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' End Date:  ${auction.endTime}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        children: [Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // _infoChip(
                            //   Icons.person,
                            //   auction.highestBidderId ?? 'No bids yet',
                            // ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                auction.status // If auction.status is true (meaning active)
                                    ? Colors.green[100] // Use green background for 'Active'
                                    : Colors.orange[100], // Use orange for 'Inactive' (or whatever you prefer for inactive)
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                // Display "ACTIVE" if status is true, "INACTIVE" if status is false
                                auction.status ? 'ACTIVE' : 'INACTIVE',
                                style: TextStyle(
                                  color:
                                  auction.status // If auction.status is true (meaning active)
                                      ? Colors.green[800] // Use dark green text for 'Active'
                                      : Colors.orange[800], // Use dark orange text for 'Inactive' (or whatever you prefer for inactive)
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),]
                      ),
                      const SizedBox(height: 14),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          print(
                            'Auction ID being passed: ${auction.id}',
                          ); // Debug

                          if (auction.id.isNotEmpty) {
                            final isAdmin =
                                userProfileVM.selectedUser.value?.isAdmin ??
                                false;

                            if (isAdmin) {
                              Get.to(
                                () => const AuctionDetailsScreenAdmin(),
                                arguments: auction,
                              );
                            } else {
                              Get.to(
                                () => const AuctionDetailsScreenUser(),
                                arguments: auction,
                              );
                            }
                          } else {
                            print('Error: Auction ID is empty');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                        ),
                        child: const Text(
                          'Auction Details',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.deepPurple),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
