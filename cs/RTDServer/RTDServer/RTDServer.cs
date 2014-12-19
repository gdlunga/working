using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Runtime.InteropServices;
using Microsoft.Office.Interop.Excel;

using Npgsql;

namespace RTDServer {

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
    
    class ThreadToken
    {
        public String feedCode;
        public String feedValue;

        public ThreadToken(String feedCode, String feedValue)
        {
            this.feedCode = feedCode;
            this.feedValue = feedValue;
        }
    }
    
    [ClassInterface(ClassInterfaceType.AutoDispatch)]
    public class UpdateDBServer
    {
        ProducerConsumer producer_consumer = ProducerConsumer.Instance;
        ThreadToken      token;

        public String MainThread(ref String feedCode, ref String feedValue)
        {
            try
            {
                this.token          = new ThreadToken(feedCode, feedValue);
                
                producer_consumer.Produce(token);

                new Thread(new ThreadStart(ConsumerJob)).Start();

                return "It worked!";
            }
            catch
            {
                return "It does not worked!";
            }
        }

        private void ConsumerJob()
        {
            ThreadToken token = (ThreadToken)producer_consumer.Consume();
            //this.WriteOnDB(ref(token.feedCode), ref(token.feedValue));
        }        

        public String WriteOnDB(ref String feedCode, ref String feedValue)
        {
            String hresult = String.Empty;
            StringBuilder updateCommand = new StringBuilder();
            String tableName = "data_double";

            String connection = "Server=lx000000700501;Port=5432;User Id=quants;Password=quants;Database=quotes";
            try
            {
                using (NpgsqlConnection pgsqlConnection = new NpgsqlConnection(connection))
                {
                    // Open the PgSQL Connection.                
                    pgsqlConnection.Open();
                    // Define command
                    NpgsqlCommand pgsqlCommand = new NpgsqlCommand();
                    pgsqlCommand.Connection = pgsqlConnection;

                    updateCommand.Length = 0;
                    updateCommand.Append("UPDATE ");
                    updateCommand.Append(tableName);
                    updateCommand.Append(" SET VALUE = ");
                    updateCommand.Append(feedValue);
                    updateCommand.Append(" WHERE field_id = (SELECT id FROM fields WHERE field = 'VALUE') ");
                    updateCommand.Append(" AND feedcode_id = (SELECT id FROM feedcodes WHERE label = '");
                    updateCommand.Append(feedCode);
                    updateCommand.Append("')");

                    string cmd = updateCommand.ToString();

                    pgsqlCommand.CommandText = cmd;
                    pgsqlCommand.ExecuteNonQuery();
                    pgsqlCommand.Dispose();
                }
                hresult = "It worked!";
            }
            catch (NpgsqlException ex)
            {
                hresult = "It does not worked! ";
            }
            catch
            {
                hresult = "It does not worked!";
            }
            return hresult;
        }
    }

    class ProducerConsumer
    {
        private ProducerConsumer()
        {
        }

        readonly object listLock = new object();
        Queue queue = new Queue();

        private static ProducerConsumer instance;

        public static ProducerConsumer Instance
        {
            get{
                if(instance == null){
                    instance = new ProducerConsumer();
                }
                return instance;
            }
        }

        public void Produce(object o)
        {
            lock (listLock)
            {
                queue.Enqueue(o);
                Monitor.Pulse(listLock);
            }
        }

        public object Consume()
        {
            lock (listLock)
            {
                while (queue.Count == 0)
                {
                    Monitor.Wait(listLock);
                }
                return queue.Dequeue();
            }
        }
    }

}
