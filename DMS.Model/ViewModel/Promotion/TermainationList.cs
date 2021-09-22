using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.Promotion
{
    public class TermainationList : BaseViewModel
    {
        public TermainationList()
        {
            LstProductLine = new List<KeyValuePair<string, string>>();

            LstPolicyTypeDesc = new List<Hashtable>();
            //LstPolicyNo = new List<KeyValuePair<string, string>>();
            RstTemainationList = new ArrayList();
            RstTemplateList = new ArrayList();
            ProductLineList = new ArrayList();
        }

        #region Control

        public String QryPromotionNo { get; set; }
        public String QryStatus { get; set; }
        public String QryPromotionName { get; set; }
        public String QryPromotionType { get; set; }
        public String IptUserId { get; set; }

        //促销政策编号
        public String QryPolicyNo { get; set; }
        //政策名称
        public String QryPolicyName { get; set; }
        //归类名称
        public String QryPolicyGroupName { get; set; }
        //产品线
        public String QryProductLine { get; set; }
        //开始时间
        public String QryStartDate { get; set; }
        //结束时间
        public String QryEndDate { get; set; }
        //SubBu
        public String QrySubBu { get; set; }
        //终止时效时间
        public String QryTemainationSDate { get; set; }
        //终止类型
        public String QryTemainationType { get; set; }

        //备注
        public String QryRemark { get; set; }

        public String TermainationNo { get; set; }

        public String QryPolicy { get; set; }
        //产品线查询
        public String QryCP { get; set; }
        //终止类型查询
        public String QryZZ { get; set; }
        public String TermainationId { get; set; }

        public String View{ get; set; }


        public String QryTermainationNo { get; set; }
        #endregion

        #region ControlDataSource

        public ArrayList LstPolicyNo { get; set; }
        public IList<KeyValuePair<string, string>> LstProductLine { get; set; }


        public IList<Hashtable> LstPolicyTypeDesc { get; set; }

        #endregion

        #region DataDataSource

        public ArrayList RstTemainationList { get; set; }
        public ArrayList RstTemplateList { get; set; }

        public ArrayList ProductLineList { get; set; }
        #endregion

    }


}
