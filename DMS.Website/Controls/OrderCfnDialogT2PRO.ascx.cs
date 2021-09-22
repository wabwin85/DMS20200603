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

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "OrderCfnDialogT2PRO")]
    public partial class OrderCfnDialogT2PRO : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void ProProductTypeStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            ICfns business = new Cfns();

            Hashtable obj = new Hashtable();
            obj.Add("DealerId", this.hidDealerId.Text);
            obj.Add("ProductLineId", this.hidProductLine.Text);
            obj.Add("GivenType", "FreeGoods");

            DataSet ds = business.QueryPromotionProductLineType(obj);
            this.ProProductTypeStore.DataSource = ds;
            this.ProProductTypeStore.DataBind();
            if(ds.Tables[0].Rows.Count>0)
            {
                txtLeftNum.Text = ds.Tables[0].Rows[0]["LeftNum"].ToString();
            }
        }
        protected void CurrentCfnStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //经销商下订单的时候可以看到所有的产品，但是只能选择授权范围内，且产品表中可下订的产品

            string[] strCriteria;
            int iCriteriaNbr;
            ICfns business = new Cfns();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            //参数：产品线
            if (!string.IsNullOrEmpty(this.hidProductLine.Text))
            {
                param.Add("ProductLineId", this.hidProductLine.Text);
            }

            //参数：CFN（UPN）
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtCFN.Text);
                foreach (string strCFN in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strCFN))
                    {
                        iCriteriaNbr++;
                        //如果strCFN是以+开头的，代表是HIBC码，则去掉第一位和最后一位
                        if (strCFN.Substring(0, 1) == "+" && strCFN.Length > 2)
                        {
                            param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN.Substring(1, strCFN.Length - 2));
                        }
                        else
                        {
                            param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                        }
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
            }

            //参数：经销商ID
            if (!string.IsNullOrEmpty(this.hidDealerId.Text))
            {
                param.Add("DealerId", new Guid(this.hidDealerId.Text));
            }

            //参数（新增）：产品名称
            if (!string.IsNullOrEmpty(this.txtCFNName.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtCFNName.Text);
                foreach (string strCFNName in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strCFNName))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("ProductCFNName{0}", iCriteriaNbr), strCFNName);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductCFNName", "HasCFNNameCriteria");
            }


            //参数（新增）：是否只显示可订产品
            if (chkDisplayCanOrder.Checked)
            {
                param.Add("DisplayCanOrder", 1);
            }
            else
            {
                param.Add("DisplayCanOrder", 0);
            }

            //参数(新增)：价格类型，根据订单类型
            if (!string.IsNullOrEmpty(this.hidPriceTypeId.Text))
            {
                param.Add("PriceType", this.hidPriceTypeId.Text);
            }
            //if (this.hidOrderType.Text == "Normal")
            //{
            //    param.Add("OrderType", "Normal");
            //}
            //参数：赠品分类ID
            param.Add("DLid", this.cbProProductType.SelectedItem.Value);
            DataSet ds = null;

            //已不使用
            if (this.chkShare.Checked)
            {
                ds = business.QueryCfnForPurchaseOrderByShare(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }
            else
            {
                ds = business.QueryCfnForPurchaseOrderT2ByPRO(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }
            e.TotalCount = totalCount;

            this.CurrentCfnStore.DataSource = ds;
            this.CurrentCfnStore.DataBind();

        }

        [AjaxMethod]
        public void Show(string hid, string pid, string did, string ptid)
        {
            this.hidHeaderId.Text = hid;
            this.hidProductLine.Text = pid;
            this.hidDealerId.Text = did;
            string[] str = ptid.Split('@');
            this.hidPriceTypeId.Text = str[0];
            this.ProProductTypeStore.DataBind();



            this.CfnWindow.Show();
        }

        [AjaxMethod]
        public void DoAddItems(string param, string checkparam)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            (new PurchaseOrderBLL()).AddSpecialCfnPromotion(new Guid(this.hidHeaderId.Text), new Guid(this.hidDealerId.Text), param.Substring(0, param.Length - 1), checkparam.Substring(0, checkparam.Length - 1), this.hidSpecialPriceId.Text, this.hidOrderTypeId.Text, out rtnVal, out rtnMsg);
        }
    }
}