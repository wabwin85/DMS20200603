using System;
using System.Text;
using System.IO;
using NPOI.SS.UserModel;
using NPOI.HSSF.UserModel;
using NPOI.HPSF;
using DMS.Business;
using DMS.Common;
using DMS.Model;
using DMS.Business.Cache;
using System.Collections.Generic;
using System.Data;
using NPOI.SS.Util;
using DMS.Business.Contract;
using System.Collections;
using DMS.Model.Data;
using ThoughtWorks.QRCode.Codec;
using System.Drawing;

namespace DMS.Website.Pages.Contract
{
    public partial class PrintPage : System.Web.UI.Page
    {
        #region 公用
        private static HSSFWorkbook hssfworkbook;
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
        private IDealerMasters _dealerMasters = new DealerMasters();
        private IContractAmendmentService _amendment = new ContractAmendmentService();
        private IContractAppointmentService _appointment = new ContractAppointmentService();
        private IContractMaster _contract = new DMS.Business.ContractMaster();
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["ExportType"] != null && Request.QueryString["ExportType"].ToString().Equals("Authorization"))
                {
                    PrintDealerAuthorization();
                }
                else if (Request.QueryString["ExportType"] != null && Request.QueryString["ExportType"].ToString().Equals("HospitalAOP"))
                {
                    PrintDCMSHospitalAOP(Request.QueryString["ContractId"].ToString());
                }
                else
                {

                    if (Request.QueryString["ContractID"] != null && Request.QueryString["DealerID"] != null)
                    {
                        if (Request.QueryString["OperationType"] != null && Request.QueryString["OperationType"].ToString().Equals("Appointment"))
                        {
                            PrintOrderAgreement(Request.QueryString["ContractID"].ToString(), Request.QueryString["DealerID"].ToString());
                        }
                        else
                        {
                            PrintOrder(Request.QueryString["ContractID"].ToString(), Request.QueryString["DealerID"].ToString());
                        }
                    }
                }
            }
        }

        #region 补充协议
        private void PrintOrder(string ContractID, string DealerID)
        {
            string templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Supplementary_Letter.xls");

            FileStream file = new FileStream(templateName, FileMode.Open, FileAccess.Read);
            hssfworkbook = new HSSFWorkbook(file);
            GenerateData(ContractID, DealerID);

            //FileStream filein = new FileStream(@"test.xls", FileMode.Create);
            //hssfworkbook.Write(filein);

            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "Supplementary Letter.xls"));
            Response.Clear();
            GetExcelStream().WriteTo(Response.OutputStream);
            Response.Flush();
            Response.End();

        }

        private void GenerateData(string ContractID, string DealerID)
        {
            ISheet dataSheet = hssfworkbook.GetSheetAt(0);

            //获取页面数据
            Guid InstanceId = (ContractID == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(ContractID));
            Guid DMA_ID = (DealerID == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(DealerID));

            #region 绑定表头
            //PurchaseOrderHeader header = _business.GetPurchaseOrderHeaderById(InstanceId);
            ContractAmendment amd = _amendment.GetContractAmendmentByID(InstanceId);
            //经销商ID/名称
            DealerMaster dm = _dealerMasters.GetDealerMaster(DMA_ID);
            string dealerName = dm.ChineseName.Substring(dm.ChineseName.Length - 3, 3).Equals("-T1") ? dm.ChineseName.Substring(0, dm.ChineseName.Length - 3) : dm.ChineseName;
            dataSheet.GetRow(11).GetCell(1).SetCellValue("To: " + dm.EnglishName);
            dataSheet.GetRow(11).GetCell(4).SetCellValue("致：" + dealerName);

            dataSheet.GetRow(14).GetCell(1).SetCellValue("Re: Distributorship Agreement dated " + ConvterDateToEnglish(amd.CamAgreementEffectiveDate.Value));
            dataSheet.GetRow(14).GetCell(4).SetCellValue("Re: 关于" + ConvterDateToChinese(amd.CamAgreementEffectiveDate.Value) + "所签经销商协议的修改 ");

            dataSheet.GetRow(15).GetCell(1).SetCellValue("    Amendment [] dated " + ConvterDateToEnglish(amd.CamAmendmentEffectiveDate.Value));
            dataSheet.GetRow(15).GetCell(4).SetCellValue("  补充协议编号 [], 日期：" + ConvterDateToChinese(amd.CamAmendmentEffectiveDate.Value));

            dataSheet.GetRow(18).GetCell(1).SetCellValue("Genesis Medtech (Shanghai) Co., Ltd. (“蓝威”) and " + dm.EnglishName + "”) entered into an exclusive distributorship agreement (the “Agreement”) effective as of " + ConvterDateToEnglish(amd.CamAgreementEffectiveDate.Value) + " with an Expiration Date of " + ConvterDateToEnglish(amd.CamAgreementExpirationDate.Value) + ".");
            dataSheet.GetRow(18).GetCell(4).SetCellValue("蓝威医疗科技(上海)有限公司(以下简称为“蓝威”)和" + dm.ChineseName + "(以下简称为“经销商”)签署了一份 独家 销售协议(以下简称为“该协议”)，生效期为" + ConvterDateToChinese(amd.CamAgreementEffectiveDate.Value) + "，有效期限为" + ConvterDateToChinese(amd.CamAgreementExpirationDate.Value) + ".");

            dataSheet.GetRow(22).GetCell(1).SetCellValue("1. Territory – Schedule C.   Effective " + ConvterDateToEnglish(amd.CamAmendmentEffectiveDate.Value) + " , the authorized Territory under the Agreement shall be hereby amended to read as follows:");
            dataSheet.GetRow(22).GetCell(4).SetCellValue("1. 销售区域–C部分. 该协议中有关授权销售区域的内容将修改如下，并于" + ConvterDateToChinese(amd.CamAmendmentEffectiveDate.Value) + "开始生效:");


            #endregion

            #region 绑定产品明细
            DataTable dtHosList = _contractBll.GetContractTerritoryByContractId(new Guid(ContractID)).Tables[0];
            if (dtHosList.Rows.Count > 1)
            {
                InsertExcelDetailRows(dataSheet, dtHosList.Rows.Count - 1);
            }

            int rowNub = 26;

            for (int i = 0; i < dtHosList.Rows.Count; i++)
            {
                int a = i + 1;
                rowNub = rowNub + 1;
                dataSheet.GetRow(rowNub).GetCell(2).SetCellValue((a.ToString() + ". " + dtHosList.Rows[i]["HospitalENName"].ToString()));
                dataSheet.AddMergedRegion(new CellRangeAddress(rowNub, rowNub, 2, 2));

                dataSheet.GetRow(rowNub).GetCell(5).SetCellValue((a.ToString() + ". " + dtHosList.Rows[i]["HospitalName"].ToString()));
                dataSheet.AddMergedRegion(new CellRangeAddress(rowNub, rowNub, 5, 5));
            }

            int rowNub2 = 51;
            rowNub2 = rowNub2 + dtHosList.Rows.Count;
            dataSheet.GetRow(rowNub2).GetCell(2).SetCellValue(dm.EnglishName);
            dataSheet.GetRow(rowNub2 + 1).GetCell(2).SetCellValue(dealerName);
            #endregion

        }

        private MemoryStream GetExcelStream()
        {
            MemoryStream file = new MemoryStream();
            hssfworkbook.Write(file);
            return file;
        }

        private void InsertExcelDetailRows(ISheet dataSheet, int rowCount)
        {
            // '将fromRowIndex行以后的所有行向下移动rowCount行，保留行高和格式
            dataSheet.ShiftRows(28, dataSheet.LastRowNum, rowCount, true, false);

            // '取得源格式行
            IRow rowSource = dataSheet.GetRow(27);
            ICellStyle rowstyle = rowSource.RowStyle;

            for (int rowIndex = 28; rowIndex < 28 + rowCount; rowIndex++)
            {
                // '新建插入行
                IRow rowInsert = dataSheet.CreateRow(rowIndex);
                //rowInsert.RowStyle = rowstyle;
                rowInsert.Height = rowSource.Height;
                for (int colIndex = 0; colIndex < rowSource.LastCellNum; colIndex++)
                {
                    //'新建插入行的所有单元格，并复制源格式行相应单元格的格式
                    ICell cellSource = rowSource.GetCell(colIndex);
                    ICell cellInsert = rowInsert.CreateCell(colIndex);
                    //cellInsert.CellStyle = cellSource.CellStyle;
                }
            }
        }

        private string ConvterDateToEnglish(DateTime strDate)
        {
            string retValue = "";
            int month = strDate.Month;
            switch (month)
            {
                case 1:
                    retValue = "January";
                    break;
                case 2:
                    retValue = "February";
                    break;
                case 3:
                    retValue = "March";
                    break;
                case 4:
                    retValue = "April";
                    break;
                case 5:
                    retValue = "May";
                    break;
                case 6:
                    retValue = "June";
                    break;
                case 7:
                    retValue = "July";
                    break;
                case 8:
                    retValue = "August";
                    break;
                case 9:
                    retValue = "September";
                    break;
                case 10:
                    retValue = "October";
                    break;
                case 11:
                    retValue = "November";
                    break;
                case 12:
                    retValue = "December";
                    break;

                default:
                    retValue = "0";
                    break;
            }

            retValue = (retValue + " " + strDate.Day + ", " + strDate.Year);
            return retValue;
        }

        private string ConvterDateToChinese(DateTime strDate)
        {
            return strDate.Year + "年" + strDate.Month + "月" + strDate.Day + "日";
        }
        #endregion

        #region 经销商协议
        private void PrintOrderAgreement(string ContractID, string DealerID)
        {
            string templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Template_DealerAgreement.xls");

            FileStream file = new FileStream(templateName, FileMode.Open, FileAccess.Read);
            hssfworkbook = new HSSFWorkbook(file);
            GenerateDataAgreement(ContractID, DealerID);

            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "Dealer Agreement.xls"));
            Response.Clear();
            GetExcelStream().WriteTo(Response.OutputStream);
            Response.Flush();
            Response.End();
        }

        private void GenerateDataAgreement(string ContractID, string DealerID)
        {
            //获取页面数据
            Guid InstanceId = (ContractID == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(ContractID));
            Guid DMA_ID = (DealerID == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(DealerID));
            ContractMasterDM conMast = _contract.GetContractMasterByDealerID(DMA_ID);

            ContractAppointment appointment = _appointment.GetContractAppointmentByID(InstanceId);

            DealerMaster dm = _dealerMasters.GetDealerMaster(DMA_ID);
            string dealerName = dm.ChineseName.Substring(dm.ChineseName.Length - 3, 3).Equals("-T1") ? dm.ChineseName.Substring(0, dm.ChineseName.Length - 3) : dm.ChineseName;

            //DealerMaster dm = _dealerMasters.GetDealerMaster(DMA_ID);

            #region 维护 Sheet1
            ISheet dataSheet = hssfworkbook.GetSheetAt(0);
            dataSheet.GetRow(182).GetCell(1).SetCellValue(dm.EnglishName);
            dataSheet.GetRow(183).GetCell(1).SetCellValue("(" + dealerName + ")");
            #endregion

            #region 维护Sheet2
            ISheet dataSheet2 = hssfworkbook.GetSheetAt(1);
            dataSheet2.GetRow(14).GetCell(1).SetCellValue(dm.EnglishName);
            dataSheet2.GetRow(18).GetCell(1).SetCellValue(conMast.CmAddress);
            dataSheet2.GetRow(23).GetCell(1).SetCellValue("Tel （电话）: " + conMast.CmTelephony);
            dataSheet2.GetRow(26).GetCell(1).SetCellValue("Fax（传真）: " + conMast.CmFax);
            dataSheet2.GetRow(29).GetCell(1).SetCellValue("E-mail（电子邮件）: " + conMast.CmEmail);
            dataSheet2.GetRow(32).GetCell(1).SetCellValue("Contact person（联系人）: " + conMast.CmContactPerson);

            dataSheet2.GetRow(39).GetCell(1).SetCellValue("   " + ConvterDateToEnglish(appointment.CapEffectiveDate.Value) + "(" + ConvterDateToChinese(appointment.CapEffectiveDate.Value) + ")");
            dataSheet2.GetRow(42).GetCell(1).SetCellValue("   " + ConvterDateToEnglish(appointment.CapExpirationDate.Value) + "(" + ConvterDateToChinese(appointment.CapExpirationDate.Value) + ")");
            #endregion

            #region 绑定授权医院
            int rowNub = 92;

            DataTable dtHosList = _contractBll.GetContractTerritoryByContractId(new Guid(ContractID)).Tables[0];
            if (dtHosList.Rows.Count > 1)
            {
                InsertExcelDetailRowsAmendment(rowNub, dataSheet2, dtHosList.Rows.Count);
            }

            for (int i = 0; i < dtHosList.Rows.Count; i++)
            {
                int a = i + 1;
                rowNub = rowNub + 1;
                dataSheet2.GetRow(rowNub).GetCell(1).SetCellValue((a.ToString() + ". " + dtHosList.Rows[i]["HospitalENName"].ToString()));
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub, rowNub, 1, 2));

                dataSheet2.GetRow(rowNub).GetCell(4).SetCellValue((a.ToString() + ". " + dtHosList.Rows[i]["HospitalName"].ToString()));
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub, rowNub, 4, 5));
            }

            int rowNub2 = 112;
            rowNub2 = rowNub2 + dtHosList.Rows.Count;
            DataTable dtQuotas = _contractBll.GetAopDealersByQueryByContractId(new Guid(ContractID)).Tables[0];
            for (int i = 0; i < dtQuotas.Rows.Count; i++)
            {
                InsertExcelDetailRowsAmendment(rowNub2, dataSheet2, 8);

                rowNub2 = rowNub2 + 1;
                string year = dtQuotas.Rows[i]["Year"].ToString();
                dataSheet2.GetRow(rowNub2).GetCell(1).SetCellValue("January 1," + year + " - March 31," + year + ": " + dtQuotas.Rows[i]["Q1"].ToString() + " RMB");
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub2, rowNub2, 1, 2));
                dataSheet2.GetRow(rowNub2).GetCell(4).SetCellValue(year + "年1月1日 – " + year + "年3月31日： " + dtQuotas.Rows[i]["Q1"].ToString() + " RMB");
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub2, rowNub2, 4, 5));

                dataSheet2.GetRow(rowNub2 + 2).GetCell(1).SetCellValue("April 1," + year + " - June 30," + year + ": " + dtQuotas.Rows[i]["Q2"].ToString() + " RMB");
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub2 + 2, rowNub2 + 2, 1, 2));
                dataSheet2.GetRow(rowNub2 + 2).GetCell(4).SetCellValue(year + "年4月1日 – " + year + "年6月30日： " + dtQuotas.Rows[i]["Q2"].ToString() + " RMB");
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub2 + 2, rowNub2 + 2, 4, 5));

                dataSheet2.GetRow(rowNub2 + 4).GetCell(1).SetCellValue("July 1," + year + " - September 30," + year + ": " + dtQuotas.Rows[i]["Q3"].ToString() + " RMB");
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub2 + 4, rowNub2 + 4, 1, 2));
                dataSheet2.GetRow(rowNub2 + 4).GetCell(4).SetCellValue(year + "年7月1日 – " + year + "年9月30日： " + dtQuotas.Rows[i]["Q3"].ToString() + " RMB");
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub2 + 4, rowNub2 + 4, 4, 5));

                dataSheet2.GetRow(rowNub2 + 6).GetCell(1).SetCellValue("October 1," + year + " - December 31," + year + ": " + dtQuotas.Rows[i]["Q4"].ToString() + " RMB");
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub2 + 6, rowNub2 + 6, 1, 2));
                dataSheet2.GetRow(rowNub2 + 6).GetCell(4).SetCellValue(year + "年10月1日 – " + year + "年12月12日： " + dtQuotas.Rows[i]["Q4"].ToString() + " RMB");
                dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub2 + 6, rowNub2 + 6, 4, 5));

            }

            int rowNub3 = 126;
            rowNub3 = rowNub3 + dtHosList.Rows.Count + (dtQuotas.Rows.Count * 8);
            string Account = "";
            string CreditLimit = "";
            string SecurityDeposit = "";

            if (appointment.CapAccount != null)
            {
                Account = appointment.CapAccount;
            }
            else
            {
                Account = "0";
            }
            if (appointment.CapCreditLimit != null)
            {
                CreditLimit = appointment.CapCreditLimit;
            }
            else
            {
                CreditLimit = "0";
            }
            if (appointment.CapSecurityDeposit != null)
            {
                SecurityDeposit = appointment.CapSecurityDeposit;
            }
            else
            {
                SecurityDeposit = "0";
            }
            string EngishPay = "Payment for Products is due within " + Account + " days after date of BSC SAP system invoice on open account as long as DISTRIBUTOR’s credit remains good, payments to BSC are made on time, and the total amount owed by DISTRIBUTOR to BSC is within the credit limits determined by BSC from time to time.  DISTRIBUTOR’s credit limit as of the effective date of this Agreement shall be RMB " + CreditLimit + " (include VAT). DISTRIBUTOR shall secure open account payment terms with a RMB " + SecurityDeposit + " (bank guarantee) security deposit. BSC reserves the right to require DISTRIBUTOR to provide additional security for the amount of such credit limit as a condition to making sales on open account terms.  BSC shall have the right to adjust DISTRIBUTOR’s payment terms and credit limits from time to time.";
            string ChinesePay = "只要经销商的信用保持良好、对蓝威的付款准时，并且经销商对蓝威应付的总金额限制在由蓝威不定期地确定的信用限额范围内，产品的付款就在蓝威 ERP系统发票日后" + Account + "天内到期应付。自本协议生效日起，经销商的信用限额为人民币" + CreditLimit + "（含增值税）。经销商应提供金额为人民币" + SecurityDeposit + "的银行保函作为安全保证。蓝威有权要求经销商为该信用限额提供充分担保，作为使用记账方式进行销售的条件。蓝威有权不定期地调整经销商的支付条款及信用限额。";
            dataSheet2.GetRow(rowNub3).GetCell(1).SetCellValue(EngishPay);
            dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub3, rowNub3, 1, 2));
            dataSheet2.GetRow(rowNub3).GetCell(4).SetCellValue(ChinesePay);
            dataSheet2.AddMergedRegion(new CellRangeAddress(rowNub3, rowNub3, 4, 5));

            #endregion



        }

        private void InsertExcelDetailRowsAmendment(int startRow, ISheet dataSheet, int rowCount)
        {
            // '将fromRowIndex行以后的所有行向下移动rowCount行，保留行高和格式
            dataSheet.ShiftRows(startRow, dataSheet.LastRowNum, rowCount, true, false);

            // '取得源格式行
            IRow rowSource = dataSheet.GetRow(startRow - 1);
            ICellStyle rowstyle = rowSource.RowStyle;

            for (int rowIndex = startRow; rowIndex < startRow + rowCount; rowIndex++)
            {
                // '新建插入行
                IRow rowInsert = dataSheet.CreateRow(rowIndex);
                //rowInsert.RowStyle = rowstyle;
                rowInsert.Height = rowSource.Height;
                for (int colIndex = 0; colIndex < rowSource.LastCellNum; colIndex++)
                {
                    //'新建插入行的所有单元格，并复制源格式行相应单元格的格式
                    ICell cellSource = rowSource.GetCell(colIndex);
                    ICell cellInsert = rowInsert.CreateCell(colIndex);
                    //cellInsert.CellStyle = cellSource.CellStyle;
                }
            }
        }

        #endregion

        #region 合同授权书导出
        private void PrintDealerAuthorization()
        {
            string contractId = Request.QueryString["contractId"].ToString();
            string dealerId = Request.QueryString["dealerId"].ToString();
            string dealerName = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(Request.QueryString["dealerName"].ToString()));
            string dealerType = Request.QueryString["dealerType"].ToString();
            string parmetType = Request.QueryString["parmetType"].ToString();
            string Identifier = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(Request.QueryString["Identifier"].ToString()));
            string conUser = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(Request.QueryString["conUser"].ToString()));
            string conTel = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(Request.QueryString["conTel"].ToString()));
            DateTime begindate = Convert.ToDateTime(Request.QueryString["begindate"]);
            DateTime enddate = Convert.ToDateTime(Request.QueryString["enddate"]);
            string subu = Request.QueryString["SuBu"].ToString(); 
            string templateName = "";
            int authType = _contractBll.CheckAuthorizationType(contractId);
            if (authType == 0)
            {
                templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Template_DealerAuthorization.xls");
                FileStream file = new FileStream(templateName, FileMode.Open, FileAccess.Read);
                hssfworkbook = new HSSFWorkbook(file);
                GetDealerAuthorization(contractId, dealerId, dealerName, dealerType, parmetType, Identifier, conUser, conTel, begindate, enddate, subu);
            }
            else { 
                templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Template_DealerAuthorizationProduct.xls");
                FileStream file = new FileStream(templateName, FileMode.Open, FileAccess.Read);
                hssfworkbook = new HSSFWorkbook(file);
                GetDealerAuthorizationProduct(contractId, dealerId, dealerName, dealerType, parmetType, Identifier, conUser, conTel, begindate, enddate, subu);
            }
           
            

            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "DealerAuthorization.xls"));
            Response.Clear();
            GetExcelStream().WriteTo(Response.OutputStream);
            Response.Flush();
            Response.End();

        }

        private void GetDealerAuthorization(string contractId, string dealerId, string dealerName, string dealerType, string parmetType, string Identifier, string conUser, string conTel, DateTime beginDate, DateTime endDate,string subu)
        {
            Guid InstanceId = (contractId == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(contractId));
            Guid DealerId = (dealerId == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(dealerId));
            dealerName = dealerName.Substring(dealerName.Length - 3, 3).Equals("-T1") ? dealerName.Substring(0, dealerName.Length - 3) : dealerName;
            string endtime = "";
            endtime = "本授权书授权期限为 " + beginDate.Year.ToString() + " 年 " + beginDate.Month.ToString() + " 月 " + beginDate.Day.ToString() + " 日 ";
            endtime += "至 " + endDate.Year.ToString() + " 年 " + endDate.Month.ToString() + " 月 " + endDate.Day.ToString() + " 日。";

            bool IsArea = false;

            Hashtable obj = new Hashtable();
            obj.Add("ContractId", InstanceId);
            obj.Add("ParmetType", parmetType);
            DataTable dtParmet = _contractBll.GetAuthorCodeAndDivName(obj).Tables[0];

            ISheet dataSheet = hssfworkbook.GetSheetAt(0);

            dataSheet.GetRow(2).GetCell(1).SetCellValue("【编号：" + Identifier.ToString() + "】");
            dataSheet.GetRow(18).GetCell(1).SetCellValue(DateTime.Now.Year.ToString() + "年 " + DateTime.Now.Month.ToString() + "月 " + DateTime.Now.Day + "日 ");

            string BrandName = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParmet.Rows[0]["BrandName"].ToString()));
            string ProductLine = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParmet.Rows[0]["DivName"].ToString()));
            string pctName = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParmet.Rows[0]["AuthorNameString"].ToString() == "" ? "" : dtParmet.Rows[0]["AuthorNameString"].ToString()));

            if (!dealerType.Equals(DealerType.T2.ToString()))
            {
                //一级/平台
                DataTable provinces = _contractBll.GetProvincesForAreaSelected(obj).Tables[0];
                string terr = "";
                if (provinces.Rows.Count > 0)
                {
                    for (int i = 0; i < provinces.Rows.Count; i++)
                    {
                        terr += (provinces.Rows[i]["Description"].ToString() + "，");
                    }
                    IsArea = true;
                }
                else
                {
                    terr = "（授权区域详见下述清单）";
                }

                dataSheet.GetRow(8).GetCell(1).SetCellValue("    本公司 蓝威医疗科技(上海)有限公司 为提高产品配送效率，向医疗机构提供更为优质高效的服务, 特授权 " + dealerName.ToString() + "为本公司在 " + terr + " 的配送企业，负责承担在授权时限内对我司经销的 "+BrandName+"品牌"+ ProductLine.ToString() + " " + pctName.ToString() + " 的配送和结算工作。 " + dealerName.ToString() + " 将保证及时供货并提供全面、完善的服务。");
                dataSheet.GetRow(17).GetCell(1).SetCellValue("蓝威医疗科技(上海)有限公司");

                dataSheet.GetRow(15).GetCell(1).SetCellValue(endtime);
            }
            else
            {
                DataTable dtParent = _dealerMasters.GetParentDealer(DealerId).Tables[0];
                string dealerT2 = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParent.Rows[0]["DealerName"].ToString()));
                string ParentDealerT2 = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParent.Rows[0]["ParentDealerName"].ToString()));

                dataSheet.GetRow(8).GetCell(1).SetCellValue("    本公司" + ParentDealerT2.ToString() + " 为提高产品配送效率，向医疗机构提供更为优质高效的服务, 特授权 " + dealerT2.ToString() + " 为本公司在 （授权医院详见清单） 的配送企业，负责承担在授权时限内对我司经销的 " + BrandName + "品牌" + ProductLine.ToString() + " " + pctName.ToString() + " 的配送和结算工作。 " + dealerT2.ToString() + " 将保证及时供货并提供全面、完善的服务。");
                dataSheet.GetRow(17).GetCell(1).SetCellValue(ParentDealerT2.ToString());

                if (!(conUser == string.Empty || conUser.Equals("")))
                {

                    endtime += ParentDealerT2.ToString() + " 联系人和方式：" + conUser.ToString() + "  电话：" + conTel.ToString();
                }

                dataSheet.GetRow(15).GetCell(1).SetCellValue(endtime.ToString());
            }

            if (IsArea)
            {
                DataTable dtExcHospital = _contractBll.GetPartAreaExcHospitalTemp(obj).Tables[0];
                if (dtExcHospital.Rows.Count > 1)
                {
                    InsertExcelHospitalRows(dataSheet, dtExcHospital.Rows.Count - 1);
                }

                int rowNub = 9;
                dataSheet.GetRow(rowNub).GetCell(1).SetCellValue("授权区域内以下医院除外：");

                for (int i = 0; i < dtExcHospital.Rows.Count; i++)
                {
                    int a = i + 1;
                    rowNub = rowNub + 1;
                    string stringHospital = a.ToString() + ". " + dtExcHospital.Rows[i]["HosHospitalName"].ToString();
                    dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(stringHospital.ToString());
                }
            }
            else
            {
                //DataTable dtTerritorynew = _contractBll.GetContractTerritoryByContractId(InstanceId).Tables[0];
                DataTable dtTerritorynew = _contractBll.GetDistinctTerritoryByContractId(InstanceId).Tables[0];
                if (dtTerritorynew.Rows.Count > 1)
                {
                    InsertExcelHospitalRows(dataSheet, dtTerritorynew.Rows.Count - 1);
                }

                int rowNub = 9;

                for (int i = 0; i < dtTerritorynew.Rows.Count; i++)
                {
                    int a = i + 1;
                    rowNub = rowNub + 1;
                    string stringHospital = a.ToString() + ". " + dtTerritorynew.Rows[i]["HospitalName"].ToString();
                    if (!dtTerritorynew.Rows[i]["DepartRemark"].ToString().Equals(""))
                    {
                        stringHospital += (" (" + dtTerritorynew.Rows[i]["DepartRemark"].ToString() + ")");
                    }

                    dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(stringHospital.ToString());
                }
            }

            QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();
            qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
            qrCodeEncoder.QRCodeScale = 3;
            qrCodeEncoder.QRCodeVersion = 0;
            qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.L;
            System.Drawing.Image image = qrCodeEncoder.Encode(InstanceId.ToString());
            string filepath = Page.Server.MapPath(@"..\..\") + @"Upload\QR\" + Guid.NewGuid().ToString() + ".png";
            System.IO.FileStream fs = new System.IO.FileStream(filepath, System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.Write);
            image.Save(fs, System.Drawing.Imaging.ImageFormat.Jpeg);

            fs.Close();
            image.Dispose();

            FileStream fs2 = new FileStream(filepath, FileMode.Open, FileAccess.Read);

            byte[] Content = new byte[Convert.ToInt32(fs2.Length)];
            fs2.Read(Content, 0, Convert.ToInt32(fs2.Length));
            int pictureIdx = hssfworkbook.AddPicture(Content, NPOI.SS.UserModel.PictureType.JPEG);
            HSSFPatriarch patriarch = (HSSFPatriarch)dataSheet.CreateDrawingPatriarch();
            HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0, 0, 0, 14, 1, 17, 5);
            HSSFPicture pict = (HSSFPicture)patriarch.CreatePicture(anchor, pictureIdx);
            //pict.Resize();

            fs2.Close();
        }
        private void InsertExcelHospitalRows(ISheet dataSheet, int rowCount)
        {
            // '将fromRowIndex行以后的所有行向下移动rowCount行，保留行高和格式
            dataSheet.ShiftRows(11, dataSheet.LastRowNum, rowCount, true, false);

            // '取得源格式行
            IRow rowSource = dataSheet.GetRow(10);
            ICellStyle rowstyle = rowSource.RowStyle;

            for (int rowIndex = 11; rowIndex < 11 + rowCount; rowIndex++)
            {
                // '新建插入行
                IRow rowInsert = dataSheet.CreateRow(rowIndex);
                //rowInsert.RowStyle = rowstyle;
                rowInsert.Height = rowSource.Height;
                for (int colIndex = 0; colIndex < rowSource.LastCellNum; colIndex++)
                {
                    //'新建插入行的所有单元格，并复制源格式行相应单元格的格式
                    ICell cellSource = rowSource.GetCell(colIndex);
                    ICell cellInsert = rowInsert.CreateCell(colIndex);
                    //cellInsert.CellStyle = cellSource.CellStyle;
                }
            }
        }

        private void GetDealerAuthorizationProduct(string contractId, string dealerId, string dealerName, string dealerType, string parmetType, string Identifier, string conUser, string conTel, DateTime beginDate, DateTime endDate,string subu)
        {
              Guid InstanceId = (contractId == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(contractId));
            Guid DealerId = (dealerId == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(dealerId));
            dealerName = dealerName.Substring(dealerName.Length - 3, 3).Equals("-T1") ? dealerName.Substring(0, dealerName.Length - 3) : dealerName;
            string endtime = "";
            endtime = "本授权书授权期限为 " + beginDate.Year.ToString() + " 年 " + beginDate.Month.ToString() + " 月 " + beginDate.Day.ToString() + " 日 ";
            endtime += "至 " + endDate.Year.ToString() + " 年 " + endDate.Month.ToString() + " 月 " + endDate.Day.ToString() + " 日。";

            bool IsArea = false;

            Hashtable obj = new Hashtable();
            obj.Add("ContractId", InstanceId);
            obj.Add("ParmetType", parmetType);
            DataTable dtParmet = _contractBll.GetAuthorCodeAndDivName(obj).Tables[0];

            ISheet dataSheet = hssfworkbook.GetSheetAt(0);

            dataSheet.GetRow(2).GetCell(1).SetCellValue("【编号：" + Identifier.ToString() + "】");
            dataSheet.GetRow(18).GetCell(1).SetCellValue(DateTime.Now.Year.ToString() + "年 " + DateTime.Now.Month.ToString() + "月 " + DateTime.Now.Day + "日 ");

            string BrandName = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParmet.Rows[0]["BrandName"].ToString()));
            string ProductLine = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParmet.Rows[0]["DivName"].ToString()));
            string pctName = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParmet.Rows[0]["AuthorNameString"].ToString() == "" ? "" : dtParmet.Rows[0]["AuthorNameString"].ToString()));

            if (!dealerType.Equals(DealerType.T2.ToString()))
            {
                //一级/平台

                dataSheet.GetRow(8).GetCell(1).SetCellValue("    本公司 蓝威医疗科技(上海)有限公司 为提高产品配送效率，向医疗机构提供更为优质高效的服务, 特授权 " + dealerName.ToString() + "为本公司在 （授权区域详见下述清单） 的配送企业，负责承担在授权时限内对我司经销的 " + BrandName + "品牌" + ProductLine.ToString() + " （授权产品如下清单） 的配送和结算工作。 " + dealerName.ToString() + " 将保证及时供货并提供全面、完善的服务。");
                dataSheet.GetRow(17).GetCell(1).SetCellValue("蓝威医疗科技(上海)有限公司");

                dataSheet.GetRow(15).GetCell(1).SetCellValue(endtime);
            }
            else
            {
                DataTable dtParent = _dealerMasters.GetParentDealer(DealerId).Tables[0];
                string dealerT2 = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParent.Rows[0]["DealerName"].ToString()));
                string ParentDealerT2 = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(dtParent.Rows[0]["ParentDealerName"].ToString()));

                dataSheet.GetRow(8).GetCell(1).SetCellValue("    本公司" + ParentDealerT2.ToString() + " 为提高产品配送效率，向医疗机构提供更为优质高效的服务, 特授权 " + dealerT2.ToString() + " 为本公司在 （授权医院详见清单） 的配送企业，负责承担在授权时限内对我司经销的 " + BrandName + "品牌" + ProductLine.ToString() + " （授权产品如下清单） 的配送和结算工作。 " + dealerT2.ToString() + " 将保证及时供货并提供全面、完善的服务。");
                dataSheet.GetRow(17).GetCell(1).SetCellValue(ParentDealerT2.ToString());

                if (!(conUser == string.Empty || conUser.Equals("")))
                {

                    endtime += ParentDealerT2.ToString() + " 联系人和方式：" + conUser.ToString() + "  电话：" + conTel.ToString();
                }

                dataSheet.GetRow(15).GetCell(1).SetCellValue(endtime.ToString());
            }

            if (IsArea)
            {
                DataTable dtAreat = _contractBll.GetProductForAreaSelected(obj).Tables[0];
                DataTable dtExcHospital = _contractBll.GetPartAreaExcHospitalTemp(obj).Tables[0];
                if (dtAreat.Rows.Count > 1)
                {
                    InsertExcelHospitalRows(dataSheet, dtAreat.Rows.Count - 1 + dtExcHospital.Rows.Count);
                }

                int rowNub = 9;
                dataSheet.GetRow(rowNub).GetCell(1).SetCellValue("授权区域如下：");
                for (int i = 0; i < dtAreat.Rows.Count; i++)
                {
                    int a = i + 1;
                    rowNub = rowNub + 1;
                    string stringHospital = a.ToString() + ". " + dtAreat.Rows[i]["Description"].ToString()+":"+ dtAreat.Rows[i]["ProductName"].ToString();
                   
                    dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(stringHospital.ToString());
                }

                rowNub = 9+ dtAreat.Rows.Count+1;
                dataSheet.GetRow(rowNub).GetCell(1).SetCellValue("授权区域内以下医院除外：");

                for (int i = 0; i < dtExcHospital.Rows.Count; i++)
                {
                    int a = i + 1;
                    rowNub = rowNub + 1;
                    string stringHospital = a.ToString() + ". " + dtExcHospital.Rows[i]["HosHospitalName"].ToString();
                    dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(stringHospital.ToString());
                }
            }
            else
            {
                //DataTable dtTerritorynew = _contractBll.GetContractTerritoryByContractId(InstanceId).Tables[0];
                DataTable dtTerritorynew = _contractBll.TerritoryProductByContractId(InstanceId, subu).Tables[0];
                if (dtTerritorynew.Rows.Count > 1)
                {
                    InsertExcelHospitalRows(dataSheet, dtTerritorynew.Rows.Count - 1);
                }

                int rowNub = 9;

                for (int i = 0; i < dtTerritorynew.Rows.Count; i++)
                {
                    int a = i + 1;
                    rowNub = rowNub + 1;
                    string stringHospital = a.ToString() + ". " + dtTerritorynew.Rows[i]["HospitalName"].ToString();
                    //string stringProduct = dtTerritorynew.Rows[i]["ProductName"].ToString();

                    if (!dtTerritorynew.Rows[i]["DepartRemark"].ToString().Equals(""))
                    {
                        stringHospital += (" (" + dtTerritorynew.Rows[i]["DepartRemark"].ToString() + ")");
                    }
                    stringHospital += (":"+ dtTerritorynew.Rows[i]["ProductName"].ToString());

                    dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(stringHospital.ToString());
                }
            }

            QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();
            qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
            qrCodeEncoder.QRCodeScale = 3;
            qrCodeEncoder.QRCodeVersion = 0;
            qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.L;
            System.Drawing.Image image = qrCodeEncoder.Encode(InstanceId.ToString());
            string filepath = Page.Server.MapPath(@"..\..\") + @"Upload\QR\" + Guid.NewGuid().ToString() + ".png";
            System.IO.FileStream fs = new System.IO.FileStream(filepath, System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.Write);
            image.Save(fs, System.Drawing.Imaging.ImageFormat.Jpeg);

            fs.Close();
            image.Dispose();

            FileStream fs2 = new FileStream(filepath, FileMode.Open, FileAccess.Read);

            byte[] Content = new byte[Convert.ToInt32(fs2.Length)];
            fs2.Read(Content, 0, Convert.ToInt32(fs2.Length));
            int pictureIdx = hssfworkbook.AddPicture(Content, NPOI.SS.UserModel.PictureType.JPEG);
            HSSFPatriarch patriarch = (HSSFPatriarch)dataSheet.CreateDrawingPatriarch();
            HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0, 0, 0, 14, 1, 17, 5);
            HSSFPicture pict = (HSSFPicture)patriarch.CreatePicture(anchor, pictureIdx);
            //pict.Resize();

            fs2.Close();
        }

        #endregion

        #region 流程中经销商医院指标导出
        private void PrintDCMSHospitalAOP(string ContractId)
        {
            string templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Template_DealerHospitalAOP.xls");

            FileStream file = new FileStream(templateName, FileMode.Open, FileAccess.Read);
            hssfworkbook = new HSSFWorkbook(file);
            BindHospitalAOP(ContractId);

            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "DealerHospitalAOP.xls"));
            Response.Clear();
            GetExcelStream().WriteTo(Response.OutputStream);
            Response.Flush();
            Response.End();
        }

        private void BindHospitalAOP(string ContractId)
        {
            ISheet dataSheet = hssfworkbook.GetSheetAt(0);
            int rowNub = 0;
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", ContractId);
            DataTable dt = _contractBll.ExportAopDealersHospitalByQuery(obj).Tables[0];
            if (dt.Rows.Count > 1)
            {
                InsertExcelDetailRowsAmendment(rowNub + 1, dataSheet, dt.Rows.Count);
            }

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                rowNub = rowNub + 1;
                dataSheet.GetRow(rowNub).GetCell(0).SetCellValue(dt.Rows[i][0].ToString());
                dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(dt.Rows[i][1].ToString());
                dataSheet.GetRow(rowNub).GetCell(2).SetCellValue(dt.Rows[i][2].ToString());
                dataSheet.GetRow(rowNub).GetCell(3).SetCellValue(dt.Rows[i][3].ToString());
                dataSheet.GetRow(rowNub).GetCell(4).SetCellValue(dt.Rows[i][4].ToString());
                dataSheet.GetRow(rowNub).GetCell(5).SetCellValue(dt.Rows[i][5].ToString());
                dataSheet.GetRow(rowNub).GetCell(6).SetCellValue(dt.Rows[i][6].ToString());
                dataSheet.GetRow(rowNub).GetCell(7).SetCellValue(dt.Rows[i][7].ToString());
                dataSheet.GetRow(rowNub).GetCell(8).SetCellValue(dt.Rows[i][8].ToString());
                dataSheet.GetRow(rowNub).GetCell(9).SetCellValue(dt.Rows[i][9].ToString());
                dataSheet.GetRow(rowNub).GetCell(10).SetCellValue(dt.Rows[i][10].ToString());
                dataSheet.GetRow(rowNub).GetCell(11).SetCellValue(dt.Rows[i][11].ToString());
                dataSheet.GetRow(rowNub).GetCell(12).SetCellValue(dt.Rows[i][12].ToString());
                dataSheet.GetRow(rowNub).GetCell(13).SetCellValue(dt.Rows[i][13].ToString());
                dataSheet.GetRow(rowNub).GetCell(14).SetCellValue(dt.Rows[i][14].ToString());
                dataSheet.GetRow(rowNub).GetCell(15).SetCellValue(dt.Rows[i][15].ToString());
                dataSheet.GetRow(rowNub).GetCell(16).SetCellValue(dt.Rows[i][16].ToString());
                dataSheet.GetRow(rowNub).GetCell(17).SetCellValue(dt.Rows[i][17].ToString());
            }
        }
        #endregion

    }
}
