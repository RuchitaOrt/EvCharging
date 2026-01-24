import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';

class StationCardWidget extends StatelessWidget {
  const StationCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => const _StationCard(),
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  const _StationCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 338,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- HEADER ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  CommonImagePath.frame,
                  height: SizeConfig.blockSizeVertical * 8,
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),

                /// --- INFO ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Hitech EV",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(Icons.more_vert, color: CommonColors.blue),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children:  [
                          _InfoTag(icon: CommonImagePath.redpin, text: "4.8 KM"),
                          SizedBox(width: 2),
                          _InfoTag(icon: CommonImagePath.star, text: "4.5"),
                          SizedBox(width: 2),
                          _InfoTag(
                            icon: CommonImagePath.clock,
                            text: "9.00AM - 12.00PM",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// --- FOOTER ---
            Row(
              children: [
                const _TypeInfo(type: "Type 1", price: "₹12.99 / kWh"),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                const _TypeInfo(type: "Type 2", price: "₹12.99 / kWh"),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
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
                      "Get Directions",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class _InfoTag extends StatelessWidget {
  final String icon;
  final String text;

  const _InfoTag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: CommonColors.neutral200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Image.asset(icon, height: 14),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _TypeInfo extends StatelessWidget {
  final String type;
  final String price;

  const _TypeInfo({
    required this.type,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: TextStyle(
            fontSize: 12,
            color: CommonColors.neutral500,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: CommonColors.primary,
          ),
        ),
      ],
    );
  }
}
