import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../models/projeto_model.dart';
import 'calculos.dart';

class PdfGenerator {
  static const _navy = PdfColor.fromInt(0xFF1A1A2E);
  static const _orange = PdfColor.fromInt(0xFFE85D04);
  static const _dark = PdfColor.fromInt(0xFF1E1E1E);
  static const _medium = PdfColor.fromInt(0xFF505050);
  static const _cream = PdfColor.fromInt(0xFFEBE4D9);
  static const _white = PdfColor.fromInt(0xFFFFFFFF);

  static const _orangeColor = Color(0xFFE85D04);

  /// Gera PDF e abre modal de compartilhamento
  static Future<void> gerarECompartilhar({
    required List<Projeto> projetos,
    required EmpresaInfo empresa,
    required ClienteInfo cliente,
    required BuildContext context,
  }) async {
    final pdfDoc = await _gerarDocumento(projetos, empresa, cliente);
    final bytes = await pdfDoc.save();

    // Salvar em arquivo temporário
    final dir = await getTemporaryDirectory();
    final dataStr = DateFormat('yyyy-MM-dd_HHmm').format(DateTime.now());
    final fileName = 'orcamento_$dataStr.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);

    if (!context.mounted) return;

    // Mostrar opções: Visualizar ou Compartilhar
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PDF Gerado!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.visibility, color: _orangeColor),
                title: const Text('Visualizar PDF'),
                onTap: () {
                  Navigator.pop(ctx);
                  _visualizar(context, Uint8List.fromList(bytes), fileName);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: _orangeColor),
                title: const Text('Compartilhar'),
                subtitle: const Text('WhatsApp, Gmail, Telegram...'),
                onTap: () {
                  Navigator.pop(ctx);
                  Share.shareXFiles(
                    [XFile(file.path)],
                    text: 'Orçamento - Calculadora do Serralheiro',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.print, color: _orangeColor),
                title: const Text('Imprimir'),
                onTap: () {
                  Navigator.pop(ctx);
                  Printing.layoutPdf(
                      onLayout: (_) async => Uint8List.fromList(bytes));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _visualizar(
      BuildContext context, Uint8List bytes, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: PdfPreview(
            build: (_) async => bytes,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
          ),
        ),
      ),
    );
  }

  /// Gera o documento PDF
  static Future<pw.Document> _gerarDocumento(
    List<Projeto> projetos,
    EmpresaInfo empresa,
    ClienteInfo cliente,
  ) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.robotoRegular(),
        bold: await PdfGoogleFonts.robotoBold(),
      ),
    );

    final pesoTotal = projetos.fold(0.0, (s, p) => s + p.resultado.pesoTotal);
    final valorTotal =
        projetos.fold(0.0, (s, p) => s + p.resultado.valorTotal);
    final dataStr = DateFormat('dd/MM/yyyy').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _header(empresa, dataStr),
        footer: (context) => _footer(context),
        build: (context) => [
          // Info do cliente
          if (!cliente.isEmpty) _clienteSection(cliente),

          pw.SizedBox(height: 12),

          // Tabela de materiais
          pw.TableHelper.fromTextArray(
            context: context,
            border: pw.TableBorder.all(color: _navy, width: 0.5),
            headerStyle: pw.TextStyle(
              color: _white,
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(color: _navy),
            cellStyle: const pw.TextStyle(fontSize: 8, color: _dark),
            cellAlignment: pw.Alignment.center,
            cellPadding: const pw.EdgeInsets.all(5),
            headers: ['#', 'Perfil', 'Material', 'Qtd', 'Peso (kg)', 'Valor (R\$)'],
            data: projetos.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              return [
                '${i + 1}',
                p.nomePerfil,
                p.material.nome,
                '${p.quantidade}',
                p.resultado.pesoTotal.toStringAsFixed(3),
                p.resultado.valorTotal.toStringAsFixed(2),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 12),

          // Totais
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: _navy,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('PESO TOTAL',
                        style: pw.TextStyle(
                            color: _cream,
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(Calculos.formatarPeso(pesoTotal),
                        style: pw.TextStyle(
                            color: _white,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('VALOR TOTAL',
                        style: pw.TextStyle(
                            color: _cream,
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(Calculos.formatarValor(valorTotal),
                        style: pw.TextStyle(
                            color: _orange,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Observações do cliente
          if (cliente.obs.isNotEmpty) ...[
            pw.Text('Observações:',
                style: pw.TextStyle(
                    fontSize: 9, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text(cliente.obs,
                style: const pw.TextStyle(fontSize: 8, color: _medium)),
          ],
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _header(EmpresaInfo empresa, String data) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: _navy,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('CALCULADORA DO SERRALHEIRO',
                        style: pw.TextStyle(
                            color: _orange,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold)),
                    if (empresa.nome.isNotEmpty)
                      pw.Text(empresa.nome,
                          style: const pw.TextStyle(
                              color: _white, fontSize: 9)),
                    if (empresa.cnpj.isNotEmpty)
                      pw.Text('CNPJ: ${empresa.cnpj}',
                          style: const pw.TextStyle(
                              color: _cream, fontSize: 7)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('ORÇAMENTO',
                        style: pw.TextStyle(
                            color: _white,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(data,
                        style:
                            const pw.TextStyle(color: _cream, fontSize: 8)),
                  ],
                ),
              ],
            ),
          ),
          pw.Container(height: 2, color: _orange),
        ],
      ),
    );
  }

  static pw.Widget _footer(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Gerado por Calculadora do Serralheiro',
            style: const pw.TextStyle(color: _medium, fontSize: 7),
          ),
          pw.Text(
            'Página ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(color: _medium, fontSize: 7),
          ),
        ],
      ),
    );
  }

  static pw.Widget _clienteSection(ClienteInfo cliente) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _cream,
        borderRadius: pw.BorderRadius.circular(4),
        border: pw.Border.all(color: _navy, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('CLIENTE',
              style: pw.TextStyle(
                  color: _orange,
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold)),
          if (cliente.nome.isNotEmpty)
            pw.Text(cliente.nome,
                style: pw.TextStyle(
                    fontSize: 10, fontWeight: pw.FontWeight.bold)),
          if (cliente.telefone.isNotEmpty)
            pw.Text('Tel: ${cliente.telefone}',
                style: const pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
  }
}
