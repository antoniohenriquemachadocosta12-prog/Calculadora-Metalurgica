import React from 'react';
import { Projeto } from '@/types/projeto';
import { Logo } from './Logo';

interface ProjectListProps {
  projetos: Projeto[];
  onBack: () => void;
  onDelete: (id: number) => void;
  onPDF: () => void;
}

export const ProjectList: React.FC<ProjectListProps> = ({ projetos, onBack, onDelete, onPDF }) => {
  const pesoTotal = projetos.reduce((acc, p) => acc + p.resultado.pesoTotal, 0);

  return (
    <div className="app-container pb-24">
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

      {/* Back button */}
      <button
        onClick={onBack}
        className="fixed top-4 left-4 w-10 h-10 rounded-full bg-navy flex items-center justify-center text-white text-xl shadow-button hover:opacity-90 transition-opacity"
      >
        ←
      </button>

      {/* Bottom Navigation */}
      <div className="bottom-nav flex items-center justify-between">
        <Logo size="md" />

        {projetos.length > 0 && (
          <button
            onClick={onPDF}
            className="btn-teal flex items-center gap-2"
          >
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M14 2H6C4.9 2 4 2.9 4 4V20C4 21.1 4.9 22 6 22H18C19.1 22 20 21.1 20 20V8L14 2ZM16 18H8V16H16V18ZM16 14H8V12H16V14ZM13 9V3.5L18.5 9H13Z" />
            </svg>
            PDF
          </button>
        )}
      </div>
    </div>
  );
};
