import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_testground/constants/enums.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription? connectivityStreamSubscription;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    monitorInternetConnection();
  }

  StreamSubscription<ConnectivityResult> monitorInternetConnection() {
    return connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (event == ConnectivityResult.mobile) {
        emitInternetConnected(ConnectionType.mobile);
      } else if (event == ConnectivityResult.ethernet) {
        emitInternetConnected(ConnectionType.ethernet);
      } else if (event == ConnectivityResult.none) {
        emitInternetDisconnected();
      }
    });
  }

  void emitInternetConnected(ConnectionType _connectionType) => emit(
        InternetConnected(
          connectionType: _connectionType,
        ),
      );

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription?.cancel();
    return super.close();
  }
}
