using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using Microsoft.Office.Interop.Excel;

using Npgsql;

namespace RTDServer {
    /// <summary>
    /// RTD Server
    /// </summary>
    [Guid("EBD9B4A9-3E17-45F0-A1C9-E134043923D3")]
    [ProgId("RealTimeServer")]
    public class RTDServer : IRtdServer 
    {
        private readonly Dictionary<int, FeedCode> topics = new Dictionary<int, FeedCode>();
        QuantsDBConnection conn;

        public int ServerStart(IRTDUpdateEvent rtdUpdateEvent) {
            try
            {
                conn = new QuantsDBConnection(rtdUpdateEvent);
                conn.addNotifyConnection();
                return 1;
            }
            catch (Exception e)
            {
                return 0;
            }
        }

        public dynamic ConnectData(int TopicID, ref Array Strings, ref bool GetNewValues)
        {
            if (this.conn == null) {
                topics[TopicID] = new FeedCode();
                return "Server Not Connected";
            }
            else {
                FeedCode code = new FeedCode();
                code.code = Strings.GetValue(0).ToString();
                code.field = Strings.GetValue(1).ToString();
                code.datatable = conn.getDataTable(code.field);
                GetNewValues = true;
                topics[TopicID] = code;
                dynamic val;
                try
                {
                    val = conn.getValue(code);
                }
                catch (Exception e)
                {
                    val = e.ToString();
                }
                return val;
            }
        }

        public void DisconnectData(int TopicID)
        {
            topics.Remove(TopicID);

        }

        public int Heartbeat()
        {
            return 1;
        }

        public Array RefreshData(ref int topicCount)
        {
            var data = new object[2, topics.Count];
            int i = 0;
            foreach (var entry in topics)
            {
                data[0, i] = entry.Key;
                if (this.conn == null)
                    data[1, i] = "Server Not Connected";
                else
                {
                    object val;
                    try
                    {
                        val = conn.getValue(entry.Value);
                    }
                    catch (Exception e)
                    {
                        val = e.ToString();
                    }

                    data[1, i] = val;
                    ++i;
                }
            }
            topicCount = topics.Count;
            return data;
        }

        public void ServerTerminate()
        {
            conn.Dispose();
        }

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
    /// <summary>
    /// UpdateDBServer 
    /// </summary>
    [ClassInterface(ClassInterfaceType.AutoDispatch)]
    public class UpdateDBServer
    {
        ProducerConsumer producer_consumer = ProducerConsumer.Instance;
        FeedCode token;

        public String MainThread(ref String feedCode, ref String feedValue)
        {
            try
            {
                this.token = new FeedCode(feedCode, feedValue);
                producer_consumer.Produce(token);
                return "It worked!";
            }
            catch
            {
                return "It does not worked!";
            }
        }
    }

}
