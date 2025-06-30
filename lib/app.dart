import 'package:flutter/material.dart';
import 'package:flutter_wc_app/providers/ToiletProvider.dart';
import 'package:flutter_wc_app/providers/UserProvider.dart';
import 'package:flutter_wc_app/view/HomeScreen.dart';
import 'package:flutter_wc_app/view/OnboardingScreen.dart';
import 'package:provider/provider.dart';


class TuvaletTakipApp extends StatelessWidget {
  const TuvaletTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUserInfo()),
        ChangeNotifierProvider(create: (_) => ToiletProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tuvalet Takip',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
              useMaterial3: true,
            ),
            home: userProvider.kullaniciAdi == null
                ? const OnboardingScreen()
                : const HomeScreen(),
          );
        },
      ),
    );
  }
}
