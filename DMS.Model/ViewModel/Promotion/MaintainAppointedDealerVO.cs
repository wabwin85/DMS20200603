using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.Promotion
{
    public class MaintainAppointedDealerVO : BaseViewModel
    {
        public MaintainAppointedDealerVO()
        {
            RstImportFailList = new ArrayList();

            LstPolicyDealerDesc = new List<Hashtable>();

            RstPolicyDealer = new ArrayList();
        }

        #region Control

        public String IptPolicyId { get; set; }
        //产品线
        public String IptProductLine { get; set; }
        //SubBU
        public String IptSubBu { get; set; }
        public String IptPageType { get; set; }
        public String IptPromotionState { get; set; }

        //经销商Code
        public String IptDealerCode { get; set; }
        //类型
        public String IptOperType { get; set; }

        public int IptImportSuccess { get; set; }
        public int IptImportFail { get; set; }
        
        public String IptDealerId { get; set; }

        #endregion

        #region ControlDataSource

        public IList<Hashtable> LstPolicyDealerDesc { get; set; }

        #endregion

        #region DataDataSource

        public ArrayList RstPolicyDealer { get; set; }
        public ArrayList RstImportFailList { get; set; }

        #endregion
    }
}
