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
using Coolite.Ext.Web;
using DMS.Business;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Common;
using System.Collections.Generic;

namespace DMS.Website.Pages.DealerTrain
{
    public partial class SignManage : BasePage
    {
        //#region 公用
        //private DealerTrainBLL _dealerTrainBLL = new DealerTrainBLL();
        //IRoleModelContext _context = RoleModelContext.Current;
        //public bool IsPageNew
        //{
        //    get
        //    {
        //        return (this.IptIsNew.Text == "True" ? true : false);
        //    }
        //    set
        //    {
        //        this.IptIsNew.Text = value.ToString();
        //    }
        //}
        //#endregion

        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    if (!IsPostBack && !Ext.IsAjaxRequest)
        //    {
        //        this.Bind_ProductLine(this.StoTrainBu);
        //    }
        //}

        //#region 签约查询

        //protected void StoTrainArea_RefreshData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    IDictionary<string, string> trainArea = DictionaryHelper.GetDictionary(SR.Train_Area);
        //    StoTrainArea.DataSource = trainArea;
        //    StoTrainArea.DataBind();
        //}

        //protected void StoSignList_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    int totalCount = 0;
        //    DataSet query = _dealerTrainBLL.GetDealerSignList(this.QrySignName.Text, this.QryTrainName.Text, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagSignList.PageSize : e.Limit), out totalCount);
        //    (this.StoSignList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
        //    this.StoSignList.DataSource = query;
        //    this.StoSignList.DataBind();
        //}

        //#endregion

        //#region 签约维护

        //protected void StoTrainList_RefreshData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    if (IsPageNew)
        //    {
        //        DataSet query = _dealerTrainBLL.GetTrainListBySignId(null);
        //        this.StoTrainList.DataSource = query;
        //        this.StoTrainList.DataBind();
        //    }
        //    else
        //    {
        //        String signId = e.Parameters["SignId"].ToString();
        //        if (!String.IsNullOrEmpty(signId))
        //        {
        //            DataSet query = _dealerTrainBLL.GetTrainListBySignId(signId);
        //            this.StoTrainList.DataSource = query;
        //            this.StoTrainList.DataBind();
        //        }
        //    }
        //}

        //protected void StoSignSalesList_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    String signId = e.Parameters["SignId"].ToString();
        //    if (!String.IsNullOrEmpty(signId))
        //    {
        //        int totalCount = 0;
        //        DataSet query = _dealerTrainBLL.GetDealerSalesList(signId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagSignSalesList.PageSize : e.Limit), out totalCount);
        //        (this.StoSignSalesList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
        //        this.StoSignSalesList.DataSource = query;
        //        this.StoSignSalesList.DataBind();
        //    }
        //}

        //[AjaxMethod]
        //public void ShowSignInfo(string signId)
        //{
        //    this.IptRtnVal.Clear();
        //    this.IptRtnMsg.Clear();
        //    this.IptIsNew.Clear();

        //    //this.hidSignRelationIdDetail.Clear();
        //    //this.hidSignIdDetail.Clear();

        //    this.IptSignName.Clear();
        //    this.IptSignTrain.SelectedItem.Value = string.Empty;
        //    this.IptSignDesc.Clear();

        //    BindDetailValues(signId);
        //    WdwSignInfo.Show();
        //}

        //private void BindDetailValues(string signId)
        //{
        //    if (signId.Equals("00000000-0000-0000-0000-000000000000"))
        //    {
        //        this.IptIsNew.Value = "True";
        //        this.IptSignId.Value = Guid.NewGuid();
        //        this.IptSignTrain.Enabled = true;

        //        _dealerTrainBLL.AddDealerSignDraft(this.IptSignId.Value.ToString(), _context.User.Id);
        //    }
        //    else
        //    {
        //        this.IptIsNew.Value = "False";
        //        this.IptSignId.Value = signId;
        //        this.IptSignTrain.Enabled = false;
        //        DealerSign sign = _dealerTrainBLL.GetDealerSignInfo(signId);
        //        if (sign != null)
        //        {
        //            this.IptSignName.Value = sign.SignName;
        //            this.IptSignTrain.SelectedItem.Value = sign.TrainId.ToString();
        //            this.IptSignDesc.Value = sign.SignDesc;
        //        }
        //    }
        //}

        //[AjaxMethod]
        //public void DeleteSignDraft(string signId)
        //{
        //    if (IsPageNew)
        //    {
        //        _dealerTrainBLL.RemoveDealerSignDraft(signId);
        //    }
        //}

        //[AjaxMethod]
        //public void SaveSignInfo()
        //{
        //    _dealerTrainBLL.ModifyDealerSign(IsPageNew, this.IptSignId.Value.ToString(), this.IptSignTrainValue.Value.ToString(), this.IptSignName.Text, this.IptSignDesc.Text, _context.User.Id);

        //    this.IptIsNew.Text = "False";
        //}

        //[AjaxMethod]
        //public void CheckSignInfo(string signId)
        //{
        //    this.IptRtnVal.Clear();
        //    this.IptRtnMsg.Clear();

        //    if (_dealerTrainBLL.CheckDelaerSignRecordExists(signId))
        //    {
        //        this.IptRtnMsg.Text = "该签约下面的销售已有成绩存在，是否确认删除？";
        //    }
        //    else
        //    {
        //        this.IptRtnMsg.Text = "是否确认删除该签约？";
        //    }
        //}

        //[AjaxMethod]
        //public void DeleteSignInfo(string signId)
        //{
        //    _dealerTrainBLL.RemoveDealerSign(signId, _context.User.Id);
        //}

        //#endregion

        //#region 签约销售维护

        //protected void StoDealerSalesList_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    String signId = e.Parameters["SignId"].ToString();
        //    if (!String.IsNullOrEmpty(signId))
        //    {
        //        int totalCount = 0;
        //        DataSet query = _dealerTrainBLL.GetRemainDealerSalesList(signId, this.QryDealerName.Text, this.QrySalesName.Text, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagDealerSalesList.PageSize : e.Limit), out totalCount);
        //        (this.StoDealerSalesList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
        //        this.StoDealerSalesList.DataSource = query;
        //        this.StoDealerSalesList.DataBind();
        //    }
        //}

        //[AjaxMethod]
        //public void ShowDealerSales()
        //{
        //    //Init vlaue within this window control
        //    //InitTrainOnlineWindow();

        //    //Show Window
        //    this.WdwDealerSales.Show();
        //}

        //[AjaxMethod]
        //public void SaveDealerSales(string param)
        //{
        //    param = param.Substring(0, param.Length - 1);
        //    _dealerTrainBLL.AddDealerSales(IsPageNew, this.IptSignId.Value.ToString(), param.Split(','), _context.User.Id);
        //    StoDealerSalesList.DataBind();
        //}

        //[AjaxMethod]
        //public void CheckDealerSales(string signRelationId)
        //{
        //    this.IptRtnVal.Clear();
        //    this.IptRtnMsg.Clear();

        //    if (_dealerTrainBLL.CheckDelaerSalesRecordExists(signRelationId))
        //    {
        //        this.IptRtnMsg.Text = "该销售已有成绩存在，是否确认删除？";
        //    }
        //    else
        //    {
        //        this.IptRtnMsg.Text = "是否确认删除该销售？";
        //    }
        //}

        //[AjaxMethod]
        //public void DeleteDealerSales(string signRelationId, String signId, String salesId)
        //{
        //    this.IptRtnVal.Clear();
        //    this.IptRtnMsg.Clear();

        //    _dealerTrainBLL.RemoveDealerSales(signRelationId, signId, salesId, _context.User.Id);
        //}

        //#endregion
    }
}
