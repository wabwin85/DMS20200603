using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DMS.Model.ApiModel
{
    public class UPNDocumentDetail : BaseApiModel
    {
        public List<UPNDocumentItem> datas { get; set; }
    }

    public class UPNDocumentItem
    {
        public String UPN { get; set; }
        public String Lot { get; set; }
        public String DocNum { get; set; }
        public String ValidDateFrom { get; set; }
        public String ValidDateTo { get; set; }
        public String SourceFileName { get; set; }
        public String LinkUrl { get; set; }
        public String FileExt { get; set; }
        public String Category { get; set; }
        
    }
}
