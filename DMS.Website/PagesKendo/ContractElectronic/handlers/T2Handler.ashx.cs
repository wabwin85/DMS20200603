using DMS.Business.ContractElectronic;
using DMS.Common.Common;
using DMS.Model.ViewModel.ContractElectronic;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace DMS.Website.PagesKendo.ContractElectronic.handlers
{
    /// <summary>
    /// T2Handler 的摘要说明
    /// </summary>
    public class T2Handler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            ContractDetailView model = new ContractDetailView();

            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<ContractDetailView>(data);
                SelectFunService service = new SelectFunService();
                ContractService business = new ContractService();
                if (model.Method == "InitT2ApplyRenew")
                {
                    if (model.ContractType == "Appointment")
                        model = service.SelectFunAppointmentByContractID(model);
                    if (model.ContractType == "Renewal")
                        model = service.SelectFunRenewalByContractID(model);
                }
                if (model.Method == "InitT2Modify")
                {
                    model = service.SelectFunAmendmentByContractID(model);
                }
                if (model.Method == "InitT2Term")
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
                    ContractService Service = new ContractService();
                    model = business.ExportPDFLP(Service.BuildPath(model));
                    //model = business.ExportPDFLP(model);
                }
                else if (model.Method == "ContractRevoke")
                {
                    ContractService Service = new ContractService();
                    Service.ContractRevokeByExportId(model);

                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

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