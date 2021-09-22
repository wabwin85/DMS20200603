
using DMS.Model.ViewModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    public class DealerMasterDDBscView : BaseViewModel
    {
        public DealerMasterDDBscView()
        {
            AttachmentList = new ArrayList();
        }
        public string ContractID { get; set; }
        public string DDReportName { get; set; }
        public string DeleteAttachmentID { get; set; }
        public string DeleteAttachmentName { get; set; }
        public DateTime? DDStartDate { get; set; }

        public DateTime? DDEndDate { get; set; }

        public string HtmlString { get; set; }
        public ArrayList AttachmentList { get; set; }

    }
    
}
