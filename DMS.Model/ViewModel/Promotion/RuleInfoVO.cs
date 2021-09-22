using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.Promotion
{
    public class RuleInfoVO : BaseViewModel
    {
        public RuleInfoVO()
        {
            LstPolicyFactorX = new ArrayList();
            LstPolicyFactorY = new ArrayList();
            LstPointType = new ArrayList();

            LstRuleDesc = new List<Hashtable>();

            RstRuleDetail = new ArrayList();
        }

        #region Control

        //是否新增
        public String IsPageNew { get; set; }

        //是否模板
        public String IsTemplate { get; set; }

        public String IptPolicyId { get; set; }
        public String IptPolicyRuleId { get; set; }
        public String IptPolicyStyle { get; set; }
        public String IptPolicyStyleSub { get; set; }
        public String IptPageType { get; set; }
        public String IptPromotionState { get; set; }

        public String IptConditionId { get; set; }
        public String IptConditionMaxId { get; set; }

        //规则描述
        public String IptDesc { get; set; }
        //计算基数 X
        public String IptPolicyFactorX { get; set; }
        //计算基数 X 备注
        public String IptFactorRemarkX { get; set; }
        //Y 因素
        public String IptPolicyFactorY { get; set; }
        //Y 因素 备注
        public String IptFactorRemarkY { get; set; }
        //X 值
        public String IptFactorValueX { get; set; }
        //Y 值(赠送/折扣)
        public String IptFactorValueY { get; set; }
        //固定积分
        public String IptPointValue { get; set; }
        //积分换算方式
        public String IptPointType { get; set; }

        //条件因素
        public String IptPolicyConditionFacter { get; set; }
        //判断符号
        public String IptSymbol { get; set; }
        //值类型
        public String IptValueType { get; set; }
        //引用判断值1
        public String IptRefValue1 { get; set; }
        //引用判断值2
        public String IptRefValue2 { get; set; }
        //判断值1
        public String IptValue1 { get; set; }
        //判断值2
        public String IptValue2 { get; set; }
        //比较因素
        public String IptCompareFacter { get; set; }
        //系数
        public String IptCompareFacterRatio { get; set; }

        #endregion

        #region ControlDataSource

        public ArrayList LstPolicyFactorX { get; set; }
        public ArrayList LstPolicyFactorY { get; set; }
        public ArrayList LstPointType { get; set; }

        public ArrayList LstPolicyConditionFacter { get; set; }
        public IList<KeyValuePair<string, string>> LstSymbol { get; set; }
        public IList<KeyValuePair<string, string>> LstValueType { get; set; }
        public IList<KeyValuePair<string, string>> LstRefValue1 { get; set; }
        public IList<KeyValuePair<string, string>> LstRefValue2 { get; set; }
        public ArrayList LstCompareFacter { get; set; }

        public IList<Hashtable> LstRuleDesc { get; set; }

        #endregion

        #region DataDataSource

        public ArrayList RstRuleDetail { get; set; }

        #endregion
    }
}
