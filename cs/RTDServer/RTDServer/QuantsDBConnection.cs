using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Runtime.InteropServices;
using Microsoft.Office.Interop.Excel;

using Npgsql;

namespace RTDServer
{
    public class QuantsDBConnection : IDisposable
    {
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
            string sql = "SELECT value FROM ((" + code.datatable + " LEFT JOIN fields ";
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
            if (notifyConn != null)
                notifyConn.Close();
            conn.Close();
        }
    }
}
