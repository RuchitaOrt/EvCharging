import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int _expandedIndex = -1; // tracks which FAQ is open

  final List<Map<String, String>> faqList = [
    {
      "q": "I have forgotten my password, how should I reset it?",
      "a": "Select ‘forgot password’ and enter your registered mobile number. An OTP will be sent to your mobile number."
    },
    {
      "q": "How do I contact support?",
      "a": "You can reach us anytime via our support email or hotline number."
    },
    {
      "q": "How do I pay for a charging session?",
      "a": "Payment can be done through UPI, cards, or wallet options available in the app."
    },
    {
      "q": "Who do I contact to set up a charging station for my car?",
      "a": "Please contact our support team for installation details and procedures."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: CommonColors.neutral50,
      
     appBar:
      CommonAppBar(title: "FAQ",),
      
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: faqList.length,
          itemBuilder: (context, index) {
            bool isOpen = _expandedIndex == index;
        
            return Container(
              margin: EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: CommonColors.lightblue),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      faqList[index]["q"]!,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,color: CommonColors.blue,),
                    ),
                    trailing: Icon(
                      isOpen ? Icons.remove : Icons.add,
                      color: CommonColors.blue,
                    ),
                    onTap: () {
                      setState(() {
                        _expandedIndex = isOpen ? -1 : index; // open one, close others
                      });
                    },
                  ),
        
                  // Expanded answer section
                  if (isOpen)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          Divider(color: CommonColors.lightblue),
                          Text(
                            faqList[index]["a"]!,
                            style: TextStyle(color: CommonColors.greyText, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
