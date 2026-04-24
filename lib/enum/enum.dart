enum WalletFilterType {
  all,
  last7Days,
  thisMonth,
  Debit,
  Credit
}
extension WalletFilterTypeExtension on WalletFilterType {
  String get label {
    switch (this) {
      case WalletFilterType.all:
        return "All";
      case WalletFilterType.last7Days:
        return "Last 7 Days";
      case WalletFilterType.thisMonth:
        return "This Month";
      case WalletFilterType.Debit:
        return "Debit";
      case WalletFilterType.Credit:
        return "Credit";
    }
  }
}


enum ChargerFilterType {
  ac,
  dc,
  car,
  bike,
  both,
  fast,
}