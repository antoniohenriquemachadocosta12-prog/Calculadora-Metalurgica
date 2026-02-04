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

// Interactive diagram with positioned inputs for Perfil C
const DiagramaPerfilCInterativo: React.FC<{
  medidas: Record<string, number>;
  onChange: (campo: string, valor: string) => void;
}> = ({ medidas, onChange }) => {
  return (
    <div className="relative w-full max-w-[320px] mx-auto">
      {/* SVG Diagram */}
      <svg viewBox="0 0 300 280" className="w-full h-auto">
        {/* C Profile shape */}
        <g transform="translate(100, 60)">
          <path
            d="M 0 0 L 100 0 L 100 20 L 20 20 L 20 130 L 100 130 L 100 150 L 0 150 Z"
            fill="none"
            stroke="hsl(var(--navy))"
            strokeWidth="2"
          />
          {/* Diagonal line for perspective */}
          <line x1="100" y1="0" x2="115" y2="-15" stroke="hsl(var(--navy))" strokeWidth="1.5" />
          <line x1="100" y1="20" x2="115" y2="5" stroke="hsl(var(--navy))" strokeWidth="1.5" />
          <line x1="115" y1="-15" x2="115" y2="5" stroke="hsl(var(--navy))" strokeWidth="1.5" />

          {/* Dimension lines */}
          <line x1="-15" y1="0" x2="-15" y2="150" stroke="hsl(var(--navy))" strokeWidth="1" />
          <line x1="-20" y1="0" x2="-10" y2="0" stroke="hsl(var(--navy))" strokeWidth="1" />
          <line x1="-20" y1="150" x2="-10" y2="150" stroke="hsl(var(--navy))" strokeWidth="1" />

          <line x1="0" y1="165" x2="100" y2="165" stroke="hsl(var(--navy))" strokeWidth="1" />
          <line x1="0" y1="160" x2="0" y2="170" stroke="hsl(var(--navy))" strokeWidth="1" />
          <line x1="100" y1="160" x2="100" y2="170" stroke="hsl(var(--navy))" strokeWidth="1" />
        </g>
      </svg>

      {/* Input for Altura (left side) */}
      <div className="absolute left-2 top-1/2 -translate-y-1/2">
        <input
          type="number"
          inputMode="decimal"
          className="input-field w-16 text-center text-sm font-medium"
          placeholder="0"
          value={medidas.altura || ''}
          onChange={(e) => onChange('altura', e.target.value)}
        />
      </div>

      {/* Input for Largura (bottom) */}
      <div className="absolute bottom-4 left-1/2 -translate-x-1/2">
        <input
          type="number"
          inputMode="decimal"
          className="input-field w-16 text-center text-sm font-medium"
          placeholder="0"
          value={medidas.largura || ''}
          onChange={(e) => onChange('largura', e.target.value)}
        />
      </div>

      {/* Input for Quantidade (X) */}
      <div className="absolute top-16 right-16 flex items-center gap-1">
        <span className="text-navy font-bold">X</span>
        <input
          type="number"
          inputMode="numeric"
          className="input-field w-14 text-center text-sm font-medium"
          placeholder="1"
          min="1"
          value={medidas._quantidade || ''}
          onChange={(e) => onChange('_quantidade', e.target.value)}
        />
      </div>

      {/* Input for Comprimento */}
      <div className="absolute top-1/3 right-4">
        <input
          type="number"
          inputMode="decimal"
          className="input-field w-20 text-center text-sm font-medium"
          placeholder="0"
          value={medidas.comprimento || ''}
          onChange={(e) => onChange('comprimento', e.target.value)}
        />
      </div>

      {/* Input for Espessura */}
      <div className="absolute bottom-24 right-4">
        <input
          type="number"
          inputMode="decimal"
          className="input-field w-14 text-center text-sm font-medium"
          placeholder="0"
          value={medidas.espessura || ''}
          onChange={(e) => onChange('espessura', e.target.value)}
        />
      </div>

      {/* Input for Aba */}
      <div className="absolute bottom-16 right-4">
        <input
          type="number"
          inputMode="decimal"
          className="input-field w-14 text-center text-sm font-medium"
          placeholder="0"
          value={medidas.aba || ''}
          onChange={(e) => onChange('aba', e.target.value)}
        />
      </div>
    </div>
  );
};

// Generic diagram with inputs below
const DiagramaGenerico: React.FC<{
  tipoPerfil: string;
  medidas: Record<string, number>;
  onChange: (campo: string, valor: string) => void;
  perfil: typeof PERFIS[string];
}> = ({ tipoPerfil, medidas, onChange, perfil }) => {
  // Profile icons as SVG
  const renderProfileSVG = () => {
    switch (tipoPerfil) {
      case 'perfilC':
        return (
          <path d="M 50 20 L 150 20 L 150 40 L 70 40 L 70 160 L 150 160 L 150 180 L 50 180 Z"
                fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />
        );
      case 'perfilU':
        return (
          <path d="M 50 20 L 50 180 L 150 180 L 150 20 M 70 40 L 70 160 L 130 160 L 130 40"
                fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />
        );
      case 'barraQuadrada':
        return <rect x="60" y="60" width="80" height="80" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />;
      case 'barraRetangular':
        return <rect x="40" y="70" width="120" height="60" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />;
      case 'barraRedonda':
        return <circle cx="100" cy="100" r="50" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />;
      case 'tuboQuadrado':
        return (
          <>
            <rect x="50" y="50" width="100" height="100" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />
            <rect x="70" y="70" width="60" height="60" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />
          </>
        );
      case 'tuboRetangular':
        return (
          <>
            <rect x="30" y="60" width="140" height="80" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />
            <rect x="50" y="80" width="100" height="40" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />
          </>
        );
      case 'tuboRedondo':
        return (
          <>
            <circle cx="100" cy="100" r="55" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />
            <circle cx="100" cy="100" r="35" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />
          </>
        );
      case 'cantoneira':
        return <path d="M 40 40 L 40 160 L 60 160 L 60 60 L 160 60 L 160 40 Z" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />;
      case 'chapa':
        return <rect x="30" y="80" width="140" height="40" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />;
      default:
        return <rect x="50" y="50" width="100" height="100" fill="none" stroke="hsl(var(--navy))" strokeWidth="2" />;
    }
  };

  return (
    <div className="flex flex-col items-center gap-4">
      {/* SVG Diagram */}
      <svg viewBox="0 0 200 200" className="w-40 h-40">
        {renderProfileSVG()}
      </svg>

      {/* Input Grid */}
      <div className="grid grid-cols-2 gap-3 w-full max-w-xs">
        {perfil.campos.map((campo) => (
          <div key={campo} className="flex flex-col gap-1">
            <label className="text-navy text-xs font-medium">
              {perfil.labels[campo]} ({perfil.unidades[campo]})
            </label>
            <input
              type="number"
              inputMode="decimal"
              className="input-field text-sm"
              placeholder="0"
              value={medidas[campo] || ''}
              onChange={(e) => onChange(campo, e.target.value)}
            />
          </div>
        ))}
      </div>
    </div>
  );
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
          {tipoPerfil === 'perfilC' ? (
            <DiagramaPerfilCInterativo
              medidas={{ ...medidas, _quantidade: quantidade }}
              onChange={handleChange}
            />
          ) : (
            <DiagramaGenerico
              tipoPerfil={tipoPerfil}
              medidas={medidas}
              onChange={handleChange}
              perfil={perfil}
            />
          )}

          {/* Quantity input for non-perfilC */}
          {tipoPerfil !== 'perfilC' && (
            <div className="mt-4 flex justify-center">
              <div className="flex items-center gap-2">
                <span className="text-navy font-bold">Qtd:</span>
                <input
                  type="number"
                  inputMode="numeric"
                  className="input-field w-16 text-center text-sm font-medium"
                  placeholder="1"
                  min="1"
                  value={quantidade}
                  onChange={(e) => handleChange('_quantidade', e.target.value)}
                />
                <span className="text-navy text-sm">pç</span>
              </div>
            </div>
          )}

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
