import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BodyMapWidget extends StatefulWidget {
  final Function(String)? onLocationSelected;

  const BodyMapWidget({super.key, this.onLocationSelected});

  @override
  State<BodyMapWidget> createState() => _BodyMapWidgetState();
}

class _BodyMapWidgetState extends State<BodyMapWidget> {
  String? _selectedLocation;

  final List<BodyPart> _bodyParts = [
    BodyPart(name: 'Cabeça', position: Offset(0.5, 0.1), size: Size(0.15, 0.12)),
    BodyPart(name: 'Pescoço', position: Offset(0.5, 0.22), size: Size(0.1, 0.05)),
    BodyPart(name: 'Ombro Esquerdo', position: Offset(0.25, 0.27), size: Size(0.12, 0.08)),
    BodyPart(name: 'Ombro Direito', position: Offset(0.75, 0.27), size: Size(0.12, 0.08)),
    BodyPart(name: 'Tórax', position: Offset(0.5, 0.4), size: Size(0.3, 0.2)),
    BodyPart(name: 'Abdômen', position: Offset(0.5, 0.6), size: Size(0.3, 0.15)),
    BodyPart(name: 'Braço Esquerdo', position: Offset(0.15, 0.35), size: Size(0.08, 0.25)),
    BodyPart(name: 'Braço Direito', position: Offset(0.85, 0.35), size: Size(0.08, 0.25)),
    BodyPart(name: 'Antebraço Esquerdo', position: Offset(0.15, 0.6), size: Size(0.08, 0.2)),
    BodyPart(name: 'Antebraço Direito', position: Offset(0.85, 0.6), size: Size(0.08, 0.2)),
    BodyPart(name: 'Mão Esquerda', position: Offset(0.15, 0.8), size: Size(0.08, 0.1)),
    BodyPart(name: 'Mão Direita', position: Offset(0.85, 0.8), size: Size(0.08, 0.1)),
    BodyPart(name: 'Coxa Esquerda', position: Offset(0.4, 0.75), size: Size(0.12, 0.2)),
    BodyPart(name: 'Coxa Direita', position: Offset(0.6, 0.75), size: Size(0.12, 0.2)),
    BodyPart(name: 'Joelho Esquerdo', position: Offset(0.4, 0.95), size: Size(0.12, 0.08)),
    BodyPart(name: 'Joelho Direito', position: Offset(0.6, 0.95), size: Size(0.12, 0.08)),
    BodyPart(name: 'Perna Esquerda', position: Offset(0.4, 1.03), size: Size(0.12, 0.2)),
    BodyPart(name: 'Perna Direita', position: Offset(0.6, 1.03), size: Size(0.12, 0.2)),
    BodyPart(name: 'Pé Esquerdo', position: Offset(0.4, 1.23), size: Size(0.12, 0.08)),
    BodyPart(name: 'Pé Direito', position: Offset(0.6, 1.23), size: Size(0.12, 0.08)),
    BodyPart(name: 'Costas - Superior', position: Offset(0.5, 0.35), size: Size(0.3, 0.15)),
    BodyPart(name: 'Costas - Inferior', position: Offset(0.5, 0.5), size: Size(0.3, 0.15)),
    BodyPart(name: 'Glúteos', position: Offset(0.5, 0.7), size: Size(0.2, 0.1)),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecione a localização da ferida',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = 400.0;
                return Container(
                  height: height,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Desenho simplificado do corpo
                      CustomPaint(
                        size: Size(width, height),
                        painter: BodyPainter(),
                      ),
                      // Áreas clicáveis
                      ..._bodyParts.map((part) => _buildClickableArea(part, width, height)),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            if (_selectedLocation != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppTheme.primaryBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Localização selecionada: $_selectedLocation',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableArea(BodyPart part, double width, double height) {
    final isSelected = _selectedLocation == part.name;
    return Positioned(
      left: part.position.dx * width - (part.size.width * width / 2),
      top: part.position.dy * height - (part.size.height * height / 2),
      width: part.size.width * width,
      height: part.size.height * height,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLocation = part.name;
          });
          widget.onLocationSelected?.call(part.name);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryBlue.withOpacity(0.3)
                : Colors.transparent,
            border: isSelected
                ? Border.all(color: AppTheme.primaryBlue, width: 2)
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: isSelected
              ? Center(
                  child: Icon(
                    Icons.check_circle,
                    color: AppTheme.primaryBlue,
                    size: 24,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class BodyPart {
  final String name;
  final Offset position; // Posição relativa (0.0 a 1.0)
  final Size size; // Tamanho relativo

  BodyPart({
    required this.name,
    required this.position,
    required this.size,
  });
}

class BodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Cabeça
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.1),
      size.width * 0.08,
      paint,
    );

    // Tronco
    final torsoPath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.25)
      ..lineTo(size.width * 0.35, size.height * 0.65)
      ..lineTo(size.width * 0.65, size.height * 0.65)
      ..lineTo(size.width * 0.65, size.height * 0.25)
      ..close();
    canvas.drawPath(torsoPath, paint);

    // Braços
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.35),
      Offset(size.width * 0.2, size.height * 0.35),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.35),
      Offset(size.width * 0.8, size.height * 0.35),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.35),
      Offset(size.width * 0.2, size.height * 0.85),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.35),
      Offset(size.width * 0.8, size.height * 0.85),
      paint,
    );

    // Pernas
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.65),
      Offset(size.width * 0.4, size.height * 1.3),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.65),
      Offset(size.width * 0.6, size.height * 1.3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

