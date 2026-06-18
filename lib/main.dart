import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hornvin/controllers/garage_controller.dart';
import 'package:hornvin/controllers/invoice_controller.dart';
import 'package:hornvin/controllers/language_controller.dart';
import 'package:provider/provider.dart';
import 'package:hornvin/auth/intro_screen.dart';
import 'package:hornvin/bottom_navi/chat_screen.dart';
import 'package:hornvin/controllers/job_controller.dart';
import 'package:hornvin/controllers/order_management_controller.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/screens/garage_dashboard_page.dart';
import 'package:hornvin/screens/garage_cart_page.dart';
import 'package:hornvin/screens/garage_orders_page.dart';
import 'package:hornvin/screens/garage_products_page.dart';
import 'package:hornvin/screens/home_screen.dart';
import 'package:hornvin/screens/help_support_screen.dart';
import 'package:hornvin/screens/job_screen/job_list_screen.dart';
import 'package:hornvin/screens/language_screen.dart';
import 'package:hornvin/screens/new_screen_bottom/invoice_generation_screen.dart';
import 'package:hornvin/screens/new_screen_bottom/invoice_view_screen.dart';
import 'package:hornvin/screens/signup_screen.dart';
import 'package:hornvin/screens/select_location_screen.dart';
import 'package:hornvin/services/storage_service.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  final languageController = LanguageController();
  await languageController.loadSavedLanguage();
  final token = await StorageService.getToken();
  debugPrint('App Started');
  debugPrint('Token present: ${token != null ? "Yes" : "No"}');
  //await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(languageController: languageController));
}

class MyApp extends StatelessWidget {
  final LanguageController languageController;

  const MyApp({super.key, required this.languageController});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //   UpdateCheckService().checkForUpdate(context);
    // });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobController()),
        ChangeNotifierProvider(create: (_) => GarageController()),
        ChangeNotifierProvider(create: (_) => OrderManagementController()),
        ChangeNotifierProvider(create: (_) => InvoiceController()),
        ChangeNotifierProvider.value(value: languageController),
      ],
      child: Consumer<LanguageController>(
        builder: (context, languageController, _) {
          return MaterialApp(
            title: 'Hornvin',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: languageController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/language': (context) => const LanguageScreen(),
              '/intro': (context) => const IntroScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/home': (context) => const HomeScreen(),
              'garage_dashboard': (context) => const GarageDashboardPage(),
              'garage_orders': (context) => const GarageOrdersPage(),
              'garage_products': (context) => const GarageProductsPage(),
              'garage_cart': (context) => const GarageCartPage(),
              '/create_invoice': (context) => const InvoiceGenerationScreen(),
              '/view_invoices': (context) => const InvoiceViewScreen(),
              '/HornvinChatScreen': (context) => const ChatScreen(),
              '/job-list': (context) => const JobListScreen(),
              '/help-support': (context) => const HelpSupportScreen(),
              '/garage-settings': (context) => const GarageSettingsScreen(),
              '/reports-analytics': (context) => const ReportsAnalyticsScreen(),
              '/select-location': (context) => const SelectLocationScreen(),
            },
          );
        },
      ),
    );
  }
}
