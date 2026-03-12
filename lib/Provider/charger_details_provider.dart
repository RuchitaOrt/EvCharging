import 'package:HyCharge/Services/charger_service.dart';
import 'package:HyCharge/model/ChargerDetailsResponse.dart';
import 'package:flutter/material.dart';

class ChargerDetailsProvider extends ChangeNotifier {

  final ChargerDetailsApiService _service = ChargerDetailsApiService();

  ChargerDetailsResponse? chargerDetailsResponse;

  bool isLoading = false;

 Future<ChargerDetailsResponse?> fetchChargerDetails(
  BuildContext context,
  String recId,
) async {

  isLoading = true;
  notifyListeners();

  try {

    chargerDetailsResponse =
        await _service.getChargerDetails(context, recId);

    return chargerDetailsResponse; // ✅ RETURN DATA

  } catch (e) {
    debugPrint("CHARGER DETAILS ERROR $e");
    return null;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
}