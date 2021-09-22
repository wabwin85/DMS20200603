using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;

namespace DMS.ViewModel.Dashboard
{
    public class DealerPageVO : BaseVO
    {
        public String IptCorpType;
        public KeyValue IptQuarter;
        public KeyValue IptBu;

        public IList<Hashtable> LstQuarter;
        public IList<Hashtable> LstBu;

        public IList<KeyValue> RstTodo;
        public IList<Hashtable> RstManual;
        public IList<KeyValue> RstSummary;
        public IList<Hashtable> RstNotice;

        public Hashtable RstDimension;
        public Hashtable RstTrend;
    }
}
