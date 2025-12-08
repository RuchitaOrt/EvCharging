
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmationSheet extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onLogout;
  final String title;
  final String imagePath; 
  final String firstbutton;
  final String secondButton;
  final String subHeading;
  final bool isSingleButton;
  final String singleButton;
   final VoidCallback onBackToHome;
   final String refrenceNumber;
  const ConfirmationSheet({
    super.key,
    required this.onCancel,
    required this.onLogout,
    this.title = "Are you sure you want to log out?",
    required this.imagePath, required this.firstbutton, required this.secondButton, required this.subHeading, required this.isSingleButton, required this.onBackToHome, required this.singleButton,  this.refrenceNumber="",
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child:
               GestureDetector(
                 onTap: () => Navigator.of(context).pop(),
                 child: SvgPicture.asset(
                             CommonImagePath.cancel,
                           
                           ),
               ),
               
            ),
            Image.asset(
              imagePath,
height: 60,
            ),
            // const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style:  TextStyle(
                color: CommonColors.blackshade,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
           refrenceNumber!=""?  Container(
            margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: CommonColors.hintGrey,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CommonColors.greyText)
              ),
               child:  Padding(
                 padding: const EdgeInsets.all(8.0),
              
               ),
             ):Container(),
          subHeading!=""?  Column(
              children: [
                Text(
                  subHeading,
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    color: CommonColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                 const SizedBox(height: 24),
              ],
            ):Container(),
      
         isSingleButton? Container(
          width: SizeConfig.blockSizeHorizontal*90,
      
           child: ElevatedButton(
             onPressed: onBackToHome,
             style: ElevatedButton.styleFrom(
               backgroundColor: CommonColors.blue,
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(8)),
             ),
             child:  Text(singleButton,
                 style: TextStyle(color: Colors.white)),
           ),
         ):   Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: CommonColors.blue,),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child:  Text(firstbutton,
                        style: TextStyle(color: CommonColors.blue,)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child:  Text(secondButton,
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
