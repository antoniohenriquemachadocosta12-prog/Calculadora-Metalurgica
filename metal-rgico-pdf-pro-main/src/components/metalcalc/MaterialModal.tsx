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
      className="fixed inset-0 bg-foreground/50 flex items-end z-50"
      onClick={onClose}
    >
      <div 
        className="bg-card rounded-t-2xl w-full max-h-[85vh] overflow-hidden border-t-2 border-border"
        onClick={e => e.stopPropagation()}
      >
        <div className="flex justify-between items-center p-4 border-b-2 border-border bg-cream">
          <h3 className="text-foreground font-semibold">Selecione o Material</h3>
          <button 
            className="bg-transparent border-none text-muted-foreground text-2xl cursor-pointer hover:text-foreground"
            onClick={onClose}
          >
            ×
          </button>
        </div>
        <div className="p-4 max-h-[65vh] overflow-y-auto bg-cream">
          {Object.entries(MATERIAIS).map(([key, mat]) => (
            <button
              key={key}
              className={`w-full border-2 rounded-lg p-3 mb-2 cursor-pointer flex justify-between items-center text-left transition-colors ${
                materialKey === key 
                  ? 'border-primary bg-primary/10' 
                  : 'bg-cream-dark border-border hover:border-primary/50'
              }`}
              onClick={() => onSelect(key)}
            >
              <div>
                <span className="block text-foreground text-sm font-medium mb-0.5">{mat.nome}</span>
                <span className="block text-muted-foreground text-xs">{mat.densidade} kg/m³</span>
              </div>
              <span className="text-primary text-sm font-semibold">R$ {mat.precoKg.toFixed(2)}/kg</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};
