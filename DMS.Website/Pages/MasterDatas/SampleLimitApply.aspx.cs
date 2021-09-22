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

namespace DMS.Website.Pages.MasterDatas
{
    public partial class SampleLimitApply : BasePage
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        SampleApplyBLL Bll = new SampleApplyBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {

                this.Bind_ProductLine(ProductLineStore);

            }
        }
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                table.Add("cbProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.Level4Code.Text))
            {
                table.Add("Level4Code", this.Level4Code.Text);
            }
            int totalCount = 0;
            DataSet ds = Bll.GetSampleLimitApply(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();

        }

        [AjaxMethod]
        public void Inserttde(string id, string productline, string Limit, string CFN_Level4Code, string Type)
        {
         
            this.HidCFN_Level4Code.Value= string.Empty;
            this.hid.Value = id;
            this.SubmitButton.Hidden = false;
            this.UpdateButton.Hidden = false;
            this.ProductLine.Disabled = true;
            this.CFN_Level4Code.Disabled = true;
            this.ProductLine.SelectedItem.Value = string.Empty;
            this.CFN_Level4Code.Value = string.Empty;
            this.LimitAmount.Text = string.Empty;
            if (Type == "update")
            {
                this.ProductLine.SelectedItem.Value = productline;
              
                this.CFN_Level4Code.SelectedItem.Value = CFN_Level4Code;
                this.HidCFN_Level4Code.Value = CFN_Level4Code;
                this.LimitAmount.Text = Limit;
                this.hidLimit.Value = Limit;
                this.SubmitButton.Hidden = true;

            }
            else {
                this.ProductLine.Disabled = false;
                this.CFN_Level4Code.Disabled = false;
                this.UpdateButton.Hidden = true;
            }
            this.WindowPromotionType.Show();
        }

        [AjaxMethod]
        public void ChangeProductLine(string ProductLine)
        {
           DataSet dt= Bll.GetSampleLimitcode(ProductLine);
            if (dt.Tables[0].Rows.Count > 0)
            {
                this.CFN_Level4Codestore.DataSource = dt;
                this.CFN_Level4Codestore.DataBind();
                this.remake.Hidden = true;
            }
            else {

                this.remake.Hidden = false;
            }

        }
        [AjaxMethod]
      
        public void Submit(string id,string productline,string Limit,string CFN_Level4Code, string Type)
        {
            if (Type == "insert")
            {
                bool result = false;
                Hashtable param = new Hashtable();
                if ((!string.IsNullOrEmpty(this.ProductLine.SelectedItem.Value)) && (!string.IsNullOrEmpty(this.CFN_Level4Code.SelectedItem.Value)) && (!string.IsNullOrEmpty(this.LimitAmount.Text)))
                {
                    param.Add("ProductLine", this.ProductLine.SelectedItem.Value);
                    param.Add("CFN_Level4Code", this.CFN_Level4Code.SelectedItem.Value);
                    param.Add("LimitAmount", this.LimitAmount.Text);

                    try
                    {
                        result = Bll.InsertSampleApplyLimit(param);
                    }
                    catch (Exception m)
                    {
                        throw new Exception(m.Message);
                    }
                    if (result)
                    {
                        Hashtable hs = new Hashtable();
                        hs.Add("message", "新增微信商业样品的申请upn，新增申请upn的产品线："+ this.ProductLine.SelectedItem.Text.ToString()+ "，Level4Code:" + this.CFN_Level4Code.SelectedItem.Value.ToString() +"，设置数量："+ this.LimitAmount.Text);
                        hs.Add("UserId", this._context.UserName.ToString());
                        hs.Add("EventId", "更新微信商业样品的申请upn");
                        Bll.InsertUserLog(hs);

                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = "成功",
                            Message = "新增成功!",
                        });
                       
                    }
                    else
                    {
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.ERROR,
                            Title = "错误",
                            Message = "新增失败!",
                        });
                        return;

                    }
                    this.WindowPromotionType.Hidden = true;
                   
                    this.GridDealerInfor.Reload();
                }
                else
                {
                    Ext.Msg.Alert("消息", "请填写完整!").Show();
                    return;
                }


            }
            else {
                bool result = false;
               
                result = Bll.UpdateSampleApplyLimit(this.hid.Value.ToString(),this.LimitAmount.Text);
                if (result)
                {
                    if (result)
                    {
                        Hashtable hs = new Hashtable();
                        hs.Add("message", "修改微信商业样品的申请upn数量，修改upn的产品线："+ this.Hidproductline.Value.ToString() + "，Level4Code：" + this.HidCFN_Level4Code.Value.ToString() + "，数量由"+ this.hidLimit.Value.ToString()+ "修改为" + this.LimitAmount.Text);
                        hs.Add("UserId", this._context.UserName.ToString());
                        hs.Add("EventId", "更新微信商业样品的申请upn");
                        Bll.InsertUserLog(hs);
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = "成功",
                            Message = "修改成功!",
                        });

                    }
                    else
                    {
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.ERROR,
                            Title = "错误",
                            Message = "修改失败!",
                        });
                        return;

                    }


                }

                this.WindowPromotionType.Hidden = true;
                this.GridDealerInfor.Reload();
            }  
        }



    }
}