using System;
using System.Collections.Generic;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using System.Data;
    using System.Collections;
    using Model.ApiModel;

    public interface ICfns
    {
        Cfn GetObject(Guid Id);
        IList<Cfn> SelectByFilter(Cfn cfn);
        IList<Cfn> SelectByFilter(Cfn cfn, int start, int limit, out int totalRowCount);
        IList<Cfn> SelectByFilterIsContain(Hashtable obj, int start, int limit, out int totalRowCount);
        IList<Cfn> SelectByFilterNoSet(Hashtable obj, int start, int limit, out int totalRowCount);
        IList<Cfn> SelectByCustomerFaceNbr(Cfn cfn);

        bool Insert(Cfn cfn);
        bool Update(Cfn cnf);
        bool Delete(Guid Id);
        bool FakeDelete(Guid Id);
        bool SaveChanges(ChangeRecords<Cfn> data);
        bool SaveCfnOfCatagory(Coolite.Ext.Web.ChangeRecords<Cfn> data, Guid catagoryId, Guid lineId);
        bool SaveCfnPartsRelation(DMS.ViewModel.Common.ChangeRecords<Cfn> data, Guid catagoryId, Guid lineId);
        void ImportFromExcel(string source, ref int intTotal, ref int intSuccess, ref int intFalse);
        //added by bozhenfei on 20110216
        DataSet QueryCfnForPurchaseOrderByAuth(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryCfnForPurchaseOrderT2ByAuth(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryCfnForPurchaseOrderByShare(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QueryCfnForPurchaseOrderBySpecialPrice(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryCfnForPurchaseOrderByPromotion(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet GetPromotionTypeById(string Id);
        //end

        //added by huakaichun on 20151013
        DataSet QueryCfnForPurchaseOrderByPRO(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryPromotionProductLineType(Hashtable table);

        //added by songyuqi on 20100608
        DataSet SelectCFNForDealerShare(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet SelectCFNForDealerNotShare(Hashtable table, int start, int limit, out int totalRowCount);
        //end

       //added by huyong 
        IList<ProductData> QueryProductDataInfo();

        IList<ProductDataForQAComplain> QueryProductDataInfoByUPN(Hashtable ht);

        //added by bozhenfei on 20150511
        string CheckProductMinQty(string cfn, decimal qty);

        //added by Song Yuqi on 20150527
        IList<Cfn> QueryCfnByFilter(Hashtable table);

        //Add By Hua Kaichun
        DataSet SelectCFNRegistration(Hashtable table,int start, int limit, out int totalRowCount);
        //短期寄售组套产品查询
        DataSet QueryConsignmentCfnSetBy(string ProductLineId, int start, int limit, out int totalRowCount);

        DataSet QueryCfnForConsignmentMaster(Hashtable table, int start, int limit, out int totalRowCount);
        //根据upn查询COA附件 lijie add 2016-05-09
        DataSet SelectCFNRegistrationByUpn(Hashtable ht);
        //二级经销商促销产品查询
        DataSet QueryCfnForPurchaseOrderT2ByPRO(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet SelectCFNRegistrationBylot(Hashtable table, int start, int limit, out int totalRowCount);

        List<UPNDocumentItem> SelectCFNRegistrationBylotAPI(string upnCode, string queryType, string lot);
    }
}
