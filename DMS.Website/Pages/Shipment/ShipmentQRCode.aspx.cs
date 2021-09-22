using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Shipment
{
    using DMS.Website.Common;
    using Lafite.RoleModel.Security;
    using System.Collections;
    using System.Data;
    using DMS.Business;
    using Coolite.Ext.Web;
    using ThoughtWorks.QRCode.Codec;
    using ThoughtWorks.QRCode.Codec.Data;
    using ThoughtWorks.QRCode.Codec.Util;
    using System.IO;
    using System.Text;
    using Microsoft.Practices.Unity;
    using DMS.Model;

    public partial class ShipmentQRCode : BasePage
    {
        private ICfns _business = null;
        [Dependency]
        public ICfns business
        {
            get { return _business; }
            set { _business = value; }
        }

        private IHospitals _hospitalBusiness = null;
        [Dependency]
        public IHospitals hospitalBusiness 
        {
            get { return _hospitalBusiness; }
            set { _hospitalBusiness = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_DealerListByFilter(DealerStore, true);

                if (IsDealer)
                {
                    this.cbDealer.Disabled = true;
                    this.hiddenDealerId.Text = RoleModelContext.Current.User.CorpId.Value.ToString();
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    this.Bind_ProductLine(ProductLineStore);
                }
                else
                {
                    this.cbDealer.Disabled = false;
                    this.hiddenDealerId.Text = string.Empty;
                }
            }
        }

        protected void Store_RefreshHospital(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;
            Guid ProductLineId = Guid.Empty;
            Hashtable param = new Hashtable();
            if (this.cbDealer.SelectedItem != null && this.cbDealer.SelectedItem.Value != "")
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }

            if (this.cbProductLine.SelectedItem != null && this.cbProductLine.SelectedItem.Value != "")
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetHospitalForDealerByFilter(param);

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = ds;
                store1.DataBind();
            }
        }

        protected void Store_RefreshProductLine(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;

            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value.ToString()))
            {
                DealerId = new Guid(cbDealer.SelectedItem.Value.ToString());
            }

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetProductLineByDealer(DealerId);

            ProductLineStore.DataSource = ds;
            ProductLineStore.DataBind();
        }

        [AjaxMethod]
        public string BarCode(string barCode)
        {
            List<string> crmList = new List<string>() { "60", "62", "64" };

            //清空
            this.txtIdentifierFalg.Text = "";
            this.txtType.Text = "";
            this.txtLotNumber.Text = "";
            this.dfCreateDate.Clear();

            this.dfEffectiveDate.Clear();
            this.txtSerialNumbe.Text = "";
            this.trQrCode.Text = "";

            this.hiddenCrmFlag.Text = "";
            this.hiddenCfnChineseName.Text = "";
            this.hiddenCfnEnglishName.Text = "";

            string temp_barCode = barCode;

            if (temp_barCode.Length == 0)
            {
                return "请扫描条形码";
            }
            else if (temp_barCode.Substring(0, 1) == "+")
            {
                this.txtType.Text = "HIBC";

                this.txtLotNumber.ReadOnly = false;
                this.dfEffectiveDate.Disabled = false;

                this.txtLotNumber.LabelCls = "normalFont";
                this.dfEffectiveDate.LabelCls = "normalFont";

            }
            else if (temp_barCode.Length > 26)
            {
                this.txtType.Text = "GS1";

                this.txtLotNumber.ReadOnly = true;
                this.dfEffectiveDate.Disabled = true;

                this.txtLotNumber.LabelCls = "fillFont";
                this.dfEffectiveDate.LabelCls = "fillFont";
            }
            else
            {
                return "请扫描有效的条形码";
            }

            if (this.txtType.Text == "GS1")
            {
                this.txtLotNumber.ReadOnly = true;

                this.txtIdentifierFalg.Text = temp_barCode.Substring(2, 14);

                DateTime dt = DateTime.MinValue;
                if (DateTime.TryParseExact("20" + temp_barCode.Substring(18, 6), "yyyyMMdd", System.Globalization.CultureInfo.CurrentCulture, System.Globalization.DateTimeStyles.None, out dt))
                {
                    this.dfEffectiveDate.SelectedDate = dt;
                }
                else
                {
                    return "日期不正确";
                }
                this.txtLotNumber.Text = temp_barCode.Substring(26, temp_barCode.Length - 26);


                #region 判断CRM植入产品
                bool isCrmFlag = false;
                Hashtable table = new Hashtable();

                table.Add("Property7", this.txtIdentifierFalg.Text);

                IList<Cfn> list = business.QueryCfnByFilter(table);

                if (list.Count() > 0)
                {
                    //判断是否为CRM植入产品
                    if (list.Where<Cfn>(p => p.Property6 == "1" && crmList.IndexOf(p.CustomerFaceNbr.Substring(0, 2)) > -1).Count() > 0)
                    {
                        isCrmFlag = true;
                    }
                    this.hiddenCfnChineseName.Text = list.First<Cfn>().ChineseName;
                    this.hiddenCfnEnglishName.Text = list.First<Cfn>().EnglishName;
                }
                else
                {
                    this.txtIdentifierFalg.Text = "";
                    return "扫描的产品不是波科的产品";
                }

                if (isCrmFlag)
                {
                    this.txtSerialNumbe.Text = this.txtLotNumber.Text;
                }

                this.hiddenCrmFlag.Text = isCrmFlag ? "1" : "0";
                #endregion
            }
            else if (this.txtType.Text == "HIBC")
            {
                this.txtLotNumber.ReadOnly = false;

                //唯一标识去除+后所有的
                this.txtIdentifierFalg.Text = temp_barCode.Substring(1, temp_barCode.Length - 1);

                #region 判断CRM植入产品
                bool isCrmFlag = false;
                Hashtable table = new Hashtable();

                //去掉+号和最末一位数字
                table.Add("CustomerFaceNbr", temp_barCode.Substring(1, temp_barCode.Length - 2));

                IList<Cfn> list = business.QueryCfnByFilter(table);

                if (list.Count() > 0)
                {
                    //判断是否为CRM植入产品
                    if (list.Where<Cfn>(p => p.Property6 == "1" && crmList.IndexOf(p.CustomerFaceNbr.Substring(0, 2)) > -1).Count() > 0)
                    {
                        isCrmFlag = true;
                    }
                    this.hiddenCfnChineseName.Text = list.First<Cfn>().ChineseName;
                    this.hiddenCfnEnglishName.Text = list.First<Cfn>().EnglishName;
                }
                else
                {
                    this.txtIdentifierFalg.Text = "";
                    return "扫描的产品不是波科的产品";
                }

                if (isCrmFlag)
                {
                    this.txtSerialNumbe.Text = this.txtLotNumber.Text;
                }

                this.hiddenCrmFlag.Text = isCrmFlag ? "1" : "0";
                #endregion
            }
            return "";
        }

        [AjaxMethod]
        public void SynLotNumber()
        {
            //若为HIBC并且为Crm产品，序号等于批次号
            if (this.txtType.Text == "HIBC" && this.hiddenCrmFlag.Text == "1")
            {
                this.txtSerialNumbe.Text = this.txtLotNumber.Text;
            }

            if (this.txtType.Text == "HIBC")
            {
                LotMasters lotBusiness = new LotMasters();
                LotMaster lotMaster = lotBusiness.SelectLotMasterByLotNumberCFN(this.txtLotNumber.Text, this.txtIdentifierFalg.Text);

                if (lotMaster != null && lotMaster.ExpiredDate.HasValue)
                {
                    this.dfEffectiveDate.SelectedDate = lotMaster.ExpiredDate.Value;
                }
                else
                {
                    this.dfEffectiveDate.Clear();
                }
            }
        }

        [AjaxMethod]
        public void SynCreateDate()
        {
            //若为非Crm产品，序号等于生产日期+当前时间戳
            if (this.hiddenCrmFlag.Text == "0" && this.dfCreateDate.IsNull)
            {
                this.txtSerialNumbe.Text = "";
            }
            else if (this.hiddenCrmFlag.Text == "0")
            {
                this.txtSerialNumbe.Text = this.dfCreateDate.SelectedDate.ToString("yyMMdd") + DateTime.Now.ToString("yyyyMMddHHmmss");
            }
        }

        [AjaxMethod]
        public void CreateQrCode()
        {
            Hospital hospital = hospitalBusiness.GetObject(new Guid(this.cbHospital.SelectedItem.Value));

            if (hospital != null && !string.IsNullOrEmpty(hospital.HosFax))
            {

                //序列号的规则：医院编号+唯一编码+产品批次号+生产日期+有效期+产品序列号
                this.trQrCode.Text = hospital.HosFax + "" + this.txtIdentifierFalg.Text + ","
                                    + this.txtLotNumber.Text + "," + this.dfCreateDate.SelectedDate.ToString("yyMMdd") + ","
                                    + this.dfEffectiveDate.SelectedDate.ToString("yyMMdd") + "," + this.txtSerialNumbe.Text;
            }
            else
            {
                Ext.Msg.Alert("Message", "你所选择医院尚未开通二维码生成，请联系管理员").Show();
            }
        }

        [AjaxMethod]
        public void CreateImageQrPath()
        {
            this.hiddenQrPath.Text = "";
            this.hiddenQrPath.Text = Guid.NewGuid() + ".png";
        }

        [AjaxMethod]
        public void CreateQr()
        {
            if (string.IsNullOrEmpty(this.trQrCode.Text))
            {
                Ext.Msg.Alert("Message", "请先生成二维码序列号").Show();
                return;
            }

            QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();

            qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;

            qrCodeEncoder.QRCodeScale = 4;

            qrCodeEncoder.QRCodeVersion = 8;

            qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.M;

            //String data = "Hello 二维码！";
            string data = this.trQrCode.Text;
            Response.Write(data);

            System.Drawing.Bitmap image = qrCodeEncoder.Encode(data);

            System.IO.MemoryStream MStream = new System.IO.MemoryStream();

            image.Save(MStream, System.Drawing.Imaging.ImageFormat.Png);

            Response.ClearContent();

            Response.ContentType = "image/Png";

            Response.BinaryWrite(MStream.ToArray());

            string imgName = this.hiddenQrPath.Text;
            string filePath = Page.Server.MapPath(@"..\..\") + @"Upload\QR\" + imgName;

            //this.hiddenQrPath.Text = imgName;

            FileStream fs = new FileStream(filePath, FileMode.CreateNew, FileAccess.ReadWrite);

            BinaryWriter bw = new BinaryWriter(fs, UTF8Encoding.UTF8);
            byte[] by = MStream.ToArray();
            for (int i = 0; i < MStream.ToArray().Length; i++)
                bw.Write(by[i]);
            fs.Close();
        }
    }
}
