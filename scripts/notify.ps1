Add-Type @"
using System;
using System.Runtime.InteropServices;

public class TaskbarFlash {
    [StructLayout(LayoutKind.Sequential)]
    public struct FLASHWINFO {
        public uint cbSize;
        public IntPtr hwnd;
        public uint dwFlags;
        public uint uCount;
        public uint dwTimeout;
    }

    [DllImport("user32.dll")] public static extern bool FlashWindowEx(ref FLASHWINFO pwfi);

    public const uint FLASHW_ALL = 3;
    public const uint FLASHW_TIMERNOFG = 12;

    public static void Flash(IntPtr hwnd, uint count) {
        FLASHWINFO fi = new FLASHWINFO();
        fi.cbSize = (uint)Marshal.SizeOf(fi);
        fi.hwnd = hwnd;
        fi.dwFlags = FLASHW_ALL | FLASHW_TIMERNOFG;
        fi.uCount = count;
        fi.dwTimeout = 0;
        FlashWindowEx(ref fi);
    }
}
"@

# Play notification sound
$soundFile = "C:\Windows\Media\Windows Proximity Notification.wav"
if (Test-Path $soundFile) {
    (New-Object System.Media.SoundPlayer $soundFile).Play()
} else {
    [System.Media.SystemSounds]::Asterisk.Play()
}

# Find terminal window and flash taskbar icon
$terminalNames = @("WindowsTerminal", "Code", "claude", "mintty", "ConEmuC64", "ConEmuC")
foreach ($name in $terminalNames) {
    $proc = Get-Process -Name $name -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne [IntPtr]::Zero } |
        Select-Object -First 1
    if ($proc) {
        [TaskbarFlash]::Flash($proc.MainWindowHandle, 5)
        break
    }
}
