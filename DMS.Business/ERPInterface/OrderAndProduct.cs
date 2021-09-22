using DMS.DataAccess.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Web.Script.Serialization;
using System.Collections;
using DMS.DataAccess;
using Grapecity.DataAccess.Transaction;
using DMS.Common.Common;
/// <summary>
/// ERP接口程序
/// 平台采购数据推送ERP
/// 获取ERP物料信息
/// </summary>
namespace DMS.Business.ERPInterface
{
    public class OrderAndProduct
    {
        //K3CloudApiClient client;
        HttpClient httpClient = new HttpClient();
        public OrderAndProduct()
        {
            string strResult = "";
            try
            {
                string URL = System.Configuration.ConfigurationManager.AppSettings["ERPLoginInUrl"];
                string userName = System.Configuration.ConfigurationManager.AppSettings["ERPUserName"];
                string passWord = System.Configuration.ConfigurationManager.AppSettings["ERPPassWord"];
                string dbID = System.Configuration.ConfigurationManager.AppSettings["ERPDBID"];
                string lcID = System.Configuration.ConfigurationManager.AppSettings["ERPLCID"];
                int intLCID = 0;                
                intLCID = int.Parse(lcID);

                //登陆验证参考：
                //HttpClient httpClient = new HttpClient();
                httpClient.Url = URL;
                List<object> Parameters = new List<object>();
                Parameters.Add(dbID);//帐套Id
                Parameters.Add(userName);//用户名
                Parameters.Add(passWord);//密码
                Parameters.Add(intLCID);
                httpClient.Content = JsonConvert.SerializeObject(Parameters);                
                strResult = httpClient.AsyncRequest();               
                var iResult = JObject.Parse(strResult)["LoginResultType"].Value<int>();
                if (iResult != 1 && iResult != -5)
                {
                    throw new Exception("金碟ERP接口登录验证出错,返回值：" + iResult);
                }                
            }
            catch(Exception ex)
            {
                throw new Exception("金碟ERP接口配置错误"+ strResult);
            }
        }
        /// <summary>
        /// 批量查询物料
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public bool GetMaterials()
        {
            bool ret = false;
            DateTime startTime = DateTime.Now;
            string formId = "BD_MATERIAL";// 固定值 formId
            httpClient.Url = System.Configuration.ConfigurationManager.AppSettings["ERPProductUrl"];
            string FieldKeys = System.Configuration.ConfigurationManager.AppSettings["ProductFieldKeys"];
            string FilterString = System.Configuration.ConfigurationManager.AppSettings["ProductFilterString"];
            JObject data = new JObject();
            //查询表单
            data.Add("FormId", SafeJTokenFromObject(formId));
            //允许查询最大值 0 标识不限制
            data.Add("TopRowCount", SafeJTokenFromObject(0));
            //分页取数每页允许获取的数据，最大不能超过2000
            data.Add("Limit", SafeJTokenFromObject(0));
            //分页取数开始行索引，从0开始，例如每页10行数据，第2页开始是10，第3页开始是20
            data.Add("StartRow", SafeJTokenFromObject(0));
            //查询列
            data.Add("FieldKeys", SafeJTokenFromObject(FieldKeys));
            //查询条件
            data.Add("FilterString", SafeJTokenFromObject(FilterString));

            List<object> Parameters = new List<object>();
            Parameters.Add(data.ToString());
            httpClient.Content = JsonConvert.SerializeObject(Parameters);
            string strResult = httpClient.AsyncRequest();
            DateTime endTime = DateTime.Now;
            LogHelper.Error("ProductInterface---starttime:"+ startTime +"\r\n" + strResult + "ProductInterface---endtime:"+ endTime + "\r\n");
            InsertWorkflowLog(Guid.NewGuid().ToString(), startTime, endTime, JsonConvert.SerializeObject(Parameters), "", ret, "ProductInterface");
            string errmsg = "";
            int intE = AnalysisResult(strResult, out errmsg);
            ret = true;
            if (intE == 1)
            {
                ret = true;
            }
            else if (intE == 2)
            {
                ret = false;
                throw new Exception(errmsg);
            }
            else
            {
                ret = false;
                throw new Exception(strResult);
            }
            return ret;
        }

        /// <summary>
        /// 新增销售订单
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public bool AddSaleOrderToERP(string ApplyId,string data,out string errMsg)
        {
            bool ret = false;
            DateTime startTime = DateTime.Now;
            string formId = "SAL_SaleOrder";// 固定值 formId
            //string result = client.Save(formId, XML);//批量查询，返回值无字段标识，与fieldKeys中的索引顺序一致。

            //HttpClient httpClient = new HttpClient();
            httpClient.Url = System.Configuration.ConfigurationManager.AppSettings["ERPLpOrderUrl"];
            List<object> Parameters = new List<object>();
            Parameters.Add(formId);
            Parameters.Add(data);
            httpClient.Content = JsonConvert.SerializeObject(Parameters);
            string strResult = httpClient.AsyncRequest();
            int intE = AnalysisResult(strResult, out errMsg);
            
            DateTime endTime = DateTime.Now;
            
            if (intE==1)
            {
                ret = true;
                
            }
            else if(intE==2)
            {
                ret = false;
                //throw new Exception(errmsg);
            }
            else
            {
                ret = false;
                //throw new Exception(strResult);
                errMsg = strResult;
            }
            InsertWorkflowLog(ApplyId, startTime, endTime, JsonConvert.SerializeObject(Parameters), strResult, ret, errMsg);
            return ret;           
        }
        /// <summary>
        /// 新增退货单
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public bool AddReturnOrder(string ApplyId, string data, out string errMsg)
        {
            bool ret = false;
            DateTime startTime = DateTime.Now;
            string formId = "BGP_ReturnNotice";// 固定值 formId
            httpClient.Url = System.Configuration.ConfigurationManager.AppSettings["ERPLpOrderUrl"];
            List<object> Parameters = new List<object>();
            Parameters.Add(formId);
            Parameters.Add(data);
            httpClient.Content = JsonConvert.SerializeObject(Parameters);
            string strResult = httpClient.AsyncRequest();
            int intE = AnalysisResult(strResult, out errMsg);

            DateTime endTime = DateTime.Now;

            if (intE == 1)
            {
                ret = true;
            }
            else if (intE == 2)
            {
                ret = false;
            }
            else
            {
                ret = false;
                errMsg = strResult;
            }
            InsertWorkflowLog(ApplyId, startTime, endTime, JsonConvert.SerializeObject(Parameters), strResult, ret, errMsg);
            return ret;
        }
        /// <summary>
        /// 新增接口日志
        /// </summary>
        /// <param name="startTime"></param>
        /// <param name="endTime"></param>
        /// <param name="requestMessage"></param>
        /// <param name="responseMessage"></param>
        public void InsertWorkflowLog(string applyId, DateTime startDate, DateTime endDate, string requestMessage, string responseMessage, bool success, string errMsg)
        {
            using (WorkflowLogDao dao = new WorkflowLogDao())
            {
                try
                {
                    WorkflowLog log = new WorkflowLog();
                    log.Id = Guid.NewGuid();
                    log.ApplyId = new Guid(applyId);
                    log.StartTime = startDate;
                    log.EndTime = endDate;
                    log.Status = success ? "Success" : "Failure";
                    log.RequestMessage = requestMessage == null ? string.Empty : requestMessage;
                    log.ResponseMessage = responseMessage == null ? string.Empty : responseMessage;
                    log.FileName = errMsg;
                    dao.InsertWorkflowLog(log);
                }
                catch (Exception ex)
                {

                }
            }
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
        /// <summary>
        /// 解析金蝶发回JSON数据
        /// </summary>
        /// <param name="Result"></param>
        /// <returns>-1 解析异常抛前台返回数据，1返回成功，2返回失败抛出errmsg</returns>
        public int AnalysisResult(string Result, out string errmsg)
        {
            int ret = -1;
            errmsg = "";
            try
            {
                if (Result.StartsWith("{"))
                {
                    var result = JObject.Parse(Result)["Result"];
                    var responseStatus = result["ResponseStatus"];
                    bool isSuccess = responseStatus["IsSuccess"].Value<bool>();
                    if (isSuccess)
                    {
                        ret = 1;
                    }
                    else
                    {
                        ret = 2;
                        errmsg = responseStatus["Errors"].ToString();
                    }
                }
                else if (Result.StartsWith("["))//产品接口解析
                {
                    DataTable interfacePro = JsonToDataTable(Result);
                    using (TransactionScope trans = new TransactionScope())
                    {
                        using (ProductDao bsmd = new ProductDao())
                        {
                            bsmd.ExecuteBatchInsert("InterfaceERPProduct", interfacePro);
                        }
                        trans.Complete();
                    }
                    ret = 1;
                }
                else
                {
                    ret = 0;
                }
            }
            catch(Exception ex)
            {
                ret = -1;
            }
            return ret;
        }

        /// <summary>
        /// JSON 转换 dataTable
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        public DataTable JsonToDataTable(string json)
        {
            DataTable dataTable = new DataTable();  //实例化
            DataTable result;
            try
            {
                string FieldKeys = System.Configuration.ConfigurationManager.AppSettings["ProductFieldKeys"];
                string[] arrField = FieldKeys.Split(',');
                ArrayList arrayList = new JavaScriptSerializer().Deserialize<ArrayList>(json);
                if (arrayList.Count > 0)
                {
                    //添加列名
                    if (dataTable.Columns.Count == 0)
                    {
                        foreach (string current in arrField)
                        {
                            dataTable.Columns.Add(current, typeof(String));
                        }
                        dataTable.Columns.Add("ID", typeof(Guid));
                        dataTable.Columns.Add("ImportDate", typeof(DateTime));
                        dataTable.Columns.Add("ProcessDate", typeof(DateTime));
                        dataTable.Columns.Add("IsProcess", typeof(Int32));
                    }
                    foreach (ArrayList product in arrayList)
                    {
                        object[] listProduct = product.ToArray();                                                
                        DataRow dataRow = dataTable.NewRow();
                        for (int i=0;i< listProduct.Count(); i++)
                        {
                            dataRow[i] = Convert.ToString(listProduct[i]);
                        }
                        dataRow["ID"] = Guid.NewGuid();
                        dataRow["ImportDate"] = DateTime.Now;
                        dataRow["ProcessDate"] = DBNull.Value;
                        dataRow["IsProcess"] = 0;
                        dataTable.Rows.Add(dataRow); //循环添加行到DataTable中
                    }
                }
            }
            catch(Exception ex)
            {
            }
            result = dataTable;
            return result;
        }

    }
}
