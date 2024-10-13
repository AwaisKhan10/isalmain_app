import 'package:get_it/get_it.dart';
import 'package:sheduling_app/core/services/auth_services.dart';
import 'package:sheduling_app/core/services/database_services.dart';

GetIt locator = GetIt.instance;
setupLocator() {
  locator.registerSingleton(AuthServices());
  locator.registerSingleton(DatabaseServices());
}
