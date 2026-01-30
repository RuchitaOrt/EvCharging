import 'package:ev_charging_app/Provider/ChargingEstimateProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChargingEstimateScreen extends StatelessWidget {
  const ChargingEstimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChargingEstimateProvider(),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Select Charging"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Amount"),
                Tab(text: "Units"),
                Tab(text: "Time"),
                Tab(text: "%"),
              ],
            ),
          ),
          body: Column(
            children: const [
            
              Expanded(child: _TabViews()),
                _EstimateCard(),
            ],
          ),
        ),
      ),
    );
  }
}
class _EstimateCard extends StatelessWidget {
  const _EstimateCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChargingEstimateProvider>(
      builder: (_, p, __) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8),
            ],
          ),
          child: Column(
            children: [
              _row("Amount", "₹${p.amount.toStringAsFixed(0)}"),
              _row("Units", "${p.units.toStringAsFixed(1)} kWh"),
              _row("Time", "${p.time.toStringAsFixed(1)} hrs"),
              _row("Battery", "${p.percentage.toStringAsFixed(0)}%"),
            ],
          ),
        );
      },
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              value,
              key: ValueKey(value),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _TabViews extends StatelessWidget {
  const _TabViews();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        _AmountTab()
,        _sliderTab(
          label: "Select Units (kWh)",
          min: 1,
          max: 40,
          onChange: (v) =>
              context.read<ChargingEstimateProvider>().updateByUnits(v),
          valueSelector: (p) => p.units,
        ),
        _sliderTab(
          label: "Charging Time (hrs)",
          min: 0.5,
          max: 8,
          onChange: (v) =>
              context.read<ChargingEstimateProvider>().updateByTime(v),
          valueSelector: (p) => p.time,
        ),
        _sliderTab(
          label: "Battery %",
          min: 1,
          max: 100,
          onChange: (v) =>
              context.read<ChargingEstimateProvider>().updateByPercentage(v),
          valueSelector: (p) => p.percentage,
        ),
      ],
    );
  }

  Widget _sliderTab({
    required String label,
    required double min,
    required double max,
    required Function(double) onChange,
    required double Function(ChargingEstimateProvider) valueSelector,
  }) {
    return Consumer<ChargingEstimateProvider>(
      builder: (_, p, __) {
        final value = valueSelector(p).clamp(min, max);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              Slider(
                min: min,
                max: max,
                value: value,
                onChanged: onChange,
              ),
              Center(
                child: Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// class ChargingEstimateScreen extends StatelessWidget {
//   const ChargingEstimateScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ChargingEstimateProvider(),
//       child: DefaultTabController(
//         length: 4,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text("Select Charging Type"),
//             bottom: const TabBar(
//               tabs: [
//                 Tab(text: "Amount"),
//                 Tab(text: "Units"),
//                 Tab(text: "Time"),
//                 Tab(text: "%"),
//               ],
//             ),
//           ),
//           body: const _Body(),
//         ),
//       ),
//     );
//   }
// }
// class _Body extends StatelessWidget {
//   const _Body();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: const [
//         Expanded(child: _TabContent()),
//         _BottomButton(),
//       ],
//     );
//   }
// }
// class _TabContent extends StatelessWidget {
//   const _TabContent();

//   @override
//   Widget build(BuildContext context) {
//     return TabBarView(
//       children: [
//         _AmountTab(),
//         Center(child: Text("Units UI")),
//         Center(child: Text("Time UI")),
//         Center(child: Text("% UI")),
//       ],
//     );
//   }
// }
class _AmountTab extends StatefulWidget {
  @override
  State<_AmountTab> createState() => _AmountTabState();
}

class _AmountTabState extends State<_AmountTab> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChargingEstimateProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InputField(
            label: "Amount",
            hint: "Enter amount",
            unit: "₹",
            controller: controller,
            onChanged: (v) {
              final value = double.tryParse(v) ?? 0;
              provider.calculateFromAmount(value);
            },
          ),

          const SizedBox(height: 24),

          /// 🔥 Estimated Values (ROWS)
          //_EstimatedValuesCard(provider),
        ],
      ),
    );
  }
}
class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final String unit;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _InputField({
    required this.label,
    required this.hint,
    required this.unit,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(unit,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

Widget _EstimatedValuesCard(ChargingEstimateProvider p) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Estimated Values",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Divider(),
        _row("Charging Time", "${p.time.toStringAsFixed(1)} hrs"),
        _row("Energy Delivered", "${p.units.toStringAsFixed(1)} kWh"),
        _row("Battery %", "${p.percentage.toStringAsFixed(0)} %"),
        _row("Amount", "₹${p.amount.toStringAsFixed(0)}"),
      ],
    ),
  );
}

Widget _row(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
// class _BottomButton extends StatelessWidget {
//   const _BottomButton();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SizedBox(
//         width: double.infinity,
//         height: 48,
//         child: ElevatedButton(
//           onPressed: () {},
//           child: const Text("Proceed to Charging"),
//         ),
//       ),
//     );
//   }
// }
