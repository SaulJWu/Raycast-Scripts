#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Calculate & Paste Price
# @raycast.mode silent
# @raycast.packageName Pricing Automation
# @raycast.icon $
# @raycast.shortcut control+option+p

-- 辅助函数：去除字符串两端的空格
on trim(inputString)
	set AppleScript's text item delimiters to {" "}
	set textItems to text items of inputString
	set AppleScript's text item delimiters to ""
	return textItems as string
end trim

on run
	-- 保存当前活动应用，以便对话框关闭后恢复焦点
	set frontApp to ""
	try
		tell application "System Events"
			set frontApp to name of first application process whose frontmost is true
		end tell
	end try
	
	-- 1. 请求用户输入原始价格
	try
		set originalPriceStr to text returned of (display dialog "请输入原始价格 (USD):" default answer "" buttons {"取消", "确定"} default button "确定")
		
		-- 验证输入不为空
		if originalPriceStr is "" then
			display notification "请输入价格，不能为空。" with title "价格计算失败"
			return
		end if
		
		-- 去除空格
		set originalPriceStr to my trim(originalPriceStr)
		
	on error number -128
		-- 用户点击了"取消"
		return
	end try
	
	-- 2. 转换为数字并执行计算
	try
		set originalPrice to (originalPriceStr as number)
		
		-- 验证价格大于0
		if originalPrice ≤ 0 then
			display notification "请输入大于0的价格。" with title "价格计算失败"
			return
		end if
		
		-- 计算 80% 的折扣价
		set finalPrice to originalPrice * 0.8
		
		-- 将结果取整到个位（向上取整）
		set roundedPrice to round finalPrice rounding up
		
	on error errorMessage
		-- 如果输入不是有效数字
		display notification "请输入有效数字。错误: " & errorMessage with title "价格计算失败"
		return
	end try
	
	-- 3. 构建完整的文本字符串
	set outputText to "$" & originalPriceStr & " a BCV, pero si cancela en divisas de le aplica un descuento del 20% y le queda $" & (roundedPrice as text) & " en divisas"
	
	-- 4. 将最终文本复制到剪贴板
	set the clipboard to outputText
	
	-- 5. 恢复焦点到原来的应用并粘贴文本
	try
		-- 重新激活原来的应用
		if frontApp is not "" then
			tell application frontApp
				activate
			end tell
		end if
		
		-- 粘贴文本到当前焦点
		tell application "System Events"
			-- 模拟 Command-V (粘贴)
			keystroke "v" using {command down}
		end tell
		
	on error errorMessage
		display notification "粘贴失败: " & errorMessage with title "错误"
	end try
end run