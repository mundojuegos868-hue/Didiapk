import 'package:flutter/material.dart';

void main() {
  runApp(DidiProfitCalculator());
}

class DidiProfitCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Didi Ganancia',
      home: ProfitForm(),
    );
  }
}

class ProfitForm extends StatefulWidget {
  @override
  _ProfitFormState createState() => _ProfitFormState();
}

class _ProfitFormState extends State<ProfitForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController kmController = TextEditingController();
  final TextEditingController ingresoController = TextEditingController();
  final TextEditingController duracionController = TextEditingController();

  // Parámetros fijos
  final double consumoKmPorLitro = 15.4; // km/L
  final double precioGasolina = 25;
  final double comisionDidi = 0.15;
  final double costoPorKm = 2;
  final double umbralGanancia = 40;

  double? gasolinaUsada;
  double? costoGasolina;
  double? comision;
  double? costoKmTotal;
  double? gananciaNeta;
  double? gananciaHora;
  String decision = "";

  void calcular() {
    final km = double.tryParse(kmController.text);
    final ingresoBruto = double.tryParse(ingresoController.text);
    final duracionHoras = double.tryParse(duracionController.text);

    if (km == null || ingresoBruto == null || duracionHoras == null || duracionHoras == 0) {
      setState(() {
        decision = "Introduce valores válidos";
      });
      return;
    }

    gasolinaUsada = km / consumoKmPorLitro;
    costoGasolina = gasolinaUsada! * precioGasolina;
    comision = ingresoBruto * comisionDidi;
    costoKmTotal = km * costoPorKm;

    gananciaNeta = ingresoBruto - comision! - costoGasolina! - costoKmTotal!;
    gananciaHora = gananciaNeta! / duracionHoras;

    decision = gananciaNeta! >= umbralGanancia ? "ACEPTAR" : "RECHAZAR";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Ganancia Didi")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: kmController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Distancia (km)"),
              ),
              TextFormField(
                controller: ingresoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Ingreso bruto (\$)"),
              ),
              TextFormField(
                controller: duracionController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Duración viaje (horas)"),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: calcular, child: Text("Calcular")),
              SizedBox(height: 20),

              if (gananciaNeta != null) ...[
                Text("Gasolina usada: ${gasolinaUsada!.toStringAsFixed(2)} L"),
                Text("Costo gasolina: \$${costoGasolina!.toStringAsFixed(2)}"),
                Text("Comisión Didi: \$${comision!.toStringAsFixed(2)}"),
                Text("Costo por km: \$${costoKmTotal!.toStringAsFixed(2)}"),
                Text("Ganancia neta: \$${gananciaNeta!.toStringAsFixed(2)}"),
                Text("Ganancia por hora: \$${gananciaHora!.toStringAsFixed(2)}"),
                SizedBox(height: 10),
                Text("Decisión: $decision", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ] else
                Text(decision, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
