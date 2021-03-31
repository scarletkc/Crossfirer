﻿#Include Crossfirer_Functions.ahk
Preset("控")
;OnExit("CloseOthers", -1)
;==================================================================================
global CTL_Service_On := False
CheckPermission()
;==================================================================================
Need_Help := False
CF_Title :=
Random_Move := False
global cnt := 0
global Game_Start_Hour := 0 ;客户端启动就计时
global Game_Begin_Min := 0
global Allowed_Hour := 4 ;默认单次游戏最多四小时
global Hour_Played := 0
global Hour_Left := Allowed_Hour - Hour_Played

If WinExist("ahk_class CrossFire")
{
    Gui, Helper: New, +LastFound +AlwaysOnTop -Caption +ToolWindow +MinSize -DPIScale, CTL ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
    Gui, Helper: Margin, 0, 0
    Gui, Helper: Color, 333333 ;#333333
    Gui, Helper: Font, S8 Q5 C00FF00, Microsoft YaHei ;#00FF00
    Gui, Helper: add, Text, hwndGui_8, ╔====使用==说明===╗`n     按~     =开关自火==`n     按2   ==手枪模式==`n     按3/4  =暂停模式==`n     按J    ==瞬狙模式==`n     按L   ==连发速点==`n     按Tab键 通用模式==`n================`n     鼠标中间键 右键连点`n     鼠标前进键 炼狱连刺`n     鼠标后退键 左键连点`n     按W和F ==基础鬼跳`n     按W和Alt =空中跳蹲`n     按W放LCtrl bug小道`n     按S和F  ==跳蹲上墙`n     按W和C==前跳跳蹲`n     按S和C ==后跳跳蹲`n     按Z和C ==六级跳箱`n     按?或/ ==随机动作`n     按<或, ==左旋转跳`n     按>或. ==右旋转跳`n================`n     小键盘123 更换射速`n     小键盘0     关闭压枪`n     小键盘+ 更换压枪度`n     小键盘Del. 点射压枪`n================`n     按H  =运行一键限速`n     按-   =重新加载脚本`n     按=      开关E键快反`n     大写锁定 最小化窗口`n     回车键 开关所有按键`n     右Alt   恢复所有按键`n╚====使用==说明===╝
    GuiControlGet, P8, Pos, %Gui_8%
    global P8H ;*= (A_ScreenDPI / 96)
    WinSet, TransColor, 333333 255 ;#333333
    WinSet, ExStyle, +0x20 +0x8; 鼠标穿透以及最顶端

    Gui, Hint: New, +LastFound +AlwaysOnTop -Caption +ToolWindow +MinSize -DPIScale, CTL ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
    Gui, Hint: Margin, 0, 0
    Gui, Hint: Color, 333333 ;#333333
    Gui, Hint: Font, S8 Q5, Microsoft YaHei ;#00FF00
    Gui, Hint: add, Text, hwndGui_9 c00FF00, 按`n右`n c`n t`n r`n l`n键`n开`n关`n帮`n助
    GuiControlGet, P9, Pos, %Gui_9%
    global P9H ;*= (A_ScreenDPI / 96)
    WinSet, TransColor, 333333 255 ;#333333
    WinSet, ExStyle, +0x20 +0x8; 鼠标穿透以及最顶端

    Gui, Ran: New, +LastFound +AlwaysOnTop -Caption +ToolWindow +MinSize -DPIScale, CTL ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
    Gui, Ran: Margin, 0, 0
    Gui, Ran: Color, 333333 ;#333333
    Gui, Ran: Font, s10 Q5, Microsoft YaHei ;#00FF00
    Gui, Ran: add, Text, hwndGui_11 c00FF00 vRan_Moving, 随机动作
    GuiControlGet, P11, Pos, %Gui_11%
    global P11H, P11W
    WinSet, TransColor, 333333 255 ;#333333
    WinSet, ExStyle, +0x20 +0x8; 鼠标穿透以及最顶端

    Gui, T_Hour: New, +LastFound +AlwaysOnTop -Caption +ToolWindow +MinSize -DPIScale, CTL ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
    Gui, T_Hour: Margin, 0, 0
    Gui, T_Hour: Color, 333333 ;#333333
    Gui, T_Hour: Font, s8 Q5, Microsoft YaHei ;#00FF00
    Gui, T_Hour: add, Text, hwndGui_12 c00FF00 vT_Left, 剩余%Hour_Left%小时
    GuiControlGet, P12, Pos, %Gui_12%
    global P12H, P12W
    WinSet, TransColor, 333333 255 ;#333333
    WinSet, ExStyle, +0x20 +0x8; 鼠标穿透以及最顶端

    SetGuiPosition(XGui9, YGui9, "V", 0, -P8H // 2)
    SetGuiPosition(XGui10, YGui10, "V", 0, -P9H // 2)
    SetGuiPosition(XGui11, YGui11, "L", 0, -P11H)
    SetGuiPosition(XGui12, YGui12, "_", -P12W // 2, -P12H)
    Gui, Hint: Show, x%XGui10% y%YGui10% NA
    Gui, Ran: Show, x%XGui11% y%YGui11% NA
    Gui, Helper: Show, Hide
    Gui, T_Hour: Show, x%XGui12% y%YGui12% NA

    WinGetTitle, CF_Title, ahk_class CrossFire
    global Xl := 0, Yl := 0, Wl := 1600, Hl := 900
    CheckPosition(Xl, Yl, Wl, Hl, "CrossFire")
    WinMinimize, ahk_class ConsoleWindowClass
    SetTimer, UpdateGui, 500
    DPI_Initial := A_ScreenDPI

    Game_Start_Hour := A_Hour
    Game_Begin_Min := A_Min
    CTL_Service_On := True
} 
;==================================================================================
~*-::
    WinClose, ahk_class ConsoleWindowClass
    Try
        Run, .\请低调使用.bat
    Catch
        Run, .\低调使用.exe
ExitApp

#If CTL_Service_On

~*CapsLock Up:: ;minimize window and replace origin use
    If WinActive("ahk_class CrossFire")
    {
        WinMinimize, ahk_class CrossFire
        HyperSleep(100)
        CoordMode, Mouse, Screen
        MouseMove, A_ScreenWidth // 2, A_ScreenHeight // 2 ;The middle of screen
    }
    Else
        WinActivate, ahk_class CrossFire ;激活该窗口
Return

#If WinActive("ahk_class CrossFire") && CTL_Service_On ;以下的热键需要相应条件才能激活

~*Enter Up::
    Suspend, Off ;恢复热键,首行为挂起关闭才有效
    If Is_Chatting()
        Suspend, On 
    Suspended()
Return

~*RAlt::
    Suspend, Off ;恢复热键,双保险
    Suspended()
    SetGuiPosition(XGui9, YGui9, "V", 0, -P8H // 2)
    SetGuiPosition(XGui10, YGui10, "V", 0, -P9H // 2)
    SetGuiPosition(XGui11, YGui11, "L", 0, -P11H)
    SetGuiPosition(XGui12, YGui12, "_", -P12W // 2, -P12H)
    Gui, Ran: Show, x%XGui11% y%YGui11% NA
    ShowHelp(Need_Help, XGui9, YGui9, "Helper", XGui10, YGui10, "Hint", 0)
    Gui, T_Hour: Show, x%XGui12% y%YGui12% NA
Return

~*Up::
    Allowed_Hour += 1
Return

~*Down::
    Allowed_Hour -= 1
Return

~*RCtrl::
    ShowHelp(Need_Help, XGui9, YGui9, "Helper", XGui10, YGui10, "Hint", 1)
Return

~*?::
~*/::
    Random_Move := !Random_Move
    If Random_Move
    {
        GuiControl, Ran: +c00FFFF +Redraw, Ran_Moving ;#00FFFF
        cnt := 0
    }
    Else
    {
        If Mod(cnt, 2)
            press_key("Shift", 30, 30)
        cnt := 0
        GuiControl, Ran: +c00FF00 +Redraw, Ran_Moving ;#00FF00
    }
Return
;==================================================================================
UpdateGui() ;精度0.5s
{
    global DPI_Initial, CF_Title, Random_Move, XGui12, YGui12
    CheckPosition(Xl, Yl, Wl, Hl, "CrossFire")

    Hour_Played := (A_Hour - Game_Start_Hour) >= 0 ? (A_Hour - Game_Start_Hour) : (A_Hour + 24 - Game_Start_Hour)
    If (A_Min - Game_Begin_Min) < 0
    {
        Hour_Played -= 1
    }
    Hour_Left := Allowed_Hour - Hour_Played
    Hour_Text := "剩余" . Hour_Left . "小时"
    UpdateText("T_Hour", "T_Left", Hour_Text, XGui12, YGui12)
    If Hour_Left <= 0
        WinClose, ahk_class CrossFire

    If !InStr(A_ScreenDPI, DPI_Initial)
        MsgBox, 262144, 提示/Hint, 请按"-"键重新加载脚本`nPlease restart by pressing "-" key
    If !WinExist("ahk_class CrossFire")
    {
        WinClose, ahk_class ConsoleWindowClass
        If ProcessExist("GameLoader.exe")
        {
            If A_IsCompiled && A_IsAdmin
            {
                Runwait, %comspec% /c taskkill /IM GameLoader.exe /F, , Hide
                Runwait, %comspec% /c taskkill /IM TQMCenter.exe /F, , Hide
                Runwait, %comspec% /c taskkill /IM TenioDL.exe /F, , Hide
                Runwait, %comspec% /c taskkill /IM feedback.exe /F, , Hide
                Runwait, %comspec% /c taskkill /IM CrossProxy.exe /F, , Hide
            }
            Else
                Run, *RunAs .\关闭TX残留进程.bat, , Hide
        }
        CloseOthers()
        ExitApp
    }
    Else If !Not_In_Game(CF_Title)
    {
        Send, {Blind}{vk87 Up} ;F24 key
        Random, move_it, 1, 9
        Random, do_range, 3, 6 ;随机命中几率
        If Random_Move && move_it = 3
            press_key("1", 30, 30)
        If Random_Move && WinActive("ahk_class CrossFire") && move_it > do_range
        {
            Random, ran_move, -3, 3 ;随机鼠标左右和自身移动
            Random, ran_act, -3, 3 ;随机鼠标上下
            If !GetKeyState("vk86") ;当不在无尽挂机中
            {
                MouseMove, Xl + Wl // 2, Yl + Hl // 2
                mouseXY(ran_move * 50, ran_act * 5)
            }

            Switch ran_move
            {
                Case -3: press_key("w", 150, 30)
                Case -2: press_key("s", 150, 30)
                Case -1: press_key("a", 150, 30)
                Case 0: press_key("LCtrl", 150, 30)
                Case 1: press_key("d", 150, 30)
                Case 2: press_key("Space", 150, 30)
                Case 3: press_key("Shift", 30, 60), press_key("Shift", 30, 60), cnt += 1
            }
        }
    }
    Else If Not_In_Game(CF_Title)
        Send, {Blind}{vk87 Down} ;F24 key
}
;==================================================================================
;通过按下快捷键显示/隐藏提示
ShowHelp(ByRef Need_Help, XGui1, YGui1, Gui_Number1, XGui2, YGui2, Gui_Number2, Changer)
{
    If Changer = 1
        Need_Help := !Need_Help
    If Need_Help
    {
        Gui, %Gui_Number1%: Show, x%XGui1% y%YGui1% NA
        Gui, %Gui_Number2%: Show, Hide
    }
    Else
    {
        Gui, %Gui_Number1%: Show, Hide
        Gui, %Gui_Number2%: Show, x%XGui2% y%YGui2% NA
    }
}
;==================================================================================
;控制关闭其他脚本方式
CloseOthers()
{
    DetectHiddenWindows, On
    IniRead, PID1, 助手数据.ini, 一键限网, PID
    IniRead, PID2, 助手数据.ini, 基础压枪, PID
    IniRead, PID3, 助手数据.ini, 基础身法, PID
    IniRead, PID4, 助手数据.ini, 战斗猎手, PID
    IniRead, PID5, 助手数据.ini, 自动开火, PID
    IniRead, PID6, 助手数据.ini, 连点助手, PID
    IniRead, PID7, 助手数据.ini, 无尽挂机, PID
    process_count := 8
    Time_Count := A_TickCount
    Loop
    {
        HyperSleep(30)
        Current_Index := Mod(A_Index, 7) + 1
        Current_Pid := PID%Current_Index%
        If PID%Current_Index% != ERROR
            PostMessage, 0x0111, 65405, , , ahk_pid %Current_Pid%
        WinGet, process_count, Count, ahk_class AutoHotkey
        Time_Used := A_TickCount - Time_Count
    } Until process_count <= 1 || Time_Used > 5000
    FileDelete, 助手数据.ini ;删除脚本进程数据

    Title_Blank := 0
    Loop ;, 10
    {
        PostMessage("Listening", 125638)
        WinGetTitle, Gui_Title, ahk_class AutoHotkeyGUI
        ;MsgBox, , , %Gui_Title%
        If StrLen(Gui_Title) < 4
            Title_Blank += 1
        HyperSleep(30) ;just for stability
    } Until Title_Blank > 4
}
;==================================================================================