# Raycast 脚本项目

## 项目简介

这是一个用于 Raycast 的 AppleScript 脚本集合，主要用于价格计算和自动化操作。

## 脚本说明

### CalculateAndPastePrice.applescript

**功能**：计算价格折扣并自动粘贴文本

**用途**：
- 输入原始价格（USD）
- 自动计算 80% 折扣价（即原价的 20% 折扣）
- 生成格式化的文本并自动粘贴到当前焦点位置

**快捷键**：`Control + Option + P`

**使用流程**：
1. 按下快捷键或通过 Raycast 运行脚本
2. 在弹出的对话框中输入原始价格
3. 脚本自动计算折扣价并粘贴格式化文本

**输出格式示例**：
```
$100 a BCV, pero si cancela en divisas de le aplica un descuento del 20% y le queda $80 en divisas
```

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
# 在终端中直接运行
osascript CalculateAndPastePrice.applescript

# 或者使用 osascript 的调试模式
osascript -l AppleScript CalculateAndPastePrice.applescript
```

### 修改脚本后的操作

1. 保存文件
2. 在 Raycast 中重新加载脚本（Extensions > 你的脚本 > Reload）
3. 或者重启 Raycast

## 更新日志

### 2024-12-XX（最新）
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

