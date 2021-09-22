using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.Consignment
{
    public class TransferConfirmPO
    {
        public Guid TC_ID { get; set; }
        public Guid TC_TD_ID { get; set; }
        public Guid? TC_WHM_ID { get; set; }
        public Guid? TC_PMA_ID { get; set; }
        public Guid? TC_LOT_ID { get; set; }
        public decimal? TC_QTY { get; set; }
        public Guid? TC_ConfirmUser { get; set; }
        public DateTime? TC_ConfirmDate { get; set; }
        public string TC_Lot { get; set; }
        public string TC_QRCode { get; set; }
        public string TC_DOM { get; set; }
        public DateTime? TC_ExpiredDate { get; set; }

    }
}
