# taskbar-click-fix

Windows 11 taskbar click fix tool (MVP).

## Current status
- Observation MVP implemented
- Correction MVP implemented
- Next step: Windows real-machine testing and result tuning

## Files
- `docs/research.md` — deep research report
- `docs/mvp-notes.md` — current MVP scope and limitations
- `docs/windows-test-plan.md` — Windows real-machine test plan
- `docs/quickstart-ja.md` — Japanese quickstart for real-machine testing
- `docs/test-result-template.md` — template for reporting Windows real-machine results
- `docs/telegram-test-reply-template-ja.md` — Japanese reply template for sending test results back over Telegram
- `ahk/taskbar_click_logger.ahk` — AutoHotkey v2 observation logger MVP
- `ahk/taskbar_click_fix_mvp.ahk` — AutoHotkey v2 correction MVP

## Observation MVP
`ahk/taskbar_click_logger.ahk` records:
- left button down/up duration
- pointer movement during click
- root window class at click location
- whether the foreground window changed

Output file:
- `taskbar_click_log.csv`

## Correction MVP
`ahk/taskbar_click_fix_mvp.ahk` does this:
- watches left button down/up with `WH_MOUSE_LL`
- detects taskbar root windows (`Shell_TrayWnd`, `Shell_SecondaryTrayWnd`)
- if button-up happens too quickly, it swallows the original up event
- injects a delayed button-up so the effective hold reaches `MIN_HOLD_MS`

Current default:
- `MIN_HOLD_MS = 40`

## How to run on Windows 11
1. Install AutoHotkey v2
2. Clone or copy this repository to the Windows machine
3. Run one of these scripts:
   - Observation only: `ahk/taskbar_click_logger.ahk`
   - Correction MVP: `ahk/taskbar_click_fix_mvp.ahk`
4. Reproduce the taskbar click issue
5. If using the logger, inspect `taskbar_click_log.csv`

## Real-machine test checklist
### Observation pass
- Run `ahk/taskbar_click_logger.ahk`
- Try at least 20-30 short taskbar clicks
- Test both:
  - switching to another app from the taskbar
  - selecting another window of the same app from taskbar thumbnails
- Save `taskbar_click_log.csv`

### Correction pass
- Stop the logger
- Run `ahk/taskbar_click_fix_mvp.ahk`
- Repeat the same taskbar switching actions
- Compare:
  - failure rate before/after
  - whether clicks feel delayed
  - whether drag behavior becomes weird

## What to record after testing
- Windows 11 build number
- device type (mouse / trackball)
- connection type (Bluetooth / Bolt / other)
- whether Logi Options+ is installed
- whether taskbar tools like Windhawk / ExplorerPatcher are installed
- whether another mouse reproduces the issue
- sample CSV rows from the observation pass
- whether `MIN_HOLD_MS = 40` feels too small / too large

## Known limitations
- Correction MVP has no exclusion for Start button / tray / notification area yet
- No automated success detection yet
- No packaged Windows release yet
- Not validated on a real Windows machine yet

## License
MIT
