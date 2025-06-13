class Bid {
  String bidId;
  String auctionId;
  String bidderId;
  String auctionTitle; // Added: For easy display in bid history
  String? auctionImageUrl; // Added: Optional, for thumbnail in bid history
  String bidderUsername; // Added: For displaying bidder's name
  double amount; // Changed to double or int for numerical operations
  DateTime bidDateTime; // Changed from String timestamp to DateTime
  // String timestamp; // Can be derived from bidDateTime for display
  bool isWinningBid; // Added: To mark the winning bid

  Bid({
    required this.bidId,
    required this.auctionId,
    required this.auctionTitle,
    this.auctionImageUrl, // Optional
    required this.bidderId,
    required this.bidderUsername,
    required this.amount,
    required this.bidDateTime,
    this.isWinningBid = false, // Default to false
  });

  // You might want to add a factory constructor for converting from JSON/Map
  factory Bid.fromMap(Map<String, dynamic> json) {
    return Bid(
      bidId: json['id'],
      auctionId: json['auctionId'],
      auctionTitle: json['auctionTitle'],
      auctionImageUrl: json['auctionImageUrl'],
      bidderId: json['bidderId'],
      bidderUsername: json['bidderUsername'],
      amount: (json['amount'] as num).toDouble(),
      // Handle num to double
      bidDateTime: DateTime.parse(json['bidDateTime']),
      // Parse string to DateTime
      isWinningBid: json['isWinningBid'],
    );
  }

  // And a toJson method for converting to JSON/Map
  Map<String, dynamic> toMap() {
    return {
      'id': bidId,
      'auctionId': auctionId,
      'auctionTitle': auctionTitle,
      'auctionImageUrl': auctionImageUrl,
      'bidderId': bidderId,
      'bidderUsername': bidderUsername,
      'amount': amount,
      'bidDateTime': bidDateTime.toIso8601String(), // Store as ISO 8601 string
      'isWinningBid': isWinningBid,
    };
  }
}
