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
      className="fixed inset-0 bg-navy/60 flex items-center justify-center z-50 p-4"
      onClick={onClose}
    >
      <div
        className="bg-cream rounded-lg w-full max-w-md overflow-hidden"
        style={{ border: '3px solid hsl(210 45% 25%)' }}
        onClick={e => e.stopPropagation()}
      >
        {/* Header */}
        <div className="p-4" style={{ borderBottom: '2px solid hsl(210 45% 25%)' }}>
          <h3 className="text-navy font-bold text-lg">Dados do Orçamento</h3>
          <p className="text-navy/60 text-sm">Preencha para gerar o PDF</p>
        </div>

        {/* Form */}
        <div className="p-4 space-y-4 max-h-[60vh] overflow-y-auto">
          {/* Empresa */}
          <div>
            <h4 className="text-navy font-semibold text-sm mb-2">Dados da Empresa</h4>
            <div className="space-y-2">
              <input
                type="text"
                placeholder="Nome da Empresa"
                className="input-field w-full"
                value={empresa.nome}
                onChange={(e) => onEmpresaChange({ ...empresa, nome: e.target.value })}
              />
              <input
                type="text"
                placeholder="CNPJ"
                className="input-field w-full"
                value={empresa.cnpj}
                onChange={(e) => onEmpresaChange({ ...empresa, cnpj: e.target.value })}
              />
            </div>
          </div>

          {/* Cliente */}
          <div>
            <h4 className="text-navy font-semibold text-sm mb-2">Dados do Cliente</h4>
            <div className="space-y-2">
              <input
                type="text"
                placeholder="Nome do Cliente"
                className="input-field w-full"
                value={cliente.nome}
                onChange={(e) => onClienteChange({ ...cliente, nome: e.target.value })}
              />
              <input
                type="tel"
                placeholder="Telefone"
                className="input-field w-full"
                value={cliente.telefone}
                onChange={(e) => onClienteChange({ ...cliente, telefone: e.target.value })}
              />
              <textarea
                placeholder="Observações"
                rows={2}
                className="input-field w-full resize-none"
                value={cliente.obs}
                onChange={(e) => onClienteChange({ ...cliente, obs: e.target.value })}
              />
            </div>
          </div>
        </div>

        {/* Buttons */}
        <div className="p-4 flex gap-3" style={{ borderTop: '2px solid hsl(210 45% 25%)' }}>
          <button
            onClick={onClose}
            className="btn-orange flex-1"
          >
            Cancelar
          </button>
          <button
            onClick={onConfirm}
            className="btn-teal flex-1 flex items-center justify-center gap-2"
          >
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M14 2H6C4.9 2 4 2.9 4 4V20C4 21.1 4.9 22 6 22H18C19.1 22 20 21.1 20 20V8L14 2ZM16 18H8V16H16V18ZM16 14H8V12H16V14ZM13 9V3.5L18.5 9H13Z" />
            </svg>
            Gerar PDF
          </button>
        </div>
      </div>
    </div>
  );
};
