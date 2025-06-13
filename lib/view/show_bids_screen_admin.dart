import 'package:auction_app/view_model/bid_vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/bid.dart';

class ShowAuctionsAdmin extends StatelessWidget {
  ShowAuctionsAdmin({super.key});

  final BidViewModel bidViewModel = Get.find<BidViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final groupedBids = bidViewModel.groupBidsByAuction(bidViewModel.loadAllBidsList);

        // 🔸 Sort and mark winning bids
        bidViewModel.sortGroupedBidsByAmount(groupedBids);

        if (groupedBids.isEmpty) {
          return const Center(
            child: Text(
              'No bids available.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: groupedBids.entries.map((entry) {
            List<Bid> bids = entry.value;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Auction Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: bids.isNotEmpty && bids.first.auctionImageUrl != null
                          ? Image.network(
                        bids.first.auctionImageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),
                      )
                          : Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 👇 Looping through Bids
                    ...bids.map((bid) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, size: 18, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                bid.bidderUsername,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(width: 10),

                              // 🏆 Winning Badge
                              if (bid.isWinningBid)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[700],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Winning Bid',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.attach_money, size: 18, color: Colors.green),
                              const SizedBox(width: 5),
                              Text(
                                '\$${bid.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 18, color: Colors.blueGrey),
                              const SizedBox(width: 5),
                              Text(
                                _formatDateTime(bid.bidDateTime),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }),

    );
  }

  String _formatDateTime(DateTime dt) {
    return dt.toLocal().toString().split('.')[0];
  }
}
