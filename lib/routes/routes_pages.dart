import 'package:get/get.dart';

import '/routes/routes_names.dart';
import '/screens/login_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/splash_screen.dart';
import '/screens/tabs/ventas_detalle_screen.dart';
import '/screens/tabs_screen.dart';

List<GetPage<dynamic>> rutas = <GetPage<dynamic>>[
  GetPage<dynamic>(name: nameSplashScreen, page: () => const SplashScreen()),
  GetPage<dynamic>(name: nameLoginScreen, page: () => const LoginScreen()),
  GetPage<dynamic>(name: nameTabsScreen, page: () => const TabsScreen()),
  GetPage<dynamic>(name: profileScreen, page: () => const ProfileScreen()),
  GetPage<dynamic>(name: ventaDetalleScreen, page: () => const VentaDetalleScreen()),
];
