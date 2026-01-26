import React from 'react';

interface BottomNavProps {
  leftAction?: {
    label: string;
    onClick: () => void;
  };
  rightAction?: {
    label: string;
    onClick: () => void;
    badge?: number;
  };
}

export const BottomNav: React.FC<BottomNavProps> = ({ leftAction, rightAction }) => {
  return (
    <div className="fixed bottom-0 left-0 right-0 bg-primary p-3 flex items-center justify-between safe-area-bottom">
      {/* Logo */}
      <div className="w-14 h-14 rounded-full bg-foreground/20 flex items-center justify-center shadow-button">
        <span className="text-3xl font-bold text-primary-foreground italic">M</span>
      </div>

      <div className="flex gap-3">
        {leftAction && (
          <button
            onClick={leftAction.onClick}
            className="bg-cream text-foreground px-6 py-3 rounded-lg font-semibold text-base shadow-button border-2 border-border hover:bg-cream-dark transition-colors"
          >
            {leftAction.label}
          </button>
        )}
        
        {rightAction && (
          <button
            onClick={rightAction.onClick}
            className="bg-accent text-accent-foreground px-6 py-3 rounded-lg font-semibold text-base shadow-button relative hover:opacity-90 transition-opacity"
          >
            {rightAction.label}
            {rightAction.badge !== undefined && rightAction.badge > 0 && (
              <span className="absolute -top-2 -right-2 bg-destructive text-destructive-foreground rounded-full w-6 h-6 flex items-center justify-center text-xs font-bold">
                {rightAction.badge}
              </span>
            )}
          </button>
        )}
      </div>
    </div>
  );
};
