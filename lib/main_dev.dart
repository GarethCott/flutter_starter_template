import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/config/flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor configuration
  FlavorConfig.initialize(Flavor.dev);

  // Initialize app configuration
  await AppConfig.initialize();

  // Print configuration summary for development
  AppConfig.instance.printConfigSummary();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
