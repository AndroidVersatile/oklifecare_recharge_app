import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  bool _isAccountNumberVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProviderScreen>(context, listen: false);
      provider.fetchUserdata();
      provider.fetchWalletBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderScreen>(context);
    final userDetail = provider.userDetail;
    final walletBalance = provider.walletBalance;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors
                  .transparent, // Make background transparent to show gradient
              elevation: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon:
                      const Icon(Icons.settings_outlined, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
         body:
        (userDetail == null || walletBalance == null)
            ? Center(
                child: Image.asset(
                  Assets.noData,
                  height: 300,
                  width: 300,
                ),
              )
            :
        SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 25),
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius),
                              image: DecorationImage(
                                image: AssetImage(Assets.wallet),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text('Account Holder',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                ),
                                Text(
                                  '${userDetail.memFirstName} ${userDetail.lastName}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                Text('Account Number',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _isAccountNumberVisible
                                              ? userDetail.accountNo
                                              : '•••• •••• ••••',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isAccountNumberVisible =
                                                  !_isAccountNumberVisible;
                                            });
                                          },
                                          child: Icon(
                                            _isAccountNumberVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '₹${walletBalance.balance.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
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
                                  height: 140, // Fixed height to match the image
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title and View All
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Recharge & Pay Bills',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                              overflow: TextOverflow
                                                  .ellipsis, // Ellipsis to avoid overflow
                                            ),
                                          ),
                                          Text(
                                            'View All',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13,decoration:TextDecoration.underline,decorationColor: Colors.red),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      // Icons Row
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                ),
                                                // Icon(Icons.phone_android, color: Colors.purple, size: 50),
                                                SizedBox(height: 5),
                                                Text('Mobile',
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                context.pushNamed(AppPages.dthRecharge);
                                              });
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  "assets/dth.png",
                                                  height: 50,
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox(height: 5),
                                                Text('DTH', style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap:(){
                                              setState(() {
                                                context.pushNamed(AppPages.electricityScreen);
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/electricity.png",
                                                  height: 50,
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox(height: 5),
                                                Text('Electricity',
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Second Card (empty or same content)
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 140, // Same fixed height
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  // child: Center(
                                  //   child: Text("Second Card"),
                                  // ),
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
                                image: DecorationImage(
                                  image: AssetImage('assets/banner.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          AppTheme.verticalSpacing(),
                          Text(
                            "Benefits & Support",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          AppTheme.verticalSpacing(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFixedCard('assets/estore.png', "E-Store", () {
                                  context.pushNamed(AppPages.searchproductscreen);
                                }),
                                _buildFixedCard('assets/benefits.png', "Benefits", () {
                                  context.pushNamed(AppPages.benefitscategoreyscreen);
                                }),
                                _buildFixedCard('assets/blood.png', "Blood Seva", () {
                                  context.pushNamed(AppPages.bloodcategoreyscreen);
                                }),
                                _buildFixedCard('assets/emergency.png', "Emergency", () {
                                  context.pushNamed(AppPages.emergencycategoreyscreen);
                                }),
                              ],
                            ),
                          ),

                          AppTheme.verticalSpacing(mul: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildFixedHorizontalCard(
                                'assets/order.png',
                                "My Order",
                                onTap: () {
                                  context.pushNamed(AppPages.myorderscreen);
                                },
                              ),
                              _buildFixedHorizontalCard(
                                "assets/reward.png",
                                "Reward",
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => RewardScreen()),
                                  // );
                                },
                              ),
                              _buildFixedHorizontalCard(
                                "assets/earn.png",
                                "Refer & Earn",
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => ReferAndEarnScreen()),
                                  // );
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
                                    clipBehavior: Clip
                                        .antiAlias, // Ensures image doesn't overflow
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
                                        'assets/offeradd2.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppTheme.verticalSpacing(),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height:
                                      150, // Fixed height to match the image
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title and View All
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Services',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                              overflow: TextOverflow
                                                  .ellipsis, // Ellipsis to avoid overflow
                                            ),
                                          ),
                                          Text(
                                            'View All',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13,decoration:TextDecoration.underline,decorationColor: Colors.red),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      // Icons Row
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // context.pushNamed(AppPages.rechargePlan);
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/ambulance.png",
                                                  height: 50,
                                                  fit: BoxFit.fill,
                                                ),
                                                // Icon(Icons.warning_amber, color: Colors.purple, size:45),
                                                SizedBox(height: 5),
                                                Text('Ambulance',
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // context.pushNamed(AppPages.dthRecharge);
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/health.png",
                                                  height: 50,
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox(height: 5),
                                                Text('Health',
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Image.asset(
                                                "assets/education.png",
                                                height: 50,
                                                fit: BoxFit.fill,
                                              ),
                                              SizedBox(height: 5),
                                              Text('Education',
                                                  style: TextStyle(
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Second Card (empty or same content)
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 150, // Same fixed height
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title and View All
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Apps by Uonely',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    fontSize: 13),
                                                // overflow: TextOverflow.ellipsis, // Ellipsis to avoid overflow
                                              ),
                                            ),
                                            Text(
                                              'View All',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 13,decoration:TextDecoration.underline,decorationColor: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      // Icons Row
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // context.pushNamed(AppPages.rechargePlan);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      "assets/umart.png",
                                                      height: 45,
                                                      fit: BoxFit.fill,
                                                    ),// Icon(Icons.warning_amber, color: Colors.purple, size:45),
                                                    SizedBox(height: 5),
                                                    Text('U Mart',
                                                        style: TextStyle(
                                                            fontSize: 11)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  // context.pushNamed(AppPages.dthRecharge);
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/admission.png",
                                                    height: 45,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text('U Admission',
                                                      style: TextStyle(
                                                          fontSize: 11)),
                                                ],
                                              ),
                                            ),
                                          ])
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          AppTheme.verticalSpacing(mul: 1),
                          Container(
                            height: 140, // Fixed height to match the image
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title and View All
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Our Links',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13),
                                        overflow: TextOverflow
                                            .ellipsis, // Ellipsis to avoid overflow
                                      ),
                                    ),
                                    Text(
                                      'View All',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13,decoration:TextDecoration.underline,decorationColor: Colors.red),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                // Icons Row
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // context.pushNamed(AppPages.rechargePlan);
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/govt.png",
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(height: 5),
                                          Text('Govt.',
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // context.pushNamed(AppPages.dthRecharge);
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/finance.png",
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(height: 5),
                                          Text('Finance',
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          "assets/business.png",
                                          height: 50,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(height: 5),
                                        Text('Business',
                                            style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          "assets/career.png",
                                          height: 50,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(height: 5),
                                        Text('Career',
                                            style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]))));
  }
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
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 12),
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
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 30,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
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
