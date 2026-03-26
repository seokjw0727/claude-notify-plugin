# claude-notify-plugin

Windows taskbar flash notification with sound for Claude Code.

Claude Code 작업이 완료되면 Windows 작업 표시줄 아이콘이 깜빡이고 알림 사운드가 재생됩니다.

## Features

- Windows 작업 표시줄 아이콘 깜빡임 (FlashWindowEx API)
- Windows Proximity Notification 사운드 재생
- 터미널이 비활성 상태일 때만 동작 (작업 중 방해 없음)
- 클릭하면 깜빡임 자동 중지
- Windows Terminal, VS Code, mintty, ConEmu 등 주요 터미널 자동 감지

## Requirements

- Windows 10 / 11
- PowerShell 5.1+
- Claude Code 2.1+

## Installation

### Option 1: Plugin Marketplace

```bash
claude plugin marketplace add --source github --repo seokjw0727/claude-notify-plugin
claude plugin install claude-notify
```

### Option 2: Settings.json

`~/.claude/settings.json`에 직접 추가:

```json
{
  "extraKnownMarketplaces": {
    "seokjw0727-claude-notify": {
      "source": "github",
      "repo": "seokjw0727/claude-notify-plugin"
    }
  }
}
```

### Option 3: Local Testing

```bash
claude --plugin-dir /path/to/claude-notify-plugin
```

## How It Works

Claude Code의 `Notification` hook을 사용합니다. Claude가 사용자 입력을 기다리는 상태가 되면:

1. 현재 실행 중인 터미널 프로세스를 찾음
2. Win32 `FlashWindowEx` API로 작업 표시줄 아이콘 깜빡임
3. `Windows Proximity Notification.wav` 사운드 재생

## Supported Terminals

| Terminal | Process Name |
|----------|-------------|
| Windows Terminal | `WindowsTerminal` |
| VS Code | `Code` |
| Claude Desktop | `claude` |
| Git Bash (mintty) | `mintty` |
| ConEmu | `ConEmuC64` / `ConEmuC` |

## Configuration

### Sound

기본 사운드는 `C:\Windows\Media\Windows Proximity Notification.wav`입니다. 해당 파일이 없으면 시스템 기본 알림음(`Asterisk`)이 재생됩니다.

### Flash Count

기본 깜빡임 횟수는 5회입니다. `scripts/notify.ps1`에서 수정 가능:

```powershell
[TaskbarFlash]::Flash($proc.MainWindowHandle, 5)  # 5 -> 원하는 횟수
```

## File Structure

```
claude-notify-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── hooks/
│   └── hooks.json           # Notification hook config
├── scripts/
│   └── notify.ps1           # Taskbar flash + sound script
└── README.md
```

## Troubleshooting

**Q: 소리만 나고 깜빡임이 없어요**
- 터미널이 포커스 상태이면 깜빡이지 않습니다. 다른 창으로 전환 후 테스트하세요.

**Q: 깜빡임만 있고 소리가 없어요**
- `C:\Windows\Media\Windows Proximity Notification.wav` 파일이 있는지 확인하세요.

**Q: 아무 반응이 없어요**
- PowerShell 실행 정책을 확인하세요: `Get-ExecutionPolicy`
- `Bypass` 또는 `RemoteSigned` 이상이어야 합니다.

## License

MIT
