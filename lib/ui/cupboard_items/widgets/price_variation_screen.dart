
import 'package:flutter/material.dart';
import 'package:lista_facil/ui/report/view_model/report_view_model.dart';
import 'package:lista_facil/ui/core/themes/colors.dart';

class PriceVariationScreen extends StatefulWidget {
  const PriceVariationScreen({super.key});

  @override
  State<PriceVariationScreen> createState() => _PriceVariationScreenState();
}

class _PriceVariationScreenState extends State<PriceVariationScreen> {
  final ReportViewModel _reportController = ReportViewModel();
  Map<String, double> _difVariacao = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await _reportController.getVariacaoPrecoUltimaCompra();
    setState(() {
      _difVariacao = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = _difVariacao.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Variação de Preços",
        style: TextStyle(
          color: ThemeColor.colorWhite
        ),),
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final e = entries[index];
          final nomeItem = e.key;
          final diff = e.value; 

          String mensagem;
          var diferenca = diff > 0;
          if (diff > 0) {
            mensagem = "Teve um aumento no preço de R\$ ${diff.toStringAsFixed(2)}";
          } else if (diff < 0) {
            mensagem = "Teve uma queda no preço de R\$ ${diff.abs().toStringAsFixed(2)}";
          } else {
            mensagem = "Preço se manteve o mesmo";
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 3.0),
            child: ListTile(
              dense: true,
              tileColor: ThemeColor.colorWhite,
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Item $nomeItem",
                    style: TextStyle(color: ThemeColor.colorBlue),
                  ),
                  diferenca ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.arrow_upward_rounded,color: ThemeColor.colorRed800,),
                  ) : Padding(
                    padding: const EdgeInsets.only(top:  10.0),
                    child: Icon(Icons.arrow_downward, color: ThemeColor.colorGreenTotal,),
                  )
                ],
              ),
              subtitle: Text(
                mensagem,
                style: TextStyle(
                    color: diferenca
                        ? ThemeColor.colorRed800
                        : ThemeColor.colorGreenTotal),
              ),
            ),
          );
        },
      ),
    );
  }
}