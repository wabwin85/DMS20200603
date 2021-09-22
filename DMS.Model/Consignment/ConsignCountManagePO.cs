using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.Consignment
{
    public class ConsignCountManagePO
    {
        public Guid CQ_ID { get; set; }
        public String CQ_DMA_SAP_Code { get; set; }
        public int CQ_DivisionCode { get; set; }
        public String CQ_Upn { get; set; }
        public Decimal? CQ_Amount { get; set; }
        public Decimal? CQ_Qty { get; set; }
        public DateTime? CQ_BeginDate { get; set; }
        public DateTime? CQ_EndDate { get; set; }
        public DateTime? CQ_CreateDate { get; set; }
    }
}
