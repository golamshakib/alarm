import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_sizes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomText(text: 'Log in', fontSize: getWidth(20),),
      ),
    );
  }
}
