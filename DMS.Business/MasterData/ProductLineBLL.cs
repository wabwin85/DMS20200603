using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using DMS.DataAccess;
using DMS.Model;
using DMS.Common;
using DMS.DataAccess.MasterData;

namespace DMS.Business
{
    public class ProductLineBLL
    {
        public ProductLineBLL()
        {

        }

        public String SelectProductLineName(Guid productLineId)
        {
            using (ProductLineDao dao = new ProductLineDao())
            {
                return dao.SelectProductLineName(productLineId);
            }
        }

        public IList<ViewProductLine> SelectViewProductLine(string subCompanyId, string brandId, string id)
        {
            using (ProductLineDao dao = new ProductLineDao())
            {
                return dao.SelectViewProductLine(subCompanyId, brandId, id);
            }
        }
    }
}
