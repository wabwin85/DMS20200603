using Common.Logging;
using DMS.Common;
using DMS.Signature.BLL;
using DMS.Signature.Model;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using static DMS.Signature.Model.EviFileDigestRequest;

namespace DMS.Website.PagesKendo.ESign.handler
{
    /// <summary>
    /// ESignHandlerDemo 的摘要说明
    /// </summary>
    public class ESignHandlerDemo : IHttpHandler
    {
        private static ILog _log = LogManager.GetLogger(typeof(ESignHandler));
        private ESignViewModel model = new ESignViewModel();
        private IRoleModelContext _context = RoleModelContext.Current;

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                String data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<ESignViewModel>(data);

                if ("EnterpriseUser".Equals(model.Function, StringComparison.OrdinalIgnoreCase))
                {
                    EnterpriseUserHandler(model);
                }
                else if ("EnterpriseSeal".Equals(model.Function, StringComparison.OrdinalIgnoreCase))
                {
                    EnterpriseSealHandler(model);
                }
                else if ("EnterpriseSign".Equals(model.Function, StringComparison.OrdinalIgnoreCase))
                {
                    EnterpriseSignHandler(model);
                }
                else if ("EnterpriseAuth".Equals(model.Function, StringComparison.OrdinalIgnoreCase))
                {
                    EnterpriseAuthHandler(model);
                }
            }
            catch (Exception ex)
            {
                _log.Error(ex.ToString());

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            context.Response.Write(JsonConvert.SerializeObject(model));
        }

        /// <summary>
        /// 企业用户注册、更新
        /// </summary>
        /// <param name="model"></param>
        private void EnterpriseUserHandler(ESignViewModel model)
        {
            ESignBLL bll = new ESignBLL();
            EnterpriseUserVO vo = JsonConvert.DeserializeObject<EnterpriseUserVO>(model.ReqData);
            if ("Init".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                String dealerId = !String.IsNullOrEmpty(vo.DealerId) ? vo.DealerId : _context.User.CorpId.Value.ToString();

                DataTable obj = bll.QueryEnterpriseUser(dealerId);

                model.ResData = JsonHelper.DataTableToJson(obj);
            }
            else if ("Create".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.CreateDate = DateTime.Now;
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.UpdateDate = vo.CreateDate;
                vo.UpdateUser = vo.CreateUser;
                vo.UpdateUserName = vo.CreateUserName;

                bll.CreateEnterpriseUser(vo);
            }

            model.IsSuccess = true;
        }

        /// <summary>
        /// 企业用户制章
        /// </summary>
        /// <param name="model"></param>
        private void EnterpriseSealHandler(ESignViewModel model)
        {
            ESignBLL bll = new ESignBLL();
            EnterpriseSealVO vo = JsonConvert.DeserializeObject<EnterpriseSealVO>(model.ReqData);

            if ("Init".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                String dealerId = !String.IsNullOrEmpty(vo.DealerId) ? vo.DealerId : _context.User.CorpId.Value.ToString();

                DataSet obj = bll.QueryEnterpriseSeal(dealerId);

                model.ResData = JsonConvert.SerializeObject(new { data = obj.Tables[0], historyList = obj.Tables[1] });
            }
            else if ("Create".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                if (String.IsNullOrEmpty(vo.AccountUid))
                {
                    throw new Exception("请先注册电子签章企业用户信息");
                }

                vo.CreateDate = DateTime.Now;
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.UpdateDate = vo.CreateDate;
                vo.UpdateUser = vo.CreateUser;
                vo.UpdateUserName = vo.CreateUserName;

                bll.CreateEnterpriseSeal(vo);
            }
            else if ("DownloadSeal".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                try
                {
                    var now = DateTime.Now;
                    string filePath = "/Upload/temp/";
                    string fileName = Guid.NewGuid() + ".png";

                    byte[] arr = Convert.FromBase64String(vo.Seal);
                    using (MemoryStream ms = new MemoryStream(arr))
                    {
                        Bitmap bmp = new Bitmap(ms);
                        if (!Directory.Exists(new Page().Server.MapPath(filePath)))
                        {
                            Directory.CreateDirectory(new Page().Server.MapPath(filePath));
                        }

                        //新建第二个bitmap类型的bmp2变量。
                        Bitmap bmp2 = new Bitmap(bmp, bmp.Width, bmp.Height);
                        //将第一个bmp拷贝到bmp2中
                        Graphics draw = Graphics.FromImage(bmp2);
                        draw.DrawImage(bmp, 0, 0);
                        draw.Dispose();

                        bmp2.Save(new Page().Server.MapPath(filePath + fileName), System.Drawing.Imaging.ImageFormat.Png);

                        ms.Close();

                        model.ResData = JsonConvert.SerializeObject(new { imageUrl = fileName });
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("下载图片失败" + ex.Message);
                }
            }

            model.IsSuccess = true;
        }

        /// <summary>
        /// 电子签章
        /// </summary>
        /// <param name="model"></param>
        private void EnterpriseSignHandler(ESignViewModel model)
        {
            ESignBLL bll = new ESignBLL();
            EnterpriseSignVO vo = JsonConvert.DeserializeObject<EnterpriseSignVO>(model.ReqData);

            if ("Init".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.DealerId = !String.IsNullOrEmpty(vo.DealerId) ? vo.DealerId : _context.User.CorpId.Value.ToString();
                DataTable dt = bll.QueryEnterpriseUser(vo.DealerId);

                model.ResData = JsonHelper.DataTableToJson(dt);
            }
            else if ("Search".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                List<EnterpriseSignModelDemo> list = new List<EnterpriseSignModelDemo>();

                list.Add(new EnterpriseSignModelDemo { Id = "78730027-539D-43C3-9F32-2D1B7690BC00", DealerName = vo.DealerName, ContractNo = "Contract00000001" });
                list.Add(new EnterpriseSignModelDemo { Id = "15CFF44D-FFB6-4466-A45C-E8BA6E7DF7D0", DealerName = vo.DealerName, ContractNo = "Contract00000002" });
                list.Add(new EnterpriseSignModelDemo { Id = "590708CC-BE1E-45E3-A6E0-D78753A2A044", DealerName = vo.DealerName, ContractNo = "Contract00000003" });

                model.ResData = JsonConvert.SerializeObject(new { data = list, total = list.Count() });
            }
            else if ("ShowLog".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                IList<FileVersion> list = bll.QueryFileVersion(vo.ApplyId);
                model.ResData = JsonConvert.SerializeObject(new { data = list });
            }
            else if ("ShowPdf".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                if (!File.Exists(new Page().Server.MapPath(vo.FileSrcPath + vo.FileSrcName)))
                {
                    throw new Exception("文件不存在");
                }

                List<object> list = bll.PereviewPdf(vo.FileSrcPath + vo.FileSrcName);

                if (list.Count == 0)
                {
                    throw new Exception("PDF预览错误！");
                }

                model.ResData = JsonConvert.SerializeObject(list);
            }
            else if ("SendCode".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                String phone = bll.SendMobileCode(vo);

                if (phone.Length >= 7)
                {
                    phone = Regex.Replace(phone, "(\\d{3})\\d{4}(\\d{4})", "$1****$2");
                }

                model.ResData = JsonConvert.SerializeObject(new { Phone = phone });
            }
            else if ("Sign".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                vo.FileSrcPath = @"//Upload//";
                vo.FileDstPath = @"//Upload//";
                vo.FileSrcName = @"DM-RN-2016-0070-V-20171220-145121.pdf";
                vo.FileName = @"DM-RN-2016-0070-V-20171220-145121.pdf";

                bll.EnterpriseUserSign(vo);

                model.ResData = JsonConvert.SerializeObject(new { FileSrcPath = vo.FileSrcPath, FileSrcName = vo.FileSrcName });
            }
            else if ("LocalSign".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                //vo.ApplyId = Guid.NewGuid().ToString();
                //vo.FileId = Guid.NewGuid().ToString();
                vo.FileSrcPath = @"//Upload//";
                vo.FileDstPath = @"//Formal";
                vo.FileSrcName = @"DM-RN-2016-0070-V-20171220-145121.pdf";
                vo.FileName = @"DM-RN-2016-0070-V-20171220-145121.pdf";

                bll.EnterpriseSelfSign(vo);

                model.ResData = JsonConvert.SerializeObject(new { FileSrcPath = vo.FileSrcPath, FileSrcName = vo.FileSrcName });
            }
            else if ("CanelSign".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                vo.FileSrcPath = @"//Upload//";
                vo.FileDstPath = @"//Formal//";
                vo.FileSrcName = @"DM-RN-2016-0070-V-20171220-145121.pdf";
                vo.FileName = @"DM-RN-2016-0070-V-20171220-145121.pdf";

                bll.EnterpriseUserCanelSign(vo);

                model.ResData = JsonConvert.SerializeObject(new { FileSrcPath = vo.FileSrcPath, FileSrcName = vo.FileSrcName });
            }
            else if ("LocalCanelSign".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                vo.FileSrcPath = @"//Upload//";
                vo.FileDstPath = @"//Formal//";
                vo.FileSrcName = @"DM-RN-2016-0070-V-20171220-145121.pdf";
                vo.FileName = @"DM-RN-2016-0070-V-20171220-145121.pdf";

                bll.EnterpriseSelfCanelSign(vo);

                model.ResData = JsonConvert.SerializeObject(new { FileSrcPath = vo.FileSrcPath, FileSrcName = vo.FileSrcName });
            }
            else if("FileDigest".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                EviFileModel eviFileModel = new EviFileModel();
                RelateFileModel relateModel = new RelateFileModel();

                eviFileModel.applyId = "78730027-539D-43C3-9F32-2D1B7690BC00";
                eviFileModel.fileId = "78730027-539D-43C3-9F32-2D1B7690BC00";
                eviFileModel.dealerId = _context.User.CorpId.Value;
                eviFileModel.filePath = new Page().Server.MapPath(@"//Upload//faead3f4-b0ff-406c-992e-c32cd18a2c79.pdf");
                eviFileModel.eviName = "DM-RN-2016-0070-V-20171220-145121.pdf";

                List<ESignIds> esignIds = new List<ESignIds>();
                esignIds.Add(new ESignIds { type = 0, value = "956083745578881029" });
                esignIds.Add(new ESignIds { type = 0, value = "956083758329565192" });
                eviFileModel.eSignIds = esignIds;

                eviFileModel.bizIds = null;

                eviFileModel.CreateUser = new Guid(_context.User.Id);
                eviFileModel.CreateUserName = _context.User.FullName;
                eviFileModel.CreateDate = DateTime.Now;

                relateModel.applyId = eviFileModel.applyId;
                relateModel.fileId = eviFileModel.fileId;
                relateModel.dealerId = eviFileModel.dealerId;

                List<CertificateBean> certificates = new List<CertificateBean>();

                certificates.Add(new CertificateBean { type = "CODE_USC", name = "上海葡萄城信息技术有限公司", number = "91310115607246787D" });
                relateModel.certificates = certificates;

                relateModel.CreateUser = new Guid(_context.User.Id);
                relateModel.CreateUserName = _context.User.FullName;
                relateModel.CreateDate = DateTime.Now;

                bll.FileDigestUpload(eviFileModel, relateModel);
            }

            model.IsSuccess = true;
        }

        /// <summary>
        /// 企业实名认证
        /// </summary>
        /// <param name="model"></param>
        private void EnterpriseAuthHandler(ESignViewModel model)
        {

            ESignBLL bll = new ESignBLL();
            EnterpriseAuthVO vo = JsonConvert.DeserializeObject<EnterpriseAuthVO>(model.ReqData);

            if ("Init".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.DealerId = !String.IsNullOrEmpty(vo.DealerId) ? vo.DealerId : _context.User.CorpId.Value.ToString();
                DataTable dt = bll.QueryEnterpriseAuth(vo);

                model.ResData = JsonHelper.DataTableToJson(dt);
            }
            else if ("RealName".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                bll.EnterpriseRealNameAuth(vo);
            }
            else if ("ToPay".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                bll.EnterpriseToPay(vo);
            }
            else if ("PayAuth".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                bll.EnterprisePayAuth(vo);
            }

            model.IsSuccess = true;
        }
        
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }

    public class EnterpriseSignModelDemo
    {
        public String Id { get; set; }
        public String DealerName { get; set; }
        public String ContractNo { get; set; }
    }
}