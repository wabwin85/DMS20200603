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

namespace DMS.Business
{
    public class InventorySafetyBLL : IInventorySafetyBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;


        //获取经销商安全库存，带分页
        public DataSet GetInventoryByDMACFN(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (InventorySafetyDao dao = new InventorySafetyDao())
            {
                BaseService.AddCommonFilterCondition(table);
                return dao.GetInventoryByDMACFN(table, start, limit, out totalRowCount);
            }
        }

        //获取经销商授权产品的实际库存信息，带分页
        public DataSet GetActualInvQtyByCFN(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (InventorySafetyDao dao = new InventorySafetyDao())
            {

                return dao.GetActualInvQtyByCFN(table, start, limit, out totalRowCount);
            }
        }

        //获取经销商共享产品的实际库存信息，带分页
        public DataSet GetActualInvQtyOfShareCFN(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (InventorySafetyDao dao = new InventorySafetyDao())
            {

                return dao.GetActualInvQtyOfShareCFN(table, start, limit, out totalRowCount);
            }
        }

        //添加选择的产品，默认安全库存为0
        public bool AddItemsCfn(Guid DealerId, string[] PmaIds)
        {
            bool result = false;

            InventorySafety IS = null;

            using (TransactionScope trans = new TransactionScope())
            {
                InventorySafetyDao IsDao = new InventorySafetyDao();

                foreach (string PmaId in PmaIds)
                {
                    //判断InventorySafety表是否已经有记录

                    IS = GetInventorySafetyByDMACFN(new Guid(PmaId), DealerId);
                    if (IS == null)
                    {
                        //如果记录不存在，则新增记录
                        IS = new InventorySafety();
                        IS.Id = Guid.NewGuid();
                        IS.DealerDmaId = DealerId;
                        IS.CfnId = new Guid(PmaId);
                        IS.Qty = 0;  //缺省数量置为0。                        
                        IsDao.Insert(IS);
                    }
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        //根据经销商及产品获取安全库存
        public InventorySafety GetInventorySafetyByDMACFN(Guid CFNID, Guid DealerID)
        {
            using (InventorySafetyDao dao = new InventorySafetyDao())
            {
                Hashtable param = new Hashtable();
                param.Add("CfnId", CFNID);
                param.Add("DealerDmaId", DealerID);

                IList<InventorySafety> IS = dao.GetInventorySafetyByDMACFN(param);

                if (IS.Count > 0)
                {
                    return IS[0];
                }
            }
            return null;
        }

        public int UpdateInventoryQty(Guid Id, double Qty)
        {
            using (InventorySafetyDao dao = new InventorySafetyDao())
            {
                Hashtable param = new Hashtable();
                param.Add("Qty", Qty);
                param.Add("Id", Id);

                int iRe = dao.UpdateQty(param);

                return iRe;
            }

        }


        //复制当前库存为安全库存
        public bool UpdateSafetyQtyWithAcutalQty(Guid DealerId)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                InventorySafetyDao IsDao = new InventorySafetyDao();
                IsDao.UpdateSafetyQtyWithAcutalQty(DealerId);
                IsDao.InsertSafetyQtyWithAcutalQty(DealerId);

                trans.Complete();
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 导入安全库存中间表
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public bool ImportInventorySafetyInit(DataSet ds, string fileName)
        {
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    InventorySafetyInitDao dao = new InventorySafetyInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));
                    //读取DataSet数据至数据库
                    int lineNbr = 1;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        string errString = string.Empty;
                        InventorySafetyInit data = new InventorySafetyInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;
                        //if (_context.User.CorpId.HasValue)
                        //{
                        //    data.DmaId = _context.User.CorpId.Value;
                        //}
                        //else
                        //{
                        //    errString += "请使用经销商帐号导入订单,";
                        //}

                        if (dr[0] == DBNull.Value)
                        {
                            errString += "经销商编号(ERP编号)为空,";
                        }
                        else
                        {
                            data.DealerSapCode = dr[0].ToString().Trim();
                        }

                        if (dr[2] == DBNull.Value)
                        {
                            errString += "仓库名称为空,";

                        }

                        else
                        {
                            data.Warehouse = dr[2].ToString().Trim();

                        }

                        if (dr[3] == DBNull.Value)
                        {
                            errString += "产品型号为空,";
                        }
                        else
                        {
                            data.ArticleNumber = dr[3].ToString().Trim();
                        }
                        if (dr[4] == DBNull.Value)
                        {
                            //data.Qty=dr[4]
                            errString += "安全库存数量为空,";
                        }
                        else
                        {
                            try
                            {
                                data.Qty = Convert.ToInt32(dr[4].ToString().Trim());
                                if (data.Qty <= 0)
                                {
                                    throw new Exception("安全库存数量不能小于0");
                                }
                            }
                            catch
                            {
                                errString += "安全库存数量必须为正整数,";
                            }
                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !string.IsNullOrEmpty(errString);
                        data.ErrorDescription = errString;

                        if (data.LineNbr != 1)
                        {
                            dao.Insert(data);
                        }
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

        /// <summary>
        /// 调用存储过程处理Excel导入数据
        /// </summary>
        /// <param name="IsValid"></pram>
        /// <returns></returns>
        public bool VerifyInvenotrySafetyInit(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (InventorySafetyInitDao dao = new InventorySafetyInitDao())
            {
                IsValid = dao.Initialize(new Guid(_context.User.Id), RoleModelContext.Current.User.CorpId.Value);
                result = true;
            }
            return result;
        }



        /// <summary>
        /// 查询Excel导入出错信息
        /// </summary>
        /// <returns></returns>
        public IList<InventorySafetyInit> QueryInvenotrySafetyInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (InventorySafetyInitDao dao = new InventorySafetyInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("User", new Guid(_context.User.Id));
                param.Add("ErrorFlag", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);
            }
        }

   
    }

}
