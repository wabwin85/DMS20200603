using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using System.Data;
    using DMS.Model.Data;
    using System.Collections;

    public interface IAttachmentBLL
    {
        DataSet GetAttachmentByMainId(Guid mainId, AttachmentType type);

        bool AddAttachment(Attachment attach);
        string AddContractAttachment(Hashtable attach);
        bool DelAttachment(Guid id);

        DataSet GetAttachmentByMainId(Guid mainId, AttachmentType type, int start, int limit, out int totalRowCount);

        DataSet GetAttachmentByMainId(Guid mainId, int start, int limit, out int totalRowCount);

        Attachment GetAttachmentById(Guid id);

        void UpdateAttachmentName(Guid id, string fileName, string fileType);

        DataSet GetAttachment(Hashtable obj, int start, int limit, out int totalRowCount);

        DataSet GetAttachmentContract(Hashtable obj, int start, int limit, out int totalRowCount);

        DataSet GetAttachmentOther(Hashtable obj, int start, int limit, out int totalRowCount);

        //Add By SongWeiming on 2015-09-16 For GSP Project 
        //更新附件的ID
        int UpdateAttachmentMainID(Guid curMainId, Guid newMainId,string fileType);

        //将新添加的附件作为正式的附件
        int UpdateAttachmentTempMainIDToDealerID(Guid dealerId,string fileType);       

        //End Add By SongWeiming on 2015-09-16
    }
}
