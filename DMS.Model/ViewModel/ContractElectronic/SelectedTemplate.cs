using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.ContractElectronic
{
    [Serializable]
    public class SelectedTemplate
    {
        //public Guid ExportID { get; set; }
        public string TmpID { get; set; }

        public string TmpName { get; set; }

        public int SortIndex { get; set; }

        public bool IsCheck { get; set; }
        public string FilePath { get; set; }
        public string FileType { get; set; }
    }
    [Serializable]
    public class UserPdfTemplate
    {
        //public Guid ExportID { get; set; }
        public string TmpID { get; set; }

        public string TmpName { get; set; }

        //public int SortIndex { get; set; }

        public string FilePath { get; set; }
        public string FileType { get; set; }
    }
    [Serializable]
    public class Rebate
    {
      public string   RebateRation { get; set; }
      public string RebateDiscount { get; set; }
      public string QuarterRatio { get; set; }
      public List<DiscountList> DiscountList { get; set; }
    }
    [Serializable]
    public class DiscountList
    {
     public string Grade { get; set; }
     public string Discount { get; set; }
    }
}
