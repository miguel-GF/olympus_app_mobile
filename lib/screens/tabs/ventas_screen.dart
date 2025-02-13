import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/session_controller.dart';
import '../../controllers/venta_controller.dart';
import '../../models/venta.dart';

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
      ventasFuture = _fetchVentas(); // 🔹 Vuelve a llamar a la API con el nuevo rango
    });
  }

  Future<List<Venta>> _fetchVentas() async {
    return ventaController.listar(
      empresa: sessionController.usuario.empresa,
      sucursal: sessionController.usuario.sucursal,
      fechaInicio: DateFormat('yyyy-MM-dd').format(selectedRange!.start),
      fechaFin: DateFormat('yyyy-MM-dd').format(selectedRange!.end),
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
              builder: (BuildContext context, AsyncSnapshot<List<Venta>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SkeletonListView();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay ventas disponibles'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Venta venta = snapshot.data![index];
                    return ListTile(
                      title: Text(venta.cliente),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    );
                  },
                );
              },
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
              _filterButton('📌 Últimos 7 días', () => _setDateRange(7, '📌 Últimos 7 días')),
              _filterButton('📌 Últimos 30 días', () => _setDateRange(30, '📌 Últimos 30 días')),
              _filterButton('📌 Este mes', () => _setDateRange(-1, '📌 Este mes')),
              _filterButton('📌 Mes anterior', () => _setDateRange(-2, '📌 Mes anterior')),
              _filterButton('📅 Personalizado', () => _selectDateRange(context)),
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
