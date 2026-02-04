import React, { useState } from 'react';
import { PERFIS } from '@/data/perfis';
import { MATERIAIS } from '@/data/materiais';
import { calcularPesoEValor } from '@/utils/calculos';
import { Projeto, Resultado } from '@/types/projeto';
import { MaterialModal } from './MaterialModal';
import { BottomNav } from './BottomNav';

interface MeasurementFormProps {
  tipoPerfil: string;
  onBack: () => void;
  onAddToList: (projeto: Projeto) => void;
  onViewList: () => void;
  projetosCount: number;
}

// Labeled input positioned around diagrams
const LabeledInput: React.FC<{
  label: string;
  unidade: string;
  value: number | string;
  onChange: (val: string) => void;
  placeholder?: string;
}> = ({ label, unidade, value, onChange, placeholder = '0' }) => (
  <div className="flex flex-col items-center gap-0.5">
    <label className="text-navy text-[10px] font-bold uppercase tracking-wide">{label}</label>
    <div className="flex items-center gap-1">
      <input
        type="number"
        inputMode="decimal"
        className="input-field w-16 text-center text-sm font-semibold py-1"
        placeholder={placeholder}
        value={value || ''}
        onChange={(e) => onChange(e.target.value)}
      />
      <span className="text-navy text-[10px] font-medium">{unidade}</span>
    </div>
  </div>
);

// Arrow dimension line helper
const DimensionArrow: React.FC<{
  x1: number; y1: number; x2: number; y2: number;
  color?: string;
}> = ({ x1, y1, x2, y2, color = 'hsl(24 70% 50%)' }) => {
  const angle = Math.atan2(y2 - y1, x2 - x1);
  const arrowSize = 6;
  return (
    <g>
      <line x1={x1} y1={y1} x2={x2} y2={y2} stroke={color} strokeWidth="1" />
      {/* Arrow at start */}
      <polygon points={`${x1},${y1} ${x1 + arrowSize * Math.cos(angle - 0.5)},${y1 + arrowSize * Math.sin(angle - 0.5)} ${x1 + arrowSize * Math.cos(angle + 0.5)},${y1 + arrowSize * Math.sin(angle + 0.5)}`} fill={color} />
      {/* Arrow at end */}
      <polygon points={`${x2},${y2} ${x2 - arrowSize * Math.cos(angle - 0.5)},${y2 - arrowSize * Math.sin(angle - 0.5)} ${x2 - arrowSize * Math.cos(angle + 0.5)},${y2 - arrowSize * Math.sin(angle + 0.5)}`} fill={color} />
    </g>
  );
};

// ===== TECHNICAL DRAWINGS FOR EACH PROFILE =====

const DiagramaPerfilC: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="relative w-full max-w-[300px]">
      <svg viewBox="0 0 280 220" className="w-full h-auto">
        {/* C-channel cross section */}
        <g transform="translate(90, 20)">
          {/* Outer shape */}
          <path d="M 0 0 L 80 0 L 80 15 L 15 15 L 15 145 L 80 145 L 80 160 L 0 160 Z"
            fill="hsl(42 40% 92%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />
          {/* Inner hatching for thickness */}
          <path d="M 0 0 L 80 0 L 80 15 L 15 15 L 15 145 L 80 145 L 80 160 L 0 160 Z"
            fill="none" stroke="hsl(210 45% 25%)" strokeWidth="0.5" strokeDasharray="3,3" />

          {/* Dimension: Altura - left side */}
          <DimensionArrow x1={-20} y1={0} x2={-20} y2={160} />
          <line x1={-5} y1={0} x2={-25} y2={0} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={-5} y1={160} x2={-25} y2={160} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Largura - bottom */}
          <DimensionArrow x1={0} y1={180} x2={80} y2={180} />
          <line x1={0} y1={165} x2={0} y2={185} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={80} y1={165} x2={80} y2={185} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Aba - top */}
          <DimensionArrow x1={0} y1={-12} x2={80} y2={-12} />
          <text x={40} y={-15} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Aba</text>

          {/* Dimension: Espessura - on wall */}
          <DimensionArrow x1={0} y1={7.5} x2={15} y2={7.5} />
          <text x={7.5} y={-2} textAnchor="middle" fontSize="8" fill="hsl(24 70% 50%)" fontWeight="bold">e</text>
        </g>

        {/* Labels on drawing */}
        <text x={55} y={110} textAnchor="middle" fontSize="10" fill="hsl(24 70% 50%)" fontWeight="bold">Altura</text>
        <text x={170} y={215} textAnchor="middle" fontSize="10" fill="hsl(24 70% 50%)" fontWeight="bold">Largura</text>
      </svg>
    </div>

    {/* Input fields in organized grid */}
    <div className="grid grid-cols-3 gap-2 w-full max-w-xs">
      <LabeledInput label="Altura" unidade="mm" value={medidas.altura} onChange={(v) => onChange('altura', v)} />
      <LabeledInput label="Largura" unidade="mm" value={medidas.largura} onChange={(v) => onChange('largura', v)} />
      <LabeledInput label="Aba" unidade="mm" value={medidas.aba} onChange={(v) => onChange('aba', v)} />
      <LabeledInput label="Espessura" unidade="mm" value={medidas.espessura} onChange={(v) => onChange('espessura', v)} />
      <LabeledInput label="Comprim." unidade="mm" value={medidas.comprimento} onChange={(v) => onChange('comprimento', v)} />
      <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
    </div>
  </div>
);

const DiagramaPerfilU: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="relative w-full max-w-[280px]">
      <svg viewBox="0 0 260 210" className="w-full h-auto">
        <g transform="translate(80, 15)">
          {/* U-channel */}
          <path d="M 0 0 L 0 140 L 100 140 L 100 0 L 85 0 L 85 125 L 15 125 L 15 0 Z"
            fill="hsl(42 40% 92%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />

          {/* Dimension: Altura - left */}
          <DimensionArrow x1={-20} y1={0} x2={-20} y2={140} />
          <line x1={-5} y1={0} x2={-25} y2={0} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={-5} y1={140} x2={-25} y2={140} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Largura - bottom */}
          <DimensionArrow x1={0} y1={160} x2={100} y2={160} />
          <line x1={0} y1={145} x2={0} y2={165} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={100} y1={145} x2={100} y2={165} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Espessura */}
          <DimensionArrow x1={0} y1={-10} x2={15} y2={-10} />
          <text x={7.5} y={-14} textAnchor="middle" fontSize="8" fill="hsl(24 70% 50%)" fontWeight="bold">e</text>
        </g>

        <text x={45} y={95} textAnchor="middle" fontSize="10" fill="hsl(24 70% 50%)" fontWeight="bold">Altura</text>
        <text x={165} y={195} textAnchor="middle" fontSize="10" fill="hsl(24 70% 50%)" fontWeight="bold">Largura</text>
      </svg>
    </div>
    <div className="grid grid-cols-2 gap-2 w-full max-w-xs">
      <LabeledInput label="Altura" unidade="mm" value={medidas.altura} onChange={(v) => onChange('altura', v)} />
      <LabeledInput label="Largura" unidade="mm" value={medidas.largura} onChange={(v) => onChange('largura', v)} />
      <LabeledInput label="Espessura" unidade="mm" value={medidas.espessura} onChange={(v) => onChange('espessura', v)} />
      <LabeledInput label="Comprim." unidade="mm" value={medidas.comprimento} onChange={(v) => onChange('comprimento', v)} />
      <div className="col-span-2 flex justify-center">
        <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
      </div>
    </div>
  </div>
);

const DiagramaBarraQuadrada: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="w-full max-w-[220px]">
      <svg viewBox="0 0 200 200" className="w-full h-auto">
        <g transform="translate(40, 20)">
          <rect x={0} y={0} width={120} height={120} fill="hsl(42 40% 92%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />
          {/* Diagonal hatching */}
          <line x1={0} y1={0} x2={120} y2={120} stroke="hsl(210 45% 25%/0.2)" strokeWidth="0.5" />
          <line x1={120} y1={0} x2={0} y2={120} stroke="hsl(210 45% 25%/0.2)" strokeWidth="0.5" />

          {/* Dimension: Lado - left */}
          <DimensionArrow x1={-15} y1={0} x2={-15} y2={120} />
          <line x1={-5} y1={0} x2={-20} y2={0} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={-5} y1={120} x2={-20} y2={120} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Lado - bottom */}
          <DimensionArrow x1={0} y1={140} x2={120} y2={140} />
          <line x1={0} y1={125} x2={0} y2={145} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={120} y1={125} x2={120} y2={145} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
        </g>
        <text x={15} y={85} textAnchor="middle" fontSize="10" fill="hsl(24 70% 50%)" fontWeight="bold">Lado</text>
        <text x={100} y={178} textAnchor="middle" fontSize="10" fill="hsl(24 70% 50%)" fontWeight="bold">Lado</text>
      </svg>
    </div>
    <div className="grid grid-cols-3 gap-2 w-full max-w-xs">
      <LabeledInput label="Lado" unidade="mm" value={medidas.lado} onChange={(v) => onChange('lado', v)} />
      <LabeledInput label="Comprim." unidade="mm" value={medidas.comprimento} onChange={(v) => onChange('comprimento', v)} />
      <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
    </div>
  </div>
);

const DiagramaBarraRetangular: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="w-full max-w-[260px]">
      <svg viewBox="0 0 240 170" className="w-full h-auto">
        <g transform="translate(40, 15)">
          <rect x={0} y={0} width={150} height={80} fill="hsl(42 40% 92%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />
          <line x1={0} y1={0} x2={150} y2={80} stroke="hsl(210 45% 25%/0.2)" strokeWidth="0.5" />
          <line x1={150} y1={0} x2={0} y2={80} stroke="hsl(210 45% 25%/0.2)" strokeWidth="0.5" />

          {/* Dimension: Altura - left */}
          <DimensionArrow x1={-15} y1={0} x2={-15} y2={80} />
          <line x1={-5} y1={0} x2={-20} y2={0} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={-5} y1={80} x2={-20} y2={80} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Largura - bottom */}
          <DimensionArrow x1={0} y1={100} x2={150} y2={100} />
          <line x1={0} y1={85} x2={0} y2={105} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={150} y1={85} x2={150} y2={105} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
        </g>
        <text x={15} y={60} textAnchor="middle" fontSize="10" fill="hsl(24 70% 50%)" fontWeight="bold">Altura</text>
        <text x={115} y={132} textAnchor="middle" fontSize="10" fill="hsl(24 70% 50%)" fontWeight="bold">Largura</text>
      </svg>
    </div>
    <div className="grid grid-cols-3 gap-2 w-full max-w-xs">
      <LabeledInput label="Largura" unidade="mm" value={medidas.largura} onChange={(v) => onChange('largura', v)} />
      <LabeledInput label="Altura" unidade="mm" value={medidas.altura} onChange={(v) => onChange('altura', v)} />
      <LabeledInput label="Comprim." unidade="mm" value={medidas.comprimento} onChange={(v) => onChange('comprimento', v)} />
      <div className="col-span-3 flex justify-center">
        <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
      </div>
    </div>
  </div>
);

const DiagramaBarraRedonda: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="w-full max-w-[200px]">
      <svg viewBox="0 0 180 180" className="w-full h-auto">
        <g transform="translate(90, 90)">
          <circle cx={0} cy={0} r={60} fill="hsl(42 40% 92%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />
          {/* Center cross */}
          <line x1={-5} y1={0} x2={5} y2={0} stroke="hsl(210 45% 25%)" strokeWidth="1" />
          <line x1={0} y1={-5} x2={0} y2={5} stroke="hsl(210 45% 25%)" strokeWidth="1" />

          {/* Dimension: Diâmetro */}
          <DimensionArrow x1={-60} y1={0} x2={60} y2={0} />
        </g>
        <text x={90} y={80} textAnchor="middle" fontSize="10" fill="hsl(24 70% 50%)" fontWeight="bold">Diâmetro</text>
      </svg>
    </div>
    <div className="grid grid-cols-3 gap-2 w-full max-w-xs">
      <LabeledInput label="Diâmetro" unidade="mm" value={medidas.diametro} onChange={(v) => onChange('diametro', v)} />
      <LabeledInput label="Comprim." unidade="mm" value={medidas.comprimento} onChange={(v) => onChange('comprimento', v)} />
      <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
    </div>
  </div>
);

const DiagramaTuboQuadrado: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="w-full max-w-[220px]">
      <svg viewBox="0 0 200 200" className="w-full h-auto">
        <g transform="translate(40, 20)">
          {/* Outer */}
          <rect x={0} y={0} width={120} height={120} fill="hsl(42 40% 88%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />
          {/* Inner (hollow) */}
          <rect x={18} y={18} width={84} height={84} fill="hsl(42 40% 96%)" stroke="hsl(210 45% 25%)" strokeWidth="1.5" />

          {/* Dimension: Lado Ext - left */}
          <DimensionArrow x1={-15} y1={0} x2={-15} y2={120} />
          <line x1={-5} y1={0} x2={-20} y2={0} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={-5} y1={120} x2={-20} y2={120} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Espessura - top */}
          <DimensionArrow x1={0} y1={-10} x2={18} y2={-10} />
          <text x={9} y={-14} textAnchor="middle" fontSize="8" fill="hsl(24 70% 50%)" fontWeight="bold">e</text>

          {/* Dimension: Lado - bottom */}
          <DimensionArrow x1={0} y1={140} x2={120} y2={140} />
          <line x1={0} y1={125} x2={0} y2={145} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={120} y1={125} x2={120} y2={145} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
        </g>
        <text x={15} y={85} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Lado</text>
        <text x={100} y={178} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Lado Ext.</text>
      </svg>
    </div>
    <div className="grid grid-cols-3 gap-2 w-full max-w-xs">
      <LabeledInput label="Lado Ext." unidade="mm" value={medidas.lado} onChange={(v) => onChange('lado', v)} />
      <LabeledInput label="Espessura" unidade="mm" value={medidas.espessura} onChange={(v) => onChange('espessura', v)} />
      <LabeledInput label="Comprim." unidade="mm" value={medidas.comprimento} onChange={(v) => onChange('comprimento', v)} />
      <div className="col-span-3 flex justify-center">
        <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
      </div>
    </div>
  </div>
);

const DiagramaTuboRetangular: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="w-full max-w-[260px]">
      <svg viewBox="0 0 240 170" className="w-full h-auto">
        <g transform="translate(40, 15)">
          {/* Outer */}
          <rect x={0} y={0} width={150} height={90} fill="hsl(42 40% 88%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />
          {/* Inner */}
          <rect x={18} y={18} width={114} height={54} fill="hsl(42 40% 96%)" stroke="hsl(210 45% 25%)" strokeWidth="1.5" />

          {/* Dimension: Altura Ext - left */}
          <DimensionArrow x1={-15} y1={0} x2={-15} y2={90} />
          <line x1={-5} y1={0} x2={-20} y2={0} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={-5} y1={90} x2={-20} y2={90} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Largura Ext - bottom */}
          <DimensionArrow x1={0} y1={110} x2={150} y2={110} />
          <line x1={0} y1={95} x2={0} y2={115} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={150} y1={95} x2={150} y2={115} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Espessura */}
          <DimensionArrow x1={0} y1={-10} x2={18} y2={-10} />
          <text x={9} y={-14} textAnchor="middle" fontSize="8" fill="hsl(24 70% 50%)" fontWeight="bold">e</text>
        </g>
        <text x={15} y={65} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Alt.</text>
        <text x={115} y={142} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Largura Ext.</text>
      </svg>
    </div>
    <div className="grid grid-cols-2 gap-2 w-full max-w-xs">
      <LabeledInput label="Largura Ext." unidade="mm" value={medidas.largura} onChange={(v) => onChange('largura', v)} />
      <LabeledInput label="Altura Ext." unidade="mm" value={medidas.altura} onChange={(v) => onChange('altura', v)} />
      <LabeledInput label="Espessura" unidade="mm" value={medidas.espessura} onChange={(v) => onChange('espessura', v)} />
      <LabeledInput label="Comprim." unidade="mm" value={medidas.comprimento} onChange={(v) => onChange('comprimento', v)} />
      <div className="col-span-2 flex justify-center">
        <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
      </div>
    </div>
  </div>
);

const DiagramaTuboRedondo: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="w-full max-w-[200px]">
      <svg viewBox="0 0 180 180" className="w-full h-auto">
        <g transform="translate(90, 90)">
          {/* Outer circle */}
          <circle cx={0} cy={0} r={65} fill="hsl(42 40% 88%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />
          {/* Inner circle */}
          <circle cx={0} cy={0} r={45} fill="hsl(42 40% 96%)" stroke="hsl(210 45% 25%)" strokeWidth="1.5" />
          {/* Center */}
          <line x1={-4} y1={0} x2={4} y2={0} stroke="hsl(210 45% 25%)" strokeWidth="1" />
          <line x1={0} y1={-4} x2={0} y2={4} stroke="hsl(210 45% 25%)" strokeWidth="1" />

          {/* Dimension: Diâmetro Externo */}
          <DimensionArrow x1={-65} y1={0} x2={65} y2={0} />

          {/* Dimension: Espessura */}
          <DimensionArrow x1={45} y1={-20} x2={65} y2={-20} />
          <text x={55} y={-24} textAnchor="middle" fontSize="8" fill="hsl(24 70% 50%)" fontWeight="bold">e</text>
        </g>
        <text x={90} y={82} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Diâm. Ext.</text>
      </svg>
    </div>
    <div className="grid grid-cols-3 gap-2 w-full max-w-xs">
      <LabeledInput label="Diâm. Ext." unidade="mm" value={medidas.diametroExterno} onChange={(v) => onChange('diametroExterno', v)} />
      <LabeledInput label="Espessura" unidade="mm" value={medidas.espessura} onChange={(v) => onChange('espessura', v)} />
      <LabeledInput label="Comprim." unidade="mm" value={medidas.comprimento} onChange={(v) => onChange('comprimento', v)} />
      <div className="col-span-3 flex justify-center">
        <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
      </div>
    </div>
  </div>
);

const DiagramaCantoneira: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="w-full max-w-[220px]">
      <svg viewBox="0 0 220 200" className="w-full h-auto">
        <g transform="translate(50, 15)">
          {/* L-shape */}
          <path d="M 0 0 L 0 130 L 18 130 L 18 18 L 120 18 L 120 0 Z"
            fill="hsl(42 40% 92%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />

          {/* Dimension: Aba 1 (vertical) - left */}
          <DimensionArrow x1={-20} y1={0} x2={-20} y2={130} />
          <line x1={-5} y1={0} x2={-25} y2={0} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={-5} y1={130} x2={-25} y2={130} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Aba 2 (horizontal) - bottom */}
          <DimensionArrow x1={0} y1={150} x2={120} y2={150} />
          <line x1={0} y1={135} x2={0} y2={155} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={120} y1={135} x2={120} y2={155} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Espessura - top */}
          <DimensionArrow x1={120} y1={-10} x2={120} y2={18} color="hsl(24 70% 50%)" />
          <text x={132} y={7} textAnchor="start" fontSize="8" fill="hsl(24 70% 50%)" fontWeight="bold">e</text>
        </g>
        <text x={20} y={85} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Aba 1</text>
        <text x={110} y={182} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Aba 2</text>
      </svg>
    </div>
    <div className="grid grid-cols-2 gap-2 w-full max-w-xs">
      <LabeledInput label="Aba 1" unidade="mm" value={medidas.aba1} onChange={(v) => onChange('aba1', v)} />
      <LabeledInput label="Aba 2" unidade="mm" value={medidas.aba2} onChange={(v) => onChange('aba2', v)} />
      <LabeledInput label="Espessura" unidade="mm" value={medidas.espessura} onChange={(v) => onChange('espessura', v)} />
      <LabeledInput label="Comprim." unidade="mm" value={medidas.comprimento} onChange={(v) => onChange('comprimento', v)} />
      <div className="col-span-2 flex justify-center">
        <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
      </div>
    </div>
  </div>
);

const DiagramaChapa: React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, quantidade, onChange }) => (
  <div className="flex flex-col items-center gap-3">
    <div className="w-full max-w-[260px]">
      <svg viewBox="0 0 240 160" className="w-full h-auto">
        <g transform="translate(40, 15)">
          {/* 3D plate illusion */}
          <rect x={0} y={20} width={150} height={80} fill="hsl(42 40% 92%)" stroke="hsl(210 45% 25%)" strokeWidth="2.5" />
          {/* Top face */}
          <polygon points="0,20 20,0 170,0 150,20" fill="hsl(42 40% 88%)" stroke="hsl(210 45% 25%)" strokeWidth="1.5" />
          {/* Right face */}
          <polygon points="150,20 170,0 170,80 150,100" fill="hsl(42 40% 85%)" stroke="hsl(210 45% 25%)" strokeWidth="1.5" />

          {/* Dimension: Largura - bottom */}
          <DimensionArrow x1={0} y1={118} x2={150} y2={118} />
          <line x1={0} y1={105} x2={0} y2={123} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={150} y1={105} x2={150} y2={123} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Altura - left */}
          <DimensionArrow x1={-15} y1={20} x2={-15} y2={100} />
          <line x1={-5} y1={20} x2={-20} y2={20} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />
          <line x1={-5} y1={100} x2={-20} y2={100} stroke="hsl(24 70% 50%)" strokeWidth="0.5" />

          {/* Dimension: Espessura - top right */}
          <DimensionArrow x1={158} y1={0} x2={158} y2={20} />
          <text x={168} y={14} textAnchor="start" fontSize="8" fill="hsl(24 70% 50%)" fontWeight="bold">e</text>
        </g>
        <text x={15} y={75} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Alt.</text>
        <text x={115} y={150} textAnchor="middle" fontSize="9" fill="hsl(24 70% 50%)" fontWeight="bold">Largura</text>
      </svg>
    </div>
    <div className="grid grid-cols-3 gap-2 w-full max-w-xs">
      <LabeledInput label="Largura" unidade="mm" value={medidas.largura} onChange={(v) => onChange('largura', v)} />
      <LabeledInput label="Altura" unidade="mm" value={medidas.altura} onChange={(v) => onChange('altura', v)} />
      <LabeledInput label="Espessura" unidade="mm" value={medidas.espessura} onChange={(v) => onChange('espessura', v)} />
      <div className="col-span-3 flex justify-center">
        <LabeledInput label="Qtd" unidade="pç" value={quantidade} onChange={(v) => onChange('_quantidade', v)} placeholder="1" />
      </div>
    </div>
  </div>
);

// Map profile types to their diagram components
const DiagramMap: Record<string, React.FC<{
  medidas: Record<string, number>;
  quantidade: number;
  onChange: (campo: string, valor: string) => void;
}>> = {
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

export const MeasurementForm: React.FC<MeasurementFormProps> = ({
  tipoPerfil,
  onBack,
  onAddToList,
  onViewList,
  projetosCount
}) => {
  const perfil = PERFIS[tipoPerfil];
  const [medidas, setMedidas] = useState<Record<string, number>>({});
  const [materialKey, setMaterialKey] = useState('acoCarbonoComum');
  const [quantidade, setQuantidade] = useState(1);
  const [resultado, setResultado] = useState<Resultado | null>(null);
  const [showMaterial, setShowMaterial] = useState(false);

  const handleChange = (campo: string, valor: string) => {
    if (campo === '_quantidade') {
      const q = parseInt(valor) || 1;
      setQuantidade(q);
      const completo = perfil.campos.every(c => medidas[c] > 0);
      if (completo) {
        setResultado(calcularPesoEValor(tipoPerfil, medidas, materialKey, q));
      }
      return;
    }

    const novas = { ...medidas, [campo]: parseFloat(valor) || 0 };
    setMedidas(novas);

    const completo = perfil.campos.every(c => novas[c] > 0);
    if (completo) {
      setResultado(calcularPesoEValor(tipoPerfil, novas, materialKey, quantidade));
    }
  };

  const handleMaterial = (key: string) => {
    setMaterialKey(key);
    setShowMaterial(false);
    const completo = perfil.campos.every(c => medidas[c] > 0);
    if (completo) {
      setResultado(calcularPesoEValor(tipoPerfil, medidas, key, quantidade));
    }
  };

  const handleAdd = () => {
    if (!resultado) return;
    onAddToList({
      id: Date.now(),
      tipoPerfil,
      nomePerfil: perfil.nome,
      medidas: { ...medidas },
      materialKey,
      material: MATERIAIS[materialKey],
      quantidade,
      resultado: { ...resultado },
    });
  };

  const handleRepetir = () => {
    if (resultado) {
      handleAdd();
    }
    setMedidas({});
    setQuantidade(1);
    setResultado(null);
  };

  // Build description string
  const getDescricao = () => {
    const dims = perfil.campos
      .filter(c => c !== 'comprimento')
      .map(c => medidas[c] || 0)
      .join(' x ');
    return `${perfil.nome} ${dims} x ${medidas.comprimento || 0} mm`;
  };

  return (
    <div className="app-container pb-24">
      {/* Main Content Card */}
      <div className="content-card">
        {/* Header */}
        <div className="bg-cream p-3 text-center" style={{ borderBottom: '3px solid hsl(210 45% 25%)' }}>
          <h2 className="text-navy font-bold text-lg">{perfil.nome}</h2>
        </div>

        {/* Diagram and Inputs Area */}
        <div className="bg-cream p-4">
          {(() => {
            const DiagramComponent = DiagramMap[tipoPerfil];
            if (DiagramComponent) {
              return (
                <DiagramComponent
                  medidas={medidas}
                  quantidade={quantidade}
                  onChange={handleChange}
                />
              );
            }
            return null;
          })()}

          {/* Material Selector */}
          <button
            className="w-full mt-4 bg-cream rounded p-2 flex justify-between items-center text-left hover:bg-cream-dark transition-colors"
            style={{ border: '2px solid hsl(210 45% 25%)' }}
            onClick={() => setShowMaterial(true)}
          >
            <span className="text-navy text-sm font-medium">{MATERIAIS[materialKey].nome}</span>
            <span className="bg-primary text-white px-2 py-1 rounded text-xs font-semibold">
              R$ {MATERIAIS[materialKey].precoKg.toFixed(2)}/kg
            </span>
          </button>

          {/* Description */}
          <div className="mt-4 text-center">
            <p className="text-navy text-sm font-medium">{getDescricao()}</p>
          </div>

          {/* Result */}
          {resultado && (
            <div className="mt-3 p-3 rounded text-center" style={{ backgroundColor: 'hsl(var(--cream-dark))', border: '2px solid hsl(210 45% 25%)' }}>
              <div className="flex justify-between items-center">
                <span className="text-navy text-sm font-medium">Peso Total:</span>
                <span className="text-navy text-xl font-bold">{resultado.pesoTotal.toFixed(2)} Kg</span>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Bottom Navigation */}
      <BottomNav
        onLogoClick={onBack}
        leftAction={{
          label: 'Repetir',
          onClick: handleRepetir,
          variant: 'orange'
        }}
        rightAction={{
          label: 'Lista',
          onClick: () => {
            if (resultado) handleAdd();
            onViewList();
          },
          badge: projetosCount,
          variant: 'teal'
        }}
      />

      {/* Modal Material */}
      {showMaterial && (
        <MaterialModal
          materialKey={materialKey}
          onSelect={handleMaterial}
          onClose={() => setShowMaterial(false)}
        />
      )}
    </div>
  );
};
