using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.Promotion
{
    public class PolicyInfoVO : BaseViewModel
    {
        public PolicyInfoVO()
        {
            LstProductLine = new List<KeyValuePair<string, string>>();
            LstSubBu = new ArrayList();
            LstPolicyGeneralDesc = new List<Hashtable>();

            RstFactorList = new ArrayList();
            RstRuleList = new ArrayList();
            RstAttachmentList = new ArrayList();
        }

        #region Control

        public String IsPageNew { get; set; }

        public String IptPolicyId { get; set; }
        public String IptPageType { get; set; }
        public String IptPolicyStyle { get; set; }
        public String IptPolicyStyleSub { get; set; }

        //政策状态
        public String IptPromotionState { get; set; }

        //政策编号
        public String IptPolicyNo { get; set; }
        //促销计算基数
        public String IptPolicyType { get; set; }
        //产品线
        public String IptProductLine { get; set; }
        //SubBU
        public String IptSubBu { get; set; }
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
        //二级到平台的加价率
        public String IptPointRatio { get; set; }
        //封顶类型
        public String IptTopType { get; set; }
        //封顶值
        public String IptTopValue { get; set; }
        //扣除上期赠品
        public bool IptMinusLastGift { get; set; }
        //进位方式
        public String IptCarryType { get; set; }
        //增量计算
        public bool IptIncrement { get; set; }
        //累计上期余量
        public bool IptAddLastLeft { get; set; }
        //YTD奖励追溯
        public String IptYtdOption { get; set; }
        //计入返利与达成
        public bool IptAcquisition { get; set; }
        //平台积分可用于全产品
        public bool IptUseProductForLp { get; set; }
        //平台积分有效期
        public String IptPointValidDateTypeForLp { get; set; }
        //跨度-平台
        public String IptPointValidDateDurationForLp { get; set; }
        //日期-平台
        public String IptPointValidDateAbsoluteForLp { get; set; }
        //一/二级积分效期
        public String IptPointValidDateType { get; set; }
        //跨度
        public String IptPointValidDateDuration { get; set; }
        //日期
        public String IptPointValidDateAbsolute { get; set; }
        //买减折价率
        public String IptMjRatio { get; set; }

        //因素ID
        public String IptPolicyFactorId { get; set; }
        public String IptPolicyFactorIsGift { get; set; }
        public String IptPolicyFactorIsPoint { get; set; }
        //规则ID
        public String IptPolicyRuleId { get; set; }
        //附件ID
        public String IptAttachmentId { get; set; }
        public String IptAttachmentName { get; set; }
        //public String IptPolicyFactorId { get; set; }
        //预览
        public string IptReloadLook { get; set; }

        public String IptPolicyPreview { get; set; }

        #endregion

        #region ControlDataSource

        public IList<KeyValuePair<string, string>> LstProductLine { get; set; }
        public ArrayList LstSubBu { get; set; }

        public IList<Hashtable> LstPolicyGeneralDesc { get; set; }

        #endregion

        #region DataDataSource

        public ArrayList RstFactorList { get; set; }
        public ArrayList RstRuleList { get; set; }
        public ArrayList RstAttachmentList { get; set; }

        #endregion
    }
}
