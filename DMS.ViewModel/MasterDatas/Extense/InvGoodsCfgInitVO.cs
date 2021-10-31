using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas.Extense
{
    public class InvGoodsCfgInitVO: BaseQueryVO
    {
        public string SubCompanyName;
        public string BrandName;
        public string ProductLine;
        public string ProductNameCN;
        public string InvType;
        public DateTime? ImportDate;
        public string ErrorMsg;
        public bool? IsError;
        public string QryCFN;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public ArrayList RstResultList;
    }
}
