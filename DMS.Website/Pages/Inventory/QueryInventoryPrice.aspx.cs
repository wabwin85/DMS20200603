using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml.Xsl;
using System.Xml;


namespace DMS.Website.Pages.Inventory
{
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using DMS.Business;
    using DMS.Model;
    using Lafite.RoleModel.Security;
    using DMS.Common;
    using DMS.Model.Data;
    using DMS.Business.Cache;
    using Microsoft.Practices.Unity;
    using System.Text;
    using iTextSharp.text.pdf;
    using iTextSharp.text;
    using System.IO;
    using System.Reflection;
    using System.Net;
    using DMS.Common.Common;

    public partial class QueryInventoryPrice : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private QueryInventoryBiz _business = null;
        [Dependency]
        public QueryInventoryBiz business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                //this.cboDealer.Enabled = pers.IsPermissible(Business.QueryInventoryBiz.Action_DealerInventoryQuery, PermissionType.Read);
                this.btnSearch.Visible = pers.IsPermissible(Business.QueryInventoryBiz.Action_DealerInventoryQuery, PermissionType.Read);
                this.Bind_DealerListByFilter(DealerStore, true);
                this.Bind_ProductLine(ProductLineStore);
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType != DealerType.HQ.ToString() && RoleModelContext.Current.User.CorpType != DealerType.LP.ToString())
                    {
                        this.cboDealer.Enabled = false;
                        btnExportLPABC.Hide();
                    }
                    else
                    {
                        btnExportLPABC.Show();
                    }
                    this.cboDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();

                }
                else
                {
                    btnExportLPABC.Show();
                }
            }
        }

        protected internal virtual void Store_AllWarehouseByDealer(object sender, StoreRefreshDataEventArgs e)
        {
            Warehouses business = new Warehouses();
            System.Diagnostics.Debug.WriteLine("Warehouse's DealerId = " + e.Parameters["DealerId"]);

            Guid DealerId = Guid.Empty;
            if (e.Parameters["DealerId"] != null || !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                DealerId = new Guid(e.Parameters["DealerId"].ToString());
            }
            IList<Warehouse> list = business.GetAllWarehouseByDealer(DealerId);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = list;
                store1.DataBind();
            }
        }

        protected void AjaxEvents_SubmitToExcel(object sender, AjaxEventArgs e)
        {
            e.Success = true;
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            DataSet Invds = this.GetInventoryList();//dt是从后台生成的要导出的datatable
            DataTable dt = Invds.Tables[0].Copy();

            DataSet ds = new DataSet("经销商库存数据");
            #region 构造日志信息Table
            DataTable dtData = dt;
            dtData.TableName = "经销商库存数据";
            if (null != dtData)
            {
                #region 调整列的顺序,并重命名列名

                Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"ChineseName", "经销商中文名"},
                            {"DealerType", "经销商类型"},
                            {"ParentChineseName", "上级经销商"},
                            {"WHMName", "仓库名称"},
                            {"WHMCode", "仓库编号"},
                            {"WarehouseType", "仓库类型"},
                            {"ProductLineName", "产品线中文名"},
                            {"ProductLineEnglishName", "产品线英文名"},
                            {"CustomerFaceNbr", "产品型号"},
                            {"CFNChineseName", "产品中文名"},
                            {"CFNEnglishName", "产品英文名"},
                            {"Registration", "注册证号"},
                            {"GTIN", "GTIN条码"},
                            {"Company", "生产厂商"},
                            {"LotNumber", "序列号/批号"},
                            {"QrCode", "二维码"},
                            {"LTMType", "产品生产日期"},
                            {"ExpiredDate", "有效期"},
                            {"UnitOfMeasure", "单位"},
                            {"OnHandQty", "库存数量"},
                            {"Price", "产品价格"},
                            {"SourceWhmName", "原仓库名称"}
                        };

                CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);

                #endregion 调整列的顺序,并重命名列名

                ds.Tables.Add(dtData);

            }
            #endregion 构造日志信息Table

            ExcelExporter.ExportDataSetToExcel(ds);

            //this.Response.Clear();
            //this.Response.Buffer = true;
            //this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            //this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            //this.Response.ContentType = "application/vnd.ms-excel";
            //this.EnableViewState = false;
            //this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            //this.Response.Write(ExportHelp.ExportTableForInventory(dt));//导出
            //this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            //this.Response.Flush();
            //this.Response.End();
        }

        protected void ExportLPABC(object sender, EventArgs e)
        {

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cboDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cboDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("CustomerFaceNbr", this.txtCFN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtLot.Text))
            {
                param.Add("LotNumber", this.txtLot.Text);
            }

            if (!string.IsNullOrEmpty(this.cboWarehouse.SelectedItem.Value))
            {
                param.Add("WhmId", this.cboWarehouse.SelectedItem.Value);
            }

            if (this.dateFrom.SelectedDate > DateTime.MinValue)
            {
                param.Add("ExpiredDateFrom", this.dateFrom.SelectedDate.ToString("yyyyMMdd"));
            }

            if (this.dateTo.SelectedDate > DateTime.MinValue)
            {
                param.Add("ExpiredDateTo", this.dateTo.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtCfnName.Text))
            {
                param.Add("CfnName", this.txtCfnName.Text);
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }
            DataTable dt = business.ExportLPInventoryABCDataSet(param).Tables[0];


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

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            //IQueryInventoryBiz invCurrent = new QueryInventoryBiz();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cboDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cboDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("CustomerFaceNbr", this.txtCFN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtLot.Text))
            {
                param.Add("LotNumber", this.txtLot.Text);
            }

            if (!string.IsNullOrEmpty(this.cboWarehouse.SelectedItem.Value))
            {
                param.Add("WhmId", this.cboWarehouse.SelectedItem.Value);
            }

            if (this.dateFrom.SelectedDate > DateTime.MinValue)
            {
                param.Add("ExpiredDateFrom", this.dateFrom.SelectedDate.ToString("yyyyMMdd"));
            }

            if (this.dateTo.SelectedDate > DateTime.MinValue)
            {
                param.Add("ExpiredDateTo", this.dateTo.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtCfnName.Text))
            {
                param.Add("CfnName", this.txtCfnName.Text);
            }

            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }
            if (!string.IsNullOrEmpty(this.Stockdays.Text))
            {
                param.Add("Stockdays", this.Stockdays.Text);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("cbProductLine", this.cbProductLine.SelectedItem.Value);
            }

            try
            {
                DataSet ds = null;
                ds = business.SelectInventoryPrice(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);


                //获取总数量，更新数据
                Decimal invSum = business.GetInventoryListSum(param);
                this.lblInvSum.Text = "库存数量合计：" + invSum.ToString();

                //IList<QueryInventory> ds = business.GetInventoryList(param);
                e.TotalCount = totalCount;
                //this.RecordCountStatusBar.Text = string.Format("查询结果共{0}条产品记录", ds.Count);
                this.DetailStore.DataSource = ds;
                this.DetailStore.DataBind();
            }
            catch (Exception ex)
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Title = "出错信息",
                    Message = "错误信息：" + ex.Message + " <br /> Source:" + ex.Source + " <br /> Stack Trace:" + ex.StackTrace,
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR
                });
            }

        }

        [AjaxMethod]
        public void ClearCriteria()
        {
            if (!IsDealer) this.cboDealer.SelectedItem.Value = null;
            this.cboWarehouse.SelectedItem.Value = null;
            this.txtCFN.Text = "";
            this.txtLot.Text = "";
            this.txtUPN.Text = "";
            this.txtCfnName.Text = "";
            this.dateFrom.SetValue("");
            this.dateTo.SetValue("");
            this.cbProductLine.SelectedItem.Value = null;
            this.Stockdays.Text = "";
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
                // HiddenCoafileUrl.Text = "../Download.aspx?downloadname=" + fileName1 + "&filename=" + ds.Tables[0].Rows[0]["AttachName"].ToString() + "&downtype=COA";
            }
            else
            {
                Ext.Msg.Alert("Messing", "该产品型号没有上传COA附件").Show();
            }
        }
        public void AddPdfs(string Lot, string Upn, out String fileName)
        {

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
        private DataSet GetInventoryList()
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cboDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cboDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("CustomerFaceNbr", this.txtCFN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtLot.Text))
            {
                param.Add("LotNumber", this.txtLot.Text);
            }

            if (!string.IsNullOrEmpty(this.cboWarehouse.SelectedItem.Value))
            {
                param.Add("WhmId", this.cboWarehouse.SelectedItem.Value);
            }

            if (this.dateFrom.SelectedDate > DateTime.MinValue)
            {
                param.Add("ExpiredDateFrom", this.dateFrom.SelectedDate.ToString("yyyyMMdd"));
            }

            if (this.dateTo.SelectedDate > DateTime.MinValue)
            {
                param.Add("ExpiredDateTo", this.dateTo.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtCfnName.Text))
            {
                param.Add("CfnName", this.txtCfnName.Text);
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }
            if (!string.IsNullOrEmpty(this.Stockdays.Text))
            {
                param.Add("Stockdays", this.Stockdays.Text);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("cbProductLine", this.cbProductLine.SelectedItem.Value);
            }

            DataSet ds = business.ExportNPOIInventoryPrice(param);

            return ds;
        }


    }
}
