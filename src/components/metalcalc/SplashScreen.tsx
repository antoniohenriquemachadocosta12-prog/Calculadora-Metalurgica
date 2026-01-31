import React from 'react';
import { Logo } from './Logo';

interface SplashScreenProps {
  onStart: () => void;
}

export const SplashScreen: React.FC<SplashScreenProps> = ({ onStart }) => {
  return (
    <div className="app-container items-center justify-center">
      <Logo size="xl" onClick={onStart} />
      <p className="text-primary-foreground/60 text-sm mt-4 font-medium">
        Toque para iniciar
      </p>
    </div>
  );
};
