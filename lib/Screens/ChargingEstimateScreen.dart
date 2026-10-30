import 'dart:async';

import 'package:HyCharge/Bottomsheet/showAddMoneyBottomSheet.dart';
import 'package:HyCharge/Provider/ChargingEstimateProvider.dart';
import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Provider/charger_details_provider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/SessionChargingScreen.dart';
import 'package:HyCharge/Screens/WaitingForSessionScreen.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/LocationConvert.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
import 'package:HyCharge/model/LocalStartUnifiedChargingSessionResponse.dart';
import 'package:HyCharge/model/SessionIdResponse.dart';
import 'package:HyCharge/model/StartUnifiedChargingSessionResponse.dart';
import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';
import 'package:HyCharge/widget/CommonButton.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChargingEstimateScreen extends StatefulWidget {
  Connector? selectedCharger;
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
      this.chargingConnector,this.selectedStationName,this.station, });

  @override
  State<ChargingEstimateScreen> createState() => _ChargingEstimateScreenState();
}

class _ChargingEstimateScreenState extends State<ChargingEstimateScreen> {
  double currentWalletPrice = 0.0;
  String? selectedStationID;
 
  Connector? _selectedCharger;
  String? _selectedStationID;
    String? selectedStationName;
  
  String? chargingConnector;
  @override
void dispose() {
  context
      .read<ChargingProvider>()
      .cancelSessionIdPolling();

  super.dispose();
}
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

    selectedStationName= widget.selectedCharger?.chargerTypeName ??"";
    chargingConnector= widget.selectedCharger?.connectorId ?? "";
    // print("CHSGE");
    // print(_selectedCharger!.recId!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
  final provider = context.read<WalletProvider>();

  if (provider.walletListResponse == null) {
    provider.fetchWallet(context);
  }
});

  
    if (widget.isAPPLINK == "1" && widget.chargerID != null) {
      
  // getChagerDetails(widget.chargerID!);
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
  // getChagerDetails(String chargerID) async {
  //   final provider =
  //       Provider.of<ChargerDetailsProvider>(context, listen: false);

  //   final response = await provider.fetchChargerDetails(
  //     context,
  //     chargerID,
  //   );
  //   //21julu
  //   _selectedCharger = response!.charger;
  //   _selectedStationID = response.charger!.chargingStationId;
  //    selectedStationName=response.charger?.chargePointName ?? "";
  //   chargingConnector= response.charger?.connectorName ?? "";
  //   // print(response.charger?.chargerTypeName);
  //   widget.selectedCharger = response.charger;




  // }

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
       context
      .read<ChargingProvider>()
      .cancelSessionIdPolling();
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
                 context
      .read<ChargingProvider>()
      .cancelSessionIdPolling();
                 Navigator.pop(context);
              }
            },
          ),

          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
              decoration: const BoxDecoration(
    color: CommonColors.cardWhite,
    border: Border(
      top: BorderSide(color: Color(0xFFE1E5EB), width: 1), // outlineVariant divider
    ),
  ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ⭐ VERY IMPORTANT
                children: [

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
     Row(
      children: [
        SvgPicture.asset(CommonImagePath.transaction,width: 16,height: 16,color: CommonColors.grey,),
        SizedBox(width: 8),
        Text(
          "Wallet credits",
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF69758B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    Text(
      "₹ ${currentWalletPrice.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: Color(0xFF101B36),
      ),
    ),
  ],
),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text("Wallet credits", style: TextStyle(fontSize: 12)),
                  //     Text("₹ ${currentWalletPrice}",
                  //         style: TextStyle(
                  //             fontSize: 12, fontWeight: FontWeight.w700)),
                  //   ],
                  // ),
                  const SizedBox(height: 16),
               walletProvider.isInitialLoading?
                 SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: Consumer<ChargingProvider>(
                      builder: (context, provider, _) => ElevatedButton(
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: CommonColors.blue,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        // ),

style: ElevatedButton.styleFrom(
  backgroundColor: CommonColors.blue,
  foregroundColor: Colors.white,
  minimumSize: const Size(double.infinity, 52),
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(28),
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ):   SizedBox(
                    width: double.infinity,
                    height: 44,
                    
                    child: Consumer<ChargingProvider>(
                      builder: (context, provider, _) => 
                      provider.loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      CommonColors.white),
                                ),
                              )
                            :  CommonButton(
                              fontSize: 14,
        titleColor:  CommonColors.white,
        backgroundColor:    CommonColors.blue,
      title:   "Start Charging",
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
// print(response.data!.raw!.authorizationReference!);
                                  // ✅ start session
                                  final response = await provider.startUnifiedSession(
                                      context: context,
                                      chargingGunId: _selectedCharger!
                                          .id!, //widget.selectedCharger!.recId!,
                                      chargingStationId:
                                          _selectedStationID!, //widget.selectedStationID!,
                                      userId: userId,
                                      chargeTagId: "B4A63CDF",
                                      connectorId: _selectedCharger!
                                          .connectorId!.toString(), //int.parse(widget.selectedCharger!.connectorId!),
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
                                          print("RUCHI");
                                          if (!mounted) return;
                                          if (response is StartUnifiedChargingSessionResponse) {
  // Partner charging session
       print("RUCHI ${response!}");
           print("RUCHI ${response!.success}");
                                  if (response != null && response.success) {
                                    FocusScope.of(context).unfocus();
                                    // showToast(
                                    //     "Charging session started successfully!");
                                    print("BEFORE STSRT");
                                   print(response.data!.raw!.authorizationReference!);
                                    print("Connector ID${_selectedCharger!.connectorId}");
                        String  authorizationReference="";
                         if(response.data!.raw!.authorizationReference!.startsWith("P"))
                         {
authorizationReference="${response.data!.raw!.authorizationReference!}";
                         } else
                         {
                          authorizationReference="P:${response.data!.raw!.authorizationReference!}";
                         }        

   Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SessionChargingScreen(
                                          args: SessionChargingArgs(
                                            authorizationReference:authorizationReference,
                                              sessionId:
                                              "",
                                               
                                              status: response.data?.raw?.status ??
                                                  "",
                                              cost:
                                             
                                                  "0",
                                              unitConsumed: 
                                            
                                                  "0",
                                              outputPower: 
                                             
                                                  "0",
                                              batteryPercentage:
                                                  
                                                          "0",
                                              endMeterReading: 
                                            
                                               "0",
                                              duration: 
                                             
                                              "0",
                                              stationName: 
                                             
                                              "",
                                              ConnectorGunID: response.data!.connectorId ?? ""
                                              
                                              ),
                                        ),
                                      ),
                                    );

                                  } else {
                                    FocusScope.of(context).unfocus();
                                    showToast("Failed to start session");
                                  }
}

if (response is LocalStartUnifiedChargingSessionResponse) {
  // Local charging session
       print("RUCHI ${response!}");
           print("RUCHI ${response!.success}");
                                  if (response != null && response.success) {
                                    FocusScope.of(context).unfocus();
                                    showToast(
                                        "Charging session started successfully!");
                                    print("BEFORE STSRT");
                                  
                                    print("Connector ID${_selectedCharger!.connectorId}");

                                  
                                 
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SessionChargingScreen(
                                          args: SessionChargingArgs(
                                              sessionId:
                                             response.data!.id
                                                ,
                                              status: response.data?.status ??
                                                  "",
                                             cost:
                                              //  response.data!.raw!.result.
                                              //         .chargingTotalFee!
                                              //         .toString() ??
                                                  "0",
                                              unitConsumed: 
                                              // response.data!
                                              //         .session!.energyTransmitted!
                                              //         .toString() ??
                                                  "0",
                                              outputPower: 
                                              // response.data!.session!
                                              //         .chargingGun!.powerOutput
                                              //         .toString() ??
                                                  "0",
                                              batteryPercentage:
                                                  // response.data!.batteryStateOfCharge!.startSoC == null
                                                  //     ? "0"
                                                  //     : response
                                                  //             .data!
                                                  //             .batteryStateOfCharge!
                                                  //             .startSoC
                                                  //             .toString() ??
                                                          "0",
                                              endMeterReading: 
                                              // response.data!.session!.endMeterReading!.toString() ??
                                               "0",
                                              duration: 
                                              // response.data!.session!.duration.toString() ?? 
                                              "0",
                                              stationName: 
                                              // response.data!.session!.chargingStationName ?? 
                                              "",
                                              ConnectorGunID: response.data!.connectorId ?? ""
                                              
                                              ),
                                        ),
                                      ),
                                    );
                                   

                                   
                                   
                                  } else {
                                    FocusScope.of(context).unfocus();
                                    showToast("Failed to start session");
                                  }
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
    )
                      
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: CommonColors.blue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: provider.loading
//                             ? null // disable button while loading
//                             : () async {
//                                 final chargingEstimate =
//                                     context.read<ChargingEstimateProvider>();
//                                 final userId = await AuthStorage.getUserId();
//                                 if (userId == null) return;
        
//                                 final enteredAmount = chargingEstimate.amount;
//                                 print("RRenteredAmount");
//                                 print(enteredAmount);
//                                 if (enteredAmount == 0) {
//                                   FocusScope.of(context).unfocus();
//                                   showToast("Please enter amount");
//                                 } else if (currentWalletPrice >= enteredAmount) {
//                                   final tabIndex = DefaultTabController.of(context).index;

// print("Selected Tab Index: $tabIndex");
// // print(response.data!.raw!.authorizationReference!);
//                                   // ✅ start session
//                                   final response = await provider.startUnifiedSession(
//                                       context: context,
//                                       chargingGunId: _selectedCharger!
//                                           .id!, //widget.selectedCharger!.recId!,
//                                       chargingStationId:
//                                           _selectedStationID!, //widget.selectedStationID!,
//                                       userId: userId,
//                                       chargeTagId: "B4A63CDF",
//                                       connectorId: _selectedCharger!
//                                           .connectorId!.toString(), //int.parse(widget.selectedCharger!.connectorId!),
//                                       startMeterReading: "0",
//                                       chargingTariff: "typeATariff",
//                                       costLimit:
//                                           chargingEstimate.amount.toString(),
//                                       energyLimit:
//                                           chargingEstimate.units.toString(),
//                                       timeLimit: chargingEstimate.time.toStringAsFixed(0),
//                                       batteryIncreaseLimit:
//                                           chargingEstimate.percentage.toString(),
//                                           tabIndex:tabIndex.toString() );
//                                           print("RUCHI");
//                                           if (!mounted) return;
//                                           if (response is StartUnifiedChargingSessionResponse) {
//   // Partner charging session
//        print("RUCHI ${response!}");
//            print("RUCHI ${response!.success}");
//                                   if (response != null && response.success) {
//                                     FocusScope.of(context).unfocus();
//                                     // showToast(
//                                     //     "Charging session started successfully!");
//                                     print("BEFORE STSRT");
//                                    print(response.data!.raw!.authorizationReference!);
//                                     print("Connector ID${_selectedCharger!.connectorId}");
//                         String  authorizationReference="";
//                          if(response.data!.raw!.authorizationReference!.startsWith("P"))
//                          {
// authorizationReference="${response.data!.raw!.authorizationReference!}";
//                          } else
//                          {
//                           authorizationReference="P:${response.data!.raw!.authorizationReference!}";
//                          }        

//    Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => SessionChargingScreen(
//                                           args: SessionChargingArgs(
//                                             authorizationReference:authorizationReference,
//                                               sessionId:
//                                               "",
                                               
//                                               status: response.data?.raw?.status ??
//                                                   "",
//                                               cost:
                                             
//                                                   "0",
//                                               unitConsumed: 
                                            
//                                                   "0",
//                                               outputPower: 
                                             
//                                                   "0",
//                                               batteryPercentage:
                                                  
//                                                           "0",
//                                               endMeterReading: 
                                            
//                                                "0",
//                                               duration: 
                                             
//                                               "0",
//                                               stationName: 
                                             
//                                               "",
//                                               ConnectorGunID: response.data!.connectorId ?? ""
                                              
//                                               ),
//                                         ),
//                                       ),
//                                     );

//                                   } else {
//                                     FocusScope.of(context).unfocus();
//                                     showToast("Failed to start session");
//                                   }
// }

// if (response is LocalStartUnifiedChargingSessionResponse) {
//   // Local charging session
//        print("RUCHI ${response!}");
//            print("RUCHI ${response!.success}");
//                                   if (response != null && response.success) {
//                                     FocusScope.of(context).unfocus();
//                                     showToast(
//                                         "Charging session started successfully!");
//                                     print("BEFORE STSRT");
                                  
//                                     print("Connector ID${_selectedCharger!.connectorId}");

                                  
                                 
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => SessionChargingScreen(
//                                           args: SessionChargingArgs(
//                                               sessionId:
//                                              response.data!.id
//                                                 ,
//                                               status: response.data?.status ??
//                                                   "",
//                                              cost:
//                                               //  response.data!.raw!.result.
//                                               //         .chargingTotalFee!
//                                               //         .toString() ??
//                                                   "0",
//                                               unitConsumed: 
//                                               // response.data!
//                                               //         .session!.energyTransmitted!
//                                               //         .toString() ??
//                                                   "0",
//                                               outputPower: 
//                                               // response.data!.session!
//                                               //         .chargingGun!.powerOutput
//                                               //         .toString() ??
//                                                   "0",
//                                               batteryPercentage:
//                                                   // response.data!.batteryStateOfCharge!.startSoC == null
//                                                   //     ? "0"
//                                                   //     : response
//                                                   //             .data!
//                                                   //             .batteryStateOfCharge!
//                                                   //             .startSoC
//                                                   //             .toString() ??
//                                                           "0",
//                                               endMeterReading: 
//                                               // response.data!.session!.endMeterReading!.toString() ??
//                                                "0",
//                                               duration: 
//                                               // response.data!.session!.duration.toString() ?? 
//                                               "0",
//                                               stationName: 
//                                               // response.data!.session!.chargingStationName ?? 
//                                               "",
//                                               ConnectorGunID: response.data!.connectorId ?? ""
                                              
//                                               ),
//                                         ),
//                                       ),
//                                     );
                                   

                                   
                                   
//                                   } else {
//                                     FocusScope.of(context).unfocus();
//                                     showToast("Failed to start session");
//                                   }
// }
     
   
//                                 } else {
//                                   FocusScope.of(context).unfocus();
//                                   showToast(
//                                       "Wallet does not have sufficient amount");
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => MainTab(
//                                         isLoggedIn: GlobalLists.islLogin,
//                                         currentIndex: 3,
//                                         iscreditopen: true,
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               },
//                         child: provider.loading
//                             ? const SizedBox(
//                                 height: 22,
//                                 width: 22,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2.5,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                       CommonColors.white),
//                                 ),
//                               )
//                             : const Text(
//                                 "Start Charging",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                       ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: CommonColors.background,
         

body: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Connector information card
    Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CommonColors.blue,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: CommonColors.lightBlue,
                    borderRadius: BorderRadius.circular(14)
                  ),
                  padding: const EdgeInsets.all(9),
  alignment: Alignment.center,
  child: SvgPicture.asset(
    CommonImagePath.plugdark,
    color: CommonColors.white,
    width: 20,
    height: 20,
    fit: BoxFit.contain,
  ),
),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalizeWords(selectedStationName ?? ""),
                  style: const TextStyle(
                    color: Colors.white,
                     fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
             
                Text(
                  "Connector ${chargingConnector ?? ""} · "
                  "${widget.selectedCharger?.id ?? ""}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    const Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 16, 12),
      child: Text(
        "Select Charging Method",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111D3A),
        ),
      ),
    ),

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF0F5),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            tabBarTheme: const TabBarThemeData(
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF70798B),
            ),
          ),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: CommonColors.blue,
              borderRadius: BorderRadius.circular(24),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xFF70798B),
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: "Amount"),
              Tab(text: "Units"),
              Tab(text: "Time"),
            ],
          ),
        ),
      ),
    ),

    const SizedBox(height: 2),

    Expanded(
      child: _TabViews(
        _selectedCharger,
        _selectedStationID,
      ),
    ),
  ],
),

// body: Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     // Station and connector details
//     Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: CommonColors.blue,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(
//           left: 12,
//           top: 8,
//           bottom: 12,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               capitalizeWords("${selectedStationName}"),
//               style: const TextStyle(
//                 color: CommonColors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "Connector ${chargingConnector} ${widget.selectedCharger!.id}",
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: CommonColors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),

//     const Padding(
//       padding: EdgeInsets.only(
//         left: 16,
//         top: 16,
//         bottom: 16,
//       ),
//       child: Text(
//         "Select Charging Method",
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),

//     Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Theme(
//         data: Theme.of(context).copyWith(
//           tabBarTheme: const TabBarThemeData(
//             labelColor: CommonColors.blue,
//             unselectedLabelColor: Colors.black54,
//           ),
//         ),
//         child: TabBar(
//           indicatorSize: TabBarIndicatorSize.label,
//           indicator: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           labelColor: CommonColors.blue,
//           unselectedLabelColor: Colors.black54,
//           labelStyle: const TextStyle(
//             fontWeight: FontWeight.w600,
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontWeight: FontWeight.w500,
//           ),
//           tabs: const [
//             Tab(text: "Amount"),
//             Tab(text: "Units"),
//             Tab(text: "Time"),
//           ],
//         ),
//       ),
//     ),

//     // Tab content uses the remaining available height.
//     Expanded(
//       child: _TabViews(
//         _selectedCharger,
//         _selectedStationID,
//       ),
//     ),
//   ],
// ),

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     // 👇 TabBar moved OUT of AppBar
          //       Container(
          //         width: SizeConfig.blockSizeHorizontal *100,
          //          decoration: BoxDecoration(
          //     color: CommonColors.blue,
             
          //   ),
          //         child: Padding(
          //           padding: const EdgeInsets.only(left: 12,top: 8,bottom: 1),
          //           child: Column(
          //              crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 capitalizeWords( "${selectedStationName}"),
          //                 style: const TextStyle(color: CommonColors.white,
          //                     fontSize: 15, fontWeight: FontWeight.w600),
          //               ),
          //               const SizedBox(height: 4),
          //                           Text(
          //           "Connector ${chargingConnector} ${widget.selectedCharger!.id}",
          //           style: const TextStyle(
          //               fontSize: 12, color: CommonColors.white),
          //                           ),
          //                           const SizedBox(height: 12),
          //             ],
          //           ),
          //         ),
          //       ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
          //       child: Text("Select Charging Method",
          //           style: const TextStyle(
          //               fontSize: 14, fontWeight: FontWeight.w600)),
          //     ),
          //     Container(
          //       decoration: BoxDecoration(
          //         color: Colors.grey.shade100,
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: Theme(
          //         data: Theme.of(context).copyWith(
          //           tabBarTheme: TabBarThemeData(
          //             labelColor: CommonColors.blue,
          //             unselectedLabelColor: Colors.black54,
          //           ),
          //         ),
          //         child: TabBar(
          //           indicatorSize: TabBarIndicatorSize.label,
          //           indicator: BoxDecoration(
          //             // color: CommonColors.blue,
          //             borderRadius: BorderRadius.all(Radius.circular(12)),
          //           ),
          //           labelColor: CommonColors.blue,
          //           unselectedLabelColor: Colors.black54,
          //           labelStyle: const TextStyle(
          //             fontWeight: FontWeight.w600,
          //           ),
          //           unselectedLabelStyle: const TextStyle(
          //             fontWeight: FontWeight.w500,
          //           ),
          //           tabs: [
          //             Tab(text: "Amount"),
          //             Tab(text: "Units"),
          //             // Tab(text: "Time"),
          //             Tab(text: "Time"),
          //           ],
          //         ),
          //       ),
          //     ),
                  
          //     // 👇 Content
          //     Expanded(
          //       child: _TabViews(_selectedCharger, _selectedStationID
          //           // widget.selectedCharger,
          //           // widget.selectedStationID
          //           ),
          //     ),
          //     if (MediaQuery.of(context).viewInsets.bottom > 0)
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text("Wallet credits", style: TextStyle(fontSize: 12)),
          //               Text("₹ ${currentWalletPrice}",
          //                   style: TextStyle(
          //                       fontSize: 12, fontWeight: FontWeight.w700)),
          //             ],
          //           ),
          //     ),
          //   ],
          // ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF152957).withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _infoColumn(label1, labelvalue1)),
          _divider(),
          Expanded(child: _infoColumn(label2, labelvalue2)),
          _divider(),
          Expanded(child: _infoColumn(label3, labelvalue3)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 42,
      width: 1,
      color: const Color(0xFFE0E5ED),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF69758B),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 7),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF101B36),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

// class _EstimateCard extends StatelessWidget {
//   final String label1;
//   final String label2;
//   final String label3;
//   final String labelvalue1;
//   final String labelvalue2;
//   final String labelvalue3;

//   const _EstimateCard(
//     this.label1,
//     this.label2,
//     this.label3,
//     this.labelvalue1,
//     this.labelvalue2,
//     this.labelvalue3,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//       margin: const EdgeInsets.only(left: 16,right: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 8),
//         ],
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _infoColumn(label1, labelvalue1),
//             const VerticalDivider(thickness: 1),
//             _infoColumn(label2, labelvalue2),
//             const VerticalDivider(thickness: 1),
//             _infoColumn(label3, labelvalue3),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoColumn(String title, String value) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: CommonColors.blue,
//             fontSize: 13,
//           ),
//         ),
//         Text(value),
//       ],
//     );
//   }
// }

class _TabViews extends StatelessWidget {
  final Connector? selectedCharger;
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
          
                  provider.unifiedestimateCharging(
                    context: context,
                    chargingGunId: selectedCharger!.id.toString(),
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
          
                    provider.unifiedestimateCharging(
                      context: context,
                      chargingGunId: selectedCharger!.id.toString(),
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
    
   prefixIcon:  Padding(
     padding: const EdgeInsets.all(14.0),
     child: SvgPicture.asset(CommonImagePath.clock_green,width: 12,height: 14,color: CommonColors.greyText,),
   ),
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

  provider.unifiedestimateCharging(
    context: context,
    chargingGunId: selectedCharger!.id.toString(),
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
          
              const SizedBox(height: 4),
         
              //  textInfo(),
            ],
          ),
                );
              },
            ),
          ),
          
             textInfo(),
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
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins',color: CommonColors.black)),
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
    color: CommonColors.neutral50,
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
     prefixIcon:  Padding(
     padding: const EdgeInsets.all(6.0),
     child: Image.asset(CommonImagePath.borderGreen,width: 16,height: 16,color: CommonColors.blue,),
   ),
   
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
  final Connector? selectedCharger;
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
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How much amount do you want to charge for?",
          style: TextStyle(
            color: Color(0xFF101B36),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "(Excl. of Taxes)",
          style: TextStyle(
            color: Color(0xFF69758B),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 14),

        // Amount input
        Container(
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFDCE2EB),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              const Text(
                "₹",
                style: TextStyle(
                  color: Color(0xFF657087),
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  
                  controller: provider.controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (val) {
                    provider.activeMode = "amount";
                    provider.setAmount(val);

                    if (_debounce?.isActive ?? false) {
                      _debounce!.cancel();
                    }

                    _debounce = Timer(
                      const Duration(milliseconds: 600),
                      () {
                        if (!mounted) return;

                        provider.unifiedestimateCharging(
                          context: context,
                          chargingGunId:
                              widget.selectedCharger!.id.toString(),
                          chargingStationId:
                              widget.selectedStationID!,
                          connectorId: widget.selectedCharger!
                              .connectorId.toString(),
                          desiredCost: provider.amount,
                        );
                      },
                    );
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter amount",
                    hintStyle: TextStyle(
                      color: Color(0xFF929AA8),
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101B36),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),

        const SizedBox(height: 2),

        // Preset amount chips
        Row(
          children: [100, 200, 500].map((amount) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: amount == 500 ? 0 : 8,
                ),
                child: OutlinedButton(
                  onPressed: () {
                    provider.activeMode = "amount";
                    provider.controller.text = amount.toString();
                    provider.setAmount(amount.toString());

                    if (_debounce?.isActive ?? false) {
                      _debounce!.cancel();
                    }

                    _debounce = Timer(
                      const Duration(milliseconds: 600),
                      () {
                        if (!mounted) return;

                        provider.unifiedestimateCharging(
                          context: context,
                          chargingGunId:
                              widget.selectedCharger!.id.toString(),
                          chargingStationId:
                              widget.selectedStationID!,
                          connectorId: widget.selectedCharger!
                              .connectorId.toString(),
                          desiredCost: provider.amount,
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    side: const BorderSide(
                      color: Color(0xFFDCE2EB),
                    ),
                    shape:  StadiumBorder(),
                    backgroundColor: CommonColors.background,
                  ),
                  child: Text(
                    "₹$amount",
                    style: const TextStyle(
                      color: Color(0xFF101B36),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

  // @override
  // Widget build(BuildContext context) {
  //   final provider = context.watch<ChargingEstimateProvider>();

  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.only(
  //       left: 16,
  //       right: 16,
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Text("How much amount do you want to charge for ?\n(Excl. of Taxes)",
  //             style:
  //                 const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
  //                 SizedBox(height: 10,),
  //         CustomTextFieldWidget(
  //           title: "",
  //           isMandatory: false,
  //           hintText: CommonStrings.strAmountHint,
  //           textInputType: TextInputType.text,

  //           inputFormatters: [
  //             FilteringTextInputFormatter.digitsOnly,
  //           ],
  //           textEditingController: provider.controller,
  //           // textInputType:const TextInputType.numberWithOptions(decimal: false),
  //           leadingIcon: Padding(
  //             padding: const EdgeInsets.only(top: 12,left: 15),
  //             child: Text("₹",
  //                 style:
  //                     const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
  //           ),
  //           onChange: (val) {
  //             provider.activeMode = "amount";
  //             provider.setAmount(val);

  //             final value = double.tryParse(val) ?? 0;

  //             // provider.amount = value;

  //             if (_debounce?.isActive ?? false) _debounce!.cancel();
  //             provider.activeMode = "amount";
  //             _debounce = Timer(Duration(milliseconds: 600), () {
  //               provider.unifiedestimateCharging(
  //                 context: context,
  //                 chargingGunId: widget.selectedCharger!.id.toString(),
  //                 chargingStationId: widget.selectedStationID!,
  //                 connectorId: widget.selectedCharger!.connectorId.toString(),
  //                 desiredCost: provider.amount,
  //               );
  //             });
  //           },
  //         ),
  //         const SizedBox(height: 5),
  //       ],
  //     ),
  //   );
  // }
}
