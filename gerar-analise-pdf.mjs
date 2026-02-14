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

subTitle('Valor por hora em cada cenario (~185h):');
drawTable(
  ['Cenario', 'Valor Total', 'Valor/Hora', 'Equivalente a'],
  [
    ['Cenario A', 'R$ 8.000', '~R$ 43/h', 'Abaixo de Junior'],
    ['Cenario B', 'R$ 10.000', '~R$ 54/h', 'Junior'],
    ['Cenario C', 'R$ 15.000', '~R$ 81/h', 'Pleno (inicio)'],
  ],
  {
    columnStyles: { 0: { fontStyle: 'bold' }, 1: { fontStyle: 'bold' } },
    didParseCell: (data) => {
      if (data.section === 'body' && data.row.index === 2) {
        data.cell.styles.fillColor = [255, 243, 224];
      }
    },
  }
);

subTitle('Referencia de mercado:');
drawTable(
  ['Nivel', 'Valor/Hora mercado', 'Total (185h)'],
  [
    ['Junior (1-2 anos)', 'R$ 50 - 80/h', 'R$ 9.250 - R$ 14.800'],
    ['Pleno (3-5 anos)', 'R$ 80 - 150/h', 'R$ 14.800 - R$ 27.750'],
    ['Senior (5+ anos)', 'R$ 150 - 250/h', 'R$ 27.750 - R$ 46.250'],
  ],
  { columnStyles: { 0: { fontStyle: 'bold' }, 2: { fontStyle: 'bold' } } }
);

paragraph('Nota: Mesmo o Cenario C (R$ 15k) esta abaixo do valor de mercado pleno. Os 3 cenarios representam condicoes especiais de negociacao.', { bold: true });

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

subTitle('Cenario A - R$ 8.000 (valor amigavel, SEM contrato)');
bulletPoint('App Android completo offline');
bulletPoint('10 perfis metalurgicos com diagramas tecnicos');
bulletPoint('Base de materiais basica');
bulletPoint('Geracao de PDF e compartilhamento');
bulletPoint('Publicacao na Play Store');
bulletPoint('SEM participacao na startup');
bulletPoint('SEM contrato formal de sociedade');

y += 3;
subTitle('Cenario B - R$ 10.000 (valor reduzido + contrato formal)');
bulletPoint('Tudo do Cenario A +');
bulletPoint('Ate 150 materiais com busca e filtros');
bulletPoint('Layout profissional do PDF');
bulletPoint('30 dias de suporte pos-lancamento');
bulletPoint('CONTRATO FORMAL de participacao na startup');
bulletPoint('Percentual de equity definido em contrato');

y += 3;
subTitle('Cenario C - R$ 15.000 (valor fechado, sem startup)');
bulletPoint('App completo com todas as funcionalidades');
bulletPoint('Ate 250 materiais com busca inteligente e filtros');
bulletPoint('Layout premium do PDF com logo do cliente');
bulletPoint('60 dias de suporte pos-lancamento');
bulletPoint('1 rodada de ajustes apos lancamento');
bulletPoint('Sem vinculo com startup - entrega e encerra');

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
    ['Descricao', 'Valor amigavel', 'Valor + contrato startup', 'Valor fechado'],
    ['Valor', 'R$ 8.000', 'R$ 10.000', 'R$ 15.000'],
    ['Valor/hora', '~R$ 43/h', '~R$ 54/h', '~R$ 81/h'],
    ['Contrato formal', 'Nao', 'Sim, com advogado', 'Contrato simples'],
    ['Equity na startup', 'Nenhum', 'A definir (%)', '0%'],
    ['Participacao futura', 'Promessa verbal', 'Garantida em contrato', 'Nenhuma'],
    ['Risco financeiro', 'ALTO', 'MODERADO', 'BAIXO'],
    ['Recomendacao', 'EVITAR', 'NEGOCIAR', 'SEGURO'],
  ],
  {
    columnStyles: { 0: { fontStyle: 'bold', cellWidth: 35 } },
    didParseCell: (data) => {
      if (data.section === 'body' && data.row.index === 7) {
        if (data.column.index === 1) {
          data.cell.styles.textColor = colors.red;
          data.cell.styles.fontStyle = 'bold';
        }
        if (data.column.index === 2) {
          data.cell.styles.textColor = colors.yellow;
          data.cell.styles.fontStyle = 'bold';
        }
        if (data.column.index === 3) {
          data.cell.styles.textColor = colors.green;
          data.cell.styles.fontStyle = 'bold';
        }
      }
      if (data.section === 'body' && data.row.index === 6) {
        if (data.column.index === 1) data.cell.styles.textColor = colors.red;
        if (data.column.index === 2) data.cell.styles.textColor = colors.yellow;
        if (data.column.index === 3) data.cell.styles.textColor = colors.green;
      }
    },
  }
);

// === CONTRATO E PERCENTUAL ===
sectionTitle('10. CONTRATO FORMAL - O QUE EXIGIR');

paragraph('Se optar pelo Cenario B (R$ 10k + participacao na startup), o contrato PRECISA conter:', { bold: true });
y += 2;

subTitle('Clausulas obrigatorias no contrato:');
bulletPoint('Identificacao completa das partes (CPF/CNPJ, endereco)');
bulletPoint('Descricao detalhada do projeto: Calculadora do Serralheiro (escopo, funcionalidades)');
bulletPoint('Valor: R$ 10.000 pelo desenvolvimento do app');
bulletPoint('Reconhecimento formal: o desconto de R$ 5.000 a R$ 18.000 (diferenca do valor de mercado) e um INVESTIMENTO do desenvolvedor');

y += 2;
subTitle('Percentual de participacao (equity):');

drawTable(
  ['Percentual', 'Justificativa', 'Quando faz sentido'],
  [
    ['5%', 'Simbolico, cliente nao quer ceder muito', 'Se voce so quer manter a porta aberta'],
    ['10%', 'Justo para o desconto dado', 'Equilibrio entre risco e recompensa'],
    ['15%', 'Reflete o investimento real em trabalho', 'Se voce vai ser o dev principal da fase 2'],
    ['20%+', 'Socio tecnico de fato', 'Se voce assume papel de CTO da startup'],
  ],
  {
    columnStyles: { 0: { fontStyle: 'bold', halign: 'center', cellWidth: 25 } },
    didParseCell: (data) => {
      if (data.section === 'body' && data.row.index === 1) {
        data.cell.styles.fillColor = [255, 243, 224];
      }
      if (data.section === 'body' && data.row.index === 2) {
        data.cell.styles.fillColor = [232, 245, 233];
      }
    },
  }
);

highlightBox('SUGESTAO: Pedir 10% a 15% com vesting de 2 anos', colors.orange, colors.white);

paragraph('O que significa vesting de 2 anos:', { bold: true });
bulletPoint('Voce NAO recebe os 10-15% de uma vez');
bulletPoint('Recebe proporcionalmente ao longo de 24 meses (ex: ~0.5% por mes)');
bulletPoint('Se a startup acabar no mes 6, voce tem direito a 1/4 do equity');
bulletPoint('Protege ambos os lados: voce so ganha se continuar contribuindo');

y += 2;
subTitle('Outras clausulas importantes:');
bulletPoint('Direito de preferencia: se o cliente vender a startup, voce tem prioridade de compra');
bulletPoint('Clausula anti-diluicao: seu percentual nao pode ser diluido sem seu consentimento');
bulletPoint('Papel definido na fase 2: desenvolvedor principal / CTO / consultor tecnico');
bulletPoint('Propriedade intelectual: o codigo da calculadora e seu ate o pagamento integral');
bulletPoint('Foro da comarca para resolucao de disputas');

y += 4;
sectionTitle('11. RECOMENDACAO FINAL');

highlightBox('Cenario B (R$ 10k + contrato com 10-15% equity) = MELHOR OPCAO se voce acredita no projeto', [39, 174, 96], colors.white);

paragraph('Por que:', { bold: true });
bulletPoint('Voce recebe R$ 10k agora (garante pagamento pelo trabalho)');
bulletPoint('O contrato protege seu investimento de ~R$ 8-18k em trabalho');
bulletPoint('Se a startup der certo, 10-15% de um marketplace pode valer muito');
bulletPoint('Se nao der certo, voce pelo menos recebeu R$ 10k e tem o portfolio');

y += 4;
highlightBox('Cenario C (R$ 15k fechado) = OPCAO SEGURA se tiver duvidas', [41, 128, 185], colors.white);
paragraph('Dinheiro no bolso > promessa futura. R$ 15k e um valor justo considerando a relacao com o cliente. Se a startup for boa de verdade, ele vai te procurar de novo para a fase 2.');

// === RED FLAGS ===
sectionTitle('12. BANDEIRAS VERMELHAS (Red Flags)');
paragraph('Cuidado se o cliente:', { bold: true });
bulletPoint('Recusa assinar qualquer tipo de contrato ou acordo');
bulletPoint('Diz que "contrato e coisa de quem nao confia"');
bulletPoint('Nao consegue explicar o modelo de negocio da startup');
bulletPoint('Nao tem capital nenhum (depende 100% de investidor futuro)');
bulletPoint('Ja trocou de desenvolvedor antes por questao de preco');
bulletPoint('Pressiona muito para fechar rapido');

// === VALOR PARA O SERRALHEIRO ===
y += 4;
sectionTitle('13. ARGUMENTOS DE VENDA');
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
