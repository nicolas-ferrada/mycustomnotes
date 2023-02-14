import 'package:connectivity_plus/connectivity_plus.dart';

class CheckInternetConnection {
  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false; // Device not connected to any network
    } else {
      return true; // Device connected to a network, it still might now work if network is bad
    }
  }
}
