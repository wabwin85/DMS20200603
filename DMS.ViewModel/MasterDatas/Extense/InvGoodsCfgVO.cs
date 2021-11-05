using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas.Extense
{
    public class InvGoodsCfgVO:BaseQueryVO
    {
        public Guid Id;
        public string QryCFN;

        public string ProductNameCN;

        public string ProductLine;

        public string SubCompanyName;

        public string BrandName;

        public string InvType;

        public KeyValue QryBu;

        public DateTime? UpdateTime;

        public string Creator;

        public string Modifier;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public IList<KeyValue> LstBu = null;
        public ArrayList RstResultList = null;
        public List<string> DeleteSeleteID = null;
    }
}
