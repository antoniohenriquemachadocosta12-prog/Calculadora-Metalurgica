import React, { forwardRef } from 'react';
import { Projeto } from '@/types/projeto';
import { BottomNav } from './BottomNav';

interface ProjectListProps {
  projetos: Projeto[];
  onBack: () => void;
  onDelete: (id: number) => void;
  onPDF: () => void;
}

export const ProjectList = forwardRef<HTMLDivElement, ProjectListProps>(({
  projetos,
  onBack,
  onDelete,
  onPDF
}, ref) => {
  const pesoTotal = projetos.reduce((acc, p) => acc + p.resultado.pesoTotal, 0);

  return (
    <div ref={ref} className="app-container pb-24">
      {/* Main Content Card */}
      <div className="content-card">
        {/* Table */}
        <div className="bg-cream">
          {/* Table Header */}
          <table className="data-table">
            <thead>
              <tr>
                <th className="w-12">Item</th>
                <th className="w-16">Quant.</th>
                <th className="w-12">Und.</th>
                <th>Peso</th>
                <th className="w-16"></th>
              </tr>
            </thead>
            <tbody>
              {projetos.length === 0 ? (
                <tr>
                  <td colSpan={5} className="p-8 text-center">
                    <div className="text-navy/50">
                      <svg className="w-12 h-12 mx-auto mb-2 opacity-50" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                        <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                      </svg>
                      <p className="text-sm font-medium">Lista vazia</p>
                      <p className="text-xs mt-1">Adicione perfis para gerar orçamento</p>
                    </div>
                  </td>
                </tr>
              ) : (
                projetos.map((projeto, index) => (
                  <tr key={projeto.id}>
                    <td className="font-medium">{index + 1}</td>
                    <td>{projeto.quantidade}</td>
                    <td>Pç</td>
                    <td className="font-semibold">{projeto.resultado.pesoTotal.toFixed(2)} Kg</td>
                    <td>
                      <div className="flex items-center justify-center gap-2">
                        <button
                          className="text-navy hover:text-primary transition-colors"
                          title="Editar"
                        >
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" />
                            <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" />
                          </svg>
                        </button>
                        <button
                          className="text-destructive hover:text-destructive/70 transition-colors"
                          onClick={() => onDelete(projeto.id)}
                          title="Excluir"
                        >
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <polyline points="3,6 5,6 21,6" />
                            <path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2" />
                          </svg>
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>

          {/* Footer */}
          <div className="p-3" style={{ borderTop: '2px solid hsl(210 45% 25%)' }}>
            {/* Total */}
            <div className="flex justify-between items-center mb-4">
              <span className="text-navy text-sm font-semibold">Peso Total</span>
              <div className="px-3 py-1 rounded" style={{ backgroundColor: 'hsl(var(--muted))', border: '1px solid hsl(210 45% 25%)' }}>
                <span className="text-navy font-bold">{pesoTotal.toFixed(2)} Kg</span>
              </div>
            </div>

            {/* Info text */}
            <div className="text-xs text-navy/70 space-y-1">
              <div className="flex justify-between">
                <span><strong>Tabela</strong> - Lista de Material</span>
                <span><strong>Fonte:</strong> Própria.</span>
              </div>
              <div className="flex justify-between pt-2 border-t border-navy/20">
                <span>Atenciosamente,</span>
                <span className="font-medium italic">MetalCalc Pro</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Navigation */}
      <BottomNav
        onLogoClick={onBack}
        showPdfButton={projetos.length > 0}
        onPdfClick={onPDF}
      />
    </div>
  );
});

ProjectList.displayName = 'ProjectList';
