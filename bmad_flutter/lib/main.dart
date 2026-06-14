import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/state/museum_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider<MuseumState>(
      create: (_) => MuseumState(),
      child: const MuseumApp(),
    ),
  );
}
