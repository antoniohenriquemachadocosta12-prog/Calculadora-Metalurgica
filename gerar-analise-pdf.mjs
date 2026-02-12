import { jsPDF } from 'jspdf';
import autoTable from 'jspdf-autotable';
import fs from 'fs';

const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
const pageWidth = doc.internal.pageSize.getWidth();
const pageHeight = doc.internal.pageSize.getHeight();
const margin = 18;
const contentWidth = pageWidth - margin * 2;
let y = 0;

const colors = {
  orange: [232, 93, 4],
  navy: [26, 26, 46],
  cream: [245, 240, 230],
  darkGray: [40, 40, 40],
  medGray: [100, 100, 100],
  lightGray: [220, 220, 220],
  green: [39, 174, 96],
  red: [192, 57, 43],
  yellow: [243, 156, 18],
  white: [255, 255, 255],
};

function checkPage(needed = 20) {
  if (y + needed > pageHeight - 20) {
    doc.addPage();
    y = 20;
  }
}

function drawHeader() {
  doc.setFillColor(...colors.navy);
  doc.rect(0, 0, pageWidth, 52, 'F');
  doc.setFillColor(...colors.orange);
  doc.rect(0, 52, pageWidth, 3, 'F');

  doc.setTextColor(...colors.white);
  doc.setFontSize(22);
  doc.setFont('helvetica', 'bold');
  doc.text('ANALISE DE PRECIFICACAO', pageWidth / 2, 20, { align: 'center' });

  doc.setFontSize(14);
  doc.setFont('helvetica', 'normal');
  doc.text('Calculadora do Serralheiro - App Android', pageWidth / 2, 30, { align: 'center' });

  doc.setFontSize(9);
  doc.setTextColor(200, 200, 200);
  doc.text('Documento confidencial | Fevereiro 2026', pageWidth / 2, 42, { align: 'center' });

  y = 65;
}

function sectionTitle(text) {
  checkPage(20);
  doc.setFillColor(...colors.orange);
  doc.rect(margin, y - 1, 4, 8, 'F');
  doc.setFontSize(13);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...colors.navy);
  doc.text(text, margin + 8, y + 5);
  y += 14;
}

function subTitle(text) {
  checkPage(14);
  doc.setFontSize(10.5);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...colors.darkGray);
  doc.text(text, margin, y + 4);
  y += 10;
}

function paragraph(text, opts = {}) {
  checkPage(12);
  doc.setFontSize(opts.size || 9.5);
  doc.setFont('helvetica', opts.bold ? 'bold' : 'normal');
  doc.setTextColor(...(opts.color || colors.darkGray));
  const lines = doc.splitTextToSize(text, contentWidth - (opts.indent || 0));
  for (const line of lines) {
    checkPage(6);
    doc.text(line, margin + (opts.indent || 0), y + 4);
    y += 5;
  }
  y += 2;
}

function bulletPoint(text, opts = {}) {
  checkPage(10);
  const indent = opts.indent || 4;
  doc.setFontSize(9.5);
  doc.setFont('helvetica', 'normal');
  doc.setTextColor(...colors.darkGray);
  doc.setFillColor(...colors.orange);
  doc.circle(margin + indent, y + 3, 1, 'F');
  const lines = doc.splitTextToSize(text, contentWidth - indent - 6);
  for (const line of lines) {
    checkPage(6);
    doc.text(line, margin + indent + 4, y + 4);
    y += 5;
  }
  y += 1;
}

function drawTable(headers, rows, opts = {}) {
  checkPage(30);
  autoTable(doc, {
    startY: y,
    head: [headers],
    body: rows,
    margin: { left: margin, right: margin },
    theme: 'grid',
    headStyles: {
      fillColor: opts.headerColor || colors.navy,
      textColor: colors.white,
      fontStyle: 'bold',
      fontSize: 9,
      halign: 'center',
    },
    bodyStyles: {
      fontSize: 8.5,
      textColor: colors.darkGray,
      cellPadding: 3,
    },
    alternateRowStyles: {
      fillColor: [248, 248, 248],
    },
    columnStyles: opts.columnStyles || {},
    didParseCell: opts.didParseCell || undefined,
  });
  y = doc.lastAutoTable.finalY + 8;
}

function highlightBox(text, bgColor, textColor) {
  checkPage(18);
  const lines = doc.splitTextToSize(text, contentWidth - 16);
  const boxH = lines.length * 6 + 8;
  doc.setFillColor(...bgColor);
  doc.roundedRect(margin, y, contentWidth, boxH, 2, 2, 'F');
  doc.setFontSize(10.5);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...textColor);
  let ty = y + 7;
  for (const line of lines) {
    doc.text(line, margin + 8, ty);
    ty += 6;
  }
  y += boxH + 6;
}

function drawFooter(pageNum) {
  doc.setFillColor(...colors.navy);
  doc.rect(0, pageHeight - 12, pageWidth, 12, 'F');
  doc.setFontSize(7);
  doc.setTextColor(180, 180, 180);
  doc.text('MetalCalc Pro - Analise de Precificacao | Confidencial', margin, pageHeight - 5);
  doc.text(`Pagina ${pageNum}`, pageWidth - margin, pageHeight - 5, { align: 'right' });
}

// === PAGE 1 ===
drawHeader();

sectionTitle('1. ESCOPO DO PRODUTO FINAL');
paragraph('App Android offline para serralheiros calcularem peso e custo de perfis metalurgicos, gerarem PDF de orcamento profissional e compartilharem via WhatsApp/email direto para o cliente ou fornecedor.');

subTitle('O que o app faz:');
bulletPoint('Funciona 100% offline - ideal para uso na obra');
bulletPoint('10 tipos de perfis metalurgicos com diagramas tecnicos SVG');
bulletPoint('100 a 250 materiais com busca e filtro por categoria');
bulletPoint('Calculo automatico de peso e valor');
bulletPoint('Geracao de PDF profissional de orcamento');
bulletPoint('Compartilhamento nativo Android (WhatsApp, Gmail, etc.)');

subTitle('O que o app NAO faz:');
bulletPoint('Nao salva dados entre sessoes (PDF e a saida final)');
bulletPoint('Nao precisa de internet, login ou backend');

// === INVENTARIO TECNICO ===
sectionTitle('2. INVENTARIO TECNICO DO MVP');

drawTable(
  ['Metrica', 'Valor'],
  [
    ['Arquivos fonte', '75'],
    ['Linhas de codigo customizado', '~2.600'],
    ['Componentes customizados', '10'],
    ['Telas/Views', '4 (splash, menu, formulario, lista)'],
    ['Perfis metalurgicos', '10 tipos com SVG tecnico'],
    ['Materiais (atual)', '9 (sera expandido para 100-250)'],
    ['Geracao de PDF', 'Sim (jsPDF + autoTable)'],
    ['Stack', 'React 18 + TypeScript + Vite + Tailwind'],
  ],
  { columnStyles: { 0: { fontStyle: 'bold', cellWidth: 65 } } }
);

// === O QUE PRECISA SER FEITO ===
sectionTitle('3. ETAPAS: MVP → PRODUTO FINAL');

drawTable(
  ['Etapa', 'Descricao', 'Horas'],
  [
    ['App Android', 'Empacotar com Capacitor, splash nativa, icone', '12-18h'],
    ['Base de materiais', 'Importar CSV, busca por texto, filtros por categoria', '14-22h'],
    ['Compartilhamento', 'Android Share Intent nativo (WhatsApp, Gmail, etc.)', '6-10h'],
    ['Offline', 'Garantir funcionamento sem internet', '4-6h'],
    ['QA Android', 'Testes em devices, ajustes de tela, teclado, scroll', '10-16h'],
    ['Play Store', 'APK assinado, screenshots, submissao', '6-10h'],
  ],
  {
    columnStyles: {
      0: { fontStyle: 'bold', cellWidth: 38 },
      1: { cellWidth: 95 },
      2: { halign: 'center', cellWidth: 22 },
    },
  }
);

// === ESTIMATIVA DE HORAS ===
sectionTitle('4. ESTIMATIVA TOTAL DE HORAS');

drawTable(
  ['Fase', 'Horas Estimadas', 'Media'],
  [
    ['MVP (ja desenvolvido)', '98 - 140h', '~120h'],
    ['MVP → Produto Final', '52 - 82h', '~65h'],
    ['TOTAL GERAL', '150 - 222h', '~185h'],
  ],
  {
    headerColor: colors.orange,
    columnStyles: {
      0: { fontStyle: 'bold' },
      1: { halign: 'center' },
      2: { halign: 'center', fontStyle: 'bold' },
    },
  }
);

// === PRECIFICACAO ===
sectionTitle('5. PRECIFICACAO DO PROJETO COMPLETO');

subTitle('Referencia por hora:');
drawTable(
  ['Nivel', 'Valor/Hora', 'Total (185h media)'],
  [
    ['Junior (1-2 anos)', 'R$ 50 - 80/h', 'R$ 9.250 - R$ 14.800'],
    ['Pleno (3-5 anos)', 'R$ 80 - 150/h', 'R$ 14.800 - R$ 27.750'],
    ['Senior (5+ anos)', 'R$ 150 - 250/h', 'R$ 27.750 - R$ 46.250'],
  ],
  { columnStyles: { 0: { fontStyle: 'bold' }, 2: { fontStyle: 'bold' } } }
);

subTitle('Preco fechado recomendado:');
drawTable(
  ['Faixa', 'Valor', 'Contexto'],
  [
    ['Minimo', 'R$ 12.000', 'Junior, ganhar experiencia'],
    ['Justo', 'R$ 18.000 - R$ 25.000', 'Valor de mercado para este escopo'],
    ['Premium', 'R$ 30.000 - R$ 35.000', 'Senior, entrega polida'],
  ],
  {
    columnStyles: { 0: { fontStyle: 'bold' }, 1: { fontStyle: 'bold' } },
    didParseCell: (data) => {
      if (data.section === 'body' && data.row.index === 1) {
        data.cell.styles.fillColor = [255, 243, 224];
      }
    },
  }
);

highlightBox('RECOMENDACAO: R$ 20.000 a R$ 28.000 (preco fechado)', colors.orange, colors.white);

// === CUSTOS FIXOS ===
sectionTitle('6. CUSTOS FIXOS');

drawTable(
  ['Item', 'Custo', 'Quem paga'],
  [
    ['Conta Google Play Developer', 'R$ 130 (unica vez)', 'Cliente'],
    ['Apple Developer (se futuro iOS)', '~R$ 500/ano', 'Cliente'],
    ['Dominio (se quiser site)', '~R$ 40/ano', 'Cliente'],
    ['Infraestrutura mensal', 'R$ 0 (app offline)', 'N/A'],
  ],
  { columnStyles: { 0: { fontStyle: 'bold' } } }
);

// === MANUTENCAO ===
sectionTitle('7. MANUTENCAO POS-LANCAMENTO');

drawTable(
  ['Servico', 'Valor mensal'],
  [
    ['Atualizacao de precos de materiais', 'R$ 500 - R$ 1.000'],
    ['Adicionar novos perfis/materiais', 'R$ 500 - R$ 1.000'],
    ['Correcoes de bugs + atualizacao Android', 'R$ 800 - R$ 1.500'],
    ['PACOTE COMPLETO', 'R$ 1.000 - R$ 2.000/mes'],
  ],
  {
    columnStyles: { 0: { fontStyle: 'bold' } },
    didParseCell: (data) => {
      if (data.section === 'body' && data.row.index === 3) {
        data.cell.styles.fillColor = [255, 243, 224];
        data.cell.styles.fontStyle = 'bold';
      }
    },
  }
);

// === PACOTES ===
sectionTitle('8. SUGESTAO DE PACOTES PARA O CLIENTE');

subTitle('Pacote Basico - R$ 20.000');
bulletPoint('App Android completo offline');
bulletPoint('10 perfis metalurgicos com diagramas tecnicos');
bulletPoint('Base de ate 150 materiais (fornecidos pelo cliente)');
bulletPoint('Geracao de PDF profissional');
bulletPoint('Compartilhamento via WhatsApp/email');
bulletPoint('Publicacao na Play Store');
bulletPoint('30 dias de suporte pos-lancamento');

y += 3;
subTitle('Pacote Profissional - R$ 28.000');
bulletPoint('Tudo do Basico +');
bulletPoint('Ate 250 materiais com busca inteligente e filtros');
bulletPoint('Layout premium do PDF com logo do cliente');
bulletPoint('60 dias de suporte pos-lancamento');
bulletPoint('1 rodada de ajustes apos lancamento');

y += 3;
subTitle('Manutencao (opcional) - R$ 1.500/mes');
bulletPoint('Atualizacao de precos e novos materiais');
bulletPoint('Atualizacoes Android e correcoes de bugs');
bulletPoint('Suporte por WhatsApp');

// === CENARIO STARTUP ===
sectionTitle('9. CENARIO STARTUP - ANALISE ESTRATEGICA');

paragraph('O cliente propoe um "valor amigavel" pela calculadora em troca de oportunidade de participar de uma startup futura: um centro de vendas online de materiais de serralheria (e depois marcenaria).', { size: 9.5 });

subTitle('Visao do cliente:');
paragraph('FASE 1 (agora): Calculadora do Serralheiro (app offline)', { indent: 6 });
paragraph('FASE 2 (futuro): Centro de vendas online de materiais de serralheria', { indent: 6 });
paragraph('FASE 3 (futuro): Expandir para marcenaria', { indent: 6 });
y += 2;
paragraph('A calculadora NAO e o negocio. E a porta de entrada para capturar usuarios (serralheiros) que depois serao direcionados para a plataforma de vendas.', { bold: true });

subTitle('3 Cenarios de Negociacao:');

drawTable(
  ['', 'Cenario A', 'Cenario B', 'Cenario C'],
  [
    ['Descricao', 'Valor amigavel puro', 'Valor reduzido + contrato', 'Valor cheio'],
    ['Valor', 'R$ 8-12k', 'R$ 10-14k', 'R$ 20-28k'],
    ['Contrato startup', 'Nao', 'Sim, formal', 'N/A'],
    ['Equity', 'Promessa verbal', '10-20% escrito', '0%'],
    ['Risco financeiro', 'ALTO', 'MODERADO', 'BAIXO'],
    ['Potencial futuro', 'Incerto', 'Protegido', 'Nenhum'],
    ['Recomendacao', 'EVITAR', 'MELHOR OPCAO', 'SEGURO'],
  ],
  {
    columnStyles: { 0: { fontStyle: 'bold', cellWidth: 35 } },
    didParseCell: (data) => {
      if (data.section === 'body' && data.row.index === 6) {
        if (data.column.index === 1) {
          data.cell.styles.textColor = colors.red;
          data.cell.styles.fontStyle = 'bold';
        }
        if (data.column.index === 2) {
          data.cell.styles.textColor = colors.green;
          data.cell.styles.fontStyle = 'bold';
        }
        if (data.column.index === 3) {
          data.cell.styles.textColor = [41, 128, 185];
          data.cell.styles.fontStyle = 'bold';
        }
      }
      if (data.section === 'body' && data.row.index === 4) {
        if (data.column.index === 1) data.cell.styles.textColor = colors.red;
        if (data.column.index === 2) data.cell.styles.textColor = colors.yellow;
        if (data.column.index === 3) data.cell.styles.textColor = colors.green;
      }
    },
  }
);

// === RECOMENDACAO ESTRATEGICA ===
sectionTitle('10. RECOMENDACAO ESTRATEGICA');

highlightBox('Se voce ACREDITA na startup: Cenario B (R$ 12k + contrato com equity)', [39, 174, 96], colors.white);

paragraph('Exija na negociacao:', { bold: true });
bulletPoint('Contrato formal com advogado (escrito e assinado)');
bulletPoint('Equity definido: 10-20% da startup, com vesting de 2 anos');
bulletPoint('Valor minimo da calculadora: R$ 12.000 (nao menos)');
bulletPoint('Clausula de CTO/dev principal para a fase 2 (marketplace)');
bulletPoint('Deixar claro: o desconto dado e um INVESTIMENTO em forma de trabalho');

y += 4;
highlightBox('Se voce TEM DUVIDAS: Cenario C (valor cheio R$ 20-28k)', [41, 128, 185], colors.white);
paragraph('Dinheiro no bolso > promessa futura. Se a startup for boa de verdade, ele vai te procurar de novo. "Porta aberta" sem contrato nao vale desconto.');

// === RED FLAGS ===
sectionTitle('11. BANDEIRAS VERMELHAS (Red Flags)');
paragraph('Cuidado se o cliente:', { bold: true });
bulletPoint('Recusa assinar qualquer tipo de contrato ou acordo');
bulletPoint('Diz que "contrato e coisa de quem nao confia"');
bulletPoint('Nao consegue explicar o modelo de negocio da startup');
bulletPoint('Nao tem capital nenhum (depende 100% de investidor futuro)');
bulletPoint('Ja trocou de desenvolvedor antes por questao de preco');
bulletPoint('Pressiona muito para fechar rapido');

// === VALOR PARA O SERRALHEIRO ===
y += 4;
sectionTitle('12. ARGUMENTOS DE VENDA');
paragraph('Valor que a calculadora entrega para o serralheiro:', { bold: true });
bulletPoint('Velocidade: Orcamento em minutos, nao em horas');
bulletPoint('Profissionalismo: PDF bonito impressiona o cliente');
bulletPoint('Praticidade: Funciona na obra, sem internet');
bulletPoint('Precisao: Calculos exatos, sem erro de conta');
bulletPoint('Agilidade: Envia pedido ao fornecedor na hora');

// Add footers
const totalPages = doc.internal.getNumberOfPages();
for (let i = 1; i <= totalPages; i++) {
  doc.setPage(i);
  drawFooter(i);
}

const output = doc.output('arraybuffer');
fs.writeFileSync('/home/user/Calculadora-Metalurgica/Analise_Precificacao_MetalCalc.pdf', Buffer.from(output));
console.log('PDF gerado com sucesso!');
console.log('Arquivo: Analise_Precificacao_MetalCalc.pdf');
console.log('Paginas:', totalPages);
