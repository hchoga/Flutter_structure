import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for network connectivity checks
/// Following SOLID principles (Interface Segregation Principle)
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
