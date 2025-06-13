import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/bid.dart';
import '../view_model/bid_vm.dart';

class MyBidsScreenUser extends StatefulWidget {
  const MyBidsScreenUser({super.key});

  @override
  State<MyBidsScreenUser> createState() => _MyBidsScreenUserState();
}

class _MyBidsScreenUserState extends State<MyBidsScreenUser> {
  late BidViewModel bidViewModel;

  @override
  void initState() {
    super.initState();
    bidViewModel = Get.find();
    // Ensure the bids are loaded when the screen initializes
    bidViewModel.loadAllBidsOfCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bidViewModel.loadAllBidsOfCurrentUserList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gavel_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "You haven't placed any bids yet.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Browse auctions and place your first bid!",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(8.0), // Add some padding around the list
        itemCount: bidViewModel.loadAllBidsOfCurrentUserList.length,
        itemBuilder: (context, index) {
          Bid bid = bidViewModel.loadAllBidsOfCurrentUserList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            elevation: 4.0, // Add some shadow for depth
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12.0,
              ), // Rounded corners for the card
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align content to the start
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Auction Image
                      if (bid.auctionImageUrl != null &&
                          bid.auctionImageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          // Rounded corners for the image
                          child: Image.network(
                            bid.auctionImageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey[400],
                                  ),
                                ),
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                        ),
                      const SizedBox(width: 12),
                      // Bid Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bid.auctionTitle ?? 'Auction Title Not Available',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your Bid:  \$${bid.amount.toStringAsFixed(2) ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Winning Bid Status (conditional display)
                            if (bid.isWinningBid == true)
                              const Text(
                                '🏆 Winning Bid!',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              'Placed by: ${bid.bidderUsername ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'On: ${bid.bidDateTime?.toLocal().toString().split('.')[0] ?? 'N/A'}', // Format datetime
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1), // Separator
                  Align(
                    alignment: Alignment.centerRight,
                    // Align delete button to the right
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Delete Bid",
                          middleText:
                              "Are you sure you want to delete this bid?",
                          textConfirm: "Delete",
                          textCancel: "Cancel",
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.redAccent,
                          onConfirm: () {
                            bidViewModel.deleteBid(bid);
                            Get.back(); // Close the dialog
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete Bid"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
