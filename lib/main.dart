import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'state/meta_store.dart';
import 'state/tarefa_store.dart';
import 'state/reminder_store.dart';
import 'widgets/metas_page.dart';
import 'screens/relatorio_page.dart';
import 'screens/reminders_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
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
        ChangeNotifierProvider(create: (_) => ReminderStore()),
      ],
      child: MaterialApp(
        title: 'Planner Virtual',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MetasPage(),
    const RelatorioPage(),
    const RemindersPage(),
  ];

  final List<String> _titles = ['Mark Day Planner', 'Relatórios', 'Lembretes'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MetaStore>().seedMockData();
      context.read<TarefaStore>().seedMockData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            label: 'Metas',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),
          NavigationDestination(icon: Icon(Icons.alarm), label: 'Lembretes'),
        ],
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
