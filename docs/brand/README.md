# AI Tool — Brand Guide

Identidade visual do AI Tool. Fonte de verdade para qualquer uso da marca:
produto, instalador, site, vídeo, documentação.

Referência visual (símbolo às várias escalas, friso do ERP, paleta, wordmark,
regras e exemplos de má utilização): abrir [`index.html`](index.html) neste
diretório. A página carrega os SVG reais do repositório, por isso serve também
de verificação — se algo aparecer partido, o asset está partido.

## A marca

O símbolo é um monograma **A·i**: um "A" desenhado como cursor a apontar para
cima, com um ponto dourado que é ao mesmo tempo o "i" e o utilizador no centro
da conversa. Lê-se como assistente que eleva — não como mais um chatbot.

O universo de apoio é o **núcleo orbital**: um centro dourado com arcos e
satélites, que representa o agente a orquestrar as ferramentas à volta do ERP.
Usa-se em ilustração (site, vídeo, splash, fundos), nunca como substituto do
símbolo.

## Paleta

| Nome | Hex | Uso |
|---|---|---|
| Navy | `#1E3A5F` | Cor principal da marca; tile flat; texto sobre claro |
| Navy profundo | `#16304F` | Fim do gradiente do tile; fundos escuros |
| Navy claro | `#24466E` | Início do gradiente do tile |
| Dourado | `#D9A441` | Acento único: o ponto, o "AI" no wordmark, réguas |
| Dourado profundo | `#C28F2E` | Hover/estados do dourado |
| Tinta | `#1A2433` | Texto sobre fundos claros |
| Papel | `#F4F6F9` | Fundos claros |

O dourado marca sempre o mesmo papel: o ponto onde o assistente age. Nunca se
usa como cor de preenchimento de grandes áreas.

## Tipografia

- **Segoe UI Bold** para o wordmark (`AI` dourado + `TOOL`), letter-spacing
  largo (3–7 px conforme a escala).
- **Segoe UI** regular para texto de apoio.
- Fallback: Arial, sans-serif. Não usar serifadas nem monospace na marca.

## Ficheiros e quando usar

| Ficheiro | Uso |
|---|---|
| `svg/aitool-mark.svg` | Master com gradiente — marketing, site, tamanhos ≥48 px |
| `svg/aitool-mark-flat.svg` | Flat `#1E3A5F` — produto/DevExpress (sem gradientes) |
| `svg/aitool-mark-small.svg` | Variante ótica 16–32 px (traço mais grosso) |
| `svg/aitool-glyph-navy.svg` | Glifo sem tile sobre fundos claros |
| `svg/aitool-glyph-white.svg` | Glifo sem tile sobre fundos escuros |
| `svg/aitool-mono-black.svg` / `-white.svg` | Monocromático (impressão, gravação) |
| `svg/aitool-orbital.svg` / `-white.svg` | Ilustração de apoio |
| `svg/aitool-wordmark.svg` / `-dark.svg` | Lockup símbolo + wordmark |
| `png/mark-*.png` | Exports 16–512 px, fundo transparente |
| `png/og-1200x630.png` | OpenGraph / social em inglês — social preview do GitHub |
| `png/og-1200x630.pt.png` | OpenGraph / social em português — bolalabs.pt |
| `png/orbital-512.png` | Variante orbital em 512 px |
| `index.html` | Especificação visual da marca (abrir no browser) |

No produto, os assets vivem em `UI/Resources` (icon_simple.*, favicon.*,
splash.*) e `Installer/branding` — são derivados destes masters e substituem-se
regenerando a partir daqui, nunca editando à mão.

## Regras

- Zona de proteção: metade da largura do tile em todo o redor.
- Tamanho mínimo: 16 px (usar a variante small abaixo de 48 px em contextos
  rasterizados).
- Não rodar, não distorcer, não recolorir, não adicionar sombras ou efeitos.
- Não usar o glifo branco sobre fundos claros nem o navy sobre escuros.
- O ponto é sempre dourado `#D9A441` — exceto nas variantes monocromáticas.
- O orbital nunca aparece a menos de 64 px nem como ícone de aplicação.
- Sobre fotografias ou fundos imprevisíveis, usar sempre a versão com tile.

## Restrições técnicas (produto)

Os SVG consumidos pelo DevExpress 21.2.3 (`SvgImage`) têm de ser planos:
formas básicas e paths com fills sólidos, sem gradientes, filtros, máscaras,
`use` ou CSS. `aitool-mark-flat.svg` cumpre; o master com gradiente não entra
no produto.
