import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamboard/screens/LandingScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/RecordingScreen.dart';
import 'components/Globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bvtkzsxrphxzfaszilab.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2dGt6c3hycGh4emZhc3ppbGFiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg2NDkwMTYsImV4cCI6MjA0NDIyNTAxNn0.gnFPJ9aiJDYD1Fz11-KMmGFPP9RUI_ZPxs29l1yqjFk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Globals().initialize(context);
    return ScreenUtilInit(builder: (context, child) {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: RecordingScreen(),//home: Landingscreen(),
      );
    },
      designSize: const Size(430, 932),
      minTextAdapt: true, // Optional, adapts text size
      splitScreenMode: true, // Optional, handles multi-screen layouts
    );
  }
}
