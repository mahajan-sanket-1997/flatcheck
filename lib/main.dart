import 'package:flutter/material.dart';

void main() => runApp(const FlatCheckApp());

class FlatCheckApp extends StatelessWidget {
  const FlatCheckApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlatCheck',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const CalculatorPage(),
      );
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final base = TextEditingController();
  final carpet = TextEditingController();
  final parking = TextEditingController();
  final gst = TextEditingController(text: '5');
  final stamp = TextEditingController(text: '6');
  final registration = TextEditingController(text: '30000');
  final other = TextEditingController();

  double n(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '').trim()) ?? 0;
  String money(double v) => '₹${v.round()}';

  @override
  void dispose() {
    for (final c in [base, carpet, parking, gst, stamp, registration, other]) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agreement = n(base) * 100000;
    final gstAmt = agreement * n(gst) / 100;
    final stampAmt = agreement * n(stamp) / 100;
    final total = agreement + n(parking) + gstAmt + stampAmt + n(registration) + n(other);
    final area = n(carpet);
    final double perSqft = area > 0 ? total / area : 0.0;
    final double extras = agreement > 0 ? (total - agreement) / agreement * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('FlatCheck'), centerTitle: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Know the real cost before you buy.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Quick estimate • Offline • India-focused'),
        const SizedBox(height: 18),
        _field('Agreement / Base Price (₹ lakh)', base),
        _field('Carpet Area (sq ft)', carpet),
        _field('Parking (₹)', parking),
        _field('GST (%)', gst),
        _field('Stamp Duty (%)', stamp),
        _field('Registration (₹)', registration),
        _field('Other Charges (₹)', other),
        const SizedBox(height: 8),
        FilledButton(onPressed: () => setState(() {}), child: const Text('Calculate Real Cost')),
        const SizedBox(height: 20),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Your FlatCheck Result', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _result('Actual Total Purchase Cost', money(total)),
          _result('Effective Price / Carpet sq ft', money(perSqft)),
          _result('Additional Costs', '${extras.toStringAsFixed(1)}%'),
          const SizedBox(height: 12),
          if (agreement > 0 && extras > 15)
            const Text('⚠️ Extra costs are significant. Check the builder quotation carefully.', style: TextStyle(fontWeight: FontWeight.w600))
          else if (agreement > 0)
            const Text('✅ This is a quick estimate. Verify every charge before paying.', style: TextStyle(fontWeight: FontWeight.w600)),
        ]))),
        const SizedBox(height: 12),
        const Text('FlatCheck V1 • Estimates only. Actual GST, stamp duty and registration can vary by property and buyer circumstances.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
    );
  }

  Widget _field(String label, TextEditingController c) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(controller: c, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: label, border: const OutlineInputBorder())),
      );

  Widget _result(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(label)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]),
      );
}
