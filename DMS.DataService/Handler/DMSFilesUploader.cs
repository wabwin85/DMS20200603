using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using System.IO;
using System.Text;
using DMS.Model;
using DMS.Business.ScoreCard;
using System.Data;
using DMS.DataAccess;

namespace DMS.DataService.Handler
{
    public class DMSFilesUploader : UploadData
    {
        public DMSFilesUploader(byte[] fileBt,string ESCNo,string FileType,string FileOperType,string FileName,string Remark,string UploadUser,DateTime UploadDate,out string result)
        {
            #region 保存附件
            string fileExtention = string.Empty;
            string fileExt = string.Empty;
            if (FileName.LastIndexOf(".") < 0)
            {
                result = "Failed";

            }
            else
            {
                fileExtention = FileName.Substring(FileName.LastIndexOf("\\") + 1);
                fileExt = FileName.Substring(FileName.LastIndexOf(".") + 1).ToLower();

                string newFileName = FileType == "ScoreCard" ? fileExtention.Substring(0, fileExtention.LastIndexOf(".")) + DateTime.Now.ToString("yyyyMMddHHmmss") + "." + fileExt : fileExtention.Substring(0, fileExtention.LastIndexOf(".")) + "." + fileExt;

                result = "successful";
                //if (fileBt.Length == 0)
                //return "The length of the File" + FileName + "is 0";
                string filePath = "";
                if (FileType == "ScoreCard")
                {
                    filePath = System.Configuration.ConfigurationManager.AppSettings["UploadPathSC"].ToString();   //文件路径
                }
                else if (FileType == "ProductLisence")
                {
                    filePath = System.Configuration.ConfigurationManager.AppSettings["UploadPathPL"].ToString();   //文件路径
                }
                else if (FileType == "DCMS")
                {
                    filePath = System.Configuration.ConfigurationManager.AppSettings["UploadPathDCMS"].ToString();   //文件路径
                }
                else if (FileType == "IRF")
                {
                    filePath = System.Configuration.ConfigurationManager.AppSettings["UploadPathIRF"].ToString();   //文件路径
                }
                //FileStream fstream = File.Create(filePath + fileName, fileBt.Length);
                //FileStream fstream = File.AppendAllText(
                FileStream fstream = new FileStream(filePath + newFileName, FileMode.Create);
                try
                {
                    //MemoryStream m = new MemoryStream(fileBt);
                    //m.WriteTo(fstream);
                    fstream.Write(fileBt, 0, fileBt.Length);   //二进制转换成文件

                    //rst += "\r\n";
                    result += " File Name is:" + newFileName + "\r\n";

                    fstream.Close();

                    #region 保存上传附件角色日志信息
                    if (FileType == "ScoreCard")
                    {
                        IEndoScoreCardBLL _endoScoreCard = new EndoScoreCardBLL();
                        DataSet ds = _endoScoreCard.GetScoreCardIdByNo(ESCNo);
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            ScAttachment attach = new ScAttachment();
                            attach.Id = Guid.NewGuid();
                            attach.MainId = new Guid(ds.Tables[0].Rows[0]["ESCH_ID"].ToString());
                            attach.Name = FileName;
                            attach.Url = newFileName;//AppSettings.HostUrl + "/Upload/UploadFile/" + newFileName;

                            if (FileOperType == "DSM上传")
                            {
                                attach.Type = "DSM";
                            }
                            else if (FileOperType == "CM上传")
                            {
                                attach.Type = "CM";
                            }

                            attach.Remark = Remark;
                            attach.UploadDate = DateTime.Now;
                            attach.UploadUser = new Guid(_endoScoreCard.GetUserIdByName(UploadUser).Tables[0].Rows[0]["Id"].ToString());

                            _endoScoreCard.AddScAttachment(attach);

                            ScoreCardLog scl = new ScoreCardLog();
                            scl.Id = Guid.NewGuid();
                            scl.EscId = new Guid(ds.Tables[0].Rows[0]["ESCH_ID"].ToString());
                            scl.OperUser = UploadUser;
                            scl.OperDate = DateTime.Now;
                            scl.OperNote = Remark;
                            scl.OperType = FileOperType + "附件";
                            _endoScoreCard.Insert(scl);
                        }
                    }
                    else if (FileType == "ProductLisence")
                    {
                        Attachment Att = new Attachment();
                        AttachmentDao Attdao = new AttachmentDao();
                        Att.Id = Guid.NewGuid();
                        Att.MainId = Guid.Empty;
                        Att.Name = FileName;
                        Att.Url = newFileName;
                        Att.Type = FileType;
                        Att.UploadUser = Guid.Empty;
                        Att.UploadDate = DateTime.Now;
                        Attdao.Insert(Att);

                        UploadLog log = new UploadLog();
                        log.Id = Guid.NewGuid();
                        log.Type = "PL:" + newFileName;
                        log.DmaId = Guid.Empty;
                        log.CreateUser = Guid.Empty;
                        log.CreateDate = DateTime.Now;

                        using (UploadLogDao dao = new UploadLogDao())
                        {
                            dao.Insert(log);
                        }
                    }
                    else if (FileType == "DCMS") 
                    {
                        UploadLog log = new UploadLog();
                        log.Id = Guid.NewGuid();
                        log.Type = "DCMS:" + newFileName;
                        log.DmaId = Guid.Empty;
                        log.CreateUser = Guid.Empty;
                        log.CreateDate = DateTime.Now;

                        using (UploadLogDao dao = new UploadLogDao())
                        {
                            dao.Insert(log);
                        }
                    }

                    #endregion

                }
                catch (Exception ex)
                {
                    //抛出异常信息
                    result = ex.ToString();
                }
                finally
                {

                    fstream.Close();
                }
                //StringBuilder sbd = new StringBuilder();
                //sbd.AppendLine(rst);
                //return sbd.ToString();

            #endregion

            }
        }

       
    }

    public class FileUploader : UploadData
    {
         public FileUploader(byte[] fileBt, string ESCNo, string FileType, string FileOperType, string FileName, string Remark, string UploadUser, DateTime UploadDate,int Index, out string result)
        {
            #region 保存附件
            string fileExtention = string.Empty;
            string fileExt = string.Empty;
            if (FileName.LastIndexOf(".") < 0)
            {
                result = "Failed";

            }
            else
            {
                fileExtention = FileName.Substring(FileName.LastIndexOf("\\") + 1);
                fileExt = FileName.Substring(FileName.LastIndexOf(".") + 1).ToLower();

                string newFileName = FileType == "ScoreCard" ? fileExtention.Substring(0, fileExtention.LastIndexOf(".")) + DateTime.Now.ToString("yyyyMMddHHmmss") + "." + fileExt : fileExtention.Substring(0, fileExtention.LastIndexOf(".")) + "." + fileExt;

                result = "successful";
                //if (fileBt.Length == 0)
                //return "The length of the File" + FileName + "is 0";
                string filePath = "";
                if (FileType == "ScoreCard")
                {
                    filePath = System.Configuration.ConfigurationManager.AppSettings["UploadPathSC"].ToString();   //文件路径
                }
                else if (FileType == "ProductLisence")
                {
                    filePath = System.Configuration.ConfigurationManager.AppSettings["UploadPathPL"].ToString();   //文件路径
                }
                else if (FileType == "DCMS")
                {
                    filePath = System.Configuration.ConfigurationManager.AppSettings["UploadPathDCMS"].ToString();   //文件路径
                }
                else if (FileType == "IRF")
                {
                    filePath = System.Configuration.ConfigurationManager.AppSettings["UploadPathIRF"].ToString();   //文件路径
                }
                //FileStream fstream = File.Create(filePath + fileName, fileBt.Length);
                //FileStream fstream = File.AppendAllText(
                FileStream fstream = null;
                try
                {
                    //MemoryStream m = new MemoryStream(fileBt);
                    //m.WriteTo(fstream);
                    if (Index == 0)
                    {
                        fstream = new FileStream(filePath + newFileName, FileMode.OpenOrCreate);
                        fstream.Write(fileBt, 0, fileBt.Length);
                    }
                    else{
                        fstream = File.OpenWrite(filePath + newFileName);
                        fstream.Position = fstream.Length;

                        fstream.Write(fileBt, 0, fileBt.Length);
                    }

                    //二进制转换成文件

                    //rst += "\r\n";
                    result += " File Name is:" + newFileName + "\r\n";

                    fstream.Close();

                    #region 保存上传附件角色日志信息
                    if (FileType == "ScoreCard")
                    {
                        IEndoScoreCardBLL _endoScoreCard = new EndoScoreCardBLL();
                        DataSet ds = _endoScoreCard.GetScoreCardIdByNo(ESCNo);
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            ScAttachment attach = new ScAttachment();
                            attach.Id = Guid.NewGuid();
                            attach.MainId = new Guid(ds.Tables[0].Rows[0]["ESCH_ID"].ToString());
                            attach.Name = FileName;
                            attach.Url = newFileName;//AppSettings.HostUrl + "/Upload/UploadFile/" + newFileName;

                            if (FileOperType == "DSM上传")
                            {
                                attach.Type = "DSM";
                            }
                            else if (FileOperType == "CM上传")
                            {
                                attach.Type = "CM";
                            }

                            attach.Remark = Remark;
                            attach.UploadDate = DateTime.Now;
                            attach.UploadUser = new Guid(_endoScoreCard.GetUserIdByName(UploadUser).Tables[0].Rows[0]["Id"].ToString());

                            _endoScoreCard.AddScAttachment(attach);

                            ScoreCardLog scl = new ScoreCardLog();
                            scl.Id = Guid.NewGuid();
                            scl.EscId = new Guid(ds.Tables[0].Rows[0]["ESCH_ID"].ToString());
                            scl.OperUser = UploadUser;
                            scl.OperDate = DateTime.Now;
                            scl.OperNote = Remark;
                            scl.OperType = FileOperType + "附件";
                            _endoScoreCard.Insert(scl);
                        }
                    }
                    else if (FileType == "ProductLisence" && Index == 0)
                    {
                        Attachment Att = new Attachment();
                        AttachmentDao Attdao = new AttachmentDao();
                        Att.Id = Guid.NewGuid();
                        Att.MainId = Guid.Empty;
                        Att.Name = FileName;
                        Att.Url = newFileName;
                        Att.Type = FileType;
                        Att.UploadUser = Guid.Empty;
                        Att.UploadDate = DateTime.Now;
                        Attdao.Insert(Att);

                        UploadLog log = new UploadLog();
                        log.Id = Guid.NewGuid();
                        log.Type = "PL:" + newFileName;
                        log.DmaId = Guid.Empty;
                        log.CreateUser = Guid.Empty;
                        log.CreateDate = DateTime.Now;

                        using (UploadLogDao dao = new UploadLogDao())
                        {
                            dao.Insert(log);
                        }
                    }
                    else if (FileType == "DCMS")
                    {
                        UploadLog log = new UploadLog();
                        log.Id = Guid.NewGuid();
                        log.Type = "DCMS:" + newFileName;
                        log.DmaId = Guid.Empty;
                        log.CreateUser = Guid.Empty;
                        log.CreateDate = DateTime.Now;

                        using (UploadLogDao dao = new UploadLogDao())
                        {
                            dao.Insert(log);
                        }
                    }

                    #endregion

                }
                catch (Exception ex)
                {
                    //抛出异常信息
                    result = ex.ToString();
                }
                finally
                {

                    fstream.Close();
                }
                //StringBuilder sbd = new StringBuilder();
                //sbd.AppendLine(rst);
                //return sbd.ToString();

            #endregion

            }
        }

    }
}
