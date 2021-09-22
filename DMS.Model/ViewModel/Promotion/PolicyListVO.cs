using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.Promotion
{
    public class PolicyListVO : BaseViewModel
    {
        public PolicyListVO()
        {
            LstProductLine = new List<KeyValuePair<string, string>>();
            LstPolicyStatus = new List<KeyValuePair<string, string>>();
            LstTimeStatus = new List<KeyValuePair<string, string>>();

            LstPolicyTypeDesc = new List<Hashtable>();

            RstPolicyList = new ArrayList();
            RstTemplateList = new ArrayList();
        }

        #region Control

        public String QryPolicyName { get; set; }
        public String QryProductLine { get; set; }
        public String QryPolicyStatus { get; set; }
        public String QryPolicyNo { get; set; }
        public String QryTimeStatus { get; set; }
        public String QryYear { get; set; }
        public String QryPromotionType { get; set; }

        public String IptPolicyId { get; set; }
        public String IptUserId { get; set; }

        public String IptProductLine { get; set; }

        #endregion

        #region ControlDataSource

        public IList<KeyValuePair<string, string>> LstProductLine { get; set; }
        public IList<KeyValuePair<string, string>> LstPolicyStatus { get; set; }
        public IList<KeyValuePair<string, string>> LstTimeStatus { get; set; }

        public IList<Hashtable> LstPolicyTypeDesc { get; set; }

        #endregion

        #region DataDataSource

        public ArrayList RstPolicyList { get; set; }
        public ArrayList RstTemplateList { get; set; }

        #endregion
    }
}
