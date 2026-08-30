import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityObserver {
  ConnectivityObserver([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> isOnline() async => _isOnline(await _connectivity.checkConnectivity());

  Stream<bool> observe() async* {
    yield _isOnline(await _connectivity.checkConnectivity());
    yield* _connectivity.onConnectivityChanged.map(_isOnline);
  }
}

bool _isOnline(List<ConnectivityResult> results) =>
    results.any((result) => result != ConnectivityResult.none);
