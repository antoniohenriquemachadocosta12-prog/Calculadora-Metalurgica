import { jsPDF } from 'jspdf';
import autoTable from 'jspdf-autotable';
import fs from 'fs';

const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
const W = doc.internal.pageSize.getWidth();
const H = doc.internal.pageSize.getHeight();
const m = 18;
const cw = W - m * 2;
let y = 0;

const C = {
  orange: [232, 93, 4],
  navy: [26, 26, 46],
  dark: [40, 40, 40],
  med: [100, 100, 100],
  light: [245, 245, 245],
  green: [39, 174, 96],
  red: [192, 57, 43],
  blue: [41, 128, 185],
  yellow: [243, 156, 18],
  white: [255, 255, 255],
  cream: [255, 248, 240],
};

function np(need = 20) { if (y + need > H - 20) { doc.addPage(); y = 20; } }

function footer(n) {
  doc.setFillColor(...C.navy);
  doc.rect(0, H - 12, W, 12, 'F');
  doc.setFontSize(7);
  doc.setTextColor(170, 170, 170);
  doc.text('Proposta Comercial | Calculadora do Serralheiro | Confidencial', m, H - 5);
  doc.text(`${n}`, W - m, H - 5, { align: 'right' });
}

function sec(text) {
  np(22);
  doc.setFillColor(...C.orange);
  doc.rect(m, y - 1, 4, 9, 'F');
  doc.setFontSize(14);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...C.navy);
  doc.text(text, m + 8, y + 6);
  y += 16;
}

function sub(text) {
  np(14);
  doc.setFontSize(11);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...C.dark);
  doc.text(text, m, y + 4);
  y += 10;
}

function p(text, opts = {}) {
  np(10);
  doc.setFontSize(opts.s || 9.5);
  doc.setFont('helvetica', opts.b ? 'bold' : 'normal');
  doc.setTextColor(...(opts.c || C.dark));
  const lines = doc.splitTextToSize(text, cw - (opts.i || 0));
  for (const l of lines) { np(6); doc.text(l, m + (opts.i || 0), y + 4); y += 5; }
  y += 2;
}

function bp(text, opts = {}) {
  np(10);
  const ind = opts.i || 4;
  doc.setFontSize(9.5);
  doc.setFont('helvetica', opts.b ? 'bold' : 'normal');
  doc.setTextColor(...C.dark);
  doc.setFillColor(...C.orange);
  doc.circle(m + ind, y + 3, 1, 'F');
  const lines = doc.splitTextToSize(text, cw - ind - 6);
  for (const l of lines) { np(6); doc.text(l, m + ind + 4, y + 4); y += 5; }
  y += 1;
}

function tbl(h, r, o = {}) {
  np(30);
  autoTable(doc, {
    startY: y, head: [h], body: r,
    margin: { left: m, right: m }, theme: 'grid',
    headStyles: { fillColor: o.hc || C.navy, textColor: C.white, fontStyle: 'bold', fontSize: 9, halign: 'center' },
    bodyStyles: { fontSize: 8.5, textColor: C.dark, cellPadding: 3 },
    alternateRowStyles: { fillColor: [248, 248, 248] },
    columnStyles: o.cs || {},
    didParseCell: o.dp || undefined,
  });
  y = doc.lastAutoTable.finalY + 8;
}

function box(text, bg, tc, center = false) {
  np(18);
  const lines = doc.splitTextToSize(text, cw - 16);
  const bh = lines.length * 6 + 10;
  doc.setFillColor(...bg);
  doc.roundedRect(m, y, cw, bh, 2, 2, 'F');
  doc.setFontSize(11);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...tc);
  let ty = y + 8;
  for (const l of lines) {
    if (center) {
      doc.text(l, m + cw / 2, ty, { align: 'center' });
    } else {
      doc.text(l, m + 8, ty);
    }
    ty += 6;
  }
  y += bh + 6;
}

function divider() {
  np(8);
  doc.setDrawColor(...C.light);
  doc.setLineWidth(0.3);
  doc.line(m, y, W - m, y);
  y += 6;
}

// ============================================================
// CAPA
// ============================================================
doc.setFillColor(...C.navy);
doc.rect(0, 0, W, H, 'F');

// Faixa laranja decorativa
doc.setFillColor(...C.orange);
doc.rect(0, 85, W, 4, 'F');
doc.rect(0, H - 40, W, 2, 'F');

// Titulo
doc.setTextColor(...C.white);
doc.setFontSize(32);
doc.setFont('helvetica', 'bold');
doc.text('PROPOSTA COMERCIAL', W / 2, 55, { align: 'center' });

doc.setFontSize(18);
doc.setFont('helvetica', 'normal');
doc.text('Calculadora do Serralheiro', W / 2, 68, { align: 'center' });

doc.setFontSize(12);
doc.setTextColor(...C.orange);
doc.text('Aplicativo Android para Calculo de Peso Metalurgico', W / 2, 78, { align: 'center' });

// Info box central
doc.setFillColor(35, 35, 55);
doc.roundedRect(35, 105, W - 70, 80, 4, 4, 'F');

doc.setFontSize(10);
doc.setTextColor(200, 200, 200);
const info = [
  ['Tipo:', 'Aplicativo Android Nativo (offline)'],
  ['Stack:', 'React 18 + TypeScript + Vite + Tailwind CSS'],
  ['Funcionalidades:', 'Ate 250 perfis | PDF profissional | Compartilhamento'],
  ['Plataforma:', 'Android (Google Play Store)'],
  ['Status:', 'MVP funcional em desenvolvimento'],
];
let iy = 118;
for (const [label, val] of info) {
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...C.orange);
  doc.text(label, 45, iy);
  doc.setFont('helvetica', 'normal');
  doc.setTextColor(200, 200, 200);
  doc.text(val, 80, iy);
  iy += 12;
}

// Rodape capa
doc.setFontSize(10);
doc.setTextColor(140, 140, 140);
doc.text('Documento confidencial', W / 2, H - 28, { align: 'center' });
doc.text('Fevereiro 2026', W / 2, H - 20, { align: 'center' });

// ============================================================
// PAGINA 2 - SOBRE O PROJETO
// ============================================================
doc.addPage();
y = 20;

sec('1. O PROJETO');

p('A Calculadora do Serralheiro e um aplicativo Android 100% offline que permite ao profissional de serralheria calcular o peso dos perfis metalurgicos, gerar o peso total em PDF profissional e compartilhar diretamente com clientes e fornecedores via WhatsApp ou email.');
y += 2;

sub('Problema que resolve:');
bp('Serralheiros perdem tempo fazendo calculos manuais em papeis ou em planilhas improvisadas');
bp('Calculos feitos "de cabeca" levam a erros de precificacao e prejuizo');
bp('Falta de profissionalismo na apresentacao da lista de materiais ao cliente');
bp('Dificuldade de acesso a internet em obras e oficinas');

y += 2;
sub('Solucao entregue:');
bp('Calculos automaticos e precisos para ate 250 tipos de perfis metalurgicos');
bp('Base com ate 250 materiais e precos atualizaveis');
bp('PDF profissional gerado em segundos com a lista de materiais e nome do aplicativo');
bp('Compartilhamento instantaneo (WhatsApp, Gmail, etc.)');
bp('Funciona 100% sem internet - a mensagem so sera enviada quando o usuario estiver conectado');

// ============================================================
// FUNCIONALIDADES DETALHADAS
// ============================================================
y += 4;
sec('2. FUNCIONALIDADES DO APP');

sub('2.1 Perfis Metalurgicos (10 tipos)');
p('Cada perfil possui diagrama tecnico SVG interativo e formulas de calculo especificas:');

tbl(
  ['Perfil', 'Medidas Necessarias'],
  [
    ['Perfil "C"', 'Altura, largura, aba, espessura, comprimento'],
    ['Perfil "U"', 'Altura, largura, espessura, comprimento'],
    ['Barra Quadrada', 'Lado, comprimento'],
    ['Barra Retangular', 'Largura, altura, comprimento'],
    ['Barra Redonda', 'Diametro, comprimento'],
    ['Tubo Quadrado', 'Lado, espessura, comprimento'],
    ['Tubo Retangular', 'Largura, altura, espessura, comprimento'],
    ['Tubo Redondo', 'Diametro externo, espessura, comprimento'],
    ['Cantoneira', 'Aba 1, aba 2, espessura, comprimento'],
    ['Chapa', 'Largura, altura, espessura'],
  ],
  { cs: { 0: { fontStyle: 'bold', cellWidth: 45 } } }
);

sub('2.2 Materiais');
p('Base de dados com densidade (kg/m3) para calculo automatico de peso. A calculadora calcula apenas o peso dos materiais, nao gera orcamentos com valores financeiros.');

tbl(
  ['Material', 'Densidade (kg/m3)', 'Categoria'],
  [
    ['Aco Carbono 1020', '7.850', 'Aco Carbono'],
    ['Aco Carbono 1045', '7.850', 'Aco Carbono'],
    ['Aco Inox 304', '8.000', 'Aco Inoxidavel'],
    ['Aco Inox 316', '8.000', 'Aco Inoxidavel'],
    ['Aluminio 6061', '2.700', 'Aluminio'],
    ['Aluminio 6063', '2.700', 'Aluminio'],
    ['Cobre', '8.960', 'Cobre'],
    ['Latao', '8.500', 'Latao'],
    ['Ferro Fundido', '7.200', 'Ferro Fundido'],
  ],
  { cs: { 0: { fontStyle: 'bold', cellWidth: 45 }, 1: { halign: 'center' }, 2: { halign: 'center' } } }
);

p('A base podera ser expandida em ate 250 materiais na versao final, com sistema de busca por texto e filtro por categoria.', { b: true });

sub('2.3 Geracao de PDF Profissional');
bp('Lista de materiais com numero total de itens e peso por item');
bp('Tabela detalhada com: perfil, material, peso unitario e peso total');
bp('Antes de gerar, o app solicita o nome do documento para organizacao');
bp('Layout com cores e logo do aplicativo (sem dados pessoais do usuario)');
bp('O PDF contem apenas a lista de materiais e a marca do aplicativo');
bp('PDF gerado 100% offline, direto no celular');

y += 2;
sub('2.4 Compartilhamento Nativo');
bp('Integrado ao sistema de compartilhamento Android');
bp('Envia PDF direto pelo WhatsApp, Gmail, Telegram, etc.');
bp('Nao precisa de internet para gerar - so para enviar');

// ============================================================
// POR QUE ESTA STACK
// ============================================================
y += 4;
sec('3. POR QUE ESTAS TECNOLOGIAS?');

p('Cada tecnologia foi escolhida com criterio tecnico e logico para garantir qualidade, performance e economia no desenvolvimento:');
y += 2;

// React + TypeScript
sub('React 18 + TypeScript');
p('Por que:', { b: true });
bp('React e a biblioteca mais utilizada no mundo para interfaces (usado por Meta, Netflix, Airbnb)');
bp('TypeScript previne bugs em tempo de desenvolvimento - codigo mais seguro e confiavel');
bp('Componentes reutilizaveis: cada perfil, modal e tela e um componente independente');
bp('Comunidade gigante = facil encontrar suporte, bibliotecas e desenvolvedores');
p('Alternativas descartadas:', { b: true, c: C.med });
bp('Flutter/Dart: Curva de aprendizado maior, menos bibliotecas para PDF');
bp('React Native puro: Mais complexo para funcionalidades offline');
bp('Desenvolvimento nativo (Kotlin): Custo 2-3x maior e nao permite web futuramente');

y += 3;
sub('Vite (Build Tool)');
p('Por que:', { b: true });
bp('Vite e o build tool mais rapido do mercado - desenvolvimento instantaneo');
bp('Hot Module Replacement (HMR): alteracoes aparecem em tempo real sem recarregar');
bp('Build de producao otimizado e compacto (ideal para mobile)');
bp('Usado por Vue, Nuxt, SvelteKit e milhares de projetos corporativos');
p('Alternativa descartada: Webpack - 10x mais lento para desenvolvimento', { c: C.med });

y += 3;
sub('Tailwind CSS');
p('Por que:', { b: true });
bp('CSS utilitario: escreve-se menos codigo, resultado mais consistente');
bp('Design responsivo nativo - adapta automaticamente a qualquer tela Android');
bp('Tema customizado com as cores da marca (laranja metalico + navy)');
bp('Sem CSS solto/desorganizado - tudo inline e previsivel');
bp('Reducao de 40-60% no tamanho do CSS final em producao');

y += 3;
sub('Capacitor (Empacotamento Android)');
p('Por que:', { b: true });
bp('Transforma a aplicacao web em app Android nativo');
bp('Acesso a APIs nativas: compartilhamento, armazenamento, splash screen');
bp('Mantido pela equipe do Ionic - projeto maduro e estavel');
bp('Um unico codigo para web + Android (e futuramente iOS)');
bp('Publicacao direta na Google Play Store');
p('Alternativa descartada: Cordova - projeto desatualizado, menos suporte a APIs modernas', { c: C.med });

y += 3;
sub('jsPDF + AutoTable (Geracao de PDF)');
p('Por que:', { b: true });
bp('Gera PDF 100% no dispositivo, sem servidor ou internet');
bp('AutoTable cria tabelas profissionais com formatacao automatica');
bp('Controle total do layout: cores, logo, fontes, posicionamento');
bp('Biblioteca leve (~200kb) - nao impacta o tamanho do app');
bp('Mais de 25 milhoes de downloads - amplamente testada no mercado');

y += 3;
sub('shadcn/ui + Radix UI (Componentes)');
p('Por que:', { b: true });
bp('Componentes acessiveis (acessibilidade WCAG) por padrao');
bp('49 componentes prontos: botoes, modais, formularios, tabelas');
bp('Customizaveis com Tailwind - sem CSS extra necessario');
bp('Nao e uma dependencia pesada - codigo copiado para o projeto');
bp('Usado por Vercel, Cal.com e milhares de empresas');

// ============================================================
// INVENTARIO TECNICO
// ============================================================
y += 4;
sec('4. INVENTARIO TECNICO ATUAL');

tbl(
  ['Metrica', 'Valor', 'Observacao'],
  [
    ['Arquivos de codigo', '96', 'Inclui componentes, utils, tipos, configs'],
    ['Linhas de codigo', '~6.300', 'TypeScript + JSX customizado'],
    ['Componentes customizados', '13', 'Telas, modais, formularios, diagramas'],
    ['Componentes de UI', '49', 'Biblioteca shadcn/ui reutilizavel'],
    ['Telas do app', '4', 'Splash, Menu, Formulario, Lista de projetos'],
    ['Perfis metalurgicos', '10', 'Com diagrama SVG tecnico cada'],
    ['Materiais na base', '9 (sera 100-250)', 'Com densidade e preco/kg'],
    ['Sistema de PDF', 'Completo', 'Layout profissional com jsPDF'],
    ['Testes', 'Configurado (Vitest)', 'Framework pronto para testes unitarios'],
  ],
  { cs: { 0: { fontStyle: 'bold', cellWidth: 50 }, 1: { halign: 'center', cellWidth: 35 } } }
);

// ============================================================
// ETAPAS E CRONOGRAMA
// ============================================================
sec('5. ETAPAS DE DESENVOLVIMENTO');

sub('FASE 1 - MVP (ja desenvolvido)');
p('O nucleo do aplicativo ja esta construido e funcional:');

tbl(
  ['Entrega', 'Status', 'Descricao'],
  [
    ['Arquitetura do projeto', 'Concluido', 'Estrutura de pastas, configs, dependencias'],
    ['10 perfis metalurgicos', 'Concluido', 'Formulas + diagramas SVG interativos'],
    ['Sistema de calculo', 'Concluido', 'Peso e valor automaticos por material'],
    ['Interface completa', 'Concluido', '4 telas com navegacao e design responsivo'],
    ['Geracao de PDF', 'Concluido', 'Lista de materiais profissional com tabela e totais'],
    ['Selecao de material', 'Concluido', '9 materiais com densidade e preco/kg'],
  ],
  {
    cs: { 0: { fontStyle: 'bold', cellWidth: 45 }, 1: { halign: 'center', cellWidth: 28 } },
    dp: (data) => {
      if (data.section === 'body' && data.column.index === 1) {
        data.cell.styles.textColor = C.green;
        data.cell.styles.fontStyle = 'bold';
      }
    },
  }
);

sub('FASE 2 - MVP para Produto Final');
p('Etapas restantes para transformar o MVP em produto publicavel:');

tbl(
  ['Etapa', 'Descricao', 'Horas Est.'],
  [
    ['Empacotamento Android', 'Capacitor, splash nativa, icone do app, assinatura', '12-18h'],
    ['Base de materiais', 'Importar 100-250 materiais via CSV, busca e filtros por categoria', '14-22h'],
    ['Compartilhamento', 'Android Share Intent nativo para WhatsApp, Gmail, etc.', '6-10h'],
    ['Modo offline total', 'Service Worker, cache de assets, testes sem internet', '4-6h'],
    ['QA em dispositivos', 'Testes em 5+ aparelhos, ajustes de teclado, scroll, tela', '10-16h'],
    ['Publicacao Play Store', 'APK assinado, screenshots, descricao, politica privacidade', '6-10h'],
  ],
  { cs: { 0: { fontStyle: 'bold', cellWidth: 42 }, 1: { cellWidth: 85 }, 2: { halign: 'center', cellWidth: 25 } } }
);

// ============================================================
// ESTIMATIVA DE HORAS
// ============================================================
sec('6. ESTIMATIVA DE HORAS TOTAIS');

tbl(
  ['Fase', 'Horas Estimadas', 'Media'],
  [
    ['FASE 1 - MVP (ja desenvolvido)', '98 - 140h', '~120h'],
    ['FASE 2 - MVP para Produto Final', '52 - 82h', '~65h'],
    ['TOTAL DO PROJETO', '150 - 222h', '~185h'],
  ],
  {
    hc: C.orange,
    cs: { 0: { fontStyle: 'bold' }, 1: { halign: 'center' }, 2: { halign: 'center', fontStyle: 'bold' } },
    dp: (data) => {
      if (data.section === 'body' && data.row.index === 2) {
        data.cell.styles.fillColor = [255, 243, 224];
        data.cell.styles.fontStyle = 'bold';
      }
    },
  }
);

p('A estimativa considera: desenvolvimento, testes, ajustes de design, empacotamento e publicacao. Nao inclui tempo de resposta e feedback do cliente.', { c: C.med });

// ============================================================
// VALORES E CENARIOS
// ============================================================
sec('7. INVESTIMENTO');

sub('Valor por hora em cada cenario (~185h de trabalho):');

tbl(
  ['Cenario', 'Investimento', 'Valor/Hora', 'Equivalente'],
  [
    ['Cenario A', 'R$ 8.000', '~R$ 43/h', 'Abaixo de Junior'],
    ['Cenario B', 'R$ 10.000', '~R$ 54/h', 'Junior'],
  ],
  {
    cs: { 0: { fontStyle: 'bold' }, 1: { fontStyle: 'bold', halign: 'center' }, 2: { halign: 'center' }, 3: { halign: 'center' } },
  }
);

sub('Referencia de mercado freelancer:');
tbl(
  ['Nivel', 'Valor/Hora (mercado)', 'Projeto completo (185h)'],
  [
    ['Junior (1-2 anos)', 'R$ 50 - 80/h', 'R$ 9.250 - R$ 14.800'],
    ['Pleno (3-5 anos)', 'R$ 80 - 150/h', 'R$ 14.800 - R$ 27.750'],
    ['Senior (5+ anos)', 'R$ 150 - 250/h', 'R$ 27.750 - R$ 46.250'],
  ],
  { cs: { 0: { fontStyle: 'bold' }, 2: { fontStyle: 'bold' } } }
);

p('Importante: O valor de R$ 8.000 ja esta consideravelmente abaixo do preco praticado no mercado para um projeto deste porte. Os valores de referencia acima servem para demonstrar que esta proposta representa uma condicao especial e diferenciada. Mesmo assim, estou aberto a negociacao para encontrarmos o melhor caminho juntos.', { b: true });

// ============================================================
// DETALHAMENTO DOS CENARIOS
// ============================================================
y += 2;
sec('8. DETALHAMENTO DOS CENARIOS');

// CENARIO A
doc.setFillColor(...C.cream);
np(80);
doc.roundedRect(m, y, cw, 76, 2, 2, 'F');
doc.setFillColor(...C.orange);
doc.roundedRect(m, y, cw, 10, 2, 2, 'F');
doc.rect(m, y + 8, cw, 2, 'F');
doc.setTextColor(...C.white);
doc.setFontSize(12);
doc.setFont('helvetica', 'bold');
doc.text('CENARIO A — R$ 8.000', m + 6, y + 7);
y += 14;
doc.setTextColor(...C.dark);
doc.setFontSize(9);
doc.setFont('helvetica', 'normal');
const ceaItems = [
  'App Android completo e funcional (ate 250 perfis + calculo + PDF)',
  'Ate 150 materiais com busca por texto e filtros por categoria',
  'Layout premium do PDF com logo personalizado',
  'Publicacao na Google Play Store',
  '30 dias de suporte e correcoes pos-lancamento',
  '1 rodada de ajustes/melhorias apos lancamento',
  'Papel de desenvolvedor principal na fase 2 (marketplace)',
  'Contrato formal reconhecido e assinado digitalmente',
];
for (const item of ceaItems) {
  doc.setFillColor(...C.orange);
  doc.circle(m + 6, y + 1.5, 0.8, 'F');
  doc.text(item, m + 10, y + 2.5);
  y += 6;
}
y += 10;

// CENARIO B
doc.setFillColor(...C.cream);
np(80);
doc.roundedRect(m, y, cw, 76, 2, 2, 'F');
doc.setFillColor(...C.green);
doc.roundedRect(m, y, cw, 10, 2, 2, 'F');
doc.rect(m, y + 8, cw, 2, 'F');
doc.setTextColor(...C.white);
doc.setFontSize(12);
doc.setFont('helvetica', 'bold');
doc.text('CENARIO B — R$ 10.000 (+ contrato de participacao)', m + 6, y + 7);
y += 14;
doc.setTextColor(...C.dark);
doc.setFontSize(9);
doc.setFont('helvetica', 'normal');
const cebItems = [
  'Tudo do Cenario A +',
  'Ate 250 materiais com busca inteligente e filtros avancados',
  '60 dias de suporte e correcoes pos-lancamento',
  '2 rodadas de ajustes/melhorias apos lancamento',
  'Contrato formal de participacao na startup (equity)',
  'Percentual de participacao definido em contrato (10-15%)',
  'Papel de desenvolvedor principal na fase 2 (marketplace)',
  'Contrato formal reconhecido e assinado digitalmente',
];
for (const item of cebItems) {
  doc.setFillColor(...C.orange);
  doc.circle(m + 6, y + 1.5, 0.8, 'F');
  doc.text(item, m + 10, y + 2.5);
  y += 6;
}
y += 10;

// ============================================================
// CUSTOS DO CLIENTE
// ============================================================
sec('9. CUSTOS POR CONTA DO CLIENTE');

p('Alem do investimento no desenvolvimento, existem custos fixos necessarios para publicacao e operacao:');

tbl(
  ['Item', 'Custo', 'Frequencia', 'Observacao'],
  [
    ['Conta Google Play Developer', 'R$ 130', 'Unica vez', 'Obrigatorio para publicar na Play Store'],
    ['Dominio (site futuro)', '~R$ 40', 'Anual', 'Opcional, se quiser landing page'],
    ['Apple Developer (iOS futuro)', '~R$ 500', 'Anual', 'Somente se expandir para iPhone'],
    ['Servidor/Infraestrutura', 'R$ 0', '-', 'App offline = sem custo mensal'],
  ],
  { cs: { 0: { fontStyle: 'bold' }, 1: { halign: 'center', fontStyle: 'bold' }, 2: { halign: 'center' } } }
);

box('O app funciona 100% offline. Nao ha custo mensal de servidor, banco de dados ou infraestrutura.', C.green, C.white, true);

// ============================================================
// MANUTENCAO
// ============================================================
sec('10. MANUTENCAO POS-LANCAMENTO (opcional)');

tbl(
  ['Servico', 'Valor Mensal', 'O que inclui'],
  [
    ['Novos materiais/perfis', 'R$ 150', 'Adicionar novos itens a base de dados'],
    ['Correcoes + atualizacao', 'R$ 250', 'Bugs, compatibilidade Android, melhorias'],
    ['PACOTE COMPLETO', 'R$ 400/mes', 'Tudo acima incluso + suporte WhatsApp'],
  ],
  {
    cs: { 0: { fontStyle: 'bold' }, 1: { halign: 'center', fontStyle: 'bold' } },
    dp: (data) => {
      if (data.section === 'body' && data.row.index === 2) {
        data.cell.styles.fillColor = [255, 243, 224];
        data.cell.styles.fontStyle = 'bold';
      }
    },
  }
);

// ============================================================
// CRONOGRAMA
// ============================================================
sec('11. CRONOGRAMA DE ENTREGA');

tbl(
  ['Semana', 'Entrega', 'Marcos'],
  [
    ['Semana 1-4', 'Empacotamento Android + base de materiais', 'Primeira versao rodando no celular'],
    ['Semana 5', 'Compartilhamento + modo offline', 'App funcional completo'],
    ['Semana 6-7', 'QA em dispositivos + ajustes', 'Testes em 5+ aparelhos reais'],
    ['Semana 8', 'Publicacao na Play Store', 'App disponivel para download'],
  ],
  {
    cs: { 0: { fontStyle: 'bold', halign: 'center', cellWidth: 28 }, 2: { cellWidth: 55 } },
    dp: (data) => {
      if (data.section === 'body' && data.column.index === 2) {
        data.cell.styles.fontStyle = 'bold';
        data.cell.styles.textColor = C.green;
      }
    },
  }
);

p('Prazo total estimado: 7 a 8 semanas apos aprovacao da proposta.', { b: true });
p('O prazo pode variar dependendo do tempo de feedback e aprovacoes do cliente.', { c: C.med });

// ============================================================
// VALOR PARA O CLIENTE FINAL
// ============================================================
sec('12. VALOR QUE O APP ENTREGA');

p('O que o serralheiro ganha usando a Calculadora do Serralheiro:');
y += 2;

const valores = [
  ['Velocidade', 'Lista de materiais e peso total da lista pronta em menos de 5 minutos, nao em 30 minutos.'],
  ['Precisao', 'Calculos automaticos eliminam erros de conta. Sem prejuizo por erro de calculos errados.'],
  ['Profissionalismo', 'PDF bonito e organizado impressiona o cliente (caso queira comprar os materiais). Passa confianca, profissionalismo e seriedade, otimizado para vendedores e lista de materiais gerada com mais velocidade.'],
  ['Praticidade', 'Funciona na obra, no carro, na oficina. Sem internet, sem complicacao.'],
  ['Agilidade', 'Envia a lista pro cliente na hora pelo WhatsApp. Fecha negocio mais rapido.'],
  ['Organizacao', 'Todos os itens da lista de materiais organizados com peso calculados.'],
];

for (const [titulo, desc] of valores) {
  np(14);
  doc.setFontSize(10);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...C.orange);
  doc.text(titulo + ':', m + 4, y + 4);
  doc.setFont('helvetica', 'normal');
  doc.setTextColor(...C.dark);
  doc.setFontSize(9);
  const tLines = doc.splitTextToSize(desc, cw - 6);
  let ty2 = y + 10;
  for (const tl of tLines) { doc.text(tl, m + 4, ty2); ty2 += 5; }
  y = ty2 + 2;
}

// ============================================================
// CONDICOES
// ============================================================
y += 4;
sec('13. CONDICOES GERAIS');

bp('Proposta valida por 15 dias a partir da data deste documento');
bp('Pagamento: 50% na aprovacao + 50% na entrega publicada na Play Store, ou parcelado em 4 vezes');
bp('Alteracoes de escopo apos aprovacao serao orcadas separadamente');
bp('O codigo-fonte sera entregue ao cliente apos pagamento integral');
bp('Prazo de entrega: 7 a 8 semanas apos aprovacao');
bp('Suporte pos-lancamento incluso conforme cenario escolhido');

y += 4;
divider();
y += 2;

// Assinatura
np(40);
doc.setFontSize(10);
doc.setFont('helvetica', 'normal');
doc.setTextColor(...C.dark);
doc.text('Aguardo seu retorno para alinharmos os proximos passos.', m, y + 4);
y += 12;
doc.text('Atenciosamente,', m, y + 4);
y += 14;
doc.setDrawColor(...C.dark);
doc.line(m, y, m + 70, y);
y += 5;
doc.setFontSize(9);
doc.setTextColor(...C.med);
doc.text('Desenvolvedor', m, y + 4);
y += 8;
doc.line(m + 90, y - 13, m + 90 + 70, y - 13);
doc.text('Cliente', m + 90, y + 4 - 8);

// ============================================================
// FOOTERS
// ============================================================
const total = doc.internal.getNumberOfPages();
for (let i = 1; i <= total; i++) {
  doc.setPage(i);
  if (i === 1) continue; // capa sem footer
  footer(i);
}

const out = doc.output('arraybuffer');
fs.writeFileSync('/home/user/Calculadora-Metalurgica/Proposta_Comercial_Calculadora_Serralheiro.pdf', Buffer.from(out));
console.log('PDF da proposta gerado com sucesso!');
console.log('Arquivo: Proposta_Comercial_Calculadora_Serralheiro.pdf');
console.log('Paginas:', total);
