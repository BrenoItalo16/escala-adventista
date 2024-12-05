import 'package:get_it/get_it.dart';
import '../../services/connectivity_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerSingleton<ConnectivityService>(ConnectivityService());
}
