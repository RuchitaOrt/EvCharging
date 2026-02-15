import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: CommonColors.neutral50,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Title in center
            Text(
              title,
              style: GoogleFonts.mulish(
                fontWeight: FontWeight.w600,
                color: CommonColors.blackshade,
                fontSize: 20,
              ),
            ),

            // Back button on the left
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: CommonColors.blacklight),
                onPressed: onBack ?? () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

