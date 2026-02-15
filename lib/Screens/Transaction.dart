import 'package:HyCharge/Bottomsheet/showAddMoneyBottomSheet.dart';
import 'package:HyCharge/Provider/PaymentProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/enum/enum.dart';

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
      if (widget.creditsOpen) {
        final walletProvider = context.read<WalletProvider>();
        showAddMoneyBottomSheet(
          context,
          walletProvider.currentBalance.toStringAsFixed(2),
        );
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

  String _formatDate(String? isoDate) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(
        title: "Transactions",
        onBack: () => Navigator.pop(context),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 900;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 1200 : double.infinity,
              ),
              child: Consumer<WalletProvider>(
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
                      if (index == 0) return const _WalletSummaryCard();

                      if (index == 1) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Payment History",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800),
                              ),
                              _filterButton(context, provider),
                            ],
                          ),
                        );
                      }

                      final txIndex = index - 2;

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
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Tx {
  final String title;
  final String orderId;
  final String amount;
  final String time;
  final bool isCredit;

  _Tx(this.title, this.amount, this.time, this.isCredit, this.orderId);
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
                Text(item.orderId,
                    style:
                        const TextStyle(fontSize: 10, color: Colors.black54)),
                Row(
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
                        color: item.isCredit
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletSummaryCard extends StatelessWidget {
  const _WalletSummaryCard();

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
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: CommonColors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(CommonImagePath.logo),
              ),
              const SizedBox(width: 12),
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
              SizedBox(
                height: 35,
                width: 110,
                child: ElevatedButton(
                  onPressed: () {
                    showAddMoneyBottomSheet(
                      context,
                      provider.currentBalance.toStringAsFixed(2),
                    );
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
                      color: CommonColors.white,
                    ),
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
