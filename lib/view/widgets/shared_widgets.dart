import 'package:auction_app/view_model/bid_vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/auction.dart';

String formatEndTime(DateTime endTime) {
  return DateFormat('MMM d, hh:mm a').format(endTime);
}

Widget infoChip(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 20, color: Colors.deepPurple),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    ],
  );
}

void showBidDialog(BuildContext context, Auction auction, BidViewModel bidViewModel) {
  final TextEditingController bidController = TextEditingController();

  Get.dialog(
    AlertDialog(
      title: const Text("Place Your Bid"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Current Highest Bid: \$${auction.currentBid}"),
          const SizedBox(height: 10),
          TextField(
            controller: bidController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Enter your bid",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        TextButton(
          onPressed: () {
            final newBid = double.tryParse(bidController.text);
            if (newBid == null || newBid <= auction.currentBid) {
              Get.snackbar("Invalid Bid", "Your bid must be greater than \$${auction.currentBid}");
              return;
            }

            bidViewModel.placeBid(auction, newBid);
          },
          child: const Text("Place Bid", style: TextStyle(color: Colors.green)),
        ),
      ],
    ),
  );
}
