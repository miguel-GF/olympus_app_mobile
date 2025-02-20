import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../app_assets.dart';
import '../../constants.dart';
import '../../controllers/session_controller.dart';
import '../../controllers/venta_controller.dart';
import '../../models/venta_grafica_home.dart';
import '../../themes/color_palette.dart';
import '../../utils/exception_util.dart';
import '../../utils/tool_util.dart';
import '../../widgets/gb_shimmer_circular.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, double>> _futureSalesData;
  final SessionController sessionController = Get.find<SessionController>();
  final VentaController ventaController = Get.find<VentaController>();
  String nombreMes = 'asdas';

  @override
  void initState() {
    super.initState();
    _futureSalesData = fetchSalesData();
  }

  Future<Map<String, double>> fetchSalesData() async {
    final DateTime now = DateTime.now();
    DateTime start = now;
    final DateTime end = now;
    start = DateTime(now.year, now.month);
    final List<VentaGraficaHome> ventas =
        await ventaController.obtenerVentasConcentrado(
      empresa: sessionController.usuario.empresa,
      sucursal: sessionController.usuario.sucursal,
      fechaInicio: DateFormat('yyyy-MM-dd').format(start),
      fechaFin: DateFormat('yyyy-MM-dd').format(end),
    );

    final VentaGraficaHome ventaPagada = ventas.firstWhere(
      (VentaGraficaHome vt) => vt.status == statusVentaPagada,
      orElse: () => VentaGraficaHome(status: 'pagada', total: 0.0),
    );

    final VentaGraficaHome ventaDeuda = ventas.firstWhere(
      (VentaGraficaHome vt) => vt.status == statusVentaDeuda,
      orElse: () => VentaGraficaHome(status: 'deuda', total: 0.0),
    );

    setState(() {
      nombreMes = DateFormat('MMMM').format(DateTime.now());
    });
    return <String, double>{
      'ventasPagadas': ventaPagada.total,
      'ventasDeuda': ventaDeuda.total,
    };
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureSalesData = fetchSalesData();
    });
  }

  Widget _buildErrorWidget(String message, Widget imageWidget) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              imageWidget,
              const MaxGap(30),
              Text(
                message,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 18,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: _refreshData,
        child: Stack(children: <Widget>[
          const SizedBox.expand(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
            ),
          ),
          SizedBox(
            height: Get.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centrado verticalmente
                    children: <Widget>[
                      FutureBuilder<Map<String, double>>(
                        future: _futureSalesData,
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, double>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: Get.height * 0.15,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 60),
                                GbShimmerCircular(
                                  width: Get.width * 0.6,
                                  height: Get.height * 0.3,
                                ),
                                const SizedBox(height: 40),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80.0),
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: Get.height * 0.15,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            final Object? error = snapshot.error;

                            if (error is ConnectionException) {
                              return _buildErrorWidget(
                                'No hay conexión a internet',
                                Lottie.asset(
                                  AppAssets.wifiAnimation,
                                  fit: BoxFit.contain,
                                ),
                              );
                            } else if (error is AuthenticationException) {
                              return _buildErrorWidget(
                                'Credenciales incorrectas',
                                const Icon(
                                  Icons.error_outline_rounded,
                                  size: 100,
                                  color: Color.fromRGBO(180, 38, 2, 1),
                                ),
                              );
                            } else if (error is DatabaseException) {
                              return _buildErrorWidget(
                                'Error en la base de datos',
                                const Icon(
                                  Icons.cloud_off_rounded,
                                  size: 100,
                                  color: Color.fromRGBO(180, 38, 2, 1),
                                ),
                              );
                            } else {
                              return _buildErrorWidget(
                                'Error inesperado ${snapshot.error}',
                                const Icon(
                                  Icons.error_outline_rounded,
                                  size: 100,
                                  color: Color.fromRGBO(180, 38, 2, 1),
                                ),
                              );
                            }
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No hay datos disponibles'));
                          }

                          final double ventasPagadas =
                              snapshot.data!['ventasPagadas'] ?? 0.0;
                          final double ventasDeuda =
                              snapshot.data!['ventasDeuda'] ?? 0.0;

                          final List<_SalesData> salesData = <_SalesData>[
                            _SalesData('Pagadas', ventasPagadas, Colors.green),
                            _SalesData('Deuda', ventasDeuda, Colors.red),
                          ];

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Resumen de Ventas de ${nombreMes.capitalize}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Aquí puedes ver la distribución de tus ventas pagadas y pendientes.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 20),
                                SfCircularChart(
                                  legend: const Legend(
                                    isVisible: true,
                                    position: LegendPosition.bottom,
                                  ),
                                  series: <DoughnutSeries<_SalesData, String>>[
                                    DoughnutSeries<_SalesData, String>(
                                      dataSource: salesData,
                                      pointColorMapper: (_SalesData data, _) =>
                                          data.color,
                                      xValueMapper: (_SalesData data, _) =>
                                          data.status,
                                      yValueMapper: (_SalesData data, _) =>
                                          data.amount,
                                      selectionBehavior: SelectionBehavior(
                                        enable: true,
                                        selectedColor:
                                            colorPrimarioClaro, // Color de selección
                                        selectedBorderColor: Colors.black38,
                                        selectedBorderWidth: 2,
                                      ),
                                      dataLabelMapper: (_SalesData data, _) =>
                                          ToolUtil()
                                              .formatCurrency(data.amount),
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                        isVisible: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Total del mes',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ToolUtil().formatCurrency(
                                      ventasPagadas + ventasDeuda),
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.status, this.amount, this.color);
  final String status;
  final double amount;
  final Color color;
}
