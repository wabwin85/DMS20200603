using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using DMS.Model;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Common;

namespace DMS.Website
{
    public partial class WeChatComplaint : BasePage
    {
        private IWeChatBaseBLL _WhatBase = new WeChatBaseBLL();
        private IMessageBLL _messageBLL = new MessageBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (this.Request.QueryString["UserId"] != null)
                {
                    this.hfUserId.Value = this.Request.QueryString["UserId"];
                }
            }
        }

        protected void Store_ProductLine(object sender, StoreRefreshDataEventArgs e)
        {
            IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);
            this.ProductLineStore.DataSource = dataSet;
            this.ProductLineStore.DataBind();
        }

        protected void ComplaintTypeStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dt = _WhatBase.GetComplaintType(0,"0").Tables[0];
            this.ComplaintTypeStore.DataSource = dt;
            this.ComplaintTypeStore.DataBind();
        }

        protected void AnswerStateStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id");
            dt.Columns.Add("Value");
            dt.Rows.Add("0", "未回复");
            dt.Rows.Add("1", "已回复");
            this.AnswerStateStore.DataSource = dt;
            this.AnswerStateStore.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = bindResult();
            DataSet ds = _WhatBase.GetComplaintQuery(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        [AjaxMethod]
        public void AnswerItem(string detailId)
        {
            InitAnswerWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadComplaintWindow(new Guid(detailId));

                //Set Value
                this.texthdId.Value = detailId;

                //Show Window
                this.InputWindow.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }

        }

        [AjaxMethod]
        public void Submint()
        {
            try
            {
                if (!this.taTextAnswer.Value.Equals(""))
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("Id", this.texthdId.Value);
                    obj.Add("Answer", this.taTextAnswer.Text);
                    obj.Add("Status", "1");
                    int i= _WhatBase.UpdateComplaint(obj);
                    if (i > 0) 
                    {
                        //发短信通知
                        Hashtable hasget = new Hashtable();
                        hasget.Add("Id", this.texthdId.Value);

                        DataTable dt = _WhatBase.GetComplaintQuery(hasget).Tables[0];
                        if (dt.Rows[0]["UserPhone"] != null && !dt.Rows[0]["UserPhone"].ToString().Equals(""))
                        {
                            ShortMessageQueue message = new ShortMessageQueue();
                            message.Id = Guid.NewGuid();
                            message.QueueNo = "sms";
                            message.To = dt.Rows[0]["UserPhone"].ToString();

                            message.Message = "您在微信中提交的类型为" + dt.Rows[0]["QuestionTitle"].ToString() + "投诉建议已被回复，请进入微信查看详情。";
                            message.Status = "Waiting";
                            message.CreateDate = DateTime.Now;
                            _messageBLL.AddToShortMessageQueue(message);
                        }

                    }
                    InputWindow.Hide();
                    this.GridPanel1.Reload();
                    Ext.Msg.Alert("Success", "回复成功！").Show();
                }
                else
                {
                    Ext.Msg.Alert("Error", "请填写回复内容").Show();
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }

        private Hashtable bindResult()
        {
            Hashtable obj = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbComplaintType.SelectedItem.Value))
            {
                obj.Add("ComplaintType", cbComplaintType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                obj.Add("ProductLineId", cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbAnswerStatus.SelectedItem.Value))
            {
                obj.Add("AnswerStatus", cbAnswerStatus.SelectedItem.Value);
            }
            if (this.hfUserId.Value != null)
            {
                obj.Add("AnswerUserID", this.hfUserId.Value.ToString());
            }

            return obj;
        }

        private void InitAnswerWindow(bool canSubmit)
        {
            this.texthdId.Clear();
            this.textUserName.Text = "";
            this.textDealerName.Text = "";
            this.taTextComplaintType.Value = "";
            this.taProductLine.Value = "";
            this.taTextBody.Clear();
            this.taTextAnswer.Clear();

            if (canSubmit)
            {
                this.btnSubmit.Visible = true;
            }
            else
            {
                this.btnSubmit.Visible = false;
            }
        }

        private void LoadComplaintWindow(Guid detailId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Id", detailId.ToString());
            DataTable dt = _WhatBase.GetComplaintQuery(obj).Tables[0];
            if (dt.Rows.Count > 0)
            {
                this.taTextComplaintType.SelectedItem.Value = dt.Rows[0]["WdtId"].ToString();
                this.taProductLine.SelectedItem.Value = dt.Rows[0]["WupId"].ToString();
                this.taTextBody.Value = dt.Rows[0]["QuestionBody"].ToString();
                this.taTextAnswer.Value = dt.Rows[0]["Answer"].ToString();
                this.textDealerName.Text = dt.Rows[0]["DealerName"].ToString();
                this.textUserName.Text = dt.Rows[0]["UserName"].ToString();
            }
        }
    }
}
