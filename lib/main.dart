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
      // TEMA CLARO
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // TEMA ESCURO (Adapta-se ao sistema do utilizador)
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system, 
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _indiceSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    // Lista de cartões com os dados
    final List<DashboardCard> cards = [
      const DashboardCard(
        titulo: 'Vendas',
        valor: 'R\$ 5.000',
        icone: Icons.shopping_cart,
        cor: Colors.blue,
        temGrafico: true, // Ativa o gráfico de barras extra neste card
      ),
      const DashboardCard(titulo: 'Usuários', valor: '1.234', icone: Icons.people, cor: Colors.green),
      const DashboardCard(titulo: 'Lucro', valor: 'R\$ 2.150', icone: Icons.monetization_on, cor: Colors.orange),
      const DashboardCard(titulo: 'Alertas', valor: '12', icone: Icons.warning, cor: Colors.red),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Responsivo')),
      
      // BÓNUS: Menu Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu do Dashboard', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Visão Geral'),
              onTap: () => Navigator.pop(context), // Fecha o drawer
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      
      // BÓNUS: Bottom Navigation (aparece apenas em ecrãs com menos de 600px)
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? BottomNavigationBar(
              currentIndex: _indiceSelecionado,
              onTap: (index) => setState(() => _indiceSelecionado = index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
                BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Relatórios'),
              ],
            )
          : null,
          
      // BÓNUS EXTRA: Puxar para atualizar (RefreshIndicator)
      body: RefreshIndicator(
        onRefresh: () async {
          // Simula um tempo de carregamento de 1.5 segundos
          await Future.delayed(const Duration(milliseconds: 1500));
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dados do dashboard atualizados!')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // BÓNUS: Controlo de Orientação
          child: OrientationBuilder(
            builder: (context, orientation) {
              // BÓNUS: LayoutBuilder para componentização avançada
              return LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final isPortrait = orientation == Orientation.portrait;

                  Widget layoutAtual;

                  // Lógica condicional: Largura + Orientação
                  if (width < 600 && isPortrait) {
                    layoutAtual = _buildMobileLayout(cards);
                  } else if (width < 900 || (width < 600 && !isPortrait)) {
                    layoutAtual = _buildTabletLayout(width, cards);
                  } else {
                    layoutAtual = _buildDesktopLayout(cards);
                  }

                  // BÓNUS: Animações de transição
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: layoutAtual,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Layouts
  Widget _buildMobileLayout(List<DashboardCard> cards) {
    return ListView(
      key: const ValueKey('layout_mobile'),
      children: cards.map((c) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: c,
      )).toList(),
    );
  }

  Widget _buildTabletLayout(double width, List<DashboardCard> cards) {
    return SingleChildScrollView(
      key: const ValueKey('layout_tablet'),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: cards.map((c) => SizedBox(
          width: (width - 16) / 2,
          child: c,
        )).toList(),
      ),
    );
  }

  Widget _buildDesktopLayout(List<DashboardCard> cards) {
    return Row(
      key: const ValueKey('layout_desktop'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cards.map((c) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: c == cards.last ? 0 : 16.0),
          child: c,
        )
      )).toList(),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color cor;
  final bool temGrafico;

  const DashboardCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.cor,
    this.temGrafico = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // BÓNUS EXTRA: Efeito de clique e feedback visual (InkWell)
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('A carregar detalhes de $titulo...'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Círculo decorativo de fundo
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icone, size: 40, color: Colors.white),
                      if (temGrafico) _buildGraficoSimples(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(valor, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BÓNUS: Gráfico Simples usando Stack e Positioned
  Widget _buildGraficoSimples() {
    return SizedBox(
      height: 40,
      width: 60,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned(left: 0, bottom: 0, child: Container(width: 10, height: 15, color: Colors.white70)),
          Positioned(left: 15, bottom: 0, child: Container(width: 10, height: 30, color: Colors.white)),
          Positioned(left: 30, bottom: 0, child: Container(width: 10, height: 20, color: Colors.white70)),
          Positioned(left: 45, bottom: 0, child: Container(width: 10, height: 40, color: Colors.white)),
        ],
      ),
    );
  }
}