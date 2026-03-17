import 'package:HyCharge/Bottomsheet/showAddMoneyBottomSheet.dart';
import 'package:HyCharge/Provider/PaymentProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Screens/BookingDetailsScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/enum/enum.dart';
import 'package:HyCharge/widget/GlobalLists.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Transaction extends StatefulWidget {
   final bool creditsOpen;
  const Transaction({super.key, required this.creditsOpen});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        final provider = context.read<WalletProvider>();
if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
    !provider.isMoreLoading &&
    provider.hasMore) {
  provider.loadMore(context);
}
      
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
        print("widget.creditsOpe");
      print(widget.creditsOpen);
      if (widget.creditsOpen) {
        final walletProvider = context.read<WalletProvider>();

        print("Current BALANCE ${walletProvider.currentBalance}");
        showAddMoneyBottomSheet(
            context, "${walletProvider.currentBalance.toStringAsFixed(2)}");
      }
      context.read<WalletProvider>().fetchWallet(context);
       context.read<PaymentProvider>().loadRazorpayKey(context);
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
   void _showFilterDialog(BuildContext context) {
    final provider = context.read<WalletProvider>();
    WalletFilterType tempSelected = provider.selectedFilter;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text("Filter Transactions"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: WalletFilterType.values.map((filter) {
              return RadioListTile<WalletFilterType>(
                title:Text(filter.label),
                //  Text(filter.name),
                value: filter,
                groupValue: tempSelected,
                onChanged: (v) => setState(() => tempSelected = v!),
              );
            }).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                provider.changeFilter(tempSelected);
                Navigator.pop(ctx);
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
  Widget _filterButton(BuildContext context, WalletProvider provider) {
    return GestureDetector(
      onTap: () => _showFilterDialog(context),
      child: Container(
        padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: CommonColors.blue, width: 1.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(CommonImagePath.filterblue,
                color: CommonColors.blue),
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
    );
  }
String _formatDate(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return "";

  final parsed = DateTime.parse(isoDate);

  // Treat API time as UTC
  final utcTime = DateTime.utc(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
    parsed.millisecond,
    parsed.microsecond,
  );

  // Convert to IST
  final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));

  return DateFormat('EEE, MMM dd, yyyy hh:mm a').format(istTime);
}
  // String _formatDate(String? isoDate) {
  //   if (isoDate == null || isoDate.isEmpty) return "";
  //   final date = DateTime.parse(isoDate).toLocal();
  //   return DateFormat('EEE, MMM dd, yyyy hh:mm a').format(date);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(
        title: "Transactions",
        onBack: () {
           Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
            ),
            (_) => false,
          );
        },
      ),
      body: Consumer<WalletProvider>(
        builder: (context, provider, _) {
          final transactions = provider.filteredTransactions;

          if (provider.isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount:
                transactions.length + 2 + (provider.isMoreLoading ? 1 : 0),
            itemBuilder: (context, index) {
              // 🔹 Wallet header
              if (index == 0) return _WalletSummaryCard();

              // 🔹 Section title
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Payment History",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      _filterButton(context, provider),
                    ],
                  ),
                );
              }

              final txIndex = index - 2;

              // 🔹 Bottom loader
              if (txIndex == transactions.length && provider.hasMore) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final tx = transactions[txIndex];
              final isCredit = tx.transactionType == "Credit";

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TransactionTile(
                  item: _Tx(
                    tx.transactionType ?? "",
                    "₹${tx.amount ?? 0}",
                    _formatDate(tx.createdOn?.toString()),
                    isCredit,
                    tx.additionalInfo1 ?? "",
                    tx.chargingSessionId ?? ""
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
}

class _WalletHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      child: Column(
        children: [
          _WalletSummaryCard(),
        ],
      ),
    );
  }
}


class _TransactionSection extends StatefulWidget {
  const _TransactionSection();

  @override
  State<_TransactionSection> createState() => _TransactionSectionState();
}

class _TransactionSectionState extends State<_TransactionSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          context.read<WalletProvider>().loadMore(context);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
   
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<WalletProvider>(
        builder: (context, provider, _) {
          final transactions = provider.filteredTransactions;

          // 🔹 Initial loading
          if (provider.isInitialLoading) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // 🔹 Empty state
          if (transactions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text("No Payment History Found"),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Payment History",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  _filterButton(context, provider),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔥 Paginated list
              ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length +
                    (provider.isMoreLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  // 🔹 Bottom loader
                  if (index == transactions.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final tx = transactions[index];
                    
                  final isCredit = tx.transactionType == "Credit";
               
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _TransactionTile(
                      item: _Tx(
                        tx.transactionType ?? "",
                        "₹${tx.amount ?? 0}",
                        
                        _formatDate(tx.createdOn?.toString()),
                        isCredit,
                        tx.additionalInfo1 ?? "",
                        tx.chargingSessionId ?? ""
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _filterButton(BuildContext context, WalletProvider provider) {
    return GestureDetector(
      onTap: () => _showFilterDialog(context),
      child: Container(
        padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: CommonColors.blue, width: 1.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(CommonImagePath.filterblue,
                color: CommonColors.blue),
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
    );
  }

  String _formatDate(String? isoDate) {
    print("DATEvale");
    print(isoDate);
    if (isoDate == null || isoDate.isEmpty) return "";
    final date = DateTime.parse(isoDate).toLocal();
    return DateFormat('EEE, MMM dd, yyyy hh:mm a').format(date);
  }

  void _showFilterDialog(BuildContext context) {
    final provider = context.read<WalletProvider>();
    WalletFilterType tempSelected = provider.selectedFilter;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text("Filter Transactions"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: WalletFilterType.values.map((filter) {
              return RadioListTile<WalletFilterType>(
                title: Text(filter.name),
                value: filter,
                groupValue: tempSelected,
                onChanged: (v) => setState(() => tempSelected = v!),
              );
            }).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                provider.changeFilter(tempSelected);
                Navigator.pop(ctx);
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tx {
  final String title;
  final String orderId;
  final String amount;
  final String time;
  final String sessionID;
  final bool isCredit;

  _Tx(this.title, this.amount, this.time, this.isCredit, this.orderId,  this.sessionID);
}

class _TransactionTile extends StatelessWidget {
  final _Tx item;
  const _TransactionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
         item.isCredit?null:
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingDetailsScreen(recID: item.sessionID
            
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: Colors.black12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.isCredit ? Icons.call_made : Icons.call_received,
                color: item.isCredit ? Colors.green : Colors.orange,
                size: 14,
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
                  Text("${item.orderId}",
                      style:
                          const TextStyle(fontSize: 10, color: Colors.black54)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.time,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black54)),
                      Text(
                          item.isCredit ? "+ ${item.amount}" : "- ${item.amount}",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color:
                                  item.isCredit ? Colors.green : Colors.orange)),
                      // Icon(
                      //   item.isCredit ? Icons.call_received : Icons.call_made,
                      //   color: item.isCredit ? Colors.green : Colors.orange,
                      //   size: 14,
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              /// Left logo / icon
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: CommonColors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(CommonImagePath.logo)),
              const SizedBox(width: 12),

              /// Balance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    provider.isInitialLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            "₹ ${provider.currentBalance.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ],
                ),
              ),

              /// Add Credits button
              SizedBox(
                height: 35,
                width: 110,
                child: ElevatedButton(
                  onPressed: () {
                   
                    showAddMoneyBottomSheet(context,
                        "${provider.currentBalance.toStringAsFixed(2)}");
                   
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommonColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Add Credits",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: CommonColors.white),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
