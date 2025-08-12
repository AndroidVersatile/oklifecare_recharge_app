
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:uonly_app/Screens/Login/login_screen.dart';
import 'package:uonly_app/Screens/Profile_screen/add_bank_detail_screen.dart';
import 'package:uonly_app/Screens/Profile_screen/cashback_report.dart';
import 'package:uonly_app/Screens/Profile_screen/changepassword_screen.dart';
import 'package:uonly_app/Screens/Profile_screen/kyc_screen.dart';
import 'package:uonly_app/Screens/Profile_screen/updatedprofile_screen.dart';
import '../Screens/Login/home_screen.dart';
import '../Screens/Login/login_member_panel.dart';
import '../Screens/Login/sign_screen.dart';
import '../Screens/Login/webview_screen_memberpanel.dart';
import '../Screens/Profile_screen/upgradeid_screen.dart';
import '../Screens/Profile_screen/wallet_statement.dart';
import '../Screens/Recharge_Screen/dth_recharge_screen.dart';
import '../Screens/Recharge_Screen/electricity.dart';
import '../Screens/Recharge_Screen/funds_recharge_screen.dart';
import '../Screens/Recharge_Screen/recharge_plan_screen.dart';
import '../Screens/Transction history/transaction_history.dart';
import '../Screens/customer_selection.dart';
import '../Screens/customnavbar_screen.dart';
import '../Screens/receivemoney_screen.dart';
import '../Screens/scantopay_screen.dart';
import '../Screens/sendmoney_screen.dart';
import '../Screens/splash_screen.dart';
import 'app_pages.dart';

GoRouter buildRouter(BuildContext context, String initialRoute) {
  final router = GoRouter(
    initialLocation: initialRoute,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppPages.splashPath,
        name: AppPages.splashPath,
        builder: (context, state) {
          return SplashScreen();
        },
      ),
      GoRoute(
        path: AppPages.customerselection,
        name: AppPages.customerselection,
        builder: (context, state) {
          return CustomerSelectionScreen();
        },
      ),

      GoRoute(
        path: AppPages.login,
        name: AppPages.login,
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: AppPages.loginmemeber,
        name: AppPages.loginmemeber,
        builder: (context, state) {
          return LoginMemberPanelScreen();
        },
      ),

      GoRoute(
        path: AppPages.webviewScreen,
        name: AppPages.webviewScreen,
        builder: (context, state) {
          final url = state.extra as String;
          return WebViewScreen(url: url); // <-- Pass the required url
        },
      ),

      GoRoute(
        path: AppPages.signscreen,
        name: AppPages.signscreen,
        builder: (context, state) {
          return SignupScreen();
        },
      ),
      GoRoute(
        path: AppPages.CustomBottomNavBar,
        name: AppPages.CustomBottomNavBar,
        builder: (context, state) {
          return const CustomBottomNavBar();
        },
      ),
      GoRoute(
        path: AppPages.sendmoneyscreen,
        name: AppPages.sendmoneyscreen,
        builder: (context, state) {
          return  SendMoneyScreen();
        },
      ),
      GoRoute(
        path: AppPages.scantopayscreen,
        name: AppPages.scantopayscreen,
        builder: (context, state) {
          return ScantoPayScreen();
        },
      ),
      GoRoute(
        path: AppPages.receivemoneyscreen,
        name: AppPages.receivemoneyscreen,
        builder: (context, state) {
          return ReceiveMoneyScreen();
        },
      ),
      GoRoute(
        path: AppPages.homescreen,
        name: AppPages.homescreen,
        builder: (context, state) {
          return HomeScreen();
        },
      ),
      GoRoute(
        path: AppPages.HistoryScreen,
        name: AppPages.HistoryScreen,
        builder: (context, state) {
          return HistoryScreen();
        },
      ),
      GoRoute(
        path: AppPages.walletStatement,
        name: AppPages.walletStatement,
        builder: (context, state) {
          return WalletStatementScreen();
        },
      ),
      GoRoute(
        path: AppPages.changepasswordscreen,
        name: AppPages.changepasswordscreen,
        builder: (context, state) {
          return ChangePasswordScreen();
        },
      ),
      GoRoute(
        path: AppPages.kycscreen,
        name: AppPages.kycscreen,
        builder: (context, state) {
          return KycUpdateScreen();
        },
      ),

      GoRoute(
        path: AppPages.rechargePlan,
        name: AppPages.rechargePlan,
        builder: (context, state) {
          return RechargePlanScreen();
        },
      ),
      GoRoute(
        path: AppPages.dthRecharge,
        name: AppPages.dthRecharge,
        builder: (context, state) {
          return DthRechargeScreen();
        },
      ),
      GoRoute(
        path: AppPages.electricityScreen,
        name: AppPages.electricityScreen,
        builder: (context, state) {
          return ElectricityScreen();
        },
      ),
      GoRoute(
        path: AppPages.updatedprofile,
        name: AppPages.updatedprofile,
        builder: (context, state) {
          return UpdatedHistoryScreen();
        },
      ),
      GoRoute(
        path: AppPages.upgradeid,
        name: AppPages.upgradeid,
        builder: (context, state) {
          return UpgradeidScreen();
        },
      ),
      GoRoute(
        path: AppPages.addbankscreen,
        name: AppPages.addbankscreen,
        builder: (context, state) {
          return AddBankDetailScreen();
        },
      ),
      GoRoute(
        path: AppPages.fund,
        name: AppPages.fund,
        builder: (context, state) {
          return FundsRechargeScreen();
        },
      ),
      GoRoute(
        path: AppPages.depositRequestFormScreen,
        name: AppPages.depositRequestFormScreen,
        builder: (context, state) {
          return DepositRequestFormScreen();
        },
      ),
      GoRoute(
        path: AppPages.withdrawRequestFormScreen,
        name: AppPages.withdrawRequestFormScreen,
        builder: (context, state) {
          return WithdrawRequestFormScreen();
        },
      ),
    ],
  );
  return router;
}
