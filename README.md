# taskbar-click-fix

Windows 11 taskbar click fix tool (MVP).

## Current status
- Observation MVP started
- Goal: log taskbar click timing/movement before adding any correction

## Files
- `docs/research.md` — deep research report
- `ahk/taskbar_click_logger.ahk` — AutoHotkey v2 observation logger MVP

## Observation MVP
This script records:
- left button down/up duration
- pointer movement during click
- root window class at click location
- whether the foreground window changed

Output file:
- `taskbar_click_log.csv`

## Run
1. Install AutoHotkey v2 on Windows 11
2. Run `ahk/taskbar_click_logger.ahk`
3. Reproduce the taskbar click issue
4. Inspect `taskbar_click_log.csv`

## License
MIT
