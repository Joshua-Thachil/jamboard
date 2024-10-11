import 'package:flutter/material.dart';
import 'package:jamboard/Style/Palette.dart';
import 'package:jamboard/components/Buttons.dart';
import 'package:jamboard/components/InputFields.dart';
import 'package:jamboard/screens/ProjectsScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Landingscreen extends StatefulWidget {
  Landingscreen({super.key});

  @override
  State<Landingscreen> createState() => _LandingscreenState();
}

class _LandingscreenState extends State<Landingscreen> {
  final TextEditingController nameController = TextEditingController();

  void onSubmitFunction() async {
    await Supabase.instance.client.from('Recorders').insert({'name' : nameController.text});
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35, top: 200, bottom: 25),
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  "Welcome!",
                  style: TextStyle(
                    color: Palette.primary_text,
                    fontSize: 35,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 150),
                InputField(
                    InputController: nameController,
                    hint: "Enter your name",
                    height: 1),
                SizedBox(height: 240,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NextButton(text: 'Next', icon: Icons.navigate_next, onPressed: onSubmitFunction)
              ],
            )
          ],
        ),
      ),
    );
  }
}
