import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';
import '../models/wound_assessment.dart';
import 'package:intl/intl.dart';

class WoundListScreen extends StatefulWidget {
  const WoundListScreen({super.key});

  @override
  State<WoundListScreen> createState() => _WoundListScreenState();
}

class _WoundListScreenState extends State<WoundListScreen> {
  List<WoundAssessment> _assessments = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAssessments();
  }

  Future<void> _loadAssessments() async {
    setState(() => _isLoading = true);
    final assessments = await DatabaseHelper.instance.getAllWoundAssessments();
    setState(() {
      _assessments = assessments;
      _isLoading = false;
    });
  }

  List<WoundAssessment> get _filteredAssessments {
    if (_searchQuery.isEmpty) {
      return _assessments;
    }
    return _assessments.where((assessment) {
      return assessment.patientName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Future<void> _deleteAssessment(WoundAssessment assessment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir a avaliação de ${assessment.patientName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteWoundAssessment(assessment.id);
      _loadAssessments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avaliação excluída com sucesso')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAssessments,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nome do paciente...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAssessments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assessment_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Nenhuma avaliação encontrada'
                                  : 'Nenhum resultado para "$_searchQuery"',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredAssessments.length,
                        itemBuilder: (context, index) {
                          final assessment = _filteredAssessments[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                                child: const Icon(
                                  Icons.medical_services,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                              title: Text(
                                assessment.patientName,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (assessment.consultationDate != null)
                                    Text(
                                      'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(assessment.consultationDate!))}',
                                    ),
                                  if (assessment.location != null)
                                    Text('Local: ${assessment.location}'),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: 8),
                                        Text('Editar'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Excluir', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    context.go('/wound-assessment/${assessment.id}');
                                  } else if (value == 'delete') {
                                    _deleteAssessment(assessment);
                                  }
                                },
                              ),
                              onTap: () {
                                context.go('/wound-assessment/${assessment.id}');
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

