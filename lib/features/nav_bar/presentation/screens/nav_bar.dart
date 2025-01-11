// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../core/common/styles/get_text_style.dart';
// import '../../../../core/utils/constants/app_colors.dart';
// import '../../controllers/nav_bar_controller.dart';
//
// class CreatorNavBar extends StatelessWidget {
//   const CreatorNavBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetX<CreatorNavBarController>(
//         builder: (creatorNavController) =>
//         creatorNavController.screens[creatorNavController.currentIndex],
//       ),
//       bottomNavigationBar: GetX<CreatorNavBarController>(
//         builder: (navController) {
//           return BottomNavigationBar(
//             backgroundColor: AppColors.white,
//             currentIndex: navController.currentIndex,
//             selectedItemColor: AppColors.primary,
//             unselectedItemColor: const Color(0xff263238),
//             showUnselectedLabels: true,
//             onTap: navController.changeIndex,
//             items: List.generate(
//               navController.activeIcons.length,
//                   (index) {
//                 return BottomNavigationBarItem(
//                   backgroundColor: Colors.white,
//                   icon: navController.currentIndex == index
//                       ? navController.activeIcons[index]
//                       : navController.inActiveIcons[index],
//                   label: navController.labels[index],
//                   tooltip: navController.labels[index],
//                 );
//               },
//             ),
//             selectedLabelStyle: getTextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 11,
//               color: AppColors.primary,
//             ),
//             unselectedLabelStyle: getTextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 11,
//               color: AppColors.textPrimary,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
