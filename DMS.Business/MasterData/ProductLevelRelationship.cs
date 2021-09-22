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

namespace DMS.Business.MasterData
{
    public class ProductLevelRelationship : IProductLevelRelationship
    {
        /// <summary>
        /// 获取产品层级
        /// </summary>
        /// <returns>产品层级信息</returns>
        public DataSet GetProductlevelRelation()
        {
            using (ProductLevelRelationshipDao dao = new ProductLevelRelationshipDao())
            {
                return dao.GetProductlevelRelation();
            }

        }
    }
}
