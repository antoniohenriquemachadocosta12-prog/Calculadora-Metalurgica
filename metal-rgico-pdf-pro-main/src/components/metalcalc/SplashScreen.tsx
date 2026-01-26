import React from 'react';

interface SplashScreenProps {
  onStart: () => void;
}

export const SplashScreen: React.FC<SplashScreenProps> = ({ onStart }) => {
  return (
    <div className="min-h-screen bg-primary flex flex-col items-center justify-center p-5">
      <button
        onClick={onStart}
        className="w-32 h-32 rounded-full bg-foreground/20 flex items-center justify-center shadow-button hover:scale-105 transition-transform active:scale-95"
      >
        <div className="text-center">
          <span className="text-6xl font-bold text-primary-foreground italic block">M</span>
          <span className="text-xs text-primary-foreground/80 font-medium">INICIAR</span>
        </div>
      </button>
    </div>
  );
};
