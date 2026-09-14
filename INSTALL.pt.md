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

Descarregue o `AITOOL-Setup-<versão>.exe` da página da release e corra-o na máquina que tem
o `SG100`, com o cliente Primavera fechado. O instalador ainda não está assinado
digitalmente, por isso o Windows SmartScreen avisa na primeira execução: clique em **Mais
informações → Executar mesmo assim**. O SHA256 publicado com a release é a forma de
verificar o download antes disso.

O assistente de instalação faz sozinho o trabalho do lado do ERP:

1. **Encontra a instalação Primavera** — `PERCURSOSGE100`/`PERCURSOSGV100`, depois o
   registo, depois uma instalação anterior do AITOOL, e só pergunta se tudo isso falhar.
   Recusa-se a continuar com o cliente do ERP aberto.
2. **Deteta ERPs multi-instância** (árvores `Config_<INSTANCE>`, p. ex. `Config_ALEX`) e
   deixa instalar numa ou em várias de uma vez, com uma consulta opcional à PRIINSTANCIAS
   no SQL Server.
3. **Escreve os ficheiros** em `<SG100>\Config\EV\Extensions\AITOOL\` para cada instância
   selecionada e **regista o AITOOL no ecrã de Extensibilidade do ERP**, como extensão
   comum ou para empresas específicas.
4. **Verifica o Microsoft Edge WebView2 Runtime** e instala-o se faltar.

Para departamentos de IT: `/VERYSILENT /INSTANCES=ALL /SQLSERVER=SRV /REGISTER=COMMON`, ou
`/VERYSILENT /DIR="<SG100>\Config\EV\Extensions\AITOOL"`.

Depois inicie o cliente Primavera. O AITOOL aparece no friso (ribbon).

### Cópia manual, em alternativa

Útil quando o instalador não pode correr — uma topologia invulgar, ou uma política contra
instaladores.

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
   instância que deva ter o assistente.
3. Registar a extensão à mão no ecrã de Extensibilidade do ERP — o passo que o instalador
   faria por si.
4. Iniciar o cliente Primavera. O AITOOL aparece no friso (ribbon).

## Primeira execução — configurar um fornecedor

1. Abrir o AITOOL e clicar no ícone de definições (engrenagem).
2. Escolher um fornecedor (OpenAI, OpenRouter, Anthropic, ou um endpoint compatível).
3. Colar a chave de API e escolher um modelo (a lista carrega a partir do fornecedor). A
   chave é guardada encriptada na máquina (Windows DPAPI) e nunca é escrita em texto
   simples nem enviada para lado nenhum exceto o fornecedor escolhido. Ver
   [SECURITY.md](SECURITY.md).
4. Começar a conversar. As definições (fornecedor, modelo, chave) persistem entre
   reinícios.

Na primeira execução o addon cria três tabelas `AI_*` na base de dados do ERP, para o
histórico de conversas e o trilho de auditoria. O que guardam, e o script pronto para
instalações onde o addon não pode fazer `CREATE TABLE`, estão em
[docs/SECURITY-AND-PRIVACY.pt.md, secção 6](docs/SECURITY-AND-PRIVACY.pt.md#6-o-que-fica-guardado-na-sua-base-de-dados).

## Onde obter uma chave

- OpenAI: <https://platform.openai.com/api-keys>
- OpenRouter: <https://openrouter.ai/keys>
- Anthropic: <https://console.anthropic.com/>

## Atualizar

Fechar o cliente, substituir os ficheiros na pasta de extensões do AITOOL pela nova build
e reiniciar. As definições de fornecedor e a chave encriptada são preservadas.

## Desinstalar

Feche o cliente Primavera e desinstale o AITOOL pelas **Aplicações** do Windows
(Definições → Aplicações → Aplicações instaladas). São removidos os ficheiros de todas as
pastas registadas na instalação, a linha do AITOOL sai da configuração de Extensibilidade do
ERP e a chave `HKLM\SOFTWARE\Bola Labs\AITOOL`, com a lista `InstallDirs`, é apagada.

Duas pastas ficam de propósito: `%LocalAppData%\Cegid\Extensions\AITOOL` (as suas
definições, o `secrets.dat` cifrado e os logs) e `%ProgramData%\AITOOL` (as skills
partilhadas). Apague-as à mão se não quiser deixar nada. As tabelas `AI_*` também ficam na
base de dados do ERP; são suas para eliminar.

Depois de uma cópia manual, remova antes a pasta `…\Extensions\AITOOL\` e a linha de
Extensibilidade à mão.
