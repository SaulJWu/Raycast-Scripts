#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Quick Reply Templates
# @raycast.mode silent
# @raycast.packageName Quick Replies
# @raycast.icon 💬
# @raycast.shortcut control+option+r

on run
	-- 定义常用回复模板
	set templates to {¬
		{name:"TIENDA MOTO ELITE CATIA", content:"TIENDA MOTO ELITE CATIA

Horario:

Dia: Lunes a Sabado

Hora: 8:30am a 5:30 pm

Whatsapp: 04242838297

Dirección: A 2 Cuadras de la Estación del Metro Pérez Bonalde, Calle México de Catia, Frente al Colegio Juan Antonio Pérez Bonalde  

https://maps.app.goo.gl/Mto6487FwnZkyA8y5?g_st=ic"}¬
	}
	
	-- 提取模板名称列表
	set templateNames to {}
	repeat with template in templates
		set end of templateNames to name of template
	end repeat
	
	-- 让用户选择模板
	try
		set selectedTemplateName to choose from list templateNames with prompt "选择要使用的回复模板:" default items {item 1 of templateNames} without multiple selections allowed and empty selection allowed
		
		if selectedTemplateName is false then
			-- 用户取消了选择
			return
		end if
		
		-- 找到选中的模板内容
		set selectedContent to ""
		repeat with template in templates
			if name of template is item 1 of selectedTemplateName then
				set selectedContent to content of template
				exit repeat
			end if
		end repeat
		
		-- 将选中的模板内容复制到剪贴板
		set the clipboard to selectedContent
		
		-- 自动粘贴到当前焦点
		tell application "System Events"
			-- 增加一个微小的延迟，确保剪贴板操作完成，并且焦点已稳定
			delay 0.1
			
			-- 模拟 Command-V (粘贴)
			keystroke "v" using {command down}
		end tell
		
		-- 显示成功通知
		display notification "已粘贴模板: " & (item 1 of selectedTemplateName) with title "快速回复"
		
	on error errorMessage
		display notification "操作失败: " & errorMessage with title "错误"
	end try
end run

