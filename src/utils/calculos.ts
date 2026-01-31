import { MATERIAIS } from "@/data/materiais";
import { PERFIS } from "@/data/perfis";
import { Resultado } from "@/types/projeto";

export const calcularPesoEValor = (
  tipoPerfil: string,
  medidas: Record<string, number>,
  materialKey: string,
  quantidade: number = 1
): Resultado | null => {
  const perfil = PERFIS[tipoPerfil];
  const material = MATERIAIS[materialKey];
  if (!perfil || !material) return null;

  let peso: number;
  if (perfil.isVolume) {
    peso = perfil.calcularArea(medidas) * material.densidade;
  } else {
    const areaSecao = perfil.calcularArea(medidas);
    const comprimento = medidas.comprimento / 1000;
    peso = areaSecao * comprimento * material.densidade;
  }

  return {
    pesoUnitario: peso,
    pesoTotal: peso * quantidade,
    valorUnitario: peso * material.precoKg,
    valorTotal: peso * quantidade * material.precoKg,
    material: material.nome,
    precoKg: material.precoKg,
  };
};

export const formatarMedidas = (tipoPerfil: string, medidas: Record<string, number>): string => {
  const perfil = PERFIS[tipoPerfil];
  if (!perfil) return '';
  
  return perfil.campos
    .filter(campo => campo !== 'comprimento')
    .map(campo => `${medidas[campo] || 0}`)
    .join('×') + 'mm';
};

export const formatarDescricaoTecnica = (tipoPerfil: string, medidas: Record<string, number>): string => {
  const perfil = PERFIS[tipoPerfil];
  if (!perfil) return '';
  
  const dimensoes = perfil.campos
    .filter(campo => campo !== 'comprimento')
    .map(campo => `${medidas[campo] || 0}`)
    .join('x');
  
  return `${perfil.nome} ${dimensoes}mm`;
};
