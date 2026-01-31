import { Material } from "@/data/materiais";

export interface Resultado {
  pesoUnitario: number;
  pesoTotal: number;
  valorUnitario: number;
  valorTotal: number;
  material: string;
  precoKg: number;
}

export interface Projeto {
  id: number;
  tipoPerfil: string;
  nomePerfil: string;
  medidas: Record<string, number>;
  materialKey: string;
  material: Material;
  quantidade: number;
  resultado: Resultado;
}

export interface EmpresaInfo {
  nome: string;
  cnpj: string;
}

export interface ClienteInfo {
  nome: string;
  telefone: string;
  obs: string;
}
