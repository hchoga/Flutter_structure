import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to monitor network connectivity changes
/// Emits connectivity status updates to listeners
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// Check current connectivity status
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  /// Check if device is connected to internet
  Future<bool> get isConnected {
    return _checkIsConnected();
  }

  Future<bool> _checkIsConnected() async {
    final results = await checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  /// Get human-readable status
  String getStatusMessage(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      return 'Connected to WiFi';
    } else if (results.contains(ConnectivityResult.mobile)) {
      return 'Connected to Mobile Data';
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return 'Connected to Ethernet';
    } else if (results.contains(ConnectivityResult.vpn)) {
      return 'Connected to VPN';
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      return 'Connected to Bluetooth';
    } else if (results.contains(ConnectivityResult.satellite)) {
      return 'Connected to Satellite';
    } else if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return 'No Internet Connection';
    } else {
      return 'Connected';
    }
  }
}
