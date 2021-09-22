using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model.Data;
using System.Data;
using System.Collections;
using DMS.Model;
namespace DMS.Business
{
    public interface IConsignmentApplyHeaderBLL
    {
        DataSet QueryConsignmentApplyHeaderDealer(Hashtable table, int start, int limit, out int totalRowCount);
        ConsignmentApplyHeader GetConsignmentApplyHeaderSing(Guid id);
        void AddHeader(ConsignmentApplyHeader header);
        bool SaveDraft(ConsignmentApplyHeader header);
        bool Sumbit(ConsignmentApplyHeader header, out string resMsg);
        bool DeltetDraft(Guid headid);
        DataSet GetDealerSale(string code);
        DataSet GetDealerSaleByPL(string code,string DmaId);
        DataSet GetProductLineVsDivisionCode(string ProductLineId);
        DataSet QueryInventoryAdjustHeaderList(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryInventoryAdjustCfnList(string Id, int start, int limit, out int totalRowCount);
        bool SetDelayStatus(ConsignmentApplyHeader header, out string resMsg);

        DataSet QueryConsignmentTrackByOrderId(Guid Id, out string RtnVal, out string RtnMsg);
        DataSet SelecPOReceiptPriceSum(string CAID);
        DataSet SelectHospitSale(string hospitId, string Division);
        bool SelectSalesSing(string Name, string Email);
        DataSet SelectConsignmentApplyProSumList(Guid id, int start, int limit, out int totalRowCount);
        DataSet SelectConsignmentApplyInitList(int start, int limit, out int totalRowCount);
        bool Import(DataTable dt, string fileName);
        bool VerifyConsignmentApplyInit(string IsImport,out string IsValid);
        DataSet SelectConsignmentTransferInitList(int start, int limit, out int totalRowCount);
        bool ImportTransfer(DataTable dt, string fileName);
        bool VerifyConsignmentTransferInit(string IsImport, out string IsValid);
        int ConsignmentTransferDelete(string id);
    }
    
}
