#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================
; 折后价 -> 原价（原价 = 折后价 * 2）
; 参考仓库里的 ReverseCalculatePrice.applescript：弹窗输入 -> 计算 -> 复制 -> 可选粘贴
; =========================

; --- 可配置项（按你的习惯改这里就行） ---
HOTKEY := "^!d"            ; 默认快捷键：Ctrl + Alt + D
AUTO_PASTE := true         ; true=自动粘贴（Ctrl+V），false=只复制不粘贴
ROUND_DECIMALS := 2        ; 保留小数位（用于显示/文本），常用 0/2
RESTORE_CLIPBOARD := true  ; true=粘贴后恢复原剪贴板内容

; --- 注册热键 ---
Hotkey(HOTKEY, CalcAndPaste)

CalcAndPaste(*) {
    ; 1) 输入折后价
    ib := InputBox("请输入折后价（USD），例如：8 或 8.5", "输入折后价", "w360 h140")
    if (ib.Result != "OK")
        return

    raw := NormalizeNumberText(ib.Value)
    if (raw = "") {
        MsgBox("你没有输入数字。", "价格计算失败", "Iconx")
        return
    }
    if !IsNumberText(raw) {
        MsgBox("请输入有效数字（只要数字和小数点）。你输入的是：" raw, "价格计算失败", "Iconx")
        return
    }

    discounted := raw + 0
    if (discounted <= 0) {
        MsgBox("请输入大于 0 的价格。", "价格计算失败", "Iconx")
        return
    }

    ; 2) 计算：原价 = 折后价 * 2（相当于 50% 折扣）
    original := discounted * 2

    ; 3) 构建输出文本（与仓库 AppleScript 的风格一致）
    originalStr := FormatNumber(original, ROUND_DECIMALS)
    discountedStr := FormatNumber(discounted, ROUND_DECIMALS)
    outputText := "$" originalStr " a BCV, pero si cancela en divisas de le aplica un descuento del 50% y le queda $" discountedStr " en divisas"

    ; 4) 复制到剪贴板，并可选粘贴
    oldClip := A_Clipboard
    A_Clipboard := outputText
    if !ClipWait(0.5) {
        MsgBox("复制到剪贴板失败，请重试。", "错误", "Iconx")
        return
    }

    if (AUTO_PASTE) {
        Send("^v")
        Sleep(80)
    }

    if (RESTORE_CLIPBOARD)
        A_Clipboard := oldClip
}

NormalizeNumberText(s) {
    s := Trim(s)
    s := StrReplace(s, "$")
    s := StrReplace(s, " ", "")
    s := StrReplace(s, ",", ".")  ; 允许用户输入 8,5
    return s
}

IsNumberText(s) {
    ; 允许：123 / 123.45
    return RegExMatch(s, "^\d+(\.\d+)?$")
}

FormatNumber(n, decimals := 2) {
    ; 保留小数，然后去掉末尾多余的 0 和 .
    s := Round(n, decimals) ""
    if InStr(s, ".") {
        s := RegExReplace(s, "0+$")
        s := RegExReplace(s, "\.$")
    }
    return s
}


