# Wolf modern XDAT research

This branch tracks support for the modern Lineage II interface files used by the Wolf project.

## Current status

The upstream editor bundled in this repository exposes schemas only through `etoa5` (Salvation).
Modern interface files with Varkas, Relic and Automatic Play systems are newer and must **not** be saved with the Salvation schema.

The current working hypothesis is that the sample files belong to the **p502-family XDAT serialization** used around the 502/509-era interface. This is a heuristic until a round-trip compatible schema is implemented and verified.

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

## Local inspector

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\xdat_editor\tools\inspect-modern-xdat.ps1 "D:\path\to\Interface.xdat"
```

The inspector is read-only and reports file size, SHA-256, modern feature markers and their first byte offsets.

## Next engineering step

Reconstruct/import the exact modern schema (starting with `DefaultProperty`, `Window`, root `XDAT` and every registered child control), then add the new protocol to `versions.csv`.
