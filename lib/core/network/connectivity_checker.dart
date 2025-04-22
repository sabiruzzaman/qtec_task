import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityChecker {
  Future<bool> get isConnected async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
