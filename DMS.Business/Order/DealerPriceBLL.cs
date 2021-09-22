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

namespace DMS.Business
{
    public class DealerPriceBLL : IDealerPriceBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IClientBLL _clientBLL = new ClientBLL();

        public bool Import(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DealerPriceInitDao dao = new DealerPriceInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<Hashtable> list = new List<Hashtable>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        Hashtable data = new Hashtable();
                        data["Id"] = Guid.NewGuid();
                        data["User"] = new Guid(_context.User.Id);
                        data["UploadDate"] = DateTime.Now;
                        data["FileName"] = fileName;
                        data["LPId"] = _context.User.CorpId;

                        //ArticleNumber
                        data["ArticleNumber"] = dr[0] == DBNull.Value ? "" : dr[0].ToString().Trim();
                        if (string.IsNullOrEmpty(data["ArticleNumber"].ToString()))
                        {
                            data["ArticleNumberErrMsg"] = "产品型号为空";
                        }
                        else
                        {
                            data["ArticleNumberErrMsg"] = "";
                        }

                        //Dealer
                        data["Dealer"] = dr[1] == DBNull.Value ? "" : dr[1].ToString().Trim();

                        //Price
                        data["Price"] = dr[2] == DBNull.Value ? "" : dr[2].ToString().Trim();
                        if (!string.IsNullOrEmpty(data["Price"].ToString()))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data["Price"].ToString(), out qty))
                            {
                                data["PriceErrMsg"] = "价格格式不正确";
                            }
                            else
                            {
                                data["PriceErrMsg"] = "";
                            }
                        }
                        else
                        {
                            data["PriceErrMsg"] = "价格格式不正确";
                        }

                        //PriceType
                        data["PriceTypeName"] = dr[3] == DBNull.Value ? "" : dr[3].ToString().Trim();
                        if (string.IsNullOrEmpty(data["PriceTypeName"].ToString()))
                        {
                            data["PriceTypeErrMsg"] = "类型为空";
                        }
                        else
                        {
                            data["PriceTypeErrMsg"] = "";
                        }

                        data["LineNbr"] = lineNbr++;
                        data["ErrorFlag"] = !(string.IsNullOrEmpty(data["ArticleNumberErrMsg"].ToString())
                            && string.IsNullOrEmpty(data["PriceErrMsg"].ToString())
                            && string.IsNullOrEmpty(data["PriceTypeErrMsg"].ToString())
                            );

                        if (data["LineNbr"].ToString() != "1")
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

        /// <summary>
        /// 查询Excel订单导入出错信息
        /// </summary>
        /// <returns></returns>
        public DataSet QueryDealerPriceInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (DealerPriceInitDao dao = new DealerPriceInitDao())
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
        public bool VerifyDealerPriceInit(string importType, string remark, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DealerPriceInitDao dao = new DealerPriceInitDao())
            {
                IsValid = dao.Initialize(importType, new Guid(_context.User.Id), remark);
                result = true;
            }
            return result;
        }

        public void Update(Hashtable data)
        {
            using (DealerPriceInitDao dao = new DealerPriceInitDao())
            {
                dao.UpdateForEdit(data);
            }
        }

        public void Delete(Guid id)
        {
            using (DealerPriceInitDao dao = new DealerPriceInitDao())
            {
                dao.Delete(id);
            }
        }

        public DataSet QueryDealerPriceHead(Hashtable param, int start, int limit, out int totalRowCount)
        {
            using (DealerPriceInitDao dao = new DealerPriceInitDao())
            {
                return dao.SelectDealerPriceHeadByHashtable(param, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryDealerPriceDetail(String HId, int start, int limit, out int totalRowCount)
        {
            using (DealerPriceInitDao dao = new DealerPriceInitDao())
            {
                return dao.SelectDealerPriceDetailByHead(HId, start, limit, out totalRowCount);
            }
        }
    }
}
