import 'package:flutter/material.dart';
import 'package:lista_facil/controllers/report_controller.dart';
import 'package:lista_facil/screens/widgets/price_variation_screen.dart';
import 'package:lista_facil/screens/widgets/top_item_screen.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportController _controller = ReportController();

  double _mediaMensal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    double media = await _controller.getGastosTrimestraisAlimentacao();
    setState(() {
      _mediaMensal = media;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Relatórios",
          style: TextStyle(color: ThemeColor.colorWhite),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 80),
            Text(
              "Gasto médio (últimos 3 meses): \nR\$ ${_mediaMensal.toStringAsFixed(2)}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22,
              color: ThemeColor.colorWhite),
            ),
            const SizedBox(height: 170),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                if(!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PriceVariationScreen(),
                  ),
                );
              },
              child: Text("Variação de preço entre itens",
                style: TextStyle(color: ThemeColor.colorBlueTema),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final topMais = await _controller.getTopItemsMaisComprados();
                if(!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopItemsScreen(
                      title: "Top 10 mais comprados",
                      data: topMais,
                    ),
                  ),
                );
              },
              child: Text("Top 10 itens mais comprados",
                style: TextStyle(color: ThemeColor.colorBlueTema),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final topMais = await _controller.getTopItemsMaisComprados();
                final topMenos = topMais.reversed.toList();

                if(!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopItemsScreen(
                      title: "Top 10 menos comprados",
                      data: topMenos,
                    ),
                  ),
                );
              },
              child: Text("Top 10 itens menos comprados",
                style: TextStyle(color: ThemeColor.colorBlueTema)),
            ),
          ],
        ),
      ),
    );
  }
}
