param(
  [Parameter(Mandatory=$true)][string]$Name,
  [int]$ProcId = 0,
  [int]$ClickX = -1,
  [int]$ClickY = -1,
  [int]$WaitMs = 800
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public class Shot {
  public delegate bool EnumProc(IntPtr hWnd, IntPtr lParam);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr lParam);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
  [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr hWnd, StringBuilder sb, int max);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint flags, uint dx, uint dy, uint data, UIntPtr extra);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  public struct RECT { public int Left, Top, Right, Bottom; }

  public static IntPtr FindByPid(uint target) {
    IntPtr found = IntPtr.Zero;
    EnumWindows((h, l) => {
      uint pid; GetWindowThreadProcessId(h, out pid);
      if (pid != target) return true;
      if (!IsWindowVisible(h)) return true;
      var sb = new StringBuilder(256);
      GetWindowText(h, sb, 256);
      if (sb.Length == 0) return true;
      found = h;
      return false;
    }, IntPtr.Zero);
    return found;
  }
}
'@

$h = [Shot]::FindByPid([uint32]$ProcId)
if ($h -eq [IntPtr]::Zero) { Write-Output "WINDOW_NOT_FOUND for pid $ProcId"; exit 1 }
[Shot]::SetProcessDPIAware() | Out-Null

[Shot]::SetForegroundWindow($h) | Out-Null
Start-Sleep -Milliseconds 300

if ($ClickX -ge 0) {
  [Shot]::SetCursorPos($ClickX, $ClickY) | Out-Null
  Start-Sleep -Milliseconds 150
  [Shot]::mouse_event(2, 0, 0, 0, [UIntPtr]::Zero)  # LEFTDOWN
  [Shot]::mouse_event(4, 0, 0, 0, [UIntPtr]::Zero)  # LEFTUP
  Start-Sleep -Milliseconds $WaitMs
}

$r = New-Object Shot+RECT
[Shot]::GetWindowRect($h, [ref]$r) | Out-Null
$w = $r.Right - $r.Left
$ht = $r.Bottom - $r.Top
if ($w -le 0 -or $ht -le 0) { Write-Output "MINIMIZED_OR_INVALID"; exit 1 }
$bmp = New-Object System.Drawing.Bitmap($w, $ht)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($r.Left, $r.Top, 0, 0, $bmp.Size)
$out = Join-Path $PSScriptRoot ("{0}.png" -f $Name)
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "SAVED $out ($w x $ht)"
