# Analise Completa e Precificacao - Calculadora do Serralheiro (App Android)

## Contexto

Analise de precificacao para app mobile Android "Calculadora do Serralheiro".
O MVP ja existe como web app (React + TypeScript). O produto final sera um app Android
offline que permite ao serralheiro calcular peso/custo de perfis metalurgicos,
gerar PDF de orcamento e compartilhar via WhatsApp/email direto para o cliente ou fornecedor.

**Decisoes do usuario:**
- Plataforma: Apenas Android
- Materiais: Cliente fornece planilha Excel/CSV (100-250 materiais)
- Sem persistencia local - o PDF e a saida final
- Sem backend/banco de dados
- Calculos e perfis fornecidos pelo cliente
- Uma unica saida: PDF compartilhavel

---

## 1. ESCOPO DO PRODUTO FINAL

### O que o app faz:
1. Serralheiro abre o app (funciona 100% offline)
2. Escolhe o tipo de perfil metalurgico (10 tipos com diagramas tecnicos)
3. Informa as medidas e seleciona o material (busca entre 100-250 materiais)
4. App calcula peso e valor automaticamente
5. Adiciona itens a uma lista de orcamento
6. Gera PDF profissional com todos os itens
7. Compartilha o PDF via WhatsApp, Gmail, etc. (share nativo Android)

### O que o app NAO faz:
- Nao salva dados entre sessoes
- Nao precisa de internet
- Nao tem login/cadastro
- Nao tem backend

---

## 2. INVENTARIO DO MVP (ja desenvolvido)

| Metrica | Valor |
|---------|-------|
| Arquivos fonte | 75 |
| Linhas de codigo customizado | ~2.600 |
| Componentes customizados | 10 |
| Telas | 4 (splash, menu, formulario, lista) |
| Perfis metalurgicos | 10 tipos com SVG tecnico |
| Materiais | 9 (sera expandido para 100-250) |
| PDF | Sim, com jsPDF + autoTable |
| Stack | React 18 + TypeScript + Vite + Tailwind |

### Arquivos-chave do MVP:
- `src/data/materiais.ts` - Base de materiais (hoje 9, sera 100-250)
- `src/utils/calculos.ts` - Motor de calculos geometricos
- `src/utils/pdfGenerator.ts` - Geracao de PDF profissional
- `src/components/metalcalc/MeasurementForm.tsx` - Formulario principal (~500 linhas)
- `src/components/metalcalc/ProfileMenu.tsx` - Menu de perfis
- `src/components/metalcalc/ProjectList.tsx` - Lista de orcamento
- `src/components/metalcalc/MetalCalcPro.tsx` - Componente principal

---

## 3. O QUE PRECISA SER FEITO (MVP → Produto Final)

### 3.1 Empacotar como App Android
- Usar Capacitor (ponte entre web app e Android nativo)
- Configurar projeto Android Studio
- Splash screen nativa
- Icone do app
- **Horas: 12-18h**

### 3.2 Expandir base de materiais (9 → 100-250)
- Importar planilha CSV/Excel do cliente para formato TypeScript
- Implementar busca por texto (campo de pesquisa)
- Implementar filtro por categoria
- Reorganizar UI de selecao de material (lista scrollavel com secoes)
- **Horas: 14-22h**

### 3.3 Compartilhamento nativo Android
- Integrar com Android Share Intent (API nativa via Capacitor)
- Apos gerar PDF, abrir sheet de compartilhamento do Android
- WhatsApp, Gmail, Telegram, etc. aparecem automaticamente
- **Horas: 6-10h**

### 3.4 Ajustes para uso offline
- Service Worker para cache de assets (Capacitor ja resolve isso)
- Garantir que nenhuma dependencia exige internet
- Testar em modo aviao
- **Horas: 4-6h**

### 3.5 Polish e QA Android
- Testar em diferentes tamanhos de tela Android
- Ajustar safe areas, teclado virtual, scroll
- Performance em dispositivos mais antigos
- Correcoes de bugs encontrados
- **Horas: 10-16h**

### 3.6 Publicacao na Play Store
- Gerar APK/AAB assinado
- Criar conta Google Play Developer (R$ 130 - pago uma vez)
- Screenshots, descricao, icone para a loja
- Submeter e acompanhar aprovacao
- **Horas: 6-10h**

---

## 4. ESTIMATIVA TOTAL DE HORAS

| Modulo | Horas |
|--------|-------|
| **MVP (ja feito)** | |
| Setup + config | 4-6h |
| Design system | 8-12h |
| Splash + navegacao | 3-4h |
| Menu de perfis + SVGs | 6-8h |
| Diagramas tecnicos SVG (10 tipos) | 20-30h |
| Formulario dinamico | 12-16h |
| Motor de calculos | 8-12h |
| Base de materiais (9) | 4-6h |
| Lista de projetos (CRUD) | 6-8h |
| Geracao de PDF | 12-16h |
| Modal empresa/cliente | 3-4h |
| Responsividade | 8-12h |
| Testes e correcoes | 4-6h |
| **Subtotal MVP** | **98-140h (~120h media)** |
| | |
| **DO MVP AO PRODUTO FINAL** | |
| App Android (Capacitor) | 12-18h |
| Base de materiais expandida (100-250) | 14-22h |
| Compartilhamento nativo Android | 6-10h |
| Offline garantido | 4-6h |
| Polish + QA Android | 10-16h |
| Publicacao Play Store | 6-10h |
| **Subtotal MVP → Final** | **52-82h (~65h media)** |
| | |
| **TOTAL GERAL** | **150-222h (~185h media)** |

---

## 5. PRECIFICACAO DO PROJETO COMPLETO

### Por hora (referencia):
| Nivel | Valor/Hora | Total (185h media) |
|-------|-----------|-------------------|
| Junior | R$ 50-80/h | R$ 9.250 - R$ 14.800 |
| Pleno | R$ 80-150/h | R$ 14.800 - R$ 27.750 |
| Senior | R$ 150-250/h | R$ 27.750 - R$ 46.250 |

### Preco fechado RECOMENDADO:

| Faixa | Valor | Para quem |
|-------|-------|-----------|
| **Minimo** | R$ 12.000 | Se voce e junior e quer ganhar experiencia |
| **Justo** | R$ 18.000 - R$ 25.000 | Valor de mercado para este escopo |
| **Premium** | R$ 30.000 - R$ 35.000 | Se voce e senior e entrega polido |

### Recomendacao: **R$ 20.000 a R$ 28.000**

---

## 6. CUSTOS FIXOS (alem do desenvolvimento)

| Item | Custo | Quem paga |
|------|-------|-----------|
| Conta Google Play Developer | R$ 130 (unica vez) | Cliente |
| Apple Developer (se futuro iOS) | ~R$ 500/ano | Cliente |
| Dominio (se quiser site) | ~R$ 40/ano | Cliente |

**Custo de infraestrutura mensal: R$ 0** (app offline, sem servidor)

---

## 7. MANUTENCAO POS-LANCAMENTO

| Servico | Valor mensal |
|---------|-------------|
| Atualizacao de precos de materiais | R$ 500 - R$ 1.000 |
| Adicionar novos perfis/materiais | R$ 500 - R$ 1.000 |
| Correcoes de bugs + atualizacao Android | R$ 800 - R$ 1.500 |
| **Pacote completo manutencao** | **R$ 1.000 - R$ 2.000/mes** |

---

## 8. SUGESTAO DE PACOTES PARA O CLIENTE

### Pacote Basico - R$ 20.000
- App Android completo offline
- 10 perfis metalurgicos com diagramas
- Base de ate 150 materiais (fornecidos pelo cliente)
- Geracao de PDF
- Compartilhamento via WhatsApp/email
- Publicacao na Play Store
- 30 dias de suporte pos-lancamento

### Pacote Profissional - R$ 28.000
- Tudo do Basico +
- Ate 250 materiais
- Busca inteligente com filtros
- Layout premium do PDF com logo do cliente
- 60 dias de suporte pos-lancamento
- 1 rodada de ajustes apos lancamento

### Manutencao (opcional) - R$ 1.500/mes
- Atualizacao de precos
- Novos materiais/perfis
- Atualizacoes Android
- Suporte por WhatsApp

---

## 9. ARGUMENTOS DE VENDA (valor para o serralheiro)

- **Velocidade**: Orcamento em minutos, nao em horas
- **Profissionalismo**: PDF bonito impressiona o cliente
- **Praticidade**: Funciona na obra, sem internet
- **Precisao**: Calculos exatos, sem erro de conta
- **Agilidade com fornecedor**: Envia pedido na hora

---

## 10. FATORES QUE SIMPLIFICAM O PROJETO

- Cliente fornece planilha de materiais (nao precisa pesquisar)
- Cliente fornece formulas e perfis (conhecimento de dominio vem dele)
- Sem backend = sem custo de servidor
- Sem login = sem complexidade de auth
- Apenas Android = uma plataforma so
- PDF como saida final = sem persistencia complexa
- MVP ja existe e funciona

---

## 11. RISCOS E RESSALVAS

1. **Mudanca de escopo** - Se o cliente quiser iOS depois, e praticamente o mesmo custo novamente para adaptar e publicar
2. **Atualizacao de precos** - Se precos de materiais mudam frequentemente, o app precisa de update na Play Store cada vez (ou contratar manutencao)
3. **Play Store** - Google pode levar 3-7 dias para aprovar o app, e pode rejeitar na primeira tentativa
4. **Dispositivos antigos** - Android fragmentado, pode ter bugs em devices muito antigos

---

## 12. CENARIO STARTUP - ANALISE ESTRATEGICA

### Contexto da negociacao
O cliente quer um "valor amigavel" pela calculadora em troca de oportunidade de participar
de uma startup futura: um centro de vendas online de materiais de serralheria (e depois marcenaria).

- Se valor amigavel: paga menos + porta aberta para a startup
- Se valor cheio: paga o combinado, mas sem oportunidade na startup

### A VISAO DO CLIENTE (o que ele quer construir)

```
FASE 1 (agora): Calculadora do Serralheiro (app offline)
    ↓ validacao de mercado
FASE 2 (futuro): Centro de vendas online de materiais de serralheria
    ↓ expansao
FASE 3 (futuro): Expandir para marcenaria
```

A calculadora NAO e o negocio. E a **porta de entrada** para capturar usuarios (serralheiros)
que depois serao direcionados para a plataforma de vendas. Modelo classico de startup:
ferramenta gratuita/barata → captura de base → monetizacao via marketplace.

### 3 CENARIOS DE NEGOCIACAO

#### CENARIO A: "Valor amigavel" puro (MAIOR RISCO)
- Cobra: R$ 8.000 - R$ 12.000
- Desconto: 40-60% sobre o valor justo
- Recebe: Dinheiro + promessa verbal de participacao na startup
- **RISCO ALTO**: Promessa verbal nao vale nada juridicamente.
  O cliente pode nao cumprir, a startup pode nao acontecer,
  ou podem trazer outro dev mais barato depois.

#### CENARIO B: Valor reduzido + contrato de participacao (EQUILIBRADO)
- Cobra: R$ 10.000 - R$ 14.000
- Desconto: 30-50%
- Recebe: Dinheiro + CONTRATO FORMAL com:
  - % de equity (participacao societaria) na startup futura
  - Ou contrato de CTO/dev principal com salario + equity
  - Direito de primeira recusa para projetos futuros
  - Clausula de vesting (ex: equity liberado ao longo de 2-4 anos)
- **RISCO MODERADO**: Tem protecao juridica, mas startup ainda pode falhar.

#### CENARIO C: Valor cheio sem startup (MENOR RISCO)
- Cobra: R$ 20.000 - R$ 28.000
- Desconto: 0%
- Recebe: Dinheiro garantido, sem risco
- Perde: Oportunidade na startup (se for real)
- **RISCO BAIXO**: Dinheiro no bolso, sem depender de promessas futuras.

### ANALISE CRITICA - PERGUNTAS QUE VOCE DEVE SE FAZER

1. **A startup tem fundamento?**
   - O cliente tem experiencia no ramo de serralheria/vendas?
   - Ele tem capital ou acesso a investidores de verdade?
   - Existe demanda real para um marketplace de materiais metalurgicos?
   - Quem sao os concorrentes? (Mercado Livre, marketplaces B2B)

2. **A "porta aberta" e concreta?**
   - "Participar da startup" significa o que exatamente? Socio? Funcionario? Freelancer?
   - Qual % de participacao?
   - Tem contrato? Sem contrato = promessa vazia.

3. **Qual e o seu custo real?**
   - ~185h de trabalho. Se voce cobra R$ 10.000, esta recebendo ~R$ 54/hora.
   - Voce consegue pagar suas contas com isso?
   - O desconto que voce da e, na pratica, um INVESTIMENTO na startup.
     Se a startup nao acontecer, voce perdeu esse dinheiro.

4. **Voce seria substituivel?**
   - Se a startup crescer, o cliente pode contratar outro dev?
   - Voce tem algo que garanta sua posicao alem da "boa vontade"?

### RECOMENDACAO ESTRATEGICA

**Se voce ACREDITA na startup e no cliente:**

Vai com o CENARIO B, mas EXIJA:

1. **Contrato formal** com advogado (pode ser simples, mas escrito e assinado)
2. **Equity definido** - ex: 10-20% da startup, com vesting de 2 anos
3. **Valor minimo da calculadora**: R$ 12.000 (nao menos)
4. **Clausula de CTO/dev principal** para a fase 2 (marketplace)
5. **O desconto que voce da (R$ 8.000-16.000) e o valor do seu "investimento"**
   - Deixe isso claro: "Estou investindo R$ X na startup em forma de trabalho"

**Se voce TEM DUVIDAS sobre o cliente ou a startup:**

Vai com o CENARIO C (valor cheio). Motivo:
- Dinheiro no bolso > promessa futura
- Se a startup for boa de verdade, ele vai te procurar de novo
- "Porta aberta" sem contrato nao vale desconto

### BANDEIRAS VERMELHAS (red flags)

Cuidado se o cliente:
- Recusa assinar qualquer tipo de contrato/acordo
- Diz que "contrato e coisa de quem nao confia"
- Nao consegue explicar o modelo de negocio da startup
- Nao tem capital nenhum (depende 100% de investidor futuro)
- Ja trocou de desenvolvedor antes por questao de preco
- Pressiona muito para fechar rapido

### TABELA RESUMO DOS CENARIOS

| | Cenario A | Cenario B | Cenario C |
|---|-----------|-----------|-----------|
| Valor | R$ 8-12k | R$ 10-14k | R$ 20-28k |
| Contrato startup | Nao | Sim, formal | N/A |
| Equity | Promessa verbal | 10-20% escrito | 0% |
| Risco financeiro | Alto | Moderado | Baixo |
| Potencial futuro | Incerto | Protegido | Nenhum |
| **Recomendacao** | **Evitar** | **Melhor opcao** | **Seguro** |
