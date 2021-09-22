using DMS.Business.EKPWorkflow;
using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.Contract;
using DMS.Model;
using DMS.Model.EKPWorkflow;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Business.Contract
{
    public class TenderAuthorizationListBLL : ITenderAuthorizationList
    {
        private EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
        IRoleModelContext _context = RoleModelContext.Current;

        public DataSet GetAuthorization(Guid id)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.GetAuthorization(id);
            }
        }

        public DataSet GetAuthorizationList(Guid id)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.GetAuthorizationList(id);
            }
        }
        //查询
        public DataSet GetTenderAuthorizationList(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.GetTenderAuthorizationList(obj, start, limit, out totalRowCount);
            }

        }
        //合同类型
        public DataSet ExpApplicType(string id)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.ExpApplicType(id);
            }

        }
        //授权医院
        public DataSet ExpHospital(string id)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.ExpHospital(id);
            }
        }

        //书签替换
        public DataSet SelectTenderWork(string No)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.SelectTenderWork(No);
            }

        }
        //上级平台商
        public DataSet SelectSuperiorDealer(Hashtable obj)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.SelectSuperiorDealer(obj);
            }
        }
        //正式合同
        public DataSet Submint_Contract(Hashtable obj)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.SelectContract(obj);
            }
        }

        public DataSet ExcelTenderAuthorization(Hashtable obj)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.ExcelTenderAuthorization(obj);
            }
        }
        public AuthorizationTenderMain GetTenderMainById(Guid Id)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.GetTenderMainById(Id);
            }
        }

        public DataSet GetTenderHospitalQuery(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.GetTenderHospitalQuery(obj, start, limit, out totalRowCount);
            }
        }
        public DataSet GetTenderHospitalProductQuery(Hashtable obj)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.GetTenderHospitalProductQuery(obj);
            }
        }
        public DataSet GetTenderFileQuery(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.GetTenderFileQuery(obj, start, limit, out totalRowCount);
            }
        }
        public DataSet CheckTenderDealerName(Hashtable obj)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.CheckTenderDealerName(obj);
            }
        }
        public bool DeleteTenderHospital(Hashtable obj)
        {
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    TenderAuthorizationListDao dao = new TenderAuthorizationListDao();
                    int a = dao.DeleteTenderProduct(obj);
                    int b = dao.DeleteTenderHospital(obj);
                    result = true;
                    trans.Complete();
                }
            }
            catch (Exception ex)
            {

            }
            return result;
        }

        //清空授权医院
        public void ClearHospital(string DtmId)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                dao.ClearHospital(DtmId);
            }
        }
        //清空授权产品
        public void ClearHospitalProduct(string DtmId)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                dao.ClearHospitalProduct(DtmId);
            }
        }
        public void AddTenderProduct(Hashtable obj)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                dao.AddTenderProduct(obj);
            }
        }
        public DataSet GetTenderAllProduct(Hashtable obj)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.GetTenderAllProduct(obj);
            }
        }
        public void DeleteTenderProduct(Guid[] changes)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                TenderAuthorizationListDao dao = new TenderAuthorizationListDao();

                foreach (Guid item in changes)
                {
                    dao.DeleteTenderProduct(item.ToString());
                }
                trans.Complete();
            }
        }
        public void InsertTenderMain(AuthorizationTenderMain tendermain)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                dao.InsertTenderMain(tendermain);
            }
        }
        public void SaveAuthTenderMain(AuthorizationTenderMain tendermain, string operType)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                if (operType == "doSubmit")
                {
                    tendermain.No = this.GetNextAutoNumberForTender(tendermain.ProductLineId.Value.ToString(), "ATU", "SysSalesUploader");
                }
                dao.UpdateTenderMain(tendermain);
            }

            if (operType == "doSubmit")
            {
                string productLine = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine).Where<Lafite.RoleModel.Domain.AttributeDomain>(p => p.Id.ToUpper().Equals(tendermain.ProductLineId.ToString().ToUpper())).First().AttributeName;
                //发起流程
                ekpBll.DoSubmit(_context.User.LoginId, tendermain.Id.ToString(), tendermain.No, "TenderAuth", string.Format("{0} {1}经销商招投标授权", tendermain.No, tendermain.DealerName)
                    , EkpModelId.Tender.ToString(), EkpTemplateFormId.TenderTemplate.ToString());
            }
        }


        public void DeleteAuthTenderMain(string DtmId)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                TenderAuthorizationListDao dao = new TenderAuthorizationListDao();
                dao.DeleteTenderProductByDtmId(DtmId);
                dao.DeleteTenderHospitalByDtmId(DtmId);
                dao.DeleteTenderMainByDtmId(DtmId);
                trans.Complete();
            }
        }

        public bool SaveHospitalOfAuthorization(string dtmId, IDictionary<string, string>[] changes)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                TenderAuthorizationListDao dao = new TenderAuthorizationListDao();
                foreach (Dictionary<string, string> hospital in changes)
                {
                    dao.AddTenderHospital(dtmId, hospital["HosId"].ToString());
                }
                result = true;
                trans.Complete();
            }
            return result;
        }
        public string GetNextAutoNumberForTender(string deptcode, string clientid, string strSettings)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.GetNextAutoNumberForTender(deptcode, clientid, strSettings);
            }
        }
        public string CheckTenderAttachment(string mainId)
        {
            string retValue = "0";
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                DataTable dtRe = dao.GetTenderAttachmentType(mainId).Tables[0];
                if (dtRe.Rows.Count > 0)
                {
                    retValue = dtRe.Rows[0]["retValue"].ToString();
                }
            }
            return retValue;
        }
        public int UpdateTenderHospitalDept(Hashtable obj)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.UpdateTenderHospitalDept(obj);
            }
        }

        public DataSet ExportHospitalProduct(string id)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.ExcleHospitalproduct(id);
            }
        }
        //授权医院和产品清单
        public DataSet ExportHospitalProductWork(Hashtable id)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.ExcleHospitalproductWork(id);
            }
        }

        public DataSet ExportHospital(string id, int start, int limit, out int totalRowCoun)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.ExcleHospital(id, start, limit, out totalRowCoun);
            }
        }

        public DataSet ExportTenderAuthorizationProduct(string id)
        {
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.ExportTenderAuthorizationProduct(id);
            }
        }

        public DataSet SelectHospitalNum(string id)
        {

            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                return dao.SelectHospitalNum(id);
            }
        }

        public StringBuilder CreateTenderAuthorizationHtml(string id, DmsTemplateHtmlType htmlType, StringBuilder htmlStringBuilder)
        {
            DataTable dt;
            HtmlHelper helper = new HtmlHelper();
            using (TenderAuthorizationListDao dao = new TenderAuthorizationListDao())
            {
                dt = dao.QueryTenderAuthorizationForHtmlById(id);
            }

            //获取表头信息
            Dictionary<string, string> dict = new Dictionary<string, string>();
            dict.Add("No", dt.Rows[0]["No"].ToString());
            dict.Add("CreateUser", dt.Rows[0]["CreateUser"].ToString());
            dict.Add("CreateDate", dt.Rows[0]["CreateDate"].ToString());
            dict.Add("ProductLineId", dt.Rows[0]["ProductLineName"].ToString());
            dict.Add("BeginDate", dt.Rows[0]["BeginDate"].ToString());
            dict.Add("EndDate", dt.Rows[0]["EndDate"].ToString());
            dict.Add("DealerType", dt.Rows[0]["DealerTypeName"].ToString());
            dict.Add("LicenceType", dt.Rows[0]["LicenceType"].ToString());
            dict.Add("DealerName", dt.Rows[0]["DealerName"].ToString());
            dict.Add("DealerAddress", dt.Rows[0]["DealerAddress"].ToString());
            dict.Add("Remark1", dt.Rows[0]["Remark1"].ToString());

            //获取授权产品
            Hashtable obj = new Hashtable();
            obj.Add("DthId", Guid.Empty.ToString());
            obj.Add("DtmId", id);
            obj.Add("BeginDate", dt.Rows[0]["BeginDate"].ToString());
            obj.Add("EndDate", dt.Rows[0]["EndDate"].ToString());
            obj.Add("OperType", "Export");
            obj.Add("start", 0);
            obj.Add("limit", 0);
            DataTable tenderProductDt = this.GetTenderHospitalProductQuery(obj).Tables[0];

            //填写表单主信息
            helper.SetHtmlContentByKeyValue(htmlStringBuilder, dict);
            //对DataTable排序，并移出不需要的列
            helper.SetColumnIndexAndRemoveColumn(tenderProductDt, new string[] { "ROWNUMBER", "HosKeyAccount", "HosHospitalName", "SubProductName", "RepeatDealer" });
            tenderProductDt.TableName = "TenderTable";
            //填写授权产品信息
            helper.SetHtmlContentByDataTable(htmlStringBuilder, tenderProductDt);

            AttachmentBLL attBll = new AttachmentBLL();
            StringBuilder attachmentStr = attBll.GetAttachmentContent(id, htmlType);

            //填写表单主信息
            dict.Clear();
            dict.Add("AttachmentGrid", attachmentStr.ToString());
            helper.SetHtmlContentByKeyValue(htmlStringBuilder, dict);

            //string fileName = helper.CreateHtml(id, sb);

            return htmlStringBuilder;
        }

        public DataSet SuperiorDealer(string id)
        {
            throw new NotImplementedException();
        }
    }
}
