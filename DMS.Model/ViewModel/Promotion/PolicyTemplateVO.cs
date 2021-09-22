using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.Promotion
{
    public class PolicyTemplateVO : BaseViewModel
    {
        public PolicyTemplateVO()
        {
            LstProductLine = new List<KeyValuePair<string, string>>();
            LstPolicyGeneralDesc = new List<Hashtable>();

            RstFactorList = new ArrayList();
            RstRuleList = new ArrayList();
            RstAttachmentList = new ArrayList();
        }

        #region Control
        
        public String IptPolicyId { get; set; }
        public String IptPageType { get; set; }
        public String IptPolicyStyle { get; set; }
        public String IptPolicyStyleSub { get; set; }

        //政策状态
        public String IptPromotionState { get; set; }

        //政策编号
        public String IptPolicyNo { get; set; }
        //产品线
        public String IptProductLine { get; set; }
        //政策名称
        public String IptPolicyName { get; set; }
        //分组名称
        public String IptPolicyGroupName { get; set; }
        //开始时间
        public DateTime? IptBeginDate { get; set; }
        //终止时间
        public DateTime? IptEndDate { get; set; }
        //结算对象
        public String IptProTo { get; set; }
        //指定类型
        public String IptProToType { get; set; }
        //经销商结算周期
        public String IptPeriod { get; set; }
        //计入返利与达成
        public bool IptAcquisition { get; set; }
        //经销商积分效期
        public String IptPointValidDateType { get; set; }

        //因素ID
        public String IptPolicyFactorId { get; set; }
        public String IptPolicyFactorIsGift { get; set; }
        public String IptPolicyFactorIsPoint { get; set; }
        //规则ID
        public String IptPolicyRuleId { get; set; }
        //附件ID
        public String IptAttachmentId { get; set; }
        public String IptAttachmentName { get; set; }

        public String IptPolicySummary { get; set; }
        public String IptPolicyPreview { get; set; }

        #endregion

        #region ControlDataSource

        public IList<KeyValuePair<string, string>> LstProductLine { get; set; }

        public IList<Hashtable> LstPolicyGeneralDesc { get; set; }

        #endregion

        #region DataDataSource

        public ArrayList RstFactorList { get; set; }
        public ArrayList RstRuleList { get; set; }
        public ArrayList RstAttachmentList { get; set; }

        #endregion
    }
}
