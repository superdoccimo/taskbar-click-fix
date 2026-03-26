# MVP notes

## Observation MVP
- File: `ahk/taskbar_click_logger.ahk`
- Purpose: record click timing, movement, root class, foreground change

## Correction MVP
- File: `ahk/taskbar_click_fix_mvp.ahk`
- Strategy: if left-click up happens too quickly on taskbar root windows, swallow it and inject a delayed button-up
- Current scope: `Shell_TrayWnd` and `Shell_SecondaryTrayWnd`
- Current default: `MIN_HOLD_MS = 40`

## Known limitations
- No CSV logging in correction script yet
- No exclusion for start button / tray / notification area yet
- Uses AutoHotkey `Click "Up"` for injected release
- Not tested on real Windows machine yet
