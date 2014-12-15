using System;
using System.Linq;
using System.Text;
using System.Threading;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using Microsoft.Office.Interop.Excel;


namespace MinimalRTDServer
{
    public class Countdown
    {
        public int CurrentValue { get; set; }
    }

    [
        Guid("9AA100A8-E50E-4047-9C60-E4732391063E"),
        ProgId("T004314.Sample.RtdServer"),
    ]
    public class RtdServer : IRtdServer
    {
        //private readonly Dictionary<int, Countdown> _topics = new Dictionary<int, Countdown>();
        private Timer _timer;
        private int _topic_id;

        public int ServerStart(IRTDUpdateEvent rtdUpdateEvent)
        {
            _timer = new Timer( delegate { rtdUpdateEvent.UpdateNotify(); }
                              , null
                              , TimeSpan.Zero
                              , TimeSpan.FromMilliseconds(1000));
            return 1;
        }

        public object ConnectData(int topicId, ref Array strings, ref bool getNewValues)
        {
            var start = Convert.ToInt32(strings.GetValue(0).ToString());
            getNewValues = true;

            _topic_id = topicId;
            //_topics[topicId] = new Countdown { CurrentValue = start };

            //return start;
            return GetTime();
        }

        public Array RefreshData(ref int topicCount)
        {
            var data = new object[2, 1];

            data[0, 0] = _topic_id;
            data[1, 0] = GetTime();
            topicCount = 1;

            /*
            var index = 0;
            
            foreach (var entry in _topics)
            {
                --entry.Value.CurrentValue;
                data[0, index] = entry.Key;
                data[1, index] = entry.Value.CurrentValue;
                ++index;
            }

            topicCount = _topics.Count;
            */

            return data;
        }

        private string GetTime()
        {
            return DateTime.Now.ToString("hh:mm:ss:ff");
        }

        public void DisconnectData(int topicId)
        {
            _timer.Dispose();
            //topics.Remove(topicId);
        }

        public int Heartbeat() { return 1; }

        public void ServerTerminate() { _timer.Dispose(); }

        [ComRegisterFunctionAttribute]
        public static void RegisterFunction(Type t)
        {
            Microsoft.Win32.Registry.ClassesRoot.CreateSubKey(@"CLSID\{" + t.GUID.ToString().ToUpper() + @"}\Programmable");
            var key = Microsoft.Win32.Registry.ClassesRoot.OpenSubKey(@"CLSID\{" + t.GUID.ToString().ToUpper() + @"}\InprocServer32", true);
            if (key != null)
                key.SetValue("", System.Environment.SystemDirectory + @"\mscoree.dll", Microsoft.Win32.RegistryValueKind.String);
        }

        [ComUnregisterFunctionAttribute]
        public static void UnregisterFunction(Type t)
        {
            Microsoft.Win32.Registry.ClassesRoot.DeleteSubKey(@"CLSID\{" + t.GUID.ToString().ToUpper() + @"}\Programmable");
        }

    }
}
