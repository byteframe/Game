using System.Diagnostics;
namespace OculusKiller
{
    public class Program
    {
        public static void Main()
        {
          Process vrStartupProcess = Process.Start("L:\\Oculus\\Software\\stress-level-zero-inc-bonelab\\BONELAB_Oculus_Windows64.exe");
          vrStartupProcess.WaitForExit();
        }
    }
}