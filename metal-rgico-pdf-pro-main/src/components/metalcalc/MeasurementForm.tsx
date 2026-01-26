import React, { useState } from 'react';
import { PERFIS } from '@/data/perfis';
import { MATERIAIS } from '@/data/materiais';
import { DIAGRAMAS } from './ProfileDiagrams';
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

export const MeasurementForm: React.FC<MeasurementFormProps> = ({ 
  tipoPerfil, 
  onBack, 
  onAddToList,
  onViewList,
  projetosCount 
}) => {
  const perfil = PERFIS[tipoPerfil];
  const DiagramaComponent = DIAGRAMAS[tipoPerfil];
  const [medidas, setMedidas] = useState<Record<string, number>>({});
  const [materialKey, setMaterialKey] = useState('acoCarbonoComum');
  const [quantidade, setQuantidade] = useState(1);
  const [resultado, setResultado] = useState<Resultado | null>(null);
  const [showMaterial, setShowMaterial] = useState(false);

  const handleChange = (campo: string, valor: string) => {
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

  const handleQtd = (v: string) => {
    const q = parseInt(v) || 1;
    setQuantidade(q);
    const completo = perfil.campos.every(c => medidas[c] > 0);
    if (completo) {
      setResultado(calcularPesoEValor(tipoPerfil, medidas, materialKey, q));
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
    // Reset form for same profile with different specs
    setMedidas({});
    setQuantidade(1);
    setResultado(null);
  };

  return (
    <div className="min-h-screen bg-primary pb-24">
      {/* Main Content Card */}
      <div className="mx-3 mt-3 bg-card rounded-lg border-2 border-border overflow-hidden">
        {/* Header */}
        <div className="bg-cream p-3 border-b-2 border-border">
          <h2 className="text-foreground font-bold text-lg text-center">{perfil.nome}</h2>
        </div>

        {/* Technical Drawing */}
        <div className="bg-cream p-4 border-b-2 border-border flex justify-center items-center min-h-[200px]">
          {DiagramaComponent && <DiagramaComponent medidas={medidas} />}
        </div>

        {/* Measurement Inputs */}
        <div className="p-3 max-h-[calc(100vh-420px)] overflow-y-auto">
          <div className="grid grid-cols-2 gap-2">
            {perfil.campos.map((campo) => (
              <div key={campo} className="flex flex-col gap-1">
                <label className="text-muted-foreground text-xs font-medium">
                  {perfil.labels[campo]} ({perfil.unidades[campo]})
                </label>
                <input
                  type="number"
                  inputMode="decimal"
                  className="bg-cream border-2 border-border rounded px-3 py-2 text-foreground text-sm outline-none focus:border-primary transition-colors"
                  placeholder="0"
                  value={medidas[campo] || ''}
                  onChange={(e) => handleChange(campo, e.target.value)}
                />
              </div>
            ))}
            <div className="flex flex-col gap-1">
              <label className="text-muted-foreground text-xs font-medium">
                Quantidade (pç)
              </label>
              <input
                type="number"
                inputMode="numeric"
                className="bg-cream border-2 border-border rounded px-3 py-2 text-foreground text-sm outline-none focus:border-primary transition-colors"
                min="1"
                value={quantidade}
                onChange={(e) => handleQtd(e.target.value)}
              />
            </div>
          </div>

          {/* Material Selector */}
          <button 
            className="w-full bg-cream border-2 border-border rounded mt-3 p-2 cursor-pointer flex justify-between items-center text-left hover:bg-cream-dark transition-colors"
            onClick={() => setShowMaterial(true)}
          >
            <span className="text-foreground text-sm font-medium">{MATERIAIS[materialKey].nome}</span>
            <span className="bg-primary text-primary-foreground px-2 py-1 rounded text-xs font-semibold">
              R$ {MATERIAIS[materialKey].precoKg.toFixed(2)}/kg
            </span>
          </button>

          {/* Result */}
          {resultado && (
            <div className="mt-3 bg-cream-dark border-2 border-border rounded p-3">
              <div className="text-xs text-muted-foreground mb-1">Descrição Técnica:</div>
              <div className="text-sm text-foreground font-medium mb-2">
                {perfil.nome} {perfil.campos.filter(c => c !== 'comprimento').map(c => medidas[c]).join(' x ')} x {medidas.comprimento} mm
              </div>
              <div className="flex justify-between items-center">
                <span className="text-sm text-muted-foreground">Peso Total:</span>
                <span className="text-lg font-bold text-foreground">{resultado.pesoTotal.toFixed(2)} Kg</span>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Bottom Navigation */}
      <BottomNav
        leftAction={{
          label: 'Repetir',
          onClick: resultado ? handleAdd : handleRepetir
        }}
        rightAction={{
          label: 'Lista',
          onClick: resultado ? () => { handleAdd(); onViewList(); } : onViewList,
          badge: projetosCount
        }}
      />

      {/* Back to Home floating button */}
      <button
        onClick={onBack}
        className="fixed top-4 left-4 w-10 h-10 rounded-full bg-foreground/20 flex items-center justify-center text-primary-foreground text-xl shadow-button hover:bg-foreground/30 transition-colors"
      >
        ←
      </button>

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
