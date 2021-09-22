using System;
using DMS.Model;
using System.Data;
using Coolite.Ext.Web;
using System.Collections;
using System.Collections.Generic;

namespace DMS.Business
{
    public interface IInventorySafetyBLL
    {
        //获取经销商安全库存
        DataSet GetInventoryByDMACFN(Hashtable table, int start, int limit, out int totalRowCount);

        //获取经销商授权产品的实际库存信息
        DataSet GetActualInvQtyByCFN(Hashtable table, int start, int limit, out int totalRowCount);

        //获取经销商共享产品的实际库存信息
        DataSet GetActualInvQtyOfShareCFN(Hashtable table, int start, int limit, out int totalRowCount);

        //添加选择的产品，默认安全库存为0
        bool AddItemsCfn(Guid DealerId, string[] PmaIds);

        //根据经销商及产品获取安全库存
        InventorySafety GetInventorySafetyByDMACFN(Guid CFNID, Guid DealerID);

        //更新安全库存
        int UpdateInventoryQty(Guid Id, double Qty);

        //复制当前库存为安全库存
        bool UpdateSafetyQtyWithAcutalQty(Guid DealerId);

        //导入安全库存中间表
        bool ImportInventorySafetyInit(DataSet ds, string fileName);

        bool VerifyInvenotrySafetyInit(out string IsValid);

        IList<InventorySafetyInit> QueryInvenotrySafetyInitErrorData(int start, int limit, out int totalRowCount);

    }
}
