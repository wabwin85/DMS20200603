using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using Coolite.Ext.Web;
using System.Data;
using DMS.Business.Contract;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;

namespace DMS.Website.Pages.Contract
{
    using iTextSharp.text.pdf;
    using iTextSharp.text;
    using System.IO;
    using System.Reflection;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Model.Data;
    using System.Text.RegularExpressions;
    using DMS.Business;
    using System.Collections;

    public partial class ContractForm6 : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private ITrainingSignInService _trainingSignIn = new TrainingSignInService();
        private Regex regChinese = new Regex("[\u4e00-\u9fa5]");
        private ContractMasterDM conMast = null;
        private IContractMasterBLL masterBll = new ContractMasterBLL();
        private IContractAppointmentService _appointment = new ContractAppointmentService();
        private IContractRenewalService _Renewal = new DMS.Business.ContractRenewalService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["CmId"] != null && Request.QueryString["CmStatus"] != null && Request.QueryString["DealerId"] != null && Request.QueryString["ContStatus"] != null)
                {
                    this.hdCmId.Value = Request.QueryString["CmId"];
                    this.hdCmStatus.Value = Request.QueryString["CmStatus"];
                    this.hdDealerEnName.Value = GetDealerName(new Guid(Request.QueryString["DealerId"]));
                    this.hdContStatus.Value = Request.QueryString["ContStatus"];
                    this.hdContId.Value = Request.QueryString["ContId"];

                    PagePermissions();
                    PagePermissionsbtn();
                    if (Session["conMast"] != null)
                    {
                        conMast = Session["conMast"] as ContractMasterDM;
                    }
                    BindPageDate();
                }
                if (!RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                {
                    btnCreatePdf.Enabled = false;
                }
            }
        }

        protected void Store_RefreshTrainingSignIn(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid CmId = new Guid(this.hdCmId.Value.ToString());
            DataTable dt = _trainingSignIn.GetTrainingSignInByContId(CmId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.TrainingSignInStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            TrainingSignInStore.DataSource = dt;
            TrainingSignInStore.DataBind();
            if (dt.Rows.Count < 3)
            {
                Session["From6"] = false;
            }
            else 
            {
                Session["From6"] = true; ;
            }
        }

        private void BindPageDate() 
        {
            this.lbThirdParty.Text = this.hdDealerEnName.Value.ToString();
            if (conMast != null)
            {
                DealeriafSign sign = masterBll.GetDealerIAFSign(conMast.CmId);
                if (sign != null)
                {
                    if (sign.From6Date != null) 
                    {
                        this.dfSingeDate.SelectedDate = sign.From6Date.Value;
                    }
                    this.tfPresentedBy.Value = sign.From6PresentedBy;
                    this.tfUserName.Value = sign.From6RepName;
                    this.tfTital.Value = sign.From6RepTital;
                }
                
            }
        }

        [AjaxMethod]
        public void SaveDraft()
        {
            try
            {
                string massage = "";
                if (!PageCheck(ref  massage))
                {
                    Ext.Msg.Alert("Error", massage).Show();
                }
                else
                {
                    SaveDate(ContractMastreStatus.Draft.ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        [AjaxMethod]
        public void SaveSubmit()
        {
            try
            {
                string massage = "";
                if (!PageCheck(ref  massage))
                {
                    Ext.Msg.Alert("Error", massage).Show();
                }
                else
                {
                    SaveDate(ContractMastreStatus.Submit.ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        private bool PageCheck(ref string massage) 
        {
            if (tfUserName.Text.Equals(""))
            {
                massage += "请填写签字代表名称<br/>";
            }
            if (tfTital.Text.Equals(""))
            {
                massage += "请填写签字代表职位<br/>";
            }
            if (dfSingeDate.Value==null)
            {
                massage += "请填写培训时间<br/>";
            }
            if (tfPresentedBy.Text.Equals(""))
            {
                massage += "请填写培训人<br/>";
            }
            if (massage.Equals(""))
            {
                return true;
            }
            else
            {
                massage = massage.Substring(0, massage.Length - 5);
                return false;
            }
        }

        private void SaveDate(string cmStatus)
        {
            try
            {
                DealeriafSign sign = new DealeriafSign();
                sign.CmId = new Guid(this.hdCmId.Value.ToString());
                sign.From6ThirdParty = this.lbThirdParty.Text;
                sign.From6Date = this.dfSingeDate.SelectedDate;
                sign.From6PresentedBy = this.tfPresentedBy.Text;
                sign.From6RepName = this.tfUserName.Text;
                sign.From6RepTital = this.tfTital.Text;

                DealeriafSign dtSign = masterBll.GetDealerIAFSign(sign.CmId);
                if (dtSign == null)
                {
                    masterBll.SaveDealerIAFSign(sign);
                }
                else
                {
                    masterBll.UpdateDealerIAFSignFrom6(sign);
                }
                Hashtable htCon = new Hashtable();
                htCon.Add("CapId", this.hdContId.Value);
                htCon.Add("CapCmId", this.hdCmId.Value);
                _appointment.UpdateAppointmentCmidByConid(htCon);

                htCon.Add("CreId", this.hdContId.Value);
                htCon.Add("CreCmId", this.hdCmId.Value);
                _Renewal.UpdateRenewalCmidByConid(htCon);

                if (Session["PageOperationType"] != null && (string)Session["PageOperationType"] == PageOperationType.EDIT.ToString())
                {
                    if (cmStatus.Equals(ContractMastreStatus.Draft.ToString()))
                    {
                        Ext.Msg.Alert("Success", "保存草稿成功").Show();
                    }
                    else
                    {
                        Ext.Msg.Alert("Success", "保存成功").Show();
                    }
                    Session["From6-1"] = true;
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }

        private void PagePermissionsbtn()
        {
            if (Session["PageOperationType"] == null)
            {
                //合同主表数据未维护，并且登录人并不是“一级经销商”或者“设备经销商”，只能查看空页面
                this.btnSaveDraft.Hidden = true;
            }

            if (this.hdCmStatus.Value.ToString().Equals(ContractMastreStatus.Submit.ToString()))
            {
                this.btnSaveDraft.Hidden = true;
                if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation)
                    && !this.hdContStatus.Value.Equals(ContractStatus.Completed.ToString())
                    && !this.hdContStatus.Value.Equals(ContractStatus.COSubmitPDF.ToString())
                    && !this.hdContStatus.Value.Equals(ContractStatus.Reject.ToString()))
                {
                    this.btnSubmit.Hidden = false;
                }
            }
            else
            {
                if (!IsDealer)
                {
                    this.btnSaveDraft.Hidden = true;
                }
            }
        }

        #region 反腐败培训签到
        [AjaxMethod]
        public void ShowTrainingSignInWindow()
        {
            //Init vlaue within this window control
            InitTrainingSignInWindow(true);

            //Show Window
            this.windowTrainingSignIn.Show();
        }

        [AjaxMethod]
        public void SaveTrainingSignIn()
        {
            string massage = "";
            if (!String.IsNullOrEmpty(this.tfWinTrainingSignInName.Text) && regChinese.IsMatch(this.tfWinTrainingSignInName.Text))
            {
                massage += "请使用英文名称<br/>";
            }
            //if (!String.IsNullOrEmpty(this.tfWinTrainingSignInDealerName.Text) && regChinese.IsMatch(this.tfWinTrainingSignInDealerName.Text))
            //{
            //    massage += "请使用英文填写第三方名称<br/>";
            //}
            try
            {
                if (massage == "")
                {
                    TrainingSignIn TrainingSignIn = new TrainingSignIn();

                    //Create
                    if (string.IsNullOrEmpty(this.hiddenWinTrainingSignInDetailId.Text))
                    {
                        TrainingSignIn.TsiId = Guid.NewGuid();
                        TrainingSignIn.TsiCmId = new Guid(this.hdCmId.Value.ToString());
                        TrainingSignIn.TsiName = this.tfWinTrainingSignInName.Text;
                        TrainingSignIn.TsiDealerName = this.tfWinTrainingSignInDealerName.Text;
                        if (!this.dfWinTrainingSignInDate.Value.ToString().Equals(""))
                        {
                            TrainingSignIn.TsiTrainingDate = Convert.ToDateTime(this.dfWinTrainingSignInDate.Value);
                        }
                        else
                        {
                            TrainingSignIn.TsiTrainingDate = null;
                        }

                        TrainingSignIn.BlUpdateDate = null;
                        TrainingSignIn.BlUpdateUser = null;
                        TrainingSignIn.BlCreateUser = new Guid(_context.User.Id);
                        TrainingSignIn.BlCreateDate = DateTime.Now;

                        _trainingSignIn.SaveTrainingSignIn(TrainingSignIn);
                    }
                    //Edit
                    else
                    {
                        TrainingSignIn.TsiId = new Guid(this.hiddenWinTrainingSignInDetailId.Text);
                        TrainingSignIn.TsiCmId = new Guid(this.hdCmId.Value.ToString());
                        TrainingSignIn.TsiName = this.tfWinTrainingSignInName.Text;
                        TrainingSignIn.TsiDealerName = this.tfWinTrainingSignInDealerName.Text;
                        if (!this.dfWinTrainingSignInDate.Value.ToString().Equals(""))
                        {
                            TrainingSignIn.TsiTrainingDate = Convert.ToDateTime(this.dfWinTrainingSignInDate.Value);
                        }
                        else
                        {
                            TrainingSignIn.TsiTrainingDate = null;
                        }


                        TrainingSignIn.BlUpdateUser = new Guid(_context.User.Id);
                        TrainingSignIn.BlUpdateDate = DateTime.Now;

                        _trainingSignIn.UpdateTrainingSignIn(TrainingSignIn);
                    }
                    windowTrainingSignIn.Hide();
                    gpTrainingSignIn.Reload();
                }
                else
                {
                    throw new Exception(massage);
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }
        }

        [AjaxMethod]
        public void DeleteTrainingSignInItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                _trainingSignIn.DeleteTrainingSignIn(new Guid(detailId));
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditTrainingSignInItem(string detailId)
        {
            //Init vlaue within this window control
            InitTrainingSignInWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadTrainingSignInWindow(new Guid(detailId));

                //Set Value
                this.hiddenWinTrainingSignInDetailId.Text = detailId;

                //Show Window
                this.windowTrainingSignIn.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        private void PagePermissions()
        {
            if (this.hdCmStatus.Value.ToString().Equals(ContractMastreStatus.Submit.ToString()))
            {
                if (!RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) 
                    && !this.hdContStatus.Value.Equals(ContractStatus.Completed.ToString())
                    && !this.hdContStatus.Value.Equals(ContractStatus.COSubmitPDF.ToString())
                    && !this.hdContStatus.Value.Equals(ContractStatus.Reject.ToString()))
                {
                    this.gpTrainingSignIn.ColumnModel.Columns[3].Hidden = true;
                    this.btnTrainingSignIn.Enabled = false;
                }
            }
            else
            {
                if (!IsDealer)
                {
                    this.gpTrainingSignIn.ColumnModel.Columns[3].Hidden = true;
                    this.btnTrainingSignIn.Enabled = false;
                }
            }
        }

        private string GetDealerName(Guid dealerid)
        {
            string dealerName = "";
            if (dealerid != null && dealerid != Guid.Empty)
            {
                IDealerMasters bll = new DealerMasters();
                DealerMaster dm = new DealerMaster();
                dm.Id = dealerid;
                IList<DealerMaster> listDm = bll.QueryForDealerMaster(dm);
                if (listDm.Count > 0)
                {
                    DealerMaster getDealerMaster = listDm[0];
                    dealerName = String.IsNullOrEmpty(getDealerMaster.EnglishName) ? getDealerMaster.ChineseName : getDealerMaster.EnglishName;
                }
            }
            return dealerName;
        }
        #endregion

        #region Init
        /// <summary>
        /// Init Control value and status of TrainingSignIn Window
        /// </summary>
        /// <param name="canSubmit"></param>
        private void InitTrainingSignInWindow(bool canSubmit)
        {
            this.tfWinTrainingSignInName.Clear();
            this.tfWinTrainingSignInDealerName.Clear();
            this.dfWinTrainingSignInDate.Clear();
          
            this.hiddenWinTrainingSignInDetailId.Clear(); //Id

            if (canSubmit)
            {
                this.btnTrainingSignInSubmit.Visible = true;

                this.tfWinTrainingSignInName.Clear();
                this.tfWinTrainingSignInDealerName.Clear();
                this.dfWinTrainingSignInDate.Clear();

                this.tfWinTrainingSignInDealerName.Text = this.hdDealerEnName.Value.ToString();
            }
            else
            {
                this.btnTrainingSignInSubmit.Visible = false;

                this.tfWinTrainingSignInName.Clear();
                this.tfWinTrainingSignInDealerName.Clear();
                this.dfWinTrainingSignInDate.Clear();
            }
        }

        private void LoadTrainingSignInWindow(Guid detailId)
        {
            TrainingSignIn trainSignIn = _trainingSignIn.GetTrainingSignInById(detailId);

            this.tfWinTrainingSignInName.Text = trainSignIn.TsiName;
            this.tfWinTrainingSignInDealerName.Text = trainSignIn.TsiDealerName;
            this.dfWinTrainingSignInDate.Value = trainSignIn.TsiTrainingDate;
        }

        #endregion

        #region Create IAF_Form_6 File

        protected void CreatePdf(object sender, EventArgs e)
        {
            DealeriafSign sign = masterBll.GetDealerIAFSign(new Guid(this.hdCmId.Value.ToString()));

            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 12);
            try
            {
                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();
                
                DataSet ds = _trainingSignIn.GetTrainingSignInByContId(new Guid(this.hdCmId.Value.ToString()));

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                //设置脚注，页码
                PdfPageEvent pdfPage = new PdfPageEvent("044905 Form 6 Attendance Sheet Rev. D");
                writer.PageEvent = pdfPage;

                doc.Open();
                
                #region Pdf Title

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(3);
                titleTable.SetWidths(new float[] { 25f, 50f, 25f });
                PdfHelper.InitPdfTableProperty(titleTable);

                titleTable.AddCell(PdfHelper.GetIAFBscLogoImageCell());

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("Form 6\r\nAttendance Sheet", PdfHelper.iafTitleGrayFont));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                PdfHelper.AddEmptyPdfCell(titleTable);

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);

                #endregion

                #region 副标题
                PdfPTable labelTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(labelTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Transacting Business with Integrity Training", PdfHelper.iafTitleFont)) { FixedHeight = 50f, BackgroundColor = PdfHelper.remarkBgColor, PaddingTop = 10f }, labelTable, null, null);

                PdfHelper.AddPdfTable(doc, labelTable);

                #endregion

                #region 第三方信息
                PdfPTable thirdParyTable = new PdfPTable(4);
                thirdParyTable.SetWidths(new float[] { 15f, 20f, 40f, 15f });
                PdfHelper.InitPdfTableProperty(thirdParyTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { Colspan = 4, FixedHeight = 10f }, thirdParyTable, null, null);

                //Third Party Name
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { Rowspan = 3 }, thirdParyTable, null, null);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Third Party Name:", PdfHelper.normalFont)) { FixedHeight = 20f }, thirdParyTable, Rectangle.ALIGN_LEFT, null); ;
                PdfHelper.AddPdfCellWithUnderLine(this.hdDealerEnName.Value.ToString(), pdfFont.normalChineseFont, thirdParyTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("")) { Rowspan = 3 }, thirdParyTable, null, null);

                //Date
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Date:", PdfHelper.normalFont)) { FixedHeight = 20f }, thirdParyTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellWithUnderLine(sign.From6Date==null?"":sign.From6Date.Value.ToShortDateString(), PdfHelper.iafAnswerFont, thirdParyTable, null, Rectangle.ALIGN_BOTTOM);

                //Presented By
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Presented By:", PdfHelper.normalFont)) { FixedHeight = 20f }, thirdParyTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellWithUnderLine(sign.From6PresentedBy, PdfHelper.iafAnswerFont, thirdParyTable, null, Rectangle.ALIGN_BOTTOM);


                PdfHelper.AddPdfTable(doc, thirdParyTable);
                #endregion

                #region Third Party User

                PdfPTable bodyTable = new PdfPTable(3);
                bodyTable.SetWidths(new float[] { 30f, 35f, 35f });
                PdfHelper.InitPdfTableProperty(bodyTable);

                bodyTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 3 });

                //Head
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("NAME (PRINT)", PdfHelper.normalFont)) { BackgroundColor = PdfHelper.remarkBgColor, BorderColor = PdfHelper.blueColor, BorderColorRight = BaseColor.BLACK, BorderWidthLeft = 1f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("THIRD PARTY NAME", PdfHelper.normalFont)) { BackgroundColor = PdfHelper.remarkBgColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthLeft = 0.6f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("SIGNATURE", PdfHelper.normalFont)) { BackgroundColor = PdfHelper.remarkBgColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 1f, BorderWidthLeft = 0.6f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);

                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Phrase("  1.  " + this.GetStringByDataRow(ds, 1, "TsiName"), PdfHelper.smallFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "TsiDealerName"), pdfFont.normalChineseFont)) { BorderColor = BaseColor.BLACK, BorderColorTop = PdfHelper.blueColor, BorderWidth = 0.3f, BorderWidthTop = 1.5f }, bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Phrase("", pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);

                for (int i = 2; i < 20; i++)
                {
                    PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Phrase("  " + i + ".   " + this.GetStringByDataRow(ds, i, "TsiName"), PdfHelper.smallFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                    PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "TsiDealerName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase("", pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                }

                PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Phrase("  20.   " + this.GetStringByDataRow(ds, 20, "TsiName"), PdfHelper.smallFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "TsiDealerName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase("", pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);

                PdfHelper.AddPdfTable(doc, bodyTable);
                #endregion

                #region Signature
                PdfPTable signatureTable = new PdfPTable(3);
                signatureTable.SetWidths(new float[] { 55f, 35f, 10f });
                PdfHelper.InitPdfTableProperty(signatureTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { Colspan = 3, FixedHeight = 10f }, signatureTable, null, null);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { Rowspan = 6 }, signatureTable, null, null);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("", PdfHelper.timesFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT }, signatureTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { Rowspan = 6 }, signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Authorized Representative’s Signature", PdfHelper.timesFont)), signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(sign.From6RepName, PdfHelper.timesFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT }, signatureTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Representative’s Name", PdfHelper.timesFont)), signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(sign.From6RepTital, PdfHelper.timesFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT }, signatureTable, null, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Representative’s Title", PdfHelper.timesFont)), signatureTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfTable(doc, signatureTable);
                #endregion

                //return fileName;
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "发生错误！").Show();
                Console.WriteLine(ex.Message);
                //return string.Empty;
            }
            finally
            {
                doc.Close();
            }
            DownloadFileForDCMS(fileName, "IAF_Form_6.pdf", "DCMS");
        }

        private string GetStringByDataRow(DataSet ds, int rowNumber, string column)
        {
            string resultStr = string.Empty;
            if (ds.Tables != null && ds.Tables.Count > 0)
            {
                if (rowNumber <= ds.Tables[0].Rows.Count)
                {
                    if (ds.Tables[0].Rows[rowNumber - 1][column] != null)
                    {
                        resultStr = ds.Tables[0].Rows[rowNumber - 1][column].ToString();
                    }
                }
            }

            return resultStr;
        }

        protected void DownloadFileForDCMS(string filename, string downname, string documentName)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UploadFile\\" + documentName + "\\" + filename;

                Response.Clear();
                Response.Buffer = true;

                //以字符流的形式下载文件 
                System.IO.FileStream fs = new System.IO.FileStream(filename, System.IO.FileMode.Open);
                byte[] bytes = new byte[(int)fs.Length];
                fs.Read(bytes, 0, bytes.Length);
                fs.Close();
                Response.ContentType = "application/octet-stream";
                //通知浏览器下载文件而不是打开 
                Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(savename, System.Text.Encoding.UTF8));
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {

            }

        }
        #endregion
    }
}
