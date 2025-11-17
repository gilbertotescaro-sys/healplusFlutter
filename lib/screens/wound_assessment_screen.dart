import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';
import '../models/wound_assessment.dart';
import '../widgets/body_map_widget.dart';
import '../widgets/timer_widget.dart';

class WoundAssessmentScreen extends StatefulWidget {
  final String? woundId;

  const WoundAssessmentScreen({super.key, this.woundId});

  @override
  State<WoundAssessmentScreen> createState() => _WoundAssessmentScreenState();
}

class _WoundAssessmentScreenState extends State<WoundAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;
  
  WoundAssessment? _assessment;
  bool _isLoading = true;
  String? _woundImagePath;
  final ImagePicker _picker = ImagePicker();
  
  // Controllers para campos de texto
  final Map<String, TextEditingController> _controllers = {};
  
  // Valores dos campos
  DateTime? _birthDate;
  DateTime? _consultationDate;
  TimeOfDay? _consultationTime;
  DateTime? _returnDate;
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.woundId != null) {
      _loadAssessment();
    } else {
      _assessment = WoundAssessment(patientName: '');
      _isLoading = false;
    }
  }

  void _initializeControllers() {
    _controllers['patientName'] = TextEditingController();
    _controllers['phone'] = TextEditingController();
    _controllers['email'] = TextEditingController();
    _controllers['profession'] = TextEditingController();
    _controllers['width'] = TextEditingController();
    _controllers['length'] = TextEditingController();
    _controllers['depth'] = TextEditingController();
    _controllers['evolutionTime'] = TextEditingController();
    _controllers['etiology'] = TextEditingController();
    _controllers['painReliefFactors'] = TextEditingController();
    _controllers['painWorseningFactors'] = TextEditingController();
    _controllers['tunnelLocation'] = TextEditingController();
    _controllers['observations'] = TextEditingController();
    _controllers['treatmentPlan'] = TextEditingController();
    _controllers['professionalName'] = TextEditingController();
    _controllers['professionalCorenCrm'] = TextEditingController();
    _controllers['allergies'] = TextEditingController();
    _controllers['surgeriesDetails'] = TextEditingController();
    _controllers['peripheralPulses'] = TextEditingController();
  }

  Future<void> _loadAssessment() async {
    setState(() => _isLoading = true);
    final assessment = await DatabaseHelper.instance.getWoundAssessment(widget.woundId!);
    if (assessment != null) {
      setState(() {
        _assessment = assessment;
        _woundImagePath = assessment.woundImagePath;
        _controllers['patientName']!.text = assessment.patientName;
        _controllers['phone']!.text = assessment.phone ?? '';
        _controllers['email']!.text = assessment.email ?? '';
        _controllers['profession']!.text = assessment.profession ?? '';
        _controllers['width']!.text = assessment.width?.toString() ?? '';
        _controllers['length']!.text = assessment.length?.toString() ?? '';
        _controllers['depth']!.text = assessment.depth?.toString() ?? '';
        _controllers['evolutionTime']!.text = assessment.evolutionTime ?? '';
        _controllers['etiology']!.text = assessment.etiology ?? '';
        _controllers['painReliefFactors']!.text = assessment.painReliefFactors ?? '';
        _controllers['painWorseningFactors']!.text = assessment.painWorseningFactors ?? '';
        _controllers['tunnelLocation']!.text = assessment.tunnelLocation ?? '';
        _controllers['observations']!.text = assessment.observations ?? '';
        _controllers['treatmentPlan']!.text = assessment.treatmentPlan ?? '';
        _controllers['professionalName']!.text = assessment.professionalName ?? '';
        _controllers['professionalCorenCrm']!.text = assessment.professionalCorenCrm ?? '';
        _controllers['allergies']!.text = assessment.allergies ?? '';
        _controllers['surgeriesDetails']!.text = assessment.surgeriesDetails ?? '';
        _controllers['peripheralPulses']!.text = assessment.peripheralPulses ?? '';
        
        if (assessment.birthDate != null) {
          _birthDate = DateTime.tryParse(assessment.birthDate!);
        }
        if (assessment.consultationDate != null) {
          _consultationDate = DateTime.tryParse(assessment.consultationDate!);
        }
        if (assessment.consultationTime != null) {
          final timeParts = assessment.consultationTime!.split(':');
          if (timeParts.length == 2) {
            _consultationTime = TimeOfDay(
              hour: int.tryParse(timeParts[0]) ?? 0,
              minute: int.tryParse(timeParts[1]) ?? 0,
            );
          }
        }
        if (assessment.returnDate != null) {
          _returnDate = DateTime.tryParse(assessment.returnDate!);
        }
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _woundImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagem: $e')),
      );
    }
  }

  Future<void> _saveAssessment() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios')),
      );
      return;
    }

    final updatedAssessment = _assessment!.copyWith(
      patientName: _controllers['patientName']!.text,
      birthDate: _birthDate?.toIso8601String(),
      phone: _controllers['phone']!.text.isEmpty ? null : _controllers['phone']!.text,
      email: _controllers['email']!.text.isEmpty ? null : _controllers['email']!.text,
      profession: _controllers['profession']!.text.isEmpty ? null : _controllers['profession']!.text,
      woundImagePath: _woundImagePath,
      width: double.tryParse(_controllers['width']!.text),
      length: double.tryParse(_controllers['length']!.text),
      depth: double.tryParse(_controllers['depth']!.text),
      evolutionTime: _controllers['evolutionTime']!.text.isEmpty ? null : _controllers['evolutionTime']!.text,
      etiology: _controllers['etiology']!.text.isEmpty ? null : _controllers['etiology']!.text,
      painReliefFactors: _controllers['painReliefFactors']!.text.isEmpty ? null : _controllers['painReliefFactors']!.text,
      painWorseningFactors: _controllers['painWorseningFactors']!.text.isEmpty ? null : _controllers['painWorseningFactors']!.text,
      tunnelLocation: _controllers['tunnelLocation']!.text.isEmpty ? null : _controllers['tunnelLocation']!.text,
      observations: _controllers['observations']!.text.isEmpty ? null : _controllers['observations']!.text,
      treatmentPlan: _controllers['treatmentPlan']!.text.isEmpty ? null : _controllers['treatmentPlan']!.text,
      professionalName: _controllers['professionalName']!.text.isEmpty ? null : _controllers['professionalName']!.text,
      professionalCorenCrm: _controllers['professionalCorenCrm']!.text.isEmpty ? null : _controllers['professionalCorenCrm']!.text,
      consultationDate: _consultationDate?.toIso8601String(),
      consultationTime: _consultationTime != null 
          ? '${_consultationTime!.hour.toString().padLeft(2, '0')}:${_consultationTime!.minute.toString().padLeft(2, '0')}'
          : null,
      returnDate: _returnDate?.toIso8601String(),
      allergies: _controllers['allergies']!.text.isEmpty ? null : _controllers['allergies']!.text,
      surgeriesDetails: _controllers['surgeriesDetails']!.text.isEmpty ? null : _controllers['surgeriesDetails']!.text,
      peripheralPulses: _controllers['peripheralPulses']!.text.isEmpty ? null : _controllers['peripheralPulses']!.text,
    );

    try {
      String assessmentId;
      if (widget.woundId != null) {
        await DatabaseHelper.instance.updateWoundAssessment(updatedAssessment);
        assessmentId = updatedAssessment.id;
      } else {
        assessmentId = await DatabaseHelper.instance.insertWoundAssessment(updatedAssessment);
      }
      setState(() {
        _assessment = updatedAssessment;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avaliação salva com sucesso!')),
        );
        // Atualizar o timer widget se necessário
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
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
        title: Text(widget.woundId != null ? 'Editar Avaliação' : 'Nova Avaliação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAssessment,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildPersonalDataSection(),
                  _buildTissueSection(),
                  _buildInfectionSection(),
                  _buildMoistureSection(),
                  _buildEdgeSection(),
                  _buildRepairSection(),
                  _buildSocialSection(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    const totalPages = 7;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: List.generate(totalPages, (index) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 4,
                  decoration: BoxDecoration(
                    color: index <= _currentPage
                        ? AppTheme.primaryBlue
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'Página ${_currentPage + 1} de $totalPages',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDataSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dados Pessoais',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _controllers['patientName'],
            decoration: const InputDecoration(
              labelText: 'Nome Completo *',
              hintText: 'Digite o nome completo',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nome é obrigatório';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _birthDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() => _birthDate = date);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                _birthDate != null
                    ? DateFormat('dd/MM/yyyy').format(_birthDate!)
                    : 'Selecione a data',
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controllers['phone'],
            decoration: const InputDecoration(
              labelText: 'Telefone',
              hintText: '(00) 00000-0000',
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controllers['email'],
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'email@exemplo.com',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controllers['profession'],
            decoration: const InputDecoration(
              labelText: 'Profissão',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Estado Civil',
            ),
            items: ['Solteiro(a)', 'Casado(a)', 'Divorciado(a)', 'Viúvo(a)', 'União Estável']
                .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                .toList(),
            onChanged: (value) {
              // Salvar no assessment
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Imagem da Ferida',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (_woundImagePath != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_woundImagePath!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => setState(() => _woundImagePath = null),
                  ),
                ),
              ],
            )
          else
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Adicionar Imagem'),
            ),
        ],
      ),
    );
  }

  Widget _buildTissueSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'T - Tecido',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Dimensões e Características Gerais',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controllers['width'],
                  decoration: const InputDecoration(
                    labelText: 'Largura (cm)',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _controllers['length'],
                  decoration: const InputDecoration(
                    labelText: 'Comprimento (cm)',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controllers['depth'],
            decoration: const InputDecoration(
              labelText: 'Profundidade (cm)',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          const Text(
            'Localização',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          BodyMapWidget(
            onLocationSelected: (location) {
              setState(() {
                _assessment = _assessment?.copyWith(location: location);
              });
            },
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _controllers['evolutionTime'],
            decoration: const InputDecoration(
              labelText: 'Tempo de Evolução',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controllers['etiology'],
            decoration: const InputDecoration(
              labelText: 'Etiologia',
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Lesão por Pressão'),
            value: _assessment?.pressureInjury ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(pressureInjury: value);
              });
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Avaliação do Leito da Ferida',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildTissuePercentageSlider('Granulação', _assessment?.granulationPercent ?? 0, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(granulationPercent: value);
            });
          }),
          const SizedBox(height: 16),
          _buildTissuePercentageSlider('Epitelização', _assessment?.epithelializationPercent ?? 0, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(epithelializationPercent: value);
            });
          }),
          const SizedBox(height: 16),
          _buildTissuePercentageSlider('Esfacelo', _assessment?.escharPercent ?? 0, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(escharPercent: value);
            });
          }),
          const SizedBox(height: 16),
          _buildTissuePercentageSlider('Necrose Seca', _assessment?.dryNecrosisPercent ?? 0, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(dryNecrosisPercent: value);
            });
          }),
        ],
      ),
    );
  }

  Widget _buildTissuePercentageSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${value.toInt()}%'),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          label: '${value.toInt()}%',
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildInfectionSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'I - Infecção e Inflamação',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Intensidade da Dor (0-10)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildPainIntensitySlider(),
          const SizedBox(height: 24),
          TextFormField(
            controller: _controllers['painReliefFactors'],
            decoration: const InputDecoration(
              labelText: 'Fatores que Aliviam a Dor',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controllers['painWorseningFactors'],
            decoration: const InputDecoration(
              labelText: 'Fatores que Pioram a Dor',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          const Text(
            'Sinais de Inflamação',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildCheckboxListTile('Rubor', _assessment?.inflammationRubor ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(inflammationRubor: value);
            });
          }),
          _buildCheckboxListTile('Calor', _assessment?.inflammationCalor ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(inflammationCalor: value);
            });
          }),
          _buildCheckboxListTile('Edema', _assessment?.inflammationEdema ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(inflammationEdema: value);
            });
          }),
          _buildCheckboxListTile('Dor Local', _assessment?.inflammationPain ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(inflammationPain: value);
            });
          }),
          _buildCheckboxListTile('Perda de Função', _assessment?.inflammationFunctionLoss ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(inflammationFunctionLoss: value);
            });
          }),
          const SizedBox(height: 24),
          const Text(
            'Sinais de Infecção Local',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildCheckboxListTile('Eritema Perilesional', _assessment?.infectionErythema ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(infectionErythema: value);
            });
          }),
          _buildCheckboxListTile('Calor Local', _assessment?.infectionCalor ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(infectionCalor: value);
            });
          }),
          _buildCheckboxListTile('Edema', _assessment?.infectionEdema ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(infectionEdema: value);
            });
          }),
          _buildCheckboxListTile('Dor Local', _assessment?.infectionPain ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(infectionPain: value);
            });
          }),
          _buildCheckboxListTile('Exsudato Purulento', _assessment?.infectionPurulentExudate ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(infectionPurulentExudate: value);
            });
          }),
          _buildCheckboxListTile('Odor Fétido', _assessment?.infectionFetidOdor ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(infectionFetidOdor: value);
            });
          }),
          _buildCheckboxListTile('Retardo na Cicatrização', _assessment?.infectionHealingDelay ?? false, (value) {
            setState(() {
              _assessment = _assessment?.copyWith(infectionHealingDelay: value);
            });
          }),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Cultura da Ferida Realizada?'),
            value: _assessment?.culturePerformed ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(culturePerformed: value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPainIntensitySlider() {
    final painValue = _assessment?.painIntensity ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Intensidade'),
            Text(
              '$painValue/10',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: painValue >= 7 ? Colors.red : painValue >= 4 ? Colors.orange : Colors.green,
              ),
            ),
          ],
        ),
        Slider(
          value: painValue.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          label: '$painValue',
          onChanged: (value) {
            setState(() {
              _assessment = _assessment?.copyWith(painIntensity: value.toInt());
            });
          },
        ),
      ],
    );
  }

  Widget _buildCheckboxListTile(String title, bool value, ValueChanged<bool> onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: (newValue) => onChanged(newValue ?? false),
    );
  }

  Widget _buildMoistureSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'M - Umidade (Exsudato)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Quantidade',
            ),
            items: ['Ausente', 'Mínimo', 'Moderado', 'Abundante']
                .map((qty) => DropdownMenuItem(value: qty, child: Text(qty)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(exudateQuantity: value);
              });
            },
            initialValue: _assessment?.exudateQuantity,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Tipo',
            ),
            items: ['Seroso', 'Seropurulento', 'Purulento', 'Sanguinolento']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(exudateType: value);
              });
            },
            initialValue: _assessment?.exudateType,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Consistência',
            ),
            items: ['Fina', 'Espessa', 'Viscosa']
                .map((consistency) => DropdownMenuItem(value: consistency, child: Text(consistency)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(exudateConsistency: value);
              });
            },
            initialValue: _assessment?.exudateConsistency,
          ),
          const SizedBox(height: 24),
          const Text(
            'Pele Perilesional',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Umidade da Pele',
            ),
            items: ['Hidratada', 'Ressecada', 'Macerada']
                .map((moisture) => DropdownMenuItem(value: moisture, child: Text(moisture)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(perilesionalSkinMoisture: value);
              });
            },
            initialValue: _assessment?.perilesionalSkinMoisture,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Extensão da Alteração',
            ),
            items: ['< 1cm', '1-2cm', '2-4cm', '> 4cm']
                .map((extent) => DropdownMenuItem(value: extent, child: Text(extent)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(skinAlterationExtent: value);
              });
            },
            initialValue: _assessment?.skinAlterationExtent,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Condição da Pele',
            ),
            items: [
              'Íntegra',
              'Eritematosa',
              'Macerada',
              'Seca e Descamativa',
              'Eczematosa',
              'Hiperpigmentada',
              'Hipopigmentada',
              'Indurada',
              'Sensível',
              'Edema',
            ]
                .map((condition) => DropdownMenuItem(value: condition, child: Text(condition)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(skinCondition: value);
              });
            },
            initialValue: _assessment?.skinCondition,
          ),
        ],
      ),
    );
  }

  Widget _buildEdgeSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'E - Bordas (Edge)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Características das Bordas',
            ),
            items: ['Regulares', 'Irregulares', 'Bem Definidas', 'Mal Definidas']
                .map((char) => DropdownMenuItem(value: char, child: Text(char)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(edgeCharacteristics: value);
              });
            },
            initialValue: _assessment?.edgeCharacteristics,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Fixação das Bordas',
            ),
            items: ['Aderidas', 'Descoladas', 'Parcialmente Descoladas']
                .map((attachment) => DropdownMenuItem(value: attachment, child: Text(attachment)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(edgeAttachment: value);
              });
            },
            initialValue: _assessment?.edgeAttachment,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Bordas Descoladas'),
            value: _assessment?.edgeDetached ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(edgeDetached: value);
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Velocidade de Cicatrização',
            ),
            items: ['Progressiva', 'Estagnada', 'Regressiva']
                .map((velocity) => DropdownMenuItem(value: velocity, child: Text(velocity)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(healingVelocity: value);
              });
            },
            initialValue: _assessment?.healingVelocity,
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Presença de Túneis ou Cavidade?'),
            value: _assessment?.tunnelsPresent ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(tunnelsPresent: value);
              });
            },
          ),
          if (_assessment?.tunnelsPresent == true) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _controllers['tunnelLocation'],
              decoration: const InputDecoration(
                labelText: 'Localização',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRepairSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'R - Reparo e Recomendações',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _controllers['observations'],
            decoration: const InputDecoration(
              labelText: 'Observações e Plano de Tratamento',
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 24),
          const Text(
            'Dados da Consulta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _consultationDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() => _consultationDate = date);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data da Consulta',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                _consultationDate != null
                    ? DateFormat('dd/MM/yyyy').format(_consultationDate!)
                    : 'Selecione a data',
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _consultationTime ?? TimeOfDay.now(),
              );
              if (time != null) {
                setState(() => _consultationTime = time);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Hora da Consulta',
                suffixIcon: Icon(Icons.access_time),
              ),
              child: Text(
                _consultationTime != null
                    ? _consultationTime!.format(context)
                    : 'Selecione a hora',
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controllers['professionalName'],
            decoration: const InputDecoration(
              labelText: 'Profissional Responsável',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controllers['professionalCorenCrm'],
            decoration: const InputDecoration(
              labelText: 'COREN/CRM',
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _returnDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() => _returnDate = date);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data de Retorno',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                _returnDate != null
                    ? DateFormat('dd/MM/yyyy').format(_returnDate!)
                    : 'Selecione a data',
              ),
            ),
          ),
          const SizedBox(height: 24),
          TimerWidget(woundAssessmentId: _assessment?.id),
        ],
      ),
    );
  }

  Widget _buildSocialSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'S - Fatores Sociais e Histórico do Paciente',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Fatores Sociais e de Autocuidado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Nível de Atividade',
            ),
            items: ['Leito', 'Cadeira', 'Deambula', 'Ativo']
                .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(activityLevel: value);
              });
            },
            initialValue: _assessment?.activityLevel,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Compreensão e Adesão',
            ),
            items: ['Boa', 'Regular', 'Ruim']
                .map((adherence) => DropdownMenuItem(value: adherence, child: Text(adherence)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(understandingAdherence: value);
              });
            },
            initialValue: _assessment?.understandingAdherence,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Suporte Social e Cuidadores',
            ),
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(socialSupport: value);
              });
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Hábitos e Histórico Pessoal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Pratica atividade física?'),
            value: _assessment?.physicalActivity ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(physicalActivity: value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('Ingere álcool?'),
            value: _assessment?.alcoholConsumption ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(alcoholConsumption: value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('É fumante?'),
            value: _assessment?.smoker ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(smoker: value);
              });
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Estado Nutricional',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Avaliação Nutricional',
            ),
            maxLines: 3,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(nutritionalAssessment: value);
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ingestão de Água por Dia (ml)',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(waterIntake: double.tryParse(value));
              });
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Histórico Clínico e Comorbidades',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Objetivo do Tratamento',
            ),
            maxLines: 3,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(treatmentObjective: value);
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Histórico de Cicatrização',
            ),
            maxLines: 3,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(healingHistory: value);
              });
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Possui alergia?'),
            value: _assessment?.hasAllergy ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(hasAllergy: value);
              });
            },
          ),
          if (_assessment?.hasAllergy == true) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _controllers['allergies'],
              decoration: const InputDecoration(
                labelText: 'Alergias',
              ),
              maxLines: 2,
            ),
          ],
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Realizou cirurgias?'),
            value: _assessment?.surgeriesPerformed ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(surgeriesPerformed: value);
              });
            },
          ),
          if (_assessment?.surgeriesPerformed == true) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _controllers['surgeriesDetails'],
              decoration: const InputDecoration(
                labelText: 'Detalhes das Cirurgias',
              ),
              maxLines: 3,
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            'Função Vascular',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Claudicação Intermitente'),
            value: _assessment?.claudication ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(claudication: value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('Dor em Repouso'),
            value: _assessment?.restPain ?? false,
            onChanged: (value) {
              setState(() {
                _assessment = _assessment?.copyWith(restPain: value);
              });
            },
          ),
          TextFormField(
            controller: _controllers['peripheralPulses'],
            decoration: const InputDecoration(
              labelText: 'Pulsos Periféricos',
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Comorbidades',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildComorbidityCheckboxes(),
          const SizedBox(height: 24),
          const Text(
            'Medicamentos em Uso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildMedicationCheckboxes(),
        ],
      ),
    );
  }

  Widget _buildComorbidityCheckboxes() {
    final comorbidities = [
      'DMI', 'DMII', 'HAS', 'Neoplasia', 'HIV/AIDS', 'Obesidade',
      'Cardiopatia', 'DPOC', 'Doença Hematológica', 'Doença Vascular',
      'Demência Senil', 'Insuficiência Renal', 'Hanseníase',
      'Insuficiência Hepática', 'Doença Autoimune',
    ];
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: comorbidities.map((comorbidity) {
        return FilterChip(
          label: Text(comorbidity),
          selected: _assessment?.comorbidities?.contains(comorbidity) ?? false,
          onSelected: (selected) {
            final current = _assessment?.comorbidities?.split(',') ?? [];
            final updated = selected
                ? [...current, comorbidity]
                : current.where((c) => c != comorbidity).toList();
            setState(() {
              _assessment = _assessment?.copyWith(
                comorbidities: updated.join(','),
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildMedicationCheckboxes() {
    final medications = [
      'Anti-hipertensivo', 'Corticoides', 'Hipoglicemiantes Orais', 'AINES',
      'Insulina', 'Drogas Vasoativas', 'Suplemento', 'Anticoagulante',
      'Vitamínico', 'Antirretroviral',
    ];
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: medications.map((medication) {
        return FilterChip(
          label: Text(medication),
          selected: _assessment?.medications?.contains(medication) ?? false,
          onSelected: (selected) {
            final current = _assessment?.medications?.split(',') ?? [];
            final updated = selected
                ? [...current, medication]
                : current.where((m) => m != medication).toList();
            setState(() {
              _assessment = _assessment?.copyWith(
                medications: updated.join(','),
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text('Anterior'),
            )
          else
            const SizedBox(),
          ElevatedButton(
            onPressed: () {
              if (_currentPage < 6) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                _saveAssessment();
              }
            },
            child: Text(_currentPage < 6 ? 'Próximo' : 'Salvar'),
          ),
        ],
      ),
    );
  }
}

