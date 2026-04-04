import 'dart:async';

import 'package:HyCharge/Bottomsheet/showAddMoneyBottomSheet.dart';
import 'package:HyCharge/Provider/ChargingEstimateProvider.dart';
import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Provider/charger_details_provider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/SessionChargingScreen.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/LocationConvert.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChargingEstimateScreen extends StatefulWidget {
  Charger? selectedCharger;
  String? selectedStationID;
  final String? isAPPLINK;
  final String? chargerID;
  final String? selectedStationName;
 final  String? station;
  final String? chargingConnector;
  ChargingEstimateScreen(
      {super.key,
      this.selectedCharger,
      this.selectedStationID,
      this.isAPPLINK = "0",
      this.chargerID,
      this.chargingConnector,this.selectedStationName,this.station});

  @override
  State<ChargingEstimateScreen> createState() => _ChargingEstimateScreenState();
}

class _ChargingEstimateScreenState extends State<ChargingEstimateScreen> {
  double currentWalletPrice = 0.0;
  String? selectedStationID;
 
  Charger? _selectedCharger;
  String? _selectedStationID;
    String? selectedStationName;
  
  String? chargingConnector;
  @override
  void initState() {
    super.initState();
    
     WidgetsBinding.instance.addPostFrameCallback((_) {
    final estimateProvider = context.read<ChargingEstimateProvider>();

    /// ✅ RESET EVERYTHING
    estimateProvider.controller.clear();
    estimateProvider.resetValues(); // 👈 create this (below)
  });

    _selectedCharger = widget.selectedCharger;

    _selectedStationID = widget.selectedStationID;

    selectedStationName= widget.selectedCharger?.chargePointName ??"";
    chargingConnector= widget.selectedCharger?.connectorName ?? "";
    // print("CHSGE");
    // print(_selectedCharger!.recId!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
  final provider = context.read<WalletProvider>();

  if (provider.walletListResponse == null) {
    provider.fetchWallet(context);
  }
});

  
    if (widget.isAPPLINK == "1" && widget.chargerID != null) {
      
  getChagerDetails(widget.chargerID!);
   MyApp.pendingChargerId = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
    gunPOPUP(); // ✅ SAFE
  });
   
} else {
  //  rToast("chargerID is NULL");
  debugPrint("❌ chargerID is NULL");
}
  }
gunPOPUP()
async {
  print("gunPOPUP");
 await gunConnectorDialog(
  context,
  message: "Plug the charging connector into your vehicle to begin charging.",
);
}
  getChagerDetails(String chargerID) async {
    final provider =
        Provider.of<ChargerDetailsProvider>(context, listen: false);

    final response = await provider.fetchChargerDetails(
      context,
      chargerID,
    );
    _selectedCharger = response!.charger;
    _selectedStationID = response.charger!.chargingStationId;
     selectedStationName=response.charger?.chargePointName ?? "";
    chargingConnector= response.charger?.connectorName ?? "";
    // print(response.charger?.chargerTypeName);
    widget.selectedCharger = response.charger;




  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();

    currentWalletPrice = walletProvider.currentBalance;

    print("Current BALANCE ${walletProvider.currentBalance}");
    print(walletProvider.isInitialLoading);
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: () async {
    if (widget.isAPPLINK == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
        ),
      );
    } else {
      Navigator.pop(context);
    }
    return false; // ✅ now it's Future<bool>
  },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CommonAppBar(
            title: "Plugin and Charge",
            onBack: ()
            {
              if (widget.isAPPLINK == "1") {
               Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
              ),
            );
              }else{
                 Navigator.pop(context);
              }
            },
          ),

          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  // color: CommonColors.neutral50,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black12,
                  //     blurRadius: 8,
                  //     offset: Offset(0, -2),
                  //   ),
                  // ],
                  ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ⭐ VERY IMPORTANT
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Wallet credits", style: TextStyle(fontSize: 12)),
                      Text("₹ ${currentWalletPrice}",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),
               walletProvider.isInitialLoading?
                 SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: Consumer<ChargingProvider>(
                      builder: (context, provider, _) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: walletProvider.isInitialLoading
                            ? null // disable button while loading
                            : () async {
                               
                              },
                        child: provider.loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      CommonColors.white),
                                ),
                              )
                            : const Text(
                                "Start Charging",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ):   SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: Consumer<ChargingProvider>(
                      builder: (context, provider, _) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: provider.loading
                            ? null // disable button while loading
                            : () async {
                                final chargingEstimate =
                                    context.read<ChargingEstimateProvider>();
                                final userId = await AuthStorage.getUserId();
                                if (userId == null) return;
        
                                final enteredAmount = chargingEstimate.amount;
                                print("RRenteredAmount");
                                print(enteredAmount);
                                if (enteredAmount == 0) {
                                  FocusScope.of(context).unfocus();
                                  showToast("Please enter amount");
                                } else if (currentWalletPrice >= enteredAmount) {
                                  final tabIndex = DefaultTabController.of(context).index;

print("Selected Tab Index: $tabIndex");
                                  // ✅ start session
                                  final response = await provider.startSession(
                                      context: context,
                                      chargingGunId: _selectedCharger!
                                          .recId, //widget.selectedCharger!.recId!,
                                      chargingStationId:
                                          _selectedStationID!, //widget.selectedStationID!,
                                      userId: userId,
                                      chargeTagId: "B4A63CDF",
                                      connectorId: int.parse(_selectedCharger!
                                          .connectorId!), //int.parse(widget.selectedCharger!.connectorId!),
                                      startMeterReading: "0",
                                      chargingTariff: "typeATariff",
                                      costLimit:
                                          chargingEstimate.amount.toString(),
                                      energyLimit:
                                          chargingEstimate.units.toString(),
                                      timeLimit: chargingEstimate.time.toStringAsFixed(0),
                                      batteryIncreaseLimit:
                                          chargingEstimate.percentage.toString(),
                                          tabIndex:tabIndex.toString() );
        
                                  if (response != null && response.success) {
                                    FocusScope.of(context).unfocus();
                                    showToast(
                                        "Charging session started successfully!");
                                    print("BEFORE STSRT");
                                    print(response.data!.session!.recId);
                                    print(response
                                        .data!.batteryStateOfCharge!.startSoC);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SessionChargingScreen(
                                          args: SessionChargingArgs(
                                              sessionId:
                                                  response.data!.session!.recId!,
                                              status: response.data!.session!.status ??
                                                  "",
                                              cost: response.data!.session!
                                                      .chargingTotalFee!
                                                      .toString() ??
                                                  "0",
                                              unitConsumed: response.data!
                                                      .session!.energyTransmitted!
                                                      .toString() ??
                                                  "0",
                                              outputPower: response.data!.session!
                                                      .chargingGun!.powerOutput
                                                      .toString() ??
                                                  "0",
                                              batteryPercentage:
                                                  response.data!.batteryStateOfCharge!.startSoC == null
                                                      ? "0"
                                                      : response
                                                              .data!
                                                              .batteryStateOfCharge!
                                                              .startSoC
                                                              .toString() ??
                                                          "0",
                                              endMeterReading: response.data!.session!.endMeterReading!.toString() ?? "0",
                                              duration: response.data!.session!.duration.toString() ?? "0",
                                              stationName: response.data!.session!.chargingStationName ?? "",
                                              ConnectorGunID: response.data!.session!.chargingGun!.connectorId ?? ""
                                              
                                              ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    FocusScope.of(context).unfocus();
                                    showToast("Failed to start session");
                                  }
                                } else {
                                  FocusScope.of(context).unfocus();
                                  showToast(
                                      "Wallet does not have sufficient amount");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MainTab(
                                        isLoggedIn: GlobalLists.islLogin,
                                        currentIndex: 3,
                                        iscreditopen: true,
                                      ),
                                    ),
                                  );
                                }
                              },
                        child: provider.loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      CommonColors.white),
                                ),
                              )
                            : const Text(
                                "Start Charging",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: CommonColors.neutral50,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👇 TabBar moved OUT of AppBar
                Container(
                  width: SizeConfig.blockSizeHorizontal *100,
                   decoration: BoxDecoration(
              color: CommonColors.blue,
             
            ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12,top: 8,bottom: 1),
                    child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalizeWords( "${selectedStationName}"),
                          style: const TextStyle(color: CommonColors.white,
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                                    Text(
                    "Connector ${chargingConnector}",
                    style: const TextStyle(
                        fontSize: 12, color: CommonColors.white),
                                    ),
                                    const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text("Select Charging Method",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    tabBarTheme: TabBarThemeData(
                      labelColor: CommonColors.blue,
                      unselectedLabelColor: Colors.black54,
                    ),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                      // color: CommonColors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    labelColor: CommonColors.blue,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(text: "Amount"),
                      Tab(text: "Units"),
                      // Tab(text: "Time"),
                      Tab(text: "Time"),
                    ],
                  ),
                ),
              ),
                  
              // 👇 Content
              Expanded(
                child: _TabViews(_selectedCharger, _selectedStationID
                    // widget.selectedCharger,
                    // widget.selectedStationID
                    ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom > 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Wallet credits", style: TextStyle(fontSize: 12)),
                        Text("₹ ${currentWalletPrice}",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstimateCard extends StatelessWidget {
  final String label1;
  final String label2;
  final String label3;
  final String labelvalue1;
  final String labelvalue2;
  final String labelvalue3;

  const _EstimateCard(
    this.label1,
    this.label2,
    this.label3,
    this.labelvalue1,
    this.labelvalue2,
    this.labelvalue3,
  );

  @override
  Widget build(BuildContext context) {
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
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoColumn(label1, labelvalue1),
            const VerticalDivider(thickness: 1),
            _infoColumn(label2, labelvalue2),
            const VerticalDivider(thickness: 1),
            _infoColumn(label3, labelvalue3),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: CommonColors.blue,
            fontSize: 13,
          ),
        ),
        Text(value),
      ],
    );
  }
}

class _TabViews extends StatelessWidget {
  final Charger? selectedCharger;
  final String? selectedStationID;
  _TabViews(this.selectedCharger, this.selectedStationID);
  Timer? _debounce;

  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AmountTab(
                selectedCharger: selectedCharger,
                selectedStationID: selectedStationID,
              ),
              textInfo(),
              const SizedBox(height: 8),
              // _EstimateCard("Time", "Unit", "Percentage", "-", "-", "0 %"),
              Consumer<ChargingEstimateProvider>(
                builder: (_, p, __) {
                  return _EstimateCard(
                    "Time",
                    "Unit",
                    "Percentage",
                    "${(p.time ?? 0).round()} min",
                    // "${p.time.toStringAsFixed(2)} min",
                    "${p.units.toStringAsFixed(2)}",
                    "${p.percentage} %",
                  );
                },
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sliderTab(
                label: "Select Units (kWh)",
                min: 1,
                max: 40,
                onChanged: (v) {
                  final provider = context.read<ChargingEstimateProvider>();
                  provider.isDragging = true;
                  provider.activeMode = "units";
                  provider.setUnits(v);
                },
                onChangeEnd: (v) {
                  final provider = context.read<ChargingEstimateProvider>();
                  provider.isDragging = false;
                  provider.activeMode = "units";
          
                  provider.estimateCharging(
                    context: context,
                    chargingGunId: selectedCharger!.recId.toString(),
                    chargingStationId: selectedStationID!,
                    connectorId: selectedCharger!.connectorId.toString(),
                    desiredEnergy: v,
                  );
                },
                valueSelector: (p) => p.units,
              ),
          
              textInfo(),
              const SizedBox(height: 2),
              // _EstimateCard(
              //     "Time", "Percentage", "Amount", "-", "0 %", "₹ 0"),
              Consumer<ChargingEstimateProvider>(
                builder: (_, p, __) {
                  return _EstimateCard(
                    "Time",
                    "Percentage",
                    "Amount",
                    "${(p.time ?? 0).round()} min",
                    // "${p.time.toStringAsFixed(2)} min",
                    "${p.percentage} %",
                    "₹ ${p.amount.round()}",
                  );
                },
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _sliderTab(
              //   label: "Charging Time (hrs)",
              //   min: 0,
              //   max: 80,
              //   onChange: (v) =>
              //       context.read<ChargingEstimateProvider>().updateByTime(v),
              //   valueSelector: (p) => p.time,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 16, bottom: 16),
                child: Text("Select Time in min",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400)),
              ),
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Selector<ChargingEstimateProvider, double>(
              selector: (_, p) => p.time,
              builder: (context, timeValue, __) {
                final provider = context.read<ChargingEstimateProvider>();
if (provider.activeMode != "time" &&
    timeController.text != timeValue.round().toString()) {
  timeController.text = timeValue.round().toString();
}

                return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              /// Title
              // const Text(
              //   "Select Time in min",
              //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              // ),
          
              // const SizedBox(height: 8),
          
              /// Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                ),
                child: Slider(
                  value: timeValue.clamp(0, 80),
                  min: 0,
                  max: 80,
                  activeColor: CommonColors.blue,
                  onChanged: (v) {
                    provider.isDragging = true;
                    provider.activeMode = "time";
                    provider.setTime(v);
                     timeController.text = v.round().toString();
                  },
                  onChangeEnd: (v) {
                    provider.isDragging = false;
                    provider.activeMode = "time";
          
                    provider.estimateCharging(
                      context: context,
                      chargingGunId: selectedCharger!.recId.toString(),
                      chargingStationId: selectedStationID!,
                      connectorId: selectedCharger!.connectorId.toString(),
                      desiredDuration: v.round(),
                    );
                  },
                ),
              ),
          
              /// Min Max labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("0 min", style: TextStyle(fontSize: 12)),
                  Text("1h 20m", style: TextStyle(fontSize: 12)),
                ],
              ),
          
              const SizedBox(height: 10),
          
              /// Manual Input + Display
              Row(
                children: [
          
                  /// TextField
                  Expanded(
                    child: 
                    TextField(
            controller: timeController,
            // keyboardType: TextInputType.number,
            // inputFormatters: [
            //   FilteringTextInputFormatter.digitsOnly,
            //   LengthLimitingTextInputFormatter(3),
            // ],
             keyboardType: TextInputType.text,
        
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
            decoration: InputDecoration(
              hintText: "Enter minutes (0-80)",
              contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
           hintStyle: CommonStyles.textFieldHint,
      errorStyle: CommonStyles.textFieldHint,
      counterText: "",
    
   
      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      disabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
      filled: true,
      fillColor: CommonColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
           onSubmitted: (val) {
  final provider = context.read<ChargingEstimateProvider>();

  double v = double.tryParse(val) ?? 0;

  // ✅ limit between 0 and 80
  v = v.clamp(0, 80);

  // ✅ show toast if exceeded
  if (v == 80 && val != "80") {
    showToast("Maximum allowed time is 80 minutes");
  }

  // ✅ update textfield to corrected value
  timeController.text = v.round().toString();

  provider.activeMode = "time";
  provider.setTime(v);

  provider.estimateCharging(
    context: context,
    chargingGunId: selectedCharger!.recId.toString(),
    chargingStationId: selectedStationID!,
    connectorId: selectedCharger!.connectorId.toString(),
    desiredDuration: v.round(),
  );
}

          )
                  ),
          
                  const SizedBox(width: 10),
          
                  /// Current Value
                  // Text(
                  //   formatAsMinutes(timeValue),
                  //   style: const TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ],
              ),
          
              const SizedBox(height: 8),
          Text("Estimates Value",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
              //  textInfo(),
            ],
          ),
                );
              },
            ),
          ),
             
              const SizedBox(height: 8),
              Consumer<ChargingEstimateProvider>(
                builder: (_, p, __) {
                  return _EstimateCard(
                    "Unit",
                    "Percentage",
                    "Amount",
                    "${p.units.toStringAsFixed(2)}",
                    "${p.percentage} %",
                    "₹ ${p.amount.round()}",
                  );
                },
              ),
          
              //    _EstimateCard("Unit","Percentage","Amount","20","20 %","₹ 2000"),
            ],
          ),
        ),
      ],
    );
  }

  String formatAsMinutes(double minutes) {
    return "${minutes.round()} min";
  }

  String _formatMinutes(double minutes) {
    int hrs = minutes ~/ 60;
    int mins = (minutes % 60).round();

    if (hrs == 0) return "$mins min";
    if (mins == 0) return "$hrs h";
    return "${hrs}h ${mins}m";
  }

  Widget textInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Text("Estimates Value",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
    );
  }
  final BorderRadius borderRadius = const BorderRadius.all(
    
    Radius.circular(8),
  );
  final BorderSide focusedBorder = const BorderSide(
     color: CommonColors.blue,
    width: 1.0,
  );
   final BorderSide enableBorder = BorderSide(
    color: CommonColors.background,
    // color: CraftColors.neutral20Color,
    width: 1.0,
  );
  
Widget _sliderTab({
  required String label,
  required double min,
  required double max,
  required Function(double) onChanged,
  required Function(double) onChangeEnd,
  required double Function(ChargingEstimateProvider) valueSelector,
}) {
  return Selector<ChargingEstimateProvider, double>(
    selector: (_, p) => valueSelector(p),
    builder: (context, value, __) {
      final provider = context.read<ChargingEstimateProvider>();
      final controller = TextEditingController(
        text: value.toStringAsFixed(2),
      );

      final clampedValue = value.clamp(min, max);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Title
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            /// Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                activeColor: CommonColors.blue,
                min: min,
                max: max,
                value: clampedValue,
                onChanged: onChanged,
                onChangeEnd: onChangeEnd,
              ),
            ),

            /// Min Max
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${min.toInt()}",
                    style: const TextStyle(fontSize: 12)),
                Text("${max.toInt()}",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),

            const SizedBox(height: 8),

            /// Selected Value + Manual Input
            Row(
              children: [

                /// Input Field
                Expanded(
                  child: TextField(
                    controller: controller,
                     keyboardType: TextInputType.text,
        
                          inputFormatters: [
                            // FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                    // keyboardType:
                    //     const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Enter value",
                       hintStyle: CommonStyles.textFieldHint,
      errorStyle: CommonStyles.textFieldHint,
      counterText: "",
    
   
      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      disabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
      filled: true,
      fillColor: CommonColors.white,
                    ),
                    onSubmitted: (val) {
                      double v = double.tryParse(val) ?? min;

                      if (v < min) v = min;
                      if (v > max) v = max;

                      onChanged(v);
                      onChangeEnd(v);
                    },
                  ),
                ),

                const SizedBox(width: 10),

                /// Current Value Display
                // Text(
                //   clampedValue.toStringAsFixed(2),
                //   style: const TextStyle(
                //     fontSize: 13,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ],
            ),
              const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
  // Widget _sliderTab({
  //   required String label,
  //   required double min,
  //   required double max,
  //   required Function(double) onChanged,
  //   required Function(double) onChangeEnd,
  //   required double Function(ChargingEstimateProvider) valueSelector,
  // }) {
  //   return Selector<ChargingEstimateProvider, double>(
  //     selector: (_, p) => valueSelector(p),
  //     builder: (context, value, __) {
  //       final clampedValue = value.clamp(min, max);

  //       return Padding(
  //         padding: const EdgeInsets.all(24),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             /// Title
  //             Text(
  //               label,
  //               style: const TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w400,
  //               ),
  //             ),

  //             const SizedBox(height: 10),

  //             /// Slider
  //             SliderTheme(
  //               data: SliderTheme.of(context).copyWith(
  //                 trackHeight: 3,
  //                 thumbShape:
  //                     const RoundSliderThumbShape(enabledThumbRadius: 8),
  //                 overlayShape:
  //                     const RoundSliderOverlayShape(overlayRadius: 14),
  //               ),
  //               child: Slider(
  //                 activeColor: CommonColors.blue,
  //                 min: min,
  //                 max: max,
  //                 value: clampedValue,
  //                 onChanged: onChanged,
  //                 onChangeEnd: onChangeEnd,
  //               ),
  //             ),

  //             /// Min - Max values
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "${min.toInt()}",
  //                   style: const TextStyle(fontSize: 12),
  //                 ),
  //                 Text(
  //                   "${max.toInt()}",
  //                   style: const TextStyle(fontSize: 12),
  //                 ),
  //               ],
  //             ),

  //             // const SizedBox(height: 4),

  //             /// Selected value
  //             Center(
  //               child: Text(
  //                 "${clampedValue.toStringAsFixed(2)}",
  //                 style: const TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}

class _AmountTab extends StatefulWidget {
  final Charger? selectedCharger;
  final String? selectedStationID;

  const _AmountTab({
    required this.selectedCharger,
    required this.selectedStationID,
  });
  @override
  State<_AmountTab> createState() => _AmountTabState();
}

class _AmountTabState extends State<_AmountTab> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChargingEstimateProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text("How much amount do you want to charge for ?\n(Excl. of Taxes)",
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          CustomTextFieldWidget(
            title: "",
            isMandatory: false,
            hintText: CommonStrings.strAmountHint,
            textInputType: TextInputType.text,

            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            textEditingController: provider.controller,
            // textInputType:const TextInputType.numberWithOptions(decimal: false),
            leadingIcon: Text("₹",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            onChange: (val) {
              provider.activeMode = "amount";
              provider.setAmount(val);

              final value = double.tryParse(val) ?? 0;

              // provider.amount = value;

              if (_debounce?.isActive ?? false) _debounce!.cancel();
              provider.activeMode = "amount";
              _debounce = Timer(Duration(milliseconds: 600), () {
                provider.estimateCharging(
                  context: context,
                  chargingGunId: widget.selectedCharger!.recId.toString(),
                  chargingStationId: widget.selectedStationID!,
                  connectorId: widget.selectedCharger!.connectorId.toString(),
                  desiredCost: provider.amount,
                );
              });
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
