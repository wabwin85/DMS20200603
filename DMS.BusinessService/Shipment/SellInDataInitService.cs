using DMS.Business.Shipment;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model;
using DMS.ViewModel.Shipment.Extense;
using Grapecity.DataAccess.Transaction;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Shipment
{
    public class SellInDataInitService : ABaseQueryService
    {
        ISellInDataInitBLL business = new SellInDataInitBLL();

        public bool ImportTemp(DataTable dt, out string isError)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            isError = "";
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    //先清空临时表数据
                    business.DeleteTempSellInData();

                    int lineNbr = 1;
                    List<SellInDetailInfoTemp> list = new List<SellInDetailInfoTemp>();
                    if (dt.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dt.Rows)
                        {
                            if (lineNbr != 1)
                            {
                                SellInDetailInfoTemp item = new SellInDetailInfoTemp();
                                item.Id = Guid.NewGuid();
                                item.CreatedBy = new Guid(UserInfo.Id);
                                item.InsertTime = DateTime.Now;
                                item.ModifiedBy = new Guid(UserInfo.Id);
                                item.ModifiedTime = DateTime.Now;
                                if (dr[0] == DBNull.Value || string.IsNullOrEmpty(dr[0].ToString()))
                                {
                                    item.ErrorMsg += "公司名不能为空";
                                }
                                else
                                    item.SubCompany = dr[0].ToString();
                                if (dr[1] == DBNull.Value || string.IsNullOrEmpty(dr[1].ToString()))
                                    item.ErrorMsg += "品牌不能为空";
                                else
                                    item.Brand = dr[1].ToString();
                                if (dr[2] == DBNull.Value || string.IsNullOrEmpty(dr[2].ToString()))
                                    item.ErrorMsg += "核算年份不能为空";
                                else
                                    item.AccountingYear = dr[2].ToString();
                                if (dr[3] == DBNull.Value || string.IsNullOrEmpty(dr[3].ToString()))
                                    item.ErrorMsg += "核算季度不能为空";
                                else
                                    item.AccountingQuarter = dr[3].ToString();
                                if (dr[4] == DBNull.Value || dr[4].ToString().Length != 2)
                                    item.ErrorMsg += "核算月份不能为空且长度必须为2";
                                else
                                    item.AccountingMonth = dr[4].ToString();
                                if (dr[5] == DBNull.Value || string.IsNullOrEmpty(dr[5].ToString()))
                                    item.ErrorMsg += "渠道不能为空";
                                else
                                    item.Channel = dr[5].ToString();
                                if (dr[6] == DBNull.Value && string.IsNullOrEmpty(dr[6].ToString()))
                                    item.ErrorMsg += "销售凭证不能为空";
                                else
                                    item.SalesIdentity = dr[6].ToString();
                                item.SalesIdentityRow = dr[7] == DBNull.Value ? string.Empty : dr[7].ToString();
                                item.OrderType = dr[8] == DBNull.Value ? string.Empty : dr[8].ToString();
                                if (dr[9] != DBNull.Value && dr[9].ToString() != string.Empty) 
                                    item.ActualDiscount = decimal.Parse(dr[9].ToString());
                                item.CompanyCode = dr[10] == DBNull.Value ? string.Empty : dr[10].ToString();
                                if (dr[11] != DBNull.Value && !string.IsNullOrEmpty(dr[11].ToString()))
                                    item.CompanyName = dr[11] == DBNull.Value ? string.Empty : dr[11].ToString();
                                else
                                    item.ErrorMsg += "公司名不能为空";
                                item.IsRelated = dr[12] == DBNull.Value ? string.Empty : dr[12].ToString();
                                item.RevenueType = dr[13] == DBNull.Value ? string.Empty : dr[13].ToString();
                                item.BorderType = dr[14] == DBNull.Value ? string.Empty : dr[14].ToString();
                                item.ProductLine = dr[15] == DBNull.Value ? string.Empty : dr[15].ToString();
                                item.ProductProvince = dr[16] == DBNull.Value ? string.Empty : dr[16].ToString();
                                if(dr[17]!=DBNull.Value && !string.IsNullOrEmpty(dr[17].ToString()))
                                    item.InvoiceDate = DateTime.Parse(dr[17].ToString());
                                if (dr[18] == DBNull.Value || string.IsNullOrEmpty(dr[18].ToString()))
                                    item.ErrorMsg += "售达方DMS Code不能为空";
                                else
                                    item.SoldPartyDealerCode = dr[18].ToString();

                                item.SoldPartySAPCode = dr[19] == DBNull.Value ? string.Empty : dr[19].ToString();
                                item.SoldPartyName = dr[20] == DBNull.Value ? string.Empty : dr[20].ToString();
                                 
                                item.BillingType = dr[21] == DBNull.Value ? string.Empty : dr[21].ToString();
                                item.Province = dr[22] == DBNull.Value ? string.Empty : dr[22].ToString();
                                if (dr[23] != DBNull.Value && !string.IsNullOrEmpty(dr[23].ToString()))
                                    item.ExchangeRate = decimal.Parse(dr[23].ToString());
                                if (dr[24] != DBNull.Value && !string.IsNullOrEmpty(dr[24].ToString()))
                                    item.MaterialCode = dr[24].ToString();
                                if (!Convert.IsDBNull(dr[25]) && !string.IsNullOrEmpty(dr[25].ToString()))
                                    item.MaterialName = dr[25].ToString(); 
                                item.UPN = dr[26] == DBNull.Value ? string.Empty : dr[26].ToString();
                                if (!Convert.IsDBNull(dr[27]) && !string.IsNullOrEmpty(dr[27].ToString()))
                                    item.OutInvoiceNum = int.Parse(dr[27].ToString());
                                if (dr[28] != DBNull.Value && !string.IsNullOrEmpty(dr[28].ToString()))
                                    item.InvoiceNetAmount = decimal.Parse(dr[28].ToString());
                                if (dr[29] != DBNull.Value && !string.IsNullOrEmpty(dr[29].ToString()))
                                    item.InvoiceRate = decimal.Parse(dr[29].ToString());
                                if (dr[30] != DBNull.Value && !string.IsNullOrEmpty(dr[30].ToString()))
                                    item.RebateNetAmount = decimal.Parse(dr[30].ToString());
                                if (dr[31] != DBNull.Value && !string.IsNullOrEmpty(dr[31].ToString()))
                                    item.RebateRate = decimal.Parse(dr[31].ToString());
                                if (dr[32] != DBNull.Value && !string.IsNullOrEmpty(dr[32].ToString()))
                                    item.InvoiceAmount = decimal.Parse(dr[32].ToString());
                                if (dr[33] != DBNull.Value && !string.IsNullOrEmpty(dr[33].ToString()))
                                    item.LocalCurrencyAmount = decimal.Parse(dr[33].ToString());
                                if (dr[34] != DBNull.Value && !string.IsNullOrEmpty(dr[34].ToString()))
                                    item.KLocalCurrencyAmount = decimal.Parse(dr[34].ToString());
                                if (dr[35] != DBNull.Value && !string.IsNullOrEmpty(dr[35].ToString()))
                                    item.DeliveryDate = DateTime.Parse(dr[35].ToString());
                                if (dr[36] != DBNull.Value && !string.IsNullOrEmpty(dr[36].ToString()))
                                    item.OrderCreateDate = DateTime.Parse(dr[36].ToString());
                                if (dr[37] != DBNull.Value && !string.IsNullOrEmpty(dr[37].ToString()))
                                    item.ProductLineAndSoldParty = dr[37].ToString();
                                if (dr[38] != DBNull.Value && !string.IsNullOrEmpty(dr[38].ToString()))
                                    item.ActualLegalEntity = dr[38].ToString();
                                if (dr[39] != DBNull.Value && !string.IsNullOrEmpty(dr[39].ToString()))
                                    item.IsNeedRecovery = dr[39].ToString();
                                if (dr[40] != DBNull.Value && !string.IsNullOrEmpty(dr[40].ToString()))
                                    item.RecoveryComment = dr[40].ToString();
                                if (dr[41] != DBNull.Value && !string.IsNullOrEmpty(dr[41].ToString()))
                                    item.BusinessCaliber = decimal.Parse( dr[41].ToString());
                                if (dr[42] != DBNull.Value && !string.IsNullOrEmpty(dr[42].ToString()))
                                    item.ClosedAccount = decimal.Parse(dr[42].ToString());
                                if (dr[43] != DBNull.Value && !string.IsNullOrEmpty(dr[43].ToString()))
                                    item.Comment = dr[43].ToString();
                                if (dr[44] != DBNull.Value && !string.IsNullOrEmpty(dr[44].ToString()))
                                {
                                    item.ProductGeneration = dr[44].ToString();
                                }
                                if (dr[45] != DBNull.Value && !string.IsNullOrEmpty(dr[45].ToString()))
                                {
                                    item.StandardPrice = decimal.Parse( dr[45].ToString());
                                }
                                if (dr[46] != DBNull.Value && !string.IsNullOrEmpty(dr[46].ToString()))
                                {
                                    item.Region = dr[46].ToString();
                                }
                                if (lineNbr != 1)
                                {
                                    if (string.IsNullOrEmpty(item.ErrorMsg))
                                    {
                                        item.ErrorMsg = "";
                                    }
                                    else
                                    {
                                        item.IsError = true;
                                        isError = item.ErrorMsg;
                                        break;
                                    }
                                    list.Add(item);
                                }
                            }
                            lineNbr += 1;

                        }
                        if (string.IsNullOrEmpty(isError))
                        {
                            business.BulkCopy(list);
                            result = true;
                            isError = "";
                            trans.Complete();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                isError = ex.Message;
                result = false;
            }
            return result;
        }

        public string VerifyTempData(string rtnVal, string rtnMsg)
        { 
            string rtnval = business.VerifyTempData(rtnMsg, rtnVal);
            return rtnval;
        }

        public string Query(SellInDataInitModelVO model)
        {
            try
            { 

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryErrorData(start, model.PageSize, out outCont);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = outCont;
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
            return JsonConvert.SerializeObject(result);
        }
    }
}
