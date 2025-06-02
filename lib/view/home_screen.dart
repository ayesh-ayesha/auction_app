import 'package:auction_app/repositories/auction_repo.dart';
import 'package:auction_app/repositories/auth_repo.dart';
import 'package:auction_app/view/home_screen_content.dart';
import 'package:auction_app/view/my_bids_screen_user.dart';
import 'package:auction_app/view_model/UserProfile_vm.dart';
import 'package:auction_app/view_model/bid_vm.dart';
import 'package:auction_app/view_model/login_vm.dart';
import 'package:auction_app/view_model/signup_vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/bid_repo.dart';
import '../repositories/media_repo.dart';
import '../view_model/auction_vm.dart';
import 'add_auction_screen_admin.dart';
import 'show_bids_screen_admin.dart';

//my Code
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  List<Widget> getScreensForRole(bool isAdmin) {
    if (isAdmin) {
      return [
        HomeScreenContent(),
        AddAuctionScreenAdmin(),
        ShowAuctionsAdmin(),
        // AuctionDetailsScreenAdmin(),
      ];
    } else {
      return [
        HomeScreenContent(),
        MyBidsScreenUser(),
        // AuctionDetailsScreenUser()
      ];
    }
  }

  List<BottomNavigationBarItem> getNavItemsForRole(bool role) {
    if (role) {
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_outlined),
          activeIcon: Icon(Icons.add),
          label: "Add Auction",
        ),
        // BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long),label: "Auctions Details"),
        BottomNavigationBarItem(
          icon: Icon(Icons.gavel_outlined),
          activeIcon: Icon(Icons.gavel),
          label: "Manage Bids",
        ),
      ];
    } else {
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Browse",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gavel_outlined),
          activeIcon: Icon(Icons.gavel),
          label: "My Bids",
        ),
        // BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long),label: "Auctions Details"),
      ];
    }
  }

  void onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  late LoginViewModel loginViewModel;
  late UserProfileVM userProfileVM;
  late SignUpViewModel signUpViewModel;

  @override
  void initState() {
    super.initState();
    loginViewModel = Get.find();
    userProfileVM = Get.find();
    String? currentUserId = loginViewModel.getCurrentUserId();
    if (currentUserId != null) {
      userProfileVM.fetchUserById(currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auction app"),
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.person, size: 28),
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 0,
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Loading State
                          Obx(() {
                            if (userProfileVM.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return SizedBox.shrink();
                          }),

                          // Error State
                          Obx(() {
                            if (userProfileVM.errorMessage.value.isNotEmpty) {
                              return Text(
                                "⚠️ ${userProfileVM.errorMessage.value}",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          }),

                          // User Info
                          Obx(() {
                            final user = userProfileVM.selectedUser.value;
                            if (userProfileVM.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (user != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "👤 ${user.displayName ?? 'No name'}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "📧 ${user.email ?? 'No email'}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 4),

                                  DropdownButton<bool>(
                                    items: const [
                                      DropdownMenuItem<bool>(
                                        value: false,
                                        child: Text("User"),
                                      ),
                                      DropdownMenuItem<bool>(
                                        value: true,
                                        child: Text("Admin"),
                                      ),
                                    ],
                                    value: user.isAdmin,
                                    // fallback to false if null
                                    onChanged: (bool? newValue) {
                                      if (newValue != null) {
                                        userProfileVM.updateStatus(newValue);
                                      }
                                    },
                                  ),

                                  Text(
                                    "🔐 Role: ${user.isAdmin ? "Admin" : "User"}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              );
                            } else if (!userProfileVM.isLoading.value &&
                                userProfileVM.errorMessage.value.isEmpty) {
                              return Text("No user data available");
                            }
                            return SizedBox.shrink();
                          }),

                          const SizedBox(height: 12),
                          Divider(),

                          Center(
                            child: ElevatedButton.icon(
                              onPressed: loginViewModel.logout,
                              icon: Icon(Icons.logout),
                              label: Text('Logout'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Obx(() {
        final user = userProfileVM.selectedUser.value;
        if (user == null) {
          return Center(child: CircularProgressIndicator());
        }

        bool userRole = user.isAdmin;
        List<Widget> screens = getScreensForRole(userRole);

        // Make sure currentPageIndex doesn't exceed available screens
        if (currentPageIndex >= screens.length) {
          currentPageIndex = 0;
        }

        return screens[currentPageIndex];
      }),

      // Dynamic bottom navigation based on user role
      bottomNavigationBar: Obx(() {
        final user = userProfileVM.selectedUser.value;
        if (user == null) {
          return SizedBox.shrink(); // Hide nav bar while loading
        }

        bool userRole = user.isAdmin;
        List<BottomNavigationBarItem> navItems = getNavItemsForRole(userRole);

        return BottomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: onItemTapped,
          items: navItems,
          type: BottomNavigationBarType.fixed,
          // Shows all tabs
          selectedItemColor: userRole ? Colors.grey : Colors.orangeAccent,
          showUnselectedLabels: false,
        );
      }),
    );
  }
}

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    AuthRepository();
    Get.put(UserProfileVM());
    Get.put(AuctionRepository(), permanent: true);
    Get.put(MediaRepository());
    Get.put(AuctionViewModel());
    Get.put(BidRepository());
    Get.put(BidViewModel());
  }
}
