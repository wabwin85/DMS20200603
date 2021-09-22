using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace DMS.Business
{
    using DMS.Model;
    using System.Collections;

    public interface IDeliveryNotes
    {
        DeliveryNote GetDeliveryNote(Guid DNId);
        IList<DeliveryNote> GetAll();
        IList<DeliveryNote> QueryForDeliveryNote(DeliveryNote deliveryNote);
        bool Insert(DeliveryNote deliveryNote);
        bool Update(DeliveryNote deliveryNote);
        bool Delete(Guid id);
        IList<DeliveryNote> GetDeliveryNoteWithoutDealer();
        IList<DeliveryNote> GetDeliveryNoteWithoutCFN();
        DataSet GetUnauthorizationPOReceipt();
        void ImportPOReceipt();

        DataSet QueryDeliveryNote(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryDeliveryNote(Hashtable table);

        //added by bozhenfei on 20100610 @发货数据上传
        bool Import(string file, DataSet ds);
        IList<DeliveryInit> QueryErrorDeliveryInit(int start, int limit, out int totalRowCount);
        bool Generate(out string IsValid);
    }
}
