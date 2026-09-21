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

O schema já passou por uma grande sequência de top-level Windows, incluindo:

- Ability*
- AbnormalStatusExtendWnd
- ActionWnd
- AgeWnd
- AgitDeco*
- Alchemy*
- ArenaTutorialWnd
- Artifact*
- AssassinOnly
- AttendCheck*
- Attribute*
- Auction*
- AutomaticPlay
- AutoPotion*
- AutoShotItemWnd
- AutoUseItem*
- Balrog*
- BenchMarkMenuWnd
- BirthdayAlarm*
- BlackCouponWnd
- Block*
- BoardWnd
- BOTsystemWnd
- BottomBar
- BR_*
- BuilderCmdWnd
- CalculatorWnd
- Campaign*
- CardExchangeWnd
- Character*
- ChatWnd
- Clan*
- ClassChange*
- Cleft*
- CollectionSystem*
- ColorNickName*
- ConsoleWnd
- CounterAttackWnd
- CouponEventWnd
- CrossEvent*
- CrystallizationWnd
- CursedWeaponMessage
- Customizing*
- DebugWnd

### Último teste de runtime antes deste documento

Após o fix de RichListCtrl, o parser chegou a:

```text
DebugWnd[Window]
```

e depois caiu em EOF no tamanho total do arquivo:

```text
Read error before offset 0x66972c
java.io.EOFException
at IOUtil.readUIEntity
at p520.Window.read(Window.groovy:227)
```

Análise offline mostrou:

- `DebugWnd` está alinhado corretamente;
- o próximo top-level é `DeliverWnd`;
- o desalinhamento real era `InvenWeight`;
- foi criado o fix `4057372`;
- próximo teste deve confirmar avanço além de `DeliverWnd`.

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

1. Fazer `git pull` contendo o commit `4057372`.
2. Rebuildar `p520`.
3. Abrir novamente o `Interface.xdat`.
4. Confirmar que passa por `DebugWnd`, `DeliverWnd` e `SelectDeliverWnd`.
5. Se houver nova falha, identificar o controle anterior ao offset e cruzar com `interface_p520`.
6. Continuar até todos os 643 top-level Windows serem lidos.
7. Fazer `Save As` sem edição.
8. Reabrir o arquivo salvo.
9. Comparar original vs salvo.
10. Corrigir qualquer diferença de round-trip.
11. Só depois editar/remover:
    - `AutomaticPlay`
    - `AutoHunt_All_Btn`
    - elementos relacionados ao Auto Hunt.
12. Testar no cliente real.
13. Repetir o mesmo processo no `InterfaceClassic.xdat`.

---

# 18. Critério de conclusão do suporte p520

O suporte só deve ser considerado concluído quando:

- `Interface.xdat` abre 100%;
- `InterfaceClassic.xdat` abre 100%;
- `Save As` funciona;
- arquivo salvo reabre;
- no-edit round-trip não altera estrutura inesperadamente;
- cliente aceita o arquivo salvo;
- Auto Hunt pode ser removido/desabilitado sem quebrar UI;
- offsets/layouts modernos deixam de depender de hacks manuais.

---

## Resumo curto para uma nova sessão

Se você está entrando neste projeto agora:

- o cliente alvo é tratado como **Wolf Waker / p520**;
- a pasta `interface_p520` é a source de referência;
- o XDAT moderno está sendo reconstruído sobre etoa5 com overrides;
- muitos controles modernos já foram corrigidos;
- o parser já chega até `DebugWnd`;
- o último fix implementado foi **InvenWeight +3 ints**, commit `4057372`;
- o próximo passo é testar esse commit e continuar a partir de `DeliverWnd`;
- o objetivo final é remover `AutomaticPlay` / `AutoHunt_All_Btn` com round-trip seguro.
