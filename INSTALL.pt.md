[English](INSTALL.md) | **Português**

# Instalar o AITOOL

O AITOOL é uma extensão para o cliente desktop do Primavera v10 (SG100).

## Requisitos

- Uma instalação licenciada do **Primavera v10 (SG100)** (fornece o SDK do ERP que o AITOOL
  usa em runtime, e a maior parte dos controlos DevExpress; o instalador leva os restantes).
- **Microsoft Edge WebView2 Runtime** (Evergreen). A maioria das máquinas Windows 11 já o
  tem; caso contrário, instala-se a partir da Microsoft (gratuito).
- Uma chave de API de pelo menos um fornecedor de IA: OpenAI, OpenRouter, Anthropic, ou
  qualquer endpoint compatível com OpenAI (p. ex. um servidor LM Studio local, que não
  precisa de chave).

## Instalações cliente-servidor

O Primavera v10 instala-se tipicamente em cliente-servidor: o ERP vive num servidor e cada
posto de trabalho chega à pasta partilhada `SG100` (mapas, configuração, extensões) através
de uma partilha Windows. O AITOOL é uma extensão dentro dessa pasta, por isso:

- **Corra o setup uma vez**, na máquina que tem o `SG100` (o servidor, ou o PC que partilha
  a pasta), com o cliente Primavera fechado em todo o lado. O setup encontra a instalação,
  escreve os ficheiros em `<SG100>\Config\EV\Extensions\AITOOL\` e regista o addon no ecrã
  de Extensibilidade do ERP.
- **Os postos não precisam de mais nada.** Apanham o assistente no arranque seguinte. O
  único requisito local é o runtime Microsoft Edge WebView2, que o Windows 10 e 11 já
  trazem.
- **As chaves são por utilizador.** Cada pessoa introduz a sua chave de fornecedor nas
  definições do assistente; fica cifrada com o perfil DPAPI desse utilizador Windows, nesse
  posto. Uma empresa que queira uma chave partilhada, ou um modelo local num servidor,
  aponta o endpoint para lá.

As topologias variam (Terminal Server, várias instâncias, uma cópia do `SG100` por
máquina); se a sua for invulgar, a cópia manual abaixo funciona da mesma forma, pasta a
pasta.

## Instalação

O instalador não está assinado digitalmente; o Windows SmartScreen avisa na primeira
execução. Verifique o SHA256 publicado com a release antes de continuar.

1. Fechar o cliente Primavera.
2. Copiar os ficheiros do AITOOL para a pasta de extensões da instalação Primavera:
   `<SG100>\Config\EV\Extensions\AITOOL\` — tipicamente
   `C:\Program Files\PRIMAVERA\SG100\Config\EV\Extensions\AITOOL\`. Se o Primavera
   estiver instalado noutro local, a variável de ambiente `PERCURSOSGE100` aponta para a
   respetiva pasta `Apl`; `<SG100>` é a pasta-mãe dessa pasta.
   (Copiar a pasta completa que lhe foi entregue; não deixar cópias antigas para trás.)

   **Múltiplas instâncias do ERP:** cada instância Primavera além da `DEFAULT` tem a sua
   própria árvore de pastas com sufixo (`Config_<INSTANCE>`, p. ex. `Config_ALEX`).
   Repetir a cópia para `<SG100>\Config_<INSTANCE>\EV\Extensions\AITOOL\` em cada
   instância que deva ter o assistente — ou usar o instalador, que deteta as instâncias e
   instala em todas as selecionadas de uma vez.
3. Iniciar o cliente Primavera. O AITOOL aparece no friso (ribbon).

## Primeira execução — configurar um fornecedor

1. Abrir o AITOOL e clicar no ícone de definições (engrenagem).
2. Escolher um fornecedor (OpenAI, OpenRouter, Anthropic, ou um endpoint compatível).
3. Colar a chave de API e escolher um modelo (a lista carrega a partir do fornecedor). A
   chave é guardada encriptada na máquina (Windows DPAPI) e nunca é escrita em texto
   simples nem enviada para lado nenhum exceto o fornecedor escolhido. Ver
   [SECURITY.md](SECURITY.md).
4. Começar a conversar. As definições (fornecedor, modelo, chave) persistem entre
   reinícios.

## Onde obter uma chave

- OpenAI: <https://platform.openai.com/api-keys>
- OpenRouter: <https://openrouter.ai/keys>
- Anthropic: <https://console.anthropic.com/>

## Atualizar

Fechar o cliente, substituir os ficheiros na pasta de extensões do AITOOL pela nova build
e reiniciar. As definições de fornecedor e a chave encriptada são preservadas.

## Desinstalar

Fechar o cliente e apagar a pasta `…\Extensions\AITOOL\`. Para remover também a chave
guardada, apagar `%LocalAppData%\Cegid\Extensions\AITOOL\secrets.dat`.
