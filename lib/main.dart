import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/meta_store.dart';
import 'widgets/metas_page.dart';

void main() {
  runApp(const PlannerApp());
}

class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MetaStore(),
      child: MaterialApp(
        title: 'Planner Virtual',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF4F46E5),
        ),
        debugShowCheckedModeBanner: false,
        home: const MetasPage(),
      ),
    );
  }
}
