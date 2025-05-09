import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/loading_provider.dart';
import 'package:ecommerce_app/provider/user_provider.dart';
import 'package:ecommerce_app/views/auth/check_authentication.dart';
import 'package:ecommerce_app/views/auth/login.dart';
import 'package:ecommerce_app/views/auth/signin.dart';
import 'package:ecommerce_app/views/cart/cart_screen.dart';
import 'package:ecommerce_app/views/cart/check_out_screen.dart';
import 'package:ecommerce_app/views/discount/discount_screen.dart';
import 'package:ecommerce_app/views/home/home_nav.dart';
import 'package:ecommerce_app/views/home/home_screen.dart';
import 'package:ecommerce_app/views/orders/orders_screen.dart';
import 'package:ecommerce_app/views/orders/view_order_screen.dart';
import 'package:ecommerce_app/views/products/specific_products.dart';

import 'package:ecommerce_app/views/profile/update_profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  // Stripe.publishableKey = "Sachin_secret_key";

  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ecommerce App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.amber,
          ),
          scaffoldBackgroundColor: Colors.white,
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        routes: {
          "/": (context) => const CheckUserLogInOrNot(),
          "/login": (context) => const LoginPage(),
          "/signup": (context) => const SignIn(),
          "/check_user_login_or_not": (context) => const CheckUserLogInOrNot(),
          "/home_nav": (context) => const HomeNav(),
          "/home": (context) => const HomeScreen(),
          "/update_profile": (context) => const UpdateProfileScreen(),
          "/discount": (context) => const DiscountScreen(),
          "/specific_products": (context) => const SpecificProducts(),
          "cart": (context) => const CartScreen(),
          '/check_out': (context) => const CheckOutScreen(),
          "/orders": (context) => const OrdersScreen(),
          "/view_order": (context) => const ViewOrderScreen()
        },
      ),
    );
  }
}
