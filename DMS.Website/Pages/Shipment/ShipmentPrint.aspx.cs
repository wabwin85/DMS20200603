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
using System.Xml;
using System.Xml.Xsl;
using System.Text.RegularExpressions;

namespace DMS.Website.Pages.Shipment
{
    public partial class ShipmentPrint : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IShipmentBLL _business = null;
        private IDealerMasters _master = null;
        private static Guid id = Guid.Empty;
        const string DIBProductLineID = "5cff995d-8ffc-44f6-a0aa-ff750cc36312";

        [Dependency]
        public IShipmentBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        [Dependency]
        public IDealerMasters master
        {
            get { return _master; }
            set { _master = value; }
        }


        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                    Response.Redirect("ShipmentList.aspx");
                else
                {
                    id = new Guid(Request.QueryString["id"].ToString());
                    BindMain(id);

                    DetailRefershData();
                }
            }
        }


        private void BindMain(Guid id)
        {
            DealerMasters dm = new DealerMasters();
            Guid pid = Guid.Empty;
            Guid hid = Guid.Empty;
            ShipmentHeader mainData = business.GetShipmentHeaderByIdForPrinting(id);
            //tbDealer.Text = DealerCacheHelper.GetDealerName(mainData.DealerDmaId);
            tbDealer.Text = mainData.DealerName;

            if (mainData.ProductLineBumId != null)
                pid = mainData.ProductLineBumId.Value;
            if (mainData.HospitalHosId != null)
                hid = mainData.HospitalHosId.Value;

            this.tbTotalAmount.Text = business.GetShipmentTotalAmount(id).ToString();
            this.txtTotalQty.Text = business.GetShipmentTotalQty(id).ToString();

            string ProductLine = string.Empty;
            if (pid != Guid.Empty)
            {
                ProductLine = master.GetProductLineById(pid).Tables[0].Rows[0]["AttributeName"].ToString();
            }
            DataTable dt = master.GetHospitalById(hid).Tables[0];

            string Memo = string.IsNullOrEmpty(mainData.NoteForPumpSerialNbr) ? "" : mainData.NoteForPumpSerialNbr;
            string OrderNumber = mainData.ShipmentNbr;
            string Status = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Status, mainData.Status);
            string Date = mainData.ShipmentDate.HasValue ? mainData.ShipmentDate.Value.ToString("yyyy-MM-dd") : "";
            string InvoiceNo = string.IsNullOrEmpty(mainData.InvoiceNo) ? "" : mainData.InvoiceNo;
            string Office = string.IsNullOrEmpty(mainData.Office) ? "" : mainData.Office;
            string InvocieTitle = string.IsNullOrEmpty(mainData.InvoiceTitle) ? "" : mainData.InvoiceTitle;
            string InvoiceDate = mainData.InvoiceDate.HasValue ? mainData.InvoiceDate.Value.ToString("yyyy-MM-dd") : "";

            //this.tbProductLine.Text = string.IsNullOrEmpty(ProductLine) ? "" : ProductLine;
            this.tbHospital.Text = dt.Rows.Count == 0 ? "" : dt.Rows[0]["Name"].ToString();
            this.tbMemo.Text = string.IsNullOrEmpty(Memo) ? "" : Memo;
            this.tbOrderNumber.Text = string.IsNullOrEmpty(OrderNumber) ? "" : OrderNumber;
            //this.tbStatus.Text = string.IsNullOrEmpty(Status) ? "" : Status;
            this.tbDate.Text = Date;
            this.txtInoviceNo.Text = InvoiceNo;
            this.txtOffice.Text = Office;
            //this.txtInvoiceTitle.Text = InvocieTitle;
            this.txtInoviceDate.Text = InvoiceDate;
            //控制打印显示的列
            ControlColumnDisplay(mainData.DealerDmaId);

        }

        protected void DetailRefershData()
        {
            Guid tid = id;

            IShipmentBLL business = new ShipmentBLL();
            Hashtable param = new Hashtable();

            param.Add("HeaderId", tid);
            DataSet ds = business.QueryShipmentLotForPrint(param);

            this.GridView1.DataSource = ds;

            this.GridView1.DataBind();
        }

        protected void result_RowCreated(object sender, GridViewRowEventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("result_RowCreated");
            //if (e.Row.RowType == DataControlRowType.DataRow || e.Row.RowType == DataControlRowType.Header)
            //{
            //    //判断是否显示编辑列
            //    e.Row.Cells[2].Visible = !Convert.ToBoolean(this.hfUPN.Value);
            //    e.Row.Cells[5].Visible = !Convert.ToBoolean(this.hfUOM.Value);
            //}
        }

        protected void ControlColumnDisplay(Guid id)
        {
            DealerCommonSetting dcSetting = business.QueryGetDealerCommonSetting(id);

            if (dcSetting != null)
            {
                for (int i = 0; i <12; i++)
                {
                    this.GridView1.Columns[i].Visible = false;

                }

                string st = dcSetting.SettingValue.Replace(",", ""); ;
                string[] strs = Regex.Split(st, "(?<=.)(?=.)");


                foreach (var item in strs)
                {

                    if (item == "0")
                    {
                        this.GridView1.Columns[0].Visible = true; //注册证名称
                    }
                    if (item == "1")
                    {
                        this.GridView1.Columns[1].Visible = true;  //产品型号
                    }
                    if (item == "b")
                    {
                        this.GridView1.Columns[2].Visible = true;   //产品规格
                    }
                    if (item == "2")
                    {
                        this.GridView1.Columns[3].Visible = true;  //产品批号
                    }
                    if (item == "3")
                    {
                        this.GridView1.Columns[4].Visible = true;  //有效期
                    }
                    if (item == "4")
                    {
                        this.GridView1.Columns[5].Visible = true; //销售数量
                    }
                    if (item == "5")
                    {
                        this.GridView1.Columns[6].Visible = true;  //单位
                    }
                    if (item == "6")
                    {
                        this.GridView1.Columns[7].Visible = true; //单价
                    }
                    if (item == "7")
                    {
                        this.GridView1.Columns[8].Visible = true; //注册证号
                    }
                    if (item == "8")
                    {
                        this.GridView1.Columns[9].Visible = true; //注册证英文号
                    }

                    if (item == "9")
                    {
                        this.GridView1.Columns[10].Visible = true; //注册证开始时间
                    }

                    if (item == "a")
                    {
                        this.GridView1.Columns[11].Visible = true;//注册证过期时间
                    }


                }
            }
        }



    }
}
