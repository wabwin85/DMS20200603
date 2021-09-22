using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Common
{
    public class ApplyBasic
    {
        public ApplyBasic()
        {
        }

        public ApplyBasic(String ApplyDate, String ApplyUser, String ApplyNo, String Status)
        {
            this.ApplyDate = ApplyDate;
            this.ApplyUser = ApplyUser;
            this.ApplyNo = ApplyNo;
            this.Status = Status;
        }

        [LogAttribute]
        public String ApplyDate = "";
        [LogAttribute]
        public String ApplyUser = "";
        [LogAttribute]
        public String ApplyNo = "";
        [LogAttribute]
        public String Status = "";
    }
}
