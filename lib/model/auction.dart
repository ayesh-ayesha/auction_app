

import 'package:cloud_firestore/cloud_firestore.dart';

class Auction {
  String id;
  String title;
  String description;
  String imageUrl;
  int startBid;
  int currentBid;
  DateTime endTime;
  String? highestBidderId;
  int bidCount;
  bool status;

  Auction({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startBid,
    required this.currentBid,
    required this.endTime,
    this.highestBidderId,
    this.bidCount = 0,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'startBid': startBid,
      'currentBid': currentBid,
      'endTime': endTime,
      'highestBidderId': highestBidderId,
      'bidCount': bidCount,
      'status': status,
    };
  }

  factory Auction.fromMap(Map<String, dynamic> map) {
    return Auction(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      startBid: _parseInt(map['startBid']),
      currentBid: _parseInt(map['currentBid']),
      endTime: (map['endTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      highestBidderId: map['highestBidderId'],
      bidCount: _parseInt(map['bidCount']),
      status: map['status'] ?? false,
    );
  }


  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

}
