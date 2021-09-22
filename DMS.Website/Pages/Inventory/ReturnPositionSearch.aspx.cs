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


namespace DMS.Website.Pages.Inventory
{
    public partial class ReturnPositionSearch : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IReturnPositionSearchBLL _businessReport = new ReturnPositionSearchBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_DealerListByFilter(DealerStore, true);
                this.Bind_ProductLine(ProductLineStore);
                if (IsDealer)
                {
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    if (RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.T1.ToString())
                    {
                        this.cbDealer.Disabled = true;
                        this.btninsert.Hidden = true;
                        this.GridPanel1.ColumnModel.SetHidden(6, true);
                    }
                }
            }
        }
        private Hashtable GetQueryListdatil()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.hiddenChineseName.Text))
            {
                param.Add("SAP_Code", this.hiddenChineseName.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenProductLineName.Text))
            {
                param.Add("pid", this.hiddenProductLineName.Text);
            }
            return param;
        }
        //退货明细查询
        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DetailRefershData(e.Start, e.Limit);

        }

        private void DetailRefershData(int start, int limit)
        {
            int totalCount = 0;
            DataTable query = _businessReport.GetObjectid(GetQueryListdatil(), (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar2.PageSize : limit), out totalCount).Tables[0];
            (this.DetailStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.DetailStore.DataSource = query;
            this.DetailStore.DataBind();

        }



        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            RefreshData(e.Start, e.Limit);
        }
        private void RefreshData(int start, int limit)
        {
            int totalCount = 0;
            DataTable query = _businessReport.GetPosition(GetQueryList(), (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount).Tables[0];
            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();
        }

        private Hashtable GetQueryList()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerID", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            return param;
        }

        //导出
        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = _businessReport.ExcleGetPosition(GetQueryList()).Tables[0];

            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }
        //明细查看窗体加载
        [AjaxMethod]
        public void ShowDetails(string SAP_Code, string pid)
        {
            //初始化隐藏控件
            this.hiddenChineseName.Text = string.Empty;
            
            this.hiddenProductLineName.Text = string.Empty;
            //把前台传过来的参数放入隐藏控件中
            this.hiddenChineseName.Text = SAP_Code;
            
            this.hiddenProductLineName.Text = pid;
            this.GridPanel2.Reload();//刷新详细的grid
            this.DetailWindow.Show();

        }
        //明细修改窗体加载
        [AjaxMethod]
        public void Inserttde(string id, string pid, string DRP_DetailAmount, string type)
        {
            this.Dealer.SelectedItem.Value = string.Empty;
            this.Years.Text = string.Empty;
            this.ProductLine.SelectedItem.Value = string.Empty;
            this.Quarter.SelectedItem.Value = string.Empty;//季度
            this.Amount.Text = string.Empty;//额度
            this.txtBody.Text = string.Empty;
            this.hiddenChineseNamedatil.Text = string.Empty;
            this.hiddendatayeardatil.Text = string.Empty;
            this.hiddenProductLineNamedatil.Text = string.Empty;
            this.Dealer.Disabled = false;
            this.ProductLine.Disabled = false;
            this.Years.Disabled = false;
            this.hiddentype.Text = type;
            this.hiddenamount.Text = DRP_DetailAmount;
            this.hiddenChineseNamedatil.Text = id;
            
            this.hiddenProductLineNamedatil.Text = pid;
            if ((!string.IsNullOrEmpty(this.hiddenChineseNamedatil.Text)) &&
                (!string.IsNullOrEmpty(this.hiddenProductLineNamedatil.Text)))
            {
                this.Dealer.Disabled = true;
                this.ProductLine.Disabled = true;
                this.Dealer.SelectedItem.Value = new Guid(this.hiddenChineseNamedatil.Text).ToString();
                this.ProductLine.SelectedItem.Value = new Guid(this.hiddenProductLineNamedatil.Text).ToString();
            }


            this.WindowPromotionType.Show();
        }
        //提交获取插入的数据
        private Hashtable GetQueryListditalede()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.Dealer.SelectedItem.Value))
            {
                param.Add("DealerID", this.Dealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.ProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.ProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.Years.Text))
            {
                param.Add("Years", this.Years.Text);
            }
            if (!string.IsNullOrEmpty(this.Quarter.SelectedItem.Value))
            {
                param.Add("Quarter", this.Quarter.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.Amount.Text))
            {
                param.Add("Quota", this.Amount.Text);
            }
            if (!string.IsNullOrEmpty(this.txtBody.Text))
            {
                param.Add("Desc", this.txtBody.Text);
            }

            string Yeardate = this.Years.Text;
            string SubmitBeginDate = Yeardate + "-04-01";
            string SubmitEndDate = int.Parse(Yeardate) + 1 + "-03-31";
            string ExpBeginDate = Yeardate + "-01-01";
            string ExpEndDate = Yeardate + "-12-31";
            param.Add("SubmitBeginDate", SubmitBeginDate);
            param.Add("SubmitEndDate", SubmitEndDate);
            param.Add("ExpBeginDate", ExpBeginDate);
            param.Add("ExpEndDate", ExpEndDate);
            return param;
        }
        //修改提交(update)、新增提交(insert)
        [AjaxMethod]
        public void sbmited()
        {

            if (this.hiddentype.Text == "update")
            {
                //修改退货额度明细校验             
                if (!string.IsNullOrEmpty(this.Amount.Text))
                {
                    decimal qty;
                    if (!Decimal.TryParse(this.Amount.Text, out qty))
                    {
                        Ext.Msg.Alert("消息", "额度格式不正确").Show();
                        return;
                    }
                }
                else
                {
                    Ext.Msg.Alert("消息", "额度不能为空").Show();
                    return;
                }
                if (string.IsNullOrEmpty(this.Years.Text))
                {

                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "提示",
                        Message = "请填写年份！"
                    });
                    return;
                }
                if (string.IsNullOrEmpty(this.Quarter.SelectedItem.Value))
                {

                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "错误",
                        Message = "季度不能为空!"
                    });
                    return;
                }
                if (decimal.Parse(this.Amount.Text) < 0)
                {
                    if (decimal.Parse(this.Amount.Text) + decimal.Parse(this.hiddenamount.Text) < 0)
                    {
                        Ext.Msg.Alert("消息", "修改额度必须小于当前总额度").Show();
                        return;
                    }
                }
                if (string.IsNullOrEmpty(this.txtBody.Text))
                {
                    Ext.Msg.Alert("消息", "修改额度必须填写备注").Show();
                    return;
                }
                bool result = false;
                try
                {
                    result = _businessReport.insert(GetQueryListditalede());
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
                if (result)
                {
                    Ext.Msg.Alert("消息", "修改成功").Show();
                    this.WindowPromotionType.Hidden = true;
                    this.GridPanel1.Reload();
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
            if (this.hiddentype.Text == "insert")
            {
                
                if (string.IsNullOrEmpty(this.Dealer.SelectedItem.Value))
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "错误",
                        Message = "经销商不能为空!",
                    });
                   
                    return;
                }
                if (string.IsNullOrEmpty(this.ProductLine.SelectedItem.Value))
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "错误",
                        Message = "产品线不能为空!",
                    });
                  
                    return;
                }
                if (string.IsNullOrEmpty(this.Years.Text))
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "错误",
                        Message = "年份不能为空!",
                    });
                   
                    return;
                }
                if (string.IsNullOrEmpty(this.Quarter.SelectedItem.Value))
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "错误",
                        Message = "季度不能为空!",
                    });
                   
                    return;
                }

                if (!string.IsNullOrEmpty(this.Amount.Text))
                {
                    decimal qty;
                    if (!Decimal.TryParse(this.Amount.Text, out qty))
                    {
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.ERROR,
                            Title = "错误",
                            Message = "额度格式不正确!",
                        });

                        return;
                    }           
                }
                else {
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.ERROR,
                            Title = "错误",
                            Message = "额度不允许为空!",
                        });
                    return;
                }
                
                bool result = false;
                try
                {
                    result = _businessReport.insert(GetQueryListditalede());
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
                if (result)
                {
                   
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "成功",
                        Message = "新增成功!",
                    });
                    this.WindowPromotionType.Hidden = true;
                    this.GridPanel1.Reload();
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

            }



        }
        [AjaxMethod]
        public string changedealer(string id)
        {
           string message = "false";
            DataTable dt = _businessReport.baocuo(new Guid(id)).Tables[0];
            if (dt.Rows.Count > 0)
            {            
                if (dt.Rows[0]["DMA_DealerType"].ToString()=="T2")
                {
                    message = "true";
                }
            }
            return message;
        }
    }
}