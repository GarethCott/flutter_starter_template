import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/config/flavor_config.dart';

/// Default main entry point - uses development configuration
void main() async {
  // Initialize flavor configuration for development
  FlavorConfig.initialize(Flavor.dev);

  // Initialize app configuration
  await AppConfig.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
