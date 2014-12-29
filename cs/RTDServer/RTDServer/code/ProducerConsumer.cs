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

namespace RTDServer
{
    /// <summary>
    /// Class ProducerConsumer
    /// </summary>
    public class ProducerConsumer
    {
        AutoResetEvent are = new AutoResetEvent(false);
        readonly object listLock = new object();
        static Queue queue;
        static NpgsqlConnection pgsqlConnection;
        private static ProducerConsumer instance;
        /// <summary>
        /// Instance creation (Singleton Pattern)
        /// </summary>
        public static ProducerConsumer Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new ProducerConsumer();
                    queue = new Queue();
                    new Thread(new ThreadStart(instance.ConsumerJob)).Start();

                    pgsqlConnection = new NpgsqlConnection("Server=lx000000700501;Port=5432;User Id=quants;Password=quants;Database=quotes");
                    pgsqlConnection.Open();
                }
                return instance;
            }
        }
        /// <summary>
        /// Queue element count function
        /// </summary>
        /// <returns></returns>
        public Int32 QueueCount()
        {
            lock (listLock)
            {
                return queue.Count;
            }
        }
        /// <summary>
        /// Producer
        /// </summary>
        /// <param name="o"></param>
        public void Produce(object o)
        {
            lock (listLock)
            {
                queue.Enqueue(o);
                are.Set();
                Monitor.Pulse(listLock);
            }
        }
        /// <summary>
        /// Consumer
        /// </summary>
        /// <returns></returns>
        public object Consume()
        {
            lock (listLock)
            {
                return queue.Dequeue();
            }
        }
        /// <summary>
        /// Consumer Job. This is the job activated with the initial thread
        /// </summary>
        public void ConsumerJob()
        {
            while (true)
            {
                are.WaitOne();
                {
                    if (this.QueueCount() > 0)
                    {
                        List<String> lfeedCode = new List<string>();
                        List<String> lfeedValue = new List<string>();
                        Int32 blockSize = 0;
                        while (this.QueueCount() > 0)
                        {
                            FeedCode token = (FeedCode)this.Consume();
                            lfeedCode.Add(token.code);
                            lfeedValue.Add(token.field);
                            blockSize++;
                        }
                        string[] feedCodes = lfeedCode.ToArray();
                        string[] feedValues = lfeedValue.ToArray();
                        this.WriteOnDB(ref(feedCodes), ref(feedValues), blockSize);
                    }
                }
            }
        }
        /// <summary>
        /// Write data on db using a bulk insert
        /// </summary>
        /// <param name="feedCode"></param>
        /// <param name="feedValues"></param>
        /// <param name="blockSize"></param>
        /// <returns></returns>
        public String WriteOnDB(ref String[] feedCode, ref String[] feedValues, int blockSize)
        {

            StringBuilder bulkInsertCmd = new StringBuilder();
            StringBuilder updateCommand = new StringBuilder();
            String tableName = "data_double";

            String thisFeedCode = String.Empty;
            String thisFeedValue = String.Empty;

            try
            {
                {
                    // Define command
                    NpgsqlCommand pgsqlCommand = new NpgsqlCommand();
                    pgsqlCommand.Connection = pgsqlConnection;

                    bulkInsertCmd.Length = 0;
                    for (int i = 0; i < feedCode.Length; i++)
                    {
                        thisFeedCode = feedCode[i];
                        thisFeedValue = feedValues[i];

                        updateCommand.Length = 0;
                        updateCommand.Append("UPDATE ");
                        updateCommand.Append(tableName);
                        updateCommand.Append(" SET VALUE = ");
                        updateCommand.Append(thisFeedValue);
                        updateCommand.Append(" WHERE field_id = (SELECT id FROM fields WHERE field = 'VALUE') ");
                        updateCommand.Append(" AND feedcode_id = (SELECT id FROM feedcodes WHERE label = '");
                        updateCommand.Append(thisFeedCode);
                        updateCommand.Append("')");

                        string cmd = updateCommand.ToString();
                        bulkInsertCmd.Append(cmd);
                        bulkInsertCmd.Append(";");
                    }
                    pgsqlCommand.CommandText = bulkInsertCmd.ToString();
                    pgsqlCommand.ExecuteNonQuery();
                    pgsqlCommand.Dispose();
                }
            }
            catch (NpgsqlException ex)
            {
                throw ex;
            }

            return "It worked!";
        }

    }
}
