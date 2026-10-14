// Stand-in for start_protected_game.exe: starts AC8 without EasyAntiCheat, using the same
// command as Bandai's internal "ACE COMBAT 8 No EAC" Steam launch config.
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Windows.Forms;

static class AC8NoEacLauncher
{
    const string AppId = "2288340";

    static int Main(string[] args)
    {
        string exe = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, @"Game\Binaries\Win64\AceCombat8.exe");
        if (!File.Exists(exe))
        {
            MessageBox.Show("Not found:\n" + exe, "AC8 launcher", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return 1;
        }
        var psi = new ProcessStartInfo(exe, string.Join(" ", new[] { "-SaveToUserDir" }.Concat(args.Select(Quote))))
        {
            UseShellExecute = false,
            WorkingDirectory = Path.GetDirectoryName(exe)
        };
        // Without this, a game started outside Steam asks Steam to relaunch it via the launch target.
        psi.EnvironmentVariables["SteamAppId"] = AppId;
        Process.Start(psi);
        return 0;
    }

    static string Quote(string a)
    {
        return a.Length > 0 && a.IndexOfAny(new[] { ' ', '\t', '"' }) < 0 ? a : "\"" + a.Replace("\"", "\\\"") + "\"";
    }
}
