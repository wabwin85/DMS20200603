using DMS.Common.Common;
using DMS.ViewModel.OBORESign;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using DMS.Signature.BLL;
using Newtonsoft.Json;
using DMS.DataAccess.OBORESign;
using System.Data;
using DMS.Signature.Model;
using Lafite.RoleModel.Security;

namespace DMS.BusinessService.OBORESign
{
    public class OBORContractWindowService : ABaseQueryService
    {

        public OBORContractWindowVO Init(OBORContractWindowVO model)
        {
            try
            {
                ESignBLL bll = new ESignBLL();
                OBORESignDao dao = new OBORESignDao();

                DataTable tb = new DataTable();
                tb = dao.SelectOBORESignUrl(model.ES_ID);

                if (tb.Rows[0]["ES_Status"].ToString()== "WaitDealerSign"&& (RoleModelContext.Current.User.CorpType=="T1"|| RoleModelContext.Current.User.CorpType=="T2")) {
                    model.DealerSignReadonly = false;
                }
                if (tb.Rows[0]["ES_Status"].ToString() == "WaitLPSign" && (RoleModelContext.Current.User.CorpType == "LP" || RoleModelContext.Current.User.CorpType == "LS"))
                {
                    model.LPSignReadonly = false;
                }

                string FileSrcPath = tb.Rows.Count>0?tb.Rows[0]["ES_UploadFilePath"].ToString():"";


                if (!File.Exists(new Page().Server.MapPath(FileSrcPath)))
                {
                    throw new Exception("文件不存在");
                }


                List<object> list = bll.PereviewPdf(FileSrcPath);
                model.ResData = JsonConvert.SerializeObject(list);
                model.Src = FileSrcPath;
                model.FileName = tb.Rows[0]["ES_FileName"].ToString();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }



        public OBORContractWindowVO DealerSign(OBORContractWindowVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();
                ESignBLL bll = new ESignBLL();

                DataTable tb = new DataTable();
                tb = dao.SelectOBORESignUrl(model.ES_ID);

                if ((tb.Rows[0]["ES_Status"].ToString() == "WaitDealerSign"))
                {

                    string str = tb.Rows[0]["ES_UploadFilePath"].ToString();
                    string[] sArray = str.Split(new string[] { "temp/" }, StringSplitOptions.RemoveEmptyEntries);

                    EnterpriseSignVO vo = new EnterpriseSignVO();
                    vo.DealerId = RoleModelContext.Current.User.CorpId.ToString();
                    vo.CreateUser = new Guid(RoleModelContext.Current.User.CorpId.ToString());
                    vo.CreateUserName = RoleModelContext.Current.User.CorpName;
                    vo.CreateDate = DateTime.Now;
                    vo.ApplyId = model.ES_ID;
                    vo.FileSrcPath = "/Upload/temp/";
                    vo.FileDstPath = @"//Upload/temp/";
                    vo.FileSrcName = sArray[1];
                    vo.FileName = sArray[1];
                    vo.FileId = "00000000-0000-0000-0000-000000000000";
                    bll.EnterpriseUserSign(vo);

                    string FileSrcName = vo.FileSrcName;

                    //更新合同状态
                    dao.UpdateDealerSign(model.ES_ID, FileSrcName, RoleModelContext.Current.User.Id.ToString());

                }
                else {

                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("合同状态已更改，请重试！");
                }



            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }



        public OBORContractWindowVO LPSign(OBORContractWindowVO model)
        {
            try
            {


               
                OBORESignDao dao = new OBORESignDao();
                ESignBLL bll = new ESignBLL();

                DataTable tb = new DataTable();
                tb = dao.SelectOBORESignUrl(model.ES_ID);

                if ((tb.Rows[0]["ES_Status"].ToString() == "WaitLPSign"))
                {
                    string str = tb.Rows[0]["ES_UploadFilePath"].ToString();
                    string[] sArray = str.Split(new string[] { "temp/" }, StringSplitOptions.RemoveEmptyEntries);

                    EnterpriseSignVO vo = new EnterpriseSignVO();
                    vo.DealerId = RoleModelContext.Current.User.CorpId.ToString();
                    vo.CreateUser = new Guid(RoleModelContext.Current.User.CorpId.ToString());
                    vo.CreateUserName = RoleModelContext.Current.User.CorpName;
                    vo.CreateDate = DateTime.Now;
                    vo.ApplyId = model.ES_ID;
                    vo.FileSrcPath = "/Upload/temp/";
                    vo.FileDstPath = @"//Upload/temp/";
                    vo.FileSrcName = sArray[1];
                    vo.FileName = sArray[1];
                    vo.FileId = "00000000-0000-0000-0000-000000000000";
                    bll.EnterpriseLPSign(vo);

                    string FileSrcName = vo.FileSrcName;

                    //更新合同状态
                    dao.UpdateLPSign(model.ES_ID, FileSrcName, RoleModelContext.Current.User.Id.ToString());
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("合同状态已更改，请重试！");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }




    }
}
