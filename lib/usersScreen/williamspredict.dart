import 'package:flutter/material.dart';
import 'package:genesapp/widgets/custom_app_bar_simple.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Williamspredict extends StatefulWidget {
  const Williamspredict({super.key});

  @override
  State<Williamspredict> createState() => WilliamspredictState();
}

class WilliamspredictState extends State<Williamspredict> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  String? resultado;
  double? probabilidad;

  Future<void> _enviarFormulario() async {
    const url = 'http://TU_IP_LOCAL:5000/predict'; // Cambia esto por tu IP local
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_formData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          resultado = data['diagnostico'];
          probabilidad = data['probabilidad'];
        });
      } else {
        setState(() => resultado = 'Error en la predicción');
      }
    } catch (e) {
      setState(() => resultado = 'Error de conexión: $e');
    }
  }

  Widget _buildTextField(String label, String keyName) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onSaved: (value) => _formData[keyName] = value ?? '0',
      validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
      keyboardType: TextInputType.number,
    );
  }

  final List<Map<String, String>> campos = [
    {'label': 'TALLA/EDAD (ACTUAL)_0', 'key': 'TALLA/EDAD (ACTUAL)_0'},
    {'label': 'TALLA/EDAD (ACTUAL)_Alto', 'key': 'TALLA/EDAD (ACTUAL)_Alto'},
    {'label': 'TALLA/EDAD (ACTUAL)_Bajo', 'key': 'TALLA/EDAD (ACTUAL)_Bajo'},
    {'label': 'TALLA/EDAD (ACTUAL)_Normal', 'key': 'TALLA/EDAD (ACTUAL)_Normal'},
    {'label': 'Peso al nacer/edad gestacional_0', 'key': 'Peso al nacer/edad gestacional_0'},
    {'label': 'Peso al nacer/edad gestacional_Adecuado', 'key': 'Peso al nacer/edad gestacional_Adecuado'},
    {'label': 'Peso al nacer/edad gestacional_Alto', 'key': 'Peso al nacer/edad gestacional_Alto'},
    {'label': 'Peso al nacer/edad gestacional_Bajo', 'key': 'Peso al nacer/edad gestacional_Bajo'},
    {'label': 'SEXO', 'key': 'SEXO'},
    {'label': 'PESO', 'key': 'PESO'},
    {'label': 'EDAD', 'key': 'EDAD'},
    {'label': 'BAJO PESO AL NACER', 'key': 'BAJO PESO AL NACER'},
    {'label': 'TALLA/EDAD (ACTUAL).1', 'key': 'TALLA/EDAD (ACTUAL).1'},
    {'label': 'PESO/EDAD (ACTUAL)', 'key': 'PESO/EDAD (ACTUAL)'},
    {'label': 'RDPM / DISCAPACIDAD INTELECTUAL', 'key': 'RDPM / DISCAPACIDAD INTELECTUAL'},
    {'label': 'CARACTERISTICAS FACIALES', 'key': 'CARACTERISTICAS FACIALES'},
    {'label': 'DEPRESION BITEMPORAL', 'key': 'DEPRESION BITEMPORAL'},
    {'label': 'CEJAS ARQUEADAS', 'key': 'CEJAS ARQUEADAS'},
    {'label': 'PLIEGUE EPICANTICO', 'key': 'PLIEGUE EPICANTICO'},
    {'label': 'PATRON ESTELAR DEL IRIS', 'key': 'PATRON ESTELAR DEL IRIS'},
    {'label': 'PUENTE NASAL DEPRIMIDO', 'key': 'PUENTE NASAL DEPRIMIDO'},
    {'label': 'NARIZ CORTA NARINAS ANTEVERTIDAS', 'key': 'NARIZ CORTA NARINAS ANTEVERTIDAS'},
    {'label': 'PUNTA NASAL ANCHA O BULBOSA', 'key': 'PUNTA NASAL ANCHA O BULBOSA'},
    {'label': 'MEJILLAS PROMINENTES', 'key': 'MEJILLAS PROMINENTES'},
    {'label': 'REGION MALAR PLANA', 'key': 'REGION MALAR PLANA'},
    {'label': 'FILTRUM LARGO', 'key': 'FILTRUM LARGO'},
    {'label': 'LABIOS GRUESOS', 'key': 'LABIOS GRUESOS'},
    {'label': 'DIENTES PEQUEÑOS O ESPACIADOS', 'key': 'DIENTES PEQUEÑOS O ESPACIADOS'},
    {'label': 'PALADAR ALTO Y OJIVAL', 'key': 'PALADAR ALTO Y OJIVAL'},
    {'label': 'BOCA AMPLIA', 'key': 'BOCA AMPLIA'},
    {'label': 'PABELLONES AURICULARES GRANDES', 'key': 'PABELLONES AURICULARES GRANDES'},
    {'label': 'CARDIOPATIA CONGENITA', 'key': 'CARDIOPATIA CONGENITA'},
    {'label': 'ESTENOSIS SUPRAVALVULAR AORTICA', 'key': 'ESTENOSIS SUPRAVALVULAR AORTICA'},
    {'label': 'ESTENOSIS PULMONAR', 'key': 'ESTENOSIS PULMONAR'},
    {'label': 'OTRA CARDIOPATIA', 'key': 'OTRA CARDIOPATIA'},
    {'label': 'OTRAS ALTERACIONES', 'key': 'OTRAS ALTERACIONES'},
    {'label': 'VOZ DISFONICA', 'key': 'VOZ DISFONICA'},
    {'label': 'TRASTORNO TIROIDEO', 'key': 'TRASTORNO TIROIDEO'},
    {'label': 'TRASTORNO DE LA REFRACCION', 'key': 'TRASTORNO DE LA REFRACCION'},
    {'label': 'HERNIA', 'key': 'HERNIA'},
    {'label': 'ORQUIDOPEXIA', 'key': 'ORQUIDOPEXIA'},
    {'label': 'SINOSTOSIS RADIOCUBITAL', 'key': 'SINOSTOSIS RADIOCUBITAL'},
    {'label': 'HIPERLAXITUD ARTICULAR', 'key': 'HIPERLAXITUD ARTICULAR'},
    {'label': 'ANTECEDENTE DE ORQUIDOPEXIA', 'key': 'ANTECEDENTE DE ORQUIDOPEXIA'},
    {'label': 'ESCOLIOSIS', 'key': 'ESCOLIOSIS'},
    {'label': 'HIPERCALCEMIA', 'key': 'HIPERCALCEMIA'},
    {'label': 'RETRASO EN EL DESARROLLO PSICOMOTOR', 'key': 'RETRASO EN EL DESARROLLO PSICOMOTOR'},
    {'label': 'DÉFICIT COGNITIVO', 'key': 'DÉFICIT COGNITIVO'},
    {'label': 'PERSONALIDAD SOCIAL EXTREMA', 'key': 'PERSONALIDAD SOCIAL EXTREMA'},
    {'label': 'TRASTORNOS DEL APRENDIZAJE', 'key': 'TRASTORNOS DEL APRENDIZAJE'},
    {'label': 'ANSIEDAD O FOBIAS', 'key': 'ANSIEDAD O FOBIAS (Sonidos fuertes, lugares cerrados, separación, etc.)'},
    {'label': 'PROBLEMAS DEL SUEÑO', 'key': 'PROBLEMAS DEL SUEÑO (Insomnio, despertares nocturnos)'},
    {'label': 'GENÉTICA CONFIRMADA', 'key': 'GENÉTICA CONFIRMADA (Deleción 7q11.23 / Sin análisis)'},
    {'label': 'ESTUDIO MOLECULAR CONFIRMATORIO', 'key': 'ESTUDIO MOLECULAR CONFIRMATORIO'},
    {'label': 'HIPOACUSIA', 'key': 'HIPOACUSIA'},
    {'label': 'HIPERSENSIBILIDAD AUDITIVA', 'key': 'HIPERSENSIBILIDAD AUDITIVA (HIPERACUSIA)'},
    {'label': 'ALTERACIONES VISUALES', 'key': 'ALTERACIONES VISUALES (Miopía, astigmatismo, estrabismo)'},
    {'label': 'ALTERACIONES HORMONALES', 'key': 'ALTERACIONES HORMONALES (Pubertad tardía, alteraciones tiroideas adicionales)'},
    {'label': 'DIABETES INFANTIL', 'key': 'DIABETES INFANTIL O INTOLERANCIA A LA GLUCOSA'},
    {'label': 'DÉFICIT DE CRECIMIENTO', 'key': 'DÉFICIT DE CRECIMIENTO'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSimple(
        title: "predictividad williams",
        color: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ...campos.map((campo) => _buildTextField(campo['label']!, campo['key']!)).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _enviarFormulario();
                  }
                },
                child: const Text("Enviar"),
              ),
              if (resultado != null) ...[
                const SizedBox(height: 20),
                Text("Resultado: $resultado", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (probabilidad != null)
                  Text("Probabilidad: ${(probabilidad! * 100).toStringAsFixed(2)}%"),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
