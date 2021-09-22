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

namespace DMS.Website.Pages.POReceipt
{
    using iTextSharp.text.pdf;
    using iTextSharp.text;
    using System.IO;
    public partial class POReceiptList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        private IPOReceipt _business = null;
        [Dependency]
        public IPOReceipt business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.dealerData.Value = DealerCacheHelper.GetJsonArray();
                //this.btnInsert.Disabled = !IsDealer;
                this.btnInsert.Visible = false;
                this.Bind_ProductLine(ProductLineStore);
                this.Bind_Dictionary(ReceiptStatusStore, SR.Consts_Receipt_Status.ToString());
                //this.Bind_Dictionary(ReceiptTypeStore, SR.Consts_Receipt_Type.ToString());
                this.Bind_ReceiptType(ReceiptTypeStore);

                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        this.btnImport.Hidden = true;
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.Disabled = false;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //如果为平台导入按钮开放
                        this.btnImport.Hidden = false;

                    }
                    else
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = false;

                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }

                }
                else
                {
                    if (_context.IsInRole("经销商短期寄售管理员") || _context.IsInRole("Administrators"))
                    {
                        this.btnImport.Hidden = false;
                    }
                    this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Disabled = false;
                    this.cbDealer.Disabled = false;
                    //控制查询按钮
                    Permissions pers = this._context.User.GetPermissions();
                    this.btnSearch.Visible = pers.IsPermissible(Business.POReceipt.Action_DealerReceipt, PermissionType.Read);

                }


                //if (IsDealer)
                //{
                //    this.cbDealer.Disabled = true;
                //    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                //    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_POReceipt);
                //}
                //else
                //{
                //    //控制查询按钮
                //    Permissions pers = this._context.User.GetPermissions();
                //    this.btnSearch.Visible = pers.IsPermissible(Business.POReceipt.Action_DealerReceipt, PermissionType.Read);
                //}
            }
        }


        protected void Bind_ReceiptType(Store store)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Receipt_Type);
            //var query = from t in dicts where t.Key != ReceiptType.Retail.ToString() select t;
            //store.DataSource = query;
            store.DataSource = dicts;
            store.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //IPOReceipt business = new DMS.Business.POReceipt();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerDmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbReceiptType.SelectedItem.Value))
            {
                param.Add("Type", this.cbReceiptType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbReceiptStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbReceiptStatus.SelectedItem.Value);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("SapShipmentDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("SapShipmentDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtSapShipmentid.Text))
            {
                param.Add("SapShipmentid", this.txtSapShipmentid.Text);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("Cfn", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.txtOrderNo.Text))
            {
                param.Add("PurchaseOrderNbr", this.txtOrderNo.Text);
            }


            //BSC用户可以看所有发货单，T1、T2经销商用户只能看自己的发货单,LP可以看自己的以及下属经销商的发货单
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString())|| RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }


            DataSet ds = business.QueryPoReceipt(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);



            //(this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid hid = new Guid(this.hiddenHeaderId.Text);

            //IPOReceipt business = new DMS.Business.POReceipt();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            param.Add("hid", hid);

            DataSet ds = business.QueryPoReceiptLot(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();
        }

        private void BindHeader(Guid id)
        {
            //IPOReceipt business = new DMS.Business.POReceipt();
            PoReceiptHeader header = business.GetObjectAddWarehouse(id);

            this.txtDealer.Text = DealerCacheHelper.GetDealerName(header.DealerDmaId);
            this.txtVendor.Text = DealerCacheHelper.GetDealerName(header.VendorDmaId);
            this.txtWarehouse.Text = header.WHMName;
            this.txtSapNumber.Text = header.SapShipmentid;
            this.txtPoNumber.Text = header.PoNumber;
            this.txtDate.Text = (header.SapShipmentDate == null) ? "" : header.SapShipmentDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
            this.txtStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Receipt_Status, header.Status);
            //added by bozhenfei on 20100612
            this.txtCarrier.Text = header.Carrier;
            this.txtTrackingNo.Text = header.TrackingNo;
            this.txtShipType.Text = header.ShipType;
            //end
            this.hiddenHeaderId.Text = id.ToString();
            //added by huyong on 20140509
            this.txtFromWarehouse.Text = header.FromWHMName;

            //判断是否显示收获按钮
            if (IsDealer)
            {
                //取得经销商的开帐日期
                DealerMasters dms = new DealerMasters();
                DealerMaster dm = dms.GetDealerMaster(header.DealerDmaId);

                //经销商不允许取消收货单
                this.CancelButton.Disabled = true;

                //Edit by Songweiming on 2013-11-18 允许物流平台在界面上进行收货，修改下面这句语句
                //if (dm == null || RoleModelContext.Current.User.CorpType == DealerType.LP.ToString())
                //RLD在界面上进行收货
                if ((RoleModelContext.Current.User.CorpId.ToString().ToUpper() == "2F2D2BD9-6FAE-4A40-BC44-8E5FECC1C6DD" || RoleModelContext.Current.User.CorpId.ToString().ToUpper() == "3D9B9EA0-1214-42CA-A2EF-D93C5C887040") && header.DealerDmaId.ToString() == RoleModelContext.Current.User.CorpId.ToString())
                {
                    this.SaveButton.Disabled = !(header.Status == ReceiptStatus.Waiting.ToString());
                }
                else if (dm == null || header.DealerDmaId.ToString() != RoleModelContext.Current.User.CorpId.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LP.ToString())
                {
                    //DateTime sysdate = dm.SystemStartDate.HasValue ? dm.SystemStartDate.Value : DateTime.MaxValue;
                    //if (header.SapShipmentDate.Value < sysdate)
                    //{
                    //    this.SaveButton.Disabled = true;
                    //}
                    //else
                    //{
                    //    this.SaveButton.Disabled = !(header.Status == ReceiptStatus.Waiting.ToString());
                    //}

                    this.SaveButton.Disabled = true;
                }
                else
                {
                    this.SaveButton.Disabled = !(header.Status == ReceiptStatus.Waiting.ToString());
                }

                //this.SaveButton.Disabled = !(header.Status == ReceiptStatus.Waiting.ToString());
            }
            else
            {
                this.SaveButton.Disabled = true;
                //管理员允许取消收货单，当且仅当单据类型是采购入库单，且状态是待接收的单据能够取消
                if (header.Status.Equals(ReceiptStatus.Waiting.ToString()) && header.Type.Equals(ReceiptType.PurchaseOrder.ToString()))
                {
                    this.CancelButton.Disabled = false;
                }
                else
                {
                    this.CancelButton.Disabled = true;
                }

            }
        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenHeaderId.Text);
            int totalCount = 0;
            DataSet ds = _logbll.QueryPurchaseOrderLogByHeaderId(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }


        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            Guid id = new Guid(e.ExtraParams["PHR_ID"].ToString());
            BindHeader(id);
            this.GridPanel2.ColumnModel.SetHidden(9, true);
            if (RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
            {
                this.GridPanel2.ColumnModel.SetHidden(9, false);
            }
            this.DetailWindow.Show();
        }

        [AjaxMethod]
        public void DoConfirm()
        {
            Ext.Msg.Confirm(GetLocalResourceObject("DoConfirm.Confirm.Title").ToString(), GetLocalResourceObject("DoConfirm.Confirm.Body").ToString(), new MessageBox.ButtonsConfig
            {
                Yes = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.DoYes({failure: function(err) {Ext.Msg.alert('Failure', err);}})",
                    Text = "Yes"
                },
                No = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.DoNo()",
                    Text = "No"
                }
            }).Show();
        }

        [AjaxMethod]
        public void DoCancel()
        {
            Ext.Msg.Confirm(GetLocalResourceObject("DoConfirm.Confirm.Title").ToString(), GetLocalResourceObject("DoConfirm.Cancel.Body").ToString(), new MessageBox.ButtonsConfig
            {
                Yes = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.DoCancelYes({failure: function(err) {Ext.Msg.alert('Failure', err);}})",
                    Text = "Yes"
                },
                No = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.DoNo()",
                    Text = "No"
                }
            }).Show();
        }

        [AjaxMethod]
        public void DoYes()
        {
            
            string rtnVal = string.Empty;
            //收货业务
            //IPOReceipt business = new DMS.Business.POReceipt();
            PoReceiptHeader header = business.GetObjectAddWarehouse(new Guid(this.hiddenHeaderId.Text));
            Guid WhmId = header.WhmId.HasValue ? header.WhmId.Value : Guid.Empty;
            try
            {
                rtnVal = business.SavePoReceipt(new Guid(this.hiddenHeaderId.Text),WhmId);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (rtnVal== "Success")
            {
                this.ResultStore.DataBind();
                this.DetailWindow.Hide();
                Ext.Msg.Alert(GetLocalResourceObject("DoConfirm.Confirm.Title").ToString(), GetLocalResourceObject("DoYes.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoConfirm.Confirm.Title").ToString(),rtnVal.ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DoCancelYes()
        {
            //取消收货单
            //IPOReceipt business = new DMS.Business.POReceipt();
            bool result = false;

            try
            {
                result = business.CancelPoReceipt(new Guid(this.hiddenHeaderId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                this.ResultStore.DataBind();
                this.DetailWindow.Hide();
                Ext.Msg.Alert(GetLocalResourceObject("DoConfirm.Confirm.Title").ToString(), GetLocalResourceObject("DoCancelYes.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoConfirm.Confirm.Title").ToString(), GetLocalResourceObject("DoCancelYes.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DoNo()
        {

        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = this.GetPoReceipt().Tables[0];//dt是从后台生成的要导出的datatable
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
        [AjaxMethod]
        public void DownloadPdf(string Lot, string Property1, string Upn)
        {
            HiddFileName.Clear();
            HiddDowleName.Clear();
            ICfns _cfns = Global.ApplicationContainer.Resolve<ICfns>();
            Hashtable param = new Hashtable();
            param.Add("CustomerFaceNbr", Upn);
            DataSet ds = _cfns.SelectCFNRegistrationByUpn(param);
            if (ds.Tables[0].Rows.Count > 0)
            {
                String[] strPath = new String[2];
                strPath[0] = Server.MapPath("\\Upload\\UPN\\Licence\\" + ds.Tables[0].Rows[0]["AttachName"].ToString());
                string CoaFile = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UPN\\Licence\\" + ds.Tables[0].Rows[0]["AttachName"].ToString();
                if (File.Exists(CoaFile))
                {
                    String fileName = string.Empty;
                    String NewWaterPdf = string.Empty;
                    AddPdfs(Lot, Property1, out fileName);
                    AddTextWatermark(fileName, out NewWaterPdf);

                    strPath[1] = NewWaterPdf;
                    String fileName1 = Guid.NewGuid().ToString().Replace("-", "").ToUpper() + ".pdf";
                    String OutputPdfPath = Server.MapPath(PdfHelper.COA_FILE_PATH + fileName1);
                    PdfHelper.MergePdf(strPath, OutputPdfPath);
                    HiddFileName.Text = ds.Tables[0].Rows[0]["AttachName"].ToString();
                    HiddDowleName.Text = fileName1;
                }
                else
                {
                    Ext.Msg.Alert("Messing", "该产品型号COA附件不存在").Show();
                }
                //HiddenCoafileUrl.Text = "../Download.aspx?downloadname=" + fileName1 + "&filename=" + ds.Tables[0].Rows[0]["AttachName"].ToString() + "&downtype=COA";
            }
            else
            {
                Ext.Msg.Alert("Messing", "该产型品号没有上传COA附件").Show();
            }
        }
        public void AddPdfs(string Lot, string Upn, out String fileName)
        {
            //下载COA证件

            fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.COA_FILE_PATH + fileName);
            fileName = targetPath;
            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 12);
            try
            {
                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                doc.Open();
                doc.NewPage();

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(1);
                //titleTable.SetWidths(new float[] { 90f});
                PdfHelper.InitPdfTableProperty(titleTable);

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("ATTACHMENT of CERTIFICATE OF ANALYSIS ", PdfHelper.boldFont));
                //设置标题居中
                titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                //title下划线
                PdfContentByte cb = writer.DirectContent;
                cb.SetLineWidth(0.2f);
                cb.MoveTo(165f, 772.5f);
                cb.LineTo(430f, 772.5f);
                cb.ClosePath();
                cb.Stroke();

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);

                //副标题
                #region
                Phrase phrase2 = new Phrase();
                phrase2.Add(new Chunk("The products listed below have been manufactured to the good manufacturing rules of this company, and that they have been successfully released by the Quality Control Department.", PdfHelper.boldFont));
                phrase2.Add(Chunk.NEWLINE);
                Paragraph paragraph2 = new Paragraph();
                phrase2.Add(Chunk.NEWLINE);
                paragraph2.Add(phrase2);
                paragraph2.Alignment = Rectangle.ALIGN_JUSTIFIED;
                paragraph2.IndentationLeft = 5;
                paragraph2.KeepTogether = true;
                paragraph2.Leading = 15f;
                doc.Add(paragraph2);
                #endregion

                //生成表格
                PdfPTable supportDocTable = new PdfPTable(1);
                PdfHelper.AddPdfCell("", PdfHelper.normalFont, supportDocTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, supportDocTable);
                PdfHelper.InitPdfTableProperty(supportDocTable);
                PdfPTable standardTermGridTable = new PdfPTable(4);
                standardTermGridTable.SetWidths(new float[] { 1f, 16f, 9f, 25f });
                PdfHelper.InitPdfTableProperty(standardTermGridTable);

                //表头
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("UPN/Model Number", PdfHelper.boldFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 2, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_CENTER, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Lot/Batch Number", PdfHelper.boldFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_CENTER, true, true, true, true);
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Upn, PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 2 }, standardTermGridTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_CENTER, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Lot, PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_CENTER, false, true, true, true);
                PdfHelper.AddPdfTable(doc, standardTermGridTable);

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                doc.Close();

            }
        }
        public void AddTextWatermark(string Filename, out string OutputPdfPath)
        {
            String newfileName = Guid.NewGuid().ToString().Replace("-", "").ToUpper() + ".pdf";
            OutputPdfPath = Server.MapPath(PdfHelper.COA_FILE_PATH + newfileName);
            this.PDFTextWatermark(Filename, OutputPdfPath, "仅供代理商或使用单位验收备案/招标，解释权归蓝威所有", 0, 0);
        }
        public bool PDFTextWatermark(string inputfilepath, string outputfilepath, string waterMarkText, float top, float left)
        {
            //注册中文字库
            PdfHelper.RegisterChineseFont();

            //throw new NotImplementedException();
            PdfReader pdfReader = null;
            PdfStamper pdfStamper = null;
            try
            {
                pdfReader = new PdfReader(inputfilepath);

                int numberOfPages = pdfReader.NumberOfPages;

                iTextSharp.text.Rectangle psize = pdfReader.GetPageSize(1);

                float width = psize.Width;

                float height = psize.Height;

                pdfStamper = new PdfStamper(pdfReader, new FileStream(outputfilepath, FileMode.Create));

                PdfContentByte waterMarkContent;

                //微软雅黑  
                BaseFont bfChinese = PdfHelper.baseFont;
                PdfGState gs = new PdfGState();
                gs.FillOpacity = 0.2f;//透明度

                int j = waterMarkText.Length;
                char c;
                int rise = 0;
                for (int i = 1; i <= numberOfPages; i++)
                {
                    waterMarkContent = pdfStamper.GetOverContent(i);//在内容上方加水印
                    //content = pdfStamper.GetUnderContent(i);//在内容下方加水印
                    //透明度
                    gs.FillOpacity = 0.3f;
                    waterMarkContent.SetGState(gs);

                    //开始写入文本
                    waterMarkContent.BeginText();
                    waterMarkContent.SetColorFill(BaseColor.LIGHT_GRAY);
                    waterMarkContent.SetFontAndSize(bfChinese, 25);
                    waterMarkContent.SetTextMatrix(0, 0);
                    waterMarkContent.ShowTextAligned(Element.ALIGN_CENTER, waterMarkText, width / 2 - 50, height / 2 - 50, 55);

                    waterMarkContent.EndText();
                }

                return true;
            }
            catch (Exception ex)
            {
                throw ex;

            }
            finally
            {

                if (pdfStamper != null)
                    pdfStamper.Close();

                if (pdfReader != null)
                    pdfReader.Close();
            }
        }
        protected DataSet GetPoReceipt()
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerDmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbReceiptType.SelectedItem.Value))
            {
                param.Add("Type", this.cbReceiptType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbReceiptStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbReceiptStatus.SelectedItem.Value);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("SapShipmentDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("SapShipmentDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtSapShipmentid.Text))
            {
                param.Add("SapShipmentid", this.txtSapShipmentid.Text);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("Cfn", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.txtOrderNo.Text))
            {
                param.Add("PurchaseOrderNbr", this.txtOrderNo.Text);
            }

            //BSC用户可以看所有发货单，T1、T2经销商用户只能看自己的发货单,LP可以看自己的以及下属经销商的发货单
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }

            DataSet ds = business.QueryPoReceiptForExport(param);

            return ds;
        }
    }
}
