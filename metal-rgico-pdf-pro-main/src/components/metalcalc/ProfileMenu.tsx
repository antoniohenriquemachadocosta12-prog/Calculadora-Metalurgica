import React from 'react';
import { PERFIS } from '@/data/perfis';
import { BottomNav } from './BottomNav';

interface ProfileMenuProps {
  onSelect: (key: string) => void;
  onViewList: () => void;
  projetosCount: number;
}

export const ProfileMenu: React.FC<ProfileMenuProps> = ({ onSelect, onViewList, projetosCount }) => {
  const perfilKeys = Object.keys(PERFIS);
  
  return (
    <div className="min-h-screen bg-primary pb-24">
      {/* Main Content Card */}
      <div className="mx-3 mt-3 bg-card rounded-lg border-2 border-border overflow-hidden">
        {/* Header with featured profile */}
        <div className="bg-cream p-4 border-b-2 border-border flex items-center justify-center">
          <div className="text-center">
            <span className="text-4xl block mb-1">📐</span>
            <span className="text-foreground font-semibold text-sm">Perfil "C"</span>
          </div>
        </div>
        
        {/* Grid of profiles */}
        <div className="p-3 max-h-[calc(100vh-220px)] overflow-y-auto">
          <div className="grid grid-cols-2 gap-2">
            {perfilKeys.map((key) => (
              <button 
                key={key} 
                className="bg-cream border-2 border-border rounded-lg p-4 cursor-pointer flex flex-col items-center justify-center gap-2 hover:bg-cream-dark transition-colors active:scale-95 min-h-[80px]"
                onClick={() => onSelect(key)}
              >
                <span className="text-2xl">{PERFIS[key].icone}</span>
                <span className="text-foreground text-xs font-medium text-center leading-tight">{PERFIS[key].nome}</span>
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Bottom Navigation */}
      <BottomNav
        leftAction={{
          label: 'Cadastro',
          onClick: () => {}
        }}
        rightAction={{
          label: 'Lista',
          onClick: onViewList,
          badge: projetosCount
        }}
      />
    </div>
  );
};
