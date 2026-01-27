import React from 'react';
import { PERFIS } from '@/data/perfis';
import { BottomNav } from './BottomNav';

interface ProfileMenuProps {
  onSelect: (key: string) => void;
  onViewList: () => void;
  projetosCount: number;
}

// SVG icons for each profile type
const ProfileIcons: Record<string, React.FC<{ className?: string }>> = {
  perfilC: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M12 8 L12 40 L36 40 L36 32 L20 32 L20 16 L36 16 L36 8 L12 8 Z" />
    </svg>
  ),
  perfilU: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M12 8 L12 40 L36 40 L36 8 M12 8 L12 8 M36 8 L36 8" />
      <path d="M12 8 L12 40 L36 40 L36 8" fill="none" />
    </svg>
  ),
  barraQuadrada: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <rect x="12" y="12" width="24" height="24" />
    </svg>
  ),
  barraRetangular: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <rect x="8" y="16" width="32" height="16" />
    </svg>
  ),
  barraRedonda: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <circle cx="24" cy="24" r="14" />
    </svg>
  ),
  tuboQuadrado: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <rect x="10" y="10" width="28" height="28" />
      <rect x="16" y="16" width="16" height="16" />
    </svg>
  ),
  tuboRetangular: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <rect x="6" y="14" width="36" height="20" />
      <rect x="12" y="20" width="24" height="8" />
    </svg>
  ),
  tuboRedondo: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <circle cx="24" cy="24" r="16" />
      <circle cx="24" cy="24" r="10" />
    </svg>
  ),
  cantoneira: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M10 10 L10 38 L18 38 L18 18 L38 18 L38 10 L10 10 Z" />
    </svg>
  ),
  chapa: ({ className }) => (
    <svg className={className} width="48" height="48" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="2">
      <rect x="6" y="18" width="36" height="12" />
    </svg>
  ),
};

export const ProfileMenu: React.FC<ProfileMenuProps> = ({ onSelect, onViewList, projetosCount }) => {
  const perfilKeys = Object.keys(PERFIS);
  const featuredProfile = PERFIS['perfilC'];
  const FeaturedIcon = ProfileIcons['perfilC'];

  return (
    <div className="app-container pb-24">
      {/* Main Content Card */}
      <div className="content-card">
        {/* Header with featured profile */}
        <div className="bg-cream p-4 border-b-3 border-navy flex items-center justify-center" style={{ borderBottom: '3px solid hsl(210 45% 25%)' }}>
          <div className="text-center">
            {FeaturedIcon && <FeaturedIcon className="text-navy mx-auto mb-1" />}
            <span className="text-navy font-semibold text-sm">{featuredProfile.nome}</span>
          </div>
        </div>

        {/* Grid of profiles */}
        <div className="p-3 max-h-[calc(100vh-240px)] overflow-y-auto bg-cream">
          <div className="grid grid-cols-2 gap-3">
            {perfilKeys.map((key) => {
              const IconComponent = ProfileIcons[key];
              return (
                <button
                  key={key}
                  className="profile-cell p-3"
                  onClick={() => onSelect(key)}
                >
                  {IconComponent && <IconComponent className="text-navy mb-1" />}
                  <span className="text-navy text-xs font-medium text-center leading-tight">
                    {PERFIS[key].nome}
                  </span>
                </button>
              );
            })}
          </div>
        </div>
      </div>

      {/* Bottom Navigation */}
      <BottomNav
        leftAction={{
          label: 'Cadastro',
          onClick: () => {},
          variant: 'orange'
        }}
        rightAction={{
          label: 'Lista',
          onClick: onViewList,
          badge: projetosCount,
          variant: 'teal'
        }}
      />
    </div>
  );
};
