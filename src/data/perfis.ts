// Configuração dos perfis metálicos
export interface Perfil {
  nome: string;
  icone: string;
  campos: string[];
  labels: Record<string, string>;
  unidades: Record<string, string>;
  calcularArea: (medidas: Record<string, number>) => number;
  isVolume?: boolean;
}

export const PERFIS: Record<string, Perfil> = {
  perfilC: {
    nome: 'Perfil "C"',
    icone: '⊏',
    campos: ['altura', 'largura', 'aba', 'espessura', 'comprimento'],
    labels: { altura: 'Altura', largura: 'Largura', aba: 'Aba', espessura: 'Espessura', comprimento: 'Comprimento' },
    unidades: { altura: 'mm', largura: 'mm', aba: 'mm', espessura: 'mm', comprimento: 'mm' },
    calcularArea: (m) => ((2 * m.aba * m.espessura) + (m.largura * m.espessura) + (2 * (m.altura - 2 * m.espessura) * m.espessura)) / 1000000
  },
  perfilU: {
    nome: 'Perfil "U"',
    icone: '⊔',
    campos: ['altura', 'largura', 'espessura', 'comprimento'],
    labels: { altura: 'Altura', largura: 'Largura', espessura: 'Espessura', comprimento: 'Comprimento' },
    unidades: { altura: 'mm', largura: 'mm', espessura: 'mm', comprimento: 'mm' },
    calcularArea: (m) => ((m.largura * m.espessura) + (2 * (m.altura - m.espessura) * m.espessura)) / 1000000
  },
  barraQuadrada: {
    nome: 'Barra Quadrada',
    icone: '◻',
    campos: ['lado', 'comprimento'],
    labels: { lado: 'Lado', comprimento: 'Comprimento' },
    unidades: { lado: 'mm', comprimento: 'mm' },
    calcularArea: (m) => (m.lado * m.lado) / 1000000
  },
  barraRetangular: {
    nome: 'Barra Retangular',
    icone: '▭',
    campos: ['largura', 'altura', 'comprimento'],
    labels: { largura: 'Largura', altura: 'Altura', comprimento: 'Comprimento' },
    unidades: { largura: 'mm', altura: 'mm', comprimento: 'mm' },
    calcularArea: (m) => (m.largura * m.altura) / 1000000
  },
  barraRedonda: {
    nome: 'Barra Redonda',
    icone: '○',
    campos: ['diametro', 'comprimento'],
    labels: { diametro: 'Diâmetro', comprimento: 'Comprimento' },
    unidades: { diametro: 'mm', comprimento: 'mm' },
    calcularArea: (m) => (Math.PI * Math.pow(m.diametro / 2, 2)) / 1000000
  },
  tuboQuadrado: {
    nome: 'Tubo Quadrado',
    icone: '⬜',
    campos: ['lado', 'espessura', 'comprimento'],
    labels: { lado: 'Lado Externo', espessura: 'Espessura', comprimento: 'Comprimento' },
    unidades: { lado: 'mm', espessura: 'mm', comprimento: 'mm' },
    calcularArea: (m) => ((m.lado * m.lado) - Math.pow(m.lado - 2 * m.espessura, 2)) / 1000000
  },
  tuboRetangular: {
    nome: 'Tubo Retangular',
    icone: '▯',
    campos: ['largura', 'altura', 'espessura', 'comprimento'],
    labels: { largura: 'Largura Ext.', altura: 'Altura Ext.', espessura: 'Espessura', comprimento: 'Comprimento' },
    unidades: { largura: 'mm', altura: 'mm', espessura: 'mm', comprimento: 'mm' },
    calcularArea: (m) => ((m.largura * m.altura) - ((m.largura - 2*m.espessura) * (m.altura - 2*m.espessura))) / 1000000
  },
  tuboRedondo: {
    nome: 'Tubo Redondo',
    icone: '◯',
    campos: ['diametroExterno', 'espessura', 'comprimento'],
    labels: { diametroExterno: 'Diâm. Externo', espessura: 'Espessura', comprimento: 'Comprimento' },
    unidades: { diametroExterno: 'mm', espessura: 'mm', comprimento: 'mm' },
    calcularArea: (m) => (Math.PI * (Math.pow(m.diametroExterno/2, 2) - Math.pow(m.diametroExterno/2 - m.espessura, 2))) / 1000000
  },
  cantoneira: {
    nome: 'Cantoneira',
    icone: '∟',
    campos: ['aba1', 'aba2', 'espessura', 'comprimento'],
    labels: { aba1: 'Aba 1', aba2: 'Aba 2', espessura: 'Espessura', comprimento: 'Comprimento' },
    unidades: { aba1: 'mm', aba2: 'mm', espessura: 'mm', comprimento: 'mm' },
    calcularArea: (m) => ((m.aba1 + m.aba2 - m.espessura) * m.espessura) / 1000000
  },
  chapa: {
    nome: 'Chapa',
    icone: '▬',
    campos: ['largura', 'altura', 'espessura'],
    labels: { largura: 'Largura', altura: 'Altura', espessura: 'Espessura' },
    unidades: { largura: 'mm', altura: 'mm', espessura: 'mm' },
    calcularArea: (m) => (m.largura * m.altura * m.espessura) / 1000000000,
    isVolume: true
  },
};
