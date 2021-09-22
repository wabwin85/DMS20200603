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

namespace DMS.Website.Pages.WeChat
{
    public partial class AccessPermissions : BasePage
    {
        private IWeChatBaseBLL _WhatBase = new WeChatBaseBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.BuildTree(this.TreePanel1.Root);
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable table = new Hashtable();
            if (!string.IsNullOrEmpty(this.tfPositName.Text))
            {
                table.Add("PositName", this.tfPositName.Text);
            }

            DataSet ds = _WhatBase.GetPosition(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        #region 维护职位

        [AjaxMethod]
        public void ShowPositWindow()
        {
            //Init vlaue within this window control
            InitPositWindow(true);

            //Show Window
            this.PositInputWindow.Show();
        }

        [AjaxMethod]
        public void EditPositItem(string detailId)
        {
            InitPositWindow(false);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadPositWindow(detailId);

                //Set Value
                this.PositId.Text = detailId;

                //Show Window
                this.PositInputWindow.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        private void InitPositWindow(bool canSubmit)
        {
            this.PositId.Clear();
            this.tfTextPositKey.Clear();
            this.tfTextPositName.Clear();
            this.btnPositSubmit.Visible = true;
            if (canSubmit)
            {
                this.tfTextPositKey.ReadOnly = false;
            }
            else
            {
                this.tfTextPositKey.ReadOnly = true;
            }
        }

        private void LoadPositWindow(string detailId)
        {
            DataTable Position = _WhatBase.GetPositionByPositionKey(detailId).Tables[0];

            if (Position.Rows.Count > 0)
            {
                //this.PositId.Text = Position.Rows[0]["PositKey"].ToString();
                this.tfTextPositKey.Text = Position.Rows[0]["PositKey"].ToString();
                this.tfTextPositName.Text = Position.Rows[0]["PositName"].ToString();
            }
        }

        [AjaxMethod]
        public void SubmintPosit()
        {
            string massage = "";
            if (String.IsNullOrEmpty(this.tfTextPositKey.Text))
            {
                massage += "请填写职位ID<br/>";
            }
            if (String.IsNullOrEmpty(this.tfTextPositName.Text))
            {
                massage += "请填写职位名称<br/>";
            }
            try
            {
                if (massage == "")
                {
                    //Create
                    if (string.IsNullOrEmpty(this.PositId.Text))
                    {
                        if (CheckId(this.tfTextPositKey.Text))
                        {
                            Hashtable tb = new Hashtable();
                            tb.Add("PositKey", this.tfTextPositKey.Text);
                            tb.Add("PositName", this.tfTextPositName.Text);
                            _WhatBase.InsertPosition(tb);
                        }
                        else
                        {
                            massage = "此职位ID已存在，请重新输入";
                            throw new Exception(massage);
                        }

                    }
                    //Edit
                    else
                    {
                        Hashtable tb = new Hashtable();
                        tb.Add("PositKey", this.tfTextPositKey.Text);
                        tb.Add("PositName", this.tfTextPositName.Text);
                        _WhatBase.UpdatePosition(tb);
                    }
                    PositInputWindow.Hide();
                    GridPanel1.Reload();
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
        public void DeletePositItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                _WhatBase.DeletePosition(detailId);
            }
        }

        private bool CheckId(string Key)
        {
            DataTable dtPosition = _WhatBase.GetPositionByPositionKey(Key).Tables[0];
            if (dtPosition.Rows.Count > 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        #endregion


        #region 设定权限
        [AjaxMethod]
        public void PermitsPositItem(string detailId ,string detailName)
        {
            InitPermitsPositWindow(false);

            if (!string.IsNullOrEmpty(detailId))
            {
                this.textPermitsPositionId.Value = detailId;
                this.textPermitsPositionName.Text = detailName;
                this.BuildTree(this.TreePanel1.Root);
                
                this.PermitsWindow.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        //构建树控件 
        [AjaxMethod]
        public string RefreshMenu()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildTree(null);
            return nodes.ToJson();
        }

        private Coolite.Ext.Web.TreeNodeCollection BuildTree(Coolite.Ext.Web.TreeNodeCollection nodes)
        {
            if (nodes == null)
            {
                nodes = new Coolite.Ext.Web.TreeNodeCollection();
            }

            Coolite.Ext.Web.TreeNode root = new Coolite.Ext.Web.TreeNode();
            root.Text = "Root";
            nodes.Add(root);

            Hashtable obj = new Hashtable();
            obj.Add("PositKey", this.textPermitsPositionId.Value.ToString());
            DataTable dt = _WhatBase.GetPositionPermits(obj).Tables[0];
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (dt.Rows[i]["MenuLevel"].ToString().Equals("1"))
                    {
                        Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
                        node.NodeID = dt.Rows[i]["MenuKey"].ToString();
                        node.Text = dt.Rows[i]["MenuName"].ToString();
                        node.Expanded = true;
                        root.Expanded = true;
                        root.Nodes.Add(node);
                        for (int a = 0; a < dt.Rows.Count; a++)
                        {
                            if (dt.Rows[a]["MenuLevel"].ToString().Equals("2") && dt.Rows[a]["MenuParentKey"].ToString().Equals(node.NodeID))
                            {
                                Coolite.Ext.Web.TreeNode nodeChild = new Coolite.Ext.Web.TreeNode();
                                nodeChild.NodeID = dt.Rows[a]["MenuKey"].ToString();
                                nodeChild.Text = dt.Rows[a]["MenuName"].ToString();
                                nodeChild.Leaf = true;
                                if (!dt.Rows[a]["PositKey"].ToString().Equals(""))
                                {
                                    nodeChild.Checked = ThreeStateBool.True;
                                }
                                else
                                {
                                    nodeChild.Checked = ThreeStateBool.False;
                                }
                                node.Nodes.Add(nodeChild);
                            }
                        }
                    }
                }
            }
            return nodes;
        }


        [AjaxMethod]
        public void btnSubmitPermitsDate(string ModleId)
        {
            try
            {
                //删除原有权限
                int re = _WhatBase.DeletePositionPermits(this.textPermitsPositionId.Value.ToString());
                Hashtable obj = null;
                //维护当前设置权限
                string[] arrId = ModleId.Split(',');
                for (int i = 0; i < arrId.Length; i++)
                {
                    obj = new Hashtable();
                    obj.Add("PositKey", this.textPermitsPositionId.Value.ToString());
                    obj.Add("MenuKey", arrId[i].ToString());

                    _WhatBase.InsertPositionPermits(obj);
                }
            }
            catch (Exception ex)
            {
                Coolite.Ext.Web.ScriptManager.AjaxSuccess = false;
                Coolite.Ext.Web.ScriptManager.AjaxErrorMessage = ex.Message;
            }
        }

        private void InitPermitsPositWindow(bool canSubmit)
        {
            this.textPermitsPositionName.Clear();
            this.textPermitsPositionId.Clear();
            this.TreePanel1.Items.Clear();

            if (canSubmit)
            {
                this.btnPermitsPositionSubmit.Visible = true;
            }
            else
            {
                this.btnPermitsPositionSubmit.Visible = false;
            }
        }
        #endregion

    }
}
