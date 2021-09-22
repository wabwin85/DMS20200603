using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using System.IO;
using Common.Logging;


namespace DMS.Business
{
    public class ReportBLL : IReportBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public DataSet QueryDealerInventoryDetail(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            using (ReportDao dao = new ReportDao())
            {
                return dao.QueryDealerInventoryDetail(obj, start, limit, out totalCount);
            }
        }

        public DataSet ExportDealerInventoryDetail(Hashtable obj)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            using (ReportDao dao = new ReportDao())
            {
                return dao.ExportDealerInventoryDetail(obj);
            }
        }

        public DataSet HospitalSales(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            using (ReportDao dao = new ReportDao())
            {
                return dao.HospitalSales(obj, start, limit, out totalCount);
            }
        }

        public DataSet ExportHospitalSales(Hashtable obj)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            using (ReportDao dao = new ReportDao())
            {
                return dao.ExprotHospitalSales(obj);
            }
        }

        public DataSet ScorecardDIOHReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            using (ReportDao dao = new ReportDao())
            {
                return dao.ScorecardDIOHReport(obj, start, limit, out totalCount);
            }
        }

        public DataSet ExportScorecardDIOHReport(Hashtable obj)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            using (ReportDao dao = new ReportDao())
            {
                return dao.ExprotScorecardDIOHReport(obj);
            }
        }


        public DataSet DealerPurchaseDetailReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            using (ReportDao dao = new ReportDao())
            {
                

                return dao.DealerPurchaseDetailReport(obj, start, limit, out totalCount);
            }
        }

        public DataSet ExportDealerPurchaseDetailReport(Hashtable obj)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            using (ReportDao dao = new ReportDao())
            {
                return dao.ExprotDealerPurchaseDetailReport(obj);
            }

        }

        public DataSet DealerSalesStatistics(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            obj.Add("OwnerCorpId", this._context.User.CorpId);
            using (ReportDao dao = new ReportDao())
            {
                return dao.DealerSalesStatistics(obj, start, limit, out totalCount);
            }
        }
    }
}
