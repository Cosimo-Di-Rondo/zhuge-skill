$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PluginRoot = Split-Path -Parent $ScriptDir
$SkillPath = Join-Path $PluginRoot 'SKILL.md'

if (-not (Test-Path $SkillPath)) {
    Write-Error "Error: missing skill file at $SkillPath"
    exit 1
}

$content = Get-Content -Path $SkillPath -Raw -Encoding UTF8
$escaped = $content -replace '\\', '\\\\' -replace '"', '\"' -replace "`r`n", '\n' -replace "`n", '\n' -replace "`r", '\r' -replace "`t", '\t'
$ctx = "<ZHUGE_SKILL>\n已加载 zhuge:perspective。请先遵守用户指令和宿主平台规则，在适用时运用卧龙的心智模型和决策启发式。\n\n$escaped\n\n</ZHUGE_SKILL>"

if ($env:CURSOR_PLUGIN_ROOT) {
    Write-Output "{`n  `"additional_context`": `"$ctx`"`n}"
} elseif ($env:CLAUDE_PLUGIN_ROOT) {
    Write-Output "{`n  `"hookSpecificOutput`": {`n    `"hookEventName`": `"SessionStart`",`n    `"additionalContext`": `"$ctx`"`n  }`n}"
} else {
    Write-Output "{`n  `"additional_context`": `"$ctx`"`n}"
}
exit 0
