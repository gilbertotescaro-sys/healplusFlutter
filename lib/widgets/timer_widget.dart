import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';
import '../models/wound_assessment.dart';

class TimerWidget extends StatefulWidget {
  final String? woundAssessmentId;

  const TimerWidget({super.key, this.woundAssessmentId});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  List<AssessmentTimer> _timers = [];
  Timer? _updateTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.woundAssessmentId != null) {
      _loadTimers();
    } else {
      _isLoading = false;
    }
    _startUpdateTimer();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadTimers() async {
    if (widget.woundAssessmentId == null) return;
    
    setState(() => _isLoading = true);
    final timers = await DatabaseHelper.instance
        .getTimersForAssessment(widget.woundAssessmentId!);
    setState(() {
      _timers = timers;
      _isLoading = false;
    });
  }

  Future<void> _startTimer(String timerName) async {
    if (widget.woundAssessmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salve a avaliação primeiro para usar timers')),
      );
      return;
    }

    final timer = AssessmentTimer(
      woundAssessmentId: widget.woundAssessmentId!,
      timerName: timerName,
      startTime: DateTime.now().toIso8601String(),
      isActive: true,
    );

    await DatabaseHelper.instance.insertTimer(timer);
    await _loadTimers();
  }

  Future<void> _stopTimer(AssessmentTimer timer) async {
    final endTime = DateTime.now();
    final startTime = DateTime.parse(timer.startTime);
    final duration = endTime.difference(startTime).inSeconds;

    final updatedTimer = AssessmentTimer(
      id: timer.id,
      woundAssessmentId: timer.woundAssessmentId,
      timerName: timer.timerName,
      startTime: timer.startTime,
      endTime: endTime.toIso8601String(),
      durationSeconds: duration,
      isActive: false,
      createdAt: timer.createdAt,
    );

    await DatabaseHelper.instance.updateTimer(updatedTimer);
    await _loadTimers();
  }

  Future<void> _deleteTimer(AssessmentTimer timer) async {
    await DatabaseHelper.instance.deleteTimer(timer.id);
    await _loadTimers();
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  int _getElapsedSeconds(AssessmentTimer timer) {
    if (!timer.isActive) {
      return timer.durationSeconds ?? 0;
    }
    final startTime = DateTime.parse(timer.startTime);
    final now = DateTime.now();
    return now.difference(startTime).inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_timers.isEmpty)
              const Text(
                'Nenhum timer ativo. Use os botões abaixo para iniciar.',
                style: TextStyle(color: Colors.grey),
              )
            else
              ..._timers.map((timer) => _buildTimerCard(timer)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTimerButton('Avaliação', Icons.assessment),
                _buildTimerButton('Tratamento', Icons.medical_services),
                _buildTimerButton('Curativo', Icons.healing),
                _buildTimerButton('Consulta', Icons.event),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCard(AssessmentTimer timer) {
    final elapsed = _getElapsedSeconds(timer);
    final isActive = timer.isActive;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isActive ? AppTheme.primaryBlue.withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(
          isActive ? Icons.timer : Icons.timer_off,
          color: isActive ? AppTheme.primaryBlue : Colors.grey,
        ),
        title: Text(
          timer.timerName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isActive ? AppTheme.primaryBlue : null,
          ),
        ),
        subtitle: Text(
          isActive
              ? 'Em andamento: ${_formatDuration(elapsed)}'
              : 'Finalizado: ${_formatDuration(elapsed)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              IconButton(
                icon: const Icon(Icons.stop),
                color: Colors.red,
                onPressed: () => _stopTimer(timer),
                tooltip: 'Parar',
              ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.grey,
              onPressed: () => _deleteTimer(timer),
              tooltip: 'Excluir',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerButton(String name, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => _startTimer(name),
      icon: Icon(icon),
      label: Text(name),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }
}

