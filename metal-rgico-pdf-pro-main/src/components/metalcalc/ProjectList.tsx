import React from 'react';
import { Projeto } from '@/types/projeto';

interface ProjectListProps {
  projetos: Projeto[];
  onBack: () => void;
  onDelete: (id: number) => void;
  onPDF: () => void;
}

export const ProjectList: React.FC<ProjectListProps> = ({ projetos, onBack, onDelete, onPDF }) => {
  const pesoTotal = projetos.reduce((acc, p) => acc + p.resultado.pesoTotal, 0);

  return (
    <div className="min-h-screen bg-primary pb-24">
      {/* Main Content Card */}
      <div className="mx-3 mt-3 bg-card rounded-lg border-2 border-border overflow-hidden">
        {/* Table Header */}
        <div className="bg-muted border-b-2 border-border">
          <div className="grid grid-cols-12 text-xs font-semibold text-muted-foreground">
            <div className="col-span-1 p-2 border-r border-border text-center">Item</div>
            <div className="col-span-2 p-2 border-r border-border text-center">Quant.</div>
            <div className="col-span-2 p-2 border-r border-border text-center">Und.</div>
            <div className="col-span-5 p-2 border-r border-border text-center">Peso</div>
            <div className="col-span-2 p-2 text-center">Ações</div>
          </div>
        </div>

        {/* Table Body */}
        <div className="bg-cream max-h-[calc(100vh-280px)] overflow-y-auto">
          {projetos.length === 0 ? (
            <div className="p-8 text-center text-muted-foreground">
              <span className="text-4xl block mb-2">📋</span>
              <p className="text-sm">Lista vazia</p>
              <p className="text-xs">Adicione perfis para gerar orçamento</p>
            </div>
          ) : (
            projetos.map((projeto, index) => (
              <div key={projeto.id} className="grid grid-cols-12 text-sm border-b border-border last:border-b-0">
                <div className="col-span-1 p-2 border-r border-border text-center text-foreground">{index + 1}</div>
                <div className="col-span-2 p-2 border-r border-border text-center text-foreground">{projeto.quantidade}</div>
                <div className="col-span-2 p-2 border-r border-border text-center text-foreground">Pç</div>
                <div className="col-span-5 p-2 border-r border-border text-center text-foreground font-medium">
                  {projeto.resultado.pesoTotal.toFixed(2)} Kg
                </div>
                <div className="col-span-2 p-2 flex items-center justify-center gap-1">
                  <button 
                    className="text-foreground hover:text-primary text-sm"
                    title="Ver detalhes"
                  >
                    ✏️
                  </button>
                  <button 
                    className="text-destructive hover:text-destructive/80 text-sm"
                    onClick={() => onDelete(projeto.id)}
                    title="Excluir"
                  >
                    🗑️
                  </button>
                </div>
              </div>
            ))
          )}
        </div>

        {/* Footer with Total */}
        <div className="bg-cream-dark border-t-2 border-border p-3">
          <div className="flex justify-between items-center mb-3">
            <span className="text-sm text-muted-foreground font-medium">Peso Total</span>
            <span className="text-lg font-bold text-foreground">{pesoTotal.toFixed(2)} Kg</span>
          </div>
          
          <div className="text-xs text-muted-foreground">
            <p><strong>Tabela</strong> - Lista de Material</p>
            <p className="text-right">Fonte: Própria.</p>
          </div>
          
          <div className="flex justify-between items-center mt-3 pt-3 border-t border-border">
            <span className="text-xs text-muted-foreground">Atenciosamente,</span>
            <span className="text-xs text-foreground font-medium">MetalCalc Pro</span>
          </div>
        </div>
      </div>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-0 right-0 bg-primary p-3 flex items-center justify-between safe-area-bottom">
        {/* Logo */}
        <div className="w-14 h-14 rounded-full bg-foreground/20 flex items-center justify-center shadow-button">
          <span className="text-3xl font-bold text-primary-foreground italic">M</span>
        </div>

        {/* PDF Button */}
        {projetos.length > 0 && (
          <button
            onClick={onPDF}
            className="bg-destructive text-destructive-foreground px-4 py-3 rounded-lg font-semibold text-sm shadow-button flex items-center gap-2 hover:opacity-90 transition-opacity"
          >
            <span className="text-lg">📄</span>
            PDF
          </button>
        )}
      </div>

      {/* Back to Home floating button */}
      <button
        onClick={onBack}
        className="fixed top-4 left-4 w-10 h-10 rounded-full bg-foreground/20 flex items-center justify-center text-primary-foreground text-xl shadow-button hover:bg-foreground/30 transition-colors"
      >
        ←
      </button>
    </div>
  );
};
