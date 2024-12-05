import 'package:design_system/design_system.dart';
import 'package:escala_adventista/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uicons/uicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
    // Request authentication status check when page is initialized
    context.read<AuthBloc>().add(AuthenticationStatusRequested());
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
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
            context.go('/login');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthAuthenticated) {
                          return CustomAppBar(
                            title: state.user.name,
                          );
                        }
                        return const CustomAppBar();
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Ainda não tem uma igreja?',
                      style: AppFont.bodyL16Regular,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.inputBg,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crie uma igreja',
                              style: AppFont.titleM24BoldBalow,
                            ),
                            SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  UIcons.regularRounded.info,
                                  size: 12,
                                  color: TxtColors.support,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Antes de criar uma igreja no ',
                                          style: AppFont.bodyS12XLight,
                                        ),
                                        TextSpan(
                                          text: 'Escala Adventista',
                                          style: AppFont.bodyS12Bold,
                                        ),
                                        TextSpan(
                                          text:
                                              ', consulte a diretoria da sua congregação para confirmar se já existe uma igreja criada em nosso app.',
                                          style: AppFont.bodyS12XLight,
                                        ),
                                      ],
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                child: AppIconButton(
                                  width: 72,
                                  height: 72,
                                  radious: 16,
                                  icon: UIcons.regularRounded.plus,
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    //! Buscar Músicas
                    Expanded(
                      child: AppInputSearch(),
                    ),
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
