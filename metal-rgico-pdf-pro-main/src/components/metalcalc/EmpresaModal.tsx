import React from 'react';
import { EmpresaInfo, ClienteInfo } from '@/types/projeto';

interface EmpresaModalProps {
  empresa: EmpresaInfo;
  cliente: ClienteInfo;
  onEmpresaChange: (empresa: EmpresaInfo) => void;
  onClienteChange: (cliente: ClienteInfo) => void;
  onConfirm: () => void;
  onClose: () => void;
}

export const EmpresaModal: React.FC<EmpresaModalProps> = ({
  empresa,
  cliente,
  onEmpresaChange,
  onClienteChange,
  onConfirm,
  onClose
}) => {
  return (
    <div 
      className="fixed inset-0 bg-foreground/50 flex items-center justify-center z-50 p-4"
      onClick={onClose}
    >
      <div 
        className="bg-card rounded-lg w-full max-w-md overflow-hidden border-2 border-border"
        onClick={e => e.stopPropagation()}
      >
        <div className="bg-cream p-4 border-b-2 border-border">
          <h3 className="text-foreground font-bold text-lg">Dados do Orçamento</h3>
          <p className="text-muted-foreground text-sm">Preencha para gerar o PDF</p>
        </div>

        <div className="p-4 bg-cream space-y-4 max-h-[60vh] overflow-y-auto">
          {/* Empresa */}
          <div>
            <h4 className="text-foreground font-semibold text-sm mb-2">📋 Dados da Empresa</h4>
            <div className="space-y-2">
              <input
                type="text"
                placeholder="Nome da Empresa"
                className="w-full bg-cream-dark border-2 border-border rounded px-3 py-2 text-foreground text-sm outline-none focus:border-primary"
                value={empresa.nome}
                onChange={(e) => onEmpresaChange({ ...empresa, nome: e.target.value })}
              />
              <input
                type="text"
                placeholder="CNPJ"
                className="w-full bg-cream-dark border-2 border-border rounded px-3 py-2 text-foreground text-sm outline-none focus:border-primary"
                value={empresa.cnpj}
                onChange={(e) => onEmpresaChange({ ...empresa, cnpj: e.target.value })}
              />
            </div>
          </div>

          {/* Cliente */}
          <div>
            <h4 className="text-foreground font-semibold text-sm mb-2">👤 Dados do Cliente</h4>
            <div className="space-y-2">
              <input
                type="text"
                placeholder="Nome do Cliente"
                className="w-full bg-cream-dark border-2 border-border rounded px-3 py-2 text-foreground text-sm outline-none focus:border-primary"
                value={cliente.nome}
                onChange={(e) => onClienteChange({ ...cliente, nome: e.target.value })}
              />
              <input
                type="tel"
                placeholder="Telefone"
                className="w-full bg-cream-dark border-2 border-border rounded px-3 py-2 text-foreground text-sm outline-none focus:border-primary"
                value={cliente.telefone}
                onChange={(e) => onClienteChange({ ...cliente, telefone: e.target.value })}
              />
              <textarea
                placeholder="Observações"
                rows={2}
                className="w-full bg-cream-dark border-2 border-border rounded px-3 py-2 text-foreground text-sm outline-none focus:border-primary resize-none"
                value={cliente.obs}
                onChange={(e) => onClienteChange({ ...cliente, obs: e.target.value })}
              />
            </div>
          </div>
        </div>

        <div className="p-4 bg-cream-dark border-t-2 border-border flex gap-3">
          <button
            onClick={onClose}
            className="flex-1 bg-muted border-2 border-border text-foreground py-3 rounded font-semibold hover:bg-muted/80 transition-colors"
          >
            Cancelar
          </button>
          <button
            onClick={onConfirm}
            className="flex-1 bg-accent text-accent-foreground py-3 rounded font-semibold hover:opacity-90 transition-opacity flex items-center justify-center gap-2"
          >
            <span>📄</span>
            Gerar PDF
          </button>
        </div>
      </div>
    </div>
  );
};
