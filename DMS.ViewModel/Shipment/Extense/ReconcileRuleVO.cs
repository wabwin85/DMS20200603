using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.Shipment.Extense
{
    public class ReconcileRuleVO : BaseQueryVO
    {
        public Guid Id { get; set; }

        public Guid SubCompanyId { get; set; }

        public IList<KeyValue> SubCompanies { get; set; }

        public KeyValue SubCompany { get; set; }

        public string ReconcileRule { get; set; }
        public DateTime? UpdateTime { get; set; }

        public string Updater { get; set; }

        public int PageSize { get; set; } = 0;

        public int Page { get; set; } = 0;

        public int DataCount = 0;

        public ArrayList RstResultList = null;

    }
}
