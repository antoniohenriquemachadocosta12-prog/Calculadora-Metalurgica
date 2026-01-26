// Base de dados de materiais metálicos
export interface Material {
  nome: string;
  densidade: number; // kg/m³
  precoKg: number;
  categoria: string;
}

export const MATERIAIS: Record<string, Material> = {
  acoCarbonoComum: { nome: 'Aço Carbono 1020', densidade: 7850, precoKg: 8.50, categoria: 'Aço Carbono' },
  acoCarbonoMedio: { nome: 'Aço Carbono 1045', densidade: 7850, precoKg: 9.20, categoria: 'Aço Carbono' },
  acoInox304: { nome: 'Aço Inox 304', densidade: 8000, precoKg: 28.00, categoria: 'Aço Inox' },
  acoInox316: { nome: 'Aço Inox 316', densidade: 8000, precoKg: 35.00, categoria: 'Aço Inox' },
  aluminio6061: { nome: 'Alumínio 6061', densidade: 2700, precoKg: 22.00, categoria: 'Alumínio' },
  aluminio6063: { nome: 'Alumínio 6063', densidade: 2700, precoKg: 20.00, categoria: 'Alumínio' },
  cobre: { nome: 'Cobre', densidade: 8960, precoKg: 45.00, categoria: 'Cobre' },
  latao: { nome: 'Latão', densidade: 8500, precoKg: 38.00, categoria: 'Latão' },
  ferroFundido: { nome: 'Ferro Fundido', densidade: 7200, precoKg: 6.50, categoria: 'Ferro' },
};
