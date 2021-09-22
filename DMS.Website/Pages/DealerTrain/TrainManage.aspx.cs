using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections.Generic;
using DMS.Common;
using DMS.Model;
using DMS.Business.DealerTrain;

namespace DMS.Website.Pages.DealerTrain
{
    public partial class TrainManage : BasePage
    {
        #region 公用

        public bool IsPageNew
        {
            get
            {
                return (this.IptIsNew.Text == "True" ? true : false);
            }
            set
            {
                this.IptIsNew.Text = value.ToString();
            }
        }
        IRoleModelContext _context = RoleModelContext.Current;

        private CommandoUserBLL _commandoUserBLL = new CommandoUserBLL();
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

        protected void StoTrainAreaAll_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> trainArea = DictionaryHelper.GetDictionary(SR.Train_Area);
            StoTrainAreaAll.DataSource = trainArea;
            StoTrainAreaAll.DataBind();
        }

        protected void StoTrainArea_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable trainArea = _dealerTrainBLL.GetProductLineAreaList(this.IptTrainBu.SelectedItem.Value);
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
            DataTable query = _dealerTrainBLL.GetDealerTrainDetailList(Tdetail, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagTrainOnlineList.PageSize : e.Limit), out totalCount).Tables[0];
            (this.StoTrainOnlineList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoTrainOnlineList.DataSource = query;
            this.StoTrainOnlineList.DataBind();
        }

        protected void StoTrainClassList_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable Tdetail = new Hashtable();
            Tdetail.Add("TrainId", this.IptTrainId.Value.ToString());
            Tdetail.Add("TrainType", CommandoTrainType.Class.ToString());
            DataTable query = _dealerTrainBLL.GetDealerTrainDetailList(Tdetail, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagTrainClassList.PageSize : e.Limit), out totalCount).Tables[0];
            (this.StoTrainClassList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoTrainClassList.DataSource = query;
            this.StoTrainClassList.DataBind();
        }

        protected void StoTrainManagerList_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataTable query = _dealerTrainBLL.GetTrainManagerList(this.IptTrainId.Value.ToString(), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagTrainManagerList.PageSize : e.Limit), out totalCount).Tables[0];
            (this.StoTrainManagerList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoTrainManagerList.DataSource = query;
            this.StoTrainManagerList.DataBind();
        }

        protected void StoSalesList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataTable query = _dealerTrainBLL.GetTrainSalesList(this.IptTrainId.Value.ToString(), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagSalesList.PageSize : e.Limit), out totalCount).Tables[0];
            (this.StoSalesList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoSalesList.DataSource = query;
            this.StoSalesList.DataBind();
        }

        [AjaxMethod]
        public void ShowTrainInfo(string trainId)
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();
            this.IptIsNew.Clear();
            this.IptTrainId.Clear();
            this.IptTrainArea.SelectedItem.Value = string.Empty;
            this.IptTrainBu.SelectedItem.Value = string.Empty;
            this.IptTrainStartTime.Clear();
            this.IptTrainDesc.Clear();
            this.IptTrainName.Clear();
            this.IptTrainEndTime.Clear();
            this.IptTrainPracticeCount.Clear();
            this.IptTrainPracticeId.Clear();
            this.IptAreaValue.Clear();

            this.TabPanel1.SetActiveTab(0);

            BindTrainInfo(trainId);
        }

        public void BindTrainInfo(string trainId)
        {
            this.IptIsNew.Value = trainId == "00000000-0000-0000-0000-000000000000" ? "True" : "False";

            if (IsPageNew)
            {
                this.IptTrainId.Value = Guid.NewGuid();
                this.IptTrainBu.SelectedItem.Value = "";
                this.IptTrainArea.SelectedItem.Value = "";

                DataTable trainArea = _dealerTrainBLL.GetProductLineAreaList(this.IptTrainBu.SelectedItem.Value);
                StoTrainArea.DataSource = trainArea;
                StoTrainArea.DataBind();

                TrainMaster trainMaster = new TrainMaster();
                trainMaster.TrainId = new Guid(this.IptTrainId.Value.ToString());
                trainMaster.TrainStatus = CommandoTrainStatus.Draft.ToString();
                trainMaster.CreateTime = DateTime.Now;
                trainMaster.CreateUser = new Guid(_context.User.Id);
                trainMaster.UpdateTime = DateTime.Now;
                trainMaster.UpdateUser = new Guid(_context.User.Id);

                _dealerTrainBLL.AddTrainMaster(trainMaster);
            }
            else
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
                    this.IptAreaValue.Value = trainInfo.TrainArea;

                    TrainDetail Tdetail = new TrainDetail();
                    Tdetail.TrainId = new Guid(trainId);
                    Tdetail.TrainType = CommandoTrainType.Practice.ToString();
                    IList<TrainDetail> dtPractice = _dealerTrainBLL.GetTrainDetailListByCondition(Tdetail);
                    if (dtPractice.Count > 0)
                    {
                        this.IptTrainPracticeCount.Text = dtPractice[0].TrainContent1;
                        this.IptTrainPracticeId.Value = dtPractice[0].TrainDetailId;
                    }
                }
            }
        }

        [AjaxMethod]
        public void CheckTrainInfo(string trainId)
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();

            if (_dealerTrainBLL.CheckTrainSignExists(trainId))
            {
                this.IptRtnMsg.Text = "该课程已有销售签约，是否确认删除？";
            }
            else
            {
                this.IptRtnMsg.Text = "是否确认删除该课程？";
            }
        }

        [AjaxMethod]
        public void SaveTrainInfo(String isSendRemind)
        {
            TrainMaster trainMaster = new TrainMaster();
            trainMaster.TrainId = new Guid(this.IptTrainId.Value.ToString());
            trainMaster.TrainName = this.IptTrainName.Text;
            trainMaster.TrainDesc = this.IptTrainDesc.Text;
            trainMaster.TrainBu = new Guid(this.IptTrainBu.SelectedItem.Value);
            trainMaster.TrainStartTime = this.IptTrainStartTime.SelectedDate;
            trainMaster.TrainEndTime = this.IptTrainEndTime.SelectedDate;
            trainMaster.TrainArea = this.IptTrainArea.SelectedItem.Value;
            trainMaster.TrainStatus = CommandoTrainStatus.Active.ToString();

            trainMaster.UpdateTime = DateTime.Now;
            trainMaster.UpdateUser = new Guid(_context.User.Id);

            _dealerTrainBLL.ModifyTrainMaster(trainMaster);

            TrainDetail trainPractice = new TrainDetail();
            trainPractice.TrainId = new Guid(this.IptTrainId.Value.ToString());
            trainPractice.TrainType = CommandoTrainType.Practice.ToString();
            trainPractice.TrainContent1 = this.IptTrainPracticeCount.Text == "" ? "0" : this.IptTrainPracticeCount.Text;

            trainPractice.UpdateTime = DateTime.Now;
            trainPractice.UpdateUser = new Guid(_context.User.Id);

            if (IptTrainPracticeId.Value != null && !IptTrainPracticeId.Value.ToString().Equals(""))
            {
                trainPractice.TrainDetailId = new Guid(IptTrainPracticeId.Value.ToString());
                _dealerTrainBLL.ModifyTrainDetail(trainPractice);

                if (isSendRemind == "True")
                {
                    DataTable salesList = _dealerTrainBLL.GetTrainSalesList(this.IptTrainId.Value.ToString()).Tables[0];

                    foreach (DataRow r in salesList.Rows)
                    {
                        _dealerTrainBLL.SendTrainChangeMail(r["SalesEmail"].ToString(), this.IptTrainName.Text);
                        _dealerTrainBLL.SendTrainChangeMessage(r["SalesPhone"].ToString(), this.IptTrainName.Text);
                    }
                }
            }
            else
            {
                trainPractice.TrainDetailId = Guid.NewGuid();
                trainPractice.CreateTime = DateTime.Now;
                trainPractice.CreateUser = new Guid(_context.User.Id);
                _dealerTrainBLL.AddTrainDetail(trainPractice);
            }
            this.IptIsNew.Text = "False";
        }

        [AjaxMethod]
        public void DeleteTrainInfo(string trainId)
        {
            TrainMaster t = new TrainMaster();
            t.TrainId = new Guid(trainId);
            t.TrainStatus = CommandoTrainStatus.Delete.ToString();
            t.UpdateTime = DateTime.Now;
            t.UpdateUser = new Guid(_context.User.Id);

            _dealerTrainBLL.ModifyTrainMasterStatus(t);
        }

        [AjaxMethod]
        public void DeleteTrainDraft(string trainId)
        {
            if (IsPageNew)
            {
                TrainDetail trainDetail = new TrainDetail();
                trainDetail.TrainId = new Guid(trainId);

                _dealerTrainBLL.RemoveTrainDetail(trainDetail);
                _dealerTrainBLL.RemoveTrainMasterById(new Guid(trainId));
            }
        }

        #endregion

        #region 在线学习维护

        protected void StoTrainOnlineType_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> trainOnlineType = DictionaryHelper.GetDictionary(SR.Train_OnlineType);
            StoTrainOnlineType.DataSource = trainOnlineType;
            StoTrainOnlineType.DataBind();
        }

        [AjaxMethod]
        public void ShowTrainOnlineSelfInfo(String trainDetailId)
        {
            this.IptTrainOnlineSelfName.Clear();
            this.IptTrainOnlineSelfContent.Clear();
            this.IptTrainOnlineId.Clear(); //Id

            //Show Window
            if (!string.IsNullOrEmpty(trainDetailId))
            {
                this.IptTrainOnlineId.Text = trainDetailId;

                TrainDetail online = _dealerTrainBLL.GetTrainDetailById(new Guid(trainDetailId));

                this.IptTrainOnlineSelfName.Text = online.TrainContent2;
                this.IptTrainOnlineSelfContent.Text = online.TrainContent3;
            }
            this.WdwTrainOnlineSelfInfo.Show();
        }

        [AjaxMethod]
        public void ShowTrainOnlineExamInfo(String trainDetailId)
        {
            this.IptTrainOnlineExamName.Clear();
            this.IptTrainOnlineExamContent.Clear();
            this.IptTrainOnlineExamEndTime.Clear();
            this.IptTrainOnlineId.Clear(); //Id

            //Show Window
            if (!string.IsNullOrEmpty(trainDetailId))
            {
                this.IptTrainOnlineId.Text = trainDetailId;

                TrainDetail online = _dealerTrainBLL.GetTrainDetailById(new Guid(trainDetailId));

                this.IptTrainOnlineExamName.Text = online.TrainContent2;
                this.IptTrainOnlineExamContent.Text = online.TrainContent3;
                this.IptTrainOnlineExamEndTime.SelectedDate = Convert.ToDateTime(online.TrainContent4);
            }
            this.WdwTrainOnlineExamInfo.Show();
        }

        [AjaxMethod]
        public void SaveTrainOnlineSelf(String isSendRemind)
        {
            string massage = "";
            try
            {
                TrainDetail trainDetail = new TrainDetail();
                if (string.IsNullOrEmpty(this.IptTrainOnlineId.Text))
                {
                    trainDetail.TrainDetailId = Guid.NewGuid();
                    trainDetail.TrainId = new Guid(this.IptTrainId.Value.ToString());

                    trainDetail.TrainType = CommandoTrainType.Online.ToString();
                    trainDetail.TrainContent1 = "Self";
                    trainDetail.TrainContent2 = this.IptTrainOnlineSelfName.Text;
                    trainDetail.TrainContent3 = this.IptTrainOnlineSelfContent.Text;

                    trainDetail.UpdateUser = new Guid(_context.User.Id);
                    trainDetail.UpdateTime = DateTime.Now;
                    trainDetail.CreateUser = new Guid(_context.User.Id);
                    trainDetail.CreateTime = DateTime.Now;

                    _dealerTrainBLL.AddTrainDetail(trainDetail);
                }
                else
                {
                    trainDetail.TrainDetailId = new Guid(this.IptTrainOnlineId.Text);
                    trainDetail.TrainId = new Guid(this.IptTrainId.Value.ToString());

                    trainDetail.TrainType = CommandoTrainType.Online.ToString();
                    trainDetail.TrainContent1 = "Self";
                    trainDetail.TrainContent2 = this.IptTrainOnlineSelfName.Text;
                    trainDetail.TrainContent3 = this.IptTrainOnlineSelfContent.Text;
                    trainDetail.UpdateUser = new Guid(_context.User.Id);
                    trainDetail.UpdateTime = DateTime.Now;
                    _dealerTrainBLL.ModifyTrainDetail(trainDetail);
                }

                //发送提醒
                if (isSendRemind == "True")
                {
                    DataTable salesList = _dealerTrainBLL.GetTrainSalesList(this.IptTrainId.Value.ToString()).Tables[0];

                    foreach (DataRow r in salesList.Rows)
                    {
                        _dealerTrainBLL.SendOnlineSelfChangeMail(r["SalesEmail"].ToString(), this.IptTrainOnlineSelfName.Text);
                        _dealerTrainBLL.SendOnlineSelfChangeMessage(r["SalesPhone"].ToString(), this.IptTrainOnlineSelfName.Text);
                    }
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }
        }

        [AjaxMethod]
        public void SaveTrainOnlineExam(String isSendRemind)
        {
            string massage = "";
            try
            {
                TrainDetail trainDetail = new TrainDetail();
                if (string.IsNullOrEmpty(this.IptTrainOnlineId.Text))
                {
                    trainDetail.TrainDetailId = Guid.NewGuid();
                    trainDetail.TrainId = new Guid(this.IptTrainId.Value.ToString());

                    trainDetail.TrainType = CommandoTrainType.Online.ToString();
                    trainDetail.TrainContent1 = "Exam";
                    trainDetail.TrainContent2 = this.IptTrainOnlineExamName.Text;
                    trainDetail.TrainContent3 = this.IptTrainOnlineExamContent.Text;
                    trainDetail.TrainContent4 = this.IptTrainOnlineExamEndTime.SelectedDate.ToString("yyyy-MM-dd");

                    trainDetail.UpdateUser = new Guid(_context.User.Id);
                    trainDetail.UpdateTime = DateTime.Now;
                    trainDetail.CreateUser = new Guid(_context.User.Id);
                    trainDetail.CreateTime = DateTime.Now;

                    _dealerTrainBLL.AddTrainDetail(trainDetail);
                }
                else
                {
                    trainDetail.TrainDetailId = new Guid(this.IptTrainOnlineId.Text);
                    trainDetail.TrainId = new Guid(this.IptTrainId.Value.ToString());

                    trainDetail.TrainType = CommandoTrainType.Online.ToString();
                    trainDetail.TrainContent1 = "Exam";
                    trainDetail.TrainContent2 = this.IptTrainOnlineExamName.Text;
                    trainDetail.TrainContent3 = this.IptTrainOnlineExamContent.Text;
                    trainDetail.TrainContent4 = this.IptTrainOnlineExamEndTime.SelectedDate.ToString("yyyy-MM-dd");
                    trainDetail.UpdateUser = new Guid(_context.User.Id);
                    trainDetail.UpdateTime = DateTime.Now;
                    _dealerTrainBLL.ModifyTrainDetail(trainDetail);
                }

                //发送提醒
                if (isSendRemind == "True")
                {
                    DataTable salesList = _dealerTrainBLL.GetTrainSalesList(this.IptTrainId.Value.ToString()).Tables[0];

                    foreach (DataRow r in salesList.Rows)
                    {
                        _dealerTrainBLL.SendOnlineExamChangeMail(r["SalesEmail"].ToString(), this.IptTrainOnlineExamName.Text);
                        _dealerTrainBLL.SendOnlineExamChangeMessage(r["SalesPhone"].ToString(), this.IptTrainOnlineExamName.Text);
                    }
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }
        }

        [AjaxMethod]
        public void RemoveTrainOnline(string trainDetailId)
        {
            if (!string.IsNullOrEmpty(trainDetailId))
            {
                _dealerTrainBLL.RemoveTrainDetailById(new Guid(trainDetailId));
                RstTrainOnlineList.Reload();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        #endregion

        #region 面授培训

        protected void StoLecturerList_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet query = _commandoUserBLL.GetBscUserAllList("", "Lecturer");

            StoLecturerList.DataSource = query;
            StoLecturerList.DataBind();
        }

        [AjaxMethod]
        public void ShowTrainClassInfo(String trainDetailId)
        {
            this.IptTrainClassName.Clear();
            this.IptTrainClassDesc.Clear();
            this.IptTrainClassLecturer.SelectedItem.Value = "";
            this.IptTrainClassId.Clear();

            //Show Window
            if (!string.IsNullOrEmpty(trainDetailId))
            {
                this.IptTrainClassId.Text = trainDetailId;

                TrainDetail trainClass = _dealerTrainBLL.GetTrainDetailById(new Guid(trainDetailId));

                this.IptTrainClassName.Text = trainClass.TrainContent1;
                this.IptTrainClassDesc.Text = trainClass.TrainContent2;
                this.IptTrainClassLecturer.SelectedItem.Value = trainClass.TrainContent3;
            }
            this.WdwTrainClassInfo.Show();
        }

        [AjaxMethod]
        public void SaveTrainClass(String isSendRemind)
        {
            string massage = "";
            try
            {
                if (massage == "")
                {
                    TrainDetail trainDetail = new TrainDetail();

                    if (string.IsNullOrEmpty(this.IptTrainClassId.Text))
                    {
                        trainDetail.TrainDetailId = Guid.NewGuid();
                        trainDetail.TrainId = new Guid(this.IptTrainId.Value.ToString());

                        trainDetail.TrainType = CommandoTrainType.Class.ToString();
                        trainDetail.TrainContent1 = this.IptTrainClassName.Text;
                        trainDetail.TrainContent2 = this.IptTrainClassDesc.Text;
                        trainDetail.TrainContent3 = this.IptTrainClassLecturer.SelectedItem.Value;

                        trainDetail.UpdateUser = new Guid(_context.User.Id);
                        trainDetail.UpdateTime = DateTime.Now;
                        trainDetail.CreateUser = new Guid(_context.User.Id);
                        trainDetail.CreateTime = DateTime.Now;

                        _dealerTrainBLL.AddTrainDetail(trainDetail);
                    }
                    else
                    {
                        trainDetail.TrainDetailId = new Guid(this.IptTrainClassId.Text);
                        trainDetail.TrainId = new Guid(this.IptTrainId.Value.ToString());

                        trainDetail.TrainType = CommandoTrainType.Class.ToString();
                        trainDetail.TrainContent1 = this.IptTrainClassName.Text;
                        trainDetail.TrainContent2 = this.IptTrainClassDesc.Text;
                        trainDetail.TrainContent3 = this.IptTrainClassLecturer.SelectedItem.Value;
                        trainDetail.UpdateUser = new Guid(_context.User.Id);
                        trainDetail.UpdateTime = DateTime.Now;
                        _dealerTrainBLL.ModifyTrainDetail(trainDetail);
                    }
                }
                else
                {
                    throw new Exception(massage);
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }
        }

        [AjaxMethod]
        public void RemoveTrainClass(string trainDetailId)
        {
            if (!string.IsNullOrEmpty(trainDetailId))
            {
                _dealerTrainBLL.RemoveTrainDetailById(new Guid(trainDetailId));
                RstTrainClassList.Reload();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }
        #endregion

        #region 培训经理

        protected void StoManagerList_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable condition = new Hashtable();
            condition.Add("TrainId", this.IptTrainId.Value.ToString());
            condition.Add("ManagerName", this.QryManagerName.Value.ToString());
            DataTable query = _dealerTrainBLL.GetRemainManagerList(condition, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagManagerList.PageSize : e.Limit), out totalCount).Tables[0];
            (this.StoManagerList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoManagerList.DataSource = query;
            this.StoManagerList.DataBind();
        }

        [AjaxMethod]
        public void SaveManager(string param)
        {
            param = param.Substring(0, param.Length - 1);
            _dealerTrainBLL.AddTrainManager(this.IptTrainId.Value.ToString(), param.Split(','), _context.User.Id);
            StoManagerList.DataBind();
        }

        [AjaxMethod]
        public void RemoveManager(string trainId, string managerId)
        {
            if (!string.IsNullOrEmpty(trainId) && !string.IsNullOrEmpty(managerId))
            {
                TrainManager trainManager = new TrainManager();
                trainManager.TrainId = new Guid(trainId);
                trainManager.ManagerId = new Guid(managerId);
                _dealerTrainBLL.RemoveManager(trainManager);
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        #endregion

        #region 销售

        protected void StoDealerSalesList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable condition = new Hashtable();
            condition.Add("TrainId", this.IptTrainId.Value.ToString());
            condition.Add("DealerName", this.QryDealerName.Value.ToString());
            condition.Add("SalesName", this.QrySalesName.Value.ToString());
            DataTable query = _dealerTrainBLL.GetRemainDealerSalesList(condition, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagManagerList.PageSize : e.Limit), out totalCount).Tables[0];
            (this.StoDealerSalesList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoDealerSalesList.DataSource = query;
            this.StoDealerSalesList.DataBind();
        }

        [AjaxMethod]
        public void SaveDealerSales(string param)
        {
            param = param.Substring(0, param.Length - 1);
            _dealerTrainBLL.AddDealerSales(this.IptTrainId.Value.ToString(), param.Split(','), _context.User.Id);
            StoDealerSalesList.DataBind();
        }

        [AjaxMethod]
        public void CheckDealerSales(string salesTrainId)
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();

            if (_dealerTrainBLL.CheckDelaerSalesRecordExists(salesTrainId))
            {
                this.IptRtnMsg.Text = "该销售已有成绩存在，是否确认删除？";
            }
            else
            {
                this.IptRtnMsg.Text = "是否确认删除该销售？";
            }
        }

        [AjaxMethod]
        public void DeleteDealerSales(string salesTrainId)
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();

            _dealerTrainBLL.RemoveDealerSales(salesTrainId, _context.User.Id);
        }

        #endregion
    }
}
