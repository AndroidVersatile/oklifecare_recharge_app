import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uonly_app/providers/loginProvider.dart';
import 'package:uonly_app/routing/app_pages.dart';
import '../../constants/assets.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProviderScreen>(context, listen: false);
      // Ensure fetchUserData and fetchWalletBalance are called once
      provider.fetchUserData();
      provider.fetchWalletBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderScreen>(context);
    // Use the userLoginDetail model to get memberName
    final memberName = provider.memberName;
    final walletBalance = provider.walletBalance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 5),
                // Display MemberName from the provider
                Text(
                  memberName ?? "Profile",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  context.pushNamed(AppPages.notificationscreen);
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  final loginProvider = context.read<ProviderScreen>();
                  bool isLoggedOut = await loginProvider.cache.logout();

                  if (isLoggedOut) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Logout successful',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.goNamed(AppPages.customerselection);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Logout failed, try again',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  image: DecorationImage(
                    image: AssetImage(Assets.wallet),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Member Name',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Text(
                      memberName ?? "Loading...",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Id No',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text(
                              "767 890 567", // This is a hardcoded ID, you might want to fetch this from your provider
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            Text(
                              '₹${walletBalance?.balance.toStringAsFixed(2) ?? '0.00'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              AppTheme.verticalSpacing(),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 140,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  'Recharge & Pay Bills',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(AppPages.rechargePlan);
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/mobile.png",
                                        height: 50,
                                        fit: BoxFit.fill,
                                        color: const Color(0xFF8E2DE2),
                                        colorBlendMode: BlendMode.srcIn,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text('Mobile', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(AppPages.dthRecharge);
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/dth.png",
                                        height: 50,
                                        fit: BoxFit.fill,
                                        color: const Color(0xFF8E2DE2),
                                        colorBlendMode: BlendMode.srcIn,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text('DTH', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(AppPages.electricityScreen);
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/electricity.png",
                                        height: 50,
                                        fit: BoxFit.fill,
                                        color: const Color(0xFF8E2DE2),
                                        colorBlendMode: BlendMode.srcIn,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text('Electricity', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(AppPages.bbpsScreen);
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/bbps.png",
                                        height: 50,
                                        fit: BoxFit.fill,
                                        color: const Color(0xFF8E2DE2),
                                        colorBlendMode: BlendMode.srcIn,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text('BBPS', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(AppPages.insuranseScreen);
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/insurance.png",
                                        height: 50,
                                        fit: BoxFit.fill,
                                        color: const Color(0xFF8E2DE2),
                                        colorBlendMode: BlendMode.srcIn,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text('Insurance', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(AppPages.moneytransferScreen);
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/moneytransfer.png",
                                        height: 50,
                                        fit: BoxFit.fill,
                                        color: const Color(0xFF8E2DE2),
                                        colorBlendMode: BlendMode.srcIn,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text('Money Transfer', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              AppTheme.verticalSpacing(),
              Card(
                elevation: 2,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/banner.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              AppTheme.verticalSpacing(mul: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFixedHorizontalCard(
                    'assets/order.png',
                    "Recharge History",
                    onTap: () {
                      context.pushNamed(AppPages.HistoryScreen);
                    },
                  ),
                  _buildFixedHorizontalCard(
                    "assets/reward.png",
                    "Reward",
                    onTap: () {
                      context.pushNamed(AppPages.rewardScreen);
                    },
                  ),
                  _buildFixedHorizontalCard(
                    "assets/earn.png",
                    "Refer & Earn",
                    onTap: () {
                      context.pushNamed(AppPages.referearnScreen);
                    },
                  ),
                ],
              ),
              AppTheme.verticalSpacing(mul: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox(
                          height: 100,
                          child: Image.asset(
                            'assets/offeradd.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox(
                          height: 100,
                          child: Image.asset(
                            'assets/offeradd.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppTheme.verticalSpacing(),
            ],
          ),
        ),
      ),
    );
  }

  // A helper function for building fixed-size cards (not used in the provided body)
  Widget _buildFixedCard(String imagePath, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            height: 90,
            width: 90,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: 45,
                  width: 45,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // A helper function for building horizontal cards
  Widget _buildFixedHorizontalCard(
      String imagePath,
      String title, {
        required VoidCallback onTap,
      }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 30,
                  fit: BoxFit.fill,
                  color: const Color(0xFF018CCF),
                  colorBlendMode: BlendMode.srcIn,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}