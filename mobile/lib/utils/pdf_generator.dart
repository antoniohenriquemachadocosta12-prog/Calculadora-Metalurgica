import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/projeto.dart';

final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _peso = NumberFormat('#,##0.000', 'pt_BR');
final _data = DateFormat('dd/MM/yyyy', 'pt_BR');

Future<Uint8List> gerarPdfProjeto(Projeto projeto) async {
  final pdf = pw.Document();

  final navyColor = PdfColor.fromHex('1B2B4B');
  final orangeColor = PdfColor.fromHex('E07B39');
  final tealColor = PdfColor.fromHex('2A9D8F');
  final creamColor = PdfColor.fromHex('F5F0E8');
  final grayColor = PdfColor.fromHex('4A4A4A');

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (ctx) => _buildHeader(ctx, projeto, navyColor, orangeColor, creamColor),
      footer: (ctx) => _buildFooter(ctx, grayColor),
      build: (ctx) => [
        pw.SizedBox(height: 16),
        if (projeto.cliente.nome.isNotEmpty) _buildClienteSection(projeto, navyColor, creamColor),
        pw.SizedBox(height: 16),
        _buildItensTable(projeto, navyColor, orangeColor, tealColor, grayColor),
        pw.SizedBox(height: 16),
        _buildResumo(projeto, navyColor, orangeColor),
        if (projeto.cliente.observacoes.isNotEmpty) ...[
          pw.SizedBox(height: 16),
          _buildObservacoes(projeto, grayColor),
        ],
      ],
    ),
  );

  return pdf.save();
}

pw.Widget _buildHeader(
  pw.Context ctx,
  Projeto projeto,
  PdfColor navy,
  PdfColor orange,
  PdfColor cream,
) {
  return pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 16),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: orange, width: 2)),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              projeto.empresa.nome.isNotEmpty ? projeto.empresa.nome : 'MetalCalc Pro',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: navy,
              ),
            ),
            if (projeto.empresa.cnpj.isNotEmpty)
              pw.Text(
                'CNPJ: ${projeto.empresa.cnpj}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            if (projeto.empresa.telefone.isNotEmpty)
              pw.Text(
                'Tel: ${projeto.empresa.telefone}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            if (projeto.empresa.email.isNotEmpty)
              pw.Text(
                projeto.empresa.email,
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: pw.BoxDecoration(
                color: navy,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                'ORÇAMENTO',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              projeto.nome,
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: navy),
            ),
            pw.Text(
              'Data: ${_data.format(projeto.dataCriacao)}',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _buildClienteSection(Projeto projeto, PdfColor navy, PdfColor cream) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: cream,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'DADOS DO CLIENTE',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: navy),
        ),
        pw.SizedBox(height: 4),
        pw.Text('Nome: ${projeto.cliente.nome}', style: const pw.TextStyle(fontSize: 11)),
        if (projeto.cliente.telefone.isNotEmpty)
          pw.Text('Telefone: ${projeto.cliente.telefone}', style: const pw.TextStyle(fontSize: 11)),
      ],
    ),
  );
}

pw.Widget _buildItensTable(
  Projeto projeto,
  PdfColor navy,
  PdfColor orange,
  PdfColor teal,
  PdfColor gray,
) {
  final headers = ['#', 'Perfil / Material', 'Qtd', 'Comp.(m)', 'Peso Unit.(kg/m)', 'Peso Total(kg)', 'Valor Unit.(R\$)', 'Valor Total(R\$)'];

  return pw.TableHelper.fromTextArray(
    headers: headers,
    data: List.generate(projeto.itens.length, (i) {
      final item = projeto.itens[i];
      final r = item.resultado;
      return [
        '${i + 1}',
        '${item.nomePerfil}\n${r.material.nome}',
        '${item.quantidade}',
        item.comprimento == 1 ? '-' : _peso.format(item.comprimento),
        _peso.format(r.pesoUnitario),
        _peso.format(r.pesoTotal),
        _moeda.format(r.valorUnitario),
        _moeda.format(r.valorTotal),
      ];
    }),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
      fontSize: 9,
    ),
    headerDecoration: pw.BoxDecoration(color: navy),
    cellStyle: const pw.TextStyle(fontSize: 9),
    cellAlignments: {
      0: pw.Alignment.center,
      1: pw.Alignment.centerLeft,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
      4: pw.Alignment.centerRight,
      5: pw.Alignment.centerRight,
      6: pw.Alignment.centerRight,
      7: pw.Alignment.centerRight,
    },
    oddRowDecoration: pw.BoxDecoration(color: PdfColor.fromHex('F9F9F9')),
    border: pw.TableBorder.all(color: PdfColor.fromHex('E0E0E0'), width: 0.5),
  );
}

pw.Widget _buildResumo(Projeto projeto, PdfColor navy, PdfColor orange) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.end,
    children: [
      pw.Container(
        width: 260,
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: navy,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Peso Total:',
                  style: pw.TextStyle(color: PdfColors.white, fontSize: 11),
                ),
                pw.Text(
                  '${_peso.format(projeto.totalPeso)} kg',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Divider(color: PdfColor.fromHex('FFFFFF60'), thickness: 0.5),
            pw.SizedBox(height: 6),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'VALOR TOTAL:',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                pw.Text(
                  _moeda.format(projeto.totalValor),
                  style: pw.TextStyle(
                    color: orange,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildObservacoes(Projeto projeto, PdfColor gray) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColor.fromHex('E0E0E0')),
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'OBSERVAÇÕES:',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: gray),
        ),
        pw.SizedBox(height: 4),
        pw.Text(projeto.cliente.observacoes, style: const pw.TextStyle(fontSize: 10)),
      ],
    ),
  );
}

pw.Widget _buildFooter(pw.Context ctx, PdfColor gray) {
  return pw.Container(
    padding: const pw.EdgeInsets.only(top: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(top: pw.BorderSide(color: PdfColor.fromHex('E0E0E0'), width: 0.5)),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'MetalCalc Pro — Calculadora Metalúrgica',
          style: pw.TextStyle(fontSize: 9, color: gray),
        ),
        pw.Text(
          'Página ${ctx.pageNumber} de ${ctx.pagesCount}',
          style: pw.TextStyle(fontSize: 9, color: gray),
        ),
      ],
    ),
  );
}
