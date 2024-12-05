import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/connectivity_service.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  final Widget? offlineWidget;

  const ConnectivityWrapper({
    Key? key,
    required this.child,
    this.offlineWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: GetIt.I<ConnectivityService>().connectionStatus,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;
        
        if (!isConnected && offlineWidget != null) {
          return offlineWidget!;
        }

        if (!isConnected) {
          return Stack(
            children: [
              child,
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  child: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Sem conexão com a internet',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return child;
      },
    );
  }
}
