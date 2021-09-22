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
using DMS.Common.Common;

namespace DMS.Website.Pages.Promotion
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "GiftMaintainList")]
    public partial class GiftMaintainList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IGiftMaintainBLL _business = new GiftMaintainBLL();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_ProductLine(this.ProductLineStore);
            }
        }

        protected void PeriodStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> proPeriod = DictionaryHelper.GetDictionary(SR.PRO_Period);
            PeriodStore.DataSource = proPeriod;
            PeriodStore.DataBind();
        }

        protected void CalPeriodStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dtCalPeriod = _business.GetApprovalCalPeriodByPeriod(this.hidPeriod.Value.ToString()).Tables[0];
            CalPeriodStore.DataSource = dtCalPeriod;
            CalPeriodStore.DataBind();
        }

        protected void wdCalPeriodStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dtCalPeriod = _business.GetPolicyCalPeriodByPeriod(this.hidWdPeriod.Value.ToString()).Tables[0];
            wdCalPeriodStore.DataSource = dtCalPeriod;
            wdCalPeriodStore.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("Bu", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbCalPeriod.SelectedItem.Value))
            {
                param.Add("AccountMonth", this.cbCalPeriod.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbPeriod.SelectedItem.Value))
            {
                param.Add("Period", this.cbPeriod.SelectedItem.Value);
            }
            //if (!string.IsNullOrEmpty(this.txtApprovalCode.Text))
            //{
            //    param.Add("FlowId", this.txtApprovalCode.Text);
            //}
            DataTable query = _business.QueryGiftApprovalList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();
        }

        #region 页面事件
        protected void ExportDetail(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("BUName", GetBUName(cbWdProductLine.SelectedItem.Value));
            obj.Add("Period", cbWdPeriod.SelectedItem.Value);
            obj.Add("CalPeriod", cbWdCalPeriod.SelectedItem.Value);

            DataSet queryDs = new DataSet();
            if (cbType.SelectedItem.Value == "赠品")
            {
                obj.Add("PresentType", "实物产品");
                queryDs = _business.GetGiftResult(obj);
            }
            else
            {
                obj.Add("PresentType", "积分金额");
                queryDs = _business.GetPointResult(obj);
            }

            DataTable dtMain = queryDs.Tables[0].Copy();
            DataTable dtDetail = queryDs.Tables[1].Copy();

            DataSet ds = new DataSet("促销赠品确认");

            #region 构造日志信息Table

            DataTable dtData = dtMain;
            DataTable dtDataDetail = dtDetail;
            dtData.TableName = "MainDate";
            dtDataDetail.TableName = "DetailDate";
            if (null != dtData)
            {
                #region 调整列的顺序,并重命名列名（主信息）
                if (cbType.SelectedItem.Value == "赠品")
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"BU", "BU"},
                            {"AccountMonth", "账期"},
                            {"LPSAPCode", "经销商ERP Code"},
                            {"LPName", "经销商名称"},
                            {"LargessDesc", "产品区间"},
                            {"Amount", "赠送值"}
                        };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);
                }
                else
                {

                    Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"BU", "BU"},
                            {"AccountMonth", "账期"},
                            {"LPSAPCode", "经销商ERP Code"},
                            {"LPName", "经销商名称"},
                            {"LargessDesc", "产品区间"},
                            {"Amount", "赠送值"},
                            {"PointType", "积分类型"},
                            {"PointValidDate", "积分有效期"}
                        };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);
                }

                #endregion 调整列的顺序,并重命名列名

                ds.Tables.Add(dtData);
            }

            if (null != dtDataDetail)
            {
                #region 调整列的顺序,并重命名列名（明细信息）
                if (cbType.SelectedItem.Value == "赠品")
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"BU", "BU"},
                            {"AccountMonth", "账期"},
                            {"PolicyNo", "政策编号"},
                            {"PolicyName", "政策名称"},
                            {"LargessDesc", "产品区间"},
                            {"LPSAPCode", "平台ERP Code"},
                            {"LPName", "平台名称"},
                            {"DealerSAPCode", "经销商ERP Code"},
                            {"DealerName", "经销商名称"},
                            {"HospitalId", "医院Code"},
                            {"HospitalName", "医院名称"},
                            {"Amount", "赠送值"},
                            {"AdjustAmount", "调整值"},
                            {"LeftAmount", "剩余值"},
                            {"AdjustLeftAmount", "调整剩余值"}
                        };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtDataDetail, dict);
                }
                else
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"BU", "BU"},
                            {"AccountMonth", "账期"},
                            {"PolicyNo", "政策编号"},
                            {"PolicyName", "政策名称"},
                            {"LargessDesc", "产品区间"},
                            {"LPSAPCode", "平台ERP Code"},
                            {"LPName", "平台名称"},
                            {"DealerSAPCode", "经销商ERP Code"},
                            {"DealerName", "经销商名称"},
                            {"HospitalId", "医院Code"},
                            {"HospitalName", "医院名称"},
                            {"Amount", "赠送值"},
                            {"AdjustAmount", "调整值"},
                            {"PointType", "积分类型"},
                            {"Ratio", "加价率"},
                            {"PointValidDate", "积分有效期"}
                        };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtDataDetail, dict);
                }

                #endregion 调整列的顺序,并重命名列名

                ds.Tables.Add(dtDataDetail);
            }


            #endregion 构造日志信息Table

            ExcelExporter.ExportDataSetToExcel(ds);
        }
        #endregion

        #region  私有方法
        private string GetBUName(string productlineId)
        {
            string BUName = "";
            Hashtable obj = new Hashtable();
            obj.Add("ProductLineID", productlineId);
            DataTable dtProduct = _business.GetProductInformation(obj).Tables[0];
            if (dtProduct.Rows.Count > 0)
            {
                BUName = dtProduct.Rows[0]["DivisionName"].ToString();
            }
            return BUName;
        }

        #endregion

        [AjaxMethod]
        public void Test()
        {
            //try
            //{
            //    GiftMaintainBLL bll = new GiftMaintainBLL();
            //    String xml = "<style type='text/css'>table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style><h4>申请描述</h4><table class='gridtable'><tr><th width='60'>BU</th><td width='160'>Cardio</td></tr><tr><th width='60'>结算周期</th><td width='160'>季度</td></tr><tr><th width='60'>结算帐期</th><td width='160'>2015Q4</td></tr><tr><th width='60'>描述</th><td width='160'>1111111111</td></tr></table><h4>明细</h4><table class='gridtable'><tr><th>赠品描述</th><th>平台或经销商</th><th>计算数量</th><th>调整数量</th></tr><tr><td></td><td>国科恒泰（北京）医疗科技有限公司</td><td>285.00</td><td>285.00</td></tr><tr><td></td><td>上海方承医疗器械有限公司</td><td>0.00</td><td>0.00</td></tr></table>";
            //    bll.SendEWorkflow("1", xml, "赠品");

            //    Ext.Msg.Show(new MessageBox.Config
            //    {
            //        Buttons = MessageBox.Button.OK,
            //        Icon = MessageBox.Icon.INFO,
            //        Title = "调用成功",
            //        Message = "调用成功"
            //    });
            //}
            //catch
            //{
            //    Ext.Msg.Show(new MessageBox.Config
            //    {
            //        Buttons = MessageBox.Button.OK,
            //        Icon = MessageBox.Icon.ERROR,
            //        Title = "调用失败",
            //        Message = "调用失败"
            //    });
            //}

        }
    }
}
