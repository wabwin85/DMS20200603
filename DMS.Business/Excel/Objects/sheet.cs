using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using System.Text;

namespace DMS.Business.Excel.Objects
{
    class sheet
    {
        private Hashtable _htMain;
        private DataSet _dsDetail;

        public sheet() { }
        public Hashtable htMain
        {
            get { return _htMain; }
            set { _htMain = value; }
        }

        public DataSet dsDetail
        {
            get { return _dsDetail; }
            set { _dsDetail = value; }
        }
    }
}
