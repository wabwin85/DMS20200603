using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.Promotion
{
    public class FactorInfoVO : BaseViewModel
    {
        public FactorInfoVO()
        {
            LstFactor = new ArrayList();
            LstRuleCondition = new ArrayList();
            LstRuleConditionType = new ArrayList();
            LstRelationCondition = new ArrayList();
            LstFactorDesc = new List<Hashtable>();

            RstFactorRule = new ArrayList();
            RstCheckFailList = new ArrayList();
        }

        #region Control

        //是否新增
        public String IsPageNew { get; set; }

        //是否模板
        public String IsTemplate { get; set; }

        public String IptPolicyId { get; set; }
        public String IptPolicyFactorId { get; set; }
        public String IptIsPoint { get; set; }
        public String IptIsPointSub { get; set; }
        public String IptPageType { get; set; }
        public String IptPromotionState { get; set; }

        //因素限制条件列表
        //Rule 限制条件
        //Relation 关联因素
        public String IptFactorClass { get; set; }

        //积分可订购产品
        public int IptCheckIsGift { get; set; }

        //因素类型
        public String IptFactor { get; set; }
        //描述
        public String IptRemark { get; set; }
        //促销赠品
        public bool IptIsGift { get; set; }
        //积分可订购产品
        public bool IptPointsValue { get; set; }

        //规则条件ID
        public String IptConditionId { get; set; }
        public String IptConditionMaxId { get; set; }

        //条件因素
        //条件
        public String IptRuleCondition { get; set; }
        //类型
        public String IptRuleConditionType { get; set; }
        //数值
        public String IptRuleConditionValues { get; set; }

        //关联因素
        //关联因素
        public String IptRelationCondition { get; set; }
        //描述
        public String IptRelationConditionRemark { get; set; }

        #endregion

        #region ControlDataSource

        public ArrayList LstFactor { get; set; }
        public ArrayList LstRuleCondition { get; set; }
        public ArrayList LstRuleConditionType { get; set; }
        public ArrayList LstRelationCondition { get; set; }

        public IList<Hashtable> LstFactorDesc { get; set; }

        #endregion

        #region DataDataSource

        public ArrayList RstFactorRule { get; set; }
        public ArrayList RstCheckFailList { get; set; }
        public ArrayList RstRuleConditionValues { get; set; }

        #endregion
    }
}
