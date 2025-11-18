import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';
import '../models/user_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _crmCorenController = TextEditingController();
  
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();
  
  // Preferências
  String _selectedLanguage = 'Português (Brasil)';
  String _fontSize = 'Pequeno (90%)';
  bool _darkMode = false;
  bool _highContrast = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadPreferences();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    try {
      // Usar sempre DatabaseHelper (persistência local SQLite)
      final profile = await DatabaseHelper.instance.getUserProfile();
      if (profile != null) {
        setState(() {
          _profile = profile;
          _nameController.text = profile.name;
          _emailController.text = profile.email;
          _specialtyController.text = profile.specialty ?? '';
          _crmCorenController.text = profile.crmCoren ?? '';
          _profileImagePath = profile.profileImagePath;
        });
      } else {
        // Criar perfil padrão e salvar no DB local
        _profile = UserProfile(
          name: 'Pedro Tescaro',
          email: 'pedroatescaro@gmail.com',
          specialty: 'Especialista em Feridas',
          crmCoren: '123456-SP',
        );
        await DatabaseHelper.instance.insertUserProfile(_profile!);
        // Recarregar para obter o id atribuído pelo DB
        final saved = await DatabaseHelper.instance.getUserProfile();
        if (saved != null) {
          setState(() {
            _profile = saved;
            _nameController.text = _profile!.name;
            _emailController.text = _profile!.email;
            _specialtyController.text = _profile!.specialty ?? '';
            _crmCorenController.text = _profile!.crmCoren ?? '';
            _profileImagePath = _profile!.profileImagePath;
          });
        } else {
          setState(() {
            _nameController.text = _profile!.name;
            _emailController.text = _profile!.email;
            _specialtyController.text = _profile!.specialty ?? '';
            _crmCorenController.text = _profile!.crmCoren ?? '';
          });
        }
      }
    } catch (e) {
      // Se algo falhar (ex: banco não disponível no web), criar perfil padrão localmente
      _profile = UserProfile(
        name: 'Pedro Tescaro',
        email: 'pedroatescaro@gmail.com',
        specialty: 'Especialista em Feridas',
        crmCoren: '123456-SP',
      );
      setState(() {
        _nameController.text = _profile!.name;
        _emailController.text = _profile!.email;
        _specialtyController.text = _profile!.specialty ?? '';
        _crmCorenController.text = _profile!.crmCoren ?? '';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPreferences() async {
    // Carregar preferências do SharedPreferences se necessário
    // Por enquanto, usar valores padrão
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar foto'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        _profileImagePath = image.path;
                      });
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao tirar foto: $e')),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Escolher da galeria'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _profileImagePath = image.path;
                      });
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao selecionar imagem: $e')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome e email são obrigatórios')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updatedProfile = _profile!.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      specialty: _specialtyController.text.isEmpty ? null : _specialtyController.text,
      crmCoren: _crmCorenController.text.isEmpty ? null : _crmCorenController.text,
      profileImagePath: _profileImagePath,
    );

    try {
      // Salvar no banco local sempre (SQLite)
      if (updatedProfile.id != null) {
        await DatabaseHelper.instance.updateUserProfile(updatedProfile);
        setState(() {
          _profile = updatedProfile;
          _isSaving = false;
        });
      } else {
        await DatabaseHelper.instance.insertUserProfile(updatedProfile);
        final saved = await DatabaseHelper.instance.getUserProfile();
        if (saved != null) {
          setState(() {
            _profile = saved;
            _isSaving = false;
            _profileImagePath = _profile!.profileImagePath;
          });
        } else {
          setState(() {
            _profile = updatedProfile;
            _isSaving = false;
          });
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil salvo com sucesso!')),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _specialtyController.dispose();
    _crmCorenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
          tooltip: 'Voltar',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 32),
            _buildPreferencesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perfil do Usuário',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mantenha suas informações profissionais atualizadas.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                    backgroundImage: _profileImagePath != null && !kIsWeb
                        ? FileImage(File(_profileImagePath!))
                        : null,
                    child: _profileImagePath == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: AppTheme.primaryBlue,
                          )
                        : (kIsWeb
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: AppTheme.primaryBlue,
                              )
                            : null),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.primaryBlue,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: _pickImage,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: _pickImage,
                child: const Text('Mudar foto de perfil'),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _specialtyController,
              decoration: const InputDecoration(
                labelText: 'Especialidade',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _crmCorenController,
              decoration: const InputDecoration(
                labelText: 'CRM/COREN',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Salvar Alterações'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferências',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Personalize a aparência e o idioma do aplicativo.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Idioma',
              ),
              initialValue: _selectedLanguage,
              items: ['Português (Brasil)', 'English', 'Español']
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tamanho da Fonte',
              ),
              initialValue: _fontSize,
              items: ['Pequeno (90%)', 'Médio (100%)', 'Grande (110%)', 'Muito Grande (120%)']
                  .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _fontSize = value);
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Modo Escuro'),
              value: _darkMode,
              onChanged: (value) {
                setState(() => _darkMode = value);
                // Implementar mudança de tema
              },
            ),
            SwitchListTile(
              title: const Text('Alto Contraste'),
              value: _highContrast,
              onChanged: (value) {
                setState(() => _highContrast = value);
                // Implementar alto contraste
              },
            ),
          ],
        ),
      ),
    );
  }
}

