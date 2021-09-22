using DMS.Business;
using DMS.Business.Cache;
using DMS.Business.DataInterface;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.DCM;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.DCM
{
    public class BulletinManageService : ABaseQueryService
    {
        #region Ajax Method
        IBulletinManageBLL bll = new BulletinManageBLL();
        IAttachmentBLL attachBll = new AttachmentBLL();
        IRoleModelContext context = RoleModelContext.Current;

        //主页面
        public BulletinManageVO Init(BulletinManageVO model)
        {
            try
            {
                model.IsDealer = IsDealer;
                Permissions pers = context.User.GetPermissions();
                model.ShowSearch = pers.IsPermissible(Business.BulletinManageBLL.Action_BulletinManage, PermissionType.Read);
                model.ShowImport = pers.IsPermissible(Business.BulletinManageBLL.Action_BulletinManage, PermissionType.Write);
                IDictionary<string, string> dictsDegree = DictionaryHelper.GetDictionary("CONST_Bulletin_Important");
                model.LstUrgentDegree = JsonHelper.DataTableToArrayList(dictsDegree.ToList().ToDataSet().Tables[0]);
                IDictionary<string, string> dictsStatus = DictionaryHelper.GetDictionary("CONST_Bulletin_Status");
                model.LstStatus = JsonHelper.DataTableToArrayList(dictsStatus.ToList().ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(BulletinManageVO model)
        {
            try
            {
                Hashtable param = new Hashtable();

                if (!string.IsNullOrEmpty(model.QryUrgentDegree.ToSafeString()) && !string.IsNullOrEmpty(model.QryUrgentDegree.Key))
                {
                    param.Add("UrgentDegree", model.QryUrgentDegree.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryStatus.ToSafeString()) && !string.IsNullOrEmpty(model.QryStatus.Key))
                {
                    param.Add("Status", model.QryStatus.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryPublishedDate.StartDate))
                {
                    param.Add("PublishedBeginDate", model.QryPublishedDate.StartDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryPublishedDate.EndDate))
                {
                    param.Add("PublishedEndDate", model.QryPublishedDate.EndDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryExpirationDate.StartDate))
                {
                    param.Add("ExpirationBeginDate", model.QryExpirationDate.StartDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryExpirationDate.EndDate))
                {
                    param.Add("ExpirationEndDate", model.QryExpirationDate.EndDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryTitle))
                {
                    param.Add("Title", model.QryTitle.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryPublishedUser))
                {
                    param.Add("PublishedUser", model.QryPublishedUser.ToSafeString());
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = bll.QuerySelectMainByFilter(param, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        //明细
        public BulletinManageVO InitDetail(BulletinManageVO model)
        {
            try
            {
                IDictionary<string, string> dictsDegree = DictionaryHelper.GetDictionary("CONST_Bulletin_Important");
                model.LstUrgentDegree = JsonHelper.DataTableToArrayList(dictsDegree.ToList().ToDataSet().Tables[0]);
                IDictionary<string, string> dictsStatus = DictionaryHelper.GetDictionary("CONST_Bulletin_Status");
                model.LstStatus = JsonHelper.DataTableToArrayList(dictsStatus.ToList().ToDataSet().Tables[0]);
                IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
                model.LstDealerType = JsonHelper.DataTableToArrayList(dictsCompanyType.ToList().ToDataSet().Tables[0]);

                if (model.BulletId.ToSafeGuid() == Guid.Empty)
                {
                    model.WinIsEmptyId = true;
                    BulletinMain main = new BulletinMain();
                    model.BulletId = Guid.NewGuid().ToString();

                    var dictSingle = (from p in dictsStatus where p.Key == BulletinStatus.Draft.ToString() select p).ToList();
                    model.WinStatus = new KeyValue(dictSingle[0].Key, dictSingle[0].Value);

                    main.PublishedDate = DateTime.Now;
                    main.PublishedUser = new Guid(context.User.Id);
                    main.CreateDate = main.PublishedDate;
                    main.CreateUser = main.PublishedUser;
                    main.UpdateDate = DateTime.Now;
                    main.UpdateUser = new Guid(context.User.Id);
                    main.UpdateDate = DateTime.Now;
                    main.Status = BulletinStatus.Draft.ToString();
                    main.Id = new Guid(model.BulletId);
                    BulletinManageBLL b = new BulletinManageBLL();
                    b.InsertBulletinMain(main);
                }
                else
                {
                    BulletinMain main = bll.GetObjectById(new Guid(model.BulletId));

                    var dictUD = dictsDegree.Where(p => p.Key == main.UrgentDegree).ToList();
                    if (null != dictUD && dictUD.Any())
                    {
                        model.WinUrgentDegree = new KeyValue(dictUD[0].Key, dictUD[0].Value);
                    }
                    var dictSs = dictsStatus.Where(p => p.Key == main.Status).ToList();
                    if (null != dictSs && dictSs.Any())
                    {
                        model.WinStatus = new KeyValue(dictSs[0].Key, dictSs[0].Value);
                    }
                    model.WinExpirationDate = main.ExpirationDate;
                    model.WinIsRead = main.ReadFlag;
                    model.WinTitle = main.Title;
                    model.WinBody = main.Body;

                    model.WinHdStatus = main.Status;
                    if (main.PublishedUser.ToString().Equals(context.User.Id,StringComparison.OrdinalIgnoreCase))
                    {
                        model.WinIsPublisher = true;
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string QueryDetailInfo(BulletinManageVO model)
        {
            try
            {
                Hashtable param = new Hashtable();

                if (!string.IsNullOrEmpty(model.BulletId))
                    param.Add("BumId", model.BulletId.ToSafeString());

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = bll.QuerySelectDetailByFilter(param, start, model.PageSize, out totalCount);
                model.RstDealerDetailList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstDealerDetailList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public BulletinManageVO DeleteDealerItem(BulletinManageVO model)
        {
            try
            {
                bll.deatil(new Guid(model.DelDealerId));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string QueryFilterDealer(BulletinManageVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                DealerMasters dealer = new DealerMasters();

                if (!string.IsNullOrEmpty(model.WinFilterDealer))
                {
                    param.Add("ChineseName", model.WinFilterDealer.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinFilterSAPCode))
                {
                    param.Add("SapCode", model.WinFilterSAPCode.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinFilterDealerType.ToSafeString()) && !string.IsNullOrEmpty(model.WinFilterDealerType.Key.ToSafeString()))
                {
                    param.Add("DealerType", model.WinFilterDealerType.Key.ToSafeString());
                }

                param.Add("ActiveFlag", true);
                param.Add("HostCompanyFlag", false);
                param.Add("bumid", model.BulletId);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = dealer.GetDealerMaster(param, start, model.PageSize, out totalCount);
                model.RstFilterDealerResult = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstFilterDealerResult, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public BulletinManageVO SubmitSelection(BulletinManageVO model)
        {
            try
            {
                IList<BulletinDetail> sellist = new List<BulletinDetail>();
                foreach (string id in model.ChooseParam.Split(','))
                {
                    BulletinDetail item = new BulletinDetail();
                    item.Id = Guid.NewGuid();
                    item.BumId = new Guid(model.BulletId);
                    item.DealerDmaId = new Guid(id);

                    sellist.Add(item);
                }
                bll.InsertDetail(sellist);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string QueryAttachInfo(BulletinManageVO model)
        {
            try
            {
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = attachBll.GetAttachmentByMainId(new Guid(model.BulletId), AttachmentType.Bulletin, start, model.PageSize, out totalCount);
                model.RstAttachmentList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstAttachmentList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public BulletinManageVO DeleteAttach(BulletinManageVO model)
        {
            try
            {
                attachBll.DelAttachment(new Guid(model.DelAttachId));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public BulletinManageVO SaveBulletin(BulletinManageVO model)
        {
            try
            {
                BulletinMain main = new BulletinMain();
                if (!string.IsNullOrEmpty(model.WinUrgentDegree.Key.ToSafeString()))
                    main.UrgentDegree = model.WinUrgentDegree.Key.ToSafeString();

                if (!string.IsNullOrEmpty(model.WinHdStatus.ToSafeString()))
                    main.Status = model.WinHdStatus.ToSafeString();

                //Edited By Song Yuqi On 2013-9-2 Begin
                if (model.WinExpirationDate != DateTime.MinValue)
                {
                    main.ExpirationDate = model.WinExpirationDate;
                }
                else
                {
                    main.ExpirationDate = DateTime.MaxValue;
                }
                ////Edited By Song Yuqi On 2013-9-2 End

                if (!string.IsNullOrEmpty(model.WinTitle.ToSafeString()))
                    main.Title = model.WinTitle.ToSafeString();

                if (!string.IsNullOrEmpty(model.WinBody.ToSafeString()))
                    main.Body = model.WinBody.ToSafeString();

                main.ReadFlag = model.WinIsRead;

                main.Id = new Guid(model.BulletId);
                main.PublishedDate = DateTime.Now;
                main.PublishedUser = new Guid(context.User.Id);
                main.CreateDate = main.PublishedDate;
                main.CreateUser = main.PublishedUser;
                main.UpdateDate = DateTime.Now;

                bool result = bll.Updatemain(main);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public BulletinManageVO CancelledItem(BulletinManageVO model)
        {
            try
            {
                bool result = bll.CancelledItem(new Guid(model.BulletId));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public BulletinManageVO DeleteDraft(BulletinManageVO model)
        {
            try
            {
                bool result = bll.DeleteDraft(new Guid(model.BulletId));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        #endregion
    }
}
