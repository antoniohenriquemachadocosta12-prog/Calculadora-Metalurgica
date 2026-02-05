import React, { forwardRef } from 'react';
import { Logo } from './Logo';

interface BottomNavProps {
  leftAction?: {
    label: string;
    onClick: () => void;
    variant?: 'orange' | 'teal';
  };
  rightAction?: {
    label: string;
    onClick: () => void;
    variant?: 'orange' | 'teal';
    badge?: number;
    icon?: React.ReactNode;
  };
  showPdfButton?: boolean;
  onPdfClick?: () => void;
  onLogoClick?: () => void;
}

export const BottomNav = forwardRef<HTMLDivElement, BottomNavProps>(({
  leftAction,
  rightAction,
  showPdfButton,
  onPdfClick,
  onLogoClick
}, ref) => {
  return (
    <div ref={ref} className="bottom-nav flex items-center justify-between">
      {/* Logo as Voltar button */}
      <Logo size="sm" onClick={onLogoClick} label="Voltar" />

      <div className="flex gap-3">
        {leftAction && (
          <button
            onClick={leftAction.onClick}
            className={leftAction.variant === 'teal' ? 'btn-teal' : 'btn-orange'}
          >
            {leftAction.label}
          </button>
        )}

        {rightAction && (
          <button
            onClick={rightAction.onClick}
            className={`${rightAction.variant === 'orange' ? 'btn-orange' : 'btn-teal'} relative flex items-center gap-2`}
          >
            {rightAction.icon}
            {rightAction.label}
            {rightAction.badge !== undefined && rightAction.badge > 0 && (
              <span className="absolute -top-2 -right-2 bg-destructive text-white rounded-full w-6 h-6 flex items-center justify-center text-xs font-bold">
                {rightAction.badge}
              </span>
            )}
          </button>
        )}

        {showPdfButton && (
          <button
            onClick={onPdfClick}
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
});

BottomNav.displayName = 'BottomNav';
