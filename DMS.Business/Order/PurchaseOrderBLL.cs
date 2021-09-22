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
using DMS.Business.MasterData;
using System.Net;
using DMS.DataAccess.Consignment;
using Newtonsoft.Json.Linq;
using DMS.Business.ERPInterface;

namespace DMS.Business
{
    public class PurchaseOrderBLL : IPurchaseOrderBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IClientBLL _clientBLL = new ClientBLL();

        #region Action Define
        public const string Action_OrderApply = "OrderApply";
        public const string Action_OrderApplyLP = "OrderApplyLP";
        public const string Action_OrderAudit = "OrderAudit";
        public const string Action_OrderMake = "OrderMake";
        public const string Action_OrderSetting = "OrderSetting";
        #endregion

        /// <summary>
        /// 根据主键得到PurchaseOrderHeader对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public PurchaseOrderHeader GetPurchaseOrderHeaderById(Guid id)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.GetObject(id);
            }
        }

        /// <summary>
        /// 新增PurchaseOrderHeader对象
        /// </summary>
        /// <param name="obj"></param>
        public void InsertPurchaseOrderHeader(PurchaseOrderHeader obj)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                dao.Insert(obj);
            }
        }

        /// <summary>
        /// 经销商订单查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderApply, Description = "订单授权-二级订单申请", Permissoin = PermissionType.Read)]
        public DataSet QueryPurchaseOrderHeaderForDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.QueryPurchaseOrderHeaderByFilterForDealer(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// LP及一级经销商订单查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderApplyLP, Description = "订单授权-一级及平台订单申请", Permissoin = PermissionType.Read)]
        public DataSet QueryPurchaseOrderHeaderForLPDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.QueryPurchaseOrderHeaderByFilterForLPDealer(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// LP及一级经销商订单日志导出
        /// </summary>
        /// <param name="table"></param>      
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderApplyLP, Description = "订单授权-一级及平台订单申请", Permissoin = PermissionType.Read)]
        public DataSet ExportPurchaseOrderLogForLPDealer(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.ExportPurchaseOrderLogForLPDealer(table);
            }
        }

        /// <summary>
        /// LP及一级经销商订单发票导出
        /// </summary>
        /// <param name="table"></param>      
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderApplyLP, Description = "订单授权-一级及平台订单申请", Permissoin = PermissionType.Read)]
        public DataSet ExportPurchaseOrderInvoiceForLPDealer(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.ExportPurchaseOrderInvoiceForLPDealer(table);
            }
        }

        /// <summary>
        /// LP及一级经销商订单日志导出（For审核页面）
        /// </summary>
        /// <param name="table"></param>      
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderAudit, Description = "订单授权-订单审核", Permissoin = PermissionType.Read)]
        public DataSet ExportPurchaseOrderLogForLPDealerForAudit(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.ExportPurchaseOrderLogForLPDealerForAudit(table);
            }
        }

        /// <summary>
        /// LP及一级经销商订单明细导出
        /// </summary>
        /// <param name="table"></param>      
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderApplyLP, Description = "订单授权-一级及平台订单申请", Permissoin = PermissionType.Read)]
        public DataSet ExportPurchaseOrderDetailForLPDealer(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.ExportPurchaseOrderDetailByFilterForLPDealer(table);
            }
        }

        /// <summary>
        /// 二级经销商订单查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderApply, Description = "订单授权-二级订单申请", Permissoin = PermissionType.Read)]
        public DataSet QueryPurchaseOrderHeaderForT2Dealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.QueryPurchaseOrderHeaderByFilterForT2Dealer(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 二级经销商订单明细导出
        /// </summary>
        /// <param name="table"></param>     
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderApply, Description = "订单授权-二级订单申请", Permissoin = PermissionType.Read)]
        public DataSet ExportPurchaseOrderDetailForT2Dealer(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.ExportPurchaseOrderDetailByFilterForT2Dealer(table);
            }
        }

        /// <summary>
        /// BSC用户订单审核查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderAudit, Description = "订单授权-订单审核", Permissoin = PermissionType.Read)]
        public DataSet QueryPurchaseOrderHeaderForAudit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.QueryPurchaseOrderHeaderByFilterForAudit(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// BSC用户订单处理查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderMake, Description = "订单授权-订单处理", Permissoin = PermissionType.Read)]
        public DataSet QueryPurchaseOrderHeaderForMake(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.QueryPurchaseOrderHeaderByFilterForMake(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 根据明细行主键得到PurchaseOrderDetail对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public PurchaseOrderDetail GetPurchaseOrderDetailById(Guid id)
        {
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                return dao.GetObject(id);
            }
        }

        /// <summary>
        /// 新增PurchaseOrderDetail记录
        /// </summary>
        /// <param name="obj"></param>
        public void InsertPurchaseOrderDetail(PurchaseOrderDetail obj)
        {
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.Insert(obj);
            }
        }

        /// <summary>
        /// 根据过滤条件查询明细行
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderDetail(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                return dao.QueryPurchaseOrderDetailByFilter(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 根据订单表头主键查询明细行
        /// </summary>
        /// <param name="id"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderDetailByHeaderId(Guid id, int start, int limit, out int totalRowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("PohId", id);

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                return dao.QueryPurchaseOrderDetailByFilter(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 根据订单表头主键查询发货信息明细行
        /// </summary>
        /// <param name="id"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPoReceiptOrderDetailByHeaderId(Guid id, int start, int limit, out int totalRowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("Id", id);

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                return dao.QueryPoReceiptOrderDetailByFilter(table, start, limit, out totalRowCount);
            }
        }


        /// <summary>
        /// 根据订单表头主键查询明细行中是否已包含相同的lot号
        /// </summary>
        /// <param name="id"></param>
        /// <param name="lot"></param>     
        /// <returns></returns>
        public int QueryLotNumberCount(Guid detailId, string lot)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DetailId", detailId);
            ht.Add("Lot", lot);
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                return dao.QueryLotNumberCount(ht);
            }
        }


        /// <summary>
        /// 根据订单表头主键查询明细行中是否已包含相同的产品价格
        /// </summary>
        /// <param name="id"></param>
        /// <param name="lot"></param>     
        /// <returns></returns>
        public int QueryLotPriceCount(Guid DetailID, string UPN, string lot, string Price)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DetailId", DetailID);
            ht.Add("UPN", UPN);
            ht.Add("Lot", lot);
            ht.Add("Price", Price);
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                return dao.QueryLotPriceCount(ht);
            }
        }


        /// <summary>
        /// 根据订单表头主键查询明细行(For LP & T1)
        /// </summary>
        /// <param name="id"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>        
        public DataSet QueryLPPurchaseOrderDetailByHeaderId(Guid id, String virtualDCCode, int start, int limit, out int totalRowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("PohId", id);
            table.Add("VirtualDCCode", virtualDCCode);

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                return dao.QueryLPPurchaseOrderDetailByFilter(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryLPPurchaseOrderDetailByHeaderId(Guid id, String virtualDCCode)
        {
            Hashtable table = new Hashtable();
            table.Add("PohId", id);
            table.Add("VirtualDCCode", virtualDCCode);

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                return dao.QueryLPPurchaseOrderDetailByFilter(table);
            }
        }

        /// <summary>
        /// 订单操作日志
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="userId"></param>
        /// <param name="operType"></param>
        /// <param name="operNote"></param>
        public void InsertPurchaseOrderLog(Guid headerId, Guid userId, PurchaseOrderOperationType operType, string operNote)
        {
            using (PurchaseOrderLogDao dao = new PurchaseOrderLogDao())
            {
                PurchaseOrderLog log = new PurchaseOrderLog();
                log.Id = Guid.NewGuid();
                log.PohId = headerId;
                log.OperUser = userId;
                log.OperDate = DateTime.Now;
                log.OperType = operType.ToString();
                log.OperNote = operNote;
                dao.Insert(log);
            }
        }

        /// <summary>
        /// 订单操作接口
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="userId"></param>
        /// <param name="operType"></param>
        /// <param name="operNote"></param>
        public void InsertPurchaseOrderInterface(Guid headerId, Guid corpId, Guid userId, string orderNo)
        {

            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                PurchaseOrderInterface inter = new PurchaseOrderInterface();
                inter.Id = Guid.NewGuid();
                inter.BatchNbr = String.Empty;
                inter.RecordNbr = String.Empty;
                inter.PohId = headerId;
                inter.PohOrderNo = orderNo;
                inter.Status = PurchaseOrderMakeStatus.Pending.ToString();
                inter.ProcessType = PurchaseOrderCreateType.Manual.ToString();
                inter.CreateUser = userId;
                inter.CreateDate = DateTime.Now;
                inter.UpdateUser = userId;
                inter.UpdateDate = DateTime.Now;
                inter.Clientid = _clientBLL.GetParentClientByCorpId(corpId).Id;
                dao.Insert(inter);
            }
        }

        /// <summary>
        /// 订单操作接口（LP需要些一条自己clientId的记录）
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="userId"></param>
        /// <param name="operType"></param>
        /// <param name="operNote"></param>
        public void InsertPurchaseOrderInterfaceForLP(Guid headerId, Guid corpId, Guid userId, string orderNo)
        {

            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                PurchaseOrderInterface inter = new PurchaseOrderInterface();
                inter.Id = Guid.NewGuid();
                inter.BatchNbr = String.Empty;
                inter.RecordNbr = String.Empty;
                inter.PohId = headerId;
                inter.PohOrderNo = orderNo;
                inter.Status = PurchaseOrderMakeStatus.Pending.ToString();
                inter.ProcessType = PurchaseOrderCreateType.Manual.ToString();
                inter.CreateUser = userId;
                inter.CreateDate = DateTime.Now;
                inter.UpdateUser = userId;
                inter.UpdateDate = DateTime.Now;
                Client client = _clientBLL.GetClientByCorpId(corpId);
                if (client != null)
                {
                    inter.Clientid = _clientBLL.GetClientByCorpId(corpId).Id;
                    dao.Insert(inter);
                }
            }
        }

        /// <summary>
        /// 根据过滤条件查询操作日志
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderLog(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (PurchaseOrderLogDao dao = new PurchaseOrderLogDao())
            {
                return dao.QueryPurchaseOrderLogByFilter(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 根据订单表头主键查询操作日志
        /// </summary>
        /// <param name="id"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderLogByHeaderId(Guid id, int start, int limit, out int totalRowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("PohId", id);

            using (PurchaseOrderLogDao dao = new PurchaseOrderLogDao())
            {
                return dao.QueryPurchaseOrderLogByFilter(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 根据订单表头订单编号查询发票信息
        /// </summary>
        /// <param name="id"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryInvoiceByHeaderId(Guid id, int start, int limit, out int totalRowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("HeaderId", id);

            using (TIIfInvoiceDao dao = new TIIfInvoiceDao())
            {
                return dao.QueryInvoiceByFilter(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 根据经销商和产品线查询订单可销售区域
        /// </summary>
        /// <param name="dealerId"></param>
        /// <param name="productLineId"></param>
        /// <returns></returns>
        public DataSet QueryTerritoryMaster(Guid dealerId, Guid productLineId)
        {
            Hashtable table = new Hashtable();
            table.Add("DealerId", dealerId);
            table.Add("ProductLineId", productLineId);

            using (TerritoryMasterDao dao = new TerritoryMasterDao())
            {
                return dao.QueryTerritoryMasterForPurchaseOrder(table);
            }
        }

        /// <summary>
        /// 经销商默认收货地址
        /// </summary>
        /// <param name="dealerId"></param>
        /// <returns></returns>
        public DealerMaster GetDealerMasterByDealer(Guid dealerId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetObject(dealerId);
            }
        }

        /// <summary>
        /// 经销商订单相关信息
        /// </summary>
        /// <param name="dealerId"></param>
        /// <returns></returns>
        public DealerShipTo GetDealerShipToByUser(Guid userId)
        {
            using (DealerShipToDao dao = new DealerShipToDao())
            {
                return dao.GetDealerShipToByUser(userId);
            }
        }

        /// <summary>
        /// 保存草稿
        /// </summary>
        /// <param name="header"></param>
        /// <returns></returns>
        public bool SaveDraft(PurchaseOrderHeader header)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                if (header.OrderStatus == PurchaseOrderStatus.Draft.ToString())
                {
                    header.UpdateUser = new Guid(_context.User.Id);
                    header.UpdateDate = DateTime.Now;

                    headerDao.Update(header);
                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 删除草稿
        /// </summary>
        /// <param name="headerId"></param>
        /// <returns></returns>
        public bool DeleteDraft(Guid headerId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                PurchaseOrderLogDao logDao = new PurchaseOrderLogDao();

                //判断表头中状态是否是草稿
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                if (header.OrderStatus == PurchaseOrderStatus.Draft.ToString())
                {
                    //删除明细表
                    detailDao.DeletePurchaseOrderDetailByHeaderId(headerId);
                    //删除主表
                    headerDao.Delete(headerId);
                    //删除日志表
                    logDao.DeletePurchaseOrderLogByHeaderId(headerId);

                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 删除新增的修改单据
        /// </summary>
        /// <param name="headerId"></param>
        /// <returns></returns>
        public bool DiscardModify(Guid headerId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                PurchaseOrderLogDao logDao = new PurchaseOrderLogDao();

                //判断表头中订单创建类型是否是临时
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                if (header.CreateType == PurchaseOrderCreateType.Temporary.ToString())
                {
                    //删除明细表
                    detailDao.DeletePurchaseOrderDetailByHeaderId(headerId);
                    //删除主表
                    headerDao.Delete(headerId);
                    //删除日志表
                    logDao.DeletePurchaseOrderLogByHeaderId(headerId);

                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        private JToken SafeJTokenFromObject(Object ob)
        {
            if (ob == null)
            {
                return JToken.FromObject("");
            }
            else
            {
                return JToken.FromObject(ob);
            }
        }
        public string GetOrderXmlForERP(PurchaseOrderHeader headInfo, IList<PurchaseOrderDetail> listDetailInfo)
        {
            try
            {
                JObject data = new JObject();
                data.Add("IsVerifyBaseDataField", SafeJTokenFromObject(true));
                //ERP 是否需要审批
                data.Add("IsAutoSubmitAndAudit", SafeJTokenFromObject(false));

                // 基础信息
                JObject head = new JObject();
                //单据类型
                JObject FBillTypeID = new JObject();
                FBillTypeID.Add("FNumber", SafeJTokenFromObject("XSDD10"));
                head.Add("FBillTypeID", FBillTypeID);
                //销售组织分子公司
                JObject FSaleOrgId = new JObject();
                //FSaleOrgId.Add("FNumber", SafeJTokenFromObject(BaseService.CurrentSubCompany?.Key));
                string SaleOrgId = System.Configuration.ConfigurationManager.AppSettings["FSaleOrgId"];
                FSaleOrgId.Add("FNumber", SafeJTokenFromObject(SaleOrgId));
                head.Add("FSaleOrgId", FSaleOrgId);
                //销售日期
                head.Add("FDate", SafeJTokenFromObject(DateTime.Now.ToString("yyyy-MM-dd")));
                head.Add("FBillNo", SafeJTokenFromObject(headInfo.OrderNo));
                //ERPCode
                JObject FCustId = new JObject();
                DealerMasterDao dmd = new DealerMasterDao();
                IList<Hashtable> lhat = dmd.SelectDealerMainByDealerID(headInfo.DmaId);//this._context.User.CorpId
                string ERPCode = "";
                if (lhat.Count > 0)
                {
                    ERPCode = Convert.ToString(lhat[0]["ERPCode"]);
                }
                FCustId.Add("FNumber", SafeJTokenFromObject(ERPCode));
                head.Add("FCustId", FCustId);

                //销售人员
                JObject FSalerId = new JObject();
                string SaleId = System.Configuration.ConfigurationManager.AppSettings["FSalerId"];
                if (!string.IsNullOrEmpty(SaleId))
                {
                    FSalerId.Add("FNumber", SafeJTokenFromObject(SaleId));
                    head.Add("FSalerId", FSalerId);
                }

                //对方业务员
                JObject F_BGP_Property = new JObject();
                F_BGP_Property.Add("FNumber", SafeJTokenFromObject("销售员"));
                head.Add("F_BGP_Property", F_BGP_Property);

                //订单类型
                LafiteDao lfd = new LafiteDao();
                string SRT_Type = lfd.SelectOrderType("CONST_Order_Type", headInfo.OrderType);
                if (string.IsNullOrEmpty(SRT_Type))
                {
                    SRT_Type = "OR-N";
                }
                head.Add("F_SRT_Type", SafeJTokenFromObject(SRT_Type));

                //承运商
                head.Add("F_SRT_CYSLX", SafeJTokenFromObject(headInfo.TerritoryCode));

                //期望到货日期
                string rdd = "";
                if (headInfo.Rdd.HasValue)
                {
                    rdd = headInfo.Rdd.Value.ToString("yyyy-MM-dd");
                }
                head.Add("F_SRT_DeliveryDate", SafeJTokenFromObject(rdd));
                head.Add("F_SRT_Contact", SafeJTokenFromObject(headInfo.ContactPerson));
                head.Add("F_SRT_ContactType", SafeJTokenFromObject(headInfo.Contact));
                head.Add("F_SRT_ContactPhone", SafeJTokenFromObject(headInfo.ContactMobile));
                head.Add("FLinkMan", SafeJTokenFromObject(headInfo.Consignee));
                head.Add("FLinkPhone", SafeJTokenFromObject(headInfo.ConsigneePhone));
                SapWarehouseAddressDao sapDao = new SapWarehouseAddressDao();
                SapWarehouseAddress SWA = sapDao.GetObjectByCode(headInfo.ShipToAddress);
                if (SWA != null)
                {
                    head.Add("FReceiveAddress", SafeJTokenFromObject(SWA.WhAddress));
                }
                else
                {
                    head.Add("FReceiveAddress", SafeJTokenFromObject(""));
                }
                head.Add("FNote", SafeJTokenFromObject(headInfo.Remark));

                // 财务信息
                JObject finance = new JObject();
                //是否含税
                finance.Add("FIsIncludedTax", SafeJTokenFromObject(true));
                //价外税
                finance.Add("FIsPriceExcludeTax", SafeJTokenFromObject(true));
                //结算货币
                JObject FSettleCurrId = new JObject();
                FSettleCurrId.Add("FNumber", SafeJTokenFromObject("PRE001"));
                finance.Add("FSettleCurrId", FSettleCurrId);
                //汇率类型
                JObject FExchangeTypeId = new JObject();
                FExchangeTypeId.Add("FNumber", SafeJTokenFromObject("HLTX01_SYS"));
                finance.Add("FExchangeTypeId", FExchangeTypeId);
                //汇率
                finance.Add("FExchangeRate", SafeJTokenFromObject(1.0));
                head.Add("FSaleOrderFinance", finance);

                // 订单明细信息
                JArray entry = new JArray();
                for (int i = 0; i < listDetailInfo.Count; i++)
                {
                    JObject row = new JObject();
                    JObject FMaterialId = new JObject();
                    CfnDao cfndao = new CfnDao();
                    Cfn cfn = cfndao.GetCfn(listDetailInfo[i].CfnId);
                    string CustomerFaceNbr = cfn.ERPCode;
                    //物料编码
                    FMaterialId.Add("FNumber", SafeJTokenFromObject(CustomerFaceNbr));
                    row.Add("FMaterialId", FMaterialId);
                    //销售单位
                    JObject FUnitID = new JObject();
                    FUnitID.Add("FNumber", SafeJTokenFromObject(cfn.Property3));
                    row.Add("FUnitID", FUnitID);
                    //批号
                    JObject FLot = new JObject();
                    FLot.Add("FNumber", SafeJTokenFromObject(listDetailInfo[i].LotNumber));
                    row.Add("FLot", FLot);
                    //生产日期 显示
                    row.Add("F_BGP_ProductionDateDS", SafeJTokenFromObject("1"));
                    //有效期至 显示
                    row.Add("F_BGP_EffUnit", SafeJTokenFromObject("1"));
                    row.Add("FQty", SafeJTokenFromObject(listDetailInfo[i].RequiredQty));
                    row.Add("FTaxPrice", SafeJTokenFromObject(listDetailInfo[i].CfnPrice));
                    //换货订单增加无价格标识，否则无法传入ERP
                    if (SRT_Type == "OR-EPO")
                    {
                        row.Add("FIsFree", SafeJTokenFromObject(true));
                    }
                    entry.Add(row);
                }
                head.Add("FSaleOrderEntry", entry);
                data.Add("Model", head);
                return data.ToString();
            }
            catch (Exception ex)
            {
                return "";
            }
        }
        /// <summary>
        /// 提交订单
        /// </summary>
        /// <param name="header"></param>
        /// <returns></returns>
        public bool Submit(PurchaseOrderHeader header, String crossDockingNo)
        {
            bool result = false;
            bool processrunner = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                SpecialPriceDetailDao spDao = new SpecialPriceDetailDao();
                DealerShipToDao dealerShiptoDao = new DealerShipToDao();
                MailDeliveryAddressDao mailAddressDao = new MailDeliveryAddressDao();
                ISpecialPriceBLL speicalPrice = new SpecialPriceBLL();

                DealerMasterDao dmDao = new DealerMasterDao();

                AutoNumberBLL autoNbr = new AutoNumberBLL();
                if (header.OrderStatus == PurchaseOrderStatus.Draft.ToString() || header.CreateType == PurchaseOrderCreateType.Temporary.ToString())
                {

                    IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);

                    if (header.CreateType == PurchaseOrderCreateType.Temporary.ToString())
                    {
                        processrunner = true;
                    }

                    //如果是修改订单，则在最后的过程中更新订单编号
                    if (!header.CreateType.Equals(PurchaseOrderCreateType.Temporary.ToString()))
                    {
                        //header.OrderNo = autoNbr.GetNextAutoNumberForPO(header.DmaId.Value, OrderType.Next_PurchaseOrder, header.ProductLineBumId.Value, header.OrderType);
                        //20190925，添加分子编号及品牌
                        Hashtable ht = new Hashtable();
                        BaseService.AddCommonFilterCondition(ht);
                        Guid SubCompanyId = string.IsNullOrEmpty(Convert.ToString(ht["SubCompanyId"])) ? Guid.Empty : new Guid(Convert.ToString(ht["SubCompanyId"]));
                        Guid BrandId = string.IsNullOrEmpty(Convert.ToString(ht["BrandId"])) ? Guid.Empty : new Guid(Convert.ToString(ht["BrandId"]));
                        string No = autoNbr.GetNextAutoNumberForPO_PurchaseNew(header.DmaId.Value, OrderType.Next_PurchaseOrder, header.ProductLineBumId.Value, header.OrderType, SubCompanyId, BrandId);
                        header.OrderNo = No.Substring(0, No.Length > 30 ? 30 : No.Length);
                        //header.OrderType = PurchaseOrderCreateType.Manual.ToString();
                        //如果是清指定批号订单，判断是否修改过金额，如果修改过，单据号后+‘S’
                        //Edit By SongWeiming on 2018-10-23 清指定批号订单全部不会进行修改，所以不需要判断
                        //if (header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString())
                        //{
                        //    int cnt = Convert.ToInt32(detailDao.CheckUpdatePrice(header.Id).Tables[0].Rows[0]["cnt"].ToString());
                        //    if (cnt != 0)
                        //    {
                        //        header.OrderNo += "S";
                        //        processrunner = true;
                        //    }
                        //}
                        if (!String.IsNullOrEmpty(crossDockingNo))
                        {
                            header.OrderNo = header.OrderNo + "-" + crossDockingNo;
                        }
                    }
                    //如果是东方肝胆医院，且收货地址中包含‘安亭’在单据号后加AT
                    if (header.DmaId.ToString() == SR.CONST_PurchaseOrder_DFDMA && header.ShipToAddress.Contains("安亭"))
                    {
                        header.OrderNo += "AT";
                    }
                    header.SubmitUser = new Guid(this._context.User.Id);
                    header.SubmitDate = DateTime.Now;
                    header.UpdateUser = new Guid(this._context.User.Id);
                    header.UpdateDate = DateTime.Now;
                    header.OrderStatus = PurchaseOrderStatus.Submitted.ToString();
                    header.LatestAuditDate = DateTime.Now.AddHours(PurchaseOrderUtil.GetAuditWaitHour(header.ProductLineBumId.Value));
                    header.InvoiceComment = PurchaseOrderUtil.GetInvoiceComment(header, orderDetailList);
                    header.SendwmsFlg = 0;
                    //LP T1订单推送ERP

                    #region

                    if (this._context.User.CorpType.Equals(DealerType.LP.ToString()) || this._context.User.CorpType.Equals(DealerType.LS.ToString()) || this._context.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        bool interfaceBL = false;
                        string ERPXML = GetOrderXmlForERP(header, orderDetailList);
                        string errMsg = "";
                        if (string.IsNullOrEmpty(ERPXML))
                        {
                            interfaceBL = false;
                        }
                        else
                        {
                            OrderAndProduct oap = new OrderAndProduct();
                            interfaceBL = oap.AddSaleOrderToERP(header.Id.ToString(), ERPXML, out errMsg);

                        }
                        if (!interfaceBL)
                        {
                            header.OrderStatus = PurchaseOrderStatus.Submitted.ToString();
                            this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, "金蝶返回错误信息：" + errMsg);
                        }
                        else
                        {
                            this.InsertPurchaseOrderLog(header.Id, Guid.Empty, PurchaseOrderOperationType.Submit, "订单推送ERP成功");
                            header.OrderStatus = PurchaseOrderStatus.Uploaded.ToString();
                        }
                    }

                    #endregion

                    headerDao.Update(header);

                    //Edit by Songweiming on 2013-11-4 特殊价格选择暂时先不使用
                    //如果是特殊价格订单，则需要更新特殊价格信息表
                    //if (header.SpecialPriceid != null)
                    //{
                    //    //如果是临时订单，则需要将原有订单的数量先加上去
                    //    if (header.CreateType == PurchaseOrderCreateType.Temporary.ToString())
                    //    {
                    //        spDao.AddAvailableQtyByOrderIdForTemporaryOrder(header.Id, header.SpecialPriceid.Value);
                    //    }
                    //    spDao.UpdateAvailableQtyByOrderId(header.Id, header.SpecialPriceid.Value);
                    //}

                    //Edit by Songweiming on 2013-11-4 如果是特殊价格则先不写接口表   --Edit by huyong on 2014-7-3去掉此限制
                    //if (header.OrderType != PurchaseOrderType.SpecialPrice.ToString())
                    //{
                    //}

                    //Endo订单现已不需EF Rsm审批,去掉此限制 lijie edit 2016-10-23
                    //if (!(header.ProductLineBumId.ToString() == "8f15d92a-47e4-462f-a603-f61983d61b7b" && this._context.User.CorpType.ToString() == DealerType.T1.ToString()))
                    //{

                    //}



                    //如果是修改的订单，则需要删除原有订单，将现有订单更新为正式订单
                    if (header.CreateType.Equals(PurchaseOrderCreateType.Temporary.ToString()))
                    {
                        String rtnVal = "";
                        String rtnMsg = "";
                        headerDao.ActiveTemporaryOrder(header.Id, out rtnVal, out rtnMsg);
                        if (rtnVal == "Failure")
                        {
                            throw new Exception("Error in active temporary order");
                        }

                        IPurchaseOrderBLL _business = new PurchaseOrderBLL();
                        PurchaseOrderHeader Newheader = _business.GetPurchaseOrderHeaderById(header.Id);
                        header.OrderNo = Newheader.OrderNo;
                    }

                    //将订单类型为SAP无法处理的订单，通过文件接口的方式进行处理,包含特殊价格订单、组套设备订单、退货订单、外贸订单、近效期促销订单（DP）
                    if ((this._context.User.CorpType.Equals(DealerType.LP.ToString()) || this._context.User.CorpType.Equals(DealerType.LS.ToString()) || this._context.User.CorpType.Equals(DealerType.T1.ToString())) && ((header.OrderType == PurchaseOrderType.BOM.ToString() || header.OrderType == PurchaseOrderType.SpecialPrice.ToString() || header.OrderType == PurchaseOrderType.Return.ToString())))
                    //|| (header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString()) && processrunner)))
                    {
                        String rtnPRVal = "";
                        String rtnPRMsg = "";
                        this.InsertProcessRunnerInterface(header.Id, out rtnPRVal, out rtnPRMsg);
                        if (rtnPRVal == "Failure")
                        {
                            throw new Exception("Error in insert Process Runner");
                        }
                    }
                    else
                    {
                        //this.InsertPurchaseOrderInterface(header.Id, this._context.User.CorpId.Value, new Guid(this._context.User.Id), header.OrderNo);
                        this.InsertPurchaseOrderInterface(header.Id, header.DmaId.Value, new Guid(this._context.User.Id), header.OrderNo);
                    }

                    //LP订单要有一条自己的ClentId
                    if (this._context.User.CorpType.Equals(DealerType.LP.ToString()) || this._context.User.CorpType.Equals(DealerType.LS.ToString()) || this._context.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        //this.InsertPurchaseOrderInterfaceForLP(header.Id, this._context.User.CorpId.Value, new Guid(this._context.User.Id), header.OrderNo);
                        this.InsertPurchaseOrderInterfaceForLP(header.Id, header.DmaId.Value, new Guid(this._context.User.Id), header.OrderNo);
                    }
                    //订单操作日志
                    if (header.CreateType == PurchaseOrderCreateType.Temporary.ToString())
                    {
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, "修改订单");
                    }
                    else
                    {
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);
                    }

                    //update by hua 2018-10-14
                    //T1、LP 提交清货单后，创建补货单
                    if ((this._context.User.CorpType.Equals(DealerType.LP.ToString()) || this._context.User.CorpType.Equals(DealerType.LS.ToString()) || this._context.User.CorpType.Equals(DealerType.T1.ToString())) && (header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString()))
                    {
                        ConsignCommonDao ConsignDao = new ConsignCommonDao();
                        string rtnVal = "";
                        string rtnMsg = "";

                        Hashtable ht = new Hashtable();
                        BaseService.AddCommonFilterCondition(ht);
                        ConsignDao.ProcConsignPurchaseOrderCreate("KB", "KEOrderSubmit", Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), header.OrderNo, "1", out rtnVal, out rtnMsg);
                        if (!rtnVal.Equals("Success")) throw new Exception(rtnMsg);
                    }

                    //促销订单，需要扣减赠品池、记录Loge
                    if (header.OrderType.Equals(PurchaseOrderType.PRO.ToString()))
                    {
                        String rtnValPro = "";
                        String rtnMsgPro = "";
                        Hashtable proLoge = new Hashtable();
                        proLoge.Add("PohId", header.Id);
                        proLoge.Add("OrderSubType", "Submit");
                        proLoge.Add("RtnVal", rtnValPro);
                        proLoge.Add("RtnMsg", rtnMsgPro);
                        detailDao.PRODealerLargessUpdate(proLoge);
                        rtnValPro = proLoge["RtnVal"].ToString();
                        rtnMsgPro = proLoge["RtnMsg"].ToString();

                        if (rtnValPro == "Failure")
                        {
                            throw new Exception(rtnMsgPro.ToString());
                        }
                    }

                    //积分订单，需要重新验证积分并做扣减操作
                    if (header.OrderType.Equals(PurchaseOrderType.CRPO.ToString()))
                    {
                        String rtnValPro = "";
                        String rtnMsgPro = "";
                        Hashtable pointHas = new Hashtable();
                        pointHas.Add("POH_ID", header.Id);
                        pointHas.Add("RtnVal", rtnValPro);
                        pointHas.Add("RtnMsg", rtnMsgPro);
                        detailDao.OrderPointSubmint(pointHas);
                        rtnValPro = pointHas["RtnVal"].ToString();
                        rtnMsgPro = pointHas["RtnMsg"].ToString();

                        if (rtnValPro == "Failure")
                        {
                            throw new Exception(rtnMsgPro.ToString());
                        }

                    }
                    /*
                     * 二级促销暂时隐藏
                    //如果是二级经销商提交的促销或者积分订单需要扣减红票额度
                    if (_context.User.CorpType.ToString() == DealerType.T2.ToString() && (header.OrderType == PurchaseOrderType.PRO.ToString() || header.OrderType == PurchaseOrderType.CRPO.ToString()))
                    {
                        PurchaseOrderHeaderDao hdao = new PurchaseOrderHeaderDao();
                        string Rtnval = string.Empty;
                        string Rtmmsg = string.Empty;
                        hdao.PRODealerRedInvoice_Update(header.Id, "Submit", _context.User.CorpId.Value, header.ProductLineBumId.Value, out Rtnval, out Rtmmsg);
                        if (Rtnval == "Failure")
                        {
                            throw new Exception(Rtmmsg.ToString());
                        }
                    }*/

                    //直销医院提交清指定批号订单是要生成KB订单
                    IDealerMasters mast = new DealerMasters();
                    DealerMaster dma = mast.GetDealerMaster(header.DmaId.Value);
                    if (dma.Taxpayer == "直销医院" && header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString())
                    {
                        string RtnVal = string.Empty;
                        string RtnMsg = string.Empty;
                        headerDao.AddClearBorrowSubmitKbOrder(header.Id, out RtnVal, out RtnMsg);
                    }
                    //发送短信及邮件
                    try
                    {

                        PurchaseOrderHeader newHeader = headerDao.GetObject(header.Id);
                        //获取接收邮件及短信的人员
                        //需求更改：如果是二级的订单，则获取LP相关人员的账号（限定为接收邮件的人员）
                        //如果是LP或一级经销商的订单，则需要获取CS人员及BU相关人员，根据产品线进行设定

                        //传入当前经销商ID，然后获取对应的邮件地址
                        Hashtable ht = new Hashtable();
                        ht.Add("DmaId", this._context.User.CorpId.Value);
                        ht.Add("ProductLineID", newHeader.ProductLineBumId);
                        ht.Add("MailType", "Order");
                        IList<MailDeliveryAddress> mailList = mailAddressDao.QueryOrderMailAddressByConditions(ht);



                        //DealerShipTo dst = new DealerShipTo();
                        //dst = dealerShiptoDao.GetParentDealerEmailAddressByDmaId(this._context.User.CorpId.Value);

                        //获取经销商信息
                        DealerMaster dm = new DealerMaster();
                        dm = dmDao.GetObject(this._context.User.CorpId.Value);

                        if (mailList != null && mailList.Count > 0 && dm != null)
                        {
                            //获取订单包括的产品数及总金额
                            Decimal productNumber = 0;
                            Decimal orderPrice = 0;

                            foreach (PurchaseOrderDetail detail in orderDetailList)
                            {
                                productNumber += detail.RequiredQty.Value;
                                orderPrice += detail.Amount.Value;
                            }

                            StringBuilder sb = new StringBuilder();
                            DataSet ds = detailDao.SelectPurchaseOrderDetailByHeaderIdForMail(header.Id);
                            if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
                            {
                                //构造表格
                                sb.Append("<TABLE style=\"BACKGROUND: #ccccff; border:1px solid\" cellSpacing=\"3\" cellPadding=\"0\">");
                                sb.Append("<TBODY>");
                                //表头
                                sb.Append("<TR>");
                                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Division</SPAN></STRONG>");
                                sb.Append("</TD>");
                                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Level2</SPAN></STRONG>");
                                sb.Append("</TD>");
                                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Qty</SPAN></STRONG>");
                                sb.Append("</TD>");
                                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Amount</SPAN></STRONG>");
                                sb.Append("</TD>");
                                sb.Append("</TR>");

                                foreach (DataRow row in ds.Tables[0].Rows)
                                {
                                    sb.Append("<TR>");
                                    sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    sb.Append(row["Division"].ToString());
                                    sb.Append("</TD>");
                                    sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    sb.Append(row["Level2"].ToString());
                                    sb.Append("</TD>");
                                    sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    sb.Append(Convert.ToDecimal(row["Qty"].ToString()).ToString("f0"));
                                    sb.Append("</TD>");
                                    sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    sb.Append(Convert.ToDecimal(row["Amount"].ToString()).ToString("f2"));
                                    sb.Append("</TD>");
                                    sb.Append("</TR>");

                                }

                                //表尾
                                sb.Append("<TR>");
                                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                sb.Append("&nbsp;");
                                sb.Append("</TD>");
                                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Total</SPAN></STRONG>");
                                sb.Append("</TD>");
                                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">" + ((int)productNumber).ToString() + "</SPAN></STRONG>");
                                sb.Append("</TD>");
                                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">" + orderPrice.ToString("f2") + " RMB</SPAN></STRONG>");
                                sb.Append("</TD>");
                                sb.Append("</TR>");

                                sb.Append("</TBODY>");
                                sb.Append("</TABLE>");
                            }

                            MessageBLL msgBll = new MessageBLL();
                            foreach (MailDeliveryAddress mailAddress in mailList)
                            {
                                //邮件
                                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                                dictMailSubject.Add("Dealer", this._context.User.CorpName);
                                dictMailSubject.Add("OrderNo", newHeader.OrderNo);

                                dictMailBody.Add("Dealer", this._context.User.CorpName);
                                dictMailBody.Add("OrderDate", newHeader.SubmitDate.Value.ToString());
                                dictMailBody.Add("OrderNo", newHeader.OrderNo);
                                dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                                dictMailBody.Add("Summary", sb.ToString());
                                if (newHeader.SpecialPriceid != null && newHeader.SpecialPriceid.ToString() != "00000000-0000-0000-0000-000000000000")
                                {
                                    //获取SpecialPrice的政策名称
                                    DataSet spDS = null;
                                    spDS = speicalPrice.GetPromotionPolicyNameById(newHeader.SpecialPriceid.Value);
                                    dictMailBody.Add("SpecialPriceName", "<font color='red'>（特殊价格订单，促销政策：" + spDS.Tables[0].Rows[0]["PRName"].ToString() + ")</font>");
                                }
                                else
                                {
                                    dictMailBody.Add("SpecialPriceName", "");
                                }

                                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_SUBMIT, dictMailSubject, dictMailBody, mailAddress.MailAddress);
                            }

                            //短信
                            Dictionary<String, String> dictSMS = new Dictionary<String, String>();
                            dictSMS.Add("OrderDate", newHeader.SubmitDate.Value.ToShortDateString().ToString());
                            dictSMS.Add("OrderNo", newHeader.OrderNo);
                            dictSMS.Add("OrderAmount", orderPrice.ToString("f2"));
                            dictSMS.Add("ProductNumber", ((int)productNumber).ToString());
                            msgBll.AddToShortMessageQueue(ShortMessageTemplateCode.SMS_ORDER_SUBMIT, dictSMS, dm.Phone);

                        }

                    }
                    catch
                    {

                    }
                    //20191120,增加订单审核功能(订单状态是否需要删除确认之前节点？？)k
                    if (!this._context.User.CorpType.Equals(DealerType.T2.ToString()))
                    {
                        header = GetPurchaseOrderHeaderById(header.Id);
                        DealerShipToDao infoDao = new DealerShipToDao();
                        if (header.OrderStatus == PurchaseOrderStatus.Approved.ToString())
                        {
                            if (!header.IsLocked)
                            {
                                orderDetailList = detailDao.SelectByHeaderId(header.Id);
                                header.OrderStatus = PurchaseOrderStatus.Confirmed.ToString();
                                headerDao.Update(header);
                                //订单操作日志
                                this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Confirm, null);

                                //平台提交清指定批号订单是要生成KB订单（对于其中的长期寄售部分）
                                //IDealerMasters mast = new DealerMasters();
                                //DealerMaster dma = mast.GetDealerMaster(header.DmaId.Value);
                                //if (dma.DealerType == "LP" && header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString())
                                //{
                                //    string RtnVal = string.Empty;
                                //    string RtnMsg = string.Empty;
                                //    headerDao.AddClearBorrowConfirmKBOrder(header.Id, out RtnVal, out RtnMsg);
                                //}

                                //发送邮件
                                try
                                {
                                    DealerShipTo dst = new DealerShipTo();
                                    dst = infoDao.GetParentDealerEmailAddressByDmaId(this._context.User.CorpId.Value);

                                    if (dst != null)
                                    {
                                        //获取订单包括的产品数及总金额
                                        Decimal productNumber = 0;
                                        Decimal orderPrice = 0;

                                        foreach (PurchaseOrderDetail detail in orderDetailList)
                                        {
                                            productNumber += detail.RequiredQty.Value;
                                            orderPrice += detail.Amount.Value;
                                        }

                                        MessageBLL msgBll = new MessageBLL();
                                        //邮件
                                        Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                        Dictionary<String, String> dictMailBody = new Dictionary<String, String>();

                                        dictMailSubject.Add("Approver", this._context.User.CorpName);
                                        dictMailSubject.Add("OrderNo", header.OrderNo);

                                        dictMailBody.Add("Approver", this._context.User.CorpName);
                                        dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                                        dictMailBody.Add("OrderNo", header.OrderNo);
                                        dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                        dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                                        msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_CONFIRM, dictMailSubject, dictMailBody, dst.Email);

                                    }
                                }
                                catch
                                {

                                }
                            }
                        }
                    }
                    //20191120,增加订单审核功能
                    result = true;
                }
                trans.Complete();
            }

            //Endo产品线的T1经销商已不需要EW审批，去掉此限制 lijie Edit 2016-10-23
            //if (header.ProductLineBumId.ToString() == "8f15d92a-47e4-462f-a603-f61983d61b7b" && this._context.User.CorpType.ToString() == DealerType.T1.ToString())
            //{
            //    if ("1" != SR.CONST_DMS_DEVELOP)
            //    {
            //        EwfService.WfAction wfAction = new EwfService.WfAction();
            //        wfAction.Credentials = new NetworkCredential(SR.CONST_EWF_USER_NAME, SR.CONST_EWF_USER_PWD, SR.CONST_EWF_DOMAIN);

            //        string template = WorkflowTemplate.EndoOrderTemplate.Clone().ToString();
            //        string rtnVal = string.Empty;
            //        string rtnMsg = string.Empty;
            //        string userAccount = "";
            //        Hashtable ht = new Hashtable();
            //        ht.Add("DmaId", header.DmaId);
            //        ht.Add("ProductLineBumId", header.ProductLineBumId);
            //        DataSet ds = SelectSalesByDealerAndProductLine(ht);
            //        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            //        {
            //            userAccount = string.IsNullOrEmpty(header.SalesAccount) ? ds.Tables[0].Rows[0]["UserAccount"].ToString() : header.SalesAccount;
            //        }

            //        bool flag = GetApplyOrderHtml(header.Id, out rtnVal, out rtnMsg);
            //        if (flag)
            //        {
            //            template = string.Format(template, SR.CONST_ENDO_ORDER_NO, userAccount, userAccount, "", header.OrderNo, rtnMsg);

            //            wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);

            //        }
            //    }
            //}
            return result;
        }

        public bool PushToERP(PurchaseOrderHeader header, out string errMsg)
        {
            errMsg = "";
            bool interfaceBL = false;
            #region
            PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
            PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
            IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);
            if (this._context.User.CorpType == null || this._context.User.CorpType.Equals(DealerType.LP.ToString()) || this._context.User.CorpType.Equals(DealerType.LS.ToString()) || this._context.User.CorpType.Equals(DealerType.T1.ToString()))
            {

                string ERPXML = GetOrderXmlForERP(header, orderDetailList);
                if (string.IsNullOrEmpty(ERPXML))
                {
                    interfaceBL = false;
                }
                else
                {
                    OrderAndProduct oap = new OrderAndProduct();
                    interfaceBL = oap.AddSaleOrderToERP(header.Id.ToString(), ERPXML, out errMsg);

                }
                if (!interfaceBL)
                {
                    this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, "金蝶返回错误信息：" + errMsg);
                }
                else
                {
                    this.InsertPurchaseOrderLog(header.Id, Guid.Empty, PurchaseOrderOperationType.Submit, "订单推送ERP成功");
                    header.OrderStatus = PurchaseOrderStatus.Uploaded.ToString();
                    headerDao.Update(header);
                }
            }
            return interfaceBL;
            #endregion
        }
        /// <summary>
        /// 订单同意
        /// </summary>
        /// <param name="headerId"></param>
        /// <returns></returns>
        public bool Agree(Guid headerId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                DealerShipToDao infoDao = new DealerShipToDao();
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                if (header.OrderStatus == PurchaseOrderStatus.Submitted.ToString() || header.OrderStatus == PurchaseOrderStatus.Approved.ToString() || header.OrderStatus == PurchaseOrderStatus.Uploaded.ToString())
                {
                    if (!header.IsLocked)
                    {
                        IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);

                        header.OrderStatus = PurchaseOrderStatus.Confirmed.ToString();
                        headerDao.Update(header);
                        //订单操作日志
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Confirm, null);

                        //平台提交清指定批号订单是要生成KB订单（对于其中的长期寄售部分）
                        //IDealerMasters mast = new DealerMasters();
                        //DealerMaster dma = mast.GetDealerMaster(header.DmaId.Value);
                        //if (dma.DealerType == "LP" && header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString())
                        //{
                        //    string RtnVal = string.Empty;
                        //    string RtnMsg = string.Empty;
                        //    headerDao.AddClearBorrowConfirmKBOrder(header.Id, out RtnVal, out RtnMsg);
                        //}

                        //发送邮件
                        try
                        {
                            DealerShipTo dst = new DealerShipTo();
                            dst = infoDao.GetParentDealerEmailAddressByDmaId(this._context.User.CorpId.Value);

                            if (dst != null)
                            {
                                //获取订单包括的产品数及总金额
                                Decimal productNumber = 0;
                                Decimal orderPrice = 0;

                                foreach (PurchaseOrderDetail detail in orderDetailList)
                                {
                                    productNumber += detail.RequiredQty.Value;
                                    orderPrice += detail.Amount.Value;
                                }

                                MessageBLL msgBll = new MessageBLL();
                                //邮件
                                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();

                                dictMailSubject.Add("Approver", this._context.User.CorpName);
                                dictMailSubject.Add("OrderNo", header.OrderNo);

                                dictMailBody.Add("Approver", this._context.User.CorpName);
                                dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                                dictMailBody.Add("OrderNo", header.OrderNo);
                                dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_CONFIRM, dictMailSubject, dictMailBody, dst.Email);

                            }
                        }
                        catch
                        {

                        }

                        result = true;
                    }
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 订单拒绝
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="note"></param>
        /// <returns></returns>
        public bool Reject(Guid headerId, string note)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                DealerShipToDao infoDao = new DealerShipToDao();
                SpecialPriceDetailDao spDao = new SpecialPriceDetailDao();
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                DealerShipTo info = infoDao.GetDealerShipToByUser(header.CreateUser.Value);

                //订单状态为：已提交、已审批、已上传SAP，可以拒绝
                if (header.OrderStatus == PurchaseOrderStatus.Submitted.ToString() || header.OrderStatus == PurchaseOrderStatus.Approved.ToString() || header.OrderStatus == PurchaseOrderStatus.Uploaded.ToString())
                {
                    if (!header.IsLocked)
                    {
                        header.OrderStatus = PurchaseOrderStatus.Rejected.ToString();
                        headerDao.Update(header);
                        //订单操作日志
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Reject, note);
                        //如果是特殊价格订单，则拒绝操作需要增加可用特殊价格库存
                        if (PurchaseOrderType.SpecialPrice.ToString().Equals(header.OrderType) && header.SpecialPriceid != null)
                        {
                            spDao.AddAvailableQtyByOrderId(header.Id, header.SpecialPriceid.Value);

                        }

                        //发送短信及邮件
                        try
                        {
                            this.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_REJECTED, header, info);
                            this.AddToShortMessageQueue(ShortMessageTemplateCode.SMS_ORDER_REJECTED, header, info);
                        }
                        catch
                        {

                        }
                        result = true;
                    }
                }
                trans.Complete();
            }
            return result;
        }


        /// <summary>
        /// 订单撤销确认
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="note"></param>
        /// <returns></returns>
        public bool RevokeConfirm(Guid headerId, string note)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                DealerShipToDao infoDao = new DealerShipToDao();
                SpecialPriceDetailDao spDao = new SpecialPriceDetailDao();
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                DealerShipTo info = infoDao.GetDealerShipToByUser(header.CreateUser.Value);


                //订单状态为：撤销申请中，可以进行撤销
                if (header.OrderStatus == PurchaseOrderStatus.Revoking.ToString())
                {
                    if (!header.IsLocked)
                    {
                        IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);

                        header.OrderStatus = PurchaseOrderStatus.Revoked.ToString();
                        headerDao.Update(header);


                        //订单操作日志
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Revoked, note);

                        //如果是特殊价格订单，则拒绝操作需要增加可用特殊价格库存
                        if (PurchaseOrderType.SpecialPrice.ToString().Equals(header.OrderType) && header.SpecialPriceid != null)
                        {
                            spDao.AddAvailableQtyByOrderId(header.Id, header.SpecialPriceid.Value);

                        }

                        if (header.OrderType.Equals(PurchaseOrderType.PRO.ToString()))
                        {
                            String rtnValPro = "";
                            String rtnMsgPro = "";
                            Hashtable proLoge = new Hashtable();
                            proLoge.Add("PohId", header.Id);
                            proLoge.Add("OrderSubType", "Revoking");
                            proLoge.Add("RtnVal", rtnValPro);
                            proLoge.Add("RtnMsg", rtnMsgPro);
                            detailDao.PRODealerLargessUpdate(proLoge);
                            rtnValPro = proLoge["RtnVal"].ToString();
                            rtnMsgPro = proLoge["RtnMsg"].ToString();

                            if (rtnValPro == "Failure")
                            {
                                throw new Exception(rtnMsgPro.ToString());
                            }
                        }
                        //撤销积分使用额度
                        if (header.OrderType.Equals(PurchaseOrderType.CRPO.ToString()))
                        {
                            String rtnValPoint = "";
                            String rtnMsgPoint = "";
                            Hashtable point = new Hashtable();
                            point.Add("POH_ID", header.Id);
                            point.Add("RtnVal", rtnValPoint);
                            point.Add("RtnMsg", rtnMsgPoint);
                            detailDao.OrderPointRevok(point);
                            rtnValPoint = point["RtnVal"].ToString();
                            rtnMsgPoint = point["RtnMsg"].ToString();

                            if (rtnValPoint == "Failure")
                            {
                                throw new Exception(rtnMsgPoint.ToString());
                            }
                        }

                        //发送邮件
                        try
                        {
                            if (info != null)
                            {
                                //获取订单包括的产品数及总金额
                                Decimal productNumber = 0;
                                Decimal orderPrice = 0;

                                foreach (PurchaseOrderDetail detail in orderDetailList)
                                {
                                    productNumber += detail.RequiredQty.Value;
                                    orderPrice += detail.Amount.Value;
                                }

                                MessageBLL msgBll = new MessageBLL();
                                //邮件
                                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();

                                dictMailSubject.Add("Approver", this._context.User.CorpName);
                                dictMailSubject.Add("OrderNo", header.OrderNo);

                                dictMailBody.Add("Approver", this._context.User.CorpName);
                                dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                                dictMailBody.Add("OrderNo", header.OrderNo);
                                dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_REVOKECONFIRM, dictMailSubject, dictMailBody, info.Email);

                            }
                        }
                        catch
                        {

                        }
                        result = true;
                    }
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 订单关闭
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="note"></param>
        /// <returns></returns>
        public bool CompleteOrder(Guid headerId, string note)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                DealerShipToDao infoDao = new DealerShipToDao();
                SpecialPriceDetailDao spDao = new SpecialPriceDetailDao();
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                DealerShipTo info = infoDao.GetDealerShipToByUser(header.CreateUser.Value);

                //订单状态为：申请关闭订单，才可以关闭
                if (header.OrderStatus == PurchaseOrderStatus.ApplyComplete.ToString())
                {
                    if (!header.IsLocked)
                    {
                        IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);

                        //获取明细，然后填写备注
                        String remark = header.Remark + "订单关闭成功：";
                        DataSet ds = detailDao.SelectPurchaseOrderDetailByHeaderIdForOrderComplete(header.Id);
                        if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow row in ds.Tables[0].Rows)
                            {

                                if (Convert.ToInt32(row["RequiredQty"]) > Convert.ToInt32(row["ReceiptQty"]))
                                {
                                    remark = remark + row["UPN"].ToString() + "撤销数量" + (Convert.ToInt32(row["RequiredQty"]) - Convert.ToInt32(row["ReceiptQty"])).ToString() + ";";
                                }
                            }
                        }

                        header.OrderStatus = PurchaseOrderStatus.Completed.ToString();
                        header.Remark = remark;
                        headerDao.Update(header);

                        //更新明细行信息(修改订单数量及明细行价格)
                        //detailDao.UpdatePurchaseOrderDetailForOrderComplete(header.Id.ToString());

                        Guid idUser = this._context?.User != null&&!string.IsNullOrEmpty(this._context.User.Id)
                            ? new Guid(this._context.User.Id)
                            : Guid.Empty;
                        //订单操作日志
                        this.InsertPurchaseOrderLog(header.Id, idUser, PurchaseOrderOperationType.Complete, note);

                        //发送邮件
                        try
                        {


                            if (info != null)
                            {
                                //获取订单包括的产品数及总金额
                                Decimal productNumber = 0;
                                Decimal orderPrice = 0;

                                foreach (PurchaseOrderDetail detail in orderDetailList)
                                {
                                    productNumber += detail.RequiredQty.Value;
                                    orderPrice += detail.Amount.Value;
                                }

                                MessageBLL msgBll = new MessageBLL();
                                //邮件
                                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();

                                string strApprover = this._context?.User != null &&
                                                     !string.IsNullOrEmpty(this._context.User.CorpName)
                                    ? this._context.User.CorpName
                                    : "system";

                                dictMailSubject.Add("Approver", strApprover);
                                dictMailSubject.Add("OrderNo", header.OrderNo);

                                dictMailBody.Add("Approver", strApprover);
                                dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                                dictMailBody.Add("OrderNo", header.OrderNo);
                                dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_CLOSE, dictMailSubject, dictMailBody, info.Email);

                            }
                        }
                        catch
                        {

                        }
                        result = true;
                    }
                }
                trans.Complete();
            }
            return result;
        }


        /// <summary>
        /// 拒绝撤销订单
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="note"></param>
        /// <returns></returns>
        public bool RejectRevoke(Guid headerId, string note)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                DealerShipToDao infoDao = new DealerShipToDao();
                SpecialPriceDetailDao spDao = new SpecialPriceDetailDao();
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                DealerShipTo info = infoDao.GetDealerShipToByUser(header.CreateUser.Value);

                //订单状态为：申请撤销，才可以拒绝撤销
                if (header.OrderStatus == PurchaseOrderStatus.Revoking.ToString())
                {
                    if (!header.IsLocked)
                    {
                        IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);

                        header.OrderStatus = PurchaseOrderStatus.Uploaded.ToString();
                        headerDao.Update(header);

                        //订单操作日志
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.RejectRevoke, note);

                        //发送邮件
                        try
                        {


                            if (info != null)
                            {
                                //获取订单包括的产品数及总金额
                                Decimal productNumber = 0;
                                Decimal orderPrice = 0;

                                foreach (PurchaseOrderDetail detail in orderDetailList)
                                {
                                    productNumber += detail.RequiredQty.Value;
                                    orderPrice += detail.Amount.Value;
                                }

                                MessageBLL msgBll = new MessageBLL();
                                //邮件
                                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();

                                dictMailSubject.Add("Approver", this._context.User.CorpName);
                                dictMailSubject.Add("OrderNo", header.OrderNo);

                                dictMailBody.Add("Approver", this._context.User.CorpName);
                                dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                                dictMailBody.Add("OrderNo", header.OrderNo);
                                dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_REJECTREVOKE, dictMailSubject, dictMailBody, info.Email);

                            }
                        }
                        catch
                        {

                        }
                        result = true;
                    }
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 拒绝关闭订单
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="note"></param>
        /// <returns></returns>
        public bool RejectComplete(Guid headerId, string note)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                DealerShipToDao infoDao = new DealerShipToDao();
                SpecialPriceDetailDao spDao = new SpecialPriceDetailDao();
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                DealerShipTo info = infoDao.GetDealerShipToByUser(header.CreateUser.Value);

                //订单状态为：申请关闭，才可以拒绝关闭
                if (header.OrderStatus == PurchaseOrderStatus.ApplyComplete.ToString())
                {
                    if (!header.IsLocked)
                    {
                        IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);

                        header.OrderStatus = PurchaseOrderStatus.Delivering.ToString();
                        headerDao.Update(header);

                        //订单操作日志
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.RejectComplete, note);

                        //发送邮件
                        try
                        {


                            if (info != null)
                            {
                                //获取订单包括的产品数及总金额
                                Decimal productNumber = 0;
                                Decimal orderPrice = 0;

                                foreach (PurchaseOrderDetail detail in orderDetailList)
                                {
                                    productNumber += detail.RequiredQty.Value;
                                    orderPrice += detail.Amount.Value;
                                }

                                MessageBLL msgBll = new MessageBLL();
                                //邮件
                                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();

                                dictMailSubject.Add("Approver", this._context.User.CorpName);
                                dictMailSubject.Add("OrderNo", header.OrderNo);

                                dictMailBody.Add("Approver", this._context.User.CorpName);
                                dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                                dictMailBody.Add("OrderNo", header.OrderNo);
                                dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_REJECTCOMPLETE, dictMailSubject, dictMailBody, info.Email);

                            }
                        }
                        catch
                        {

                        }
                        result = true;
                    }
                }
                trans.Complete();
            }
            return result;
        }
        /// <summary>
        /// LP及T1订单撤销
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="note"></param>
        /// <returns></returns>
        public bool RevokeLPOrder(Guid headerId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                PurchaseOrderInterfaceDao orderInterfaceDao = new PurchaseOrderInterfaceDao();
                DealerShipToDao infoDao = new DealerShipToDao();
                SpecialPriceDetailDao spDao = new SpecialPriceDetailDao();
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                DealerShipTo info = infoDao.GetDealerShipToByUser(header.CreateUser.Value);
                DealerMasterDao dmDao = new DealerMasterDao();
                MailDeliveryAddressDao mailAddressDao = new MailDeliveryAddressDao();

                //订单状态为：已提交、已同意、已上传SAP，可以撤销
                //状态=已提交、已同意：不需要审批，直接修改状态为“已撤销”,同时修改interface表中订单状态
                //状态=已上传SAP：修改单据状态为“申请撤销”，不修改interface表中订单状态

                //20191120，直接撤销，删除撤销进行中过程
                //if (header.OrderStatus == PurchaseOrderStatus.Submitted.ToString() || header.OrderStatus == PurchaseOrderStatus.Approved.ToString() || header.OrderStatus == PurchaseOrderStatus.Uploaded.ToString())
                //{
                if (!header.IsLocked)
                {
                    IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);

                    //订单状态为“已提交”、“已同意”
                    int lenON = header.OrderNo.Length;
                    if ((header.OrderStatus == PurchaseOrderStatus.Submitted.ToString() || header.OrderStatus == PurchaseOrderStatus.Approved.ToString()) && header.OrderNo.Substring(lenON - 2, 1) != "V")
                    {
                        //修改状态
                        header.OrderStatus = PurchaseOrderStatus.Revoked.ToString();
                        headerDao.Update(header);

                        //修改interface表中订单的状态
                        orderInterfaceDao.UpdatePurchaseOrderInterfaceStatusCancelled(header.Id.ToString());

                        //订单操作日志
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Revoked, null);
                        //如果是特殊价格订单，则拒绝操作需要增加可用特殊价格库存
                        if (PurchaseOrderType.SpecialPrice.ToString().Equals(header.OrderType) && header.SpecialPriceid != null)
                        {
                            spDao.AddAvailableQtyByOrderId(header.Id, header.SpecialPriceid.Value);
                        }

                        //积分、促销订单撤回额度
                        if (header.OrderType.Equals(PurchaseOrderType.PRO.ToString()))
                        {
                            String rtnValPro = "";
                            String rtnMsgPro = "";
                            Hashtable proLoge = new Hashtable();
                            proLoge.Add("PohId", header.Id);
                            proLoge.Add("OrderSubType", "Revoking");
                            proLoge.Add("RtnVal", rtnValPro);
                            proLoge.Add("RtnMsg", rtnMsgPro);
                            detailDao.PRODealerLargessUpdate(proLoge);
                            rtnValPro = proLoge["RtnVal"].ToString();
                            rtnMsgPro = proLoge["RtnMsg"].ToString();

                            if (rtnValPro == "Failure")
                            {
                                throw new Exception(rtnMsgPro.ToString());
                            }
                        }
                        //撤销积分使用额度
                        if (header.OrderType.Equals(PurchaseOrderType.CRPO.ToString()))
                        {
                            String rtnValPoint = "";
                            String rtnMsgPoint = "";
                            Hashtable point = new Hashtable();
                            point.Add("POH_ID", header.Id);
                            point.Add("RtnVal", rtnValPoint);
                            point.Add("RtnMsg", rtnMsgPoint);
                            detailDao.OrderPointRevok(point);
                            rtnValPoint = point["RtnVal"].ToString();
                            rtnMsgPoint = point["RtnMsg"].ToString();

                            if (rtnValPoint == "Failure")
                            {
                                throw new Exception(rtnMsgPoint.ToString());
                            }
                        }
                        //}
                        //else
                        //{
                        //    //修改状态
                        //    header.OrderStatus = PurchaseOrderStatus.Revoking.ToString();
                        //    headerDao.Update(header);

                        //    //订单操作日志
                        //    this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Revoking, null);
                        //}


                        //发送短信及邮件
                        try
                        {

                            //获取接收邮件及短信的人员
                            //如果是LP的订单，则获取对应HQ人员的账号；如果是二级的订单，则获取LP相关人员的账号
                            //传入当前经销商ID，然后获取对应的邮件地址
                            Hashtable ht = new Hashtable();
                            ht.Add("DmaId", this._context.User.CorpId.Value);
                            ht.Add("ProductLineID", header.ProductLineBumId);
                            ht.Add("MailType", "Order");
                            IList<MailDeliveryAddress> mailList = mailAddressDao.QueryOrderMailAddressByConditions(ht);

                            //获取经销商信息
                            DealerMaster dm = new DealerMaster();
                            dm = dmDao.GetObject(this._context.User.CorpId.Value);

                            if (mailList != null && mailList.Count > 0 && dm != null)
                            {
                                //获取订单包括的产品数及总金额
                                Decimal productNumber = 0;
                                Decimal orderPrice = 0;

                                foreach (PurchaseOrderDetail detail in orderDetailList)
                                {
                                    productNumber += detail.RequiredQty.Value;
                                    orderPrice += detail.Amount.Value;
                                }

                                MessageBLL msgBll = new MessageBLL();
                                foreach (MailDeliveryAddress mailAddress in mailList)
                                {
                                    //邮件
                                    Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                    Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                                    dictMailSubject.Add("Dealer", this._context.User.CorpName);
                                    dictMailSubject.Add("OrderNo", header.OrderNo);

                                    dictMailBody.Add("Dealer", this._context.User.CorpName);
                                    dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                                    dictMailBody.Add("OrderNo", header.OrderNo);
                                    dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                    dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                                    msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_REVOKE, dictMailSubject, dictMailBody, mailAddress.MailAddress);
                                }


                                //短信
                                Dictionary<String, String> dictSMS = new Dictionary<String, String>();
                                dictSMS.Add("OrderDate", header.SubmitDate.Value.ToShortDateString().ToString());
                                dictSMS.Add("OrderNo", header.OrderNo);
                                dictSMS.Add("OrderAmount", orderPrice.ToString("f2"));
                                dictSMS.Add("ProductNumber", ((int)productNumber).ToString());
                                msgBll.AddToShortMessageQueue(ShortMessageTemplateCode.SMS_ORDER_REVOKE, dictSMS, dm.Phone);

                            }
                        }
                        catch
                        {

                        }
                        result = true;
                    }
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// LP及T1订单关闭申请
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="note"></param>
        /// <returns></returns>
        public bool CloseLPOrder(Guid headerId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                PurchaseOrderInterfaceDao orderInterfaceDao = new PurchaseOrderInterfaceDao();
                DealerShipToDao infoDao = new DealerShipToDao();
                SpecialPriceDetailDao spDao = new SpecialPriceDetailDao();
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                DealerShipTo info = infoDao.GetDealerShipToByUser(header.CreateUser.Value);
                DealerMasterDao dmDao = new DealerMasterDao();
                MailDeliveryAddressDao mailAddressDao = new MailDeliveryAddressDao();

                //订单状态为：部分发货，才可以申请关闭订单
                if (header.OrderStatus == PurchaseOrderStatus.Delivering.ToString())
                {
                    if (!header.IsLocked)
                    {
                        IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);


                        //修改状态
                        header.OrderStatus = PurchaseOrderStatus.ApplyComplete.ToString();
                        headerDao.Update(header);

                        //订单操作日志
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.ApplyComplete, null);


                        //发送短信及邮件
                        try
                        {

                            //获取接收邮件的人员
                            //如果是LP的订单，则获取对应HQ人员的账号；如果是二级的订单，则获取LP相关人员的账号
                            Hashtable ht = new Hashtable();
                            ht.Add("DmaId", this._context.User.CorpId.Value);
                            ht.Add("ProductLineID", header.ProductLineBumId);
                            ht.Add("MailType", "Order");
                            IList<MailDeliveryAddress> mailList = mailAddressDao.QueryOrderMailAddressByConditions(ht);

                            if (mailList != null && mailList.Count > 0)
                            {
                                //获取订单包括的产品数及总金额
                                Decimal productNumber = 0;
                                Decimal orderPrice = 0;

                                foreach (PurchaseOrderDetail detail in orderDetailList)
                                {
                                    productNumber += detail.RequiredQty.Value;
                                    orderPrice += detail.Amount.Value;
                                }

                                MessageBLL msgBll = new MessageBLL();
                                foreach (MailDeliveryAddress mailAddress in mailList)
                                {
                                    //邮件
                                    Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                    Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                                    dictMailSubject.Add("Dealer", this._context.User.CorpName);
                                    dictMailSubject.Add("OrderNo", header.OrderNo);

                                    dictMailBody.Add("Dealer", this._context.User.CorpName);
                                    dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                                    dictMailBody.Add("OrderNo", header.OrderNo);
                                    dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                    dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                                    msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_APPLYCOMPLETE, dictMailSubject, dictMailBody, mailAddress.MailAddress);
                                }
                            }
                        }
                        catch
                        {

                        }
                        result = true;
                    }
                }

                //20191120，删除审核关闭，直接关闭
                //header = headerDao.GetObject(headerId);
                ////订单状态为：申请关闭订单，才可以关闭
                //if (header.OrderStatus == PurchaseOrderStatus.ApplyComplete.ToString())
                //{
                //    if (!header.IsLocked)
                //    {
                //        IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);
                //        //获取明细，然后填写备注
                //        String remark = header.Remark + "订单关闭成功：";
                //        DataSet ds = detailDao.SelectPurchaseOrderDetailByHeaderIdForOrderComplete(header.Id);
                //        if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
                //        {
                //            foreach (DataRow row in ds.Tables[0].Rows)
                //            {

                //                if (Convert.ToInt32(row["RequiredQty"]) > Convert.ToInt32(row["ReceiptQty"]))
                //                {
                //                    remark = remark + row["UPN"].ToString() + "撤销数量" + (Convert.ToInt32(row["RequiredQty"]) - Convert.ToInt32(row["ReceiptQty"])).ToString() + ";";
                //                }
                //            }
                //        }
                //        header.OrderStatus = PurchaseOrderStatus.Completed.ToString();
                //        header.Remark = remark;
                //        headerDao.Update(header);
                //        //更新明细行信息(修改订单数量及明细行价格)
                //        detailDao.UpdatePurchaseOrderDetailForOrderComplete(header.Id.ToString());
                //        //订单操作日志
                //        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Complete, null);
                //        //发送邮件
                //        try
                //        {
                //            if (info != null)
                //            {
                //                //获取订单包括的产品数及总金额
                //                Decimal productNumber = 0;
                //                Decimal orderPrice = 0;
                //                foreach (PurchaseOrderDetail detail in orderDetailList)
                //                {
                //                    productNumber += detail.RequiredQty.Value;
                //                    orderPrice += detail.Amount.Value;
                //                }
                //                MessageBLL msgBll = new MessageBLL();
                //                //邮件
                //                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                //                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();

                //                dictMailSubject.Add("Approver", this._context.User.CorpName);
                //                dictMailSubject.Add("OrderNo", header.OrderNo);

                //                dictMailBody.Add("Approver", this._context.User.CorpName);
                //                dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                //                dictMailBody.Add("OrderNo", header.OrderNo);
                //                dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                //                dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());
                //                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_CLOSE, dictMailSubject, dictMailBody, info.Email);

                //            }
                //        }
                //        catch
                //        {

                //        }
                //        result = true;
                //    }
                //}
                //20191120，删除审核节点关闭功能

                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// T2订单撤销
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="note"></param>
        /// <returns></returns>
        public bool RevokeT2Order(Guid headerId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                PurchaseOrderInterfaceDao orderInterfaceDao = new PurchaseOrderInterfaceDao();
                DealerShipToDao infoDao = new DealerShipToDao();
                SpecialPriceDetailDao spDao = new SpecialPriceDetailDao();
                PurchaseOrderHeader header = headerDao.GetObject(headerId);
                DealerShipTo info = infoDao.GetDealerShipToByUser(header.CreateUser.Value);
                DealerMasterDao dmDao = new DealerMasterDao();

                //订单状态为：已提交、已同意，可以撤销
                //状态=已提交、已同意：不需要审批，直接修改状态为“已撤销”,同时修改interface表中订单状态
                if (header.OrderStatus == PurchaseOrderStatus.Submitted.ToString() || header.OrderStatus == PurchaseOrderStatus.Approved.ToString())
                {
                    if (!header.IsLocked)
                    {

                        IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);

                        //修改状态
                        header.OrderStatus = PurchaseOrderStatus.Revoked.ToString();
                        headerDao.Update(header);

                        if (header.OrderType.Equals(PurchaseOrderType.PRO.ToString()))
                        {
                            //促销订单返回赠品 
                            String rtnValPro = "";
                            String rtnMsgPro = "";
                            Hashtable proLoge = new Hashtable();
                            proLoge.Add("PohId", header.Id);
                            proLoge.Add("OrderSubType", "Revoking");
                            proLoge.Add("RtnVal", rtnValPro);
                            proLoge.Add("RtnMsg", rtnMsgPro);
                            detailDao.PRODealerLargessUpdate(proLoge);
                            rtnValPro = proLoge["RtnVal"].ToString();
                            rtnMsgPro = proLoge["RtnMsg"].ToString();

                            if (rtnValPro == "Failure")
                            {
                                throw new Exception(rtnMsgPro.ToString());
                            }
                            //PurchaseOrderHeaderDao hdao = new PurchaseOrderHeaderDao();
                            //string Rtnval = string.Empty;
                            //string Rtmmsg = string.Empty;
                            //hdao.PRODealerRedInvoice_Update(header.Id, "Revoking", _context.User.CorpId.Value, header.ProductLineBumId.Value, out Rtnval, out Rtmmsg);
                            //if (Rtnval == "Failure")
                            //{
                            //    throw new Exception(Rtmmsg.ToString());
                            //}
                        }
                        //撤销积分使用额度和额度lijie add 2016-1013
                        if (header.OrderType.Equals(PurchaseOrderType.CRPO.ToString()))
                        {
                            String rtnValPoint = "";
                            String rtnMsgPoint = "";
                            Hashtable point = new Hashtable();
                            point.Add("POH_ID", header.Id);
                            point.Add("RtnVal", rtnValPoint);
                            point.Add("RtnMsg", rtnMsgPoint);
                            detailDao.OrderPointRevok(point);
                            rtnValPoint = point["RtnVal"].ToString();
                            rtnMsgPoint = point["RtnMsg"].ToString();

                            if (rtnValPoint == "Failure")
                            {
                                throw new Exception(rtnMsgPoint.ToString());
                            }
                            //PurchaseOrderHeaderDao hdao = new PurchaseOrderHeaderDao();
                            //string Rtnval = string.Empty;
                            //string Rtmmsg = string.Empty;
                            //hdao.PRODealerRedInvoice_Update(header.Id, "Revoking", _context.User.CorpId.Value, header.ProductLineBumId.Value, out Rtnval, out Rtmmsg);
                            //if (Rtnval == "Failure")
                            //{
                            //    throw new Exception(Rtmmsg.ToString());
                            //}
                        }

                        //修改interface表中订单的状态
                        orderInterfaceDao.UpdatePurchaseOrderInterfaceStatusCancelled(header.Id.ToString());

                        //订单操作日志
                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Revoked, null);


                        //发送短信及邮件
                        try
                        {

                            //获取接收邮件及短信的人员                           
                            DealerShipTo dst = new DealerShipTo();
                            dst = infoDao.GetParentDealerEmailAddressByDmaId(this._context.User.CorpId.Value);


                            //获取经销商信息
                            DealerMaster dm = new DealerMaster();
                            dm = dmDao.GetObject(this._context.User.CorpId.Value);

                            if (dst != null && dm != null)
                            {
                                //获取订单包括的产品数及总金额
                                Decimal productNumber = 0;
                                Decimal orderPrice = 0;

                                foreach (PurchaseOrderDetail detail in orderDetailList)
                                {
                                    productNumber += detail.RequiredQty.Value;
                                    orderPrice += detail.Amount.Value;
                                }

                                MessageBLL msgBll = new MessageBLL();
                                //邮件
                                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                                dictMailSubject.Add("Dealer", this._context.User.CorpName);
                                dictMailSubject.Add("OrderNo", header.OrderNo);

                                dictMailBody.Add("Dealer", this._context.User.CorpName);
                                dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToString());
                                dictMailBody.Add("OrderNo", header.OrderNo);
                                dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                                dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());



                                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_REVOKE, dictMailSubject, dictMailBody, dst.Email);

                                //短信
                                Dictionary<String, String> dictSMS = new Dictionary<String, String>();
                                dictSMS.Add("OrderDate", header.SubmitDate.Value.ToShortDateString().ToString());
                                dictSMS.Add("OrderNo", header.OrderNo);
                                dictSMS.Add("OrderAmount", orderPrice.ToString("f2"));
                                dictSMS.Add("ProductNumber", ((int)productNumber).ToString());
                                msgBll.AddToShortMessageQueue(ShortMessageTemplateCode.SMS_ORDER_REVOKE, dictSMS, dm.Phone);

                            }
                        }
                        catch
                        {

                        }
                        result = true;
                    }
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 删除订单采购明细
        /// </summary>
        /// <param name="headerId"></param>
        /// <returns></returns>
        public bool DeleteDetail(Guid headerId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();

                detailDao.DeletePurchaseOrderDetailByHeaderId(headerId);

                result = true;

                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 添加订购产品
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public bool AddCfn(Guid headerId, Guid dealerId, string cfnString, string ordertype, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.AddCfn(headerId, dealerId, cfnString, ordertype, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 添加特殊价格产品
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public bool AddSpecialCfn(Guid headerId, Guid dealerId, string cfnString, string specialPriceId, string orderType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.AddSpeicalCfn(headerId, dealerId, cfnString, specialPriceId, orderType, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 添加成套产品
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public bool AddCfnSet(Guid headerId, Guid dealerId, string cfnString, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.AddCfnSet(headerId, dealerId, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), cfnString, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 添加成套产品(BSC)
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public bool AddBSCCfnSet(Guid headerId, Guid dealerId, string cfnString, string priceType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.AddBSCCfnSet(headerId, dealerId, cfnString, priceType, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 添加促销赠送产品
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="cfnCheck"></param>
        /// <param name="specialPriceId"></param>
        /// <param name="orderType"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <returns></returns>
        public bool AddSpecialCfnPromotion(Guid headerId, Guid dealerId, string cfnString, string cfnCheckString, string specialPriceId, string orderType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.AddSpecialCfnPromotion(headerId, dealerId, cfnString, cfnCheckString, specialPriceId, orderType, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 提交前检查明细行
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <param name="rtnRegMsg"></param>
        /// <returns></returns>
        //public bool CheckSubmit(Guid headerId, Guid dealerId, out string rtnVal, out string rtnMsg, out string rtnRegMsg, out string errorMsg)
        //{
        //    bool result = false;

        //    using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
        //    {
        //        dao.CheckSubmit(headerId, dealerId, out rtnVal, out rtnMsg, out rtnRegMsg, out errorMsg);
        //        result = true;
        //    }
        //    return result;
        //}
        public bool CheckSubmit(Guid headerId, Guid dealerId, out string rtnVal, out string rtnMsg, out string rtnRegMsg)
        {
            bool result = false;

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.CheckSubmit(headerId, dealerId, out rtnVal, out rtnMsg, out rtnRegMsg);
                result = true;
            }
            return result;
        }
        public bool CheckSubmit(Guid headerId, Guid dealerId, String promotionPolicyID, String priceType, String orderType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.CheckSubmit(headerId, dealerId, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), promotionPolicyID, priceType, orderType, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }
        public bool CheckSubmitSpecial(Guid headerId, Guid dealerId, Guid specialPriceId, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.CheckSubmitSpecial(headerId, dealerId, specialPriceId, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }
        /// <summary>
        /// 复制订单
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <returns></returns>
        public bool Copy(Guid headerId, Guid dealerId, String priceType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.Copy(headerId, dealerId, new Guid(_context.User.Id), priceType, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 因修改订单而复制临时类型订单
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <returns></returns>
        public bool CopyForTemporary(Guid headerId, Guid instanceId, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.CopyForTemporary(headerId, instanceId, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 锁定订单
        /// </summary>
        /// <param name="listString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderMake, Description = "订单授权-订单处理", Permissoin = PermissionType.Write)]
        public bool Lock(string listString, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.Lock(new Guid(_context.User.Id), listString, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 解锁订单
        /// </summary>
        /// <param name="listString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderMake, Description = "订单授权-订单处理", Permissoin = PermissionType.Write)]
        public bool Unlock(string listString, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.Unlock(new Guid(_context.User.Id), listString, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 手工生成订单接口
        /// </summary>
        /// <param name="listString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderMake, Description = "订单授权-订单处理", Permissoin = PermissionType.Write)]
        public bool MakeManual(string listString, out string rtnVal, out string rtnMsg, out string batchNbr)
        {
            bool result = false;
            //将待生成接口的订单放入接口处理表中，此时状态未变
            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.MakeManual(new Guid(_context.User.Id), listString, out rtnVal, out rtnMsg, out batchNbr);
            }

            //生成接口文件
            if (rtnVal != "Failure")
            {
                if (string.IsNullOrEmpty(batchNbr))
                {
                    result = true;
                }
                else
                {
                    IList<PurchaseOrderInterface> interList = this.GetPurchaseOrderInterfaceByBatchNbr(batchNbr);

                    foreach (PurchaseOrderInterface inter in interList)
                    {
                        using (TransactionScope trans = new TransactionScope())
                        {
                            PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                            PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                            PurchaseOrderInterfaceDao interDao = new PurchaseOrderInterfaceDao();
                            //InterfaceOrderDao lineDao = new InterfaceOrderDao();
                            CfnDao cfnDao = new CfnDao();
                            DealerMasterDao dealerDao = new DealerMasterDao();
                            DealerShipToDao infoDao = new DealerShipToDao();
                            if (inter.Status == PurchaseOrderMakeStatus.Pending.ToString())
                            {
                                int lineNbr = 0;
                                string fileName = PurchaseOrderUtil.GetExportFileName(inter.RecordNbr);
                                //写文件
                                StreamWriter fileWriter = File.AppendText(fileName);

                                PurchaseOrderHeader header = headerDao.GetObject(inter.PohId);
                                IList<PurchaseOrderDetail> detailList = detailDao.SelectByHeaderId(header.Id);
                                DealerShipTo info = infoDao.GetDealerShipToByUser(header.CreateUser.Value);
                                try
                                {
                                    foreach (PurchaseOrderDetail detail in detailList)
                                    {
                                        //InterfaceOrder line = new InterfaceOrder();
                                        //line.Id = Guid.NewGuid();
                                        //line.DealerSapCode = dealerDao.GetObject(header.DmaId.Value).SapCode;
                                        //line.OrderNo = header.OrderNo;
                                        //line.TerritoryCode = header.TerritoryCode;
                                        //line.Remark = header.Remark;
                                        //line.InvoiceComment = header.InvoiceComment;
                                        //line.Rdd = header.Rdd;
                                        //line.ArticleNumber = cfnDao.GetCfn(detail.CfnId).CustomerFaceNbr;
                                        //line.OrderNum = detail.RequiredQty;
                                        //line.LineNbr = ++lineNbr;
                                        //line.FileName = fileName;
                                        //line.ImportDate = DateTime.Now;
                                        //lineDao.Insert(line);
                                        //fileWriter.WriteLine(PurchaseOrderUtil.GetExportLineString(line));
                                    }
                                    //更新接口中的状态
                                    inter.FileName = fileName;
                                    inter.Status = PurchaseOrderMakeStatus.Success.ToString();
                                    interDao.Update(inter);
                                    //更新订单状态
                                    header.OrderStatus = PurchaseOrderStatus.Uploaded.ToString();
                                    header.UpdateDate = DateTime.Now;
                                    header.UpdateUser = new Guid(_context.User.Id);
                                    headerDao.Update(header);

                                    bool isSuccess = true;
                                    try
                                    {
                                        //发送短信及邮件
                                        this.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_UPLOADED, header, info);
                                        this.AddToShortMessageQueue(ShortMessageTemplateCode.SMS_ORDER_UPLOADED, header, info);
                                    }
                                    catch
                                    {
                                        isSuccess = false;
                                    }
                                    //记录订单操作日志
                                    if (isSuccess)
                                    {
                                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.ManualMake, null);
                                    }
                                    else
                                    {
                                        this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.ManualMake, "发送邮件或短信时发生错误！");
                                    }
                                }
                                catch (Exception ex)
                                {
                                    rtnVal = "Error";
                                    rtnMsg += "订单[" + inter.PohOrderNo + "]导出文件失败<BR/>" + ex.ToString();
                                    interDao.Delete(inter.Id);
                                    //记录订单操作日志
                                    this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.ManualMake, "生成订单接口发生错误！");
                                }
                                finally
                                {
                                    fileWriter.Flush();
                                    fileWriter.Close();
                                }
                            }
                            trans.Complete();
                        }
                    }
                    result = true;
                }
            }
            return result;
        }

        /// <summary>
        /// 根据batchNbr得到订单生成接口待处理记录
        /// </summary>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        public IList<PurchaseOrderInterface> GetPurchaseOrderInterfaceByBatchNbr(string batchNbr)
        {
            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                return dao.SelectByBatchNbr(batchNbr);
            }
        }

        /// <summary>
        /// 根据客户端ID初始化接口表
        /// </summary>
        /// <param name="clientid"></param>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        public int InitPurchaseOrderInterfaceByClientID(string clientid, string batchNbr)
        {
            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitByClientID(ht);
            }
        }

        public int InitPurchaseOrderInterfaceForLpByClientID(string clientid, string batchNbr)
        {
            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitLpByClientID(ht);
            }
        }

        public int InitPurchaseOrderInterfaceForT2ByClientID(string clientid, string batchNbr)
        {
            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitT2ByClientID(ht);
            }
        }

        /// <summary>
        /// 根据批处理号得到订单明细数据
        /// </summary>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        public IList<SapOrderData> QueryPurchaseOrderDetailInfoByBatchNbr(string batchNbr)
        {
            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                return dao.QueryPurchaseOrderDetailInfoByBatchNbr(batchNbr);
            }
        }

        public IList<LpOrderData> QueryPurchaseOrderDetailInfoByBatchNbrForLp(string batchNbr)
        {
            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                return dao.QueryPurchaseOrderDetailInfoByBatchNbrForLp(batchNbr);
            }
        }

        public IList<T2OrderData> QueryPurchaseOrderDetailInfoByBatchNbrForT2(string batchNbr)
        {
            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                return dao.QueryPurchaseOrderDetailInfoByBatchNbrForT2(batchNbr);
            }
        }

        public bool AfterPurchaseOrderDetailInfoDownload(string BatchNbr, string ClientID, string Success, out string RtnVal)
        {
            bool result = false;

            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                dao.AfterDownload(BatchNbr, ClientID, Success, out RtnVal);
                result = true;
            }
            return result;

        }

        /// <summary>
        /// 更新订购产品明细行记录
        /// </summary>
        /// <param name="detail"></param>
        /// <returns></returns>
        public bool UpdateCfn(PurchaseOrderDetail detail)
        {
            bool result = false;

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.Update(detail);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除订购产品明细行记录
        /// </summary>
        /// <param name="detailId"></param>
        /// <returns></returns>
        public bool DeleteCfn(Guid detailId)
        {
            bool result = false;

            using (PurchaseOrderDetailDao dao = new PurchaseOrderDetailDao())
            {
                dao.Delete(detailId);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 根据订单主键计算总订购数量和总金额
        /// </summary>
        /// <param name="headerId"></param>
        /// <returns></returns>
        public DataSet SumPurchaseOrderByHeaderId(Guid headerId)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.SumPurchaseOrderByHeaderId(headerId);
            }
        }
        /// <summary>
        /// 根据主键得到DealerOrderSetting对象
        /// </summary>
        /// <param name="dealerId"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_OrderSetting, Description = "订单授权-订单生成设定", Permissoin = PermissionType.Read)]
        public DealerOrderSetting QueryGetDealerOrderSetting(Guid dealerId)
        {
            using (DealerOrderSettingDao dao = new DealerOrderSettingDao())
            {
                return dao.GetObjectByDmaId(dealerId);
            }
        }

        /// <summary>
        /// 编辑DealerOrderSetting记录
        /// </summary>
        /// <param name="order"></param>
        [AuthenticateHandler(ActionName = Action_OrderSetting, Description = "订单授权-订单生成设定", Permissoin = PermissionType.Write)]
        public void UpdateDealerOrderSetting(DealerOrderSetting order)
        {
            using (DealerOrderSettingDao dao = new DealerOrderSettingDao())
            {
                dao.Update(order);
            }
        }

        /// <summary>
        /// 新增DealerOrderSetting记录
        /// </summary>
        /// <param name="order"></param>
        [AuthenticateHandler(ActionName = Action_OrderSetting, Description = "订单授权-订单生成设定", Permissoin = PermissionType.Write)]
        public void InsertDealerOrderSetting(DealerOrderSetting order)
        {
            using (DealerOrderSettingDao dao = new DealerOrderSettingDao())
            {
                dao.Insert(order);
            }
        }

        /// <summary>
        /// 编辑DealerShipTo记录
        /// </summary>
        /// <param name="order"></param>
        public void UpdateDealerShipTo(DealerShipTo order)
        {
            using (DealerShipToDao dao = new DealerShipToDao())
            {
                dao.Update(order);
            }
        }

        /// <summary>
        /// 新增DealerShipTo记录
        /// </summary>
        /// <param name="order"></param>
        public void InsertDealerShipTo(DealerShipTo order)
        {
            using (DealerShipToDao dao = new DealerShipToDao())
            {
                dao.Insert(order);
            }
        }

        /// <summary>
        /// 发送邮件至队列
        /// </summary>
        /// <param name="code"></param>
        /// <param name="header"></param>
        public void AddToMailMessageQueue(MailMessageTemplateCode code, PurchaseOrderHeader header, DealerShipTo info)
        {
            if (info != null && info.ReceiveEmail && !string.IsNullOrEmpty(info.Email))
            {
                MessageBLL msgBll = new MessageBLL();
                MailMessageTemplate template = msgBll.GetMailMessageTemplate(code.ToString());
                if (template != null)
                {
                    msgBll.AddToMailMessageQueue(PurchaseOrderUtil.GetMailMessageQueue(template, header, info.Email));
                }
            }
        }

        /// <summary>
        /// 发送至短信队列
        /// </summary>
        /// <param name="code"></param>
        /// <param name="header"></param>
        public void AddToShortMessageQueue(ShortMessageTemplateCode code, PurchaseOrderHeader header, DealerShipTo info)
        {
            if (info != null && info.Receivesms && !string.IsNullOrEmpty(info.ContactMobile))
            {
                MessageBLL msgBll = new MessageBLL();
                ShortMessageTemplate template = msgBll.GetShortMessageTemplate(code.ToString());
                if (template != null)
                {
                    msgBll.AddToShortMessageQueue(PurchaseOrderUtil.GetShortMessageQueue(template, header, info.ContactMobile));
                }
            }
        }

        /// <summary>
        /// 查询订单SAP反馈记录 (huxiang 110419)
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet GetConfirmationByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (PurchaseOrderConfirmationDao dao = new PurchaseOrderConfirmationDao())
            {
                return dao.SelectByFilter(obj, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 查询Excel订单导入出错信息
        /// </summary>
        /// <returns></returns>
        public IList<PurchaseOrderInit> QueryPurchaseOrderInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (PurchaseOrderInitDao dao = new PurchaseOrderInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("User", new Guid(_context.User.Id));
                //param.Add("ErrorFlag", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 调用存储过程处理Excel订单导入数据
        /// </summary>
        /// <param name="IsValid"></param>
        /// <returns></returns>
        public bool VerifyPurchaseOrderInit(string importType, out string IsValid)
        {
            bool result = false;
            //20190929
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            //调用存储过程验证数据
            using (PurchaseOrderInitDao dao = new PurchaseOrderInitDao())
            {
                IsValid = dao.Initialize(importType, new Guid(_context.User.Id), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 导入订单中间表
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public bool ImportPurchaseOrderInit(DataSet ds, string fileName)
        {
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    PurchaseOrderInitDao dao = new PurchaseOrderInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));
                    //读取DataSet数据至数据库
                    int lineNbr = 1;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        string errString = string.Empty;
                        PurchaseOrderInit data = new PurchaseOrderInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;
                        if (_context.User.CorpId.HasValue)
                        {
                            data.DmaId = _context.User.CorpId.Value;
                        }
                        else
                        {
                            errString += "请使用经销商帐号导入订单,";
                        }

                        if (dr[0] == DBNull.Value)
                        {
                            errString += "产品型号为空,";
                        }
                        else
                        {
                            data.ArticleNumber = dr[0].ToString();
                        }

                        if (dr[1] == DBNull.Value)
                        {
                            errString += "订购数量为空,";
                        }
                        else
                        {
                            try
                            {
                                data.RequiredQty = dr[5] == DBNull.Value ? null : dr[1].ToString();
                                if (!string.IsNullOrEmpty(data.RequiredQty))
                                {
                                    decimal qty;
                                    if (!Decimal.TryParse(data.RequiredQty, out qty))
                                        data.RequiredQtyErrMsg = "库存数量格式不正确";

                                }
                            }
                            catch
                            {
                                errString += "订购数量必须为大于0的整数,";
                            }
                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !string.IsNullOrEmpty(errString);
                        data.ErrorDescription = errString;

                        dao.Insert(data);
                    }
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            return result;
        }


        public bool Import(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    PurchaseOrderInitDao dao = new PurchaseOrderInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<PurchaseOrderInit> list = new List<PurchaseOrderInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        PurchaseOrderInit data = new PurchaseOrderInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        if (_context.User.CorpId.HasValue)
                        {
                            data.DmaId = _context.User.CorpId.Value;
                        }

                        //OrderType
                        data.OrderType = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.OrderType))
                            data.OrderTypeErrMsg = "单据类型为空";

                        //ProductLine
                        data.ProductLine = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.ProductLine))
                            data.ProductLineErrMsg = "产品线为空";


                        //ArticleNumber
                        data.ArticleNumber = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品型号为空";

                        //Qty
                        data.RequiredQty = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (!string.IsNullOrEmpty(data.RequiredQty))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.RequiredQty, out qty))
                                data.RequiredQtyErrMsg = "订购数量格式不正确";

                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.OrderTypeErrMsg)
                            && string.IsNullOrEmpty(data.ArticleNumberErrMsg)
                            && string.IsNullOrEmpty(data.RequiredQtyErrMsg)
                            );

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }
                    }
                    dao.BatchInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }


        public bool ImportLP(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    PurchaseOrderInitDao dao = new PurchaseOrderInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<PurchaseOrderInit> list = new List<PurchaseOrderInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        PurchaseOrderInit data = new PurchaseOrderInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        if (_context.User.CorpId.HasValue)
                        {
                            data.DmaId = _context.User.CorpId.Value;
                        }

                        //OrderType
                        data.OrderType = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.OrderType))
                            data.OrderTypeErrMsg = "单据类型为空";

                        //ProductLine
                        data.ProductLine = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.ProductLine))
                            data.ProductLineErrMsg = "产品线为空";

                        //ArticleNumber
                        data.ArticleNumber = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品型号为空";

                        //Qty
                        data.RequiredQty = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (!string.IsNullOrEmpty(data.RequiredQty))
                        {
                            int qty;
                            if (!Int32.TryParse(data.RequiredQty, out qty))
                                data.RequiredQtyErrMsg = "订购数量格式不正确";
                        }
                        //LotNumber
                        data.LotNumber = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        //if (string.IsNullOrEmpty(data.LotNumber))
                        //    data.LotNumberErrMsg = "批号为空";

                        //Amount
                        data.Amount = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (!string.IsNullOrEmpty(data.Amount))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.Amount, out qty))
                                data.AmountErrMsg = "金额格式不正确";
                        }
                        //积分类型
                        data.PointType = dr[6] == DBNull.Value ? null : dr[6].ToString();
                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.OrderTypeErrMsg)
                            && string.IsNullOrEmpty(data.ArticleNumberErrMsg)
                            && string.IsNullOrEmpty(data.RequiredQtyErrMsg)
                            && string.IsNullOrEmpty(data.AmountErrMsg)
                            );

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }
                    }
                    dao.BatchInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public void Delete(Guid id)
        {
            using (PurchaseOrderInitDao dao = new PurchaseOrderInitDao())
            {
                dao.Delete(id);
            }
        }

        public void Update(PurchaseOrderInit data)
        {
            using (PurchaseOrderInitDao dao = new PurchaseOrderInitDao())
            {
                dao.UpdateForEdit(data);
            }
        }

        /// <summary>
        /// 根据用户主键获取下单人员中文名称
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public DataSet GetSubmintUserByUserID(Guid userId)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.GetSubmintUserByUserID(userId);
            }
        }


        public bool CheckLotNumberByUPN(string lot, string upn)
        {
            bool result = false;
            Hashtable ht = new Hashtable();
            ht.Add("LotNumber", lot);
            ht.Add("CFN", upn);
            using (LotMasterDao dao = new LotMasterDao())
            {
                IList<LotMaster> list = dao.SelectLotMasterByLotNumberCFN(ht);
                if (list.Count > 0)
                    result = true;
            }
            return result;
        }

        public bool CheckLotNumberByUPNQRCode(string lot, string upn)
        {
            bool result = false;
            Hashtable ht = new Hashtable();
            ht.Add("LotNumber", lot);
            ht.Add("CFN", upn);
            using (LotMasterDao dao = new LotMasterDao())
            {
                IList<LotMaster> list = dao.SelectLotMasterByLotNumberCFNQuCode(ht);
                if (list.Count > 0)
                    result = true;
            }
            return result;
        }

        /// <summary>
        /// Query the promotion policy of T1 and LP
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPromotionPolicy(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (PromotionPolicyDao dao = new PromotionPolicyDao())
            {
                return dao.QueryPromotionPolicy(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// Export Promotion Policy
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        public DataSet ExportPromotionPolicy(Hashtable param)
        {
            using (PromotionPolicyDao dao = new PromotionPolicyDao())
            {
                return dao.ExportPromotionPolicy(param);
            }
        }

        /// <summary>
        /// Adjust Promotion quantity
        /// </summary>
        /// <param name="qty"></param>
        /// <param name="remark"></param>
        public void SaveItem(decimal qty, string remark, string id)
        {
            using (PromotionPolicyDao dao = new PromotionPolicyDao())
            {
                dao.SaveItem(qty, remark, id);
            }
        }


        /// <summary>
        /// Query the promotion policy of T1 and LP
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPromotionPolicyForT2(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (PromotionPolicyDao dao = new PromotionPolicyDao())
            {
                return dao.QueryPromotionPolicyForT2(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// Export Promotion Policy
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        public DataSet ExportPromotionPolicyForT2(Hashtable param)
        {
            using (PromotionPolicyDao dao = new PromotionPolicyDao())
            {
                return dao.ExportPromotionPolicyForT2(param);
            }
        }

        /// <summary>
        /// Adjust Promotion quantity
        /// </summary>
        /// <param name="qty"></param>
        /// <param name="remark"></param>
        public void SaveItemForT2(decimal qty, string remark, string id)
        {
            using (PromotionPolicyDao dao = new PromotionPolicyDao())
            {
                dao.SaveItemForT2(qty, remark, id);
            }
        }

        public DataSet QueryPromotionPolicyT2(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (PromotionPolicyDao dao = new PromotionPolicyDao())
            {
                return dao.QueryPromotionPolicyT2(table, start, limit, out totalRowCount);
            }
        }

        public DataSet ExportPromotionPolicyT2(Hashtable param)
        {
            using (PromotionPolicyDao dao = new PromotionPolicyDao())
            {
                return dao.ExportPromotionPolicyT2(param);
            }
        }

        public bool GetApplyOrderHtml(Guid headerId, out string rtnVal, out string rtnMsg)
        {
            bool result = false;
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                DataSet ds = dao.GC_GetApplyOrderHtml(headerId, "Id", "V_PurchaseOrder", "Id", "V_PurchaseOrderTable", out rtnVal, out rtnMsg);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    rtnVal = "Success";
                    rtnMsg = ds.Tables[0].Rows[0]["HtmlStr"] != null ? ds.Tables[0].Rows[0]["HtmlStr"].ToString() : "";
                    result = true;
                }
                else
                {
                    rtnVal = "Failure";
                    result = false;
                }
            }
            return result;
        }

        public DataSet SelectSalesByDealerAndProductLine(Hashtable table)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.SelectSalesByDealerAndProductLine(table);
            }
        }

        public DataSet SelectInterfaceOrderByBatchNo(string batchNo)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.SelectInterfaceOrderByBatchNo(batchNo);
            }
        }

        public int DeleteOrderPointByOrderHeaderId(Guid id)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.DeleteOrderPointByOrderHeaderId(id);
            }
        }

        public void OrderPointCheck(Hashtable obj, out string rtnVal)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                dao.OrderPointCheck(obj, out rtnVal);
            }
        }

        public void PolicyFit(Guid prhid, string policyid, out string rtnVal, out string rtnMsg)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                dao.PolicyFit(prhid, policyid, out rtnVal, out rtnMsg);
            }
        }
        public DataSet SelectSAPWarehouseAddressByWhmId(string WhmId)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.SelectSAPWarehouseAddressByWhmId(WhmId);
            }
        }
        public DataSet GetCfnIsorderByUpn(Hashtable ht)
        {
            BaseService.AddCommonFilterCondition(ht);
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.GetCfnIsorderByUpn(ht);
            }
        }
        public PurchaseOrderHeader GetOrderByOrderNo(string OrderNo)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.GetOrderByOrderNo(OrderNo);
            }
        }
        public PurchaseOrderHeader GetOrderByOrderNoManual(string OrderNo)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.GetOrderByOrderNoManual(OrderNo);
            }
        }
        public bool UpdateOrderByOrder(PurchaseOrderHeader Header)
        {
            try
            {
                using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
                {
                    dao.Update(Header);
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public void InsertOrderOperationLog(Hashtable ht)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                dao.InsertOrderOperationLog(ht);
            }
        }
        public void RedInvoice_SumbitChecked(string PohId, string DealerId, string BuId, string PointType, string OrderType, out string RtnVal, out string RtnMsg)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                dao.RedInvoice_SumbitChecked(PohId, DealerId, BuId, PointType, OrderType, out RtnVal, out RtnMsg);
            }
        }
        public void RedInvoice_RedInvoicesCheck(string PohId, string DealerId, string PlineId, out string RtnVal, out string RtnMsg)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                dao.RedInvoice_RedInvoicesCheck(PohId, DealerId, PlineId, out RtnVal, out RtnMsg);
            }
        }
        public DataSet SumPurchaseOrderByRedInvoicesHeaderId(string PohId)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.SumPurchaseOrderByRedInvoicesHeaderId(PohId);
            }
        }
        public void DeleteOrderRedInvoicesByOrderHeaderId(string PohId)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                dao.DeleteOrderRedInvoicesByOrderHeaderId(PohId);
            }
        }
        public bool SelectDealerPaymentTypBYDmaId(string DmaId)
        {
            bool result = false;
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                DataSet ds = dao.SelectDealerPaymentTypBYDmaId(DmaId);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    result = true;
                }
            }
            return result;
        }
        public string CheckDealerPermissions(Hashtable ht)
        {
            string result = "";
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                DataSet ds = dao.SelectDealerPermissions(ht);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    result = ds.Tables[0].Rows[0]["CheckData"].ToString();
                }
            }
            return result;
        }

        public void AddNoticeCfn(Guid headerId, string cfnString)
        {
            PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
            PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
            MailDeliveryAddressDao mailAddressDao = new MailDeliveryAddressDao();
            try
            {

                PurchaseOrderHeader newHeader = headerDao.GetObject(headerId);
                //获取接收邮件及短信的人员
                //需求更改：如果是二级的订单，则获取LP相关人员的账号（限定为接收邮件的人员）
                //如果是LP或一级经销商的订单，则需要获取CS人员及BU相关人员，根据产品线进行设定

                //传入当前经销商ID，然后获取对应的邮件地址
                Hashtable ht = new Hashtable();
                ht.Add("DmaId", newHeader.DmaId);
                ht.Add("ProductLineID", Guid.Empty);
                ht.Add("MailType", "SampleNotice");
                IList<MailDeliveryAddress> mailList = mailAddressDao.QueryOrderMailAddressByConditions(ht);



                //DealerShipTo dst = new DealerShipTo();
                //dst = dealerShiptoDao.GetParentDealerEmailAddressByDmaId(this._context.User.CorpId.Value);

                //获取经销商信息

                if (mailList != null && mailList.Count > 0)
                {

                    StringBuilder sb = new StringBuilder();
                    DataSet ds = detailDao.GetNoticeCfnListByStringForEmail(cfnString);
                    if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
                    {
                        //构造表格
                        sb.Append("<TABLE style=\"BACKGROUND: #ccccff; border:1px solid\" cellSpacing=\"3\" cellPadding=\"0\">");
                        sb.Append("<TBODY>");
                        //表头
                        sb.Append("<TR>");
                        sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                        sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Division</SPAN></STRONG>");
                        sb.Append("</TD>");
                        sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                        sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Level2</SPAN></STRONG>");
                        sb.Append("</TD>");
                        sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                        sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Qty</SPAN></STRONG>");
                        sb.Append("</TD>");
                        sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                        sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Amount</SPAN></STRONG>");
                        sb.Append("</TD>");
                        sb.Append("</TR>");

                        foreach (DataRow row in ds.Tables[0].Rows)
                        {
                            sb.Append("<TR>");
                            sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                            sb.Append(row["CFN_CustomerFaceNbr"].ToString());
                            sb.Append("</TD>");
                            sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                            sb.Append(row["CFN_ChineseName"].ToString());
                            sb.Append("</TD>");
                            sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                            sb.Append(row["CFN_EnglishName"].ToString());
                            sb.Append("</TD>");
                            sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                            sb.Append(Convert.ToDecimal(row["Qty"].ToString()).ToString("f0"));
                            sb.Append("</TD>");
                            sb.Append("</TR>");

                        }

                        //表尾
                        //sb.Append("<TR>");
                        //sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                        //sb.Append("&nbsp;");
                        //sb.Append("</TD>");
                        //sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                        //sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Total</SPAN></STRONG>");
                        //sb.Append("</TD>");
                        //sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                        //sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">" + ((int)productNumber).ToString() + "</SPAN></STRONG>");
                        //sb.Append("</TD>");
                        //sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                        //sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">" + orderPrice.ToString("f2") + " RMB</SPAN></STRONG>");
                        //sb.Append("</TD>");
                        //sb.Append("</TR>");

                        sb.Append("</TBODY>");
                        sb.Append("</TABLE>");
                    }

                    MessageBLL msgBll = new MessageBLL();
                    foreach (MailDeliveryAddress mailAddress in mailList)
                    {
                        //邮件
                        Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                        Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                        dictMailSubject.Add("Dealer", this._context.User.CorpName);
                        dictMailSubject.Add("OrderNo", newHeader.OrderNo);

                        dictMailBody.Add("Dealer", this._context.User.CorpName);
                        dictMailBody.Add("OrderDate", newHeader.SubmitDate.Value.ToString());
                        dictMailBody.Add("OrderNo", newHeader.OrderNo);
                        dictMailBody.Add("Summary", sb.ToString());


                        msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ORDER_SUBMIT, dictMailSubject, dictMailBody, mailAddress.MailAddress);
                    }


                }

            }
            catch
            {

            }

        }

        public DataSet PurchasingForecastReport(Hashtable table, int start, int limit, out int totalCount)
        {

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            using (PurchaseOrderHeaderDao pd = new PurchaseOrderHeaderDao())
            {
                return pd.PurchasingForecastReport(table, start, limit, out totalCount);
            }
        }

        public DataSet ExportPurchasingForecastReport(Hashtable obj)
        {
            using (PurchaseOrderHeaderDao pd = new PurchaseOrderHeaderDao())
            {
                return pd.ExportPurchasingForecastReport(obj);

            }
        }

        //added by huyong on 2017-05-19
        public void InsertProcessRunnerInterface(Guid headerId, out string RtnVal, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (PurchaseOrderInterfaceDao dao = new PurchaseOrderInterfaceDao())
            {
                dao.InsertProcessRunnerInterface(headerId, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out RtnVal, out RtnMsg);
            }
        }
        //获取订单币种信息
        public string GetPurchaseOrderCarrierById(Hashtable obj)
        {
            string strCarrier = "CNY";
            using (PurchaseOrderHeaderDao pd = new PurchaseOrderHeaderDao())
            {
                DataTable dtCarrier = pd.GetPurchaseOrderCarrierById(obj).Tables[0];
                if (dtCarrier.Rows.Count > 0)
                {
                    strCarrier = dtCarrier.Rows[0]["Currency"].ToString();
                }
            }
            return strCarrier;
        }
        public bool CheckBomOrderQty(Hashtable obj)
        {
            bool strQty = false;
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                DataTable dtBom = dao.CheckBomOrderQty(obj).Tables[0];
                if (dtBom.Rows.Count > 0)
                {
                    strQty = Convert.ToInt32(dtBom.Rows[0]["CheckDate"]) == 1;
                }
            }
            return strQty;
        }
        public int UpdateOrderWmsSendflg(Hashtable obj)
        {
            using (PurchaseOrderHeaderDao dao = new PurchaseOrderHeaderDao())
            {
                return dao.UpdateOrderWmsSendflg(obj);
            }
        }
        public DataSet GetPurchaseOrderWmsInfo()
        {
            using (PurchaseOrderHeaderDao pd = new PurchaseOrderHeaderDao())
            {
                return pd.GetPurchaseOrderWmsInfo();

            }
        }
    }
}
