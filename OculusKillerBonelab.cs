using System.Diagnostics;
using System.Linq;
using System.Threading;

namespace OculusKiller
{
    public class Program
    {
        public static void Main()
        {
          Process vrStartupProcess = Process.Start("L:\\Oculus\\Software\\stress-level-zero-inc-bonelab\\BONELAB_Oculus_Windows64.exe");
          var sw = Stopwatch.StartNew();
          while (!vrStartupProcess.HasExited)
          {
            Thread.Sleep(1000);
          }
          var oculusClientProcesses = Process.GetProcessesByName("OculusClient");
          while (oculusClientProcesses.All(p => p.HasExited))
          {
            Thread.Sleep(1000);
          }
          foreach (var process in Process.GetProcesses().Where(p => p.ProcessName.StartsWith("OVRServer")))
          {
            process.Kill();
            process.WaitForExit();
          }
        }
    }
}