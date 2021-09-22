using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.Promotion
{
    public class PolicyTemplateListVO : BaseViewModel
    {
        public PolicyTemplateListVO()
        {
            LstProductLine = new List<KeyValuePair<string, string>>();

            LstPolicyTypeDesc = new List<Hashtable>();

            RstPolicyList = new ArrayList();
        }

        #region Control

        public String QryPolicyName { get; set; }
        public String QryProductLine { get; set; }
        public String QryPromotionType { get; set; }

        public String IptPolicyId { get; set; }
        public String IptUserId { get; set; }

        #endregion

        #region ControlDataSource

        public IList<KeyValuePair<string, string>> LstProductLine { get; set; }

        public IList<Hashtable> LstPolicyTypeDesc { get; set; }

        #endregion

        #region DataDataSource

        public ArrayList RstPolicyList { get; set; }

        #endregion
    }
}
