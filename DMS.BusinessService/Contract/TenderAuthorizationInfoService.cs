using System;
using DMS.Common.Common;
using DMS.Common;
using System.Data;
using System.Collections;
using DMS.Business;
using System.Linq;
using Lafite.RoleModel.Security;
using System.Collections.Specialized;
using DMS.Common.Extention;
using DMS.Business.Excel;
using DMS.ViewModel.Contract;
using DMS.Business.Contract;
using DMS.Model;
using DMS.DataAccess.Contract;
using System.Web;
using System.IO;
using Newtonsoft.Json;

namespace DMS.BusinessService.Contract
{
    public class TenderAuthorizationInfoService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        public TenderAuthorizationInfoVO Init(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                IPromotionPolicyBLL _business = new PromotionPolicyBLL();
                Hashtable obj = new Hashtable();
                DataTable dt = Bll.SelectSuperiorDealer(obj).Tables[0];
                model.ListSuperiorDealer = JsonHelper.DataTableToArrayList(dt);
                model.ListAuthorizationInfo = new ArrayList(DictionaryHelper.GetDictionary(SR.Provisional_Authorization).ToList());
                model.ListDealerType = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type).ToList());
                model.ListBu = base.GetProductLine();
                if (string.IsNullOrEmpty(model.InstanceId))
                {
                    model.isNewApply = true;
                    model.InstanceId = Guid.NewGuid().ToString();
                    model.Status = "Draft";
                    model.IptSAtulicenseType = true;

                    AuthorizationTenderMain Head = new AuthorizationTenderMain();
                    Head.Id = new Guid(model.InstanceId);
                    Head.States = model.Status;
                    Head.LicenceType = true;
                    Bll.InsertTenderMain(Head);
                }
                else
                {
                    AuthorizationTenderMain Head = Bll.GetTenderMainById(new Guid(model.InstanceId));
                    if (Head != null)
                    {
                        model.IptAtuNo = Head.No;
                        model.IptProductLine = new ViewModel.Common.KeyValue(Head.ProductLineId.ToString());
                        model.IptDealerType = new ViewModel.Common.KeyValue(Head.DealerType);
                        model.IptAtuApplyUser = Head.CreateUser;

                        if (Head.ProductLineId.ToString() != "")
                        {
                            DataSet dsSubBu = _business.GetSubBU(Head.ProductLineId.ToString());
                            model.ListSubBU = JsonHelper.DataTableToArrayList(dsSubBu.Tables[0]);
                            model.IptSubBU = new ViewModel.Common.KeyValue(Head.SubBU);
                        }
                        model.Status = Head.States;
                        if (model.Status == "Draft" && model.IptDealerType != null && model.IptDealerType.Key == "T2")
                        {
                            model.IptSuperiorDealer = new ViewModel.Common.KeyValue(Convert.ToString(Head.SupDealer));
                        }
                        model.IptAuthorizationInfo = new ViewModel.Common.KeyValue(Head.ApplicType);

                        if (model.IptSubBU != null && model.IptDealerType != null)
                        {
                            Hashtable rps = new Hashtable();
                            rps.Add("ProductLindId", model.IptProductLine.Key);
                            rps.Add("SubBu", model.IptSubBU.Key);
                            rps.Add("DealerType", model.IptDealerType.Key);
                            DataTable query = Bll.GetTenderAllProduct(rps).Tables[0];
                            model.RstProductStore = JsonHelper.DataTableToArrayList(query);
                        }
                        if (Head.CreateDate != null)
                        {
                            model.IptAtuApplyDate = Head.CreateDate.Value.ToString("yyyy-MM-dd hh:mm:ss");
                        }
                        if (Head.BeginDate != null)
                        {
                            model.IptAtuBeginDate = Head.BeginDate.Value.ToString();
                        }
                        if (Head.EndDate != null)
                        {
                            model.IptAtuEndDate = Head.EndDate.Value.ToString();
                        }
                        model.IptDealerName = Head.DealerName;

                        if (Head.LicenceType != null && !Head.LicenceType.Value)
                        {
                            model.IptSAtulicenseType = Head.LicenceType.Value;
                        }
                        model.IptAtuRemark = Head.Remark1;
                        if (Head.DealerType != null)
                        {
                            model.IptDealerType = new ViewModel.Common.KeyValue(Head.DealerType.ToString());
                        }
                        model.IptAtuMailAddress = Head.DealerAddress;                        
                    }

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

        public TenderAuthorizationInfoVO ChangeProductLine(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                IPromotionPolicyBLL _business = new PromotionPolicyBLL();
                Bll.ClearHospitalProduct(model.InstanceId);
                Bll.ClearHospital(model.InstanceId);
                DataSet dsSubBu = _business.GetSubBU(model.IptProductLine.Key);
                model.ListSubBU = JsonHelper.DataTableToArrayList(dsSubBu.Tables[0]);
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
        public TenderAuthorizationInfoVO ChangeSubBu(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                Bll.ClearHospitalProduct(model.InstanceId);
                Hashtable obj = new Hashtable();
                obj.Add("ProductLindId", model.IptProductLine.Key);
                obj.Add("SubBu", model.IptSubBU.Key);
                obj.Add("DealerType", model.IptDealerType.Key);
                DataTable query = Bll.GetTenderAllProduct(obj).Tables[0];
                model.RstProductStore = JsonHelper.DataTableToArrayList(query);
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
        public TenderAuthorizationInfoVO DeleteHospital(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                if (!string.IsNullOrEmpty(model.HospitalId))
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("DtmId", model.InstanceId);
                    obj.Add("DthId", model.HospitalId);
                    bool isdeleted = Bll.DeleteTenderHospital(obj);
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("请先选择医院！");
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
        public TenderAuthorizationInfoVO SaveDeptment(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                if (!string.IsNullOrEmpty(model.HospitalId))
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("DthDept", model.AddHosDepartment);
                    obj.Add("DthId", model.HospitalId);
                    Bll.UpdateTenderHospitalDept(obj);
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存出错！");
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
        public TenderAuthorizationInfoVO SaveProduct(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                if (!string.IsNullOrEmpty(model.HospitalId))
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("ProductString", model.ProductString);
                    obj.Add("DthId", model.HospitalId);
                    Bll.AddTenderProduct(obj);
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存出错！");
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
        public TenderAuthorizationInfoVO SaveHospital(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListDao dao = new TenderAuthorizationListDao();
                if (!string.IsNullOrEmpty(model.InstanceId))
                {
                    string[] hosId = model.HospitalString.Split(',');
                    foreach(string hs in hosId)
                    {
                        if (!string.IsNullOrEmpty(hs))
                        {
                            dao.AddTenderHospital(model.InstanceId, hs);
                        }
                    }                    
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存出错！");
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
        public TenderAuthorizationInfoVO DeleteProductByID(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListDao dao = new TenderAuthorizationListDao();
                if (!string.IsNullOrEmpty(model.PCTId))
                {
                    dao.DeleteTenderProduct(model.PCTId);
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("选择授权产品！");
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
        public string HospitalQuery(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                Hashtable obj = new Hashtable();
                obj.Add("DtmId", model.InstanceId);
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = Bll.GetTenderHospitalQuery(obj, start, model.PageSize, out outCont);
                model.RstHospitalDetail = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstHospitalDetail, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }
        public string ProductQuery(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                Hashtable obj = new Hashtable();
                obj.Add("DthId", model.HospitalId);
                obj.Add("DtmId", model.InstanceId);
                obj.Add("BeginDate", model.IptAtuBeginDate);
                obj.Add("EndDate", model.IptAtuEndDate);
                obj.Add("OperType", "Query");
                obj.Add("start", (model.Page - 1) * model.PageSize);
                obj.Add("limit", model.PageSize);
                DataSet query = Bll.GetTenderHospitalProductQuery(obj);
                int outCont = int.Parse(Convert.ToString(query.Tables[0].Rows[0]["CNT"]));
                model.RstHospitalProduct = JsonHelper.DataTableToArrayList(query.Tables[1]);

                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstHospitalProduct, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public TenderAuthorizationInfoVO AttachmentStore_Refresh(TenderAuthorizationInfoVO model)
        {
            try
            {
                //IAttachmentBLL _attachBll = new AttachmentBLL();
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                DataTable dt = new DataTable();
                //Guid tid = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Hashtable tb = new Hashtable();
                tb.Add("MainId", model.InstanceId);
                int totalCount = 0;
                DataSet ds = Bll.GetTenderFileQuery(tb, 0, int.MaxValue, out totalCount);
                if (ds != null)
                {
                    dt = ds.Tables[0];
                }
                model.AttachmentList = JsonHelper.DataTableToArrayList(dt);
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

        public TenderAuthorizationInfoVO DeleteAttachment(TenderAuthorizationInfoVO model)
        {
            try
            {
                IAttachmentBLL _attachBll = new AttachmentBLL();
                Guid id = string.IsNullOrEmpty(model.DeleteAttachmentID) ? Guid.Empty : new Guid(model.DeleteAttachmentID);
                _attachBll.DelAttachment(id);
                string uploadFile = HttpContext.Current.Server.MapPath("..\\..\\..\\Upload\\UploadFile\\TenderAuthorization");
                File.Delete(uploadFile + "\\" + model.DeleteAttachmentName);
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add("删除附件失败，请联系DMS技术支持");
            }
            return model;
        }

        public TenderAuthorizationInfoVO checkAttachment(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                model.IsSuccess = false;
                //判断上传证件
                string retValue = Bll.CheckTenderAttachment(model.InstanceId);
                if (model.IptSAtulicenseType && retValue == "2")
                {
                    model.IsSuccess = true;
                }
                else if (retValue == "2" || retValue == "1")
                {
                    model.IsSuccess = true;
                }

                
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add("删除附件失败，请联系DMS技术支持");
            }
            return model;
        }
        public TenderAuthorizationInfoVO Submint(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                AuthorizationTenderMain header = GetFormValue(model);
                header.States = "InApproval";
                Bll.SaveAuthTenderMain(header, "doSubmit");
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add("提交失败，请联系DMS技术支持");
            }
            return model;
        }
        public TenderAuthorizationInfoVO Save(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                AuthorizationTenderMain header = GetFormValue(model);
                header.States = "Draft";
                Bll.SaveAuthTenderMain(header, "doSave");
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add("保存失败，请联系DMS技术支持");
            }
            return model;
        }
        public TenderAuthorizationInfoVO Delete(TenderAuthorizationInfoVO model)
        {
            try
            {
                TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
                Bll.DeleteAuthTenderMain(model.InstanceId);
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add("删除失败，请联系DMS技术支持");
            }
            return model;
        }
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            ITenderAuthorizationList business = new TenderAuthorizationListBLL();
            string id = "";

            if (!string.IsNullOrEmpty(Parameters["InstanceId"].ToSafeString()))
            {
                id = Parameters["InstanceId"].ToSafeString();
            }
                        
            DataSet ds= business.ExportHospitalProduct(id);
            
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("TenderAuthorization");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        private AuthorizationTenderMain GetFormValue(TenderAuthorizationInfoVO model)
        {
            AuthorizationTenderMain main = new AuthorizationTenderMain();
            main.Id = new Guid(model.InstanceId);
            main.No = model.IptAtuNo;
            main.DealerName = model.IptDealerName;
            if (model.IptProductLine!=null&&!string.IsNullOrEmpty(model.IptProductLine.Key))
            {
                main.ProductLineId = new Guid(model.IptProductLine.Key);
            }
            if (Convert.ToDateTime(model.IptAtuBeginDate) > DateTime.MinValue)
            {
                main.BeginDate = Convert.ToDateTime(model.IptAtuBeginDate);
            }
            if (Convert.ToDateTime(model.IptAtuEndDate) > DateTime.MinValue)
            {
                main.EndDate = Convert.ToDateTime(model.IptAtuEndDate);
            }

            main.ApplicType = model.IptAuthorizationInfo.Key;
            main.CreateDate = DateTime.Now;
            main.CreateUser = RoleModelContext.Current.UserName;
            main.LicenceType = model.IptSAtulicenseType;
            main.DealerAddress = model.IptAtuMailAddress;
            main.DealerType = model.IptDealerType.Key;
            main.Remark1 = model.IptAtuRemark;
            main.SubBU = model.IptSubBU.Key;
            if (model.IptSuperiorDealer!=null&&!string.IsNullOrEmpty(model.IptSuperiorDealer.Key))
            {
                main.SupDealer = new Guid(model.IptSuperiorDealer.Key);
            }
            if (!model.IptDealerName.Equals("") && !model.IptDealerType.Key.Equals("") && !model.IptProductLine.Key.Equals(""))
            {
                main.Remark2 = CheckDealerName(model.IptDealerName, model.IptDealerType.Key, model.IptProductLine.Key, model.IptSubBU.Key, model.IptSuperiorDealer.Key);
            }
            return main;
        }
        public string CheckDealerName(string Dealername, string DealerType, string ProductLineId, string cbWdSubBU, string SuperiorDealer)
        {
            TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
            string rtnMassage = "";
            Hashtable obj = new Hashtable();
            obj.Add("DealerName", Dealername);
            obj.Add("DealerType", DealerType);
            obj.Add("ProductLineId", ProductLineId);
            obj.Add("SubBU", ProductLineId);
            if (SuperiorDealer != "")
            {
                obj.Add("SupDealer", SuperiorDealer);
            }
            DataTable query = Bll.CheckTenderDealerName(obj).Tables[0];

            if (query.Rows.Count > 0)
            {
                rtnMassage = "系统中已包含同名经销商";
            }
            return rtnMassage;
        }
        #endregion
    }


}
