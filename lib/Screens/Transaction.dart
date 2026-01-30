import 'package:ev_charging_app/Bottomsheet/showAddMoneyBottomSheet.dart';
import 'package:ev_charging_app/Provider/WalletProvider.dart';
import 'package:ev_charging_app/Request/AddWalletRequest.dart';
import 'package:ev_charging_app/Screens/ChargingHistoryScreen.dart';
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/enum/enum.dart';
import 'package:ev_charging_app/widget/GlobalLists.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().fetchWallet(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(
          title: "Transactions",
          onBack: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainTab(isLoggedIn: GlobalLists.islLogin)),
            );
          }),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Collapsing header
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            backgroundColor: CommonColors.neutral50,
            expandedHeight: 250,
            elevation: 0,
            title: const Text(
              "Wallet",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            flexibleSpace: Stack(
              children: [
                // Main background
                Positioned.fill(child: _WalletHeader()),

                // Bottom rounded curve
                Positioned(
                  bottom: -1, // small overlap
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: CommonColors.neutral50,
                      // borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // White rounded container for transactions
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: CommonColors.neutral200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: const _TransactionSection(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 60, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // _RfidBanner(),
          // const SizedBox(height: 14),
          _BalanceCard(),
          const SizedBox(height: 14),
          _AddMoneyButton(),
          const SizedBox(height: 14),
          // Text("About Wallet", style: TextStyle(
          //             fontSize: 16,
          //               fontWeight: FontWeight.w700,
          //             )),
          //  Expanded(
          //         child: Text("Your wallet balance is used for charging sessions. Credits can be added via payment methods. All transactions are securely recorded and can be tracked here.",
          //           //"Apply for a free RFID card",
          //           maxLines: 3,
          //             style: TextStyle(
          //             fontSize: 12,
          //               fontWeight: FontWeight.w400,
          //             )),
          //       ),
        ],
      ),
    );
  }
}

class _RfidBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: CommonColors.neutral50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.credit_card, color: Colors.white),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Apply for a free RFID card",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    )),
                SizedBox(height: 2),
                Text("You are now eligible for tap & pay",
                    style: TextStyle(
                      fontSize: 12,
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text("New",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          )
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(builder: (context, provider, _) {
      return Container(
        height: 90,
        decoration: BoxDecoration(
          color: CommonColors.neutral50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet, color: Colors.orange),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Current Balance", style: TextStyle(fontSize: 13)),
                  SizedBox(height: 4),
                  provider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                       "₹${provider.currentBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                  // Text("₹595.47",
                  //     style:
                  //         TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.monetization_on, color: Colors.orange, size: 20),
                  SizedBox(width: 6),
                  Text("2225 coins",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _AddMoneyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        onPressed: () {
          // final provider = context.read<WalletProvider>();
          // provider.addCredits(
          //   context,
          //   AddWalletRequest(
          //     userId: "34b9bfb0-67ad-42c1-a40f-d01ef55fb6bb",
          //     amount: 100,
          //     transactionType: "Credit",
          //     paymentRecId: "razorpay_payment_id",
          //     additionalInfo1: "Station cp1admin",
          //   ),
          // );
           showAddMoneyBottomSheet(context);
        },
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
        child: Consumer<WalletProvider>(builder: (context, provider, child) {
          return provider.isLoading
              ? CircularProgressIndicator(
                  color: CommonColors.blue,
                )
              : Text(
                  "Add Money +",
                  style: TextStyle(
                      fontSize: 12,
                      color: CommonColors.blue,
                      fontWeight: FontWeight.w600),
                );
        }),
      ),
    );
  }
}
class _TransactionSection extends StatelessWidget {
  const _TransactionSection();
 @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final transactions = provider.filteredTransactions;

        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Minimum height to fill space even if no data
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                     
                      Text(
                        "No transactions found",
                       
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Wallet",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        IntrinsicWidth(
                          child: GestureDetector(
                            onTap: () => _showFilterDialog(context),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 4, left: 8, right: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: CommonColors.blue,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    CommonImagePath.filterblue,
                                    color: CommonColors.blue,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    provider.filterLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: CommonColors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    _tabButton(provider.filterLabel, Icons.menu, 0),
                    const SizedBox(height: 16),

                    ...transactions.map((tx) {
                      final isCredit = tx!.transactionType == "Credit";
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TransactionTile(
                          item: _Tx(
                            _buildTitle(
                                "${tx!.transactionType!} - ${tx!.additionalInfo1!}"),
                            "₹${tx.amount.toString() ?? "0"}",
                            _formatDate(tx!.createdOn!.toString()),
                            isCredit,
                          ),
                        ),
                      );
                    }).toList(),

                    // Optional: Add extra space at bottom
                    const SizedBox(height: 50),
                  ],
                ),
        );
      },
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WalletProvider>(
//       builder: (context, provider, _) {
//         if (provider.isLoading) {
//           return const Padding(
//             padding: EdgeInsets.all(24),
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         // final transactions =
//         //     provider.walletListResponse?.wallet?.recentTransactions ?? [];
// final transactions = provider.filteredTransactions;

//         if (transactions.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.all(24),
//             child: Center(child: Text("No transactions found")),
//           );
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Wallet",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//                 ),


//               IntrinsicWidth(
//   child: GestureDetector(
//     onTap: () => _showFilterDialog(context),
//     child: Container(
//       padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: CommonColors.blue,
//             width: 1.5,
//           ),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             CommonImagePath.filterblue,
//             color: CommonColors.blue,
//           ),
//           const SizedBox(width: 5),
//           Consumer<WalletProvider>(
//             builder: (context, provider, _) {
//               return Text(
//                "Filter",
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: CommonColors.blue,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     ),
//   ),
// )

//               ],
//             ),
//              const SizedBox(height: 12),
//             _tabButton( provider.filterLabel, Icons.menu, 0),
//             const SizedBox(height: 16),

//             ...transactions.map((tx) {
//               final isCredit = tx.transactionType == "Credit";

//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: _TransactionTile(
//                   item: _Tx(
//                     _buildTitle("${tx.transactionType} - ${tx.additionalInfo1}"),
//                     "₹${tx.currentCreditBalance ?? "0"}",
//                     _formatDate(tx.createdOn.toString()),
//                     isCredit,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ],
//         );
//       },
//     );
//   }
void _showFilterDialog(BuildContext context) {
  final provider = context.read<WalletProvider>();
  WalletFilterType tempSelected = provider.selectedFilter;

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text("Filter Transactions",style: TextStyle(fontSize: 18),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<WalletFilterType>(
                  title: const Text("This Month"),
                  value: WalletFilterType.thisMonth,activeColor: CommonColors.blue,
                  groupValue: tempSelected,
                  onChanged: (value) {
                    setState(() {
                      tempSelected = value!;
                    });
                  },
                ),
                RadioListTile<WalletFilterType>(
                  title: const Text("Last 7 Days"),
                  value: WalletFilterType.last7Days,activeColor: CommonColors.blue,
                  groupValue: tempSelected,
                  onChanged: (value) {
                    setState(() {
                      tempSelected = value!;
                    });
                  },
                ),
                RadioListTile<WalletFilterType>(
                  title: const Text("All"),
                  value: WalletFilterType.all,activeColor: CommonColors.blue,
                  groupValue: tempSelected,
                  onChanged: (value) {
                    setState(() {
                      tempSelected = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
             
              ElevatedButton(
                onPressed: () {
                  provider.changeFilter(tempSelected);
                  Navigator.pop(ctx);
                },
                child: const Text("Done",style: TextStyle(fontSize: 14,color:  CommonColors.blue,)),
              ),
            ],
          );
        },
      );
    },
  );
}


 Widget _tabButton(String title, IconData icon, int index) {
  return IntrinsicWidth(
    child: GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: CommonColors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: CommonColors.blue.withOpacity(0.6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // 🔑 important
          children: [
            Icon(icon, color: CommonColors.blue, size: 18),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CommonColors.blue,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  String _buildTitle(tx) {
   
    return "${tx}";
  }

  
String _formatDate(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return "";

  final date = DateTime.parse(isoDate).toLocal();

  return DateFormat('EEE, MMM dd, yyyy hh:mm a').format(date);
}
}


class _Tx {
  final String title;
  final String amount;
  final String time;
  final bool isCredit;

  _Tx(this.title, this.amount, this.time, this.isCredit);
}

class _TransactionTile extends StatelessWidget {
  final _Tx item;
  const _TransactionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
        Container(
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(8),
  ),
  child: const Icon(
    Icons.cached,
    size: 20,
    color: Colors.blueGrey,
  ),
),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(item.time,
                    style:
                        const TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            ),
          ),
          Row(
            children: [
              Text(item.amount,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: item.isCredit ? Colors.green : Colors.orange)),
                      Icon(item.isCredit ? Icons.call_received : Icons.call_made ,color: item.isCredit ? Colors.green : Colors.orange,
                      size: 14,
                      )
            ],
          ),
        ],
      ),
    );
  }
}
