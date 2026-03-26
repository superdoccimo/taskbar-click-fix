#Requires AutoHotkey v2.0
#SingleInstance Force

; Correction MVP for Windows 11 taskbar click issue.
; For short left-clicks on the taskbar, delay the button-up event slightly.

global MIN_HOLD_MS := 40
global TASKBAR_CLASSES := Map("Shell_TrayWnd", true, "Shell_SecondaryTrayWnd", true)
global gHook := 0
global gCb := 0
global gDownTick := 0
global gDownX := 0
global gDownY := 0

global gInjecting := false

StartHook()
OnExit(StopHook)
Persistent

StartHook() {
    global gHook, gCb
    gCb := CallbackCreate(LowLevelMouseProc, , 3)
    gHook := DllCall("user32\SetWindowsHookExW"
        , "Int", 14
        , "Ptr", gCb
        , "Ptr", DllCall("kernel32\GetModuleHandleW", "Ptr", 0, "Ptr")
        , "UInt", 0
        , "Ptr")
    if !gHook
        MsgBox "SetWindowsHookEx failed. A_LastError=" A_LastError
}

StopHook(*) {
    global gHook, gCb
    if gHook
        DllCall("user32\UnhookWindowsHookEx", "Ptr", gHook)
    if gCb
        CallbackFree(gCb)
}

GetRootWindowClassAt(x, y) {
    hwnd := DllCall("user32\WindowFromPoint", "Int64", (y << 32) | (x & 0xFFFFFFFF), "Ptr")
    if !hwnd
        return ""
    hRoot := DllCall("user32\GetAncestor", "Ptr", hwnd, "UInt", 2, "Ptr")
    if !hRoot
        hRoot := hwnd
    buf := Buffer(256 * 2, 0)
    n := DllCall("user32\GetClassNameW", "Ptr", hRoot, "Ptr", buf, "Int", 256, "Int")
    return (n > 0) ? StrGet(buf, n, "UTF-16") : ""
}

InjectLButtonUp(*) {
    global gInjecting
    gInjecting := true
    Click "Up"
    SetTimer(() => gInjecting := false, -50)
}

LowLevelMouseProc(nCode, wParam, lParam) {
    static WM_LBUTTONDOWN := 0x0201
    static WM_LBUTTONUP := 0x0202
    static LLMHF_INJECTED := 0x00000001

    if (nCode < 0)
        return DllCall("user32\CallNextHookEx", "Ptr", 0, "Int", nCode, "Ptr", wParam, "Ptr", lParam, "Ptr")

    x := NumGet(lParam, 0, "Int")
    y := NumGet(lParam, 4, "Int")
    flags := NumGet(lParam, 12, "UInt")
    injected := (flags & LLMHF_INJECTED) != 0

    global gInjecting, gDownTick, gDownX, gDownY, MIN_HOLD_MS, TASKBAR_CLASSES
    if injected || gInjecting
        return DllCall("user32\CallNextHookEx", "Ptr", 0, "Int", nCode, "Ptr", wParam, "Ptr", lParam, "Ptr")

    if (wParam = WM_LBUTTONDOWN) {
        gDownTick := A_TickCount
        gDownX := x
        gDownY := y
        return DllCall("user32\CallNextHookEx", "Ptr", 0, "Int", nCode, "Ptr", wParam, "Ptr", lParam, "Ptr")
    }

    if (wParam = WM_LBUTTONUP && gDownTick > 0) {
        duration := A_TickCount - gDownTick
        rootClass := GetRootWindowClassAt(x, y)
        gDownTick := 0
        if (duration < MIN_HOLD_MS && TASKBAR_CLASSES.Has(rootClass)) {
            SetTimer(InjectLButtonUp, -(MIN_HOLD_MS - duration))
            return 1
        }
    }

    return DllCall("user32\CallNextHookEx", "Ptr", 0, "Int", nCode, "Ptr", wParam, "Ptr", lParam, "Ptr")
}
