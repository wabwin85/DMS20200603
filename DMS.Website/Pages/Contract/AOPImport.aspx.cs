using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using DMS.Common;
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Contract
{
    public partial class AOPImport : BasePage
    {
        #region 公用
        private IContractCommonBLL _contractCommonbll = new ContractCommonBLL();
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["ContractId"] != null || Request.QueryString["DealerId"] != null || Request.QueryString["ProductLineId"] != null
                    || Request.QueryString["IsEmerging"] != null || Request.QueryString["SubBuCode"] != null || Request.QueryString["YearString"] != null
                    || Request.QueryString["BeginDate"] != null || Request.QueryString["EndDate"] != null || Request.QueryString["PageType"] != null || Request.QueryString["ContractType"] != null)
                {
                    this.hidContractId.Value = Request.QueryString["ContractId"];
                    this.hidDealerId.Value = Request.QueryString["DealerId"];
                    this.hidProductLineId.Value = Request.QueryString["ProductLineId"];
                    this.hidYearString.Value = Request.QueryString["YearString"];
                    this.hidSubBuCode.Value = Request.QueryString["SubBuCode"];
                    this.hidIsEmerging.Value = Request.QueryString["IsEmerging"];
                    this.hidBeginDate.Value = Request.QueryString["BeginDate"];
                    this.hidEndDate.Value = Request.QueryString["EndDate"];
                    this.hidPageType.Value = Request.QueryString["PageType"];
                    this.hidContractType.Value = Request.QueryString["ContractType"];
                }
            }
        }

        public void UpLoadHospitalAOPStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractId.Value.ToString());

            DataTable dt = _contractCommonbll.QueryHospitalIndexImputError(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarUpload.PageSize : e.Limit), out totalCount).Tables[0];
            (this.UpLoadHospitalAOPStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            UpLoadHospitalAOPStore.DataSource = dt;
            UpLoadHospitalAOPStore.DataBind();
        }

        [AjaxMethod]
        public void UploadHospitalAOPSubmint()
        {
            string resount = _contractCommonbll.HospitalProductAOPInputSubmint(this.hidContractId.Value.ToString());

            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractId.Value.ToString());
            obj.Add("LastContractId", this.hidLastContractId.Value.ToString());
            obj.Add("DealerId", this.hidDealerId.Value.ToString());
            obj.Add("ProductLineId", this.hidProductLineId.Value.ToString());
            obj.Add("SubBU", this.hidSubBuCode.Value.ToString());
            obj.Add("MarketType", this.hidIsEmerging.Value.ToString());
            obj.Add("YearString", this.hidYearString.Value.ToString());
            obj.Add("BeginDate", this.hidBeginDate.Value.ToString());
            obj.Add("EndDate", this.hidEndDate.Value.ToString());
            obj.Add("AOPType", this.hidPageType.Value.ToString());
            obj.Add("SyType", "1");
            obj.Add("ContractType", this.hidContractType.Value.ToString());
            _contractCommonbll.DealerAOPMerge(obj);
        }

        protected void UploadHospitalAOPClick(object sender, AjaxEventArgs e)
        {
            //先删除上传人之前的数据
            _contractCommonbll.DeleteProductHospitalInitById(this.hidContractId.Value.ToString());

            if (this.FileUploadFieldDealer.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadFieldDealer.PostedFile.FileName;
                string fileExtention = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    if (fileExtention != "xls" && fileExtention != "xlsx")
                    {
                        error = true;
                    }
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请使用正确的模板文件，模板文件为EXCEL文件!"
                    });

                    return;
                }



                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\" + newFileName);


                //文件上传
                FileUploadFieldDealer.PostedFile.SaveAs(file);

                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "Recovered_Sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 17)
                {
                    Ext.Msg.Alert("错误", "请使用正确的模板!").Show();

                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        if (_contractCommonbll.HospitalProductAOPInput(dt, this.hidContractId.Value.ToString()))
                        {
                            string IsValid = string.Empty;
                            if (_contractCommonbll.VerifyHospitalProductImport(out IsValid, this.hidContractId.Value.ToString(), Convert.ToDateTime(this.hidBeginDate.Value.ToString())))
                            {
                                if (IsValid == "Error")
                                {
                                    Ext.Msg.Alert("Error", "数据包含错误，请修改后重新导入！").Show();
                                }
                                else
                                {
                                    this.ButtonUploadHospitalAopSubmint.Hidden = false;
                                }
                            }
                        }
                        else
                        {
                            Ext.Msg.Alert("错误", "Excel数据格式错误!").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "没有数据可导入!").Show();
                    }

                #endregion

                }
            }

            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传!"
                });


            }
        }
    }
}
