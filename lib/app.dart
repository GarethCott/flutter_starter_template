import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'routing/app_router.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = AppConfig.instance;
    final themeMode = ref.watch(themeModeNotifierProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: config.fullAppName,
      debugShowCheckedModeBanner: config.enableDebugBanner,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
