# Windows real-machine test plan

## Goal
Validate whether short taskbar clicks fail because the button-up happens too quickly or is effectively cancelled by pointer movement / shell timing.

## Environment metadata to collect
- Windows edition and build
- device model
- connection type
- Logi Options+ installed or not
- Windhawk / ExplorerPatcher installed or not
- whether another pointing device reproduces the issue

## Phase 1: observation
1. Run `ahk/taskbar_click_logger.ahk`
2. Perform 30 taskbar click attempts
3. Include both:
   - different app switch
   - same-app multi-window switch from taskbar thumbnails
4. Save `taskbar_click_log.csv`
5. Mark which attempts visibly failed

## Phase 2: correction
1. Stop logger script
2. Run `ahk/taskbar_click_fix_mvp.ahk`
3. Repeat the same 30 attempts
4. Record:
   - visible failures
   - subjective delay
   - any drag/selection side effects

## Success criteria
- fewer visible failures than observation pass
- no serious regression in normal clicking
- no obvious unwanted drag behavior on taskbar

## Tuning notes
If correction helps but feels weak:
- raise `MIN_HOLD_MS` from 40 to 50 or 60

If correction feels sticky or annoying:
- lower `MIN_HOLD_MS` from 40 to 30

## Next implementation targets after test
- exclude Start button / tray / notification area
- add optional CSV logging to correction mode
- add a tiny tray UI for enable/disable and threshold tuning
