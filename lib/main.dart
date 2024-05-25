import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/data_viewmodel.dart';
import 'views/auth_screen.dart';
import 'views/data_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => DataViewModel()),
      ],
      child: MaterialApp(
        home: Consumer<AuthViewModel>(
          builder: (context, auth, _) {
            return auth.user == null ? AuthScreen() : DataScreen();
          },
        ),
      ),
    );
  }
}
