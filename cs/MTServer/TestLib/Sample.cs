/*
using RGiesecke.DllExport;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace TestLib
{
    [ComVisible(true), ClassInterface(ClassInterfaceType.AutoDual)]
    public class TestClass
    {
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
*/