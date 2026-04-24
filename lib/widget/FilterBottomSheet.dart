import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/enum/enum.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Set<ChargerFilterType> selectedFilters;

  const FilterBottomSheet({required this.selectedFilters});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<ChargerFilterType> tempSelected;

  @override
  void initState() {
    tempSelected = {...widget.selectedFilters};
    super.initState();
  }

  String getLabel(ChargerFilterType type) {
    switch (type) {
      case ChargerFilterType.ac:
        return "AC";
      case ChargerFilterType.dc:
        return "DC";
      case ChargerFilterType.car:
        return "Car";
      case ChargerFilterType.bike:
        return "Bike";
      case ChargerFilterType.both:
        return "Both (Car & Bike)";
      case ChargerFilterType.fast:
        return "Fast Charger";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Filters",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          SizedBox(height: 16),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ChargerFilterType.values.map((type) {
              final isSelected = tempSelected.contains(type);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected
                        ? tempSelected.remove(type)
                        : tempSelected.add(type);
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? CommonColors.blue: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    getLabel(type),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 20),

          Row(
            children: [
              /// CLEAR BUTTON
              Expanded(
                child:

                 ElevatedButton(
                    onPressed: () async {
                        Navigator.pop(context, <ChargerFilterType>{});
                     
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: Text(
                      "Clear",
                      style: const TextStyle(color: CommonColors.blue),
                    ),
                  ),
             
              ),

              SizedBox(width: 10),

              /// APPLY BUTTON
              Expanded(
                child:  ElevatedButton(
                    onPressed: () async {
                       
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: Text(
                      "Apply",
                      style: const TextStyle(color: CommonColors.white),
                    ),
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}