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
using System.Globalization;

namespace DMS.Business
{
    public class InventoryInitBLL : IInventoryInitBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define

        #endregion

        /// <summary>
        /// 将Excel文件中的数据导入到InventoryInit表，并做相应的初始化
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public bool Import(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    InventoryInitDao dao = new InventoryInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<InventoryInit> list = new List<InventoryInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        InventoryInit data = new InventoryInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        //SapCode
                        data.SapCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.SapCode))
                            data.SapCodeErrMsg = "经销商代码为空";

                        //WhmName
                        data.WhmName = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.WhmName))
                            data.WhmNameErrMsg = "仓库名称为空";

                        //Cfn
                        data.Cfn = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.Cfn))
                            data.CfnErrMsg = "产品型号为空";

                        //LtmExpiredDate
                        if (dr[3] != DBNull.Value)
                        {
                            DateTime date;
                            if (DateTime.TryParse(dr[3].ToString(), out date))
                                data.LtmExpiredDate = date.ToString("yyyy-MM-dd");
                            else
                                data.LtmExpiredDateErrMsg = "产品有效期格式不正确";
                        }
                        else
                        {
                            data.LtmExpiredDateErrMsg = "产品有效期为空";
                        }

                        //LtmLotNumber
                        data.LtmLotNumber = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (string.IsNullOrEmpty(data.LtmLotNumber))
                            data.LtmLotNumberErrMsg = "批号/序列号为空";

                        //Qty
                        data.Qty = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (!string.IsNullOrEmpty(data.Qty))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.Qty, out qty))
                                data.QtyErrMsg = "库存数量格式不正确";

                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.SapCodeErrMsg)
                            && string.IsNullOrEmpty(data.WhmNameErrMsg)
                            && string.IsNullOrEmpty(data.CfnErrMsg)
                            && string.IsNullOrEmpty(data.LtmExpiredDateErrMsg)
                            && string.IsNullOrEmpty(data.LtmLotNumberErrMsg)
                            && string.IsNullOrEmpty(data.QtyErrMsg)
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
            catch(Exception e)
            {
                System.Diagnostics.Debug.WriteLine("Exception : " + e.Message.ToString());
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        /// <summary>
        /// 验证数据是否符合要求
        /// </summary>
        /// <returns></returns>
        public bool Verify(out string IsValid)
        {
            bool result = false;
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            //调用存储过程验证数据
            using (InventoryInitDao dao = new InventoryInitDao())
            {
                Guid SubCompanyId = string.IsNullOrEmpty(Convert.ToString(ht["SubCompanyId"])) ? Guid.Empty : new Guid(ht["SubCompanyId"].ToString());
                Guid BrandId = string.IsNullOrEmpty(Convert.ToString(ht["BrandId"])) ? Guid.Empty : new Guid(ht["BrandId"].ToString());
                IsValid = dao.Initialize(new Guid(_context.User.Id), SubCompanyId, BrandId);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 验证数据是否符合要求（二次导入）
        /// </summary>
        /// <returns></returns>
        public bool Verify2(out string IsValid)
        {
            System.Diagnostics.Debug.WriteLine("Verify Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (InventoryInitDao dao = new InventoryInitDao())
            {
                IsValid = dao.Initialize2(new Guid(_context.User.Id));
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("Verify Finish : " + DateTime.Now.ToString());
            return result;
        }

        public IList<InventoryInit> QueryErrorData()
        {
            using (InventoryInitDao dao = new InventoryInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("UserId", new Guid(_context.User.Id));
                param.Add("Error", true);
                return dao.SelectByHashtable(param);
            }
        }

        public IList<InventoryInit> QueryErrorData(int start, int limit, out int totalRowCount)
        {
            using (InventoryInitDao dao = new InventoryInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("UserId", new Guid(_context.User.Id));
                param.Add("Error", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);
            }
        }

        public void Insert(InventoryInit data)
        {
            using (InventoryInitDao dao = new InventoryInitDao())
            {
                dao.Insert(data);
            }
        }

        public void Delete(Guid id)
        {
            using (InventoryInitDao dao = new InventoryInitDao())
            {
                dao.Delete(id);
            }
        }

        public void Update(InventoryInit data)
        {
            using (InventoryInitDao dao = new InventoryInitDao())
            {
                dao.UpdateForEdit(data);
            }
        }

        public IList<DealerInventoryInit> QueryDealerInventoryErrorData(int start, int limit, out int totalRowCount)
        {
            using (DealerInventoryInitDao dao = new DealerInventoryInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("UserId", new Guid(_context.User.Id));
                // param.Add("Error", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);
            }
        }

        public void DeleteByUser()
        {
            using (DealerInventoryInitDao dao = new DealerInventoryInitDao())
            {
                dao.DeleteByUser(new Guid(_context.User.Id));
            }
        }

        /// <summary>
        /// 将Excel文件中的数据导入到DealerInventoryInit表，并做相应的初始化
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public bool ImportDealerInv(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DealerInventoryInitDao dao = new DealerInventoryInitDao();
                    //删除上传人的数据
                    DeleteByUser();

                    int lineNbr = 1;
                    IList<DealerInventoryInit> list = new List<DealerInventoryInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        DealerInventoryInit data = new DealerInventoryInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.DmaId = _context.User.CorpId.Value;
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;
                        data.Warehouse = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.Warehouse))
                            data.WarehouseErrMsg = "仓库名称为空";
                        data.ArticleNumber = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品型号为空";

                        data.LotNumber = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (string.IsNullOrEmpty(data.LotNumber))
                            data.LotNumberErrMsg = "批号为空";
                        data.Qty = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (!string.IsNullOrEmpty(data.Qty))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.Qty, out qty))
                                data.QtyErrMsg = "库存数量格式不正确";

                        }
                        else
                        {
                            data.QtyErrMsg = "库存数量为空";
                        }
                        data.Period = dr[6] == DBNull.Value ? null : dr[6].ToString();
                        if (!string.IsNullOrEmpty(data.Period))
                        {
                            if (data.Period.Length != 6)
                            {
                                data.PeriodErrMsg = "库存期间有误";
                            }
                        }
                        else
                        {
                            data.PeriodErrMsg = "库存期间为空";
                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.WarehouseErrMsg)
                            && string.IsNullOrEmpty(data.ArticleNumberErrMsg)
                            && string.IsNullOrEmpty(data.LotNumberErrMsg)
                            && string.IsNullOrEmpty(data.QtyErrMsg)
                            && string.IsNullOrEmpty(data.PeriodErrMsg)
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

        /// <summary>
        /// 验证数据是否正确,0仅校验，1校验并导入
        /// </summary>
        /// <returns></returns>
        public bool VerifyDII(out string IsValid, int IsImport)
        {
            System.Diagnostics.Debug.WriteLine("Verify Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (DealerInventoryInitDao dao = new DealerInventoryInitDao())
            {
                Guid SubCompanyId = string.IsNullOrEmpty(Convert.ToString(ht["SubCompanyId"])) ? Guid.Empty : new Guid(ht["SubCompanyId"].ToString());
                Guid BrandId = string.IsNullOrEmpty(Convert.ToString(ht["BrandId"])) ? Guid.Empty : new Guid(ht["BrandId"].ToString());
                IsValid = dao.InitializeDII(new Guid(_context.User.Id), IsImport, SubCompanyId, BrandId);
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("Verify Finish : " + DateTime.Now.ToString());
            return result;
        }

        public void DeleteDII(Guid id)
        {
            using (DealerInventoryInitDao dao = new DealerInventoryInitDao())
            {
                dao.Delete(id);
            }
        }

        public void UpdateDII(DealerInventoryInit obj)
        {
            using (DealerInventoryInitDao dao = new DealerInventoryInitDao())
            {
                dao.UpdateDII(obj);
            }
        }

        public IList<DealerInventoryData> QueryDID(Hashtable param, int start, int limit, out int totalCount)
        {
            using (DealerInventoryDataDao dao = new DealerInventoryDataDao())
            {
                return dao.SelectByHashtable(param, start, limit, out totalCount);
            }

        }



        public DealerInventoryData QueryRecord(Hashtable param)
        {
            using (DealerInventoryDataDao dao = new DealerInventoryDataDao())
            {
                return dao.SelectRecordByHashtable(param);
            }

        }

    }
}
