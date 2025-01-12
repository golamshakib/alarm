import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomText(text: 'This is Settings Screen'),
      ),
    );
  }
}
