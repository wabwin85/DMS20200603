using DMS.Business;
using DMS.BusinessService.Util.DataImport;
using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.OBORESign;
using DMS.Model;
using DMS.ViewModel.Common;
using DMS.ViewModel.OBORESign;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace DMS.BusinessService.OBORESign
{
    public class OBORESignInfoService : ABaseQueryService, IDataImportFac
    {
        private IMessageBLL _messageBLL = new MessageBLL();
        public ADataImport CreateDataImport()
        {
            return new ImportDealerContractWaterMark();
        }

        public OBORESignInfoVO Init(OBORESignInfoVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();
              


                if (!string.IsNullOrEmpty(model.ES_ID))
                {

                    DataTable tb = new DataTable();
                    QueryDao Bu = new QueryDao();
                    Hashtable htbu = new Hashtable();
                    htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                    htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                    model.LstBu = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);

                    tb = dao.SelectOBORESignInfo(model.ES_ID);
                    if (tb.Rows.Count > 0)
                    {
                        model.RstDetailList = JsonHelper.DataTableToArrayList(dao.SelectOBORESignInfo(model.ES_ID));
                        model.Status = dao.SelectOBORESignInfo(model.ES_ID).Rows[0]["Status"].ToString();
                        model.IptSignA = tb.Rows[0]["DMA_ChineseName"].ToString();
                        model.IptCreateUser = tb.Rows[0]["IDENTITY_NAME"].ToString();
                        model.LstSignB = JsonHelper.DataTableToArrayList(dao.SelectSignB(RoleModelContext.Current.User.CorpId.ToString(), RoleModelContext.Current.User.CorpType));
                        model.LstSubBu = dao.BuChange(tb.Rows[0]["ES_ProductLineID"].ToString());
                        model.IptSignB = new ViewModel.Common.KeyValue(tb.Rows[0]["ES_SignB"].ToString(),"");
                        model.IptBu = new ViewModel.Common.KeyValue(tb.Rows[0]["ES_ProductLineID"].ToString(), "");

                        model.IptSubBu= new List<KeyValue>();
                        //model.IptSubBu.Add(new KeyValue(tb.Rows[0]["ES_SubBu"].ToString(), tb.Rows[0]["ES_SubBu"].ToString()));
                        string str = tb.Rows[0]["ES_SubBu"].ToString();
                        string[] sArray = str.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        for (int i =0;i<sArray.Length;i++) {
                            model.IptSubBu.Add(new KeyValue(sArray[i],sArray[i]));
                        }

                        model.IptCreateDate = tb.Rows[0]["ES_CreateDate"].ToString();
                        model.IptAgreementNo = tb.Rows[0]["ES_AgreementNo"].ToString();

                        if (tb.Rows[0]["ES_Status"].ToString() == "WaitDealerSign"|| tb.Rows[0]["ES_Status"].ToString() == "WaitLPSign")
                        {
                            model.SignReadonly = false;
                            if ((RoleModelContext.Current.User.CorpType == "LP" || RoleModelContext.Current.User.CorpType == "LS"))
                            {
                                model.RevokeReadonly = false;
                            }
                           
                        }
                        if (tb.Rows[0]["ES_Status"].ToString()== "Draft"&& (RoleModelContext.Current.User.CorpType=="LP"|| RoleModelContext.Current.User.CorpType == "LS"))
                        {
                            model.DeleteReadonly = false;
                            model.SubmitReadonly = false;
                        }

                        model.UploadReadonly = false;
                        
                    }
                    else
                    {
                        //model.IptCreateDate = DateTime.Now.ToString();
                        model.IptSignA = RoleModelContext.Current.User.CorpName;
                        model.LstSignB = JsonHelper.DataTableToArrayList(dao.SelectSignB(RoleModelContext.Current.User.CorpId.ToString(), RoleModelContext.Current.User.CorpType));
                        model.IptCreateUser = RoleModelContext.Current.User.FullName;
                        model.LstSubBu = null;
                        model.SubmitReadonly = false;
                        

                    }
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

        public OBORESignInfoVO Query(OBORESignInfoVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();

                
                model.RstDetailList = JsonHelper.DataTableToArrayList(dao.SelectOBORESignInfo(model.ES_ID));
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }


        public OBORESignInfoVO Download(OBORESignInfoVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();

                DataTable tb = new DataTable();
                tb = dao.SelectOBORESignUrl(model.ES_ID);

                string FileSrcPath = tb.Rows.Count > 0 ? tb.Rows[0]["ES_UploadFilePath"].ToString() : "";
                model.FileName = tb.Rows[0]["ES_FileName"].ToString();
                model.Src = FileSrcPath;

                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }


        public OBORESignInfoVO Save(OBORESignInfoVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();
                DataTable tb = new DataTable();
                tb = dao.SelectOBORESignInfo(model.ES_ID);
                if (tb.Rows.Count > 0)
                {
                    //update
                    dao.SaveOBORInfo(model.ES_ID,model.IptBu.Key, ConvertKeyValueList(model.IptSubBu),RoleModelContext.Current.User.CorpId.ToString(),model.IptSignB.Key,DateTime.Now.ToString(), RoleModelContext.Current.User.Id.ToString(),"Update");
                }
                else
                {
                    //insert
                    dao.SaveOBORInfo(model.ES_ID, model.IptBu.Key, ConvertKeyValueList(model.IptSubBu), RoleModelContext.Current.User.CorpId.ToString(), model.IptSignB.Key, DateTime.Now.ToString(), RoleModelContext.Current.User.Id.ToString(), "Insert");
                }
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }

        public OBORESignInfoVO Submit(OBORESignInfoVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();
                DataTable tb = new DataTable();
                tb = dao.SelectOBORESignInfo(model.ES_ID);
                string SAPCode = dao.SelectDealerSapCode(model.IptSignB.Key);

                if (tb.Rows.Count > 0)
                {


                    //发送短信
                    string phone = dao.SelectDealerPhone(model.ES_ID);

                    if (model.ES_ID != "" && phone != "")
                    {
                        string ES_AgreementNo = dao.ProcGetNextAutoNumberOBOR(SAPCode, "", "OBOR", "Next_OBORAppointment");
                        SendMassage(ES_AgreementNo, phone);

                        //update
                        dao.SubmitOBORInfo(model.ES_ID, model.IptBu.Key, ConvertKeyValueList(model.IptSubBu), RoleModelContext.Current.User.CorpId.ToString(), model.IptSignB.Key, DateTime.Now.ToString(), RoleModelContext.Current.User.Id.ToString(), ES_AgreementNo);

                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("请注册企业用户信息");
                    }
                }
                else {
                    //保存草稿
                    dao.SaveOBORInfo(model.ES_ID, model.IptBu.Key, ConvertKeyValueList(model.IptSubBu), RoleModelContext.Current.User.CorpId.ToString(), model.IptSignB.Key, DateTime.Now.ToString(), RoleModelContext.Current.User.Id.ToString(), "Insert");


                    //发送短信
                    string phone = dao.SelectDealerPhone(model.ES_ID);

                    if (model.ES_ID != "" && phone != "")
                    {
                        string ES_AgreementNo = dao.ProcGetNextAutoNumberOBOR(SAPCode, "", "OBOR", "Next_OBORAppointment");
                        SendMassage(ES_AgreementNo, phone);

                        //update
                        dao.SubmitOBORInfo(model.ES_ID, model.IptBu.Key, ConvertKeyValueList(model.IptSubBu), RoleModelContext.Current.User.CorpId.ToString(), model.IptSignB.Key, DateTime.Now.ToString(), RoleModelContext.Current.User.Id.ToString(), ES_AgreementNo);

                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("请注册企业用户信息");
                    }
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


        public OBORESignInfoVO Delete(OBORESignInfoVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();

                DataTable tb = new DataTable();
                tb = dao.SelectOBORESignInfo(model.ES_ID);
                if (tb.Rows[0]["ES_Status"].ToString() == "Draft")
                {
                    dao.Delete(model.ES_ID);
                    model.IsSuccess = true;
                }
                else
                {
                    model.ExecuteMessage.Add("合同状态已更改，请重试！");
                    model.IsSuccess = false;
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

        public OBORESignInfoVO Revoke(OBORESignInfoVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();

                DataTable tb = new DataTable();
                tb = dao.SelectOBORESignInfo(model.ES_ID);
                if (tb.Rows[0]["ES_Status"].ToString() == "WaitDealerSign"|| tb.Rows[0]["ES_Status"].ToString() == "WaitLPSign")
                {
                    dao.Revoke(model.ES_ID);
                    model.IsSuccess = true;
                }
                else
                {
                    model.ExecuteMessage.Add("合同状态已更改，请重试！");
                    model.IsSuccess = false;
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


        public OBORESignInfoVO BuChange(OBORESignInfoVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();

                model.LstSubBu = dao.BuChange(model.IptBu.Key);
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }

        private void SendMassage(string AgreementNo, string massageTo)
        {
            ShortMessageTemplate temp = _messageBLL.GetShortMessageTemplate("SMS_OBOR_SUBMIT");

            MessageTaskSend massage = new MessageTaskSend();
            massage.SendMode = "2";
            massage.EmailWechatContent = temp.Template.Replace("#Verification#", AgreementNo);
            massage.MsgPhone = massageTo;
            massage.HtmlTranslationFLG = "1";
            massage.InsertQueFLG = "0";
            massage.SendAdminFLG = "0";
            massage.InsertTime = DateTime.Now;
            massage.InsertOrigin = "songw2";
            massage.GUID = "DMS-" + Guid.NewGuid().ToString();

            _messageBLL.AddToShortMessagTask(massage);
        }

        public static String ConvertKeyValueList(IList<KeyValue> Value)
        {
            String result = "";

            if (Value != null)
            {
                for (int i = 0; i < Value.Count; i++)
                {
                    result += Value[i].Key;
                    if (i != Value.Count - 1)
                    {
                        result += ",";
                    }
                }
            }

            return result;
        }

    }
}
