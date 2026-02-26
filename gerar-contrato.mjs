import { jsPDF } from 'jspdf';
import fs from 'fs';

const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
const W = doc.internal.pageSize.getWidth();
const H = doc.internal.pageSize.getHeight();
const m = 22;
const cw = W - m * 2;
let y = 0;
let pageNum = 1;

const C = {
  navy: [26, 26, 46],
  orange: [232, 93, 4],
  dark: [30, 30, 30],
  med: [80, 80, 80],
  light: [200, 200, 200],
  white: [255, 255, 255],
};

function np(need = 14) {
  if (y + need > H - 25) {
    addFooter();
    doc.addPage();
    pageNum++;
    y = 25;
  }
}

function addFooter() {
  doc.setDrawColor(...C.light);
  doc.setLineWidth(0.3);
  doc.line(m, H - 18, W - m, H - 18);
  doc.setFontSize(7);
  doc.setTextColor(...C.med);
  doc.text('Contrato de Prestacao de Servicos - Calculadora do Serralheiro | Confidencial', m, H - 13);
  doc.text(`Pagina ${pageNum}`, W - m, H - 13, { align: 'right' });
  // Rubrica
  doc.setFontSize(6.5);
  doc.text('Rubrica CONTRATANTE: ____________', m, H - 8);
  doc.text('Rubrica CONTRATADA: ____________', W - m - 55, H - 8);
}

function title(text) {
  np(16);
  doc.setFontSize(11);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...C.navy);
  doc.text(text, m, y + 5);
  y += 10;
}

function para(text, opts = {}) {
  np(10);
  doc.setFontSize(opts.size || 9);
  doc.setFont('helvetica', opts.bold ? 'bold' : 'normal');
  doc.setTextColor(...(opts.color || C.dark));
  const lines = doc.splitTextToSize(text, cw - (opts.indent || 0));
  for (const line of lines) {
    np(5);
    doc.text(line, m + (opts.indent || 0), y + 4);
    y += 4.5;
  }
  y += 2;
}

function clausula(num, titulo) {
  np(14);
  doc.setFillColor(...C.navy);
  doc.rect(m, y, cw, 8, 'F');
  doc.setFontSize(9.5);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...C.white);
  doc.text(`CLAUSULA ${num} - ${titulo}`, m + 4, y + 5.5);
  y += 12;
}

function item(num, text) {
  np(10);
  doc.setFontSize(9);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(...C.dark);
  const prefix = `${num} `;
  doc.text(prefix, m, y + 4);
  doc.setFont('helvetica', 'normal');
  const lines = doc.splitTextToSize(text, cw - 8);
  let first = true;
  for (const line of lines) {
    np(5);
    if (first) {
      doc.text(line, m + doc.getTextWidth(prefix), y + 4);
      first = false;
    } else {
      doc.text(line, m + 8, y + 4);
    }
    y += 4.5;
  }
  y += 1.5;
}

function subitem(text) {
  np(8);
  doc.setFontSize(8.5);
  doc.setFont('helvetica', 'normal');
  doc.setTextColor(...C.dark);
  const lines = doc.splitTextToSize(text, cw - 16);
  for (const line of lines) {
    np(5);
    doc.text(line, m + 12, y + 4);
    y += 4.5;
  }
  y += 1;
}

// ============================================================
// CABECALHO
// ============================================================
doc.setFillColor(...C.navy);
doc.rect(0, 0, W, 35, 'F');
doc.setFillColor(...C.orange);
doc.rect(0, 35, W, 2, 'F');

doc.setTextColor(...C.white);
doc.setFontSize(16);
doc.setFont('helvetica', 'bold');
doc.text('CONTRATO DE PRESTACAO DE SERVICOS', W / 2, 15, { align: 'center' });
doc.setFontSize(10);
doc.setFont('helvetica', 'normal');
doc.text('Desenvolvimento de Aplicativo - Calculadora do Serralheiro', W / 2, 23, { align: 'center' });
doc.setFontSize(8);
doc.setTextColor(180, 180, 180);
doc.text('Contrato N. ______/2026', W / 2, 31, { align: 'center' });

y = 45;

// ============================================================
// PREAMBULO
// ============================================================
para('Pelo presente instrumento particular, as partes abaixo identificadas celebram o presente Contrato de Prestacao de Servicos de Desenvolvimento de Software, que se regera pelas clausulas e condicoes seguintes:', { size: 9 });

y += 4;

// CONTRATANTE
doc.setFillColor(245, 245, 245);
np(42);
doc.roundedRect(m, y, cw, 38, 2, 2, 'F');
doc.setFontSize(9);
doc.setFont('helvetica', 'bold');
doc.setTextColor(...C.orange);
doc.text('CONTRATANTE:', m + 4, y + 6);
doc.setTextColor(...C.dark);
doc.setFont('helvetica', 'normal');
doc.setFontSize(8.5);
doc.text('Nome / Razao Social: _______________________________________________', m + 4, y + 13);
doc.text('CPF / CNPJ: _______________________________________________', m + 4, y + 19);
doc.text('Endereco: _______________________________________________', m + 4, y + 25);
doc.text('Telefone: _________________________  E-mail: _________________________', m + 4, y + 31);
y += 44;

// CONTRATADA
doc.setFillColor(245, 245, 245);
np(42);
doc.roundedRect(m, y, cw, 38, 2, 2, 'F');
doc.setFontSize(9);
doc.setFont('helvetica', 'bold');
doc.setTextColor(...C.orange);
doc.text('CONTRATADA (Desenvolvedor):', m + 4, y + 6);
doc.setTextColor(...C.dark);
doc.setFont('helvetica', 'normal');
doc.setFontSize(8.5);
doc.text('Nome / Razao Social: _______________________________________________', m + 4, y + 13);
doc.text('CPF / CNPJ: _______________________________________________', m + 4, y + 19);
doc.text('Endereco: _______________________________________________', m + 4, y + 25);
doc.text('Telefone: _________________________  E-mail: _________________________', m + 4, y + 31);
y += 44;

// ============================================================
// CLAUSULA 1 - OBJETO
// ============================================================
clausula('1a', 'DO OBJETO');

item('1.1', 'O presente contrato tem por objeto a prestacao de servicos de desenvolvimento de software, consistente na criacao de um aplicativo Android denominado "Calculadora do Serralheiro", conforme especificacoes tecnicas detalhadas na Proposta Comercial apresentada e aceita pelo CONTRATANTE.');

item('1.2', 'O aplicativo tera as seguintes funcionalidades principais:');
subitem('a) Calculo automatico de peso para ate 250 tipos de perfis metalurgicos;');
subitem('b) Base de dados com ate 150 materiais, com sistema de busca por texto e filtro por categoria;');
subitem('c) Geracao de PDF profissional com lista de materiais e peso calculado;');
subitem('d) Compartilhamento nativo via WhatsApp, Gmail, Telegram e demais aplicativos Android;');
subitem('e) Funcionamento 100% offline, sem necessidade de conexao com a internet;');
subitem('f) Layout com logo personalizado do aplicativo;');
subitem('g) Publicacao na Google Play Store.');

item('1.3', 'O escopo do projeto compreende exclusivamente o desenvolvimento do aplicativo conforme descrito acima. Quaisquer funcionalidades adicionais nao previstas neste contrato deverao ser objeto de negociacao e aditivo contratual.');

// ============================================================
// CLAUSULA 2 - VALOR E PAGAMENTO
// ============================================================
clausula('2a', 'DO VALOR E FORMA DE PAGAMENTO');

item('2.1', 'O valor total dos servicos objeto deste contrato e de R$ 6.000,00 (seis mil reais).');

item('2.2', 'O pagamento sera realizado da seguinte forma:');
subitem('a) 1a parcela: R$ 3.000,00 (tres mil reais) na data da assinatura deste contrato;');
subitem('b) 2a parcela: R$ 3.000,00 (tres mil reais) na entrega do aplicativo publicado na Google Play Store.');

item('2.3', 'O pagamento podera ser realizado via transferencia bancaria (PIX ou TED) para a conta indicada pela CONTRATADA.');

item('2.4', 'O atraso no pagamento de qualquer parcela acarretara multa de 2% (dois por cento) sobre o valor devido, acrescido de juros de mora de 1% (um por cento) ao mes, calculados pro rata die.');

item('2.5', 'O valor contratado nao inclui custos de publicacao na Google Play Store (taxa de R$ 130,00 da conta de desenvolvedor Google), que serao de responsabilidade exclusiva do CONTRATANTE.');

// ============================================================
// CLAUSULA 3 - PRAZO
// ============================================================
clausula('3a', 'DO PRAZO DE ENTREGA');

item('3.1', 'O prazo para conclusao e entrega do aplicativo e de 7 (sete) a 8 (oito) semanas, contados a partir da data de assinatura deste contrato e do recebimento da primeira parcela.');

item('3.2', 'O prazo estipulado no item 3.1 podera ser prorrogado nos seguintes casos:');
subitem('a) Atraso no fornecimento de informacoes ou materiais pelo CONTRATANTE;');
subitem('b) Solicitacao de alteracoes no escopo pelo CONTRATANTE;');
subitem('c) Caso fortuito ou forca maior devidamente comprovados.');

item('3.3', 'A CONTRATADA se compromete a manter o CONTRATANTE informado sobre o andamento do desenvolvimento, com atualizacoes semanais sobre o progresso.');

// ============================================================
// CLAUSULA 4 - ENTREGAS
// ============================================================
clausula('4a', 'DAS ENTREGAS E MARCOS DO PROJETO');

item('4.1', 'O desenvolvimento sera realizado nas seguintes etapas:');
subitem('a) Semana 1-4: Empacotamento Android + base de materiais (marco: primeira versao no celular);');
subitem('b) Semana 5: Compartilhamento nativo + modo offline completo;');
subitem('c) Semana 6-7: Testes de qualidade em dispositivos + ajustes;');
subitem('d) Semana 8: Publicacao na Google Play Store (marco: app disponivel para download).');

item('4.2', 'O CONTRATANTE tera direito a 1 (uma) rodada de ajustes e melhorias apos o lancamento do aplicativo, sem custo adicional, desde que solicitada dentro do periodo de suporte.');

item('4.3', 'A entrega final sera considerada realizada quando o aplicativo estiver publicado e disponivel para download na Google Play Store.');

// ============================================================
// CLAUSULA 5 - SUPORTE
// ============================================================
clausula('5a', 'DO SUPORTE POS-LANCAMENTO');

item('5.1', 'A CONTRATADA oferecera suporte tecnico gratuito pelo periodo de 30 (trinta) dias apos a publicacao do aplicativo na Google Play Store.');

item('5.2', 'O suporte inclui:');
subitem('a) Correcao de bugs e falhas de funcionamento;');
subitem('b) Ajustes de compatibilidade com dispositivos Android;');
subitem('c) Atendimento via WhatsApp em horario comercial.');

item('5.3', 'Apos o periodo de suporte gratuito, a CONTRATADA podera oferecer plano de manutencao mensal no valor de R$ 400,00 (quatrocentos reais), que incluira atualizacoes, correcoes e adicao de novos materiais.');

// ============================================================
// CLAUSULA 6 - PROPRIEDADE INTELECTUAL
// ============================================================
clausula('6a', 'DA PROPRIEDADE INTELECTUAL');

item('6.1', 'O codigo-fonte do aplicativo sera entregue ao CONTRATANTE apos o pagamento integral do valor contratado.');

item('6.2', 'Apos a entrega do codigo-fonte e quitacao integral, o CONTRATANTE tera plena propriedade sobre o aplicativo e podera utiliza-lo, modifica-lo ou distribui-lo como bem entender.');

item('6.3', 'Ate a quitacao integral, o codigo-fonte permanecera sob propriedade exclusiva da CONTRATADA, servindo como garantia do pagamento.');

item('6.4', 'A CONTRATADA podera utilizar o projeto em seu portfolio profissional, mencionando apenas o nome e tipo do projeto, sem divulgar informacoes confidenciais do CONTRATANTE.');

// ============================================================
// CLAUSULA 7 - OBRIGACOES
// ============================================================
clausula('7a', 'DAS OBRIGACOES DAS PARTES');

para('7.1 Sao obrigacoes da CONTRATADA:', { bold: true });
subitem('a) Desenvolver o aplicativo conforme especificacoes acordadas;');
subitem('b) Cumprir os prazos estabelecidos neste contrato;');
subitem('c) Manter sigilo sobre informacoes confidenciais do CONTRATANTE;');
subitem('d) Prestar suporte tecnico durante o periodo estipulado;');
subitem('e) Entregar o codigo-fonte apos quitacao integral.');

y += 2;
para('7.2 Sao obrigacoes do CONTRATANTE:', { bold: true });
subitem('a) Efetuar os pagamentos nos prazos estabelecidos;');
subitem('b) Fornecer informacoes e materiais necessarios ao desenvolvimento;');
subitem('c) Responder solicitacoes da CONTRATADA em prazo razoavel (ate 5 dias uteis);');
subitem('d) Arcar com os custos de publicacao na Google Play Store;');
subitem('e) Testar e aprovar as entregas parciais dentro de 5 dias uteis.');

// ============================================================
// CLAUSULA 8 - ALTERACOES DE ESCOPO
// ============================================================
clausula('8a', 'DAS ALTERACOES DE ESCOPO');

item('8.1', 'Quaisquer alteracoes no escopo do projeto que nao estejam previstas neste contrato deverao ser formalizadas por meio de aditivo contratual.');

item('8.2', 'As alteracoes de escopo poderao impactar o valor e o prazo do projeto. A CONTRATADA apresentara orcamento e novo cronograma antes de iniciar qualquer trabalho adicional.');

item('8.3', 'A CONTRATADA nao e obrigada a executar alteracoes de escopo sem a devida formalizacao e aprovacao de ambas as partes.');

// ============================================================
// CLAUSULA 9 - CONFIDENCIALIDADE
// ============================================================
clausula('9a', 'DA CONFIDENCIALIDADE');

item('9.1', 'As partes se comprometem a manter sigilo sobre todas as informacoes tecnicas, comerciais e estrategicas trocadas durante a vigencia deste contrato.');

item('9.2', 'A obrigacao de confidencialidade permanecera vigente por 2 (dois) anos apos o termino deste contrato.');

item('9.3', 'Nao serao consideradas confidenciais as informacoes que sejam de dominio publico ou que devam ser divulgadas por forca de lei ou decisao judicial.');

// ============================================================
// CLAUSULA 10 - RESCISAO
// ============================================================
clausula('10a', 'DA RESCISAO');

item('10.1', 'Este contrato podera ser rescindido por qualquer das partes, mediante notificacao por escrito com antecedencia minima de 15 (quinze) dias.');

item('10.2', 'Em caso de rescisao por iniciativa do CONTRATANTE:');
subitem('a) Sera devido o pagamento proporcional ao trabalho ja realizado;');
subitem('b) A primeira parcela (R$ 3.000,00) nao sera reembolsavel;');
subitem('c) O codigo-fonte do trabalho realizado nao sera entregue se houver valores pendentes.');

item('10.3', 'Em caso de rescisao por iniciativa da CONTRATADA:');
subitem('a) Devera entregar todo o trabalho realizado ate a data da rescisao;');
subitem('b) Devolvera valores referentes a trabalho nao realizado.');

item('10.4', 'Em caso de descumprimento contratual por qualquer das partes, a parte prejudicada podera rescindir o contrato imediatamente, sem prejuizo das perdas e danos cabiveis.');

// ============================================================
// CLAUSULA 11 - GARANTIA
// ============================================================
clausula('11a', 'DA GARANTIA');

item('11.1', 'A CONTRATADA garante o funcionamento do aplicativo conforme especificacoes acordadas pelo periodo de 90 (noventa) dias apos a publicacao na Google Play Store.');

item('11.2', 'A garantia nao cobre:');
subitem('a) Falhas causadas por modificacoes feitas por terceiros no codigo-fonte;');
subitem('b) Incompatibilidade com dispositivos lancados apos a entrega;');
subitem('c) Alteracoes nas politicas da Google Play Store que afetem o funcionamento do app.');

// ============================================================
// CLAUSULA 12 - DISPOSICOES GERAIS
// ============================================================
clausula('12a', 'DAS DISPOSICOES GERAIS');

item('12.1', 'Este contrato constitui o acordo integral entre as partes sobre o objeto aqui descrito, substituindo quaisquer entendimentos ou acordos anteriores, verbais ou escritos.');

item('12.2', 'Qualquer tolerancia de uma parte em relacao ao descumprimento de obrigacoes pela outra nao constituira novacao ou renunciao de direitos.');

item('12.3', 'Se qualquer clausula deste contrato for considerada invalida ou inexequivel, as demais clausulas permanecerao em pleno vigor.');

item('12.4', 'Fica eleito o foro da comarca de _________________________________ para dirimir quaisquer controversias oriundas deste contrato, com renuncia expressa a qualquer outro, por mais privilegiado que seja.');

// ============================================================
// ASSINATURAS
// ============================================================
y += 6;
np(60);

doc.setDrawColor(...C.orange);
doc.setLineWidth(0.5);
doc.line(m, y, W - m, y);
y += 8;

para('E por estarem assim justas e contratadas, as partes assinam o presente instrumento em 2 (duas) vias de igual teor e forma, na presenca de 2 (duas) testemunhas.', { size: 9 });

y += 4;
para('Local: _________________________________, Data: ____/____/2026', { size: 9 });

y += 12;

// Contratante
np(30);
doc.setDrawColor(...C.dark);
doc.line(m, y, m + 72, y);
y += 5;
doc.setFontSize(9);
doc.setFont('helvetica', 'bold');
doc.setTextColor(...C.dark);
doc.text('CONTRATANTE', m, y + 3);
doc.setFont('helvetica', 'normal');
doc.setFontSize(8);
doc.text('Nome: ___________________________________', m, y + 9);
doc.text('CPF/CNPJ: _______________________________', m, y + 14);

// Contratada
doc.line(W - m - 72, y - 19, W - m, y - 19);
doc.setFontSize(9);
doc.setFont('helvetica', 'bold');
doc.text('CONTRATADA', W - m - 72, y + 3);
doc.setFont('helvetica', 'normal');
doc.setFontSize(8);
doc.text('Nome: ___________________________________', W - m - 72, y + 9);
doc.text('CPF/CNPJ: _______________________________', W - m - 72, y + 14);

y += 24;

// Testemunhas
np(30);
doc.setFontSize(9);
doc.setFont('helvetica', 'bold');
doc.setTextColor(...C.navy);
doc.text('TESTEMUNHAS:', m, y + 3);
y += 10;

doc.setDrawColor(...C.dark);
doc.line(m, y, m + 72, y);
y += 5;
doc.setFontSize(8);
doc.setFont('helvetica', 'normal');
doc.setTextColor(...C.dark);
doc.text('Testemunha 1', m, y + 3);
doc.text('Nome: ___________________________________', m, y + 9);
doc.text('CPF: ____________________________________', m, y + 14);

doc.line(W - m - 72, y - 5, W - m, y - 5);
doc.text('Testemunha 2', W - m - 72, y + 3);
doc.text('Nome: ___________________________________', W - m - 72, y + 9);
doc.text('CPF: ____________________________________', W - m - 72, y + 14);

// ============================================================
// FOOTERS
// ============================================================
addFooter();
const total = doc.internal.getNumberOfPages();
for (let i = 1; i < total; i++) {
  doc.setPage(i);
  // footer already added during page breaks
}

const out = doc.output('arraybuffer');
fs.writeFileSync('/home/user/Calculadora-Metalurgica/Contrato_Calculadora_Serralheiro.pdf', Buffer.from(out));
console.log('Contrato gerado com sucesso!');
console.log('Arquivo: Contrato_Calculadora_Serralheiro.pdf');
console.log('Paginas:', total);
