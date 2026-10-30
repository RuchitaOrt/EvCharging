import 'package:HyCharge/Screens/auth/login_bottom_sheet.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:HyCharge/Utils/commoncolors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CommonAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          color: CommonColors.neutral50,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Title in center
            // Text(
            //   title,
            //   style: GoogleFonts.mulish(
            //     fontWeight: FontWeight.w600,
            //     color: CommonColors.blackshade,
            //     fontSize: 20,
            //   ),
            // ),
Text(title,textAlign: TextAlign.center, style: LoginText.titleHead),
            // Back button on the left
            Positioned(
              left: 0,
              child: 
              GestureDetector(
                 onTap: onBack ?? () {
                  Navigator.pop(context);
                },
                child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8),
                        child: SvgPicture.asset(CommonImagePath.back),
                      ),
              ),
              
              // IconButton(
              //   icon: const Icon(Icons.arrow_back_ios,
              //       color: CommonColors.blacklight),
              //   onPressed: onBack ?? () {
              //     Navigator.pop(context);
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// import 'package:HyCharge/Utils/commoncolors.dart';
// import 'package:HyCharge/Utils/sizeConfig.dart';
// import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';

// class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final VoidCallback? onBack;
 

//   const CommonAppBar({
//     super.key,
//     required this.title,
//     this.onBack,
   
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         height: kToolbarHeight,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: const BoxDecoration(
//           color: CommonColors.neutral50,
         
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Back button
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: CommonColors.blacklight),
//               onPressed: onBack ?? () {
//                 Navigator.pop(context);
//               }
              
//             ),

//             // Title and optional stepTitle
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     overflow: TextOverflow.ellipsis,
//                     style:  
//                     GoogleFonts.mulish(
//                 fontWeight: FontWeight.w600, // ExtraBold
//                 color: CommonColors.blackshade,
//                 fontSize: 20,
//               )
              
                    
//                   ),
                
//                 ],
//               ),
//             ),

           
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
