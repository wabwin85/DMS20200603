using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Business.DealerTrain;
using DMS.Business;
using Coolite.Ext.Web;
using System.Collections;
using System.Data;
using DMS.Common;
using DMS.Model;
using System.Text;

namespace DMS.Website.Pages.DealerTrain
{
    public partial class TrainScoreManage : BasePage
    {
        #region 公用

        IRoleModelContext _context = RoleModelContext.Current;

        private DealerTrainBLL _dealerTrainBLL = new DealerTrainBLL();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_ProductLine(this.StoTrainBu);
            }
        }

        #region 课程查询

        protected void StoTrainList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.QryTrainBu.SelectedItem.Value))
            {
                param.Add("TrainBu", this.QryTrainBu.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.QryTrainName.Text))
            {
                param.Add("TrainName", this.QryTrainName.Text);
            }
            if (!this.QryTrainStartBeginTime.IsNull)
            {
                param.Add("TrainStartBeginTime", this.QryTrainStartBeginTime.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.QryTrainStartEndTime.IsNull)
            {
                param.Add("TrainStartEndTime", this.QryTrainStartEndTime.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.QryTrainEndBeginTime.IsNull)
            {
                param.Add("TrainEndBeginTime", this.QryTrainEndBeginTime.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.QryTrainEndEndTime.IsNull)
            {
                param.Add("TrainEndEndTime", this.QryTrainEndEndTime.SelectedDate.ToString("yyyyMMdd"));
            }
            param.Add("UserId", _context.User.Id);

            DataSet query = _dealerTrainBLL.GetTrainList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagTrainList.PageSize : e.Limit), out totalCount);
            (this.StoTrainList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoTrainList.DataSource = query;
            this.StoTrainList.DataBind();
        }

        protected void StoTrainArea_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> trainArea = DictionaryHelper.GetDictionary(SR.Train_Area);
            StoTrainArea.DataSource = trainArea;
            StoTrainArea.DataBind();
        }

        #endregion

        #region 课程维护

        protected void StoTrainOnlineList_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable Tdetail = new Hashtable();
            Tdetail.Add("TrainId", this.IptTrainId.Value.ToString());
            Tdetail.Add("TrainType", CommandoTrainType.Online.ToString());
            Tdetail.Add("TrainContent1", CommandoTrainOnlineType.Exam.ToString());
            DataTable query = _dealerTrainBLL.GetDealerTrainDetailList(Tdetail, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagTrainOnlineList.PageSize : e.Limit), out totalCount).Tables[0];
            (this.StoTrainOnlineList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoTrainOnlineList.DataSource = query;
            this.StoTrainOnlineList.DataBind();
        }

        [AjaxMethod]
        public void ShowTrainInfo(string trainId)
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();
            this.IptTrainId.Clear();
            this.IptTrainArea.SelectedItem.Value = string.Empty;
            this.IptTrainBu.SelectedItem.Value = string.Empty;
            this.IptTrainStartTime.Clear();
            this.IptTrainDesc.Clear();
            this.IptTrainName.Clear();
            this.IptTrainEndTime.Clear();

            BindTrainInfo(trainId);
        }

        public void BindTrainInfo(string trainId)
        {

            this.IptTrainId.Value = trainId;

            Hashtable param = new Hashtable();
            param.Add("TrainId", this.IptTrainId.Value.ToString());
            TrainMaster trainInfo = _dealerTrainBLL.GetTrainInfo(this.IptTrainId.Value.ToString());
            if (trainInfo != null)
            {
                this.IptTrainName.Value = trainInfo.TrainName;
                this.IptTrainBu.SelectedItem.Value = trainInfo.TrainBu.ToString();
                this.IptTrainDesc.Value = trainInfo.TrainDesc;
                this.IptTrainStartTime.SelectedDate = trainInfo.TrainStartTime.Value;
                this.IptTrainEndTime.SelectedDate = trainInfo.TrainEndTime.Value;
                this.IptTrainArea.SelectedItem.Value = trainInfo.TrainArea;
            }
        }

        #endregion

        #region 在线学习

        protected void StoTrainOnlineType_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> trainOnlineType = DictionaryHelper.GetDictionary(SR.Train_OnlineType);
            StoTrainOnlineType.DataSource = trainOnlineType;
            StoTrainOnlineType.DataBind();
        }

        [AjaxMethod]
        public void ShowTrainOnlineInfo(String trainDetailId)
        {
            this.IptTrainOnlineType.SelectedItem.Value = "";
            this.IptTrainOnlineName.Clear();
            this.IptTrainOnlineContent.Clear();
            this.IptTrainOnlineEndTime.Clear();
            this.IptTrainOnlineId.Clear(); //Id
            this.BtnImportFile.Disabled = true;
            this.BtnImportDatabase.Disabled = true;

            //Show Window
            if (!string.IsNullOrEmpty(trainDetailId))
            {
                this.IptTrainOnlineId.Text = trainDetailId;

                TrainDetail online = _dealerTrainBLL.GetTrainDetailById(new Guid(trainDetailId));

                this.IptTrainOnlineType.SelectedItem.Value = online.TrainContent1;
                this.IptTrainOnlineName.Text = online.TrainContent2;
                this.IptTrainOnlineContent.Text = online.TrainContent3;
                this.IptTrainOnlineEndTime.SelectedDate = Convert.ToDateTime(online.TrainContent4);
            }
            this.WdwTrainExamImport.Show();
        }

        protected void BtnImportFileClick(object sender, AjaxEventArgs e)
        {
            if (this.IptImportFile.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = IptImportFile.PostedFile.FileName;
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
                        Message = "请使用正确的模板文件，模板文件为EXCEL文件！"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\TrainScore\\" + newFileName);


                //文件上传
                IptImportFile.PostedFile.SaveAs(file);

                this.IptFileName.Text = newFileName;
                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 3)
                {
                    Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                    return;
                }

                if (dt.Rows.Count > 1)
                {
                    if (_dealerTrainBLL.ImportTrainOnlineScore(dt, newFileName))
                    {
                        ImportData(this.IptTrainId.Value.ToString(), this.IptTrainOnlineId.Value.ToString());
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "Excel数据格式错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "没有数据可导入！").Show();
                }

                #endregion
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传！"
                });
            }
        }

        protected void BtnImportDatabaseClick(object sender, AjaxEventArgs e)
        {
            ImportData(this.IptTrainId.Value.ToString(), this.IptTrainOnlineId.Value.ToString());
        }

        private void ImportData(String trainId, String classId)
        {
            string IsValid = string.Empty;

            if (_dealerTrainBLL.VerifyTrainOnlineScore(trainId, classId, out IsValid))
            {
                if (IsValid == "Success")
                {
                    Ext.Msg.Alert("消息", "数据导入成功！").Show();
                }
                else if (IsValid == "Error")
                {
                    Ext.Msg.Alert("消息", "数据包含错误！").Show();
                }
                else
                {
                    Ext.Msg.Alert("消息", "数据导入异常！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "导入数据过程发生错误！").Show();
            }

        }

        protected void StoImportList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();

            param.Add("UserId", _context.User.Id);

            DataSet query = _dealerTrainBLL.GetTrainScoreImportByCondition(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            (this.StoImportList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoImportList.DataSource = query;
            this.StoImportList.DataBind();
        }

        [AjaxMethod]
        public void DeleteTrainOnlineScore(string id)
        {
            _dealerTrainBLL.RemoveTrainOnlineScore(id);
        }

        [AjaxMethod]
        public void SaveTrainOnlineScore(string trainScoreId, string dealerCode, string salesName, string isPass)
        {
            TrainScoreImport data = new TrainScoreImport();
            data.TrainScoreId = new Guid(trainScoreId);
            data.DealerCode = dealerCode;
            data.SalesName = salesName;
            data.IsPass = isPass;
            _dealerTrainBLL.ModifyTrainOnlineScore(data);
        }

        protected void BtnDownloadTemplate_Click(object sender, EventArgs e)
        {
            TrainScoreTemplateExport export = new TrainScoreTemplateExport();
            DataTable dt = _dealerTrainBLL.GetSalesByTrainIdForTemplate(this.IptTrainId.Value.ToString()).Tables[0];

            export.Export(dt);
        }

        #endregion

    }
}
