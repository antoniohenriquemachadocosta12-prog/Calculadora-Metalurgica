import React from 'react';

interface DiagramProps {
  medidas: Record<string, number>;
}

export const DiagramaPerfilC: React.FC<DiagramProps> = ({ medidas }) => {
  const { altura = 0, largura = 0, aba = 0, espessura = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 280 220" className="w-full max-w-[320px] h-auto">
      <g transform="translate(90, 30)">
        <path
          d="M 0 0 L 80 0 L 80 15 L 15 15 L 15 85 L 80 85 L 80 100 L 0 100 Z"
          fill="none"
          stroke="hsl(var(--primary))"
          strokeWidth="3"
        />
        <line x1="-25" y1="0" x2="-25" y2="100" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-30" y1="0" x2="-20" y2="0" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-30" y1="100" x2="-20" y2="100" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="115" x2="80" y2="115" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="110" x2="0" y2="120" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="80" y1="110" x2="80" y2="120" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="-15" x2="80" y2="-15" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="80" y1="-20" x2="80" y2="-10" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="-20" x2="0" y2="-10" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="95" y1="0" x2="95" y2="15" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="90" y1="0" x2="100" y2="0" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="90" y1="15" x2="100" y2="15" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
      </g>
      <g transform="translate(50, 80)">
        <rect x="-25" y="-12" width="50" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{altura || '?'} mm</text>
      </g>
      <text x="50" y="190" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">ALTURA</text>
      <g transform="translate(130, 160)">
        <rect x="-30" y="-12" width="60" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{largura || '?'} mm</text>
      </g>
      <text x="130" y="195" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">LARGURA</text>
      <g transform="translate(130, 10)">
        <rect x="-25" y="-8" width="50" height="20" rx="6" fill="hsl(var(--info))" />
        <text x="0" y="7" textAnchor="middle" fill="white" fontSize="12" fontWeight="bold">{aba || '?'} mm</text>
      </g>
      <g transform="translate(200, 45)">
        <rect x="-20" y="-10" width="50" height="20" rx="6" fill="hsl(var(--success))" />
        <text x="5" y="5" textAnchor="middle" fill="white" fontSize="11" fontWeight="bold">{espessura || '?'} mm</text>
      </g>
      <text x="220" y="70" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="10">ESP.</text>
    </svg>
  );
};

export const DiagramaPerfilU: React.FC<DiagramProps> = ({ medidas }) => {
  const { altura = 0, largura = 0, espessura = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 280 200" className="w-full max-w-[320px] h-auto">
      <g transform="translate(90, 30)">
        <path
          d="M 0 0 L 0 90 L 80 90 L 80 0 L 65 0 L 65 75 L 15 75 L 15 0 Z"
          fill="none"
          stroke="hsl(var(--primary))"
          strokeWidth="3"
        />
        <line x1="-25" y1="0" x2="-25" y2="90" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-30" y1="0" x2="-20" y2="0" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-30" y1="90" x2="-20" y2="90" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="105" x2="80" y2="105" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="100" x2="0" y2="110" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="80" y1="100" x2="80" y2="110" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
      </g>
      <g transform="translate(50, 75)">
        <rect x="-25" y="-12" width="50" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{altura || '?'} mm</text>
      </g>
      <text x="50" y="170" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">ALTURA</text>
      <g transform="translate(130, 150)">
        <rect x="-30" y="-12" width="60" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{largura || '?'} mm</text>
      </g>
      <text x="130" y="180" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">LARGURA</text>
      <g transform="translate(200, 50)">
        <rect x="-20" y="-10" width="50" height="20" rx="6" fill="hsl(var(--success))" />
        <text x="5" y="5" textAnchor="middle" fill="white" fontSize="11" fontWeight="bold">{espessura || '?'} mm</text>
      </g>
      <text x="220" y="75" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="10">ESP.</text>
    </svg>
  );
};

export const DiagramaBarraQuadrada: React.FC<DiagramProps> = ({ medidas }) => {
  const { lado = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 250 180" className="w-full max-w-[280px] h-auto">
      <g transform="translate(75, 30)">
        <rect x="0" y="0" width="80" height="80" fill="none" stroke="hsl(var(--primary))" strokeWidth="3" />
        <line x1="-20" y1="0" x2="-20" y2="80" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="0" x2="-15" y2="0" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="80" x2="-15" y2="80" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="95" x2="80" y2="95" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="90" x2="0" y2="100" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="80" y1="90" x2="80" y2="100" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
      </g>
      <g transform="translate(40, 70)">
        <rect x="-25" y="-12" width="50" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{lado || '?'} mm</text>
      </g>
      <g transform="translate(115, 140)">
        <rect x="-25" y="-12" width="50" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{lado || '?'} mm</text>
      </g>
      <text x="125" y="170" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">LADO</text>
    </svg>
  );
};

export const DiagramaBarraRetangular: React.FC<DiagramProps> = ({ medidas }) => {
  const { largura = 0, altura = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 280 180" className="w-full max-w-[320px] h-auto">
      <g transform="translate(80, 30)">
        <rect x="0" y="0" width="100" height="70" fill="none" stroke="hsl(var(--primary))" strokeWidth="3" />
        <line x1="-20" y1="0" x2="-20" y2="70" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="0" x2="-15" y2="0" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="70" x2="-15" y2="70" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="85" x2="100" y2="85" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="80" x2="0" y2="90" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="100" y1="80" x2="100" y2="90" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
      </g>
      <g transform="translate(45, 65)">
        <rect x="-25" y="-12" width="50" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{altura || '?'} mm</text>
      </g>
      <text x="45" y="150" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">ALTURA</text>
      <g transform="translate(130, 130)">
        <rect x="-30" y="-12" width="60" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{largura || '?'} mm</text>
      </g>
      <text x="130" y="160" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">LARGURA</text>
    </svg>
  );
};

export const DiagramaBarraRedonda: React.FC<DiagramProps> = ({ medidas }) => {
  const { diametro = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 250 180" className="w-full max-w-[280px] h-auto">
      <g transform="translate(85, 30)">
        <circle cx="40" cy="40" r="40" fill="none" stroke="hsl(var(--primary))" strokeWidth="3" />
        <line x1="0" y1="40" x2="80" y2="40" stroke="hsl(var(--muted-foreground))" strokeWidth="1" strokeDasharray="4,2" />
        <circle cx="0" cy="40" r="3" fill="hsl(var(--primary))" />
        <circle cx="80" cy="40" r="3" fill="hsl(var(--primary))" />
      </g>
      <g transform="translate(125, 130)">
        <rect x="-30" y="-12" width="60" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">Ø {diametro || '?'} mm</text>
      </g>
      <text x="125" y="160" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">DIÂMETRO</text>
    </svg>
  );
};

export const DiagramaTuboQuadrado: React.FC<DiagramProps> = ({ medidas }) => {
  const { lado = 0, espessura = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 260 190" className="w-full max-w-[300px] h-auto">
      <g transform="translate(80, 30)">
        <rect x="0" y="0" width="80" height="80" fill="none" stroke="hsl(var(--primary))" strokeWidth="3" />
        <rect x="12" y="12" width="56" height="56" fill="hsl(var(--background))" stroke="hsl(var(--primary))" strokeWidth="2" />
        <line x1="0" y1="95" x2="80" y2="95" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="90" x2="0" y2="100" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="80" y1="90" x2="80" y2="100" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="-10" x2="12" y2="-10" stroke="hsl(var(--success))" strokeWidth="2" />
        <line x1="0" y1="-15" x2="0" y2="-5" stroke="hsl(var(--success))" strokeWidth="1" />
        <line x1="12" y1="-15" x2="12" y2="-5" stroke="hsl(var(--success))" strokeWidth="1" />
      </g>
      <g transform="translate(120, 140)">
        <rect x="-25" y="-12" width="50" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{lado || '?'} mm</text>
      </g>
      <text x="120" y="170" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">LADO EXT.</text>
      <g transform="translate(120, 15)">
        <rect x="-25" y="-10" width="50" height="20" rx="6" fill="hsl(var(--success))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="11" fontWeight="bold">{espessura || '?'} mm</text>
      </g>
      <text x="180" y="18" textAnchor="start" fill="hsl(var(--muted-foreground))" fontSize="10">ESPESSURA</text>
    </svg>
  );
};

export const DiagramaTuboRetangular: React.FC<DiagramProps> = ({ medidas }) => {
  const { largura = 0, altura = 0, espessura = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 280 190" className="w-full max-w-[320px] h-auto">
      <g transform="translate(80, 35)">
        <rect x="0" y="0" width="100" height="70" fill="none" stroke="hsl(var(--primary))" strokeWidth="3" />
        <rect x="10" y="10" width="80" height="50" fill="hsl(var(--background))" stroke="hsl(var(--primary))" strokeWidth="2" />
        <line x1="-20" y1="0" x2="-20" y2="70" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="0" x2="-15" y2="0" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="70" x2="-15" y2="70" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="85" x2="100" y2="85" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="80" x2="0" y2="90" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="100" y1="80" x2="100" y2="90" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="-10" x2="10" y2="-10" stroke="hsl(var(--success))" strokeWidth="2" />
      </g>
      <g transform="translate(45, 70)">
        <rect x="-25" y="-12" width="50" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{altura || '?'} mm</text>
      </g>
      <g transform="translate(130, 135)">
        <rect x="-30" y="-12" width="60" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{largura || '?'} mm</text>
      </g>
      <g transform="translate(105, 20)">
        <rect x="-22" y="-10" width="44" height="20" rx="6" fill="hsl(var(--success))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="11" fontWeight="bold">{espessura || '?'} mm</text>
      </g>
      <text x="160" y="23" textAnchor="start" fill="hsl(var(--muted-foreground))" fontSize="10">ESP.</text>
    </svg>
  );
};

export const DiagramaTuboRedondo: React.FC<DiagramProps> = ({ medidas }) => {
  const { diametroExterno = 0, espessura = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 260 190" className="w-full max-w-[300px] h-auto">
      <g transform="translate(90, 30)">
        <circle cx="40" cy="40" r="40" fill="none" stroke="hsl(var(--primary))" strokeWidth="3" />
        <circle cx="40" cy="40" r="28" fill="hsl(var(--background))" stroke="hsl(var(--primary))" strokeWidth="2" />
        <line x1="0" y1="40" x2="80" y2="40" stroke="hsl(var(--muted-foreground))" strokeWidth="1" strokeDasharray="4,2" />
        <line x1="40" y1="0" x2="40" y2="12" stroke="hsl(var(--success))" strokeWidth="2" />
      </g>
      <g transform="translate(130, 130)">
        <rect x="-35" y="-12" width="70" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="12" fontWeight="bold">Ø {diametroExterno || '?'} mm</text>
      </g>
      <text x="130" y="160" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">DIÂM. EXT.</text>
      <g transform="translate(130, 15)">
        <rect x="-25" y="-10" width="50" height="20" rx="6" fill="hsl(var(--success))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="11" fontWeight="bold">{espessura || '?'} mm</text>
      </g>
      <text x="190" y="18" textAnchor="start" fill="hsl(var(--muted-foreground))" fontSize="10">ESP.</text>
    </svg>
  );
};

export const DiagramaCantoneira: React.FC<DiagramProps> = ({ medidas }) => {
  const { aba1 = 0, aba2 = 0, espessura = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 260 200" className="w-full max-w-[300px] h-auto">
      <g transform="translate(90, 30)">
        <path
          d="M 0 0 L 70 0 L 70 12 L 12 12 L 12 80 L 0 80 Z"
          fill="none"
          stroke="hsl(var(--primary))"
          strokeWidth="3"
        />
        <line x1="-20" y1="0" x2="-20" y2="80" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="0" x2="-15" y2="0" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="80" x2="-15" y2="80" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="-15" x2="70" y2="-15" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="-20" x2="0" y2="-10" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="70" y1="-20" x2="70" y2="-10" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
      </g>
      <g transform="translate(55, 70)">
        <rect x="-25" y="-12" width="50" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{aba1 || '?'} mm</text>
      </g>
      <text x="55" y="175" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="11">ABA 1</text>
      <g transform="translate(125, 10)">
        <rect x="-25" y="-8" width="50" height="20" rx="6" fill="hsl(var(--info))" />
        <text x="0" y="6" textAnchor="middle" fill="white" fontSize="12" fontWeight="bold">{aba2 || '?'} mm</text>
      </g>
      <text x="180" y="13" textAnchor="start" fill="hsl(var(--muted-foreground))" fontSize="10">ABA 2</text>
      <g transform="translate(200, 55)">
        <rect x="-22" y="-10" width="44" height="20" rx="6" fill="hsl(var(--success))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="11" fontWeight="bold">{espessura || '?'} mm</text>
      </g>
      <text x="200" y="75" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="10">ESP.</text>
    </svg>
  );
};

export const DiagramaChapa: React.FC<DiagramProps> = ({ medidas }) => {
  const { largura = 0, altura = 0, espessura = 0 } = medidas;
  
  return (
    <svg viewBox="0 0 280 180" className="w-full max-w-[320px] h-auto">
      <g transform="translate(70, 40)">
        <rect x="0" y="0" width="120" height="80" fill="none" stroke="hsl(var(--primary))" strokeWidth="3" />
        <line x1="120" y1="0" x2="135" y2="-10" stroke="hsl(var(--primary))" strokeWidth="2" />
        <line x1="120" y1="80" x2="135" y2="70" stroke="hsl(var(--primary))" strokeWidth="2" />
        <line x1="135" y1="-10" x2="135" y2="70" stroke="hsl(var(--primary))" strokeWidth="2" />
        <line x1="-20" y1="0" x2="-20" y2="80" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="0" x2="-15" y2="0" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="-25" y1="80" x2="-15" y2="80" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="95" x2="120" y2="95" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="0" y1="90" x2="0" y2="100" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
        <line x1="120" y1="90" x2="120" y2="100" stroke="hsl(var(--muted-foreground))" strokeWidth="1" />
      </g>
      <g transform="translate(35, 80)">
        <rect x="-25" y="-12" width="50" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{altura || '?'} mm</text>
      </g>
      <g transform="translate(130, 150)">
        <rect x="-30" y="-12" width="60" height="24" rx="6" fill="hsl(var(--primary))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="13" fontWeight="bold">{largura || '?'} mm</text>
      </g>
      <g transform="translate(220, 50)">
        <rect x="-22" y="-10" width="44" height="20" rx="6" fill="hsl(var(--success))" />
        <text x="0" y="5" textAnchor="middle" fill="white" fontSize="11" fontWeight="bold">{espessura || '?'} mm</text>
      </g>
      <text x="220" y="75" textAnchor="middle" fill="hsl(var(--muted-foreground))" fontSize="10">ESP.</text>
    </svg>
  );
};

export const DIAGRAMAS: Record<string, React.FC<DiagramProps>> = {
  perfilC: DiagramaPerfilC,
  perfilU: DiagramaPerfilU,
  barraQuadrada: DiagramaBarraQuadrada,
  barraRetangular: DiagramaBarraRetangular,
  barraRedonda: DiagramaBarraRedonda,
  tuboQuadrado: DiagramaTuboQuadrado,
  tuboRetangular: DiagramaTuboRetangular,
  tuboRedondo: DiagramaTuboRedondo,
  cantoneira: DiagramaCantoneira,
  chapa: DiagramaChapa,
};
