using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.Consignment
{
    public class ConsignInventoryAdjustHeaderPO
    {
        public Guid IAH_ID { get; set; }
        public String IAH_Reason { get; set; }
        public String IAH_Inv_Adj_Nbr { get; set; }
        public Guid IAH_DMA_ID { get; set; }
        public DateTime? IAH_ApprovalDate { get; set; }
        public DateTime IAH_CreatedDate { get; set; }
        public Guid? IAH_Approval_USR_UserID { get; set; }
        public String IAH_AuditorNotes { get; set; }
        public String IAH_UserDescription { get; set; }
        public String IAH_Status { get; set; }
        public Guid IAH_CreatedBy_USR_UserID { get; set; }
        public Guid? IAH_Reverse_IAH_ID { get; set; }
        public Guid? IAH_ProductLine_BUM_ID { get; set; }
        public String IAH_WarehouseType { get; set; }
        public String IAH_RSM { get; set; }
        public String IAH_ApplyType { get; set; }
        public String RetrunReason { get; set; }
        public String SaleRep { get; set; }

        public String DMA_ChineseShortName { get; set; }

        public String VALUE1 { get; set; }
    }
}
