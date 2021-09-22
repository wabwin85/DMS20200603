using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.Model;

namespace DMS.Business
{
    public interface IStocktakingBLL
    {
        //获取盘点单明细信息，带分页
        DataSet GetStocktakingListByCondition(Hashtable table, int start, int limit, out int totalRowCount);

        //根据经销商和仓库获取所有盘点单单据号
        DataSet GetAllStocktakingNoByCondition(Hashtable table);

        //获取盘点单主表信息
        StocktakingHeader GetStocktakingHeaderByID(Guid Id);

        //新增盘点单
        bool AddStocktaking(StocktakingHeader mainData, Hashtable param);

        //更新盘点数量
        bool UpdateCheckQuantity(Hashtable param);

        //写入新增的产品
        void InsertNewProductLotInfo(List<Dictionary<String, String>> rows, String sth_Id);

        //根据LotID删除Lot表信息，并更新Line表的数量
        bool DeleteListItem(Guid LotID);

        //盘点单差异调整
        bool DoDifAdjust(String SthId);

        //获取差异报告
        DataSet GetDifReportById(Guid SthID);

        //获取盘点报告
        DataSet GetStockReportById(Guid SthID);

        //获取报表表头
        DataSet GetReportHeaderById(Guid SthID);
    }
}
