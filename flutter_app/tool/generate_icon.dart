// Script para gerar o ícone do app como PNG
// Usa apenas dart:io e gera um PNG manual (sem dependências externas)

import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

/// Gera um PNG simples com o logo "M" em fundo navy com borda laranja
void main() {
  final sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };

  final basePath =
      'android/app/src/main/res';

  for (final entry in sizes.entries) {
    final dir = entry.key;
    final size = entry.value;
    final pixels = _generateIcon(size);
    final png = _encodePng(size, size, pixels);
    final file = File('$basePath/$dir/ic_launcher.png');
    file.writeAsBytesSync(png);
    print('Generated ${file.path} (${size}x$size)');
  }

  // Also generate a 512x512 for Play Store
  final storePixels = _generateIcon(512);
  final storePng = _encodePng(512, 512, storePixels);
  File('assets/images/icon_512.png').writeAsBytesSync(storePng);
  print('Generated assets/images/icon_512.png (512x512)');
}

/// Gera pixels RGBA para o ícone do app
List<int> _generateIcon(int size) {
  final pixels = List<int>.filled(size * size * 4, 0);

  // Cores
  const navyR = 0x1A, navyG = 0x1A, navyB = 0x2E;
  const orangeR = 0xE8, orangeG = 0x5D, orangeB = 0x04;
  const whiteR = 0xFF, whiteG = 0xFF, whiteB = 0xFF;

  final center = size / 2;
  final radius = size / 2;
  final borderWidth = size * 0.06;
  final innerRadius = radius - borderWidth;
  final cornerRadius = size * 0.18;

  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final idx = (y * size + x) * 4;

      // Rounded rectangle check
      if (!_inRoundedRect(
          x.toDouble(), y.toDouble(), 0, 0, size.toDouble(), size.toDouble(), cornerRadius)) {
        pixels[idx] = 0;
        pixels[idx + 1] = 0;
        pixels[idx + 2] = 0;
        pixels[idx + 3] = 0;
        continue;
      }

      // Border area (orange)
      final innerMargin = borderWidth;
      final inInner = _inRoundedRect(x.toDouble(), y.toDouble(), innerMargin,
          innerMargin, size - innerMargin, size - innerMargin, cornerRadius - borderWidth / 2);

      if (!inInner) {
        pixels[idx] = orangeR;
        pixels[idx + 1] = orangeG;
        pixels[idx + 2] = orangeB;
        pixels[idx + 3] = 255;
        continue;
      }

      // Check if pixel is part of the "M" letter
      final mScale = size * 0.55;
      final mLeft = center - mScale / 2;
      final mTop = center - mScale * 0.4;
      final mBot = center + mScale * 0.45;
      final strokeW = mScale * 0.14;

      final fx = (x - mLeft) / mScale;
      final fy = (y - mTop) / (mBot - mTop);

      bool isM = false;

      if (fx >= 0 && fx <= 1 && fy >= 0 && fy <= 1) {
        final sw = strokeW / mScale;

        // Left vertical bar
        if (fx >= 0 && fx <= sw) isM = true;

        // Right vertical bar
        if (fx >= 1 - sw && fx <= 1) isM = true;

        // Left diagonal (going down from top-left to center)
        final diagCenter = 0.5;
        final diagSlope = diagCenter / 0.5; // slope for the diagonal

        // Left diagonal stroke
        final targetXL = fx * diagSlope;
        if (fy >= 0 && fy <= 0.55) {
          if ((fx - fy / diagSlope).abs() < sw * 0.8) isM = true;
        }

        // Right diagonal stroke
        if (fy >= 0 && fy <= 0.55) {
          if ((fx - (1.0 - fy / diagSlope)).abs() < sw * 0.8) isM = true;
        }

        // Top-left horizontal connection
        if (fy <= sw && fx >= 0 && fx <= sw * 2) isM = true;
        // Top-right horizontal connection
        if (fy <= sw && fx >= 1 - sw * 2 && fx <= 1) isM = true;
      }

      if (isM) {
        pixels[idx] = whiteR;
        pixels[idx + 1] = whiteG;
        pixels[idx + 2] = whiteB;
        pixels[idx + 3] = 255;
      } else {
        pixels[idx] = navyR;
        pixels[idx + 1] = navyG;
        pixels[idx + 2] = navyB;
        pixels[idx + 3] = 255;
      }
    }
  }

  return pixels;
}

bool _inRoundedRect(
    double x, double y, double l, double t, double r, double b, double cr) {
  if (x < l || x >= r || y < t || y >= b) return false;

  // Check corners
  if (x < l + cr && y < t + cr) {
    return _dist(x, y, l + cr, t + cr) <= cr;
  }
  if (x >= r - cr && y < t + cr) {
    return _dist(x, y, r - cr, t + cr) <= cr;
  }
  if (x < l + cr && y >= b - cr) {
    return _dist(x, y, l + cr, b - cr) <= cr;
  }
  if (x >= r - cr && y >= b - cr) {
    return _dist(x, y, r - cr, b - cr) <= cr;
  }
  return true;
}

double _dist(double x1, double y1, double x2, double y2) {
  return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
}

/// Encodes RGBA pixel data into a minimal PNG file
Uint8List _encodePng(int width, int height, List<int> pixels) {
  // PNG file structure:
  // Signature + IHDR + IDAT + IEND

  final rawData = <int>[];

  // Build raw image data (filter byte 0 = None for each row, then RGBA pixels)
  for (int y = 0; y < height; y++) {
    rawData.add(0); // filter: None
    for (int x = 0; x < width; x++) {
      final idx = (y * width + x) * 4;
      rawData.add(pixels[idx]); // R
      rawData.add(pixels[idx + 1]); // G
      rawData.add(pixels[idx + 2]); // B
      rawData.add(pixels[idx + 3]); // A
    }
  }

  // Compress with DEFLATE (zlib)
  final compressed = zlib.encode(rawData);

  final out = BytesBuilder();

  // PNG Signature
  out.add([137, 80, 78, 71, 13, 10, 26, 10]);

  // IHDR chunk
  final ihdr = BytesBuilder();
  ihdr.add(_uint32(width));
  ihdr.add(_uint32(height));
  ihdr.addByte(8); // bit depth
  ihdr.addByte(6); // color type: RGBA
  ihdr.addByte(0); // compression
  ihdr.addByte(0); // filter
  ihdr.addByte(0); // interlace
  _writeChunk(out, 'IHDR', ihdr.toBytes());

  // IDAT chunk
  _writeChunk(out, 'IDAT', Uint8List.fromList(compressed));

  // IEND chunk
  _writeChunk(out, 'IEND', Uint8List(0));

  return out.toBytes();
}

void _writeChunk(BytesBuilder out, String type, Uint8List data) {
  out.add(_uint32(data.length));
  final typeBytes = type.codeUnits;
  out.add(typeBytes);

  // CRC covers type + data
  final crcData = <int>[...typeBytes, ...data];
  out.add(data);
  out.add(_uint32(_crc32(crcData)));
}

Uint8List _uint32(int value) {
  return Uint8List(4)
    ..[0] = (value >> 24) & 0xFF
    ..[1] = (value >> 16) & 0xFF
    ..[2] = (value >> 8) & 0xFF
    ..[3] = value & 0xFF;
}

// CRC32 implementation for PNG
int _crc32(List<int> data) {
  int crc = 0xFFFFFFFF;
  for (final byte in data) {
    crc ^= byte;
    for (int i = 0; i < 8; i++) {
      if (crc & 1 != 0) {
        crc = (crc >> 1) ^ 0xEDB88320;
      } else {
        crc >>= 1;
      }
    }
  }
  return crc ^ 0xFFFFFFFF;
}
