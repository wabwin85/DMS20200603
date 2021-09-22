using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Dashboard
{
    public class AdminPageVO : BaseQueryVO
    {
        public IList<KeyValue> RstTodo;
        public IList<Hashtable> RstManual;
        public IList<KeyValue> RstSummary;
        public IList<Hashtable> RstNotice;

        public Hashtable RstOrder = new Hashtable();
        public Hashtable RstShipment = new Hashtable();
        public Hashtable RstOrderProduct = new Hashtable();
        public Hashtable RstShipmentProduct = new Hashtable();
        public Hashtable RstInterface = new Hashtable();
        public Hashtable RstLPInterface = new Hashtable();
        public Hashtable RstMenuName = new Hashtable();
        public Hashtable RstMenu = new Hashtable();

        public KeyValue IptYear;
        public IList<Hashtable> LstYear;
    }
}
