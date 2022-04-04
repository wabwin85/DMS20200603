using DMS.Business.Excel;
using DMS.Business.Shipment;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model;
using DMS.ViewModel.Shipment.Extense;
using Grapecity.DataAccess.Transaction;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Shipment
{ 
    public class EmbedDataInitService : ABaseQueryService, IQueryExport
    {
        IEmbedDataInitBLL business = new EmbedDataInitBLL();
        public bool ImportTemp(DataTable dt, out string isError)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            isError = string.Empty;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                { 
                    //先清空临时表数据
                    business.DeleteTempEmbedData();
                     
                    int lineNbr = 1;
                    List<SellOutDetailInfoTemp> list = new List<SellOutDetailInfoTemp>();
                    if(dt.Rows.Count>0)
                    {
                        foreach (DataRow dr in dt.Rows)
                        {
                            if (lineNbr != 1)
                            {
                                SellOutDetailInfoTemp item = new SellOutDetailInfoTemp();
                                item.Id = Guid.NewGuid();
                                item.CreatedBy = new Guid(UserInfo.Id);
                                item.CreateDate = DateTime.Now;
                                item.ModifiedBy = new Guid(UserInfo.Id);
                                item.ModifiedTime = DateTime.Now;
                                if (dr[0] == DBNull.Value || string.IsNullOrEmpty( dr[0].ToString()))
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
                                if (dr[3] == DBNull.Value || string.IsNullOrEmpty(dr[3].ToString()) || dr[3].ToString().Length != 2)
                                    item.ErrorMsg += "核算月份不能为空且长度必须为2";
                                else
                                    item.AccountingMonth = dr[3].ToString();
                                if (dr[4] == DBNull.Value || string.IsNullOrEmpty(dr[4].ToString()))
                                    item.ErrorMsg += "经销商编号不能为空";
                                else
                                    item.DealerCode = dr[4].ToString();
                                if (dr[5] == DBNull.Value || string.IsNullOrEmpty(dr[5].ToString()))
                                    item.ErrorMsg += "经销商名称不能为空";
                                else
                                    item.DealerName = dr[5].ToString();
                                item.LegalEntity = dr[6] == DBNull.Value ? string.Empty : dr[6].ToString();
                                item.SalesEntity = dr[7] == DBNull.Value ? string.Empty : dr[7].ToString();
                                item.Hos_Level = dr[8] == DBNull.Value ? string.Empty : dr[8].ToString();
                                item.Hos_Type = dr[9] == DBNull.Value ? string.Empty : dr[9].ToString();
                                item.Hos_Code = dr[10] == DBNull.Value ? string.Empty : dr[10].ToString();
                                item.Hos_Name = dr[11] == DBNull.Value ? string.Empty : dr[11].ToString();
                                item.NewOpenMonth = dr[12] == DBNull.Value ? string.Empty : dr[12].ToString();
                                item.NewOpenProduct = dr[13] == DBNull.Value ? string.Empty : dr[13].ToString();
                                item.Region = dr[14] == DBNull.Value ? string.Empty : dr[14].ToString();
                                item.Province = dr[15] == DBNull.Value ? string.Empty : dr[15].ToString();
                                item.City = dr[16] == DBNull.Value ? string.Empty : dr[16].ToString();
                                item.CityLevel = dr[17] == DBNull.Value ? string.Empty : dr[17].ToString(); 
                                item.RegionOwner = dr[18] == DBNull.Value ? string.Empty : dr[18].ToString();
                                item.SalesRepresentative = dr[19] == DBNull.Value ? string.Empty : dr[19].ToString();
                                if (dr[20] == DBNull.Value || string.IsNullOrEmpty(dr[20].ToString()))
                                    item.ErrorMsg += "规格型号不能为空";
                                else
                                    item.PMA_UPN = dr[20] == DBNull.Value ? string.Empty : dr[20].ToString();
                                if (dr[21] == DBNull.Value || string.IsNullOrEmpty(dr[21].ToString()))
                                    item.ErrorMsg += "商品名称不能为空";
                                else
                                    item.CFN_Name = dr[21] == DBNull.Value ? string.Empty : dr[21].ToString();
                                if (dr[22] == DBNull.Value || string.IsNullOrEmpty(dr[22].ToString()))
                                    item.ErrorMsg += "产品线不能为空";
                                else
                                    item.ProductLine = dr[22].ToString();
                                if (dr[23] != DBNull.Value || string.IsNullOrEmpty(dr[23].ToString()))
                                    item.ShipmentNbr = dr[23].ToString();
                                if (!Convert.IsDBNull(dr[24]) && !string.IsNullOrEmpty(dr[24].ToString()))
                                {
                                    DateTime dtime;
                                    DateTime.TryParse(dr[24].ToString(), out dtime);
                                    if(dtime == null)
                                    {
                                        item.ErrorMsg += "用量日期格式不合法，请检查";
                                    }
                                    else
                                        item.UsedDate = dtime;
                                }   
                                else
                                    item.UsedDate = null;
                                if (dr[25] == DBNull.Value || string.IsNullOrEmpty(dr[25].ToString()))
                                    item.ErrorMsg += "发票号码不能为空";
                                else
                                    item.InvoiceNumber = dr[25].ToString();
                                if (dr[26] != DBNull.Value && !string.IsNullOrEmpty(dr[26].ToString()))
                                {
                                    DateTime dtime;
                                    DateTime.TryParse(dr[26].ToString(), out dtime);
                                    if (dtime == null)
                                    {
                                        item.ErrorMsg += "发票日期格式不合法，请检查";
                                    }
                                    else
                                        item.InvoiceDate = DateTime.Parse(dr[26].ToString());
                                }
                                if (dr[27] != DBNull.Value && !string.IsNullOrEmpty(dr[27].ToString()))
                                {
                                    DateTime dtime;
                                    DateTime.TryParse(dr[27].ToString(), out dtime);
                                    if (dtime == null)
                                    {
                                        item.ErrorMsg += "发票上传日期格式不合法，请检查";
                                    }
                                    else
                                        item.InvoiceUploadDate = dtime;
                                }
                                item.Status = dr[28] == DBNull.Value ? string.Empty : dr[28].ToString();
                                item.IsValidate = (dr[29] == DBNull.Value ? string.Empty : dr[29].ToString()) == "已校验" ? true : false;
                                item.Unit = DBNull.Value == dr[30] ? string.Empty : dr[30].ToString();
                                if (dr[31] != DBNull.Value && !string.IsNullOrEmpty(dr[31].ToString()))
                                    item.Quantity = Math.Round( decimal.Parse(dr[31].ToString()),2);
                                if (dr[32] != DBNull.Value && !string.IsNullOrEmpty(dr[32].ToString()))
                                    item.InvoicePrice = Math.Round( decimal.Parse(dr[32].ToString()),2);
                                if (dr[33] != DBNull.Value && !string.IsNullOrEmpty(dr[33].ToString()))
                                    item.InvoiceRate = Math.Round( decimal.Parse(dr[33].ToString()),2);
                                if (dr[34] != DBNull.Value && !string.IsNullOrEmpty(dr[34].ToString()))
                                    item.AssessUnitPrice = Math.Round( decimal.Parse(dr[34].ToString()),2);
                                else
                                    item.ErrorMsg = "考核单价（未税）不能为空";
                                if (dr[35] != DBNull.Value && !string.IsNullOrEmpty(dr[35].ToString()))
                                {
                                    decimal assessPrice;
                                    decimal.TryParse(dr[35].ToString(), out assessPrice);
                                    item.AssessPrice = Math.Round( assessPrice,2);
                                }
                                else
                                    item.ErrorMsg += "考核金额（未税）不能为空";
                                if(dr[36]!=DBNull.Value && !string.IsNullOrEmpty(dr[36].ToString()))
                                {
                                    item.Remark = dr[36].ToString();
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
            catch(Exception ex)
            {
                isError = ex.Message;
                result = false;
                
            }
            return result;
        }

        public string VerifyTempData(string rtnVal, string rtnMsg)
        {
          
           string rtnval =  business.VerifyTempData(rtnMsg, rtnVal);
            return rtnval;
        }

        public string Query(EmbedDataInitModelVO model)
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

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            IEmbedDataInitBLL business = new EmbedDataInitBLL();
            Hashtable ht = new Hashtable(); 
            DataSet ds = business.QueryTempEmbedDataInfo();
            DataSet dsExport = new DataSet("植入上传数据");
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataTable dtData = dt.Copy();

                if (null != dtData)
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"ErrorMsg","错误信息" },
                            {"SubCompany", "分子公司"},
                            {"Brand", "品牌"},
                            {"AccountingYear", "核算年份"},
                            {"AccountingMonth", "核算月份"},
                            {"DealerCode", "DMS经销商编号"},
                            {"DealerName", "经销商名称"},
                            {"LegalEntity","实控方"},
                             {"SalesEntity","销售方名称（发票卖方）"} ,
                             {"Hos_Level","医院等级"},
                             {"Hos_Type","医院类型"},
                             {"Hos_Code","DMS医院编号"},
                             {"Hos_Name","医院名称（发票买方）"},
                             {"NewOpenMonth","新开月份"},
                             {"NewOpenProduct","新开产品"},
                             {"Region","区域"},
                             {"Province","省份"},
                             {"City","城市"},
                             {"CityLevel","城市等级"},
                             {"RegionOwner","区域总监"},
                             {"SalesRepresentative","销售代表"},
                             {"PMA_UPN","规格型号"},
                             {"CFN_Name","商品名称"},
                             {"ProductLine","产品线"},
                             {"ShipmentNbr","出库单号"},
                             {"UsedDate","出库/用量日期"},
                             {"InvoiceNumber","发票号码"},
                              {"InvoiceDate","发票日期"},
                              {"InvoiceUploadDate","发票上传日期"},
                              {"Status","状态"},
                             {"IsValidate","是否校验"},
                             {"Unit","单位"},
                             {"Quantity","数量"},
                            {"InvoicePrice","发票单价（不含税)"},
                            {"InvoiceRate","税率"},
                            {"AssessUnitPrice","考核单价（未税）"},
                            {"AssessPrice","考核金额（未税）"},
                            {"Remark","备注"}
                        };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);
                    dsExport.Tables.Add(dtData);
                }

                ExportFile(dsExport, DownloadCookie);
            }
        }

        protected void ExportFile(DataSet ds, string Cookie)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, Cookie);
        }
    }
}
