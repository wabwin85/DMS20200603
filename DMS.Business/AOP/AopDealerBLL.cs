using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;

using DMS.DataAccess;
using DMS.Model;

namespace DMS.Business
{
    public class AopDealerBLL : IAopDealerBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_DealerAop = "DealerAop";
        public const string Action_DealerHospitalAop = "DealerHospitalAop";
        #endregion

        /// <summary>
        /// 根据ID获得代理商AOP对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerAop, Description = "经销商AOP", Permissoin = PermissionType.Read)]
        public AopDealer GetAopDealerByKey(Guid id)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                return dao.GetObject(id);
            }
        }

        /// <summary>
        /// 删除经销商在指定产品线上一年的AOP数据
        /// </summary>
        /// <param name="dmaId"></param>
        /// <param name="prodLineId"></param>
        [AuthenticateHandler(ActionName = Action_DealerAop, Description = "经销商AOP", Permissoin = PermissionType.Delete)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_DealerAop, Title = "经销商AOP信息", Message = "删除经销商AOP", Categories = new string[] { Data.DMSLogging.AOPCategory })]
        public bool RemoveAopDealers(Guid dmaId, Guid prodLineId, string year)
        {
            bool result = false;
            using (AopDealerDao dao = new AopDealerDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("DealerDmaId", dmaId);
                obj.Add("ProductLineBumId", prodLineId);
                obj.Add("Year", year);
                int cnt = dao.Delete(obj);
                if (cnt >= 0) result = true;
            }

            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="aopDealers"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerAop, Description = "经销商AOP", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_DealerAop, Title = "经销商AOP信息", Message = "保存经销商AOP", Categories = new string[] { Data.DMSLogging.AOPCategory })]
        public bool SaveAopDealers(IList<AopDealer> aopDealers)
        {
            bool result = false;
            if (aopDealers.Count > 0)
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    using (AopDealerDao dao = new AopDealerDao())
                    {
                        AopDealer firstAopDealer = aopDealers.First<AopDealer>();

                        Hashtable obj = new Hashtable();
                        obj.Add("DealerDmaId", firstAopDealer.DealerDmaId);
                        obj.Add("ProductLineBumId", firstAopDealer.ProductLineBumId);
                        obj.Add("Year", firstAopDealer.Year);
                        int cnt = dao.Delete(obj);
                        foreach (AopDealer tempAopDealer in aopDealers)
                        {
                            tempAopDealer.UpdateUserId = new Guid(this._context.User.Id);
                            tempAopDealer.UpdateDate = DateTime.Now;
                            dao.Insert(tempAopDealer);
                        }
                    }
                    trans.Complete();
                    result = true;
                }
            }
            else
            {
                result = true;
            }

            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="aopDealers"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerAop, Description = "经销商AOP", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_DealerAop, Title = "经销商AOP信息", Message = "保存经销商AOP", Categories = new string[] { Data.DMSLogging.AOPCategory })]
        public bool SaveAopDealers(VAopDealer aopDealers)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopDealerDao dao = new AopDealerDao())
                {
                    

                    Hashtable obj = new Hashtable();
                    obj.Add("DealerDmaId", aopDealers.DealerDmaId);
                    obj.Add("ProductLineBumId", aopDealers.ProductLineBumId);
                    obj.Add("Year", aopDealers.Year);
                    int cnt = dao.Delete(obj);

                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "01", aopDealers.Amount1));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "02", aopDealers.Amount2));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "03", aopDealers.Amount3));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "04", aopDealers.Amount4));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "05", aopDealers.Amount5));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "06", aopDealers.Amount6));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "07", aopDealers.Amount7));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "08", aopDealers.Amount8));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "09", aopDealers.Amount9));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "10", aopDealers.Amount10));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "11", aopDealers.Amount11));
                    dao.Insert(this.getAopDealerFromVAopDealer(aopDealers, "12", aopDealers.Amount12));

                }
                trans.Complete();
                result = true;
            }

            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dmaId"></param>
        /// <param name="prodLineId"></param>
        /// <param name="year"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalCount"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerAop, Description = "经销商AOP", Permissoin = PermissionType.Read)]
        public DataSet GetAopDealersByQuery(Guid? dmaId, Guid? prodLineId, string year, int start, int limit, out int totalCount)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                Hashtable obj = new Hashtable();
                if (dmaId != null) obj.Add("DealerDmaId", dmaId.Value);
                if (prodLineId != null) obj.Add("ProductLineBumId", prodLineId.Value);
                if (!string.IsNullOrEmpty(year)) obj.Add("Year", year);
                return dao.GetYearAOPAll(obj, start, limit, out totalCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerAop, Description = "经销商AOP查询", Permissoin = PermissionType.Read)]
        public DataSet GetAopDealersByFiller(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                return dao.GetAopDealersByFiller(obj, start, limit, out totalCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerHospitalAop, Description = "经销商医院AOP查询", Permissoin = PermissionType.Read)]
        public DataSet GetHospitalProductFiller(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                return dao.GetHospitalProductFiller(obj, start, limit, out totalCount);
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="dmaId"></param>
        /// <param name="prodLineId"></param>
        /// <param name="year"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerAop, Description = "经销商AOP", Permissoin = PermissionType.Read)]
        public VAopDealer GetYearAopDealers(Guid dmaId, Guid prodLineId, string year)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("DealerDmaId", dmaId);
                obj.Add("ProductLineBumId", prodLineId);
                obj.Add("Year", year);
                DataTable dt = dao.GetYearAOPAll(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    VAopDealer yearAopDealer = new VAopDealer();
                    yearAopDealer.DealerDmaId = new Guid(dt.Rows[0]["Dealer_DMA_ID"].ToString());
                    yearAopDealer.ProductLineBumId = new Guid(dt.Rows[0]["ProductLine_BUM_ID"].ToString());
                    yearAopDealer.Year = dt.Rows[0]["Year"].ToString();
                    yearAopDealer.Amount1 = double.Parse(dt.Rows[0]["Amount_1"].ToString());
                    yearAopDealer.Amount2 = double.Parse(dt.Rows[0]["Amount_2"].ToString());
                    yearAopDealer.Amount3 = double.Parse(dt.Rows[0]["Amount_3"].ToString());
                    yearAopDealer.Amount4 = double.Parse(dt.Rows[0]["Amount_4"].ToString());
                    yearAopDealer.Amount5 = double.Parse(dt.Rows[0]["Amount_5"].ToString());
                    yearAopDealer.Amount6 = double.Parse(dt.Rows[0]["Amount_6"].ToString());
                    yearAopDealer.Amount7 = double.Parse(dt.Rows[0]["Amount_7"].ToString());
                    yearAopDealer.Amount8 = double.Parse(dt.Rows[0]["Amount_8"].ToString());
                    yearAopDealer.Amount9 = double.Parse(dt.Rows[0]["Amount_9"].ToString());
                    yearAopDealer.Amount10 = double.Parse(dt.Rows[0]["Amount_10"].ToString());
                    yearAopDealer.Amount11 = double.Parse(dt.Rows[0]["Amount_11"].ToString());
                    yearAopDealer.Amount12 = double.Parse(dt.Rows[0]["Amount_12"].ToString());
                    yearAopDealer.AmountY = double.Parse(dt.Rows[0]["Amount_Y"].ToString());
                    return yearAopDealer;
                }
                else
                {
                    return null;
                }
            }
        }

        /// <summary>
        /// 获得经销商指定产品线上设置的当前极度AOP值
        /// </summary>
        /// <param name="dmaId"></param>
        /// <param name="prodLineId"></param>
        /// <returns></returns>
        public double? GetDealerCurrentQAop(Guid dmaId, Guid prodLineId)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("DealerDmaId", dmaId);
                obj.Add("ProductLineBumId", prodLineId);
                return (double?)dao.GetDealerCurrentQAop(obj);
            }
        }
        /// <summary>
        /// 获得经销商指定产品线上指标完成额度
        /// 目前还不了解如何获取因此返回0
        /// </summary>
        /// <param name="dmaId"></param>
        /// <param name="prodLineId"></param>
        /// <returns></returns>
        public double GetDealerCurrentQAmount(Guid dmaId, Guid prodLineId)
        {
            return 0.0d;
        }
        private AopDealer getAopDealerFromVAopDealer(VAopDealer aopDealers, string month, double amount)
        {
            AopDealer aopDealer = new AopDealer();
            aopDealer.Id = Guid.NewGuid();
            aopDealer.DealerDmaId = aopDealers.DealerDmaId;
            aopDealer.ProductLineBumId = aopDealers.ProductLineBumId;
            aopDealer.Year = aopDealers.Year;
            aopDealer.Month = month;
            aopDealer.Amount = amount;
            aopDealer.UpdateUserId = new Guid(this._context.User.Id);
            aopDealer.UpdateDate = DateTime.Now;
            return aopDealer;
        }

        public DataSet ExportAop(Hashtable obj) 
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                return dao.ExportAop(obj);
            }
        }

        public DataSet ExportHospitalAop(Hashtable obj)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                return dao.ExportHospitalAop(obj);
            }
        }

        public DataSet ExportHospitalProductAop(Hashtable obj)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                return dao.ExportHospitalProductAop(obj);
            }
        }


        public DataSet ExporAopDealersByFiller(Hashtable obj)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                return dao.ExporAopDealersByFiller(obj);
            }
        }

        public DataSet ExportHospitalProductFiller(Hashtable obj)
        {
            using (AopDealerDao dao = new AopDealerDao())
            {
                return dao.ExportHospitalProductFiller(obj);
            }
        }

    }
}
