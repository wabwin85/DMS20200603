using Common.Logging;
using DMS.Business;
using DMS.Business.ContractElectronic;
using DMS.Common;
using DMS.Model;
using DMS.Signature;
using DMS.Signature.BLL;
using DMS.Signature.Model;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlTypes;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;

namespace DMS.Website.PagesKendo.ESign.handler
{
    /// <summary>
    /// ESignHandler 的摘要说明
    /// </summary>
    public class ESignHandler : IHttpHandler, IRequiresSessionState
    {
        private static ILog _log = LogManager.GetLogger(typeof(ESignHandler));
        private ESignViewModel model = new ESignViewModel();
        private IRoleModelContext _context = RoleModelContext.Current;
        private ContractService ContractBll = new ContractService();
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
                else if ("EnterpriseTool".Equals(model.Function, StringComparison.OrdinalIgnoreCase))
                {
                    EnterpriseToolHandler(model);
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
        /// 企业实名认证
        /// </summary>
        /// <param name="model"></param>
        private void EnterpriseAuthHandler(ESignViewModel model)
        {
            ESignBLL bll = new ESignBLL();
            EnterpriseRegisterVO vo = JsonConvert.DeserializeObject<EnterpriseRegisterVO>(model.ReqData);

            if ("Init".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                vo.DealerId = !String.IsNullOrEmpty(vo.DealerId) ? vo.DealerId : _context.User.CorpId.Value.ToString();
                DataTable dt = bll.QueryEnterpriseRegister(vo);

                model.ResData = JsonHelper.DataTableToJson(dt);
            }
            else if ("RealName".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                DataTable dt = bll.QueryEnterpriseRegister(vo);

                String updateDate = dt.Rows[0]["CreateDate"] == DBNull.Value ? "" : dt.Rows[0]["CreateDate"].ToString();

                if (!String.IsNullOrEmpty(model.LastUpdateDate) && dt.Rows[0]["CreateDate"] != DBNull.Value)
                {
                    if (model.LastUpdateDate != updateDate)
                    {
                        throw new Exception("记录已更新，请刷新页面！");
                    }
                }
                else if ((String.IsNullOrEmpty(model.LastUpdateDate) && dt.Rows[0]["CreateDate"] != DBNull.Value)
                    || (!String.IsNullOrEmpty(model.LastUpdateDate) && dt.Rows[0]["CreateDate"] == DBNull.Value))
                {
                    throw new Exception("记录已更新，请刷新页面！");
                }

                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                //如果法定代表身份号码发生了改变，则将“法人代表ID（LegalAccounUid）”置为空，用于重新注册法人信息
                if (!String.IsNullOrEmpty(vo.LegalAccountUid) )
                {
                    if (dt.Rows[0]["LegalIdNo"] != DBNull.Value&& dt.Rows[0]["LegalIdNo"].ToString()!= vo.LegalIdNo)
                    {
                        vo.LegalAccountUid = string.Empty;
                    }
                }
                bll.EnterpriseRealNameRegister(vo);
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
            DealerMasters dealerBll = new DealerMasters();

            EnterpriseSignVO vo = JsonConvert.DeserializeObject<EnterpriseSignVO>(model.ReqData);

            if ("Init".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                String dealerId = !String.IsNullOrEmpty(vo.DealerId) ? vo.DealerId : _context.User.CorpId.HasValue ? _context.User.CorpId.Value.ToString() : Guid.Empty.ToString();

                DealerMaster dm = dealerBll.GetDealerMaster(new Guid(dealerId));

                //vo.DealerId = !String.IsNullOrEmpty(vo.DealerId) ? vo.DealerId : _context.User.CorpId.Value.ToString();

                //DataTable dt = bll.QueryEnterpriseUser(vo.DealerId);

                model.ResData = JsonHelper.Serialize(dm);
            }
            else if ("Search".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                QueryService QueryBll = new QueryService();
                ArrayList QueryList = new ArrayList();
                List<EnterpriseSignModel> list = new List<EnterpriseSignModel>();
                Hashtable ht = new Hashtable();
                ReqData Data = JsonConvert.DeserializeObject<ReqData>(model.ReqData);
                ht.Add("DealerId", Data.DealerId);
                ht.Add("Status", Data.ContractStatus);
                ht.Add("ContractNo", Data.ContractNo);
                ht.Add("StartTime", string.IsNullOrEmpty(Data.BeginDate) ? DateTime.Parse(SqlDateTime.MinValue.ToString()).ToString() : Convert.ToDateTime(Data.BeginDate).ToString("yyyy-MM-dd"));
                ht.Add("EndTime", string.IsNullOrEmpty(Data.EndDate) ? DateTime.Parse(SqlDateTime.MaxValue.ToString()).ToString() : Convert.ToDateTime(Data.EndDate).ToString("yyyy-MM-dd"));
                ht.Add("CurrentPageIndex", Data.page);
                ht.Add("PageSize", Data.pageSize);
                ht.Add("ProductLine", Data.ProductLine);
                ht.Add("UserId", _context.User.Id);
                ht.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                ht.Add("BrandId", BaseService.CurrentBrand?.Key);
                DataSet ContractDs = QueryBll.GetContractListByDealerId(ht);
                int a = ContractDs.Tables.Count;
                DataTable tb = ContractDs.Tables[0];
                QueryList = JsonHelper.DataTableToArrayList(ContractDs.Tables[0]);
                //list.Add(new EnterpriseSignModel { Id = "78730027-539D-43C3-9F32-2D1B7690BC00", DealerName = vo.DealerName, ContractNo = "Contract00000001" });
                //list.Add(new EnterpriseSignModel { Id = "15CFF44D-FFB6-4466-A45C-E8BA6E7DF7D0", DealerName = vo.DealerName, ContractNo = "Contract00000002" });
                //list.Add(new EnterpriseSignModel { Id = "590708CC-BE1E-45E3-A6E0-D78753A2A044", DealerName = vo.DealerName, ContractNo = "Contract00000003" });

                //model.ResData = JsonConvert.SerializeObject(new { data = QueryList, total = ContractDs.Tables[1].Rows.Count });
                model.ResData = JsonConvert.SerializeObject(new { data = QueryList, total = ContractDs.Tables[1].Rows[0][0] });
            }
            else if ("ShowLog".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                IList<FileVersion> list = bll.QueryFileVersion(vo.ApplyId);
                model.ResData = JsonConvert.SerializeObject(new { data = list });
            }
            else if ("ShowPdf".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                ReqData Data = JsonConvert.DeserializeObject<ReqData>(model.ReqData);
                DataSet ds = ContractBll.GetExportSelectedTemplateByExportId(Data.FileId);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    throw new Exception("文件不存在");
                }
                string FileSrcPath = ds.Tables[0].Rows[0]["UploadFilePath"].ToString();
                if (!File.Exists(new Page().Server.MapPath(FileSrcPath)))
                {
                    throw new Exception("文件不存在");
                }


                List<object> list = bll.PereviewPdf(FileSrcPath);

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
                ReqData Data = JsonConvert.DeserializeObject<ReqData>(model.ReqData);
                DataSet ds = ContractBll.GetExportSelectedTemplateByExportId(Data.FileId);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    throw new Exception("文件不存在");
                }

                //是有在状态为“等待经销商签章”时才允许签章
                ContractBll.CheckContractStatus(Data.FileId, DMS.Common.ContractESignStatus.WaitDealerSign);

                //string FileSrcPath = ds.Tables[0].Rows[0]["FileSrcPath"].ToString() + "/"+ ds.Tables[0].Rows[0]["FileSrcName"].ToString();
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;
                vo.ApplyId = Data.ApplyId;
                //  vo.FileSrcPath = Data.FileSrcPath;
                vo.FileSrcPath = (ds.Tables[0].Rows[0]["FileSrcPath"].ToString() + "/").Replace("~", "");
                vo.FileDstPath = @"//Upload/ContractElectronicAttachmentTemplate/ExportedPdf/Sign/";
                //  vo.FileSrcName = Data.FileSrcName;
                vo.FileSrcName = ds.Tables[0].Rows[0]["FileSrcName"].ToString();
                vo.FileName = ds.Tables[0].Rows[0]["FileSrcName"].ToString(); ;
                vo.FileId = Data.FileId;
                bll.EnterpriseUserSign(vo);
                //更新电子合同状态
                ContractBll.ContractSign(vo.FileId, vo.FileSrcPath, vo.FileSrcName,Data.DealerId);
                model.ResData = JsonConvert.SerializeObject(new { FileSrcPath = vo.FileSrcPath, FileSrcName = vo.FileSrcName });
            }
            else if ("LocalSign".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                ReqData Data = JsonConvert.DeserializeObject<ReqData>(model.ReqData);

                //是有在状态为“等待波科签章”时才允许签章
                ContractBll.CheckContractStatus(Data.FileId, DMS.Common.ContractESignStatus.WaitBscSign);

                DataSet ds = ContractBll.GetExportSelectedTemplateByExportId(Data.FileId);

                //根据品牌获取经销商
                Hashtable ht = new Hashtable();
                ht.Add("BrandId", BaseService.CurrentBrand?.Key);
                DealerMasters daoDealer = new DealerMasters();
                DataSet dsDealer = daoDealer.GetDealerForLocalSeal(ht);

                if (dsDealer.Tables[0].Rows.Count > 0)
                    vo.DealerId = dsDealer.Tables[0].Rows[0]["DMA_ID"].ToString();
                else
                    vo.DealerId = Guid.Empty.ToString();

                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;
                vo.UserRoles = _context.User.Roles;

                vo.ApplyId = Data.ApplyId;
                vo.FileSrcPath = (ds.Tables[0].Rows[0]["FileSrcPath"].ToString() + "/").Replace("~", "");
                vo.FileDstPath = @"//Upload/ContractElectronicAttachmentTemplate/ExportedPdf/Sign/";
                vo.FileSrcName = ds.Tables[0].Rows[0]["FileSrcName"].ToString();
                vo.FileName = ds.Tables[0].Rows[0]["FileSrcName"].ToString();
                vo.FileId = Data.FileId;
                
                bll.EnterpriseSelfSign(vo);
                //更新电子合同状态
                ContractBll.ContractSign(vo.FileId, vo.FileSrcPath, vo.FileSrcName,Data.DealerId);

                //推送邮件通知电子签章管理员
                ContractBll.SendEmail(vo);

                model.ResData = JsonConvert.SerializeObject(new { FileSrcPath = vo.FileSrcPath, FileSrcName = vo.FileSrcName });
            }
            else if ("LPSign".Equals(model.Method))
            {
                ReqData Data = JsonConvert.DeserializeObject<ReqData>(model.ReqData);

                //是有在状态为“等待平台签章”时才允许签章
                //ContractBll.CheckContractStatus(Data.FileId, DMS.Common.ContractESignStatus.WaitLPSign);

                DataSet ds = ContractBll.GetExportSelectedTemplateByExportId(Data.FileId);
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;
                vo.UserRoles = _context.User.Roles;
                vo.Code = "LP";
                vo.ApplyId = Data.ApplyId;
                vo.FileSrcPath = (ds.Tables[0].Rows[0]["FileSrcPath"].ToString() + "/").Replace("~", "");
                vo.FileDstPath = @"//Upload/ContractElectronicAttachmentTemplate/ExportedPdf/Sign/";
                vo.FileSrcName = ds.Tables[0].Rows[0]["FileSrcName"].ToString();
                vo.FileName = ds.Tables[0].Rows[0]["FileSrcName"].ToString();
                vo.FileId = Data.FileId;
                #region 测试签章注释
                vo.DealerId = _context.User.CorpId.ToString();
                #endregion

                bll.EnterpriseLPSign(vo);
                //更新电子合同状态
                ContractBll.ContractSign(vo.FileId, vo.FileSrcPath, vo.FileSrcName,Data.DealerId);

                //推送邮件通知电子签章管理员
                //ContractBll.SendEmail(vo);

                model.ResData = JsonConvert.SerializeObject(new { FileSrcPath = vo.FileSrcPath, FileSrcName = vo.FileSrcName });
            }
            else if ("CanelSign".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                ReqData Data = JsonConvert.DeserializeObject<ReqData>(model.ReqData);
                DataSet ds = ContractBll.GetExportSelectedTemplateByExportId(Data.FileId);
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;

                vo.FileSrcPath = (ds.Tables[0].Rows[0]["FileSrcPath"].ToString() + "/").Replace("~", "");
                vo.FileDstPath = @"//Upload/ContractElectronicAttachmentTemplate/ExportedPdf/Sign/";
                vo.FileSrcName = ds.Tables[0].Rows[0]["FileSrcName"].ToString();
                vo.FileName = ds.Tables[0].Rows[0]["FileSrcName"].ToString();

                bll.EnterpriseUserCanelSign(vo);
                //更新电子合同状态
                ContractBll.ContractAbandonment(vo.FileId, vo.FileSrcPath, vo.FileSrcName);
                model.ResData = JsonConvert.SerializeObject(new { FileSrcPath = vo.FileSrcPath, FileSrcName = vo.FileSrcName });
            }
            else if ("LocalCanelSign".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                ReqData Data = JsonConvert.DeserializeObject<ReqData>(model.ReqData);
                DataSet ds = ContractBll.GetExportSelectedTemplateByExportId(Data.FileId);
                vo.CreateUser = new Guid(_context.User.Id);
                vo.CreateUserName = _context.User.FullName;
                vo.CreateDate = DateTime.Now;
                vo.UserRoles = _context.User.Roles;

                vo.FileSrcPath = (ds.Tables[0].Rows[0]["FileSrcPath"].ToString() + "/").Replace("~", "");
                vo.FileDstPath = @"//Upload/ContractElectronicAttachmentTemplate/ExportedPdf/Sign/";
                vo.FileSrcName = ds.Tables[0].Rows[0]["FileSrcName"].ToString();
                vo.FileName = ds.Tables[0].Rows[0]["FileSrcName"].ToString();

                bll.EnterpriseSelfCanelSign(vo);
                //更新电子合同状态
                ContractBll.ContractAbandonment(vo.FileId, vo.FileSrcPath, vo.FileSrcName);
                model.ResData = JsonConvert.SerializeObject(new { FileSrcPath = vo.FileSrcPath, FileSrcName = vo.FileSrcName });


            }
            else if ("InitQuery".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                string DealerType = "";
                ReqData Data = JsonConvert.DeserializeObject<ReqData>(model.ReqData);
                DataSet ds = ContractBll.SelectDealerMaster(Data.DealerId);
                //经销商
                ArrayList ResDelaer = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                if (string.IsNullOrEmpty(Data.DealerId))
                {
                     DealerType = "";
                }
                else {
                     DealerType = ContractBll.SelectDealerType(Data.DealerId).Rows[0][0].ToString(); ;
                }
                
                //签章状态状态
                DataSet StatusDs = ContractBll.GetSingStatusList("ContractElectronic");
                ArrayList SingStatus = JsonHelper.DataTableToArrayList(StatusDs.Tables[0]);
                //产品线
                Hashtable htPL = new Hashtable();
                htPL.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htPL.Add("BrandId", BaseService.CurrentBrand?.Key);
                DataSet ProduDs = ContractBll.GetProductLineRelation(htPL);
                ArrayList ProductLineName = JsonHelper.DataTableToArrayList(ProduDs.Tables[0]);

                bool hasSignRole = _context.User.Roles.Contains(SignatureHelper.ESing_BscSignRole) || (_context.User.IdentityType == IdentityType.Dealer.ToString());

                model.ResData = JsonConvert.SerializeObject(new
                {
                    ResDelaer = ResDelaer,
                    SingStatus = SingStatus,
                    ProductLineName = ProductLineName,
                    hasSignRole = hasSignRole.ToString(),
                    DealerType= DealerType
                });
            }

            model.IsSuccess = true;
        }

        #region 方法合并

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

                model.ResData = JsonConvert.SerializeObject(new { data = JsonHelper.DataTableToArrayList(obj.Tables[0]), historyList = JsonHelper.DataTableToArrayList(obj.Tables[1]) });
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

        

        #endregion

        private void EnterpriseToolHandler(ESignViewModel model)
        {
            int totalCount = 0;
            ESignBLL bll = new ESignBLL();
            EnterpriseToolVO vo = JsonConvert.DeserializeObject<EnterpriseToolVO>(model.ReqData);

            if ("QueryBank".Equals(model.Method, StringComparison.OrdinalIgnoreCase))
            {
                Hashtable table = new Hashtable();

                if (!String.IsNullOrEmpty(vo.bankName.Trim()))
                {
                    table.Add("BankName", vo.bankName.Trim());
                }
                if (!String.IsNullOrEmpty(vo.subBranch.Trim()))
                {
                    table.Add("SubBranch", vo.subBranch.Trim());
                }
                
                DataTable dt = bll.QuerySubBranchByKeyWord(table, vo.skip, vo.pageSize, out totalCount);

                model.ResData = JsonConvert.SerializeObject(new { data = JsonHelper.DataTableToArrayList(dt), total = totalCount });
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

    public class EnterpriseSignModel
    {
        public int ROWNUMBE { get; set; }
        public String ExportId { get; set; }
        public String DMA_ID { get; set; }
        public String DMA_ChineseName { get; set; }
        public String ContractNo { get; set; }
        public String ContractId { get; set; }
        public String CreateDate { get; set; }
        public String CreateUser { get; set; }
        public String FileName { get; set; }
        public String FileType { get; set; }
        public String UploadFilePath { get; set; }
    }
}