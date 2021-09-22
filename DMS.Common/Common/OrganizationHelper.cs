/**********************************************
 *
 * NameSpace   : DMS.Common 
 * ClassName   : OrganizationHelper
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common
{
    using Lafite.RoleModel.Service;
    using Lafite.RoleModel.Domain;
    using Lafite.RoleModel.Security;

    public static class OrganizationHelper
    {
        /// <summary>
        /// Gets the type of the attribute list by.
        /// </summary>
        /// <param name="type">The type.</param>
        /// <returns></returns>
        public static IList<AttributeDomain> GetAttributeListByType(string type)
        {
            IAttributeBiz biz = new AttributeBiz();

            return biz.GetAttributeListByType(type);
        }

        /// <summary>
        /// Gets the attribute list by parent id.
        /// </summary>
        /// <param name="parentId">The parent id.</param>
        /// <returns></returns>
        public static IList<AttributeDomain> GetAttributeListByParentId(string parentId)
        {
            IAttributeBiz biz = new AttributeBiz();

            return biz.GetAttributeListByParentId(parentId);
        }

        /// <summary>
        /// 从当前节点获取指定类型父节点.
        /// </summary>
        /// <param name="parentType">Type of the parent.</param>
        /// <param name="id">The id.</param>
        /// <returns></returns>
        public static OrganizationUnit GetParentOrganizationUnit(string parentType, string nodeId) 
        {
             Organization org = new Organization();
             org.Load();

             OrganizationUnit unit = org.FindNode(nodeId);
             return org.FindParentNode(parentType, unit);
        }

        /// <summary>
        /// 从当前节点获取指定类型孩子节点集合.
        /// </summary>
        /// <param name="childType">Type of the child.</param>
        /// <param name="nodeId">The node id.</param>
        /// <returns></returns>
        public static IList<OrganizationUnit> GetChildOrganizationUnit(string childType, string nodeId)
        {
            Organization org = new Organization();
            org.Load();

            OrganizationUnit unit = org.FindNode(nodeId);
            return unit.FindChilds(childType);
        }

        /// <summary>
        /// Gets the organization units by login user.
        /// </summary>
        /// <param name="loginUser">The login user.</param>
        /// <returns></returns>
        public static IList<OrganizationUnit> GetOrganizationUnitsByLoginUser(LoginUser loginUser)
        {
            Organization org = new Organization();
            org.Load();
            return org.FindNodes(loginUser);
        }


        /// <summary>
        /// Gets the organization unit by login user.
        /// </summary>
        /// <param name="loginUser">The login user.</param>
        /// <returns></returns>
        public static OrganizationUnit GetOrganizationUnitByLoginUser(LoginUser loginUser)
        {
            Organization org = new Organization();
            org.Load();
            return org.FindNode(loginUser);
        }



    }
}
