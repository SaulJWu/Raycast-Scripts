# Raycast 脚本项目

## 项目简介

这是一个用于 Raycast 的 AppleScript 脚本集合，主要用于价格计算、快速回复模板和自动化操作。

## 脚本说明

### CalculateAndPastePrice.applescript

**功能**：计算价格折扣并自动粘贴文本

**用途**：
- 输入原始价格（USD）
- 自动计算 80% 折扣价（即原价的 20% 折扣）
- 生成格式化的文本并自动粘贴到当前焦点位置

**使用方式**：
- 在 Raycast 中配置快捷键后使用（快捷键在 Raycast 中设置，脚本本身不包含快捷键）
- 或直接在 Raycast 中搜索脚本名称运行

**使用流程**：
1. 通过 Raycast 运行脚本（使用配置的快捷键或搜索脚本名称）
2. 在弹出的对话框中输入原始价格
3. 脚本自动计算折扣价并粘贴格式化文本

**输出格式示例**：
```
$100 a BCV, pero si cancela en divisas de le aplica un descuento del 20% y le queda $80 en divisas
```

### ReverseCalculatePrice.applescript

**功能**：反向计算价格并自动粘贴文本

**用途**：
- 输入折扣后的价格（USD）
- 自动反推原始价格（折扣价 ÷ 0.8）
- 如果原始价格有小数，自动向下取整
- 生成格式化的文本并自动粘贴到当前焦点位置

**使用方式**：
- 在 Raycast 中配置快捷键后使用（快捷键在 Raycast 中设置，脚本本身不包含快捷键）
- 或直接在 Raycast 中搜索脚本名称运行

**使用流程**：
1. 通过 Raycast 运行脚本（使用配置的快捷键或搜索脚本名称）
2. 在弹出的对话框中输入折扣后的价格（例如：8）
3. 脚本自动反推原始价格（例如：8 ÷ 0.8 = 10）并粘贴格式化文本

**输出格式示例**：
```
$10 a BCV, pero si cancela en divisas de le aplica un descuento del 20% y le queda $8 en divisas
```

**计算逻辑**：
- 输入：折扣后价格（如 8）
- 计算：原始价格 = 折扣后价格 ÷ 0.8 = 8 ÷ 0.8 = 10
- 取整：如果原始价格有小数，向下取整（如 10.9 → 10）

### QuickReplyTemplates.applescript

**功能**：快速回复模板选择器，支持数字选择模板并自动粘贴

**用途**：
- 预定义常用回复模板（支持 Emoji 和自定义内容）
- 通过输入数字 1-6 快速选择模板
- 自动将选中的模板内容复制并粘贴到当前焦点位置

**使用方式**：
- 在 Raycast 中配置快捷键后使用（默认快捷键：`Control + Option + R`）
- 或直接在 Raycast 中搜索脚本名称运行

**使用流程**：
1. 通过 Raycast 运行脚本（使用配置的快捷键或搜索脚本名称）
2. 在弹出的列表对话框中查看所有可用模板
3. **直接按数字键（1-6）选择对应的模板**，无需回车或点击
4. 脚本自动将模板内容复制并粘贴到当前焦点位置

**模板说明**：
- **所有模板存储在 `templates/` 子目录中**
- **模板标题自动从文件名读取**（去掉 .txt 扩展名）
- 脚本自动扫描目录中的所有 .txt 文件，支持动态添加/删除模板
- 每个模板都支持 Emoji 表情符号、多行文本、链接等
- 文件按文件名排序显示，可以使用数字或 Emoji 前缀控制顺序
- 如果 `templates/` 目录不存在或为空，会使用脚本中的默认模板

**模板文件结构**：
- 所有模板文件位于 `templates/` 子目录中
- **文件名统一格式**：`template_X.txt`（X 为数字）
- **对话框只显示第一行内容预览**（约10-12个字符），不显示文件名，方便快速识别模板内容
- 脚本会自动扫描 `templates/` 目录中的所有 .txt 文件
- 文件按文件名排序显示

**默认模板文件**：
- `template_1.txt` - 店铺信息模板（预览：TIENDA MOTO...）
- `template_2.txt` - 问候模板（预览：👋 您好！）
- `template_3.txt` - 感谢模板（预览：🙏 非常感谢...）
- `template_4.txt` - 确认模板（预览：✅ 已收到...）
- `template_5.txt` - 结束对话模板（预览：感谢您的咨询...）
- `template_6.txt` - 自定义模板（预览：💬 这是一个...）

**自定义模板方法**：

**方法一：编辑现有模板**
1. 进入 `templates/` 子目录
2. 找到对应的模板文件（如 `1️⃣ TIENDA MOTO ELITE CATIA.txt`）
3. 用任何文本编辑器打开并编辑文件内容
4. 保存文件后，下次运行脚本时会自动使用新内容

**方法二：添加新模板**
1. 在 `templates/` 目录中创建新的 .txt 文件
2. 文件名统一格式：`template_X.txt`（X 为数字，例如：`template_7.txt`）
3. 在文件中写入模板内容（第一行内容会作为预览显示在对话框中）
4. 脚本会自动识别并显示新模板，对话框只显示第一行预览内容

**方法三：删除模板**
1. 直接删除 `templates/` 目录中对应的 .txt 文件
2. 脚本会自动更新模板列表

**注意事项**：
- **文件名统一格式**：`template_X.txt`（X 为数字），便于管理和排序
- **预览功能**：对话框只显示第一行内容预览（约10-12个字符），不显示文件名，方便快速识别模板内容
- 如果第一行为空，会自动使用第二行作为预览
- 建议在模板文件的第一行写入有意义的预览文本，方便在对话框中识别
- 支持 Emoji 表情符号在文件内容中（文件名建议使用统一格式）
- 文件按文件名排序显示（template_1.txt, template_2.txt...）
- 支持多行文本、Emoji、链接、联系方式等所有内容
- **预览自动刷新**：脚本每次运行都会重新读取文件内容并更新预览，无需重启 Raycast
- 如果更新了模板文件，下次运行脚本时会自动显示新的预览内容
- 如果 `templates/` 目录不存在或为空，会使用脚本中的默认模板

## 如何配置快捷键

脚本本身不包含快捷键配置，所有快捷键都需要在 Raycast 中设置：

1. 打开 Raycast（`Command + Space`）
2. 输入 "Extensions" 或"扩展"
3. 找到对应的脚本（如 "Calculate & Paste Price" 或 "Reverse Calculate & Paste Price"）
4. 点击脚本右侧的 "..." 菜单
5. 选择 "Set Hotkey" 或"设置快捷键"
6. 按下你想要设置的快捷键组合
7. 保存设置

配置完成后，你就可以使用设置的快捷键快速运行脚本了。

## 如何查看 Raycast 脚本日志

### 方法一：通过 Raycast 界面查看

1. 打开 Raycast（`Command + Space`）
2. 输入 "Extensions" 或"扩展"
3. 找到你的脚本 "Calculate & Paste Price"
4. 点击脚本右侧的 "..." 菜单
5. 选择 "View Logs" 或"查看日志"

### 方法二：通过终端查看系统日志

AppleScript 的错误日志通常记录在系统日志中：

```bash
# 查看最近的 AppleScript 错误日志
log show --predicate 'process == "osascript"' --last 5m --info

# 或者查看所有相关日志
log show --predicate 'subsystem == "com.apple.osascript"' --last 10m
```

### 方法三：直接测试脚本

在终端中直接运行脚本以查看错误信息：

```bash
cd "/Users/victor/IdeaProjects/Raycast Scripts"
osascript CalculateAndPastePrice.applescript
```

如果脚本有错误，终端会直接显示错误信息。

### 方法四：使用 Console.app（控制台应用）

1. 打开"控制台"应用（Applications > Utilities > Console）
2. 在搜索框中输入 "osascript" 或 "Raycast"
3. 运行脚本后，日志会实时显示

## 常见问题排查

### 1. 脚本无法运行

**可能原因**：
- 脚本语法错误（已修复：第27行的 `rounding as taught` 已改为 `rounding down`）
- 权限问题：需要在"系统设置 > 隐私与安全性 > 辅助功能"中授予 Raycast 权限
- 脚本路径错误

**解决方法**：
- 检查脚本语法是否正确
- 确保 Raycast 有辅助功能权限
- 在终端中直接运行脚本测试

### 2. 计算结果无法自动粘贴到输入框

**可能原因**：
- 对话框关闭后，焦点没有返回到原来的应用
- 延迟时间不够，应用还未完全激活就执行粘贴
- 剪贴板操作时序问题

**解决方法**：
- 已修复：改进了粘贴逻辑
  - 在显示对话框前保存当前活动应用
  - 对话框关闭后自动重新激活原来的应用，确保焦点正确
  - 增加了足够的延迟时间（0.3秒），确保应用激活和粘贴操作成功
  - 添加了完善的错误处理机制
- 如果问题仍然存在：
  - 确保在使用脚本前，目标应用（如聊天窗口、文本编辑器）已打开并获得焦点
  - 检查系统设置中 Raycast 是否有辅助功能权限
  - 可以在终端中直接运行脚本测试：`osascript CalculateAndPastePrice.applescript`

### 3. 价格计算错误

**可能原因**：
- 输入的不是有效数字
- 数字格式问题（如包含货币符号）

**解决方法**：
- 只输入纯数字，不要包含货币符号或其他字符
- 使用小数点格式（如：99.99）

## 代码说明

### 主要功能模块

1. **用户输入**：通过对话框获取原始价格
2. **价格计算**：计算 80% 折扣价（原价 × 0.8）
3. **取整处理**：向上取整到个位
4. **文本格式化**：生成包含原始价格和折扣价的完整文本
5. **剪贴板操作**：将文本复制到剪贴板
6. **自动粘贴**：模拟 Command+V 快捷键粘贴文本

### 关键代码说明

- `round finalPrice rounding up`：向上取整
- `set the clipboard to outputText`：设置剪贴板内容
- `keystroke "v" using {command down}`：模拟粘贴快捷键

## 开发与调试

### 测试脚本

```bash
# 测试正向计算脚本
osascript CalculateAndPastePrice.applescript

# 测试反向计算脚本
osascript ReverseCalculatePrice.applescript

# 测试快速回复模板脚本
osascript QuickReplyTemplates.applescript

# 或者使用 osascript 的调试模式
osascript -l AppleScript CalculateAndPastePrice.applescript
osascript -l AppleScript ReverseCalculatePrice.applescript
osascript -l AppleScript QuickReplyTemplates.applescript
```

### 修改脚本后的操作

1. 保存文件
2. 在 Raycast 中重新加载脚本（Extensions > 你的脚本 > Reload）
3. 或者重启 Raycast

## 更新日志

### 2024-12-XX（最新）
- **重大更新 QuickReplyTemplates.applescript**：
  - **统一文件名格式**：所有模板文件统一命名为 `template_X.txt`（X 为数字）
  - **新增预览功能**：对话框显示文件名 + 第一行内容预览（约10-12个字符），方便快速识别模板
  - 如果第一行为空，自动使用第二行作为预览
  - 所有模板存储在 `templates/` 子目录中
  - 脚本自动扫描 `templates/` 目录中的所有 .txt 文件
  - 支持动态添加、编辑、删除模板，只需操作文件即可
  - 文件按文件名排序显示（template_1.txt, template_2.txt...）
  - 如果 `templates/` 目录不存在或为空，自动使用脚本中的默认模板
  - 脚本每次运行都会重新扫描目录，无需重启 Raycast
- **修复问题**：
  - 修复了 Raycast 元数据注释格式（从 `--` 改为 `#`），确保 Raycast 能正确识别脚本
  - 修复了 AppleScript 语法错误（try/on error 结构）

### 2024-12-XX
- **更新 QuickReplyTemplates.applescript**：
  - 修改选择方式：从列表选择改为数字输入（1-6）
  - 添加对话框显示所有可用模板
  - 支持 Emoji 表情符号和自定义内容
  - 内置 6 个常用回复模板示例
  - 改进焦点恢复机制，确保粘贴操作成功
  - 添加完善的输入验证和错误处理

### 2024-12-XX
- **更新 README 说明**：
  - 明确说明快捷键在 Raycast 中配置，脚本本身不包含快捷键
  - 添加了快捷键配置说明章节
- **新增反向计算脚本 ReverseCalculatePrice.applescript**：
  - 输入折扣后的价格，自动反推原始价格
  - 计算公式：原始价格 = 折扣后价格 ÷ 0.8
  - 如果原始价格有小数，自动向下取整
  - 生成格式化的文本并自动粘贴

### 2024-12-XX
- **修复了计算结果无法自动粘贴到输入框的问题**：
  - 改进了粘贴逻辑，在显示对话框前保存当前活动应用
  - 对话框关闭后自动重新激活原来的应用，确保焦点正确
  - 增加了足够的延迟时间（0.3秒），确保应用激活和粘贴操作成功
  - 添加了完善的错误处理机制
- 修复了第27行的语法错误：将 `rounding as taught` 改为 `rounding up`（向上取整）
- 添加了详细的错误处理和用户提示
- 创建了项目 README 文档

## 注意事项

1. 确保 Raycast 已正确安装并配置
2. 脚本需要辅助功能权限才能模拟键盘操作
3. 输入价格时只输入数字，不要包含其他字符
4. 脚本会在当前焦点位置粘贴文本，使用前请确保目标应用已获得焦点
5. QuickReplyTemplates 脚本支持 Emoji，可以直接在模板内容中使用任何 Emoji 表情
6. 自定义模板时，注意保持 AppleScript 语法正确，字符串中的引号需要转义或使用不同的引号类型

