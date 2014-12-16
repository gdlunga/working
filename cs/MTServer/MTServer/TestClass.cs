using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

using RGiesecke.DllExport;

using Npgsql;

namespace TestLib
{
    [ComVisible(true), ClassInterface(ClassInterfaceType.AutoDual)]
    public class TestClass
    {

        [return: MarshalAs(UnmanagedType.SafeArray)]
        public int[] QuickSortParallel([MarshalAs(UnmanagedType.SafeArray)]ref int[] ar)
        {
            ParallelSort.QuicksortParallel<int>(ar);
            return ar;
        }

        [return: MarshalAs(UnmanagedType.SafeArray)]
        public int[] QuickSortSequential([MarshalAs(UnmanagedType.SafeArray)]ref int[] ar)
        {
            ParallelSort.QuicksortSequential<int>(ar);
            return ar;
        }

        public String TestUpdate([MarshalAs(UnmanagedType.SafeArray)]ref string[] feedCode
                                ,[MarshalAs(UnmanagedType.SafeArray)]ref string[] feedValues)
        {
            StringBuilder updateCommand = new StringBuilder();
            String tableName = "data_double";

            String thisFeedCode     = String.Empty;
            String thisFeedValue    = String.Empty;

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

                        pgsqlCommand.CommandText = cmd;
                        pgsqlCommand.ExecuteNonQuery();
                        pgsqlCommand.Dispose();
                    }
                }
            }
            catch (NpgsqlException ex)
            {
                throw ex;
            }




            return "It worked!";        
        }

        
        // test methods ---------------------------------------------------------------
        public string[] textArray
        {
            [return: MarshalAs(UnmanagedType.SafeArray)]
            get;
            [param: MarshalAs(UnmanagedType.SafeArray)]
            set;
        }
        
        public string Text
        {
            [return: MarshalAs(UnmanagedType.BStr)]
            get;
            [param: MarshalAs(UnmanagedType.BStr)]
            set;
        }

        public int Numbers
        {
            [return: MarshalAs(UnmanagedType.SysInt)]
            get;
            [param: MarshalAs(UnmanagedType.SysInt)]
            set;
        }

        [return: MarshalAs(UnmanagedType.SysInt)]
        public int GetRandomNumber()
        {
            Random x = new Random();
            return x.Next(100);
        }
        // -----------------------------------------------------------------------------
    }

    static class UnmanagedExports
    {
        [DllExport]
        [return: MarshalAs(UnmanagedType.IDispatch)]
        static Object CreateTestClass()
        {
            return new TestClass();
        }
    }
}