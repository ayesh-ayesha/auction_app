import 'package:auction_app/view_model/bid_vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/bid.dart';

class ShowAuctionsAdmin extends StatefulWidget {
  const ShowAuctionsAdmin({super.key});

  @override
  State<ShowAuctionsAdmin> createState() => _ShowAuctionsAdminState();
}

class _ShowAuctionsAdminState extends State<ShowAuctionsAdmin> {
  late BidViewModel bidViewModel;

  @override
  void initState() {
    super.initState();
    bidViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with Obx to react to changes in bidViewModel.loadAllBidsList
    return Obx(
          () => bidViewModel.loadAllBidsList.isEmpty
          ? const Center(
        child: Text(
          'No bids to display yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: bidViewModel.loadAllBidsList.length,
        itemBuilder: (context, index) {
          Bid bid = bidViewModel.loadAllBidsList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Auction Title
                  Text(
                    bid.auctionTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Bidder Username
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        'Bidder: ${bid.bidderUsername}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Bid Amount
                  Row(
                    children: [
                      const Icon(Icons.money, size: 18, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'Amount: \$${bid.amount.toStringAsFixed(2)}', // Format as currency
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Bid Date and Time
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: Colors.blueGrey),
                      const SizedBox(width: 5),
                      Text(
                        'Time: ${bid.bidDateTime.toLocal().toString().split('.')[0]}', // Nicer date format
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Auction Image
                  if (bid.auctionImageUrl != null && bid.auctionImageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        bid.auctionImageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                  if (bid.auctionImageUrl == null || bid.auctionImageUrl!.isEmpty)
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Text(
                          'No Image Available',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}