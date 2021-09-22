using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using DMS.Model.Data;
namespace DMS.Business
{
    public interface IDealerComplainBLL
    {
        string DealerComplainSave(Hashtable dealerComplainInfo);
        DataSet DealerComplainQuery(Hashtable condition, int start, int limit, out int totalRowCount);
        DataTable DealerComplainInfo(Hashtable condition);
        DataTable DealerComplainInfo_SpecialDateFormat(Hashtable condition);
        DataSet GetDealerComplainUPN(Hashtable condition);
        void DealerComplainCancel(Hashtable condition);
        void DealerComplainConfirm(Hashtable condition);
        void UpdateBSCCarrierNumber(Hashtable condition);
        void CheckUPNAndDate(Hashtable condition, out string rtnVal, out string rtnMsg);
        
        void DealerComplainConfirmCRM(Hashtable condition);
        void UpdateCRMCarrierNumber(Hashtable condition);
        void CheckUPNAndDateCRM(Hashtable condition, out string rtnVal, out string rtnMsg);

        void UpdateBSCRevoke(Hashtable condition);
        void UpdateCRMRevoke(Hashtable condition);
        DataSet GetWarehouseTypeById(Guid obj);
        DataTable DealerComplainExport(Hashtable condition);
        int UpdateDealerComplainStatus(Hashtable condition);
        int UpdateDealerComplainStatusCRM(Hashtable condition);
        int UpdateDealerComplainCourier(Hashtable condition);
        int UpdateDealerComplainIAN(Hashtable condition);
        DataTable GetDealerComplainBscInfo(Guid Cmid);

        #region Added By Song Yuqi For 经销商投诉退换货 On 2017-08-23
        string DealerComplainSaveForNew(Hashtable dealerComplainInfo);
        string DealerComplainSaveReturn(Hashtable dealerComplainInfo);
        DataSet SelectInventoryForComplainsDataSet(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet SelectInventoryWarehouseForComplainsDataSet(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryDealerComplainProductSaleDate(Hashtable table);
        DataSet SelectBscSrForComplain(Hashtable table);
        void UpdateDealerComplainStatusByFilter(String ComplainType, String Status, String ApprovelRemark, Guid ComplainId, DateTime LastUpdateDate, out String RtnVal, out String RtnMsg);
        bool ValidateComplainCanUpdate(String ComplainType, Guid ComplainId, DateTime LastUpdateDate);
        bool ValidateReturnCanUpdate(String ComplainType, Guid ComplainId, DateTime ConfirmUpdateDate);

        void CheckUPNAndDateCNFForEkp(Hashtable table, out string rtnVal, out string rtnMsg);
        void CheckUPNAndDateCRMForEkp(Hashtable table, out string rtnVal, out string rtnMsg);
        #endregion

        #region Added By Ryan Chen For 经销商投诉退换货 On 2018-05-17
        string DealerComplainCRMExportForm(DataTable dealerComplainInfo);
        string DealerComplainCNFExportForm(DataTable dealerComplainInfo);
        string DealerComplainCNFSendMailWithAttachment(DataTable table);
        string DealerComplainCRMSendMailWithAttachment(DataTable table);

        #endregion
    }
}
