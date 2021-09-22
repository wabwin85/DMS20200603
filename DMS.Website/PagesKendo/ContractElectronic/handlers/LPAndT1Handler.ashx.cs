using DMS.Business.ContractElectronic;
using DMS.Common.Common;
using DMS.Model.ViewModel.ContractElectronic;
using Newtonsoft.Json;
using Org.BouncyCastle.Asn1.Ocsp;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace DMS.Website.PagesKendo.ContractElectronic.handlers
{
    /// <summary>
    /// LPAndT1Handler 的摘要说明
    /// </summary>
    public class LPAndT1Handler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            ContractDetailView model = new ContractDetailView();

            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存
                string ID = context.Request["ReadID"];
                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<ContractDetailView>(data);
                SelectFunService service = new SelectFunService();
                ContractService business = new ContractService();
                if (model.Method == "InitLPApplyRenew")
                {
                    if (model.ContractType == "Appointment")
                        model = service.SelectFunAppointmentByContractID(model);
                    if (model.ContractType == "Renewal")
                        model = service.SelectFunRenewalByContractID(model);
                }
                else if (model.Method == "InitT1ApplyRenew")
                {
                    if (model.ContractType == "Appointment")
                        model = service.SelectFunAppointmentByContractID(model);
                    if (model.ContractType == "Renewal")
                        model = service.SelectFunRenewalByContractID(model);
                }
                else if (model.Method == "InitLPAndT1Modify")
                {
                    model = service.SelectFunAmendmentByContractID(model);
                }
                else if (model.Method == "InitLPAndT1Term")
                {
                    model = service.SelectFunTerminationByContractID(model);
                }
                else if (model.Method == "InsertExportCache")
                {
                    model = business.InsertExportCache(model);
                }
                else if (model.Method == "InsertExportSubmit")
                {
                    model = business.InsertExportSubmit(model);
                }
                else if (model.Method == "SelectAttach")
                {
                    model = service.SelectAttach(model);
                }
                else if (model.Method == "GiveupCache")
                {
                    model = business.GiveUpCache(model);
                }
                else if (model.Method == "ExportPDFLP")
                {

                    model = business.ExportPDFLP(business.BuildPath(model));
                    //model = business.ExportPDFLP(model);
                }
                else if (model.Method == "ContractRevoke")
                {
                    ContractService Service = new ContractService();
                    Service.ContractRevokeByExportId(model);

                }
                else if (model.Method == "GetReadTemplateList")
                {
                    model = business.GetReadTemplate(model);
                }
                else if (model.Method == "InsertDetail")
                {
                    model = business.InsertDetail(model);
                }
                else if (model.Method == "IsReadFile")
                {
                    model = business.IsReadFile(model);
                }
                else if (model.Method == "InitUploadFile")
                {
                    model = business.InitUploadFile(model);
                }
                else if (model.Method == "SubmitUploadFile")
                {
                    model = business.UploadFile(model);
                }
                else if (model.Method == "GetEsignContractType")
                {
                    model = business.GetLpAndT1ContractEsignTypeByContractId(model);
                }
                else if (model.Method == "TrainingInfo")
                {
                    model = business.QueryDealerTrainingByDealerId(model);
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex.ToString());

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            context.Response.Write(JsonConvert.SerializeObject(model));
        }

  


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}