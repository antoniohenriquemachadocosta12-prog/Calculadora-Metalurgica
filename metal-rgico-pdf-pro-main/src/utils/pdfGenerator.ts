import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import { Projeto, EmpresaInfo, ClienteInfo } from '@/types/projeto';
import { formatarDescricaoTecnica } from './calculos';

export const gerarPDF = (
  projetos: Projeto[],
  empresa: EmpresaInfo,
  cliente: ClienteInfo,
  validadeDias: number = 15
) => {
  const doc = new jsPDF();
  const data = new Date().toLocaleDateString('pt-BR');
  const numeroOrcamento = Date.now().toString().slice(-6);
  
  // Cores
  const corPrimaria: [number, number, number] = [232, 93, 4]; // #e85d04
  const corEscura: [number, number, number] = [26, 26, 46]; // #1a1a2e
  
  // Cabeçalho
  doc.setFillColor(...corPrimaria);
  doc.rect(0, 0, 210, 35, 'F');
  
  // Logo/Nome
  doc.setTextColor(255, 255, 255);
  doc.setFontSize(24);
  doc.setFont('helvetica', 'bold');
  doc.text('MetalCalc Pro', 15, 18);
  
  doc.setFontSize(10);
  doc.setFont('helvetica', 'normal');
  doc.text('Orçamentos Precisos para Metalurgia', 15, 26);
  
  // Número e Data
  doc.setFontSize(11);
  doc.text(`Orçamento #${numeroOrcamento}`, 145, 15);
  doc.text(`Data: ${data}`, 145, 22);
  
  // Data de validade
  const dataValidade = new Date();
  dataValidade.setDate(dataValidade.getDate() + validadeDias);
  doc.setFontSize(9);
  doc.text(`Válido até: ${dataValidade.toLocaleDateString('pt-BR')}`, 145, 29);
  
  // Dados da Empresa
  let yPos = 45;
  doc.setTextColor(...corEscura);
  doc.setFontSize(12);
  doc.setFont('helvetica', 'bold');
  doc.text('EMPRESA', 15, yPos);
  
  doc.setFont('helvetica', 'normal');
  doc.setFontSize(10);
  yPos += 7;
  doc.text(empresa.nome || 'Nome da Empresa', 15, yPos);
  yPos += 5;
  doc.text(`CNPJ: ${empresa.cnpj || '00.000.000/0000-00'}`, 15, yPos);
  
  // Dados do Cliente (se houver)
  if (cliente.nome) {
    yPos = 45;
    doc.setFontSize(12);
    doc.setFont('helvetica', 'bold');
    doc.text('CLIENTE', 120, yPos);
    
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    yPos += 7;
    doc.text(cliente.nome, 120, yPos);
    if (cliente.telefone) {
      yPos += 5;
      doc.text(`Tel: ${cliente.telefone}`, 120, yPos);
    }
  }
  
  // Linha separadora
  yPos = 68;
  doc.setDrawColor(...corPrimaria);
  doc.setLineWidth(0.5);
  doc.line(15, yPos, 195, yPos);
  
  // Tabela de Itens
  yPos += 10;
  
  const tableData = projetos.map((p, index) => [
    (index + 1).toString(),
    formatarDescricaoTecnica(p.tipoPerfil, p.medidas),
    p.material.nome,
    `R$ ${p.material.precoKg.toFixed(2)}/kg`,
    p.quantidade.toString(),
    `${p.resultado.pesoTotal.toFixed(3)} kg`,
    `R$ ${p.resultado.valorTotal.toFixed(2)}`
  ]);
  
  autoTable(doc, {
    startY: yPos,
    head: [['#', 'Descrição Técnica', 'Material', 'Preço/kg', 'Qtd', 'Peso Total', 'Valor']],
    body: tableData,
    theme: 'striped',
    headStyles: {
      fillColor: corEscura,
      textColor: [255, 255, 255],
      fontStyle: 'bold',
      fontSize: 9,
    },
    bodyStyles: {
      fontSize: 9,
      textColor: [50, 50, 50],
    },
    alternateRowStyles: {
      fillColor: [245, 245, 245],
    },
    columnStyles: {
      0: { cellWidth: 10, halign: 'center' },
      1: { cellWidth: 50 },
      2: { cellWidth: 35 },
      3: { cellWidth: 25, halign: 'right' },
      4: { cellWidth: 15, halign: 'center' },
      5: { cellWidth: 25, halign: 'right' },
      6: { cellWidth: 30, halign: 'right' },
    },
    margin: { left: 15, right: 15 },
  });
  
  // Posição após a tabela
  const finalY = (doc as any).lastAutoTable.finalY + 10;
  
  // Totais
  const pesoTotal = projetos.reduce((acc, p) => acc + p.resultado.pesoTotal, 0);
  const valorTotal = projetos.reduce((acc, p) => acc + p.resultado.valorTotal, 0);
  
  // Box de totais
  doc.setFillColor(245, 245, 245);
  doc.roundedRect(110, finalY, 85, 30, 3, 3, 'F');
  
  doc.setTextColor(...corEscura);
  doc.setFontSize(10);
  doc.setFont('helvetica', 'normal');
  doc.text('Peso Total Estimado:', 115, finalY + 10);
  doc.setFont('helvetica', 'bold');
  doc.text(`${pesoTotal.toFixed(2)} kg`, 175, finalY + 10, { align: 'right' });
  
  doc.setFont('helvetica', 'normal');
  doc.text('Valor Total do Material:', 115, finalY + 18);
  
  doc.setFillColor(...corPrimaria);
  doc.roundedRect(150, finalY + 21, 45, 8, 2, 2, 'F');
  doc.setTextColor(255, 255, 255);
  doc.setFontSize(11);
  doc.setFont('helvetica', 'bold');
  doc.text(`R$ ${valorTotal.toFixed(2)}`, 172.5, finalY + 27, { align: 'center' });
  
  // Observações (se houver)
  if (cliente.obs) {
    const obsY = finalY + 45;
    doc.setFillColor(255, 248, 231);
    doc.roundedRect(15, obsY, 180, 20, 3, 3, 'F');
    doc.setTextColor(...corEscura);
    doc.setFontSize(9);
    doc.setFont('helvetica', 'bold');
    doc.text('Observações:', 20, obsY + 7);
    doc.setFont('helvetica', 'normal');
    doc.text(cliente.obs, 20, obsY + 14, { maxWidth: 170 });
  }
  
  // Rodapé Técnico
  const pageHeight = doc.internal.pageSize.height;
  
  doc.setDrawColor(...corPrimaria);
  doc.setLineWidth(0.3);
  doc.line(15, pageHeight - 25, 195, pageHeight - 25);
  
  doc.setTextColor(100, 100, 100);
  doc.setFontSize(8);
  doc.setFont('helvetica', 'normal');
  doc.text(`Orçamento gerado em ${data} | Válido por ${validadeDias} dias`, 105, pageHeight - 18, { align: 'center' });
  doc.text('MetalCalc Pro - Orçamentos Precisos para Metalurgia', 105, pageHeight - 12, { align: 'center' });
  
  doc.setFontSize(7);
  doc.setTextColor(150, 150, 150);
  doc.text('* Valores sujeitos a alteração devido à flutuação do preço do aço no mercado.', 105, pageHeight - 6, { align: 'center' });
  
  // Download do PDF
  doc.save(`orcamento-${numeroOrcamento}.pdf`);
};
