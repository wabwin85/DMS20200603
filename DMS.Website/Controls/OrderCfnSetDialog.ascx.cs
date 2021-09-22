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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "OrderCfnSetDialog")]
    public partial class OrderCfnSetDialog : BaseUserControl
    {
        private ICfnSetBLL business = new CfnSetBLL();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void CfnSetStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //如果订单类型是成套设备订单，则可以选择成套产品
            if (!string.IsNullOrEmpty(this.hidOrderTypeId.Text) && (this.hidOrderTypeId.Text.Equals(PurchaseOrderType.BOM.ToString())))
            {
                int totalCount = 0;

                Hashtable param = new Hashtable();

                if (!string.IsNullOrEmpty(this.hidDealerId.Text))
                {
                    param.Add("DealerId", new Guid(this.hidDealerId.Text));
                }
                if (!string.IsNullOrEmpty(this.hidProductLine.Text))
                {
                    param.Add("ProductLineId", this.hidProductLine.Text);
                }
                //参数(新增)：价格类型，根据订单类型
                if (!string.IsNullOrEmpty(this.hidPriceTypeId.Text))
                {
                    param.Add("PriceType", this.hidPriceTypeId.Text);
                }
                if (!string.IsNullOrEmpty(this.txtProtectName.Text))
                {
                    param.Add("ProtectName", this.txtProtectName.Text);
                }

                if (!string.IsNullOrEmpty(this.txtUpn.Text))
                {
                    param.Add("ProtectCode", this.txtUpn.Text);

                }
           
                DataSet ds = business.QueryCfnSetForPurchaseOrderByAuth(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

                e.TotalCount = totalCount;

                this.CfnSetStore.DataSource = ds;
                this.CfnSetStore.DataBind();
            }

        }

        protected void CfnSetDetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string id = e.Parameters["CfnSetId"];

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.hidDealerId.Text))
            {
                param.Add("DealerId", new Guid(this.hidDealerId.Text));
            }
            if (!string.IsNullOrEmpty(this.hidProductLine.Text))
            {
                param.Add("ProductLineId", this.hidProductLine.Text);
            }
            if (!string.IsNullOrEmpty(id))
            {
                param.Add("CfnSetId", id);
            }
            //参数(新增)：价格类型，根据订单类型
            if (!string.IsNullOrEmpty(this.hidPriceTypeId.Text))
            {
                param.Add("PriceType", this.hidPriceTypeId.Text);
            }
            DataSet ds = business.QueryCFNSetDetailForPurchaseOrderByAuth(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.CfnSetDetailStore.DataSource = ds;
            this.CfnSetDetailStore.DataBind();
        }

        [AjaxMethod]
        public void Show(string hid, string pid, string did, string ptid, string otype)
        {
            this.txtUpn.Clear();
            this.txtProtectName.Clear();
            this.hidHeaderId.Text = hid;
            this.hidProductLine.Text = pid;
            this.hidDealerId.Text = did;
            this.hidPriceTypeId.Text = ptid;
            this.hidOrderTypeId.Text = otype;
            this.CfnSetWindow.Show();
        }

        [AjaxMethod]
        public void DoAddCfnSet(string param)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            (new PurchaseOrderBLL()).AddBSCCfnSet(new Guid(this.hidHeaderId.Text), new Guid(this.hidDealerId.Text), param.Substring(0, param.Length - 1), this.hidPriceTypeId.Text, out rtnVal, out rtnMsg);

            this.hidRtnVal.Text = rtnVal;
            this.hidRtnMsg.Text = rtnMsg.Replace("$$", "<BR/>");

        }
    }
}