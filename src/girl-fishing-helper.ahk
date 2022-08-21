#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
#SingleInstance Force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;; resource variable
ACTIVE_LABEL = 스타크래프트 활성화
INACTIVE_LABEL = 스타크래프트 비활성화
ACTIVE_COLOR = 0ccf02
INACTIVE_COLOR = a1a1a1


;; hotkey list
DoubleLeftHotkey = /
LeftHotkey = .
CenterHotkey = ,
RightHotkey = x
DoubleRightHotkey = z


;; app variable
LoopDelay := 50

ButtonYRatio := 0.9506

DoubleLeftXRatio := 0.3687
DoubleLeftYRatio := ButtonYRatio
LeftXRatio := 0.4320
LeftYRatio := ButtonYRatio
CenterXRatio := 0.495703125
CenterYRatio := ButtonYRatio
RightXRatio := 0.562890625
RightYRatio := ButtonYRatio
DoubleRightXRatio := 0.63203125
DoubleRightYRatio := ButtonYRatio


;; system variable
TargetClass = ahk_class StarCraft II

Active := true
TargetWinActive := true

ActiveLabel = %ACTIVE_LABEL%


;; run script
gosub InitGui
BindHotkey(DoubleLeftHotkey, LeftHotkey, CenterHotkey, RightHotkey, DoubleRightHotkey)
gosub ObserveActive
return


InitGui:
    gui, add, text, vActiveLabel w1000

    gui, add, picture, xm y+10 w100 h80, %A_ScriptDir%\assets\double-left.png
    gui, add, picture, x+0 yp+0 w100 h80, %A_ScriptDir%\assets\left.png
    gui, add, picture, x+0 yp+0 w100 h80, %A_ScriptDir%\assets\center.png
    gui, add, picture, x+0 yp+0 w100 h80, %A_ScriptDir%\assets\right.png
    gui, add, picture, x+0 yp+0 w100 h80, %A_ScriptDir%\assets\double-right.png

    Gui Add, Hotkey, vDoubleLeftHotkey xm y+2 w100 h20, %DoubleLeftHotkey%
    Gui Add, Hotkey, vLeftHotkey x+0 yp+0 w100 h20, %LeftHotkey%
    Gui Add, Hotkey, vCenterHotkey x+0 yp+0 w100 h20, %CenterHotkey%
    Gui Add, Hotkey, vRightHotkey x+0 yp+0 w100 h20, %RightHotkey%
    Gui Add, Hotkey, vDoubleRightHotkey x+0 yp+0 w100 h20, %DoubleRightHotkey%

    gui, add, button, vSubmitButton gSubmit xm y+10 center, 적용
    GuiControl, Focus, SubmitButton
    gui, add, text, vDebugText w1000
    Gui, Show, w520 h240
    return


Debug:
    Some = y
    state := GetKeyState(Some)
    msgbox, %Some% state is %state%
    return


Submit:
    ToggleHotkey("off", DoubleLeftHotkey, LeftHotkey, CenterHotkey, RightHotkey, DoubleRightHotkey)
    gui, submit, nohide
    BindHotkey(DoubleLeftHotkey, LeftHotkey, CenterHotkey, RightHotkey, DoubleRightHotkey)
    return


GuiClose:
    ExitApp


ObserveActive:
    loop {
        TargetWinActive := WinActive(TargetClass)
        if (TargetWinActive) {
            GuiControl,, ActiveLabel, %ACTIVE_LABEL%
            Gui, Font, c%ACTIVE_COLOR%
            GuiControl, Font, ActiveLabel
            ToggleHotkey("on", DoubleLeftHotkey, LeftHotkey, CenterHotkey, RightHotkey, DoubleRightHotkey)
            WinWaitNotActive, %TargetClass%
        } else {
            GuiControl,, ActiveLabel, %INACTIVE_LABEL%
            Gui, Font, c%INACTIVE_COLOR%
            GuiControl, Font, ActiveLabel
            ToggleHotkey("off", DoubleLeftHotkey, LeftHotkey, CenterHotkey, RightHotkey, DoubleRightHotkey)
            WinWaitActive, %TargetClass%
        }
    }
    return


BindHotkey(DoubleLeftHotkey, LeftHotkey, CenterHotkey, RightHotkey, DoubleRightHotkey) {
    Hotkey, IfWinActive, % TargetClass
    hotkey, %DoubleLeftHotkey%, DoDoubleLeft
    hotkey, %LeftHotkey%, DoLeft
    hotkey, %CenterHotkey%, DoCenter
    hotkey, %RightHotkey%, DoRight
    hotkey, %DoubleRightHotkey%, DoDoubleRight
}


ToggleHotkey(State, DoubleLeftHotkey, LeftHotkey, CenterHotkey, RightHotkey, DoubleRightHotkey) {
    hotkey, %DoubleLeftHotkey%, %State%
    hotkey, %LeftHotkey%, %State%
    hotkey, %CenterHotkey%, %State%
    hotkey, %RightHotkey%, %State%
    hotkey, %DoubleRightHotkey%, %State%
}


ClickWhileKeyStroke(MouseXRatio, MouseYRatio, Key) {
    global
    WinGetPos,,, WindowWidth, WindowHeight, %TargetClass%
    MouseXPos := WindowWidth * MouseXRatio
    MouseYPos := WindowHeight * MouseYRatio
    GuiControl,, DebugText, 마우스 위치 (%MouseXPos%, %MouseYPos%)
    Loop {
        if (!TargetWinActive or !Active or !GetKeyState(key)) {
            return
        }
        MouseClick,, %MouseXPos%, %MouseYPos%
        Sleep, %LoopDelay%
    }
}


DoDoubleLeft:
    ClickWhileKeyStroke(DoubleLeftXRatio, DoubleLeftYRatio, DoubleLeftHotkey)
    return


DoLeft:
    ClickWhileKeyStroke(LeftXRatio, LeftYRatio, LeftHotkey)
    return


DoCenter:
    ClickWhileKeyStroke(CenterXRatio, CenterYRatio, CenterHotkey)
    return


DoRight:
    ClickWhileKeyStroke(RightXRatio, RightYRatio, RightHotkey)
    return


DoDoubleRight:
    ClickWhileKeyStroke(DoubleRightXRatio, DoubleRightYRatio, DoubleRightHotkey)
    return