import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/session_controller.dart';
import '../../controllers/venta_controller.dart';
import '../../models/venta.dart';
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

  @override
  void initState() {
    super.initState();
    _futureSalesData = fetchSalesData();
  }

  Future<Map<String, double>> fetchSalesData() async {
    final List<Venta> ventas = await ventaController.listar(
      empresa: sessionController.usuario.empresa,
      sucursal: sessionController.usuario.sucursal,
      fechaInicio: '2025-02-01',
      fechaFin: '2025-02-28',
    );
    print(ventas);
    return <String, double>{
      'ventasPagadas': 1000.0,
      'ventasDeuda': 175.0,
    };
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureSalesData = fetchSalesData();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: _refreshData,
        child: Stack(children: <Widget>[
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
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                      height: Get.height * 0.15,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error al cargar los datos'));
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  'Resumen de Ventas del Mes 📊',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Aquí puedes ver la distribución de tus ventas pagadas y pendientes.',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 20),
                                SfCircularChart(
                                  legend: const Legend(
                                      isVisible: true,
                                      position: LegendPosition.bottom),
                                  series: <DoughnutSeries<_SalesData, String>>[
                                    DoughnutSeries<_SalesData, String>(
                                      dataSource: salesData,
                                      pointColorMapper: (_SalesData data, _) =>
                                          data.color,
                                      xValueMapper: (_SalesData data, _) =>
                                          data.status,
                                      yValueMapper: (_SalesData data, _) =>
                                          data.amount,
                                      dataLabelSettings: const DataLabelSettings(
                                          isVisible: true),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Total del mes',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
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
          const SizedBox.expand(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
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
