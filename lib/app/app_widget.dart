import 'package:escala_adventista/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('pt'), //! Tornar isso dinâmico com bloc/clubit
      title: AppLocalizations.of(context)!.title,
      // theme: mainTheme(context),
      // locale: TranslationProvider.of(context).flutterLocale, // use provider
      // builder: InterceptorConfig.instance,
      routerConfig: router,
    );
  }
}
