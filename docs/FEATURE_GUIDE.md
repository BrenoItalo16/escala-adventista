# Guia de Criação de Features

Este guia fornece um passo a passo detalhado sobre como criar uma nova feature completa no projeto Escala Adventista, seguindo as melhores práticas e padrões estabelecidos.

## Índice
- [1. Estrutura de Diretórios](#1-estrutura-de-diretórios)
- [2. Configuração de Dependências](#2-configuração-de-dependências)
- [3. Implementação da Feature](#3-implementação-da-feature)
- [4. Configuração de Rotas](#4-configuração-de-rotas)
- [5. Gerenciamento de Estado com BLoC](#5-gerenciamento-de-estado-com-bloc)
- [6. Injeção de Dependências](#6-injeção-de-dependências)
- [7. Persistência de Dados](#7-persistência-de-dados)
- [8. Testes](#8-testes)
- [9. Internacionalização (i18n)](#9-internacionalização-i18n)
- [10. Tratamento de Erros](#10-tratamento-de-erros)
- [11. Design System](#11-design-system)
- [12. Boas Práticas](#12-boas-práticas)
- [13. Segurança](#13-segurança)
- [14. Performance](#14-performance)
- [15. Recursos Úteis](#15-recursos-úteis)

## 1. Estrutura de Diretórios

Para criar uma nova feature, siga esta estrutura de diretórios:

```
lib/
└── features/
    └── sua_feature/
        ├── data/
        │   ├── datasources/
        │   │   ├── local/
        │   │   └── remote/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── usecases/
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/
```

## 2. Configuração de Dependências

1. Adicione as dependências necessárias no `pubspec.yaml`:
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4
  shared_preferences: ^2.2.2
```

2. Execute o comando para atualizar as dependências:
```bash
flutter pub get
```

## 3. Implementação da Feature

### 3.1 Criando a Entidade
```dart
// lib/features/sua_feature/domain/entities/sua_entidade.dart
class SuaEntidade {
  final String id;
  final String nome;

  SuaEntidade({required this.id, required this.nome});
}
```

### 3.2 Criando o Modelo
```dart
// lib/features/sua_feature/data/models/sua_modelo.dart
class SeuModelo extends SuaEntidade {
  SeuModelo({required String id, required String nome})
      : super(id: id, nome: nome);

  factory SeuModelo.fromJson(Map<String, dynamic> json) {
    return SeuModelo(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
```

## 4. Configuração de Rotas

1. Adicione a constante da rota em `lib/route/app_routes.dart`:
```dart
class AppRoutes {
  static const String suaFeature = '/sua-feature';
}
```

2. Registre a rota em `lib/route/routes.dart`:
```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.suaFeature,
      builder: (context, state) => const SuaFeaturePage(),
    ),
  ],
);
```

## 5. Gerenciamento de Estado com BLoC

### 5.1 Eventos
```dart
// lib/features/sua_feature/presentation/bloc/sua_feature_event.dart
abstract class SuaFeatureEvent {}

class CarregarDadosEvent extends SuaFeatureEvent {}
```

### 5.2 Estados
```dart
// lib/features/sua_feature/presentation/bloc/sua_feature_state.dart
abstract class SuaFeatureState {}

class CarregandoState extends SuaFeatureState {}
class DadosCarregadosState extends SuaFeatureState {}
class ErroState extends SuaFeatureState {}
```

### 5.3 BLoC
```dart
// lib/features/sua_feature/presentation/bloc/sua_feature_bloc.dart
class SuaFeatureBloc extends Bloc<SuaFeatureEvent, SuaFeatureState> {
  final SeuUseCase useCase;

  SuaFeatureBloc({required this.useCase}) : super(CarregandoState()) {
    on<CarregarDadosEvent>(_onCarregarDados);
  }

  Future<void> _onCarregarDados(
    CarregarDadosEvent event,
    Emitter<SuaFeatureState> emit,
  ) async {
    emit(CarregandoState());
    try {
      final resultado = await useCase.execute();
      emit(DadosCarregadosState());
    } catch (e) {
      emit(ErroState());
    }
  }
}
```

## 6. Injeção de Dependências

Adicione a configuração no `lib/injection_container.dart`:

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // Feature
  sl.registerFactory(() => SuaFeatureBloc(useCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => SeuUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<SeuRepository>(
    () => SeuRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sharedPreferences: sl()),
  );
}
```

## 7. Persistência de Dados

### 7.1 SharedPreferences
```dart
// lib/features/sua_feature/data/datasources/local/local_datasource.dart
class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  Future<void> salvarDados(String chave, String valor) async {
    await sharedPreferences.setString(chave, valor);
  }

  String? obterDados(String chave) {
    return sharedPreferences.getString(chave);
  }
}
```

## 8. Testes

### 8.1 Testes Unitários
```dart
// test/features/sua_feature/domain/usecases/seu_usecase_test.dart
void main() {
  late SeuUseCase useCase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    useCase = SeuUseCase(repository: mockRepository);
  });

  test('deve retornar dados quando chamado com sucesso', () async {
    // arrange
    when(mockRepository.getDados())
        .thenAnswer((_) async => Right(TestData.dados));

    // act
    final result = await useCase.execute();

    // assert
    expect(result, Right(TestData.dados));
    verify(mockRepository.getDados()).called(1);
  });
}
```

### 8.2 Testes de Widget
```dart
// test/features/sua_feature/presentation/pages/sua_page_test.dart
void main() {
  testWidgets('deve mostrar loading quando estado for CarregandoState',
      (WidgetTester tester) async {
    // arrange
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockBloc,
          child: SuaFeaturePage(),
        ),
      ),
    );

    // act
    whenListen(
      mockBloc,
      Stream.fromIterable([CarregandoState()]),
      initialState: CarregandoState(),
    );

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

## 9. Internacionalização (i18n)

### 9.1 Adicionando Novas Strings
```dart
// lib/l10n/app_en.arb
{
  "suaFeatureTitle": "Your Feature Title",
  "@suaFeatureTitle": {
    "description": "Title displayed in the feature screen"
  }
}

// lib/l10n/app_pt.arb
{
  "suaFeatureTitle": "Título da Sua Feature"
}
```

### 9.2 Usando Strings Traduzidas
```dart
Text(AppLocalizations.of(context)!.suaFeatureTitle)
```

## 10. Tratamento de Erros

### 10.1 Definindo Erros
```dart
// lib/core/error/failures.dart
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class SuaFeatureFailure extends Failure {
  const SuaFeatureFailure(String message) : super(message);
}
```

### 10.2 Implementando Either
```dart
// lib/features/sua_feature/domain/repositories/repository.dart
Future<Either<Failure, SuaEntidade>> getDados();

// Implementação
@override
Future<Either<Failure, SuaEntidade>> getDados() async {
  try {
    final result = await dataSource.getDados();
    return Right(result);
  } catch (e) {
    return Left(SuaFeatureFailure(e.toString()));
  }
}
```

## 11. Design System

### 11.1 Utilizando Componentes do Design System
```dart
// lib/features/sua_feature/presentation/pages/sua_feature_page.dart
class SuaFeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DSAppBar(
        title: Text(AppLocalizations.of(context)!.suaFeatureTitle),
      ),
      body: Column(
        children: [
          DSButton(
            onPressed: () {},
            text: 'Botão Padrão',
          ),
          DSTextField(
            controller: textController,
            label: 'Campo de Texto',
          ),
        ],
      ),
    );
  }
}
```

## 12. Boas Práticas

### 12.1 Nomenclatura
- **Classes**: PascalCase (ex: `SuaFeatureBloc`)
- **Variáveis e Métodos**: camelCase (ex: `getDados()`)
- **Constantes**: SCREAMING_SNAKE_CASE (ex: `API_BASE_URL`)
- **Arquivos**: snake_case (ex: `sua_feature_page.dart`)

### 12.2 Organização de Imports
```dart
// Dart imports
import 'dart:async';
import 'dart:convert';

// Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// Project imports
import 'package:escala_adventista/core/...';
import 'package:escala_adventista/features/...';
```

### 12.3 Documentação
```dart
/// Uma classe que representa...
///
/// Use esta classe quando precisar...
///
/// Example:
/// ```dart
/// final instance = SuaClasse();
/// await instance.metodo();
/// ```
class SuaClasse {
  /// Retorna um [Future] que completa com...
  ///
  /// Throws [SuaException] se...
  Future<void> metodo() async {
    // implementação
  }
}
```

## 13. Segurança

### 13.1 Armazenamento Seguro
```dart
// Usando flutter_secure_storage para dados sensíveis
final storage = FlutterSecureStorage();
await storage.write(key: 'token', value: 'seu_token');
```

### 13.2 Validação de Entrada
```dart
String? validateInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Campo obrigatório';
  }
  if (value.length < 6) {
    return 'Mínimo de 6 caracteres';
  }
  return null;
}
```

## 14. Performance

### 14.1 Otimizações
- Use `const` para widgets estáticos
- Implemente `equatable` para comparações eficientes
- Utilize `ListView.builder` para listas longas
- Cache imagens e dados quando apropriado

### 14.2 Exemplo de Widget Otimizado
```dart
class SeuWidget extends StatelessWidget {
  const SeuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return const SeuItemWidget();
      },
    );
  }
}
```

## 15. Recursos Úteis

- [Design System do Projeto](link_para_design_system)
- [Guia de Estilo Dart](https://dart.dev/guides/language/effective-dart/style)
- [Padrões Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/#/gettingstarted)
