import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
class SearchBenefitsScreen extends StatefulWidget {
  const SearchBenefitsScreen({super.key});

  @override
  State<SearchBenefitsScreen> createState() => _SearchBenefitsScreenState();
}

class _SearchBenefitsScreenState extends State<SearchBenefitsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';


  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchText = _searchController.text.toLowerCase();
      });
    });
  }

  List<Map<String, dynamic>> get filteredCategories{
    if (searchText.isEmpty) {
      return staticCategories;
    }
    return staticCategories.where((category) {
      final name = category['name']!.toLowerCase();
      return name.contains(searchText);
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Select Benefits",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search Benefits",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Category Grid or No Result Message
            CategoryProductScreen(categories: filteredCategories),
          ],
        ),
      ),
    );
  }
}

// Static Category List
final List<Map<String, dynamic>> staticCategories = [
  {'name': 'Mobile Recharge', 'icon': Icons.phone_iphone},
  {'name': 'Cashback Offers', 'icon': Icons.money_off_csred},
  {'name': 'Discount Coupons', 'icon': Icons.local_offer,},
  {'name': 'Referral Bonuses', 'icon': Icons.group_add,},
  {'name': 'Data Packs', 'icon': Icons.data_usage},
  {'name': 'DTH Recharge', 'icon': Icons.tv},
  {'name': 'Health & Wellness', 'icon': Icons.health_and_safety},
  {'name': 'Emergency Services', 'icon': Icons.local_hospital},
  {'name': 'Help & Support', 'icon': Icons.help_outline},
];
class CategoryProductScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoryProductScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "No category found",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryBenefitsScreen(
                    categoryName: category['name'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 10.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon inside circular background
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent.withOpacity(0.1),
                      ),
                      child: Icon(
                        category['icon'],
                        size: 30,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Category name
                    Text(
                      category['name']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BenefitItem {
  final String title;
  final String description;
  final IconData icon;

  BenefitItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class CategoryBenefitsScreen extends StatelessWidget {
  final String categoryName;

  final List<String> sliderImages = [
    'assets/slider1.jpeg',
    'assets/slider2.jpeg',
    'assets/slider3.jpeg',
  ];

  CategoryBenefitsScreen({super.key, required this.categoryName});

  List<BenefitItem> getBenefits(String name) {
    switch (name.toLowerCase()) {
      case 'mobile recharge':
        return [
          BenefitItem(
              title: '₹50 Cashback!',
              description: 'Get ₹50 cashback on your first mobile recharge using any UPI method. Offer valid for new users only.',
              icon: Icons.phone_android),
          BenefitItem(
              title: 'Reward Points',
              description: 'Earn 5 reward points for every ₹100 recharge. Points can be redeemed for exciting offers.',
              icon: Icons.card_membership),
          BenefitItem(
              title: 'Bill Reminder',
              description: 'Never miss a due date! Set reminders and enable auto-pay to pay bills on time.',
              icon: Icons.alarm),
          BenefitItem(
              title: 'Top-Up Deals',
              description: 'Get extra 1GB data on select prepaid top-ups. Check available plans now.',
              icon: Icons.signal_cellular_alt),
        ];
      case 'cashback offers':
        return [
          BenefitItem(
              title: '20% UPI Cashback',
              description: 'Enjoy 20% cashback on every UPI payment up to ₹50. Limited time offer.',
              icon: Icons.payment),
          BenefitItem(
              title: 'Festive Rewards',
              description: 'Celebrate with extra cashback on Diwali, Holi, and other festivals!',
              icon: Icons.card_giftcard),
          BenefitItem(
              title: 'Fast Credit',
              description: 'Get your cashback credited instantly within 24 hours after transaction.',
              icon: Icons.access_time),
          BenefitItem(
              title: 'Partner Offers',
              description: 'Avail discounts on Amazon, Flipkart, Swiggy, and more using our app.',
              icon: Icons.local_offer),
        ];
      case 'discount coupons':
        return [
          BenefitItem(
              title: 'Flat 50% OFF',
              description: 'Use discount coupons to get 50% off on food, fashion, and travel bookings.',
              icon: Icons.discount),
          BenefitItem(
              title: 'Single Use Coupons',
              description: 'Apply once per user. Make sure to redeem before it expires!',
              icon: Icons.lock),
          BenefitItem(
              title: 'Deals of the Day',
              description: 'Daily flash coupons on select categories. Grab before they expire.',
              icon: Icons.flash_on),
          BenefitItem(
              title: 'Voucher Wallet',
              description: 'Save and manage all your unused vouchers in one place.',
              icon: Icons.wallet_giftcard),
        ];
      default:
        return [
          BenefitItem(
              title: 'No Benefits Available',
              description: 'Please check again later for exciting benefits.',
              icon: Icons.info_outline),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final benefits = getBenefits(categoryName);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                height: 180.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: sliderImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  Text(
                    'Top Benefits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: benefits.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final benefit = benefits[index];
                return GestureDetector(
                  onTap: () {

                  },

                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.deepPurple.shade50,
                          child: Icon(benefit.icon, color: Colors.deepPurple),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                benefit.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                benefit.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

}



