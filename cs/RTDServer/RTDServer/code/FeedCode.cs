using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RTDServer
{
    public class FeedCode
    {
        public string code;
        public string field;
        public string datatable;

        public FeedCode() { }

        public FeedCode(String feedCode, String feedValue)
        {
            this.code = feedCode;
            this.field = feedValue;
        }
    }

}
