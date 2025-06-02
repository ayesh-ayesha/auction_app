import 'package:auction_app/model/auction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuctionRepository {
  late CollectionReference auctionCollection;
  late CollectionReference bidCollection;



  AuctionRepository() {
    auctionCollection = FirebaseFirestore.instance.collection('auctions');
    bidCollection = FirebaseFirestore.instance.collection('bids');

  }

  Future<void> addAuction(Auction auction) {
    var doc = auctionCollection.doc();
    auction.id = doc.id;
    return doc.set(auction.toMap());
  }

  Future<void> updateAuction(Auction auction) {
    return auctionCollection.doc(auction.id).set(auction.toMap());

  }


  Stream<List<Auction>> loadAllAuctions() {
    return auctionCollection.snapshots().map((snapshot) {
      return convertToAuctions(snapshot);
    });
  }

  Stream<List<Auction>> loadAllAuctionsOfShop(String id) {
    return auctionCollection.where('id', isEqualTo: id).snapshots().map((
      snapshot,
    ) {
      return convertToAuctions(snapshot);
    });
  }

  Future<List<Auction>> loadAllAuctionsOnce() async {
    var snapshot = await auctionCollection.get();
    return convertToAuctions(snapshot);
  }



  // utility function
  List<Auction> convertToAuctions(QuerySnapshot snapshot) {
    List<Auction> products = [];
    for (var snap in snapshot.docs) {
        products.add(Auction.fromMap(snap.data() as Map<String, dynamic>));
    }
    return products;
  }

  Future<Auction> getAuctionsById(String id) async {
    var snapshot = await auctionCollection.doc(id).get();
    return Auction.fromMap(snapshot.data() as Map<String, dynamic>);
  }



    Future<void> deleteAuction(Auction auction) async {
// 1. Get all bids related to this auction
      // We need to use `get()` for a one-time fetch, not `listen()`
      final QuerySnapshot bidsSnapshot = await bidCollection
          .where('auctionId', isEqualTo: auction.id)
          .get();

      // Start a Firestore WriteBatch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // 2. Add all bid deletions to the batch
      for (DocumentSnapshot doc in bidsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 3. Add the auction deletion to the batch
      batch.delete(auctionCollection.doc(auction.id));

      // 4. Commit the batch
      await batch.commit();    }
  }

