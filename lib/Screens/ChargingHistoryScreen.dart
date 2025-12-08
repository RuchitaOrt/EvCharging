
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';

class ChargingHistoryScreen extends StatelessWidget {
  const ChargingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:
      CommonAppBar(title: "Charging History",),
      
      backgroundColor: CommonColors.neutral50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryRow(),

            const SizedBox(height: 20),
            // _filterTabs(),
FilterTabsWidget(),
            const SizedBox(height: 20),
              Text('August 2025',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
           const SizedBox(height: 20),
            _historyCard(),
            const SizedBox(height: 12),
            _historyCard(),
          ],
        ),
      ),
    );
  }


Widget _summaryRow() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _summaryBox("12", "Sessions"),
          _summaryBox("214 kW", "Total Energy"),
         
        ],
      ),
            Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          _summaryBox("₹ 5,428", "Total Spent"),
          _summaryBox("15h 42m", "Total Time"),
        ],
      ),
    ],
  );
}

Widget _summaryBox(String value, String label) {
  return Padding(
    padding: const EdgeInsets.all(4),
    child: Container(
      width: SizeConfig.blockSizeHorizontal*40,
        decoration: BoxDecoration(
                color: CommonColors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(value, style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: CommonColors.blue)),
            const SizedBox(height: 4),
            Text(label, style:  TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    ),
  );
}

Widget _filterTabs() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _tabButton("This month", Icons.calendar_month, selected: true),
        const SizedBox(width: 10),
        _tabButton("Last 7 Days", Icons.bolt),
        const SizedBox(width: 10),
        _tabButton("Filter", Icons.filter),
      ],
    ),
  );
}


Widget _tabButton(String text,IconData icon, {bool selected = false}) {
  return Container(
    padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: selected ? CommonColors.blue.withOpacity(0.1) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: selected ? CommonColors.blue.withOpacity(0.6) : Colors.grey.shade300),
    ),
    child: Row(
      children: [
        Icon(icon,color: selected ? CommonColors.blue : Colors.black,size: 20,),
        Text(
          text,
          style: TextStyle(color: selected ? CommonColors.blue : Colors.black,fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}


Widget _historyCard() {
  return Container(
    
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: CommonColors.white,
      border: Border.all(color: CommonColors.neutral200),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: SizeConfig.blockSizeHorizontal*90,
            decoration: BoxDecoration(
                color: CommonColors.neutral50,
                borderRadius: BorderRadius.circular(8),
              ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Hitech EV Station", style: TextStyle(fontWeight: FontWeight.w600)),
             const Text("Today 10.24 am", style: TextStyle(fontWeight: FontWeight.w400,color: CommonColors.neutral500,fontSize: 12)),
              ],
            ),
          )),
        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Energy",style: TextStyle(fontWeight: FontWeight.w400,color: CommonColors.neutral500,fontSize: 12)),
                   Text("32.4 kW",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                ],
              ),
            ),
             Expanded(
              child: Column(
                children: [
                  Text("Duration",style: TextStyle(fontWeight: FontWeight.w400,color: CommonColors.neutral500,fontSize: 12)),
                   Text("2h 24m",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                ],
              ),
            ),
             Expanded(
              child: Column(
                children: [
                  Text("Plug Type",style: TextStyle(fontWeight: FontWeight.w400,color: CommonColors.neutral500,fontSize: 12)),
                   Text("Type 2",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                ],
              ),
            ),
        
            
          ],
        ),
        const SizedBox(height: 16),
 Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Speed",style: TextStyle(fontWeight: FontWeight.w400,color: CommonColors.neutral500,fontSize: 12)),
                   Text("24 kW",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                ],
              ),
            ),
             Expanded(
              child: Column(
                children: [
                  Text("Fee",style: TextStyle(fontWeight: FontWeight.w400,color: CommonColors.neutral500,fontSize: 12)),
                   Text("₹648",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                ],
              ),
            ),
             Expanded(
              child: Column(
                children: [
                  Text("Location",style: TextStyle(fontWeight: FontWeight.w400,color: CommonColors.neutral500,fontSize: 12)),
                   Text("Mulunf",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                ],
              ),
            ),
        
            
          ],
        ),
        const SizedBox(height: 16),
       Container(
        width: SizeConfig.blockSizeHorizontal*90,
         child: ElevatedButton(
           onPressed: () {},
           style: ElevatedButton.styleFrom(
             backgroundColor: CommonColors.white,
             foregroundColor: CommonColors.blue,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
               side: BorderSide(
                 color: CommonColors.blue.withOpacity(0.4),
                 width: 0.8,
               ),
             ),
           ),
           child: const Text(
             "Download Receipt",
             style: TextStyle(
                 fontSize: 12,
                 color: CommonColors.blue,
                 fontWeight: FontWeight.w600),
           ),
         ),
       ),
            
      ],
    ),
  );
}

}
class FilterTabsWidget extends StatefulWidget {
  const FilterTabsWidget({super.key});

  @override
  State<FilterTabsWidget> createState() => _FilterTabsWidgetState();
}

class _FilterTabsWidgetState extends State<FilterTabsWidget> {
  // Track selected tab index
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _tabButton("This month", Icons.calendar_month, 0),
          const SizedBox(width: 10),
          _tabButton("Last 7 Days", Icons.bolt, 1),
          const SizedBox(width: 10),
          _tabButton("Filter", Icons.filter, 2),
        ],
      ),
    );
  }

  Widget _tabButton(String title, IconData icon, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? CommonColors.blue.withOpacity(0.1) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
         border: Border.all(color: isSelected ? CommonColors.blue.withOpacity(0.6) : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon,  color: isSelected ? CommonColors.blue : Colors.black,),
            const SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? CommonColors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
