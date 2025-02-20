import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../app_assets.dart';
import '../../controllers/session_controller.dart';
import '../../controllers/venta_controller.dart';
import '../../models/venta.dart';
import '../../themes/color_palette.dart';
import '../../utils/exception_util.dart';
import '../../utils/tool_util.dart';
import '../../widgets/ventas/venta_item_widget.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  DateTimeRange? selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  String selectedFilter = '📌 Hoy';
  final SessionController sessionController = Get.find<SessionController>();
  final VentaController ventaController = Get.find<VentaController>();
  late Future<List<Venta>> ventasFuture;
  double totalVentas = 0.0;

  @override
  void initState() {
    super.initState();
    ventasFuture = _fetchVentas();
  }

  /// Método para actualizar las ventas con el nuevo rango de fechas
  void _onDateFilterSelected(DateTimeRange range, String filter) {
    setState(() {
      selectedRange = range;
      selectedFilter = filter;
      ventasFuture =
          _fetchVentas(); // 🔹 Vuelve a llamar a la API con el nuevo rango
    });
  }

  Future<List<Venta>> _fetchVentas() async {
    final List<Venta> ventas = await ventaController.listar(
      empresa: sessionController.usuario.empresa,
      sucursal: sessionController.usuario.sucursal,
      fechaInicio: DateFormat('yyyy-MM-dd').format(selectedRange!.start),
      fechaFin: DateFormat('yyyy-MM-dd').format(selectedRange!.end),
    );
    totalVentas = ventas
        .where((Venta venta) => venta.status == 'PAGADO')
        .fold(0, (double sum, Venta venta) => sum + venta.total);
    setState(() {});
    return ventas;
  }

  Widget _buildErrorWidget(String message, Widget imageWidget) {
    return Center(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final String selectedText =
        "${DateFormat('yyyy/MM/dd').format(selectedRange!.start)} - ${DateFormat('yyyy/MM/dd').format(selectedRange!.end)}";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DateFilterWidget(
            onFilterSelected: _onDateFilterSelected,
            selectedFilter: selectedFilter,
          ),
          const SizedBox(height: 20),
          Text(
            '📅 Rango fechas: $selectedText',
            style: const TextStyle(fontSize: 16),
          ),
          Expanded(
            child: FutureBuilder<List<Venta>>(
              future: ventasFuture,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Venta>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SkeletonListView();
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
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay ventas disponibles'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Venta venta = snapshot.data![index];
                    return VentaItemWidget(
                      venta: venta,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Total de ventas pagadas',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 18,
                          color: colorGris600,
                        ),
                  ),
                  const Gap(6),
                  AutoSizeText(
                    ToolUtil().formatCurrency(totalVentas),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 28),
                    maxLines: 1,
                    minFontSize: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateFilterWidget extends StatefulWidget {
  const DateFilterWidget({
    super.key,
    required this.onFilterSelected,
    required this.selectedFilter,
  });

  final Function(DateTimeRange, String) onFilterSelected;
  final String selectedFilter;

  @override
  DateFilterWidgetState createState() => DateFilterWidgetState();
}

class DateFilterWidgetState extends State<DateFilterWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDateRange(0, '📌 Hoy');
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      saveText: 'Buscar',
      helpText: 'Selecciona rango de fechas',
      keyboardType: TextInputType.text,
    );

    if (picked != null) {
      widget.onFilterSelected(picked, '📅 Personalizado');
    }
  }

  void _setDateRange(int days, String label) {
    final DateTime now = DateTime.now();
    DateTime start = now;
    DateTime end = now;

    switch (days) {
      case 0:
        start = now;
        break;
      case 1:
        start = now.subtract(const Duration(days: 1));
        end = start;
        break;
      case 7:
        start = now.subtract(const Duration(days: 7));
        break;
      case 30:
        start = now.subtract(const Duration(days: 30));
        break;
      case -1:
        start = DateTime(now.year, now.month);
        break;
      case -2:
        final DateTime firstDayLastMonth = DateTime(now.year, now.month - 1);
        start = firstDayLastMonth;
        end = DateTime(now.year, now.month, 0);
        break;
    }

    widget.onFilterSelected(DateTimeRange(start: start, end: end), label);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              _filterButton('📌 Hoy', () => _setDateRange(0, '📌 Hoy')),
              _filterButton('📌 Ayer', () => _setDateRange(1, '📌 Ayer')),
              _filterButton('📌 Últimos 7 días',
                  () => _setDateRange(7, '📌 Últimos 7 días')),
              _filterButton('📌 Últimos 30 días',
                  () => _setDateRange(30, '📌 Últimos 30 días')),
              _filterButton(
                  '📌 Este mes', () => _setDateRange(-1, '📌 Este mes')),
              _filterButton('📌 Mes anterior',
                  () => _setDateRange(-2, '📌 Mes anterior')),
              _filterButton(
                  '📅 Personalizado', () => _selectDateRange(context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterButton(String text, VoidCallback onPressed) {
    final bool isSelected = widget.selectedFilter == text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
