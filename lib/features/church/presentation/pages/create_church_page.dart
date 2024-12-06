import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/church.dart';
import '../../domain/repositories/church_repository.dart';

class CreateChurchPage extends StatefulWidget {
  const CreateChurchPage({super.key});

  @override
  State<CreateChurchPage> createState() => _CreateChurchPageState();
}

class _CreateChurchPageState extends State<CreateChurchPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _streetController = TextEditingController();
  final _stateController = TextEditingController();
  final _numberController = TextEditingController();
  late final ChurchRepository _repository;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _repository = GetIt.instance<ChurchRepository>();
  }

  Future<void> _createChurch() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final church = Church(
        name: _nameController.text,
        city: _cityController.text,
        neighborhood: _neighborhoodController.text,
        street: _streetController.text,
        state: _stateController.text,
        number: _numberController.text,
        ownerId: currentUser.uid,
      );

      await _repository.createChurch(church);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Igreja criada com sucesso!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar igreja: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    _streetController.dispose();
    _stateController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar igreja'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppInputText(
                    controller: _nameController,
                    label: 'Nome da Igreja',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  AppInputText(
                    controller: _cityController,
                    label: 'Cidade',
                    type: InputType.city,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  AppInputText(
                    controller: _streetController,
                    label: 'Logradouro',
                    type: InputType.address,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  AppInputText(
                    controller: _numberController,
                    label: 'Número',
                    type: InputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  AppInputText(
                    controller: _stateController,
                    label: 'Estado',
                    type: InputType.state,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  AppInputText(
                    controller: _neighborhoodController,
                    label: 'Bairro',
                    type: InputType.neighborhood,
                    onChanged: (_) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o bairro';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: AppButton(
                onPressed: _isLoading ? null : _createChurch,
                isLoading: _isLoading,
                text: 'Criar igreja',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
