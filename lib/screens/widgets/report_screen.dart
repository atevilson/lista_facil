
import 'package:flutter/material.dart';
import 'package:lista_facil/controllers/report_controller.dart';

class ReportScreen extends StatefulWidget {

  const ReportScreen({super.key});

  @override 
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  final ReportController _controller = ReportController();

  double _mediaMensal = 0.0;
  List<MapEntry<String, int>> _top10Mais = [];
  //List<MapEntry<String, int>> _top10Menos = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    double media = await _controller.getGastosTrimestraisAlimentacao(); // gasto médio
    List<MapEntry<String, int>> mais = await _controller.getTopItemsMaisComprados(); // top 10 mais comprados
    //List<MapEntry<String, int>> menos = await _controller.getTop10MenosComprados3Meses(); // top 10 menos comprados

    setState(() {
      _mediaMensal = media;
      _top10Mais = mais;
      //_top10Menos = menos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatórios"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Gasto médio mensal (últimos 3 meses): R\$ $_mediaMensal"),
            Divider(),
            Text("Top 10 mais comprados:"),
            for (var entry in _top10Mais)
              Text("${entry.key}: ${entry.value} unidades"),

            Divider(),
            Text("Top 10 menos comprados:"),
            // for (var entry in _top10Menos)
            //   Text("${entry.key}: ${entry.value} unidades"),
          ],
        ),
      ),
    );
  }
}