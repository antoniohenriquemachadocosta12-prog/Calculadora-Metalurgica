import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget que desenha o diagrama técnico de cada tipo de perfil metálico
class PerfilDiagram extends StatelessWidget {
  final String perfilId;
  final double size;

  const PerfilDiagram({
    super.key,
    required this.perfilId,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PerfilPainter(perfilId),
        size: Size(size, size),
      ),
    );
  }
}

class _PerfilPainter extends CustomPainter {
  final String perfilId;

  _PerfilPainter(this.perfilId);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = AppColors.navy.withAlpha(25)
      ..style = PaintingStyle.fill;

    final dimPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width * 0.8; // escala base

    switch (perfilId) {
      case 'perfil_c':
        _drawPerfilC(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'perfil_u':
        _drawPerfilU(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'perfil_i':
        _drawPerfilI(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'perfil_t':
        _drawPerfilT(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'perfil_z':
        _drawPerfilZ(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'cantoneira':
      case 'cantoneira_igual':
        _drawCantoneira(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'barra_quadrada':
        _drawBarraQuadrada(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'barra_retangular':
        _drawBarraRetangular(
            canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'barra_redonda':
      case 'vergalhao':
        _drawBarraRedonda(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'barra_sextavada':
        _drawBarraSextavada(
            canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'barra_chata':
        _drawBarraChata(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'tubo_quadrado':
        _drawTuboQuadrado(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'tubo_retangular':
        _drawTuboRetangular(
            canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'tubo_redondo':
        _drawTuboRedondo(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'tubo_oblongo':
        _drawTuboOblongo(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'chapa':
      case 'chapa_xadrez':
        _drawChapa(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'telha':
        _drawTelha(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'chapa_expandida':
        _drawChapaExpandida(
            canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'chapa_perfurada':
        _drawChapaPerfurada(
            canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      case 'grade':
        _drawGrade(canvas, size, paint, fillPaint, dimPaint, cx, cy, s);
        break;
      default:
        _drawGeneric(canvas, size, paint, fillPaint, cx, cy, s);
    }
  }

  // ===== PERFIS ESTRUTURAIS =====

  void _drawPerfilC(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final h = s * 0.7;
    final b = s * 0.35;
    final e = s * 0.06;

    final top = cy - h / 2;
    final bot = cy + h / 2;
    final left = cx - b / 2;
    final right = cx + b / 2;

    // Desenha todo o perfil C
    final fullPath = Path()
      ..moveTo(right, top)
      ..lineTo(left, top) // mesa superior
      ..lineTo(left, bot) // alma
      ..lineTo(right, bot) // mesa inferior
      ..lineTo(right, bot - e) // volta
      ..lineTo(left + e, bot - e)
      ..lineTo(left + e, top + e)
      ..lineTo(right, top + e)
      ..close();

    canvas.drawPath(fullPath, fill);
    canvas.drawPath(fullPath, paint);

    // Cotas
    _drawDimH(canvas, dim, right + 8, top, bot, 'h');
    _drawDimW(canvas, dim, left, right, bot + 8, 'b');
  }

  void _drawPerfilU(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final h = s * 0.7;
    final b = s * 0.35;
    final e = s * 0.06;

    final top = cy - h / 2;
    final bot = cy + h / 2;
    final left = cx - b / 2;
    final right = cx + b / 2;

    final path = Path()
      ..moveTo(left, top)
      ..lineTo(left, bot) // parede esquerda
      ..lineTo(right, bot) // base
      ..lineTo(right, top) // parede direita
      ..lineTo(right - e, top) // volta interna
      ..lineTo(right - e, bot - e)
      ..lineTo(left + e, bot - e)
      ..lineTo(left + e, top)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, paint);

    _drawDimH(canvas, dim, right + 8, top, bot, 'h');
    _drawDimW(canvas, dim, left, right, bot + 8, 'b');
  }

  void _drawPerfilI(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final h = s * 0.7;
    final b = s * 0.4;
    final tw = s * 0.06;
    final tf = s * 0.07;

    final top = cy - h / 2;
    final bot = cy + h / 2;
    final left = cx - b / 2;
    final right = cx + b / 2;

    final path = Path()
      ..moveTo(left, top)
      ..lineTo(right, top) // mesa superior
      ..lineTo(right, top + tf)
      ..lineTo(cx + tw / 2, top + tf)
      ..lineTo(cx + tw / 2, bot - tf) // alma direita
      ..lineTo(right, bot - tf)
      ..lineTo(right, bot) // mesa inferior
      ..lineTo(left, bot)
      ..lineTo(left, bot - tf)
      ..lineTo(cx - tw / 2, bot - tf)
      ..lineTo(cx - tw / 2, top + tf) // alma esquerda
      ..lineTo(left, top + tf)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, paint);

    _drawDimH(canvas, dim, right + 8, top, bot, 'h');
    _drawDimW(canvas, dim, left, right, bot + 8, 'b');
  }

  void _drawPerfilT(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final h = s * 0.65;
    final b = s * 0.5;
    final tw = s * 0.06;
    final tf = s * 0.07;

    final top = cy - h / 2;
    final bot = cy + h / 2;
    final left = cx - b / 2;
    final right = cx + b / 2;

    final path = Path()
      ..moveTo(left, top)
      ..lineTo(right, top) // mesa
      ..lineTo(right, top + tf)
      ..lineTo(cx + tw / 2, top + tf)
      ..lineTo(cx + tw / 2, bot) // alma direita
      ..lineTo(cx - tw / 2, bot)
      ..lineTo(cx - tw / 2, top + tf) // alma esquerda
      ..lineTo(left, top + tf)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, paint);

    _drawDimH(canvas, dim, cx + tw / 2 + 14, top, bot, 'h');
    _drawDimW(canvas, dim, left, right, top - 8, 'b');
  }

  void _drawPerfilZ(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final h = s * 0.65;
    final b = s * 0.3;
    final e = s * 0.06;

    final top = cy - h / 2;
    final bot = cy + h / 2;

    final zFull = Path()
      ..moveTo(cx + b / 2, top) // topo direito
      ..lineTo(cx - e / 2, top)
      ..lineTo(cx - e / 2, top + e)
      ..lineTo(cx - b / 2, top + e) // mesa sup esquerda
      ..lineTo(cx - b / 2, top)
      // alma
      ..lineTo(cx - b / 2, bot - e)
      ..lineTo(cx - b / 2, bot)
      ..lineTo(cx + e / 2, bot)
      ..lineTo(cx + e / 2, bot - e)
      ..lineTo(cx + b / 2, bot - e)
      ..lineTo(cx + b / 2, bot)
      ..lineTo(cx + b / 2, top + e)
      ..close();

    canvas.drawPath(zFull, fill);
    canvas.drawPath(zFull, paint);

    _drawDimH(canvas, dim, cx + b / 2 + 8, top, bot, 'h');
    _drawDimW(canvas, dim, cx - b / 2, cx + b / 2, bot + 8, 'b');
  }

  void _drawCantoneira(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final a = s * 0.5;
    final b = s * 0.5;
    final e = s * 0.07;

    final left = cx - a * 0.4;
    final bot = cy + b * 0.4;

    final path = Path()
      ..moveTo(left, bot - b) // topo
      ..lineTo(left + e, bot - b)
      ..lineTo(left + e, bot - e) // canto interno
      ..lineTo(left + a, bot - e)
      ..lineTo(left + a, bot) // base
      ..lineTo(left, bot) // canto externo
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, paint);

    _drawDimH(canvas, dim, left - 8, bot - b, bot, 'a');
    _drawDimW(canvas, dim, left, left + a, bot + 8, 'b');
  }

  // ===== BARRAS =====

  void _drawBarraQuadrada(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final l = s * 0.5;
    final rect = Rect.fromCenter(center: Offset(cx, cy), width: l, height: l);

    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, paint);

    _drawDimW(canvas, dim, cx - l / 2, cx + l / 2, cy + l / 2 + 8, 'L');
  }

  void _drawBarraRetangular(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final w = s * 0.6;
    final h = s * 0.35;
    final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);

    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, paint);

    _drawDimW(canvas, dim, cx - w / 2, cx + w / 2, cy + h / 2 + 8, 'b');
    _drawDimH(canvas, dim, cx + w / 2 + 8, cy - h / 2, cy + h / 2, 'h');
  }

  void _drawBarraRedonda(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final r = s * 0.25;

    canvas.drawCircle(Offset(cx, cy), r, fill);
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // Linha de diâmetro
    canvas.drawLine(
      Offset(cx - r, cy),
      Offset(cx + r, cy),
      dim,
    );
    _drawLabel(canvas, 'd', cx, cy - 10, AppColors.primary);
  }

  void _drawBarraSextavada(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final r = s * 0.27;
    final path = Path();

    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i - math.pi / 6;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, paint);

    // Cota entre faces
    final faceR = r * math.cos(math.pi / 6);
    canvas.drawLine(Offset(cx, cy - faceR), Offset(cx, cy + faceR), dim);
    _drawLabel(canvas, 'ch', cx + 10, cy, AppColors.primary);
  }

  void _drawBarraChata(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final w = s * 0.6;
    final h = s * 0.12;
    final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);

    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, paint);

    _drawDimW(canvas, dim, cx - w / 2, cx + w / 2, cy + h / 2 + 8, 'b');
    _drawDimH(canvas, dim, cx + w / 2 + 8, cy - h / 2, cy + h / 2, 'e');
  }

  // ===== TUBOS =====

  void _drawTuboQuadrado(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final l = s * 0.5;
    final e = s * 0.05;

    final outer = Rect.fromCenter(center: Offset(cx, cy), width: l, height: l);
    final inner = Rect.fromCenter(
        center: Offset(cx, cy), width: l - 2 * e, height: l - 2 * e);

    final path = Path()
      ..addRect(outer)
      ..addRect(inner);
    path.fillType = PathFillType.evenOdd;

    canvas.drawPath(path, fill);
    canvas.drawRect(outer, paint);
    canvas.drawRect(inner, paint..strokeWidth = 1.5);
    paint.strokeWidth = 2.5;

    _drawDimW(canvas, dim, cx - l / 2, cx + l / 2, cy + l / 2 + 8, 'L');

    // Indicar espessura
    _drawLabel(canvas, 'e', cx + l / 2 - e / 2, cy - l / 2 + 14,
        AppColors.primary);
  }

  void _drawTuboRetangular(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final w = s * 0.55;
    final h = s * 0.4;
    final e = s * 0.05;

    final outer = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);
    final inner = Rect.fromCenter(
        center: Offset(cx, cy), width: w - 2 * e, height: h - 2 * e);

    final path = Path()
      ..addRect(outer)
      ..addRect(inner);
    path.fillType = PathFillType.evenOdd;

    canvas.drawPath(path, fill);
    canvas.drawRect(outer, paint);
    canvas.drawRect(inner, paint..strokeWidth = 1.5);
    paint.strokeWidth = 2.5;

    _drawDimW(canvas, dim, cx - w / 2, cx + w / 2, cy + h / 2 + 8, 'b');
    _drawDimH(canvas, dim, cx + w / 2 + 8, cy - h / 2, cy + h / 2, 'h');
  }

  void _drawTuboRedondo(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final r = s * 0.27;
    final e = s * 0.04;

    final ringPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r))
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r - e));
    ringPath.fillType = PathFillType.evenOdd;

    canvas.drawPath(ringPath, fill);
    canvas.drawCircle(Offset(cx, cy), r, paint);
    canvas.drawCircle(Offset(cx, cy), r - e, paint..strokeWidth = 1.5);
    paint.strokeWidth = 2.5;

    // Diâmetro externo
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), dim);
    _drawLabel(canvas, 'De', cx, cy - 10, AppColors.primary);
  }

  void _drawTuboOblongo(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final w = s * 0.55;
    final h = s * 0.35;
    final e = s * 0.04;

    final outerRect =
        Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);
    final innerRect = Rect.fromCenter(
        center: Offset(cx, cy), width: w - 2 * e, height: h - 2 * e);

    final outerRR =
        RRect.fromRectAndRadius(outerRect, Radius.circular(h / 2));
    final innerRR = RRect.fromRectAndRadius(
        innerRect, Radius.circular((h - 2 * e) / 2));

    final path = Path()
      ..addRRect(outerRR)
      ..addRRect(innerRR);
    path.fillType = PathFillType.evenOdd;

    canvas.drawPath(path, fill);
    canvas.drawRRect(outerRR, paint);
    canvas.drawRRect(innerRR, paint..strokeWidth = 1.5);
    paint.strokeWidth = 2.5;

    _drawDimW(canvas, dim, cx - w / 2, cx + w / 2, cy + h / 2 + 8, 'b');
    _drawDimH(canvas, dim, cx + w / 2 + 8, cy - h / 2, cy + h / 2, 'h');
  }

  // ===== CHAPAS =====

  void _drawChapa(Canvas canvas, Size size, Paint paint, Paint fill, Paint dim,
      double cx, double cy, double s) {
    // Vista em perspectiva isométrica simples
    final w = s * 0.55;
    final h = s * 0.4;
    final e = s * 0.06;
    final off = s * 0.1; // offset perspectiva

    // Face frontal
    final front = Path()
      ..moveTo(cx - w / 2, cy - h / 2 + off)
      ..lineTo(cx + w / 2, cy - h / 2 + off)
      ..lineTo(cx + w / 2, cy - h / 2 + off + e)
      ..lineTo(cx - w / 2, cy - h / 2 + off + e)
      ..close();

    // Topo
    final top = Path()
      ..moveTo(cx - w / 2, cy - h / 2 + off)
      ..lineTo(cx - w / 2 + off, cy - h / 2)
      ..lineTo(cx + w / 2 + off, cy - h / 2)
      ..lineTo(cx + w / 2, cy - h / 2 + off)
      ..close();

    // Lateral
    final side = Path()
      ..moveTo(cx + w / 2, cy - h / 2 + off)
      ..lineTo(cx + w / 2 + off, cy - h / 2)
      ..lineTo(cx + w / 2 + off, cy - h / 2 + e)
      ..lineTo(cx + w / 2, cy - h / 2 + off + e)
      ..close();

    canvas.drawPath(front, fill);
    canvas.drawPath(top, fill);
    canvas.drawPath(side, fill);
    canvas.drawPath(front, paint);
    canvas.drawPath(top, paint);
    canvas.drawPath(side, paint);

    _drawDimW(canvas, dim, cx - w / 2, cx + w / 2, cy - h / 2 + off + e + 8,
        'largura');
    _drawLabel(canvas, 'esp', cx + w / 2 + 8, cy - h / 2 + off + e / 2,
        AppColors.primary);
  }

  void _drawTelha(Canvas canvas, Size size, Paint paint, Paint fill, Paint dim,
      double cx, double cy, double s) {
    final w = s * 0.7;
    final h = s * 0.35;
    const waves = 4;
    final amplitude = h * 0.35;

    final path = Path();
    final startX = cx - w / 2;
    final startY = cy;

    path.moveTo(startX, startY);
    for (int i = 0; i < waves; i++) {
      final segW = w / waves;
      final x0 = startX + i * segW;
      path.cubicTo(
        x0 + segW * 0.25,
        startY - amplitude,
        x0 + segW * 0.75,
        startY + amplitude,
        x0 + segW,
        startY,
      );
    }

    canvas.drawPath(path, paint);

    _drawDimW(
        canvas, dim, cx - w / 2, cx + w / 2, cy + amplitude + 12, 'largura');
  }

  void _drawChapaExpandida(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final w = s * 0.6;
    final h = s * 0.45;
    final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);

    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, paint);

    // Padrão expandido (losangos)
    final meshPaint = Paint()
      ..color = AppColors.navy.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const rows = 5;
    const cols = 6;
    final cellW = w / cols;
    final cellH = h / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final ccx = cx - w / 2 + cellW * (c + 0.5);
        final ccy = cy - h / 2 + cellH * (r + 0.5);
        final offset = (r % 2 == 0) ? 0.0 : cellW / 2;

        final diamond = Path()
          ..moveTo(ccx + offset, ccy - cellH * 0.3)
          ..lineTo(ccx + offset + cellW * 0.35, ccy)
          ..lineTo(ccx + offset, ccy + cellH * 0.3)
          ..lineTo(ccx + offset - cellW * 0.35, ccy)
          ..close();
        canvas.drawPath(diamond, meshPaint);
      }
    }

    _drawDimW(canvas, dim, cx - w / 2, cx + w / 2, cy + h / 2 + 8, 'b');
    _drawDimH(canvas, dim, cx + w / 2 + 8, cy - h / 2, cy + h / 2, 'h');
  }

  void _drawChapaPerfurada(Canvas canvas, Size size, Paint paint, Paint fill,
      Paint dim, double cx, double cy, double s) {
    final w = s * 0.6;
    final h = s * 0.45;
    final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);

    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, paint);

    // Furos circulares
    final holePaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;
    final holeStroke = Paint()
      ..color = AppColors.navy.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const rows = 4;
    const cols = 5;
    final holeR = math.min(w / (cols * 2.5), h / (rows * 2.5));

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final hx = cx - w / 2 + w / (cols + 1) * (c + 1);
        final hy = cy - h / 2 + h / (rows + 1) * (r + 1);
        canvas.drawCircle(Offset(hx, hy), holeR, holePaint);
        canvas.drawCircle(Offset(hx, hy), holeR, holeStroke);
      }
    }

    _drawDimW(canvas, dim, cx - w / 2, cx + w / 2, cy + h / 2 + 8, 'b');
    _drawDimH(canvas, dim, cx + w / 2 + 8, cy - h / 2, cy + h / 2, 'h');
  }

  void _drawGrade(Canvas canvas, Size size, Paint paint, Paint fill, Paint dim,
      double cx, double cy, double s) {
    final w = s * 0.6;
    final h = s * 0.45;

    final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);
    canvas.drawRect(rect, paint);

    // Grid pattern
    final gridPaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const hBars = 5;
    const vBars = 6;

    for (int i = 0; i <= hBars; i++) {
      final y = cy - h / 2 + (h / hBars) * i;
      canvas.drawLine(Offset(cx - w / 2, y), Offset(cx + w / 2, y), gridPaint);
    }
    for (int i = 0; i <= vBars; i++) {
      final x = cx - w / 2 + (w / vBars) * i;
      canvas.drawLine(Offset(x, cy - h / 2), Offset(x, cy + h / 2), gridPaint);
    }

    _drawDimW(canvas, dim, cx - w / 2, cx + w / 2, cy + h / 2 + 8, 'b');
    _drawDimH(canvas, dim, cx + w / 2 + 8, cy - h / 2, cy + h / 2, 'h');
  }

  // ===== GENÉRICO =====

  void _drawGeneric(Canvas canvas, Size size, Paint paint, Paint fill,
      double cx, double cy, double s) {
    final r = s * 0.3;
    canvas.drawCircle(Offset(cx, cy), r, fill);
    canvas.drawCircle(Offset(cx, cy), r, paint);
    _drawLabel(canvas, '?', cx, cy, AppColors.navy);
  }

  // ===== HELPERS DE COTAS =====

  /// Cota vertical (altura)
  void _drawDimH(Canvas canvas, Paint dim, double x, double top, double bot,
      String label) {
    // Linha vertical
    canvas.drawLine(Offset(x, top), Offset(x, bot), dim);
    // Setas
    const arrowSize = 4.0;
    canvas.drawLine(
        Offset(x - arrowSize, top + arrowSize), Offset(x, top), dim);
    canvas.drawLine(
        Offset(x + arrowSize, top + arrowSize), Offset(x, top), dim);
    canvas.drawLine(
        Offset(x - arrowSize, bot - arrowSize), Offset(x, bot), dim);
    canvas.drawLine(
        Offset(x + arrowSize, bot - arrowSize), Offset(x, bot), dim);

    _drawLabel(canvas, label, x + 8, (top + bot) / 2, AppColors.primary);
  }

  /// Cota horizontal (largura)
  void _drawDimW(Canvas canvas, Paint dim, double left, double right, double y,
      String label) {
    canvas.drawLine(Offset(left, y), Offset(right, y), dim);
    const arrowSize = 4.0;
    canvas.drawLine(
        Offset(left + arrowSize, y - arrowSize), Offset(left, y), dim);
    canvas.drawLine(
        Offset(left + arrowSize, y + arrowSize), Offset(left, y), dim);
    canvas.drawLine(
        Offset(right - arrowSize, y - arrowSize), Offset(right, y), dim);
    canvas.drawLine(
        Offset(right - arrowSize, y + arrowSize), Offset(right, y), dim);

    _drawLabel(canvas, label, (left + right) / 2, y + 10, AppColors.primary);
  }

  /// Desenha label de texto
  void _drawLabel(
      Canvas canvas, String text, double x, double y, Color color) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
        canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _PerfilPainter old) => old.perfilId != perfilId;
}
