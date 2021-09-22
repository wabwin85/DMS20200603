using DMS.ViewModel;
using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.TenderAuthorizationList
{
    public class TenderAuthorizationListVO : BaseQueryVO
    {
        public string InstanceId;
        //申请编号
        public string DTM_NO;
        //经销商
        public string DTM_DealerName;

        public DateTime DTM_BeginDate;
        public DateTime DTM_BeginYear;
        public DateTime DTM_BeginMonth;
        public DateTime DTM_BeginDay;

        public DateTime DTM_EndDate;
        public DateTime DTM_EndYear;
        public DateTime DTM_EndMonth;
        public DateTime DTM_EndDay;

        public DateTime DTM_CreateDate;
        public DateTime DTM_CreateYear;
        public DateTime DTM_CreateMonth;
        public DateTime DTM_CreateDay;
        public string Hospital;

        public string FilePath;

        public String DownloadCookie;
    }
}
