import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/relatorio_page.dart';
import 'state/meta_store.dart';
import 'state/tarefa_store.dart';
import 'widgets/metas_page.dart';

void main() {
  runApp(const PlannerApp());
}

class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MetaStore()),
        ChangeNotifierProvider(create: (_) => TarefaStore()),
      ],
      child: MaterialApp(
        title: 'Planner Virtual',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF4F46E5),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const MetasPage(), const RelatorioPage()];
  final List<String> _titles = ['Suas Metas', 'Relatórios'];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<MetaStore>().seedMockData();
      context.read<TarefaStore>().seedMockData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Metas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Relatórios',
          ),
        ],
      ),
    );
  }
}
