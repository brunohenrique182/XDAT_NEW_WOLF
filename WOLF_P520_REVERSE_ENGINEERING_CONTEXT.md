# Wolf Waker / p520 XDAT — contexto completo de reverse engineering

> Documento de continuidade do trabalho realizado no fork do XDAT Editor para abrir, salvar e editar os `Interface.xdat` modernos do Lineage II Wolf Waker.
>
> Atualizado em **2026-09-21**.
>
> Este arquivo deve ser lido antes de continuar o trabalho no schema moderno. A ideia é permitir que outra sessão, Codex ou desenvolvedor continue exatamente de onde paramos sem depender do histórico do chat.

---

## 1. Objetivo do projeto

O objetivo prático é suportar corretamente o XDAT moderno do cliente **Lineage II Wolf Waker / p520**, com leitura e escrita seguras, para depois remover/desabilitar a interface de Auto Hunt/Auto Farm.

Alvos principais da remoção:

- `AutomaticPlay`
- `AutoHunt_All_Btn`
- controles relacionados em `YetiQuickSlotWnd`
- manter `HuntingZone` separado, pois não é a mesma coisa que Auto Hunt.

A remoção definitiva só deve ser feita depois que o schema:

1. abrir o `Interface.xdat` inteiro sem erro;
2. permitir `Save As`;
3. reabrir o arquivo salvo;
4. passar teste de round-trip;
5. idealmente produzir arquivo byte-equivalente quando nenhuma alteração é feita;
6. for aceito pelo cliente.

**Nunca sobrescrever o XDAT original durante a fase experimental.**

---

## 2. Repositório / branch / PR

Repositório:

```text
brunohenrique182/XDAT_NEW_WOLF
```

Branch de trabalho:

```text
feature/wolf-modern-xdat
```

PR:

```text
#1
Wolf: reconstruct experimental p509 XDAT schema
```

O título original do PR ainda fala em p509 porque o trabalho começou com essa hipótese. A identificação atual mais consistente é **Wolf Waker / p520**.

Clone local usado nos testes:

```text
D:\Downloads\XDAT_NEW_WOLF-modern
```

---

## 3. Identificação do protocolo: p509 vs p520

Inicialmente o cliente foi tratado como `p509`, pois existiam referências públicas ligando Wolf/Varkas a 509.

Depois foi adicionada ao repositório a pasta:

```text
interface_p520/
```

Essa source contém exatamente os sistemas e nomes encontrados no XDAT alvo, incluindo:

- `AutomaticPlay.uc`
- `YetiQuickSlotWnd.uc`
- `AutoHunt_All_Btn`
- `AutoPotionWnd`
- `AutoUseItemWnd`
- `AssassinOnly`
- `AttendCheckWnd`
- `RichListCtrl`
- `RelicSummonWnd`
- árvore de `RelicWnd`
- controles NWindow modernos.

Em `YetiQuickSlotWnd.uc`, por exemplo, a source p520 referencia diretamente:

- `AutoHunt_All_Btn`
- `AutomaticPlay`
- `AutoUseItemWnd`
- `AutoPotionWnd`

Isso conecta a source p520 diretamente ao layout alvo.

### Conclusão atual

Tratar o cliente/schema como:

```text
Wolf Waker / p520
```

A source p520 é a referência principal para:

- tipos de controles;
- herança;
- enums;
- nomes;
- APIs;
- semântica dos campos.

O `Interface.xdat` real continua sendo a referência definitiva para:

- ordem dos campos;
- largura/tamanho;
- campos condicionais;
- formato de listas;
- serialização exata.

---

## 4. Arquivos alvo

### Interface.xdat

Tamanho:

```text
6,723,372 bytes
0x66972C
```

SHA-256:

```text
cbee9c55b81428d4f57a09db5d6d612a761cdc02ffba25ceba26aa0d42234744
```

### InterfaceClassic.xdat

Tamanho:

```text
7,021,258 bytes
0x6B22CA
```

SHA-256:

```text
de2f54db0a327614f0696118da4ae57a27accb1b72374d42f41336307fd9933f
```

Também foram fornecidos:

- `Interface.u`
- `InterfaceClassic.u`

---

## 5. Marcadores importantes no Interface.xdat

Offsets decimais conhecidos no `Interface.xdat`:

```text
AutomaticPlay       169212
AutoHunt_All_Btn   6158862
YetiQuickSlotWnd   6155418
RelicSummonWnd     6358146
RelicCollection    6408254
Varkas              947893
AssassinOnly        109658
CollectionSystem    122604
Homunculus         2308961
```

No `InterfaceClassic.xdat`:

```text
AutomaticPlay       169212
AutoHunt_All_Btn   6158862
YetiQuickSlotWnd   6155418
RelicSummonWnd     6520541
RelicCollection    6570923
Varkas              947893
AssassinOnly        109658
CollectionSystem    122604
Homunculus         2308961
```

---

## 6. Estado do XDAT Editor

O editor original não possuía schema moderno suficiente.

Schemas externos/antigos encontrados em pacotes anteriores:

```text
ct0
ct1
ct15
ct22
ct23
ct24
ct25
ct26
etoa2 variants
etoa3 variants
etoa4
etoa4_p3
etoa5
god25
god3
god35
```

Nenhum deles continha p520.

### Implementações adicionadas

O projeto passou a suportar:

- detecção de marcadores modernos;
- carregamento de schemas externos/plugins;
- geração do schema `p520`;
- versão `Wolf Waker / p520 (experimental)`;
- script de rebuild/test em um comando;
- overlays modernos sobre o schema `etoa5`.

### Observação importante sobre nomes internos

O diretório de overrides ainda se chama:

```text
xdat_editor/schema/p509-overrides/
```

Isso é legado da fase em que o protocolo era tratado como p509.

O build gera:

```text
build/generated-schema/p520
p520.XDAT
```

Não assumir que o nome `p509-overrides` significa que o protocolo atual continua sendo 509.

---

## 7. Comando padrão de rebuild/test

Ambiente validado:

```text
Java:
C:\Program Files\BellSoft\LibericaJDK-21

JavaFX:
%USERPROFILE%\javafx-sdk-21.0.12

Ant:
%USERPROFILE%\tools\apache-ant-1.10.18\bin\ant.bat
```

Comando:

```powershell
cd D:\Downloads\XDAT_NEW_WOLF-modern
git pull

powershell -ExecutionPolicy Bypass `
  -File .\xdat_editor\tools\rebuild-test-p520.ps1
```

Depois selecionar:

```text
Version
-> Wolf Waker / p520 (experimental)
```

O script foi corrigido para encerrar somente processos Java do XDAT Editor antigo antes do `clean`, evitando:

```text
Unable to delete ... commons-csv-1.10.0.jar
```

---

## 8. Estrutura geral do XDAT confirmada

Header:

- primeiro `int`: 25 atalhos;
- os 25 atalhos iniciais usam o formato antigo;
- após os atalhos: `0x502C`;
- quantidade top-level: **643**;
- primeiro `Window`: `0x5030`;
- primeiro nome: `AbilityCategory`.

---

# 9. Diferenças p520 reconstruídas

## 9.1 DefaultProperty

Diferença confirmada:

Após `unk24`, existe um `int modernFlags` antes de `tooltipType`.

Implementado em:

```text
p509-overrides/DefaultProperty.groovy
```

---

## 9.2 Window

O `Window` moderno foi uma das maiores diferenças.

### Bloco moderno após ownerWindow

Inicialmente parecia um bloco fixo de 81 bytes.

Depois foi comprovado que é:

```text
14 ints
1 String variável
6 ints
```

Quando a string é vazia:

```text
56 + 1 + 24 = 81 bytes
```

Exemplo importante:

```text
AgitDecoDrawerWnd
modernBlockString = "AgitDecoWnd"
```

Nesse caso o bloco cresce para 93 bytes.

### Drawer offsets antigos removidos

No p520, depois de `drawerDirection` **não existem** mais os campos antigos:

```text
offsetX
offsetY
directionFixed
```

Isso foi validado em janelas como:

- ChatWnd
- PartyWnd
- StatusWnd
- TargetStatusWnd
- OlympiadPlayer1Wnd
- OlympiadPlayer2Wnd
- PetStatusWnd
- SiegeWnd
- WorldSiegeWnd
- SummonedStatusWnd
- TimeZoneWnd

Esse erro desalinhava completamente o `ChatWnd`.

Commit importante:

```text
afdc152
fix: remove legacy drawer offsets from p520 Window
```

---

## 9.3 Button

Diferenças p520 vs etoa5:

- +1 `String` após `dropTex`;
- +2 `int` após `disableTex`.

Commit:

```text
b0709ae
```

---

## 9.4 ItemWindow

Diferenças confirmadas:

- +1 `int` após `compareTooltip`, antes de `outLineUp`;
- +5 `int` após `expandItem`.

Commit:

```text
b51c2d7
```

---

## 9.5 ComboBox

Descoberta inicial incorreta: pensávamos que havia um int extra no final.

Formato correto p520:

```text
DefaultProperty
int modernHead
List<ComboBoxElement>
```

Ou seja, o `int` moderno vem **antes** da lista.

Isso foi validado em **94 ComboBoxes reais**.

Exemplo:

```text
BoneName_ComboBox
modernHead = 25
listCount = 0
```

Commit:

```text
21f6f17
fix: correct p520 ComboBox field order
```

---

## 9.6 ListCtrl

O formato moderno correto foi validado em **126 ocorrências**:

```text
campos antigos
List<ListElement> antiga
String moderna
4 ints
List<ListElement> moderna variável
```

Cada `ListElement` contém:

```text
textStringId
width
bAscend
bClickEnable
bNumber
```

Exemplo que revelou o problema:

```text
BlockCurTriggerWnd
TeamRedList
TeamBlueList
```

Commit:

```text
c15eee2
fix: parse variable p520 ListCtrl column list
```

---

## 9.7 ScrollArea

p520:

```text
DefaultProperty
areaHeight
2 ints modernos
3 Strings modernas
children
```

Commit:

```text
6f03ece
```

---

## 9.8 HtmlCtrl

Após `viewType`, p520 adiciona:

```text
1 int
3 Strings
```

Exemplo usado:

```text
ArenaTutorialWnd.HtmlViewer
```

Commit:

```text
c940746
```

---

## 9.9 EditBox

Após o corpo etoa5:

```text
3 ints
7 Strings
2 ints
```

Validado em várias instâncias.

Commit:

```text
0a0baab
```

---

## 9.10 CheckBox

p520 adiciona:

```text
+1 int no final
```

após `disableCheckTexture`.

Commit:

```text
d4cd608
```

---

## 9.11 ShortcutItemWindow

p520 adiciona:

```text
+2 ints no final
```

Exemplo:

```text
HP_PotionSlot
old values: 0, 0
modern tail: -1, 1
```

Commit:

```text
da6c1c3
```

---

## 9.12 CharacterViewportWindow

p520 adiciona:

```text
+2 ints
```

após:

```text
npcID
userInfo
```

O erro aparecia em `BalrogWnd.ObjectViewport`, deixando o parser 8 bytes adiantado.

Commit:

```text
a31b593
```

---

## 9.13 EffectViewportWnd

Controle moderno que não existia no etoa5.

Layout reconstruído a partir de **104 ocorrências**:

```text
DefaultProperty
5 floats
2 ints
2 Strings
1 bool/int
```

Interpretação compatível com a API p520:

- scale
- offset X
- offset Y
- offset Z
- camera distance
- pitch
- yaw
- background texture
- mask texture
- UI sound

Commit:

```text
0124c68
```

---

## 9.14 StatusBar

O layout etoa5 era incompatível.

A source p520 define 25 tipos em `StatusBarSplitType`.

Foram validadas **124 instâncias reais**.

Formato:

```text
title
titleIndex
unit
drawPoint
decimalPlace

25 x GaugeTextureSplitData

gaugeFontTexture
fontSizeX
fontSizeY

List<ScaleMark>
```

Cada gauge:

```text
texture
barUSize
barVSize
color
ratio
```

Commit:

```text
846dfa7
```

---

## 9.15 StatusRound

Não existia no etoa5.

A source p520 define:

```text
StatusRoundSplitType:
Back
Main
Trailer
Mask1
Mask2
Overlay
```

Foram validadas **25 instâncias reais**.

Formato reconstruído:

```text
DefaultProperty
6 x GaugeTextureSplitData
8 x int de geometria/estado preservados
```

Commit:

```text
5e70262
schema: add reconstructed p520 StatusRound control
```

---

## 9.16 ChatWindow

O etoa5 esperava dois ints.

No p520, as 6 ocorrências reais:

- NormalChat
- TradeChat
- PartyChat
- ClanChat
- PetitionChatWindow
- SystemMsgList

possuem exatamente **um valor de 32 bits** após `DefaultProperty`.

Commit:

```text
090e717
```

---

## 9.17 RichListCtrl

Essa foi uma das reconstruções mais importantes.

A implementação inicial estava incorreta e causava:

```text
OutOfMemoryError: Java heap space
```

porque bytes internos eram interpretados como um tamanho gigantesco de lista.

Após cruzar:

- `interface_p520/NWindow/Classes/RichListCtrlHandle.uc`
- estruturas de `UIEventManager.uc`
- **225 RichListCtrl reais** no XDAT

o formato consistente encontrado foi:

```text
DefaultProperty

11 x int

3 x String

3 x byte cru

3 x String

int columnCount

columnCount x RichListColumn
```

Cada `RichListColumn`:

```text
10 x int
```

Os 3 bytes normalmente são:

```text
0 / 0 / 0
```

Listas relacionadas a quests mostraram:

```text
16 / 16 / 15
```

Foi adicionada proteção para:

```text
columnCount < 0
columnCount > 256
```

Assim um próximo mismatch gera `IOException` legível em vez de estourar o heap.

Commit:

```text
71aaa11
fix: reconstruct complete p520 RichListCtrl layout
```

---

## 9.18 InvenWeight

Última diferença identificada antes da criação deste documento.

O p520 mantém o corpo etoa5 e adiciona:

```text
+3 ints
```

após:

```text
fontWidth
fontHeight
```

Validado em **14 instâncias reais**, incluindo:

- DeliverWnd
- DetailStatusWnd
- InventoryWnd
- WarehouseWnd
- TradeWnd
- PetWnd

Nos arquivos observados, os três valores são:

```text
-9999
-9999
-9999
```

Com esse ajuste, `DeliverWnd` passa offline com **25 filhos válidos** e termina exatamente em `SelectDeliverWnd`.

Commit:

```text
4057372
schema: extend p520 InvenWeight tail
```

**Status: ainda precisa de confirmação no próximo teste do editor.**

---

# 10. Controles que parecem compatíveis com etoa5

Até agora não exigiram override nas instâncias verificadas:

- SliderCtrl
- Progress
- NameCtrl
- TreeCtrl
- RadioButton
- BarCtrl

Não assumir que isso prova compatibilidade global; significa apenas que as instâncias testadas bateram.

---

# 11. Source interface_p520 como catálogo

Foi feito inventário dos `*Handle.uc` de NWindow.

Controles relevantes presentes na source mas inicialmente ausentes do schema:

```text
AnimTexture
Bar
MultiEditBox
ProgressCtrl
SceneCameraCtrl
SceneMusicCtrl
SceneNpcCtrl
ScenePcCtrl
SceneScreenCtrl
StatusRound
```

Desses, na verificação feita no `Interface.xdat` alvo, `StatusRound` foi o tipo realmente encontrado como classe serializada e já foi implementado.

Não criar os outros às cegas sem ocorrência binária real.

---

# 12. Progresso dos testes de runtime

## Validação real final do round-trip — 2026-09-21

O schema p520 atual foi validado diretamente contra os **dois XDAT originais fornecidos**, usando o artefato do GitHub Actions gerado pelo commit `ebb197c`.

### Interface.xdat

Original:

```text
Tamanho: 6,723,372 bytes
SHA-256: cbee9c55b81428d4f57a09db5d6d612a761cdc02ffba25ceba26aa0d42234744
```

Resultado do round-trip sem edição:

```text
READ_OK
643 windows
25 shortcuts

WRITE_OK
Tamanho salvo: 6,723,372 bytes
SHA-256 salvo: cbee9c55b81428d4f57a09db5d6d612a761cdc02ffba25ceba26aa0d42234744

FIRST_DIFF=NONE

REOPEN_OK
643 windows
25 shortcuts
```

### InterfaceClassic.xdat

Original:

```text
Tamanho: 7,021,258 bytes
SHA-256: de2f54db0a327614f0696118da4ae57a27accb1b72374d42f41336307fd9933f
```

Resultado do round-trip sem edição:

```text
READ_OK
656 windows
25 shortcuts

WRITE_OK
Tamanho salvo: 7,021,258 bytes
SHA-256 salvo: de2f54db0a327614f0696118da4ae57a27accb1b72374d42f41336307fd9933f

FIRST_DIFF=NONE

REOPEN_OK
656 windows
25 shortcuts
```

### Marcadores-alvo confirmados

Nos arquivos reais foram confirmados:

- `AutomaticPlay` — 33 ocorrências;
- `AutoHunt_All_Btn` — 5 ocorrências;
- `YetiQuickSlotWnd` — 17 ocorrências;
- `RelicSummonWnd` — 37 ocorrências no `Interface.xdat` e 38 no `InterfaceClassic.xdat`;
- `Varkas` — presente.

Como o resultado sem edição possui **mesmo tamanho, mesmo SHA-256 e nenhum primeiro byte divergente**, esses marcadores e seus dados binários ao redor sobreviveram ao ciclo:

```text
read -> write -> reopen
```

sem qualquer alteração.

### Correções que fecharam o round-trip

As últimas diferenças de serialização foram resolvidas por:

```text
f62d702  p520 ChatChannelDefinition: 30 canais + duas cores RGBA
5cf56f5  preservar Window.exitbutton como inteiro cru
741c059  preservar a seção moderna final do XDAT byte-for-byte
ebb197c  preservar ListCtrl.ListElement.bNumber como inteiro cru
```

O CI do push final concluiu com sucesso.

### Estado atual

O suporte p520 já passou por:

- leitura integral dos dois XDAT reais;
- escrita integral;
- reabertura do arquivo salvo;
- round-trip **byte-idêntico** sem edição;
- preservação dos alvos de Auto Hunt, Relic e Varkas.

A fronteira que resta é diferente: precisamos fazer uma **edição controlada** no Auto Hunt, salvar e verificar se o cliente Wolf aceita o arquivo modificado.

---

# 13. Histórico resumido de commits importantes

```text
925d30f  fix variable modern Window block
b0709ae  p520-era Button override
b51c2d7  ItemWindow override
1cecdbd  ComboBox initial reconstruction
a2e168c  ListCtrl initial reconstruction
6f03ece  ScrollArea override
c940746  HtmlCtrl override
e9fc76b  RichListCtrl initial class
0a0baab  EditBox override
d4cd608  CheckBox override
da6c1c3  ShortcutItemWindow override
846dfa7  StatusBar p520 layout
a31b593  CharacterViewportWindow p520 tail
0124c68  EffectViewportWnd p520
c15eee2  variable p520 ListCtrl columns
21f6f17  correct p520 ComboBox field order
afdc152  remove old drawer offsets from p520 Window
090e717  p520 ChatWindow body
5e70262  p520 StatusRound
71aaa11  complete p520 RichListCtrl layout
4057372  p520 InvenWeight tail
c0c2ea1  p520 TextListBox tail
f62d702  p520 ChatChannelDefinition moderno
5cf56f5  preservar Window.exitbutton cru
741c059  preservar trailing section moderna byte-for-byte
ebb197c  preservar ListCtrl.ListElement.bNumber cru; fecha round-trip byte-idêntico
```

O histórico completo da branch/PR deve ser consultado no GitHub para SHAs completos.

---

# 14. Auto Hunt — estado atual

Marcadores centrais:

```text
AutomaticPlay
YetiQuickSlotWnd
AutoHunt_All_Btn
AutoPotionWnd
AutoUseItemWnd
```

A source p520 confirma as relações entre esses controles.

### Patch binário temporário anterior

Foi criado experimentalmente um patch que escondia os controles alterando tamanho/posição:

```text
width/height = 0
x/y = -10000
```

Arquivos experimentais:

```text
Interface_no_autohunt.xdat
InterfaceClassic_no_autohunt.xdat
Interface_No_AutoHunt.zip
```

Isso é apenas workaround.

**Objetivo final:** remover/desabilitar pelo schema/editor com round-trip válido.

---

# 15. Avisos conhecidos

### L2.ini

O aviso:

```text
Couldn't load environment from D:\fasdfdas\L2.ini
```

não é a causa dos erros de parsing do XDAT.

Pode ser tratado depois para carregamento de recursos/preview.

### No external schema plugins

Mensagem:

```text
No external schema plugins found ...\schema-plugins
```

é normal no fluxo atual porque o p520 está sendo gerado como schema built-in.

---

# 16. Estratégia correta daqui para frente

Não voltar ao método puramente:

```text
teste -> quebra -> corrige uma classe -> rebuild
```

A estratégia atual deve ser:

```text
interface_p520
    ↓
inventário de tipos / heranças / enums / API
    ↓
Interface.xdat real
    ↓
confirmar ordem e largura binária
    ↓
implementar override em lote
    ↓
parser completo
    ↓
round-trip
    ↓
remoção de Auto Hunt
```

Sempre preferir validar uma hipótese em várias ocorrências reais antes de alterar o schema.

---

# 17. Próximos passos

O parser/serializer base p520 está fechado para no-op round-trip. Não voltar a reconstruir subclasses sem uma nova evidência binária.

Próxima etapa prática:

1. Fazer uma cópia dos XDAT originais.
2. Abrir com `Wolf Waker / p520 (experimental)`.
3. Fazer uma alteração **mínima e reversível** ligada ao Auto Hunt.
4. Priorizar primeiro esconder/desabilitar `AutoHunt_All_Btn` / controles de `YetiQuickSlotWnd`, sem remover estruturas inteiras.
5. Salvar em um novo arquivo.
6. Reabrir o arquivo modificado no XDAT Editor para confirmar consistência estrutural.
7. Comparar original vs modificado e registrar exatamente quais bytes/objetos mudaram.
8. Colocar o arquivo modificado no cliente Wolf.
9. Iniciar o cliente e validar:
   - login;
   - entrada no mundo;
   - UI principal;
   - atalhos;
   - `YetiQuickSlotWnd`;
   - Auto Potion / Auto Use Item;
   - ausência/desativação do Auto Hunt;
   - ausência de crash/erro de interface.
10. Depois de o teste controlado ser aceito, aplicar a remoção/desativação completa de:
    - `AutomaticPlay`;
    - `AutoHunt_All_Btn`;
    - controles relacionados ao Auto Hunt.
11. Repetir a edição no `InterfaceClassic.xdat`.
12. Só então considerar o suporte p520 + remoção de Auto Hunt concluídos.

---

# 18. Critério de conclusão do suporte p520

### Já concluído

- `Interface.xdat` abre 100%;
- `InterfaceClassic.xdat` abre 100%;
- `Save As` funciona;
- arquivo salvo reabre;
- no-edit round-trip é **byte-idêntico** nos dois arquivos reais;
- tamanhos e SHA-256 são preservados;
- marcadores modernos de Auto Hunt, Relic e Varkas são preservados;
- GitHub Actions do schema p520 está verde no commit final validado.

### Ainda pendente

- fazer uma alteração controlada real;
- confirmar que o cliente Wolf aceita o XDAT **editado**;
- remover/desabilitar Auto Hunt sem quebrar a UI;
- validar a mesma mudança em `InterfaceClassic.xdat`.

Portanto, o **schema p520 de leitura/escrita sem edição está validado**. O que falta agora é a validação funcional do arquivo modificado dentro do cliente.

---

## Resumo curto para uma nova sessão

Se você está entrando neste projeto agora:

- o cliente alvo é **Wolf Waker / p520**;
- a pasta `interface_p520` é a source de referência;
- o schema p520 reconstruído já lê integralmente os dois XDAT reais;
- `Interface.xdat`: 643 windows / 25 shortcuts;
- `InterfaceClassic.xdat`: 656 windows / 25 shortcuts;
- ambos passam `read -> write -> reopen`;
- ambos geram saída **byte-idêntica ao original**, com SHA-256 idêntico;
- `AutomaticPlay`, `AutoHunt_All_Btn`, `YetiQuickSlotWnd`, `RelicSummonWnd` e `Varkas` foram confirmados;
- commit final validado do round-trip: `ebb197c`;
- a próxima tarefa não é mais corrigir parsing: é fazer uma **edição controlada do Auto Hunt e testar o arquivo editado no cliente Wolf**.


---

# 19. Primeiro teste real de XDAT editado — falha no loader nativo

Data:

```text
2026-09-21
```

Cliente confirmado:

```text
Version: D10_Global,NL_s,V2110409,520
BuildDate: Fri Aug 29 04:00:47 2025
```

Após o round-trip sem edição ter sido fechado como byte-idêntico, foi feito o primeiro teste com um XDAT realmente alterado.

O cliente rejeitou o arquivo durante a inicialização, antes de entrar no mundo ou executar a lógica normal de `AutomaticPlay.uc`.

Erro:

```text
Assertion failed: pUIData [File:..\XML\XMLDataManager.cpp] [Line: 1637]

History:
XMLDataManager::CreateUIData
<- XMLWindowData::Serialize
<- XMLDataManager::Serialize
<- XMLDataManager::LoadXdat
<- XMLUIManager::LoadXML
<- NConsoleWnd::InitializeXMLUI
<- NConsoleWnd::Initialize
<- NConsoleWnd::Init
<- UGameEngine::InitConsole
<- UGameEngine::Init
<- InitEngine
```

### Interpretação atual

Isso desloca a fronteira do problema.

Já está comprovado que:

- o schema p520 lê os dois XDAT reais;
- escreve os dois XDAT;
- reabre os arquivos salvos;
- sem alteração, o resultado é byte-idêntico ao original.

Porém, um arquivo realmente modificado falha dentro de `XMLDataManager::LoadXdat`.

As duas hipóteses principais a distinguir agora são:

1. a edição pelo Property Sheet alterou mais bytes/campos do que o pretendido;
2. a seção moderna final preservada como `modernTrailingData` contém índice, validação, checksum ou metadata dependente do conteúdo anterior e precisa ser reconstruída/recalculada após uma edição.

Não assumir ainda qual hipótese é correta.

### Ferramenta de diagnóstico adicionada

Commit:

```text
6eb67a8
tools: add p520 edited XDAT binary comparator
```

Arquivo:

```text
xdat_editor/tools/compare-xdat-edit.ps1
```

Uso:

```powershell
powershell -ExecutionPolicy Bypass -File .\xdat_editor\tools\compare-xdat-edit.ps1 `
  -Original "C:\caminho\Interface.original.xdat" `
  -Edited   "C:\caminho\Interface.edited.xdat"
```

O script informa:

- tamanho original e editado;
- SHA-256;
- quantidade de bytes modificados;
- quantidade de faixas modificadas;
- primeiro e último offset divergente;
- hexdump de contexto das diferenças;
- offsets dos marcadores principais do Auto Hunt.

### Próximo passo obrigatório

Antes de tentar remover `AutomaticPlay` ou objetos inteiros:

1. comparar o original com o arquivo que causou o crash;
2. confirmar se a alteração foi somente a região esperada;
3. se forem apenas poucos bytes em tamanho fixo, investigar a trailing section moderna como possível metadata de validação/índice/checksum;
4. se houver múltiplas regiões inesperadas, corrigir primeiro a edição/serialização do Property Sheet;
5. se o tamanho do arquivo mudar em uma edição fixa, tratar como bug de serialização.

Até esse diagnóstico ser fechado, não avançar para remoção estrutural do Auto Hunt.


---

# 20. Diagnóstico do primeiro XDAT editado — corrupção pela Property Sheet

O comparador binário foi executado contra:

```text
Original: Interface.xdat
Edited:   Interface_editado.xdat
```

Resultado:

```text
Original size : 6,723,372 bytes
Edited size   : 6,723,355 bytes
Changed bytes : 475,918
Changed ranges: 37,770
First diff    : 0x00029515
Last diff     : 0x0066972B
```

Isso descartou a hipótese de uma alteração mínima seguida apenas de rejeição por checksum/trailing metadata.

### Evidência binária importante

O primeiro desvio aparece dentro da região inicial de `AutomaticPlay`.

Valores crus no original:

```text
FF FF FF FF
```

foram regravados no arquivo editado como:

```text
01 00 00 00
```

No framework do editor:

```text
-1 -> Boolean null
 0 -> false
 1 -> true
```

e:

```text
null -> -1
false -> 0
true -> 1
```

Portanto, o binário p520 suporta estado booleano tri-state e precisa preservar `-1/null` exatamente.

### Root cause na UI

`PropertySheetManager` mantinha um cache estático:

```text
Map<Class, List<PropertySheetItem>>
```

Os `FieldProperty` armazenados nesse cache são stateful:

- guardam o objeto-alvo atual;
- mantêm listeners;
- são reutilizados entre todas as instâncias da mesma classe.

Assim, ao selecionar uma nova `Window` ou `Button`, um editor criado para a instância anterior podia continuar com estado visual antigo e empurrar esse valor para a nova instância.

Isso explica:

- `AutomaticPlay` sofrer alterações sem ter sido o alvo desejado;
- valores `-1/null` virarem `1/true`;
- `AutoHunt_All_Btn` receber serialização incompatível com seu estado original;
- o arquivo diminuir 17 bytes;
- todo o conteúdo posterior ficar deslocado e produzir centenas de milhares de diferenças.

### Correções

```text
737ecd0  fix: prevent PropertySheet state leaking across XDAT objects
ed0448a  fix: preserve tri-state booleans during PropertySheet sync
```

Mudanças:

1. `PropertySheetManager` não reutiliza mais `FieldProperty` entre objetos diferentes.
2. Cada seleção recebe novos property items.
3. `BooleanPropertyEditor` não propaga estados intermediários enquanto ControlsFX sincroniza checkbox tri-state.
4. O valor final `null / false / true` é publicado somente após a sincronização visual terminar.

### Próximo teste

Depois de atualizar para `ed0448a`:

1. rebuildar o editor p520;
2. abrir o `Interface.xdat` original;
3. navegar/selecionar vários Windows e Buttons;
4. fazer `Save As` sem alteração;
5. comparar original vs salvo — precisa continuar byte-idêntico;
6. repetir a alteração controlada de `AutoHunt_All_Btn.anchor_x`;
7. comparar novamente;
8. a edição deve produzir apenas a diferença correspondente ao campo alterado, sem mudança de tamanho;
9. somente então testar no cliente Wolf.

Não investigar checksum/trailing data antes desse novo teste, porque a primeira edição estava comprovadamente corrompida pela Property Sheet.


---

# 21. GUI PropertySheet corrigida — edição controlada agora é mínima

Após os commits:

```text
737ecd0  fix: prevent PropertySheet state leaking across XDAT objects
ed0448a  fix: preserve tri-state booleans during PropertySheet sync
```

foram repetidos dois testes no `Interface.xdat` real.

## 21.1 Save As pela GUI sem edição

Arquivo:

```text
Interface_GUI_NOEDIT.xdat
```

Resultado:

```text
Original size : 6,723,372 bytes
Edited size   : 6,723,372 bytes

Original SHA-256:
cbee9c55b81428d4f57a09db5d6d612a761cdc02ffba25ceba26aa0d42234744

Edited SHA-256:
cbee9c55b81428d4f57a09db5d6d612a761cdc02ffba25ceba26aa0d42234744

IDENTICAL: no byte differences.
```

Isso confirma que navegar pela Property Sheet e salvar sem alteração não contamina mais o XDAT.

## 21.2 Edição controlada de AutoHunt_All_Btn

Foi alterado somente o valor de posição testado em:

```text
YetiQuickSlotWnd.AutoHunt_All_Btn
```

Arquivo:

```text
Interface_editado_v2.xdat
```

Resultado:

```text
Original size : 6,723,372 bytes
Edited size   : 6,723,372 bytes

Changed bytes  : 1
Changed ranges : 1

First diff : 0x005DFA89 (6158985)
Last diff  : 0x005DFA89 (6158985)
```

Byte original:

```text
0x36
```

Byte editado:

```text
0x37
```

Classificação:

```text
minimal fixed-size edit
```

Os marcadores principais continuam nos mesmos offsets:

```text
AutomaticPlay      0x000294FC
AutoHunt_All_Btn   0x005DFA0E
YetiQuickSlotWnd   0x005DEC9A
RelicSummonWnd     0x00610482
Varkas             0x000E76B5
```

### Conclusão

O problema anterior de arquivo editado estruturalmente corrompido foi resolvido.

O editor agora demonstra:

- no-op GUI Save As byte-idêntico;
- edição real preservando o tamanho;
- apenas o byte esperado é alterado;
- nenhuma normalização massiva de outros objetos;
- nenhum deslocamento estrutural posterior.

### Próximo passo

Testar `Interface_editado_v2.xdat` diretamente no cliente Wolf.

Se o cliente aceitar esse arquivo, a etapa de edited-file acceptance do schema/editor está fechada e podemos avançar para esconder/desabilitar o Auto Hunt de forma controlada.

Se o cliente rejeitar mesmo com apenas esse único byte alterado, então investigar metadata/validação/checksum do cliente passa a ser novamente relevante.
