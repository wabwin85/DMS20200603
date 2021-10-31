using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.Shipment.Extense
{
    public class InvReconcileSummaryVO : BaseQueryVO
    {
        public Guid Id { get; set; }

        public string Ids { get; set; }

        public string SubCompanyId { get; set; }

        public string BrandId { get; set; }

        public List<KeyValue> QryDealerName { get; set; }

        public KeyValue Dealer { get; set; }

        public KeyValue QryProductLine { get; set; }

        public List<KeyValue> LstProductLine { get; set; }

        public string QryOrderNumber { get; set; }

        public DatePickerRange QryReconcileDate { get; set; }

        public DateTime? QryReconcileStartDate { get; set; }

        public DateTime? QryReconcileEndDate { get; set; }

        public string QryHospital { get; set; }

        public KeyValue CompareInfo { get; set; }

        public int PageSize { get; set; } = 0;

        public int Page { get; set; } = 0;

        public int DataCount = 0;

        public bool IsSystemCompare { get; set; } = true;

        public ArrayList RstResultList = null;

        public ArrayList RstProductDetail = null;

        public ArrayList RstInvoiceDetail = null;

        public ArrayList RstProductInvoiceDetail = null;

    }
}
