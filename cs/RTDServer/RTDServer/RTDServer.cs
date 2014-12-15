using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Threading;
using System.Runtime.InteropServices;
using Microsoft.Office.Interop.Excel;

using Npgsql;

namespace RTDServer {
    public class FeedCode
    {
        public string code;
        public string field;
        public string datatable;
    }

    public class FeedCode2 : FeedCode
    {
        public int freq;
    }


    public class QuantsDBConnection : IDisposable {
        NpgsqlConnection conn;
        NpgsqlConnection notifyConn;
        IRTDUpdateEvent rtdUpdateEvent;

        public QuantsDBConnection(IRTDUpdateEvent rtdUpdateEvent)
        {
            this.notifyConn = null;
            this.rtdUpdateEvent = rtdUpdateEvent;
            String connection = "Server=lx000000700501;Port=5432;User Id=quotes_read;Password=quotes_read;Database=quotes";
            conn = new NpgsqlConnection(connection);
            conn.Open();
        }

        public void addNotifyConnection()
        {
            String connection1 = "Server=lx000000700501;Port=5432;User Id=quotes_read;Password=quotes_read;Database=quotes;SyncNotification=true";
            notifyConn = new NpgsqlConnection(connection1);
            notifyConn.Notification += OnNotification;
            notifyConn.Open();
            using (var command = new NpgsqlCommand("listen serverupdate;", notifyConn))
            {
                command.ExecuteNonQuery();
            }
        }

        private void OnNotification(object sender, NpgsqlNotificationEventArgs e)
        {
            rtdUpdateEvent.UpdateNotify();
        }

        public dynamic getValue(FeedCode code)
        {
            string sql = "SELECT value FROM ((" + code.datatable +" LEFT JOIN fields ";
            sql = sql + "ON " + code.datatable + ".field_id = fields.id) ";
            sql = sql + "LEFT JOIN feedcodes ON " + code.datatable + ".feedcode_id = feedcodes.id) ";
            sql = sql + "WHERE feedcodes.label = :value1 and fields.field = :value2";
            NpgsqlCommand command = new NpgsqlCommand(sql, conn);
            command.Parameters.Add(new NpgsqlParameter("value1", NpgsqlTypes.NpgsqlDbType.Varchar));
            command.Parameters.Add(new NpgsqlParameter("value2", NpgsqlTypes.NpgsqlDbType.Varchar));
            command.Parameters[0].Value = code.code;
            command.Parameters[1].Value = code.field;
            dynamic val = command.ExecuteScalar();
            return val;
        }

        public string getDataTable(string field)
        {
            string sql = "SELECT datatype FROM fields where field = :value1";
            NpgsqlCommand command = new NpgsqlCommand(sql, conn);
            command.Parameters.Add(new NpgsqlParameter("value1", NpgsqlTypes.NpgsqlDbType.Varchar));
            command.Parameters[0].Value = field;
            dynamic val = command.ExecuteScalar();
            return val;
        }

        public void Dispose()
        {
            if(notifyConn != null)
                notifyConn.Close();
            conn.Close();
        }
    }

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


    [Guid("7a0439cf-0eeb-4b71-b8bf-99af48d7ed7b")]
    [ProgId("PeriodicServer")]
    public class PeriodicRTDServer : IRtdServer
    {
        private readonly Dictionary<int, FeedCode2> topics = new Dictionary<int, FeedCode2>();
        QuantsDBConnection conn;
        private Timer timer;
        IRTDUpdateEvent rtdUpdateEvent;

        public int ServerStart(IRTDUpdateEvent rtdUpdateEvent)
        {
            try
            {
                this.rtdUpdateEvent = rtdUpdateEvent;
                conn = new QuantsDBConnection(rtdUpdateEvent);
                timer = new Timer(this.update, null, TimeSpan.Zero, TimeSpan.FromSeconds(1));
                return 1;
            }
            catch (Exception e)
            {
                return 0;
            }
        }

        private void update(object state)
        {
            rtdUpdateEvent.UpdateNotify();
        }

        public dynamic ConnectData(int TopicID, ref Array Strings, ref bool GetNewValues)
        {
            if (this.conn == null)
            {
                topics[TopicID] = new FeedCode2();
                return "Server Not Connected";
            }
            else
            {
                FeedCode2 code = new FeedCode2();
                code.freq = Convert.ToInt32(Strings.GetValue(0).ToString());
                code.code = Strings.GetValue(1).ToString();
                code.field = Strings.GetValue(2).ToString();
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

        int updateSerial = 0;
        public Array RefreshData(ref int topicCount)
        {
            updateSerial++;

            var data = new object[2, topics.Count];
            int i = 0;
            foreach (var entry in topics)
            {
                if (updateSerial % entry.Value.freq == 0)
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
            }
            topicCount = i;
            return data;
        }

        public void ServerTerminate()
        {
            timer.Dispose(); 
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



}
