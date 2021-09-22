using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common
{
    using Lafite.RoleModel.Service;
    using Lafite.RoleModel.Domain;
    using Lafite.RoleModel.Security;

    public static class RoleHelper
    {
        /// <summary>
        /// 取得系统角色列表
        /// </summary>
        /// <param name="type">The type.</param>
        /// <returns></returns>
        public static IList<AttributeDomain> GetList()
        {
            IAttributeBiz biz = new AttributeBiz();

            return biz.GetAttributeListByType("Role");
        }
    }
}
