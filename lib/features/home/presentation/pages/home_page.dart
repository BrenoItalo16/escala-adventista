import 'package:design_system/design_system.dart';
import 'package:escala_adventista/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:escala_adventista/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaml/yaml.dart';
import '../../../../injection_container.dart';
import '../bloc/song_search_bloc.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthenticationStatusRequested());
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      // final yamlString = await rootBundle.loadString('pubspec.yaml');
      final yamlString = await rootBundle.loadString('../pubspec.yaml');
      final yaml = loadYaml(yamlString);
      setState(() {
        _version = yaml['version'].toString().split('+')[0];
      });
    } catch (e) {
      setState(() {
        _version = '1.0.0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SongSearchBloc>(),
        ),
        BlocProvider(
          create: (context) {
            final bloc = sl<HomeBloc>();
            // Carrega os dados da home após a criação do bloc
            bloc.add(const LoadHomeData());
            return bloc;
          },
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go(AppRoutes.login);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SingleChildScrollView(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    // if (state is AuthAuthenticated) {
                    if (state is AuthUnauthenticated) {
                      return CustomAppBar(
                        title: 'Visitante',
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomAppBar(),
                        const SizedBox(height: 24),
                        Text(
                          'Ainda não tem uma igreja?',
                          style: AppFont.bodyL16Regular,
                        ),
                        SizedBox(height: 12),
                        AppSectionButton(
                          onTap: () {
                            context.go(AppRoutes.createChurch);
                          },
                        ),
                        SizedBox(height: 24),
                        //!Corrigir erro de tela

                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            'Versão $_version',
                            style: AppFont.bodyL16Regular.copyWith(
                              color: TxtColors.support,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
