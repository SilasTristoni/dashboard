import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard Responsivo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final List<DashboardCard> cards = const [
      DashboardCard(titulo: 'Vendas', valor: 'R\$ 5.000', icone: Icons.shopping_cart, cor: Colors.blue),
      DashboardCard(titulo: 'Usuários', valor: '1.234', icone: Icons.people, cor: Colors.green),
      DashboardCard(titulo: 'Lucro', valor: 'R\$ 2.150', icone: Icons.monetization_on, cor: Colors.orange),
      DashboardCard(titulo: 'Alertas', valor: '12', icone: Icons.warning, cor: Colors.red),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Responsivo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildLayout(width, cards),
      ),
    );
  }

  Widget _buildLayout(double width, List<DashboardCard> cards) {
    if (width < 600) {
      // Mobile
      return ListView(
        children: cards.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: c,
        )).toList(),
      );
    } else if (width < 900) {
      // Tablet
      return SingleChildScrollView(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards.map((c) => SizedBox(
            width: (width / 2) - 24,
            child: c,
          )).toList(),
        ),
      );
    } else {
      // Desktop
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Impede esticamento vertical
        children: cards.map((c) => Expanded(
          child: Padding(
            // Adiciona espaço entre os cards, exceto no último
            padding: EdgeInsets.only(right: c == cards.last ? 0 : 16.0),
            child: c,
          )
        )).toList(),
      );
    }
  }
}

class DashboardCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color cor;

  const DashboardCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // O segredo para não esticar verticalmente
          children: [
            Icon(icone, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(valor, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}