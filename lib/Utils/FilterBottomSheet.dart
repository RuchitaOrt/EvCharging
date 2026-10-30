
import 'package:flutter/material.dart';
import 'package:HyCharge/enum/enum.dart';

const Color _navy = Color(0xFF142D78);
const Color _muted = Color(0xFF667085);
const Color _border = Color(0xFFE0E6F0);
const Color _pale = Color(0xFFF0F3F9);

class StationFilters {
  final HubTab network;
  final bool availableNow;
  final Set<String> chargerTypes;
  final String distance;

  const StationFilters({
    this.network = HubTab.All,
    this.availableNow = false,
    this.chargerTypes = const {},
    this.distance = 'Any',
  });

  StationFilters copyWith({
    HubTab? network,
    bool? availableNow,
    Set<String>? chargerTypes,
    String? distance,
  }) {
    return StationFilters(
      network: network ?? this.network,
      availableNow: availableNow ?? this.availableNow,
      chargerTypes: chargerTypes ?? this.chargerTypes,
      distance: distance ?? this.distance,
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final StationFilters initialFilters;

  const FilterBottomSheet({
    super.key,
    this.initialFilters = const StationFilters(),
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late StationFilters filters;

  @override
  void initState() {
    super.initState();
    filters = widget.initialFilters.copyWith(
      chargerTypes: Set<String>.from(widget.initialFilters.chargerTypes),
    );
  }

  void reset() {
    setState(() => filters = const StationFilters());
  }

  void toggleCharger(String type) {
    final selected = Set<String>.from(filters.chargerTypes);
    if (!selected.add(type)) {
      selected.remove(type);
    }
    setState(() => filters = filters.copyWith(chargerTypes: selected));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE3EC),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF101A35),
                    ),
                  ),
                  TextButton(
                    onPressed: reset,
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: _navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              _sectionTitle('Network'),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _pale,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    _networkOption('All', HubTab.All),
                    _networkOption('HyCharge', HubTab.HyCharge),
                    _networkOption('Partner', HubTab.Partner),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _border,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ONLY IF SUPPORTED BY API',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _muted,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Available now',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF101A35),
                          ),
                        ),
                        Switch.adaptive(
                          value: filters.availableNow,
                          activeTrackColor: _navy,
                          onChanged: (value) {
                            setState(() {
                              filters = filters.copyWith(
                                availableNow: value,
                              );
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    _sectionTitle('Charger type'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 7,
                      runSpacing: 8,
                      children: [
                        _chargerOption('3-Pin Socket'),
                        _chargerOption('Type 2'),
                        _chargerOption('CCS2'),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _sectionTitle('Distance'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        _distanceOption('5 km'),
                        _distanceOption('10 km'),
                        _distanceOption('25 km'),
                        _distanceOption('Any'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, filters);
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF101A35),
        ),
      ),
    );
  }

  Widget _networkOption(String title, HubTab tab) {
    final selected = filters.network == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => filters = filters.copyWith(network: tab));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? _navy : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _chargerOption(String title) {
    final selected = filters.chargerTypes.contains(title);

    return _choiceChip(
      title,
      selected,
      () => toggleCharger(title),
    );
  }

  Widget _distanceOption(String title) {
    return _choiceChip(
      title,
      filters.distance == title,
      () => setState(
        () => filters = filters.copyWith(distance: title),
      ),
    );
  }

  Widget _choiceChip(
    String title,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF0FF) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? _navy : _border,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? _navy : const Color(0xFF344054),
          ),
        ),
      ),
    );
  }
}
