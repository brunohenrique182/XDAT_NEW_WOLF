# Wolf modern XDAT research

This branch tracks support for the modern Lineage II interface files used by the Wolf project.

## Current status

The upstream editor bundled in this repository exposes schemas only through `etoa5` (Salvation).
Modern interface files with Varkas, Relic and Automatic Play systems are newer and must **not** be saved with the Salvation schema.

The editor now supports **external schema plugins** from `schema-plugins/*.jar`. It reads a plugin's `versions.csv` when present and also discovers protocol classes such as `p502/XDAT.class` automatically.

For the Wolf Waker sample, current evidence points to the **509 client/protocol line**, with some interface work still referring to a **502 XDAT** base during the 502→509 transition. Therefore the exact XDAT schema must be verified empirically rather than hard-coded as p502. The repository does not redistribute third-party schema binaries; the installer downloads a public external schema directly on the user's machine and reports every numbered `p###/XDAT.class` it actually contains.

## Observations from the current samples

- Legacy shortcut parsing remains compatible at the beginning of the file.
- A tested sample contains 25 shortcuts and then 643 top-level windows.
- The modern `DefaultProperty` layout contains at least one additional 32-bit field after the legacy `unk24` position and before `tooltipType`.
- The modern `Window` layout also diverges from `etoa5`; changing only the window count or the root reader is not sufficient.
- Modern fingerprints include:
  - `AutomaticPlay`
  - `AutoHunt_All_Btn`
  - `YetiQuickSlotWnd`
  - `RelicSummonWnd`
  - Relic collection UI
  - Varkas UI assets
  - modern Collection/Homunculus/Assassin systems

## Safety rule

Do not implement a fake p502 schema by truncating the window count or swallowing EOF.
A schema is considered usable only after:

1. the entire file parses without fallback/truncation;
2. known windows such as `AutomaticPlay` and `YetiQuickSlotWnd` are represented correctly;
3. save-to-new-file succeeds;
4. a no-op read/write round trip preserves the binary structure expected by the client;
5. the resulting file is accepted by the target client.

## Install the modern p502 schema

From a source checkout:

```powershell
powershell -ExecutionPolicy Bypass -File .\xdat_editor\tools\install-modern-schema.ps1
```

From a built `dist` folder, double-click:

```text
install-modern-schema.bat
```

The installer downloads the public schema JAR into `schema-plugins\aln-modern-schema.jar`, enumerates every numbered `p###/XDAT.class` it contains, highlights p520/p502 when present, and leaves the built-in Salvation and older schemas untouched.

Restart the editor after installation. The modern protocols are then added to the **Version** menu with an `[external]` suffix.

## Local inspector

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\xdat_editor\tools\inspect-modern-xdat.ps1 "D:\path\to\Interface.xdat"
```

The inspector is read-only and reports file size, SHA-256, modern feature markers and their first byte offsets.

## Verification still required

The plugin loader and installer are implemented, but the target Wolf `Interface.xdat` still needs a real round-trip test with the installed p502 schema:

1. install the modern schema;
2. select the best matching external protocol, prioritizing p520 for Wolf/Varkas when available and testing p502 only when justified by the schema package;
3. open the target `Interface.xdat`;
4. confirm `AutomaticPlay`, `AutoHunt_All_Btn`, `YetiQuickSlotWnd`, `RelicSummonWnd` and Varkas-related windows;
5. save to a new file;
6. reopen the saved file;
7. validate it in the target client.

Only after that test should p502 be treated as confirmed for this exact client build.


## Inspect the bundled Aden package

The repository already contains `xdat_editor/xdat-aden.zip`. Use the read-only recursive inspector before assuming it is useful:

```powershell
powershell -ExecutionPolicy Bypass -File .\xdat_editor\tools\inspect-aden-package.ps1 .\xdat_editor\xdat-aden.zip
```

The script lists interesting entries and recursively inspects nested JAR/ZIP files for `*/XDAT.class` and `versions.csv`.


## Experimental p520 reconstruction

The branch now generates a `p520` schema automatically from `etoa5` during the Ant build and overlays only the confirmed Wolf-era differences.

Confirmed from the supplied `Interface.xdat`:

- shortcut block: 25 entries;
- top-level window count: 643;
- `DefaultProperty` contains one extra 32-bit field after `unk24` and before `tooltipType`;
- `Window.saveSize` from etoa5 is absent in the observed Wolf layout;
- after `resizeFrameDirection`, `drawerDirection` is read directly;
- when `drawerDirection == None`, the old three etoa5 placeholder ints are absent;
- `ownerWindow` follows;
- a structured variable-length modern Window block follows `ownerWindow`;
- the reconstructed tail aligns exactly through the children count for both `AbilityCategory` and child `AbilitySlot11`.

The modern Window block is variable-length because it contains an internal String. Unknown fields are preserved losslessly for reverse-engineering and round-trip safety.

The built-in Version menu now includes:

```text
Wolf / p520 (experimental)
```

The next validation step is to rebuild and open the supplied Wolf `Interface.xdat` with this schema. The first read failure offset will identify the next subclass/layout that differs from etoa5.
