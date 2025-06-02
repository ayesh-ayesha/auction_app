import 'package:auction_app/model/bid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class BidRepository {
  late CollectionReference bidCollection;
  late CollectionReference auctionCollection;

  BidRepository() {
    bidCollection = FirebaseFirestore.instance.collection('bids');
    auctionCollection = FirebaseFirestore.instance.collection('auctions');
  }

  // Used for direct bid placement (avoid this if you want validation)
  Future<void> placeBid(Bid bid) async {
    var doc = bidCollection.doc();
    bid.bidId = doc.id;
    return doc.set(bid.toMap());
  }

  // Get existing bid by this user for a specific auction
  Future<Bid?> getUserBidForAuction(String auctionId, String userId) async {
    final query = await bidCollection
        .where('auctionId', isEqualTo: auctionId)
        .where('bidderId', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return Bid.fromMap(doc.data() as Map<String, dynamic>)..bidId = doc.id;
    }
    return null;
  }

  // Place bid and update auction in a single transaction
  Future<void> placeBidAndContemporaneouslyUpdateAuction(
      Bid newBid,
      String auctionId,
      double newBidAmount,
      String highestBidderId,
      ) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference auctionDocRef = auctionCollection.doc(auctionId);

    // Step 1: Check if user already placed a bid
    Bid? existingBid = await getUserBidForAuction(auctionId, newBid.bidderId!);

    DocumentReference bidDocRef;

    if (existingBid != null) {
      // Update existing bid
      newBid.bidId = existingBid.bidId;
      bidDocRef = bidCollection.doc(existingBid.bidId);
      batch.update(bidDocRef, newBid.toMap());
    } else {
      // Place a new bid
      bidDocRef = bidCollection.doc();
      newBid.bidId = bidDocRef.id;
      batch.set(bidDocRef, newBid.toMap());
    }

    // Step 2: Update auction stats
    batch.update(auctionDocRef, {
      'currentBid': newBidAmount,
      'highestBidderId': highestBidderId,
      'bidCount': FieldValue.increment(1),
      'userBidCounts.${newBid.bidderId}': FieldValue.increment(1),
    });

    return await batch.commit();
  }

  Future<void> deleteBid(Bid bid) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // References
    DocumentReference bidDocRef = bidCollection.doc(bid.bidId);
    DocumentReference auctionDocRef = auctionCollection.doc(bid.auctionId);

    // Step 1: Delete the bid
    batch.delete(bidDocRef);

    // Step 2: Decrease auction bidCount and user's bid count
    batch.update(auctionDocRef, {
      'bidCount': FieldValue.increment(-1),
      'userBidCounts.${bid.bidderId}': FieldValue.increment(-1),
    });

    // Step 3: Recalculate currentBid and highestBidderId
    final allBids = await bidCollection
        .where('auctionId', isEqualTo: bid.auctionId)
        .orderBy('amount', descending: true)
        .get();

    // Filter out the bid being deleted
    final otherBids = allBids.docs.where((doc) => doc.id != bid.bidId).toList();

    if (otherBids.isNotEmpty) {
      final topBid = otherBids.first.data() as Map<String, dynamic>;
      batch.update(auctionDocRef, {
        'currentBid': topBid['amount'],
        'highestBidderId': topBid['bidderId'],
      });
    } else {
      // Fetch the auction document to get the startingBid
      final auctionSnap = await auctionDocRef.get();
      final auctionData = auctionSnap.data() as Map<String, dynamic>;
      final startingBid = auctionData['startBid'] ?? 0;

      batch.update(auctionDocRef, {
        'currentBid': startingBid,
        'highestBidderId': null,
      });
    }

    return await batch.commit();
  }

  Stream<List<Bid>> loadAllBids() {
    return bidCollection.snapshots().map((snapshot) => convertToBids(snapshot));
  }

  Stream<List<Bid>> loadAllBidsOfAuction(String auctionId) {
    return bidCollection
        .where('auctionId', isEqualTo: auctionId)
        .snapshots()
        .map((snapshot) => convertToBids(snapshot));
  }

  Stream<List<Bid>> loadAllBidsOfAllUsers() {
    return bidCollection
        .where('isBidder', isEqualTo: true)
        .snapshots()
        .map((snapshot) => convertToBids(snapshot));
  }

  Stream<List<Bid>> loadAllBidsOfCurrentUser(String userId) {
    return bidCollection
        .where('bidderId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => convertToBids(snapshot));
  }

  List<Bid> convertToBids(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Bid.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
