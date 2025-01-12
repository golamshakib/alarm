import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/nav_bar_controller.dart';

class CreatorNavBar extends StatelessWidget {
  const CreatorNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final CreatorNavBarController navController = Get.put(CreatorNavBarController());
    return Scaffold(
      
      body: SafeArea(
        child: Obx(() {
          return navController.screens[navController.selectedIndex.value];
        }),
      ),
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, -3),
                blurRadius: 40,
                spreadRadius: 15,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: navController.selectedIndex.value,
            onTap: (index) {
              navController.changeIndex(index);
            },
            items: List.generate(navController.iconPaths.length, (index) {
              final isActive = navController.selectedIndex.value == index;
              return BottomNavigationBarItem(
                icon: Material(
                  type: MaterialType.transparency,
                  child: Image.asset(
                    isActive
                        ? navController.iconPaths[index]['active']!
                        : navController.iconPaths[index]['inactive']!,
                    height: index == 1 ? 50 : 30,
                    width: index == 1 ? 50 : 30,
                  ),
                ),
                label: '',
              );
            }),
            selectedItemColor: AppColors.yellow,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        );
      }),
    );
  }
}





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
