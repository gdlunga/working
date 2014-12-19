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
    public class myToken
    {
        private String feedCode;
        private String feedValue;

        public myToken()
        {
        }
        public myToken(String feedCode, String feedValue)
        {
            this.feedCode = feedCode;
            this.feedValue = feedValue;
        }
    }

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

            Int32 blockSize      = 10;

            StringBuilder bulkInsertCmd = new StringBuilder();
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

                    bulkInsertCmd.Length = 0;
                    int updateCount = 0;
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
                        if(updateCount <= blockSize)
                        {
                            bulkInsertCmd.Append(cmd);
                            bulkInsertCmd.Append(";");
                            updateCount++;
                        }
                        else{
                            pgsqlCommand.CommandText = bulkInsertCmd.ToString();
                            pgsqlCommand.ExecuteNonQuery();
                            pgsqlCommand.Dispose();
                            updateCount = 0;
                        }
                    }
                }
            }
            catch (NpgsqlException ex)
            {
                throw ex;
            }

            return "It worked!";        
        }

        public String TestUpdate2([MarshalAs(UnmanagedType.SafeArray)]ref string feedCode
                                , [MarshalAs(UnmanagedType.SafeArray)]ref string feedValue)
        {
            try
            {
                WriteOnDB(feedCode, feedValue);
                return "OK";
            }
            catch(Exception ex)
            {
                return "KO";
            }
        }

        String WriteOnDB(String feedCode, String feedValue)
        {
            String hresult = String.Empty;
            StringBuilder updateCommand = new StringBuilder();
            String tableName = "data_double";

            String thisFeedCode = String.Empty;
            String thisFeedValue = String.Empty;

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

                    thisFeedCode = feedCode;
                    thisFeedValue = feedValue;

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
                hresult= "It worked!";
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