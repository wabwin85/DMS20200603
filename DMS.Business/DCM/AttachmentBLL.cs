using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Lafite.RoleModel.Security;
    using DMS.Model;
    using DMS.DataAccess;
    using System.Data;
    using DMS.Model.Data;
    using System.Collections;
    using Common.Common;

    public class AttachmentBLL : IAttachmentBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet GetAttachmentByMainId(Guid mainId, AttachmentType type)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                Hashtable table = new Hashtable();
                table.Add("MainId", mainId);
                table.Add("Type", type.ToString());

                return dao.GetAttachmentByMainId(table);
            }
        }

        public DataSet GetAttachmentByMainId(Guid mainId, AttachmentType type, int start, int limit, out int totalRowCount)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                Hashtable table = new Hashtable();
                table.Add("MainId", mainId);
                table.Add("Type", type.ToString());

                return dao.GetAttachmentByMainId(table, start, limit, out totalRowCount);
            }
        }

        public DataSet GetAttachmentByMainId(Guid mainId, int start, int limit, out int totalRowCount)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                Hashtable table = new Hashtable();
                table.Add("MainId", mainId);
                return dao.GetContractAttachmentByMainId(table, start, limit, out totalRowCount);
            }
        }

        public bool AddAttachment(Attachment attach)
        {
            try
            {
                using (AttachmentDao dao = new AttachmentDao())
                {
                    dao.Insert(attach);
                    return true;
                }
            }
            catch(Exception ex)
            {
                return false;
            }
        }
        public string AddContractAttachment(Hashtable attach)
        {
            try
            {
                using (AttachmentDao dao = new AttachmentDao())
                {
                    return dao.InsertContractAttachment(attach);
                }
            }
            catch (Exception ex)
            {
                return "";
            }
        }
        public bool DelAttachment(Guid id)
        {
            try
            {
                using (AttachmentDao dao = new AttachmentDao())
                {
                    dao.Delete(id);
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public Attachment GetAttachmentById(Guid id)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                return dao.GetObject(id);
            }
        }

        public void UpdateAttachmentName(Guid id, string fileName, string fileType)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                Hashtable table = new Hashtable();
                table.Add("Id", id);
                table.Add("Name", fileName);
                table.Add("Type", fileType);
                
                dao.UpdateAttachmentName(table);

            }
        }

        public DataSet GetAttachment(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                return dao.GetAttachment(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet GetAttachmentContract(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                return dao.GetAttachmentContract(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet GetAttachmentOther(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                return dao.GetAttachmentOther(obj, start, limit, out totalRowCount);
            }
        }

        //Add By Songweiming on 2015-09-16 for GSP Project 
        //更新证照附件对应的MainID
        public int UpdateAttachmentMainID(Guid curMainId, Guid newMainId, string fileType)
        { 
            using (AttachmentDao dao = new AttachmentDao())
            {
                Hashtable table = new Hashtable();
                table.Add("CurMainId", curMainId);
                table.Add("NewMainId", newMainId);
                table.Add("Type", fileType);
                int updCnt = dao.UpdateAttachmentMainID(table);
                return updCnt;
            }
            
        }

        public int UpdateAttachmentTempMainIDToDealerID(Guid dealerId,string fileType)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                Hashtable table = new Hashtable();
                table.Add("DealerId", dealerId);               
                table.Add("Type", fileType);
                int updCnt = dao.UpdateAttachmentTempMainIDToDealerID(table);
                return updCnt;
            }
            
            
        }


        //End Add By SongWeiming on 2015-09-16

        #region Added By Song Yuqi On 2017-05-05
        public DataSet QueryAttachmentForShipmentAttachment(AttachmentType type)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                Hashtable table = new Hashtable();
                table.Add("Type", type.ToString());

                return dao.QueryAttachmentForShipmentAttachment(table);
            }
        }

        public void InsertFileUploadLog(UploadLog obj)
        {
            using (UploadLogDao dao = new UploadLogDao())
            {
                dao.Insert(obj);
            }
        }
        #endregion 

        public DataTable QueryAttachmentByFilter(string mainId)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                Hashtable table = new Hashtable();
                table.Add("MainId", mainId);

                return dao.QueryAttachmentByFilter(table);
            }
        }

        public StringBuilder GetAttachmentContent(string mainId , DmsTemplateHtmlType htmlType)
        {
            HtmlHelper helper = new HtmlHelper();
            StringBuilder sb = helper.GetDmsTemplateHtml("Attachment", htmlType);

            DataTable attachmentDt = this.QueryAttachmentByFilter(mainId);

            helper.SetColumnIndexAndRemoveColumn(attachmentDt, new string[] { "row_number", "Name", "Url", "TypeName", "Identity_Name", "UploadDate" });
            attachmentDt.TableName = "AttachmentCommon";
            //填写授权产品信息
            return helper.SetHtmlForAttachmentByDataTable(sb, attachmentDt, "TenderFile");
        }
    }
}
