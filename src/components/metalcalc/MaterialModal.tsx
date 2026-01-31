import React from 'react';
import { MATERIAIS } from '@/data/materiais';

interface MaterialModalProps {
  materialKey: string;
  onSelect: (key: string) => void;
  onClose: () => void;
}

export const MaterialModal: React.FC<MaterialModalProps> = ({ materialKey, onSelect, onClose }) => {
  return (
    <div
      className="fixed inset-0 bg-navy/60 flex items-end z-50"
      onClick={onClose}
    >
      <div
        className="bg-cream rounded-t-2xl w-full max-h-[85vh] overflow-hidden"
        style={{ border: '3px solid hsl(210 45% 25%)', borderBottom: 'none' }}
        onClick={e => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex justify-between items-center p-4" style={{ borderBottom: '2px solid hsl(210 45% 25%)' }}>
          <h3 className="text-navy font-semibold">Selecione o Material</h3>
          <button
            className="w-8 h-8 rounded-full bg-navy text-white flex items-center justify-center text-xl hover:opacity-80 transition-opacity"
            onClick={onClose}
          >
            ×
          </button>
        </div>

        {/* Material List */}
        <div className="p-4 max-h-[65vh] overflow-y-auto">
          {Object.entries(MATERIAIS).map(([key, mat]) => (
            <button
              key={key}
              className={`w-full rounded-lg p-3 mb-2 cursor-pointer flex justify-between items-center text-left transition-all ${
                materialKey === key
                  ? 'bg-primary/20'
                  : 'bg-cream-dark hover:bg-cream-dark/80'
              }`}
              style={{
                border: materialKey === key
                  ? '2px solid hsl(var(--primary))'
                  : '2px solid hsl(210 45% 25%)'
              }}
              onClick={() => onSelect(key)}
            >
              <div>
                <span className="block text-navy text-sm font-medium mb-0.5">{mat.nome}</span>
                <span className="block text-navy/60 text-xs">{mat.densidade} kg/m³</span>
              </div>
              <span className="bg-primary text-white px-2 py-1 rounded text-xs font-semibold">
                R$ {mat.precoKg.toFixed(2)}/kg
              </span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};
