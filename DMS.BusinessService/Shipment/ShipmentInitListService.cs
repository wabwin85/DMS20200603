using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Shipment;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using DMS.Business.Excel;
using System.Collections.Specialized;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.DataAccess.DataInterface;
using DMS.Business;
using Grapecity.DataAccess.Transaction;
using System.Reflection;

namespace DMS.BusinessService.Shipment
{
    public class ShipmentInitListService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public ShipmentInitListVO Init(ShipmentInitListVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = IsDealer;

                DealerMasterDao dealerMasterDao = new DealerMasterDao();

                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary("ShipmentInitStatus");
                model.LstInitStatus = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
                model.LstDealer = dealerMasterDao.SelectFilterListAll("");
                model.LstDealerName = JsonHelper.DataTableToArrayList(GetDealerSource().ToDataSet().Tables[0]);

                if (IsDealer)
                {
                    KeyValue kvDealer = new KeyValue();
                    DealerMaster dealer = dealerMasterDao.GetObject(context.User.CorpId.ToSafeGuid());
                    kvDealer.Key = context.User.CorpId.ToSafeString();
                    kvDealer.Value = dealer.ChineseShortName;
                    model.QryDealer = kvDealer;
                    model.LstDealer = dealerMasterDao.SelectFilterListAll(dealer.ChineseShortName);
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

        public string Query(ShipmentInitListVO model)
        {
            try
            {
                ShipmentInitDao dao = new ShipmentInitDao();
                int totalCount = 0;

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.Add("DmaId", model.QryDealer.Key.ToSafeString());
                }
                else
                {
                    param.Add("DmaId", "");
                }
                if (!string.IsNullOrEmpty(model.QryShipmentInitStatus.Key))
                {
                    param.Add("ShipmentStatus", model.QryShipmentInitStatus.Key.ToSafeString());
                }
                else
                {
                    param.Add("ShipmentStatus", "");
                }
                if (!string.IsNullOrEmpty(model.QrySubmitDate.StartDate))
                {
                    param.Add("SubmitDateStart", model.QrySubmitDate.StartDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                else
                {
                    param.Add("SubmitDateStart", "19900101");
                }
                if (!string.IsNullOrEmpty(model.QrySubmitDate.EndDate))
                {
                    param.Add("SubmitDateEnd", model.QrySubmitDate.EndDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                else
                {
                    param.Add("SubmitDateEnd", "20991231");
                }
                if (!string.IsNullOrEmpty(model.QryShipmentInitNo))
                {
                    param.Add("ShipmentInitNo", model.QryShipmentInitNo.ToSafeString());
                }
                else
                {
                    param.Add("ShipmentInitNo", "");
                }
                //只能查询自己下的订单
                //BSC用户可以看所有订单，经销商用户只能看自己创建的订单
                if (IsDealer)
                {
                    param.Add("UserType", "Dealer");
                    param.Add("CreateUser", new Guid(RoleModelContext.Current.User.CorpId.Value.ToString()));
                }
                else
                {
                    param.Add("UserType", "User");
                    param.Add("CreateUser", new Guid(RoleModelContext.Current.User.CorpId.Value.ToString()));
                }
                int start = (model.Page - 1) * model.PageSize;
                param.Add("start", start);
                param.Add("limit", model.PageSize);
                DataSet query = dao.SelectShipmentInitList(param);
                DataTable dtCount = query.Tables[0];
                DataTable dtValue = query.Tables[1];

                model.RstImportResult = JsonHelper.DataTableToArrayList(dtValue);
                totalCount = Convert.ToInt32(dtCount.Rows[0]["CNT"].ToString());

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstImportResult, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public string QueryDetail(ShipmentInitListVO model)
        {
            try
            {
                int totalCount = 0;
                DataSet ds = new DataSet();
                IShipmentBLL business = new ShipmentBLL();
                Hashtable param = new Hashtable();
                param.Add("No", model.WinSelectNo.ToSafeString());
                int start = (model.Page - 1) * model.PageSize;

                if (model.WinSelectStatus.ToSafeString() == ShipmentInitStatus.Submitted.ToString())
                {
                    ds = business.QueryShipmentInitProcessing(param, start, model.PageSize, out totalCount);
                }
                else
                {
                    ds = business.QueryShipmentInitResult(param, start, model.PageSize, out totalCount);
                }

                model.DataCount = totalCount;
                model.IsSuccess = true;

                model.RstWinDetailResult = JsonHelper.DataTableToArrayList(ds.Tables[0]);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstWinDetailResult, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }
        public ShipmentInitListVO QueryDetailInit(ShipmentInitListVO model)
        {
            try
            {
                int totalCount = 0;
                DataSet ds = new DataSet();
                IShipmentBLL business = new ShipmentBLL();
                Hashtable param = new Hashtable();
                param.Add("No", model.WinSelectNo.ToSafeString());

                if (model.WinSelectStatus.ToSafeString() == ShipmentInitStatus.Submitted.ToString())
                {
                    ds = business.QueryShipmentInitProcessing(param, 0,int.MaxValue, out totalCount);
                }
                else
                {
                    ds = business.QueryShipmentInitResult(param, 0, int.MaxValue, out totalCount);
                }

                model.DataCount = totalCount;
                model.IsSuccess = true;

                model.RstWinDetailResult = JsonHelper.DataTableToArrayList(ds.Tables[0]);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        public string QueryErrorData(ShipmentInitListVO model)
        {
            try
            {
                int totalCount = 0;
                IShipmentBLL business = new ShipmentBLL();
                int start = (model.Page - 1) * model.PageSize;

                IList<ShipmentInit> list = business.QueryErrorData(start, model.PageSize, out totalCount);

                model.DataCount = totalCount;
                model.IsSuccess = true;

                model.RstInitImportResult = JsonHelper.DataTableToArrayList(list.ToDataSet().Tables[0]);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstInitImportResult, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public ShipmentInitListVO ShowDetailCnt(ShipmentInitListVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();

                model.WinWrongCnt = "错误记录：0条";
                model.WinCorrectCnt = "正确记录：0条";
                model.WinInProcessCnt = "处理中记录：0条";
                model.WinSumPrice = "销售总金额:0";
                model.WinSumQty = "销售总数量:0";
                Hashtable obj = new Hashtable();
                obj.Add("No", model.WinSelectNo.ToSafeString());
                obj.Add("Status", model.WinSelectStatus.ToSafeString());

                DataTable tb = business.GetShipmentInitSum(obj).Tables[0];

                if (tb.Rows.Count > 0)
                {
                    model.WinInProcessCnt = "处理中记录：" + tb.Rows[0]["ProcessingQuantity"].ToString() + "条";
                    model.WinWrongCnt = "错误记录：" + tb.Rows[0]["FailQuantity"].ToString() + "条";
                    model.WinCorrectCnt = "正确记录：" + tb.Rows[0]["SuccessQuantity"].ToString() + "条";
                    model.WinSumPrice = "销售总金额：" + tb.Rows[0]["SumAmount"].ToString();
                    model.WinSumQty = "销售总数量：" + tb.Rows[0]["SumQuantity"].ToString();
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

        public ShipmentInitListVO DeleteErrorData(ShipmentInitListVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();
                business.Delete(model.DelErrorId.ToSafeGuid());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ShipmentInitListVO ImportCorrectData(ShipmentInitListVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();
                //foreach (Newtonsoft.Json.Linq.JObject dtShipInit in model.RstInitImportResult)
                //{
                for (int i = 0; i < model.RstInitImportResult.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtShipInit = Newtonsoft.Json.Linq.JObject.Parse(model.RstInitImportResult[i].ToString());
                    ShipmentInit init = new ShipmentInit();
                    init.Id = dtShipInit["Id"].ToString().Replace("\"", "").ToSafeGuid();
                    init.HospitalCode = dtShipInit["HospitalCode"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.HospitalName = dtShipInit["HospitalName"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.HospitalOffice = dtShipInit["HospitalOffice"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.InvoiceNumber = dtShipInit["InvoiceNumber"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.InvoiceDate = ParseJsonDate(dtShipInit["InvoiceDate"].ToString().Replace("\"", "").ToSafeString()).ToString(); //String.IsNullOrEmpty(dtShipInit["InvoiceDate"].ToString().Replace("\"", "").ToSafeString()) ? null : dtShipInit["InvoiceDate"].ToString().Replace("\"", "").ToSafeString();
                    init.ShipmentDate = ParseJsonDate(dtShipInit["ShipmentDate"].ToString().Replace("\"", "").ToSafeString()).ToString();
                    init.ArticleNumber = dtShipInit["ArticleNumber"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.ChineseName = dtShipInit["ChineseName"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.LotNumber = dtShipInit["LotNumber"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.QrCode = dtShipInit["QrCode"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.Price = dtShipInit["Price"].ToString().Replace("\"", "").ToSafeString().Replace("null", "0.0");
                    init.Qty = dtShipInit["Qty"].ToString().Replace("\"", "").ToSafeString().Replace("null", "0.1");
                    init.Warehouse = dtShipInit["Warehouse"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.InvoiceTitle = dtShipInit["InvoiceTitle"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.LotShipmentDate = ParseJsonDate(dtShipInit["LotShipmentDate"].ToString().Replace("\"", "").ToSafeString()).ToString();//String.IsNullOrEmpty(dtShipInit["LotShipmentDate"].ToString().Replace("\"", "").ToSafeString()) ? null : dtShipInit["LotShipmentDate"].ToString().Replace("\"", "").ToSafeString();
                    init.Remark = dtShipInit["Remark"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.ConsignmentNbr = dtShipInit["ConsignmentNbr"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");

                    business.Update(init);
                }
                model.RstInitImportResult = null;

                string IsValid = string.Empty;

                if (business.Verify(out IsValid, 1))
                {
                    if (IsValid == "Success")
                    {

                        string rtnVal = string.Empty;
                        string rtnMsg = string.Empty;
                        business.InsertImportData(out rtnVal, out rtnMsg);
                        if (rtnVal == "Success")
                        {
                            business.UpdateReportInventoryHistory();
                            //business.DeleteByUser();

                            model.ExecuteMessage.Add("数据导入成功！");
                        }
                    }
                    else if (IsValid == "Error")
                    {
                        model.ExecuteMessage.Add("数据包含错误！");
                    }
                    else
                    {
                        model.ExecuteMessage.Add("数据导入异常！");
                    }
                }
                else
                {
                    model.ExecuteMessage.Add("数据导入过程发生错误！");
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstInitImportResult = null;
            return model;
        }

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable();

            param.Add("No", Parameters["WinSelectNo"].ToSafeString());
            param.Add("IsErr", "1");

            IShipmentBLL business = new ShipmentBLL();

            DataSet ds = business.ExportShipmentInitResult(param);
            ExportFile(ds, DownloadCookie);

        }

        #endregion

        protected void ExportFile(DataSet ds, string Cookie)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, Cookie);
        }

        protected DateTime? ParseJsonDate(string jsonDate)
        {
            DateTime dt;
            if (!string.IsNullOrEmpty(jsonDate.Replace("null", "")))
            {
                DateTime.TryParse(jsonDate, out dt);
                return dt;
            }
            else
            {
                return null;
            }
        }
    }
}
