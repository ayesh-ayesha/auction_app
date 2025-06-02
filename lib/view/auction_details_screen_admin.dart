import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/auction.dart';
import '../view_model/UserProfile_vm.dart';
import '../view_model/auction_vm.dart';
import 'add_auction_screen_admin.dart';
import 'home_screen.dart';
import 'home_screen_content.dart';
import 'widgets/shared_widgets.dart';

class AuctionDetailsScreenAdmin extends StatefulWidget {
  const AuctionDetailsScreenAdmin({super.key});

  @override
  State<AuctionDetailsScreenAdmin> createState() => _AuctionDetailsScreenAdminState();
}

class _AuctionDetailsScreenAdminState extends State<AuctionDetailsScreenAdmin> {
  late AuctionViewModel auctionViewModel;
  late UserProfileVM userProfileVM;
  late Auction auction;

  @override
  void initState() {
    super.initState();
    auctionViewModel = Get.find();
    userProfileVM = Get.find();
    auction = Get.arguments as Auction;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      auctionViewModel.selectedAuctionDetails.value = auction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentAuction = auctionViewModel.selectedAuctionDetails.value;
      if (currentAuction == null) {
        return const Scaffold(body: Center(child: Text('Auction not found')));
      }

      return Scaffold(
        appBar: AppBar(title: Text('Auction ${currentAuction.title}')),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Auction Image
              GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: InteractiveViewer(
                    child: Image.network(
                      currentAuction.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentAuction.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(currentAuction.description, style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        infoChip(Icons.monetization_on, 'Starting Bid: \$${currentAuction.startBid},'),
                        const SizedBox(height: 5),
                        infoChip(Icons.monetization_on, 'Highest Bid: \$${currentAuction.currentBid}'),
                        const SizedBox(height: 5),
                        infoChip(Icons.gavel, 'Bids : ${currentAuction.bidCount}'),
                        const SizedBox(height: 5),
                        infoChip(Icons.timer, 'EndTime : ${formatEndTime(currentAuction.endTime)}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        infoChip(Icons.person, currentAuction.highestBidderId ?? 'No bids yet'),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: currentAuction.status // If status is true (active)
                                ? Colors.green[100] // Use green background
                                : Colors.red[100], // Else (inactive) use red background
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            // Display "Active" if status is true, "Inactive" if status is false
                            currentAuction.status ? 'Active' : 'Inactive',
                            style: TextStyle(
                              // If status is true (active)
                              color: currentAuction.status
                                  ? Colors.green[800] // Use dark green text
                                  : Colors.red[800], // Else (inactive) use dark red text
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.to(AddAuctionScreenAdmin(), arguments: auction);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Edit', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Delete Auction'),
                                content: const Text('Are you sure you want to delete this auction?'),
                                actions: [
                                  TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                                  TextButton(
                                    onPressed: () {
                                      auctionViewModel.deleteAuction(currentAuction);

                                    },
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Delete', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
