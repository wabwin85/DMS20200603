using DMS.Business;
using DMS.Business.Cache;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Inventory;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Inventory
{
    public class InventoryAdjustListMtrPickerService : ABaseQueryService
    {
        IRoleModelContext _context = RoleModelContext.Current;
        /// <summary>
        /// 其他出入库（普通仓库）初始化
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryAdjustListMtrPickerVO Init(InventoryAdjustListMtrPickerVO model)
        {
            try
            {
                model.IsCFN = false;
                string warehousetype = string.Empty;
                IList<Warehouse> list = new List<Warehouse>();
                if (model.QryAdjustType.ToString() == AdjustType.StockIn.ToString())
                {
                    list = WarehouseByDealerAndType(new Guid(model.QryDealerId), model.QryWarehouseType);

                    model.IsCFN = true;
                }
                else if (model.QryAdjustType.ToString() == AdjustType.StockOut.ToString())
                {
                    list = BindWarehouseStockOut(new Guid(model.QryDealerId), model.QryWarehouseType);
                    //this.WarehouseStore.DataBind();
                }
                else if (model.QryAdjustType.ToString() == AdjustType.Return.ToString() || model.QryAdjustType.ToString() == AdjustType.Exchange.ToString())
                {
                    //Edited By Song Yuqi On 20140319 Begin
                    list = BindWarehouseWithReturn(new Guid(model.QryDealerId), model.QryWarehouseType);
                    //Edited By Song Yuqi On 20140319 End
                    //this.Store_AllWarehouseByDealer(DealerId);
                }
                else if (model.QryAdjustType.ToString() == AdjustType.Transfer.ToString())
                {
                    list = WarehouseByDealerAndType(new Guid(model.QryDealerId), "Borrow");
                    //this.WarehouseStore.DataBind();
                }
                else
                {
                    list = WarehouseByDealerAndType(new Guid(model.QryDealerId), model.QryWarehouseType);
                    //this.WarehouseStore.DataBind();
                }

                model.RstWarehouseList = new ArrayList(list.ToList());
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        /// <summary>
        /// 寄售仓库初始化
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryAdjustListMtrPickerVO ConsignmentInit(InventoryAdjustListMtrPickerVO model)
        {
            try
            {
                model.IsCFN = false;
                string warehousetype = string.Empty;
                IList<Warehouse> list = new List<Warehouse>();
                if (model.QryAdjustType.ToString() == AdjustType.StockIn.ToString())
                {
                    model.IsCFN = true;
                    list = BindWarehouseWithConsignmengAndBorrow(new Guid(model.QryDealerId), model.QryWarehouseType);
                }
                else if (model.QryAdjustType.ToString() == AdjustType.Return.ToString() || model.QryAdjustType.ToString() == AdjustType.Exchange.ToString())
                {
                    list = Store_AllWarehouseByDealer(new Guid(model.QryDealerId));
                }
                else if (model.QryAdjustType.ToString() == AdjustType.CTOS.ToString())
                {
                    list = this.BindWarehouseWithConsignmengAndBorrow(new Guid(model.QryDealerId), model.QryWarehouseType);
                }
                else if (model.QryAdjustType.ToString() == AdjustType.Transfer.ToString())
                {
                    list = this.BindWarehouseWithConsignmengAndBorrow(new Guid(model.QryDealerId), model.QryWarehouseType);
                }
                else
                {
                    list = this.BindWarehouseWithConsignmengAndBorrow(new Guid(model.QryDealerId), model.QryWarehouseType);
                }
                model.RstWarehouseList = new ArrayList(list.ToList());
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 查询
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public string Query(InventoryAdjustListMtrPickerVO model)
        {
            try
            {
                if (!model.IsCFN)
                {
                    //非CFN
                    string[] strCriteria;
                    int iCriteriaNbr;
                    ICurrentInvBLL business = new CurrentInvBLL();

                    Hashtable param = new Hashtable();
                    if (!string.IsNullOrEmpty(model.QryDealerId))
                    {
                        param.Add("DealerId", model.QryDealerId);
                    }
                    if (!string.IsNullOrEmpty(model.QryProductLineWin))
                    {
                        param.Add("ProductLine", model.QryProductLineWin);
                    }
                    if (!string.IsNullOrEmpty(model.QryWorehourse.ToSafeString()))
                        if (model.QryWorehourse.Key != "" && model.QryWorehourse.Value != "")
                        {
                            param.Add("WarehouseId", model.QryWorehourse.Key);
                        }
                    param.Add("Type", model.QryAdjustType);
                    //可以有十个模糊查找的字段
                    if (!string.IsNullOrEmpty(model.QryCFN))
                    {
                        iCriteriaNbr = 0;
                        strCriteria = oneRecord(model.QryCFN);
                        foreach (string strCFN in strCriteria)
                        {
                            if (!string.IsNullOrEmpty(strCFN))
                            {
                                iCriteriaNbr++;
                                if (strCFN.Substring(0, 1) == "+" && strCFN.Length > 2)
                                {
                                    param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN.Substring(1, strCFN.Length - 2));
                                }
                                else
                                {
                                    param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                                }
                            }
                        }
                        if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
                    }

                    if (!string.IsNullOrEmpty(model.QryUPN))
                    {
                        iCriteriaNbr = 0;
                        strCriteria = oneRecord(model.QryUPN);
                        foreach (string strUPN in strCriteria)
                        {
                            if (!string.IsNullOrEmpty(strUPN))
                            {
                                iCriteriaNbr++;
                                param.Add(string.Format("ProductUPN{0}", iCriteriaNbr), strUPN);
                            }
                        }
                        if (iCriteriaNbr > 0) param.Add("ProductUPN", "HasUPNCriteria");
                    }

                    if (!string.IsNullOrEmpty(model.QryLotNumber))
                    {
                        iCriteriaNbr = 0;
                        strCriteria = oneRecord(model.QryLotNumber);
                        foreach (string strLot in strCriteria)
                        {
                            if (!string.IsNullOrEmpty(strLot))
                            {
                                iCriteriaNbr++;
                                if (strLot.Substring(0, 1) == "+" && strLot.Length > 2)
                                {
                                    param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot.Substring(10, strLot.Length - 12));
                                }
                                else
                                {
                                    param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot);
                                }
                            }
                        }
                        if (iCriteriaNbr > 0) param.Add("ProductLotNumber", "HasLotCriteria");
                    }
                    if (!string.IsNullOrEmpty(model.QryQrCode))
                    {
                        iCriteriaNbr = 0;
                        strCriteria = oneRecord(model.QryQrCode);
                        foreach (string strQrCode in strCriteria)
                        {
                            if (!string.IsNullOrEmpty(strQrCode))
                            {
                                iCriteriaNbr++;
                                param.Add(string.Format("QrCode{0}", iCriteriaNbr), strQrCode);
                            }
                        }
                        if (iCriteriaNbr > 0) param.Add("QrCode", "HasQrCodeCriteria");
                    }

                    //Edited By Song Yuqi On 20140319 Begin
                    DataSet ds;
                    //二级经、寄售、退货
                    if ((model.QryAdjustType == AdjustType.Return.ToString() || model.QryAdjustType == AdjustType.Exchange.ToString())
        && _context.User.CorpType == DealerType.T2.ToString()
        && model.QryWarehouseType == AdjustWarehouseType.Consignment.ToString())
                    {
                        //平台寄售、波科寄售
                        param.Add("QryWarehouseType", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                        ds = business.QueryCurrentInvForReturnByT2Consignment(param);
                    }
                    //寄售转销售
                    else if (model.QryAdjustType == AdjustType.CTOS.ToString() && _context.User.CorpType == DealerType.T2.ToString())
                    {
                        ds = business.QueryCurrentCTOSInv(param);
                    }
                    //转移给其他经销商
                    else if (model.QryAdjustType == AdjustType.Transfer.ToString() && (_context.User.CorpType == DealerType.T1.ToString() || _context.User.CorpType == DealerType.LP.ToString() || _context.User.CorpType == DealerType.LS.ToString()))
                    {
                        param.Add("QryWarehouseType", string.Format("{0},{1}", WarehouseType.Borrow.ToString(), WarehouseType.LP_Borrow.ToString()).Split(','));
                        ds = business.QueryCurrentInvForReturnByT2Consignment(param);
                    }
                    else
                    {
                        param.Add("ReturnApplyType", model.QryReturnApplyType);
                        ds = business.QueryCurrentInv(param);
                    }
                    //将结果集进行分页处理
                    DataTable NewDt = GetPagedTable(ds.Tables[0], model.Page, model.PageSize);

                    model.RstResultList = JsonHelper.DataTableToArrayList(NewDt);
                    model.DataCount = ds.Tables[0].Rows.Count;
                    model.IsSuccess = true;
                }
                //CFN状态查询
                else
                {
                    string[] strCriteria;
                    int iCriteriaNbr;
                    ICurrentInvBLL business = new CurrentInvBLL();

                    int totalCount = 0;

                    Hashtable param = new Hashtable();

                    if (!string.IsNullOrEmpty(model.QryProductLineWin))
                    {
                        param.Add("ProductLine", model.QryProductLineWin);
                    }

                    if (!string.IsNullOrEmpty(model.QryCFN_CFN))
                    {
                        iCriteriaNbr = 0;
                        strCriteria = oneRecord(model.QryCFN_CFN);
                        foreach (string strCFN in strCriteria)
                        {
                            if (!string.IsNullOrEmpty(strCFN))
                            {
                                iCriteriaNbr++;
                                param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                            }
                        }
                        if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
                    }

                    if (!string.IsNullOrEmpty(model.QryUPN_CFN))
                    {
                        iCriteriaNbr = 0;
                        strCriteria = oneRecord(model.QryUPN_CFN);
                        foreach (string strUPN in strCriteria)
                        {
                            if (!string.IsNullOrEmpty(strUPN))
                            {
                                iCriteriaNbr++;
                                param.Add(string.Format("ProductUPN{0}", iCriteriaNbr), strUPN);
                            }
                        }
                        if (iCriteriaNbr > 0) param.Add("ProductUPN", "HasUPNCriteria");
                    }

                    DataSet ds = new DataSet();
                    int start = (model.Page - 1) * model.PageSize;
                    if (model.QryIsShareCFN)
                    {
                        //共享产品查询
                        ds = business.QueryCurrentSharedCfn(param, start, model.PageSize, out totalCount);
                    }
                    else
                    {
                        //非共享产品查询
                        ds = business.QueryCurrentCfn(param, start, model.PageSize, out totalCount);
                    }
                    model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                    model.DataCount = totalCount;
                    model.IsSuccess = true;
                }
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

        /// <summary> 
        /// DataTable分页 
        /// </summary> 
        /// <param name="dt">DataTable</param> 
        /// <param name="PageIndex">页索引,注意：从1开始</param> 
        /// <param name="PageSize">每页大小</param> 
        /// <returns>分好页的DataTable数据</returns>              
        public static DataTable GetPagedTable(DataTable dt, int PageIndex, int PageSize)
        {
            if (PageIndex == 0) { return dt; }
            DataTable newdt = dt.Copy();
            newdt.Clear();
            int rowbegin = (PageIndex - 1) * PageSize;
            int rowend = PageIndex * PageSize;

            if (rowbegin >= dt.Rows.Count) { return newdt; }

            if (rowend > dt.Rows.Count) { rowend = dt.Rows.Count; }
            for (int i = rowbegin; i <= rowend - 1; i++)
            {
                DataRow newdr = newdt.NewRow();
                DataRow dr = dt.Rows[i];
                foreach (DataColumn column in dt.Columns)
                {
                    newdr[column.ColumnName] = dr[column.ColumnName];
                }
                newdt.Rows.Add(newdr);
            }
            return newdt;
        }

        #region 经销商查询
        protected IList<Warehouse> Store_AllWarehouseByDealer(Guid DealerId)
        {
            Warehouses business = new Warehouses();
            IList<Warehouse> list = business.GetAllWarehouseByDealer(DealerId);
            var g = from p in list where p.Type != WarehouseType.SystemHold.ToString() select p;

            return g.ToList();

        }

        public IList<Warehouse> BindWarehouseWithConsignmengAndBorrow(Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);


            if (dealerWarehouseType.Equals("Normal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment") || dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        //T1 ,显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台寄售库/借货库 波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() || t.Type == WarehouseType.LP_Borrow.ToString() || t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            return list;
        }

        public IList<Warehouse> BindWarehouseStockOut(Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);


            if (dealerWarehouseType.Equals("Normal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() || t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment") || dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        //T1 ,显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台寄售库/借货库 波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() || t.Type == WarehouseType.LP_Borrow.ToString() || t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            return list;
        }

        public IList<Warehouse> BindWarehouseWithReturn(Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);

            //普通
            if (dealerWarehouseType.Equals(AdjustWarehouseType.Normal.ToString()))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示所有库存
                        list = (from t in list where t.Type != WarehouseType.SystemHold.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type != WarehouseType.SystemHold.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        //T1 ,显示所有库存
                        list = (from t in list where t.Type != WarehouseType.SystemHold.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示普通、借货
                        list = (from t in list where t.Type != WarehouseType.SystemHold.ToString() && t.Type != WarehouseType.LP_Consignment.ToString() && t.Type != WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }

                //list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals(AdjustWarehouseType.Consignment.ToString()))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        //T1 ,显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() || t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            return list;
        }


        #endregion



    }
}
