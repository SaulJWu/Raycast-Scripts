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
	set templatePreviews to templatePreviews of templateData
	
	-- 显示模板列表提示（只显示预览，不显示文件名）
	set promptText to "请选择模板（输入数字 1-" & (count of templateNames) & " 后按回车）：" & return & return
	repeat with i from 1 to count of templateNames
		set templatePreview to item i of templatePreviews
		set promptText to promptText & i & ". " & templatePreview & return
	end repeat
	
	-- 使用 display dialog，用户输入数字后按回车
	-- 注意：由于 macOS 系统限制，标准的对话框都需要某种形式的确认
	-- 我们使用 display dialog，用户输入数字后按回车（回车是默认按钮）
	try
		set userInput to text returned of (display dialog promptText default answer "" buttons {"取消", "确定"} default button "确定" with title "快速回复模板")
		
		-- 验证输入不为空
		if userInput is "" then
			return
		end if
		
		-- 提取数字
		set userInput to my trim(userInput)
		try
			set selectedIndex to userInput as number
		on error
			return
		end try
		
		-- 验证索引范围
		if selectedIndex < 1 or selectedIndex > (count of templateNames) then
			return
		end if
		
		-- 获取选中的模板名称
		set selectedName to item selectedIndex of templateNames
		
	on error number -128
		-- 用户点击了"取消"
		return
	end try
	
	-- 获取选中的模板内容
	set selectedContent to item selectedIndex of templateContents
	
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
	set templatePreviews to {}
	
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
						-- 提取第一行内容作为预览（约10个字符）
						set firstLinePreview to my getFirstLinePreview(fileContent)
						
						set end of templateNames to templateName
						set end of templateContents to fileContent
						set end of templatePreviews to firstLinePreview
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
		set templateNames to {"template_1", "template_2", "template_3", "template_4", "template_5", "template_6"}
		set templateContents to {¬
			"TIENDA MOTO ELITE CATIA" & return & return & "Horario:" & return & return & "Dia: Lunes a Sabado" & return & return & "Hora: 8:30am a 5:30 pm" & return & return & "Whatsapp: 04242838297" & return & return & "Dirección: A 2 Cuadras de la Estación del Metro Pérez Bonalde, Calle México de Catia, Frente al Colegio Juan Antonio Pérez Bonalde" & return & return & "https://maps.app.goo.gl/Mto6487FwnZkyA8y5?g_st=ic", ¬
			"👋 您好！" & return & return & "感谢您的咨询，很高兴为您服务。" & return & return & "有什么我可以帮助您的吗？", ¬
			"🙏 非常感谢您的支持！" & return & return & "我们会尽快处理您的问题。" & return & return & "如有任何疑问，请随时联系我们。", ¬
			"✅ 已收到您的信息" & return & return & "我们会尽快为您处理。" & return & return & "感谢您的耐心等待！", ¬
			"感谢您的咨询！😊" & return & return & "如果还有其他问题，随时欢迎联系我们。" & return & return & "祝您生活愉快！", ¬
			"💬 这是一个自定义模板" & return & return & "您可以在 templates/ 目录中创建 .txt 文件来自定义模板。" & return & return & "文件名将作为模板标题显示。" & return & return & "支持的内容包括：" & return & "- 文本" & return & "- Emoji 表情 😀 🎉 ✨" & return & "- 链接和联系方式" & return & "- 多行文本"}
		set templatePreviews to {"TIENDA MOTO...", "👋 您好！", "🙏 非常感谢...", "✅ 已收到...", "感谢您的咨询...", "💬 这是一个..."}
	end if
	
	return {templateNames:templateNames, templateContents:templateContents, templatePreviews:templatePreviews}
end loadAllTemplates

-- 辅助函数：提取第一行内容作为预览（约10个字符）
on getFirstLinePreview(fileContent)
	-- 提取第一行（到第一个换行符）
	set AppleScript's text item delimiters to {return, linefeed}
	set textLines to text items of fileContent
	set AppleScript's text item delimiters to ""
	
	if (count of textLines) > 0 then
		set firstLine to item 1 of textLines
		-- 去除首尾空格
		set firstLine to my trim(firstLine)
		
		-- 如果第一行为空，尝试第二行
		if firstLine is "" and (count of textLines) > 1 then
			set firstLine to item 2 of textLines
			set firstLine to my trim(firstLine)
		end if
		
		-- 截取约10个字符（考虑中文字符和Emoji）
		if (length of firstLine) > 12 then
			set preview to text 1 thru 12 of firstLine & "..."
		else
			set preview to firstLine
		end if
		
		return preview
	else
		return "..."
	end if
end getFirstLinePreview

-- 辅助函数：去除字符串两端的空格
on trim(inputString)
	set AppleScript's text item delimiters to {" "}
	set textItems to text items of inputString
	set AppleScript's text item delimiters to ""
	return textItems as string
end trim
