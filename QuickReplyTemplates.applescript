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
	
	-- 从 templates 子目录加载所有模板
	set templateData to my loadAllTemplates()
	set templateNames to templateNames of templateData
	set templateContents to templateContents of templateData
	
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
			display notification "请输入数字 1-" & (count of templateNames) & " 来选择模板。" with title "快速回复"
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

-- 辅助函数：从 templates 子目录加载所有模板
-- 返回：包含 templateNames 和 templateContents 的记录
on loadAllTemplates()
	-- 获取脚本所在目录的 POSIX 路径
	try
		set scriptPath to path to me
		set scriptFolder to (POSIX path of (scriptPath as alias))
		-- 提取目录路径（去掉文件名）
		set scriptFolder to (do shell script "dirname " & quoted form of scriptFolder)
	on error
		-- 如果获取失败，使用当前工作目录
		set scriptFolder to (do shell script "pwd")
	end try
	
	-- templates 子目录路径
	set templatesFolder to scriptFolder & "templates/"
	
	set templateNames to {}
	set templateContents to {}
	
	-- 尝试扫描 templates 目录中的所有 .txt 文件
	try
		-- 获取所有 .txt 文件
		set templateFiles to paragraphs of (do shell script "ls -1 " & quoted form of templatesFolder & "*.txt 2>/dev/null | sort")
		
		repeat with templateFile in templateFiles
			if templateFile is not "" then
				-- 提取文件名（去掉路径和扩展名）
				set fileName to templateFile
				set AppleScript's text item delimiters to "/"
				set fileNameParts to text items of fileName
				set fileName to last item of fileNameParts
				set AppleScript's text item delimiters to "."
				set fileNameParts to text items of fileName
				set templateName to first item of fileNameParts
				set AppleScript's text item delimiters to ""
				
				-- 读取文件内容
				try
					set fileContent to (read POSIX file templateFile)
					if fileContent is not "" then
						set end of templateNames to templateName
						set end of templateContents to fileContent
					end if
				on error
					-- 读取失败，跳过此文件
				end try
			end if
		end repeat
	on error
		-- 目录不存在或读取失败，使用默认模板
		set templateNames to {"1️⃣ TIENDA MOTO ELITE CATIA", "2️⃣ 问候模板", "3️⃣ 感谢模板", "4️⃣ 确认模板", "5️⃣ 结束对话模板", "6️⃣ 自定义模板"}
		set templateContents to {¬
			"TIENDA MOTO ELITE CATIA" & return & return & "Horario:" & return & return & "Dia: Lunes a Sabado" & return & return & "Hora: 8:30am a 5:30 pm" & return & return & "Whatsapp: 04242838297" & return & return & "Dirección: A 2 Cuadras de la Estación del Metro Pérez Bonalde, Calle México de Catia, Frente al Colegio Juan Antonio Pérez Bonalde" & return & return & "https://maps.app.goo.gl/Mto6487FwnZkyA8y5?g_st=ic", ¬
			"👋 您好！" & return & return & "感谢您的咨询，很高兴为您服务。" & return & return & "有什么我可以帮助您的吗？", ¬
			"🙏 非常感谢您的支持！" & return & return & "我们会尽快处理您的问题。" & return & return & "如有任何疑问，请随时联系我们。", ¬
			"✅ 已收到您的信息" & return & return & "我们会尽快为您处理。" & return & return & "感谢您的耐心等待！", ¬
			"感谢您的咨询！😊" & return & return & "如果还有其他问题，随时欢迎联系我们。" & return & return & "祝您生活愉快！", ¬
			"💬 这是一个自定义模板" & return & return & "您可以在 templates/ 目录中创建 .txt 文件来自定义模板。" & return & return & "文件名将作为模板标题显示。" & return & return & "支持的内容包括：" & return & "- 文本" & return & "- Emoji 表情 😀 🎉 ✨" & return & "- 链接和联系方式" & return & "- 多行文本"}
	end try
	
	-- 如果没有找到任何模板，使用默认模板
	if (count of templateNames) is 0 then
		set templateNames to {"1️⃣ TIENDA MOTO ELITE CATIA", "2️⃣ 问候模板", "3️⃣ 感谢模板", "4️⃣ 确认模板", "5️⃣ 结束对话模板", "6️⃣ 自定义模板"}
		set templateContents to {¬
			"TIENDA MOTO ELITE CATIA" & return & return & "Horario:" & return & return & "Dia: Lunes a Sabado" & return & return & "Hora: 8:30am a 5:30 pm" & return & return & "Whatsapp: 04242838297" & return & return & "Dirección: A 2 Cuadras de la Estación del Metro Pérez Bonalde, Calle México de Catia, Frente al Colegio Juan Antonio Pérez Bonalde" & return & return & "https://maps.app.goo.gl/Mto6487FwnZkyA8y5?g_st=ic", ¬
			"👋 您好！" & return & return & "感谢您的咨询，很高兴为您服务。" & return & return & "有什么我可以帮助您的吗？", ¬
			"🙏 非常感谢您的支持！" & return & return & "我们会尽快处理您的问题。" & return & return & "如有任何疑问，请随时联系我们。", ¬
			"✅ 已收到您的信息" & return & return & "我们会尽快为您处理。" & return & return & "感谢您的耐心等待！", ¬
			"感谢您的咨询！😊" & return & return & "如果还有其他问题，随时欢迎联系我们。" & return & return & "祝您生活愉快！", ¬
			"💬 这是一个自定义模板" & return & return & "您可以在 templates/ 目录中创建 .txt 文件来自定义模板。" & return & return & "文件名将作为模板标题显示。" & return & return & "支持的内容包括：" & return & "- 文本" & return & "- Emoji 表情 😀 🎉 ✨" & return & "- 链接和联系方式" & return & "- 多行文本"}
	end if
	
	return {templateNames:templateNames, templateContents:templateContents}
end loadAllTemplates
