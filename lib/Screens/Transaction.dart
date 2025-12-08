
import 'package:ev_charging_app/Screens/ChargingHistoryScreen.dart';
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';

import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      
      appBar:
      CommonAppBar(title: "Transaction",onBack: ()  {
Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainTab()),
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
  expandedHeight: 330,
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
        bottom: -1,  // small overlap
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
)
,
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
          _RfidBanner(),
          const SizedBox(height: 14),
          _BalanceCard(),
          const SizedBox(height: 14),
          _AddMoneyButton(),
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
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          )
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Balance",
                    style: TextStyle( fontSize: 13)),
                SizedBox(height: 4),
                Text("₹595.47",
                    style: TextStyle(
                        
                        fontSize: 26,
                        fontWeight: FontWeight.w800)),
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
  }
}

class _AddMoneyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
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
                    "Add Money +",
                    style: TextStyle(
                        fontSize: 12,
                        color: CommonColors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
    );
  }
}
class _TransactionSection extends StatelessWidget {
  const _TransactionSection();

  @override
  Widget build(BuildContext context) {
    final tx = [
      _Tx("Refund - Less Unit Consumed", "₹195.47",
          "Tue, Nov 4, 2025, 10:27 AM", true),
      _Tx("Credit - Add Money", "₹500.00",
          "Tue, Nov 4, 2025, 09:55 AM", true),
      _Tx("Debit - Booking", "₹449.56",
          "Tue, Nov 4, 2025, 09:00 AM", false),
           _Tx("Credit - Add Money", "₹500.00",
          "Tue, Nov 4, 2025, 09:55 AM", true),
      _Tx("Debit - Booking", "₹449.56",
          "Tue, Nov 4, 2025, 09:00 AM", false),
           _Tx("Credit - Add Money", "₹500.00",
          "Tue, Nov 4, 2025, 09:55 AM", true),
      _Tx("Debit - Booking", "₹449.56",
          "Tue, Nov 4, 2025, 09:00 AM", false),
          _Tx("Debit - Booking", "₹449.56",
          "Tue, Nov 4, 2025, 09:00 AM", false),
           _Tx("Credit - Add Money", "₹500.00",
          "Tue, Nov 4, 2025, 09:55 AM", true),
      _Tx("Debit - Booking", "₹449.56",
          "Tue, Nov 4, 2025, 09:00 AM", false),
          _Tx("Debit - Booking", "₹449.56",
          "Tue, Nov 4, 2025, 09:00 AM", false),
           _Tx("Credit - Add Money", "₹500.00",
          "Tue, Nov 4, 2025, 09:55 AM", true),
      _Tx("Debit - Booking", "₹449.56",
          "Tue, Nov 4, 2025, 09:00 AM", false),
    ];

    return Container(
      // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Transactions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
      FilterTabsWidget(),
       const SizedBox(height: 16),
          const Text("November 2025",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
      
          ...tx.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TransactionTile(item: e),
              )),
        ],
      ),
    );
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
          Icon(
            item.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: item.isCredit ? Colors.green : Colors.orange,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(item.time,
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(item.amount,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: item.isCredit ? Colors.green : Colors.orange)),
        ],
      ),
    );
  }
}
