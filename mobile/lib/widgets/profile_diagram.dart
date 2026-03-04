import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileDiagram extends StatelessWidget {
  final String tipoPerfil;
  final Map<String, double> medidas;

  const ProfileDiagram({
    super.key,
    required this.tipoPerfil,
    required this.medidas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: CustomPaint(
        painter: _DiagramPainter(tipoPerfil: tipoPerfil, medidas: medidas),
        child: Container(),
      ),
    );
  }
}

class _DiagramPainter extends CustomPainter {
  final String tipoPerfil;
  final Map<String, double> medidas;

  _DiagramPainter({required this.tipoPerfil, required this.medidas});

  final _paint = Paint()
    ..color = AppColors.navy
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final _fillPaint = Paint()
    ..color = AppColors.navy.withOpacity(0.12)
    ..style = PaintingStyle.fill;

  final _dimPaint = Paint()
    ..color = AppColors.teal
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    _drawDiagram(canvas, size);
    canvas.restore();
  }

  void _drawDiagram(Canvas canvas, Size size) {
    switch (tipoPerfil) {
      case 'cantoneira_igual':
      case 'cantoneira_desigual':
      case 'angulo_dobrado':
        _drawCantoneira(canvas, size);
        break;
      case 'perfil_i':
      case 'perfil_h':
        _drawPerfilI(canvas, size);
        break;
      case 'perfil_u':
        _drawPerfilU(canvas, size);
        break;
      case 'perfil_c':
        _drawPerfilC(canvas, size);
        break;
      case 'perfil_z':
        _drawPerfilZ(canvas, size);
        break;
      case 'perfil_t':
        _drawPerfilT(canvas, size);
        break;
      case 'tubo_retangular':
        _drawTuboRetangular(canvas, size);
        break;
      case 'tubo_quadrado':
        _drawTuboQuadrado(canvas, size);
        break;
      case 'tubo_redondo':
        _drawTuboRedondo(canvas, size);
        break;
      case 'barra_redonda':
      case 'vergalhao':
        _drawBarraRedonda(canvas, size);
        break;
      case 'barra_quadrada':
        _drawBarraQuadrada(canvas, size);
        break;
      case 'barra_chata':
        _drawBarraChata(canvas, size);
        break;
      case 'barra_sextavada':
        _drawBarraSextavada(canvas, size);
        break;
      case 'chapa':
      case 'chapa_xadrez':
        _drawChapa(canvas, size);
        break;
      case 'tubo_oval':
        _drawTuboOval(canvas, size);
        break;
      case 'omega':
        _drawOmega(canvas, size);
        break;
      default:
        _drawGenerico(canvas, size);
    }
  }

  void _drawCantoneira(Canvas canvas, Size size) {
    const scale = 0.6;
    final w = size.width * scale;
    final h = size.height * scale;
    final e = h * 0.12;

    final path = Path()
      ..moveTo(-w / 2, -h / 2)
      ..lineTo(-w / 2, h / 2)
      ..lineTo(-w / 2 + e, h / 2)
      ..lineTo(-w / 2 + e, -h / 2 + e)
      ..lineTo(w / 2, -h / 2 + e)
      ..lineTo(w / 2, -h / 2)
      ..close();

    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _paint);
    _drawLabel(canvas, 'A', Offset(0, -h / 2 - 12), size);
    _drawLabel(canvas, 'e', Offset(-w / 2 + e / 2, 0), size);
  }

  void _drawPerfilI(Canvas canvas, Size size) {
    const scale = 0.65;
    final h = size.height * scale;
    final b = size.width * scale * 0.7;
    final tw = b * 0.12;
    final tf = h * 0.15;

    final path = Path()
      ..addRect(Rect.fromCenter(center: Offset(0, -h / 2 + tf / 2), width: b, height: tf))
      ..addRect(Rect.fromCenter(center: const Offset(0, 0), width: tw, height: h - 2 * tf))
      ..addRect(Rect.fromCenter(center: Offset(0, h / 2 - tf / 2), width: b, height: tf));

    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _paint);
    _drawLabel(canvas, 'H', Offset(b / 2 + 16, 0), size);
    _drawLabel(canvas, 'B', Offset(0, -h / 2 - 12), size);
  }

  void _drawPerfilU(Canvas canvas, Size size) {
    const scale = 0.6;
    final h = size.height * scale;
    final b = size.width * scale * 0.6;
    final tw = b * 0.14;
    final tf = h * 0.14;

    final path = Path()
      ..moveTo(-b / 2, -h / 2)
      ..lineTo(-b / 2, h / 2)
      ..lineTo(b / 2, h / 2)
      ..lineTo(b / 2, h / 2 - tf)
      ..lineTo(-b / 2 + tw, h / 2 - tf)
      ..lineTo(-b / 2 + tw, -h / 2 + tf)
      ..lineTo(b / 2, -h / 2 + tf)
      ..lineTo(b / 2, -h / 2)
      ..close();

    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _paint);
    _drawLabel(canvas, 'H', Offset(-b / 2 - 16, 0), size);
    _drawLabel(canvas, 'B', Offset(0, h / 2 + 14), size);
  }

  void _drawPerfilC(Canvas canvas, Size size) {
    const scale = 0.6;
    final h = size.height * scale;
    final b = size.width * scale * 0.55;
    final e = h * 0.1;
    final aba = b * 0.3;

    final path = Path()
      ..moveTo(-b / 2 + e, -h / 2)
      ..lineTo(-b / 2 + e, -h / 2 + aba)
      ..lineTo(b / 2, -h / 2 + aba)
      ..lineTo(b / 2, -h / 2 + aba + e)
      ..lineTo(-b / 2 + e + e, -h / 2 + aba + e)
      ..lineTo(-b / 2 + e + e, h / 2 - aba - e)
      ..lineTo(b / 2, h / 2 - aba - e)
      ..lineTo(b / 2, h / 2 - aba)
      ..lineTo(-b / 2 + e, h / 2 - aba)
      ..lineTo(-b / 2 + e, h / 2)
      ..lineTo(-b / 2, h / 2)
      ..lineTo(-b / 2, -h / 2)
      ..close();

    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _paint);
    _drawLabel(canvas, 'H', Offset(-b / 2 - 16, 0), size);
    _drawLabel(canvas, 'B', Offset(b * 0.1, h / 2 + 14), size);
  }

  void _drawPerfilZ(Canvas canvas, Size size) {
    const scale = 0.6;
    final h = size.height * scale;
    final b = size.width * scale * 0.6;
    final e = h * 0.1;

    final path = Path()
      ..moveTo(-b / 2, -h / 2)
      ..lineTo(b / 2, -h / 2)
      ..lineTo(b / 2, -h / 2 + e)
      ..lineTo(e / 2, -h / 2 + e)
      ..lineTo(e / 2, h / 2 - e)
      ..lineTo(b / 2, h / 2 - e)
      ..lineTo(b / 2, h / 2)
      ..lineTo(-b / 2, h / 2)
      ..lineTo(-b / 2, h / 2 - e)
      ..lineTo(-e / 2, h / 2 - e)
      ..lineTo(-e / 2, -h / 2 + e)
      ..lineTo(-b / 2, -h / 2 + e)
      ..close();

    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _paint);
    _drawLabel(canvas, 'H', Offset(b / 2 + 16, 0), size);
    _drawLabel(canvas, 'B', Offset(0, -h / 2 - 12), size);
  }

  void _drawPerfilT(Canvas canvas, Size size) {
    const scale = 0.6;
    final h = size.height * scale;
    final b = size.width * scale * 0.8;
    final tw = b * 0.14;
    final tf = h * 0.18;

    final mesa = Rect.fromCenter(center: Offset(0, -h / 2 + tf / 2), width: b, height: tf);
    final alma = Rect.fromCenter(center: Offset(0, (-h / 2 + tf + h / 2) / 2), width: tw, height: h - tf);

    canvas.drawRect(mesa, _fillPaint);
    canvas.drawRect(alma, _fillPaint);
    canvas.drawRect(mesa, _paint);
    canvas.drawRect(alma, _paint);
    _drawLabel(canvas, 'H', Offset(b / 2 + 16, 0), size);
    _drawLabel(canvas, 'B', Offset(0, -h / 2 - 12), size);
  }

  void _drawTuboRetangular(Canvas canvas, Size size) {
    const scale = 0.6;
    final a = size.width * scale;
    final b = size.height * scale * 0.6;
    final e = a * 0.07;

    final outer = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: a, height: b),
      const Radius.circular(4),
    );
    final inner = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: a - 2 * e, height: b - 2 * e),
      const Radius.circular(2),
    );

    canvas.drawRRect(outer, _fillPaint);
    canvas.drawRRect(outer, _paint);
    canvas.drawRRect(inner, Paint()..color = AppColors.cream..style = PaintingStyle.fill);
    canvas.drawRRect(inner, _paint);
    _drawLabel(canvas, 'A', Offset(0, -b / 2 - 12), size);
    _drawLabel(canvas, 'B', Offset(a / 2 + 14, 0), size);
    _drawLabel(canvas, 'e', Offset(0, b / 2 - e / 2), size);
  }

  void _drawTuboQuadrado(Canvas canvas, Size size) {
    const scale = 0.6;
    final a = size.width * scale * 0.75;
    final e = a * 0.09;

    final outer = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: a, height: a),
      const Radius.circular(4),
    );
    final inner = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: a - 2 * e, height: a - 2 * e),
      const Radius.circular(2),
    );

    canvas.drawRRect(outer, _fillPaint);
    canvas.drawRRect(outer, _paint);
    canvas.drawRRect(inner, Paint()..color = AppColors.cream..style = PaintingStyle.fill);
    canvas.drawRRect(inner, _paint);
    _drawLabel(canvas, 'A', Offset(0, -a / 2 - 12), size);
    _drawLabel(canvas, 'e', Offset(a / 2 + 14, 0), size);
  }

  void _drawTuboRedondo(Canvas canvas, Size size) {
    const scale = 0.6;
    final r = size.width * scale * 0.4;
    final e = r * 0.14;

    canvas.drawCircle(Offset.zero, r, _fillPaint);
    canvas.drawCircle(Offset.zero, r, _paint);
    canvas.drawCircle(Offset.zero, r - e, Paint()..color = AppColors.cream..style = PaintingStyle.fill);
    canvas.drawCircle(Offset.zero, r - e, _paint);
    _drawLabel(canvas, 'De', Offset(r + 14, 0), size);
    _drawLabel(canvas, 'e', Offset(r - e / 2, 0), size);
  }

  void _drawBarraRedonda(Canvas canvas, Size size) {
    const scale = 0.55;
    final r = size.width * scale * 0.4;
    canvas.drawCircle(Offset.zero, r, _fillPaint);
    canvas.drawCircle(Offset.zero, r, _paint);
    _drawLabel(canvas, 'D', Offset(r + 14, 0), size);
  }

  void _drawBarraQuadrada(Canvas canvas, Size size) {
    const scale = 0.55;
    final a = size.width * scale * 0.7;
    final rect = Rect.fromCenter(center: Offset.zero, width: a, height: a);
    canvas.drawRect(rect, _fillPaint);
    canvas.drawRect(rect, _paint);
    _drawLabel(canvas, 'A', Offset(0, -a / 2 - 12), size);
  }

  void _drawBarraChata(Canvas canvas, Size size) {
    const scale = 0.65;
    final a = size.width * scale;
    final e = size.height * scale * 0.25;
    final rect = Rect.fromCenter(center: Offset.zero, width: a, height: e);
    canvas.drawRect(rect, _fillPaint);
    canvas.drawRect(rect, _paint);
    _drawLabel(canvas, 'A', Offset(0, -e / 2 - 12), size);
    _drawLabel(canvas, 'e', Offset(a / 2 + 14, 0), size);
  }

  void _drawBarraSextavada(Canvas canvas, Size size) {
    const scale = 0.55;
    final r = size.width * scale * 0.38;
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = pi / 6 + i * pi / 3;
      final x = r * cos(angle);
      final y = r * sin(angle);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _paint);
    _drawLabel(canvas, 's', Offset(r + 14, 0), size);
  }

  void _drawChapa(Canvas canvas, Size size) {
    const scale = 0.65;
    final a = size.width * scale;
    final e = size.height * scale * 0.2;

    // Vista perspectiva simples
    final rect = Rect.fromCenter(center: Offset(0, e / 2), width: a, height: e);
    canvas.drawRect(rect, _fillPaint);
    canvas.drawRect(rect, _paint);

    // Perspectiva top
    final path = Path()
      ..moveTo(-a / 2, e / 2)
      ..lineTo(-a / 2 + 16, e / 2 - 16)
      ..lineTo(a / 2 + 16, e / 2 - 16)
      ..lineTo(a / 2, e / 2)
      ..close();
    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _paint);

    _drawLabel(canvas, 'A', Offset(0, e / 2 + 16), size);
    _drawLabel(canvas, 'e', Offset(a / 2 + 18, e / 2), size);
  }

  void _drawTuboOval(Canvas canvas, Size size) {
    const scale = 0.6;
    final rx = size.width * scale * 0.4;
    final ry = size.height * scale * 0.32;
    final e = rx * 0.1;

    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 2 * rx, height: 2 * ry), _fillPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 2 * rx, height: 2 * ry), _paint);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 2 * (rx - e), height: 2 * (ry - e)),
      Paint()..color = AppColors.cream..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 2 * (rx - e), height: 2 * (ry - e)),
      _paint,
    );
    _drawLabel(canvas, 'A', Offset(rx + 14, 0), size);
    _drawLabel(canvas, 'B', Offset(0, -ry - 12), size);
  }

  void _drawOmega(Canvas canvas, Size size) {
    const scale = 0.6;
    final b = size.width * scale;
    final h = size.height * scale * 0.55;
    final a = b * 0.22;
    final e = h * 0.12;

    final path = Path()
      ..moveTo(-b / 2, h / 2)
      ..lineTo(-b / 2, h / 2 - e)
      ..lineTo(-b / 2 + a, h / 2 - e)
      ..lineTo(-b / 2 + a, -h / 2 + e)
      ..lineTo(b / 2 - a, -h / 2 + e)
      ..lineTo(b / 2 - a, h / 2 - e)
      ..lineTo(b / 2, h / 2 - e)
      ..lineTo(b / 2, h / 2)
      ..lineTo(b / 2 - a + e, h / 2)
      ..lineTo(b / 2 - a + e, -h / 2)
      ..lineTo(-b / 2 + a - e, -h / 2)
      ..lineTo(-b / 2 + a - e, h / 2)
      ..close();

    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _paint);
    _drawLabel(canvas, 'B', Offset(0, h / 2 + 14), size);
    _drawLabel(canvas, 'H', Offset(-b / 2 - 16, 0), size);
  }

  void _drawGenerico(Canvas canvas, Size size) {
    const scale = 0.55;
    final a = size.width * scale * 0.7;
    final rect = Rect.fromCenter(center: Offset.zero, width: a, height: a * 0.6);
    canvas.drawRect(rect, _fillPaint);
    canvas.drawRect(rect, _paint);
    _drawLabel(canvas, '?', Offset.zero, size);
  }

  void _drawLabel(Canvas canvas, String text, Offset position, Size size) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColors.teal,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, position - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_DiagramPainter old) =>
      old.tipoPerfil != tipoPerfil || old.medidas != medidas;
}
