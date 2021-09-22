using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model.Data;
using DMS.ViewModel.Transfer;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Transfer
{
    public class TransferEditorPickerService : ABaseQueryService
    {
        IRoleModelContext _context = RoleModelContext.Current;
        public TransferEditorPickerVO Init(TransferEditorPickerVO model)
        {
            try
            {
                string warehousetype = string.Empty;
                if (model.QryTransferType.ToString() == TransferType.Transfer.ToString())
                {
                    //warehousetype = "Normal";
                    warehousetype = "MoveNormal";//20191217，移库查看普通仓库与主仓库
                }
                else if (model.QryTransferType.ToString() == TransferType.Rent.ToString())
                {
                    warehousetype = "Normal";
                }
                else
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        warehousetype = "Borrow";
                    }
                    else
                    {
                        warehousetype = "Consignment";
                    }

                }
                if (model.QryTransferType.ToString() == TransferType.Transfer.ToString())
                {
                    if (_context.User.LoginId.Contains("_99"))
                    {
                        model.RstTransferWarehouseList = new ArrayList(TransferWarehouseByDealerAndType(new Guid(model.QryDealerFromId), warehousetype).ToList());
                    }
                    else
                    {
                        model.RstTransferWarehouseList = new ArrayList(NormalWarehousType(new Guid(model.QryDealerFromId), new Guid(model.QryProductLineWin), warehousetype).ToList());
                    }
                }
                else
                {
                    model.RstTransferWarehouseList = new ArrayList(TransferWarehouseByDealerAndType(new Guid(model.QryDealerFromId), warehousetype).ToList());
                }
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

        public string Query(TransferEditorPickerVO model)
        {
            try
            {
                string[] strCriteria;
                int iCriteriaNbr;
                ICurrentInvBLL business = new CurrentInvBLL();

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryDealerFromId))
                {
                    param.Add("DealerId", model.QryDealerFromId);
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
                if (model.QryTransferType == TransferType.Transfer.ToString() || model.QryTransferType == TransferType.Rent.ToString())
                {
                    string[] list = new string[2];
                    list[0] = WarehouseType.Normal.ToString();
                    list[1] = WarehouseType.DefaultWH.ToString();
                    param.Add("QryWarehouseType", list);
                }
                else if (model.QryTransferType == TransferType.RentConsignment.ToString())
                {
                    if (_context.User.CorpType == DealerType.HQ.ToString())
                    {
                        param.Add("QryWarehouseType", WarehouseType.Consignment.ToString().Split(','));
                    }
                    else
                    {
                        //string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(',')
                        //param.Add("QryWarehouseType", WarehouseType.LP_Consignment.ToString().Split(','));
                        param.Add("QryWarehouseType", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                    }
                }
                else
                {
                    if (_context.User.CorpType == DealerType.LP.ToString() || _context.User.CorpType == DealerType.T1.ToString())
                    {
                        param.Add("QryWarehouseType", WarehouseType.Consignment.ToString().Split(','));
                    }
                    else if (_context.User.CorpType == DealerType.LS.ToString())
                    {
                        param.Add("QryWarehouseType", WarehouseType.Borrow.ToString().Split(','));
                    }
                    else
                    {
                        param.Add("QryWarehouseType", WarehouseType.LP_Consignment.ToString().Split(','));
                    }
                }


                DataSet ds = business.QueryCurrentInv(param);

                //将结果集进行分页处理
                DataTable NewDt = GetPagedTable(ds.Tables[0], model.Page, model.PageSize);

                model.RstResultList = JsonHelper.DataTableToArrayList(NewDt);

                model.DataCount = ds.Tables[0].Rows.Count;
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

    }
}
