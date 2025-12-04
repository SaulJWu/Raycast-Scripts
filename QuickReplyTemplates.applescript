#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Quick Reply Templates
# @raycast.mode silent
# @raycast.packageName Quick Replies
# @raycast.icon 💬
# @raycast.shortcut control+option+r

on run
	-- 保存当前活动应用，以便对话框关闭后恢复焦点
	set frontApp to ""
	try
		tell application "System Events"
			set frontApp to name of first application process whose frontmost is true
		end tell
	end try
	
	-- 定义模板标题列表（用于对话框展示）
	set templateNames to {"1️⃣ TIENDA MOTO ELITE CATIA", "2️⃣ 问候模板", "3️⃣ 感谢模板", "4️⃣ 确认模板", "5️⃣ 结束对话模板", "6️⃣ 自定义模板"}
	
	-- 定义每个模板的具体内容（支持 Emoji 和换行）
	set template1 to "TIENDA MOTO ELITE CATIA" & return & return & "Horario:" & return & return & "Dia: Lunes a Sabado" & return & return & "Hora: 8:30am a 5:30 pm" & return & return & "Whatsapp: 04242838297" & return & return & "Dirección: A 2 Cuadras de la Estación del Metro Pérez Bonalde, Calle México de Catia, Frente al Colegio Juan Antonio Pérez Bonalde" & return & return & "https://maps.app.goo.gl/Mto6487FwnZkyA8y5?g_st=ic"
	set template2 to "👋 您好！" & return & return & "感谢您的咨询，很高兴为您服务。" & return & return & "有什么我可以帮助您的吗？"
	set template3 to "🙏 非常感谢您的支持！" & return & return & "我们会尽快处理您的问题。" & return & return & "如有任何疑问，请随时联系我们。"
	set template4 to "✅ 已收到您的信息" & return & return & "我们会尽快为您处理。" & return & return & "感谢您的耐心等待！"
	set template5 to "感谢您的咨询！😊" & return & return & "如果还有其他问题，随时欢迎联系我们。" & return & return & "祝您生活愉快！"
	set template6 to "💬 这是一个自定义模板" & return & return & "您可以在这里添加任何内容，包括：" & return & "- 文本" & return & "- Emoji 表情 😀 🎉 ✨" & return & "- 链接和联系方式" & return & return & "完全支持自定义！"
	
	set templateContents to {template1, template2, template3, template4, template5, template6}
	
	-- 构建模板选择提示文本，清晰显示每个模板的标题
	set promptText to "═══════════════════════════════════" & return
	set promptText to promptText & "   快速回复模板选择" & return
	set promptText to promptText & "═══════════════════════════════════" & return & return
	set promptText to promptText & "请选择要使用的回复模板：" & return & return
	
	repeat with i from 1 to count of templateNames
		set promptText to promptText & "  " & i & ". " & (item i of templateNames) & return
	end repeat
	
	set promptText to promptText & return & "═══════════════════════════════════" & return
	set promptText to promptText & "请输入数字 (1-" & (count of templateNames) & ") 选择模板："
	
	-- 让用户输入数字选择模板
	try
		set userInput to text returned of (display dialog promptText default answer "" buttons {"取消", "确定"} default button "确定" with title "快速回复模板选择")
		
		-- 验证输入不为空
		if userInput is "" then
			display notification "请输入数字 1-6 来选择模板。" with title "快速回复"
			return
		end if
		
		-- 简单处理：直接使用用户输入的文本转换为数字（如果包含空格会自动报错提示）
		set userInput to userInput
		set selectedIndex to userInput as number
		
		-- 验证数字范围
		if selectedIndex < 1 or selectedIndex > (count of templateNames) then
			display notification "请输入 1 到 " & (count of templateNames) & " 之间的数字。" with title "快速回复"
			return
		end if
		
	on error number -128
		-- 用户点击了"取消"
		return
	end try
	
	-- 获取选中的模板内容和名称
	set selectedContent to item selectedIndex of templateContents
	set selectedName to item selectedIndex of templateNames
	
	-- 将选中的模板内容复制到剪贴板
	set the clipboard to selectedContent
	
	-- 恢复焦点到原来的应用并自动粘贴
	try
		-- 重新激活原来的应用
		if frontApp is not "" then
			tell application frontApp
				activate
			end tell
		end if
		
		-- 增加延迟，确保应用激活和剪贴板操作完成
		delay 0.2
		
		-- 自动粘贴到当前焦点
		tell application "System Events"
			-- 模拟 Command-V (粘贴)
			keystroke "v" using {command down}
		end tell
		
		-- 显示成功通知
		display notification "已粘贴模板: " & selectedName with title "快速回复"
		
	on error errorMessage
		display notification "粘贴失败: " & errorMessage with title "错误"
	end try
end run

-- 下面本来预留了辅助函数位置，目前逻辑已经足够简单，不需要额外函数
