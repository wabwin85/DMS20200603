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

namespace DMS.Business
{
    public class BatchOrderInitBLL : IBatchOrderInitBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        //数据初步的校验
        public DataSet  QueryBatchOrderInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (BatchOrderInitDao dao = new BatchOrderInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("User", new Guid(_context.User.Id));
                //param.Add("ErrorFlag", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);
            }
        }
        //上传成功后 输出IsValid
        public bool VerifyBatchOrderInitBLL(string ImportType, out string IsValid)
        {
            bool result = false;
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            //调用存储过程验证数据
            using (BatchOrderInitDao dao = new BatchOrderInitDao())
            {
                IsValid = dao.Initialize(ImportType, new Guid(_context.User.Id), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
                result = true;
            }
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
                    BatchOrderInitDao dao = new BatchOrderInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<BatchOrderInit> list = new List<BatchOrderInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        BatchOrderInit data = new BatchOrderInit();
                        data.Id = Guid.NewGuid().ToString();
                        data.User = _context.User.Id;
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;                      
                        //data.OrderType = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        ////if (string.IsNullOrEmpty(data.OrderType))
                        //{
                        //    data.OrderTypeErrMsg = "单据类型为空";
                        //}
                        //else if (data.OrderType != "寄售订单")
                        //{
                        //    data.OrderTypeErrMsg = "单据类型不正确";
                        //}
                        
                       
                        data.SapCode = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.SapCode))
                            data.SapCodeErrMsg = "经销商SAP编号为空";
          

                        data.ProductLine = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.ProductLine))
                            data.ProductLineErrMsg = "产品线为空";
                        
                        data.ArticleNumber = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品编号为空";
                        
                        data.LotNumber = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (string.IsNullOrEmpty(data.LotNumber))
                            data.LotNumberErrMsg = "批号为空";
                        
                        data.RequiredQty = dr[6] == DBNull.Value ? null : dr[6].ToString();
                        if (string.IsNullOrEmpty(data.RequiredQty))
                           data.RequiredQtyErrMsg = "订购数量为空";

                      



                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.ArticleNumberErrMsg)                           
                            && string.IsNullOrEmpty(data.RequiredQtyErrMsg)
                            && string.IsNullOrEmpty(data.AmountErrMsg)
                            && string.IsNullOrEmpty(data.LotNumberErrMsg)
                            && string.IsNullOrEmpty(data.ProductLineErrMsg)
                            );

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }

                    }
                    dao.BatchOrderInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch(Exception ex)
            {
                string strEx = ex.Message.ToString();
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }
        //用户下载模板直接删除
        public int DeleteBatchOrderInit(Guid UserId)
        {
            //调用存储过程验证数据
            using (BatchOrderInitDao dao = new BatchOrderInitDao())
            {
                return dao.DeleteByUser(new Guid(_context.User.Id));

            }
        }
    }
}






