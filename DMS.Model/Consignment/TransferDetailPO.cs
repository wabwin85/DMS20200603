using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.Consignment
{
    public class TransferDetailPO
    {
        public Guid TD_ID { get; set; }
        public Guid TD_TH_ID { get; set; }
        public Guid? TD_CFN_ID { get; set; }
        public String TD_UOM { get; set; }
        public decimal? TD_QTY { get; set; }
        public decimal? TD_CFN_Price { get; set; }
        public decimal? TD_Amount { get; set; }
    }
}
