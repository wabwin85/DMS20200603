using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Contract
{
    public partial class ContractHospitalInfo : BasePage
    {
        #region 公用
        private IContractMasterBLL _contractMasterBll = new ContractMasterBLL();
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.hidHospitalUploadDatId.Text = Request.QueryString["datId"].ToString();
                this.hidMarktingType.Text = Request.QueryString["MarktingType"].ToString();
                this.hidContractId.Text = Request.QueryString["ContractId"].ToString();
                
            }
        }
        /// <summary>
        /// 上传医院信息
        /// </summary>
        protected void HospitalUploadStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DatId", (this.hidHospitalUploadDatId.Text.Equals("00000000-0000-0000-0000-000000000000") ? this.hidContractId.Text : this.hidHospitalUploadDatId.Text));
            obj.Add("ISError", "0");
            int totalCount = 0;
            this.HospitalUploadStore.DataSource = _contractMasterBll.QueryHospitalUpload(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarHospital.PageSize : e.Limit), out totalCount);
            this.HospitalUploadStore.DataBind();
            e.TotalCount = totalCount;
        }

        //上传医院

        protected void HospitalUploadClick(object sender, AjaxEventArgs e)
        {
            //先删除上传人之前的数据
            _contractMasterBll.DeleteTempUploadHospitalByDatId((this.hidHospitalUploadDatId.Text.Equals("00000000-0000-0000-0000-000000000000") ? this.hidContractId.Text : this.hidHospitalUploadDatId.Text));

            if (this.FileUploadHospital.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadHospital.PostedFile.FileName;
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

                string file = Server.MapPath("\\Upload\\UploadFile\\DCMS\\" + newFileName);


                //文件上传
                FileUploadHospital.PostedFile.SaveAs(file);

                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 3)
                {
                    Ext.Msg.Alert("错误", "请使用正确的模板!").Show();

                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        if (_contractMasterBll.DCMSHospitalTempImport(dt, (this.hidHospitalUploadDatId.Text.Equals("00000000-0000-0000-0000-000000000000") ? this.hidContractId.Text : this.hidHospitalUploadDatId.Text)))
                        {
                            string IsValid = string.Empty;
                            if (_contractMasterBll.VerifyDCMSHospitalImport((this.hidHospitalUploadDatId.Text.Equals("00000000-0000-0000-0000-000000000000") ? this.hidContractId.Text : this.hidHospitalUploadDatId.Text), this.hidMarktingType.Text, out IsValid))
                            {
                                if (IsValid == "Error")
                                {
                                    Ext.Msg.Alert("Error", "数据包含错误或警告信息，请确认后导入！").Show();
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

        [AjaxMethod]
        public string SubmintProductHospital()
        {
            string retMassage = "";
            //提交数据
            Hashtable obj = new Hashtable();
            obj.Add("DatId", (this.hidHospitalUploadDatId.Text.Equals("00000000-0000-0000-0000-000000000000") ? this.hidContractId.Text : this.hidHospitalUploadDatId.Text));
            obj.Add("InputType", (this.hidHospitalUploadDatId.Text.Equals("00000000-0000-0000-0000-000000000000") ? "All" : "Part"));
            obj.Add("ISError", "1");
            if (!_contractMasterBll.SubmintHospitalTempInitCheck(obj))
            {
                retMassage = "0";
            }
            else 
            {
                _contractMasterBll.SaveHospitalTempInit(obj);
                retMassage = "1";
            }
            return retMassage;
        }
    }
}
