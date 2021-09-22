/**********************************************
 *
 * NameSpace   : DMS.Business 
 * ClassName   : ProductClassifications
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Lafite.RoleModel.Security;
    using Lafite.RoleModel.Security.Authorization;
    using Grapecity.Logging.CallHandlers;

    using DMS.DataAccess;
    using DMS.Model;
    using System.Collections;

    /// <summary>
    /// 产品分类维护
    /// </summary>
    public class ProductClassifications : BaseBusiness, IProductClassifications
    {
        #region Consts Define
        public const string Action_ProductClassifications = "ProductClassifications";

        #endregion

        private IRoleModelContext _context = RoleModelContext.Current;


        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PartsClassification GetObject(Guid objKey)
        {
            using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                return dao.GetObject(objKey);
            }
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        [AuthenticateHandler(ActionName = Action_ProductClassifications, Description = "产品分类维护", Permissoin = PermissionType.Read)]
        public IList<PartsClassification> GetAll()
        {
            using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                return dao.GetAll();
            }
        }

        /// <summary>
        /// 得到树的根节点
        /// </summary>
        /// <returns>所有实体</returns>
        [AuthenticateHandler(ActionName = Action_ProductClassifications, Description = "产品分类维护", Permissoin = PermissionType.Read)]
        public IList<PartsClassification> GetRoot()
        {
            using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                return dao.GetRoot();
            }
        }


        /// <summary>
        /// 查询PartsClassification
        /// </summary>
        /// <returns>返回PartsClassification集合</returns>
        [AuthenticateHandler(ActionName = Action_ProductClassifications, Description = "产品分类维护", Permissoin = PermissionType.Read)]
        public IList<PartsClassification> SelectByFilter(PartsClassification obj)
        {
             using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                return dao.SelectByFilter(obj);
            }
        }


        /// <summary>
        /// 根据产品线查询PartsClassification
        /// </summary>
        /// <returns>返回PartsClassification集合</returns>
        [AuthenticateHandler(ActionName = Action_ProductClassifications, Description = "产品分类维护", Permissoin = PermissionType.Read)]
        public IList<PartsClassification> GetClassificationByLine(Guid lineId)
        {
            PartsClassification param = new PartsClassification();
            param.ProductLineId = lineId;

            using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                return dao.SelectByFilter(param);
            }
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        [AuthenticateHandler(ActionName = Action_ProductClassifications, Description = "产品分类维护", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Classification, Title = "产品分类维护", Message = "产品分类维护修改", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public int Update(PartsClassification obj)
        {
             using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                obj.LastUpdateDate = DateTime.Now;
                obj.LastUpdateUser = new Guid(_context.User.Id);

                return dao.Update(obj);
            }
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        [AuthenticateHandler(ActionName = Action_ProductClassifications, Description = "产品分类维护", Permissoin = PermissionType.Delete)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Classification, Title = "产品分类维护", Message = "产品分类维护删除", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public int Delete(Guid partId)
        {
            using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                return dao.Delete(partId);
            }
        }

        /// <summary>
        /// 修改分类
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>修改结果</returns>
        [AuthenticateHandler(ActionName = Action_ProductClassifications, Description = "产品分类维护", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Classification, Title = "产品分类维护", Message = "产品分类维护", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public string UpdatePartsClassification(Hashtable ht)
        {
            using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                return dao.ModifyPartsClassification(ht);
            }
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        [AuthenticateHandler(ActionName = Action_ProductClassifications, Description = "产品分类维护", Permissoin = PermissionType.Delete)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Classification, Title = "产品分类维护", Message = "产品分类维护删除", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public string DeletePartsClassification(Hashtable ht)
        {
            using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                return dao.ModifyPartsClassification(ht);
            }
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        [AuthenticateHandler(ActionName = Action_ProductClassifications, Description = "产品分类维护", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Classification, Title = "产品分类维护", Message = "产品分类维护新增", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public void Insert(PartsClassification obj)
        {
            using (PartsClassificationDao dao = new PartsClassificationDao())
            {
                obj.LastUpdateDate = DateTime.Now;
                obj.LastUpdateUser = new Guid(_context.User.Id);

                obj.CreateDate = obj.LastUpdateDate;
                obj.CreateUser = obj.LastUpdateUser;

                dao.Insert(obj);
            }
        }
    }
}
