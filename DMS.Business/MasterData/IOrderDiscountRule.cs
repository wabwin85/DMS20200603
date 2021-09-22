using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using System.Data;
    using System.Collections;
    public interface IOrderDiscountRule
    {
        DataSet QueryOrderDiscountRule(Hashtable obj, int start, int limit, out int totalCount);
        bool Import(DataTable dt);
        bool VerifyOrderDiscountRuleInit(string importType, out string IsValid);
        DataSet QueryErrorData(int start, int limit, out int totalCount);
        int DeleteDiscountRuleByUser(); 
    }
}
