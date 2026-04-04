import React from 'react';
import { Logo } from './Logo';

interface SplashScreenProps {
  onStart: () => void;
}

export const SplashScreen: React.FC<SplashScreenProps> = ({ onStart }) => {
  return (
    <div className="app-container items-center justify-center gap-6">
      <Logo size="xl" onClick={onStart} />
      <div className="text-center">
        <h1 className="text-white text-3xl font-bold tracking-wide">MontarCalcPro</h1>
        <p className="text-white/70 text-sm mt-1">Calculadora Metalúrgica Profissional</p>
      </div>
      <button
        type="button"
        onClick={onStart}
        className="mt-2 px-8 py-3 rounded-lg font-semibold text-base shadow-button"
        style={{ backgroundColor: 'hsl(var(--accent))', color: 'white', border: '2px solid hsl(var(--navy))' }}
      >
        Iniciar
      </button>
    </div>
  );
};
