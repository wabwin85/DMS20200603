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
using Grapecity.Logging.CallHandlers;

namespace DMS.Business
{
    public class StocktakingBLL : IStocktakingBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_Stocktaking = "Stocktaking";
        #endregion

        //获取盘点单明细信息，带分页
        [AuthenticateHandler(ActionName = Action_Stocktaking, Description = "库存盘点", Permissoin = PermissionType.Read)]
        public DataSet GetStocktakingListByCondition(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (StocktakingHeaderDao dao = new StocktakingHeaderDao())
            {
                return dao.GetStocktakingListByCondition(table, start, limit, out totalRowCount);
            }
        }

        //根据经销商和仓库获取所有盘点单单据号
        [AuthenticateHandler(ActionName = Action_Stocktaking, Description = "库存盘点", Permissoin = PermissionType.Read)]
        public DataSet GetAllStocktakingNoByCondition(Hashtable table)
        {
            using (StocktakingHeaderDao dao = new StocktakingHeaderDao())
            {
                return dao.GetAllStocktakingNoByCondition(table);
            }
        }

        //获取盘点单主表信息
        [AuthenticateHandler(ActionName = Action_Stocktaking, Description = "库存盘点", Permissoin = PermissionType.Read)]
        public StocktakingHeader GetStocktakingHeaderByID(Guid Id)
        {
            using (StocktakingHeaderDao dao = new StocktakingHeaderDao())
            {
                return dao.GetObject(Id);
            }
        }

        //写入盘点单主单据信息
        private bool InsertMainData(StocktakingHeader stocktakingHeader)
        {
            bool result = false;
            using (StocktakingHeaderDao dao = new StocktakingHeaderDao())
            {
                stocktakingHeader.CreateDate = DateTime.Now;
                stocktakingHeader.CreateUser = new Guid(_context.User.Id);

                object ojb = dao.Insert(stocktakingHeader);
                result = true;
            }
            return result;
        }

        //写入盘点单Line表信息
        private bool InsertAddLineInfoByActualInv(Hashtable param)
        {
            bool result = false;
            using (StocktakingLineDao dao = new StocktakingLineDao())
            {
                object ojb = dao.InsertAddLineInfoByActualInv(param);
                result = true;
            }
            return result;
        }

        //写入盘点单Lot表信息
        private bool InsertAddLotInfoByActualInv(Hashtable param)
        {
            bool result = false;
            using (StocktakingLotDao dao = new StocktakingLotDao())
            {
                object ojb = dao.InsertAddLotInfoByActualInv(param);
                result = true;
            }
            return result;
        }


        //将当前仓库其他状态为未调整的盘点单状态修改为“不调整”
        private int UpdateHistoryCheckListStatus(Hashtable param)
        {
            using (StocktakingHeaderDao dao = new StocktakingHeaderDao())
            {
                return dao.UpdateHistoryCheckListStatus(param);
            }
        }

        //更新盘点单状态
        private int UpdateStocktakingHeaderStatus(Hashtable param)
        {
            using (StocktakingHeaderDao dao = new StocktakingHeaderDao())
            {
                return dao.UpdateStocktakingHeaderStatus(param);
            }
        }

        //根据LotId，更新Line表中某一个产品的数量
        private int UpdateLineQuantityBySltId(Hashtable param)
        {
            using (StocktakingLineDao dao = new StocktakingLineDao())
            {
                return dao.UpdateLineQuantityBySltId(param);
            }
        }

        //根据LineId，更新Line表中某一个产品的数量
        private int UpdateLineQuantityByStlId(Hashtable param)
        {
            using (StocktakingLineDao dao = new StocktakingLineDao())
            {
                return dao.UpdateLineQuantityByStlId(param);
            }
        }

        //根据HeaderId，更新Line表中某一个产品的数量
        private int UpdateLineQuantityBySthId(Hashtable param)
        {
            using (StocktakingLineDao dao = new StocktakingLineDao())
            {
                return dao.UpdateLineQuantityBySthId(param);
            }
        }

        //更新Lot表的盘点数量值
        private int UpdateLotCheckQty(Hashtable param)
        {
            using (StocktakingLotDao dao = new StocktakingLotDao())
            {
                return dao.UpdateLotCheckQty(param);
            }
        }


        //新增盘点单
        [AuthenticateHandler(ActionName = Action_Stocktaking, Description = "库存盘点", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Stocktaking, Title = "库存盘点", Message = "新增库存盘点", Categories = new string[] { Data.DMSLogging.StocktakingCategory })]
        public bool AddStocktaking(StocktakingHeader mainData, Hashtable param)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {

                //写入Header表
                this.InsertMainData(mainData);

                //写入Line表
                this.InsertAddLineInfoByActualInv(param);

                //写入Lot表
                this.InsertAddLotInfoByActualInv(param);

                //更新Line表的数量
                this.UpdateLineQuantityBySthId(param);

                //将当前仓库其他状态为未调整的盘点单状态修改为“不调整”                
                this.UpdateHistoryCheckListStatus(param);


                trans.Complete();

                result = true;
            }

            return result;
        }

        //根据LotID更新盘点数量
        [AuthenticateHandler(ActionName = Action_Stocktaking, Description = "库存盘点", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Stocktaking, Title = "库存盘点", Message = "更新库存盘点", Categories = new string[] { Data.DMSLogging.StocktakingCategory })]
        public bool UpdateCheckQuantity(Hashtable param)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                this.UpdateLotCheckQty(param);
                this.UpdateLineQuantityBySltId(param);
                trans.Complete();

                result = true;
            }
            return result;
        }

        //写入新增的产品
        [AuthenticateHandler(ActionName = Action_Stocktaking, Description = "库存盘点", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Stocktaking, Title = "库存盘点", Message = "新增库存盘点", Categories = new string[] { Data.DMSLogging.StocktakingCategory })]
        public void InsertNewProductLotInfo(List<Dictionary<String, String>> rows, String sth_Id)
        {

            int iCount = 1;
            foreach (Dictionary<String, String> row in rows)
            {


                StocktakingLineDao lineDao = new StocktakingLineDao();
                StocktakingLotDao lotDao = new StocktakingLotDao();
                Hashtable param = new Hashtable();
                param.Add("PmaId", row["PmaId"]);
                param.Add("SthId", sth_Id);
                using (TransactionScope trans = new TransactionScope())
                {

                    //首先判断Line表中有没有相应的PMA_ID

                    IList<StocktakingLine> list = lineDao.SelectStocktakingLineByPmaId(param);

                    StocktakingLot lot = new StocktakingLot();
                    StocktakingLine line = new StocktakingLine();
                    if (list.Count > 0)
                    {
                        //有相应记录，则获取STL_ID                   
                        lot.StlId = list[0].Id;

                    }
                    else
                    {
                        //新增记录写入Line表                    
                        line.Id = Guid.NewGuid();
                        line.SthId = new Guid(sth_Id);
                        line.PmaId = new Guid(row["PmaId"]);
                        line.LineNbr = iCount;
                        lineDao.Insert(line);

                        lot.StlId = line.Id;
                    }

                    //写入Lot表
                    lot.Id = Guid.NewGuid();
                    lot.LotId = new Guid(row["LotID"]);
                    lot.LotNumber = row["LotNumber"];
                    lot.ExpiredDate = Convert.ToDateTime(row["ExpiredDate"]);
                    lot.LotQty = 0;
                    lot.CheckQty = Convert.ToInt32(row["CheckQuantity"]);
                    lotDao.Insert(lot);

                    param.Add("STL_ID", lot.StlId);

                    //更新Line表的产品数量
                    this.UpdateLineQuantityByStlId(param);

                    trans.Complete();
                    iCount++;
                }
            }
        }

        //根据LotID删除Lot表信息，并更新Line表的数量
        [AuthenticateHandler(ActionName = Action_Stocktaking, Description = "库存盘点", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Stocktaking, Title = "库存盘点", Message = "删除库存盘点", Categories = new string[] { Data.DMSLogging.StocktakingCategory })]
        public bool DeleteListItem(Guid LotID)
        {
            bool result = false;
            StocktakingLotDao lotDao = new StocktakingLotDao();
            StocktakingLot lot = lotDao.GetObject(LotID);
            Hashtable param = new Hashtable();
            param.Add("STL_ID", lot.StlId.ToString());
            using (TransactionScope trans = new TransactionScope())
            {
                //删除Lot表中的记录                
                lotDao.Delete(LotID);
                //更新Line表的数量
                this.UpdateLineQuantityByStlId(param);
                trans.Complete();
                result = true;
            }
            return result;
        }

        //盘点单差异调整
        public bool DoDifAdjust(String SthId)
        {
            bool result = false;
            StocktakingHeaderDao headerDao = new StocktakingHeaderDao();
            StocktakingLineDao lineDao = new StocktakingLineDao();
            StocktakingLotDao lotDao = new StocktakingLotDao();
            InvTrans invTrans = new InvTrans();

            using (TransactionScope trans = new TransactionScope())
            {
                //首先更新盘点单的状态
                Hashtable param = new Hashtable();
                param.Add("STH_Status", "Adjusted");
                param.Add("STH_ID", SthId);
                this.UpdateStocktakingHeaderStatus(param);

                //然后更新库存
                //StocktakingHeader header = headerDao.GetObject(new Guid(SthId));
                //IList<StocktakingLine> Lines = lineDao.SelectByFilter(new Guid(SthId));

                //foreach (StocktakingLine line in Lines)
                //{
                //    IList<StocktakingLot> Lots = lotDao.SelectByFilter(line.Id);

                //    foreach (StocktakingLot lot in Lots)
                //    {
                //        if (lot.CheckQty != 0)
                //        {
                //            //库存操作
                //invTrans.SaveInvRelatedStocktaking(header, line, lot);
                //        }
                //    }

                //}
                result = true;
                trans.Complete();
            }
            return result;
        }

        //获取差异报告
        public DataSet GetDifReportById(Guid SthID)
        {
            using (StocktakingHeaderDao dao = new StocktakingHeaderDao())
            {
                return dao.GetDifReportById(SthID);
            }
        }

        //获取盘点报告
        [AuthenticateHandler(ActionName = Action_Stocktaking, Description = "库存盘点", Permissoin = PermissionType.Read)]
        public DataSet GetStockReportById(Guid SthID)
        {
            using (StocktakingHeaderDao dao = new StocktakingHeaderDao())
            {
                return dao.GetStockReportById(SthID);
            }
        }

        //获取报表表头
        [AuthenticateHandler(ActionName = Action_Stocktaking, Description = "库存盘点", Permissoin = PermissionType.Read)]
        public DataSet GetReportHeaderById(Guid SthID)
        {
            using (StocktakingHeaderDao dao = new StocktakingHeaderDao())
            {
                return dao.GetReportHeaderById(SthID);
            }
        }
    }
}
