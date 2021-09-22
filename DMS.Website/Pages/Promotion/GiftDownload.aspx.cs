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

namespace DMS.Website.Pages.Promotion
{
    public partial class GiftDownload : System.Web.UI.Page
    {
        #region 公用
        private static HSSFWorkbook hssfworkbook;
        private IGiftMaintainBLL _business = new GiftMaintainBLL();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["ExportType"] != null && Request.QueryString["BUName"] != null && Request.QueryString["Period"] != null && Request.QueryString["CalPeriod"] != null)
                {

                    DownloadGift(Request.QueryString["BUName"].ToString(), Request.QueryString["Period"].ToString(), Request.QueryString["CalPeriod"].ToString(), Request.QueryString["ExportType"].ToString());
                }
            }
        }

        private void DownloadGift(string BUName, string Period, string CalPeriod, string ExportType)
        {
            string templateName = "";
            if (ExportType == "赠品")
            {
                templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Gift.xls");
            }
            else if (ExportType == "积分")
            {
                templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Point.xls");
            }

            FileStream file = new FileStream(templateName, FileMode.Open, FileAccess.Read);
            hssfworkbook = new HSSFWorkbook(file);
            GenerateDataGift(BUName, Period, CalPeriod, ExportType);
            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "GiftCheck.xls"));
            Response.Clear();
            GetExcelStream().WriteTo(Response.OutputStream);
            Response.Flush();
            Response.End();

        }

        private void GenerateDataGift(string BUName, string Period, string CalPeriod, string ExportType)
        {
            ISheet dataSheet = hssfworkbook.GetSheetAt(0);
            //ISheet dataSheetDetail = hssfworkbook.GetSheetAt(1);
            #region 绑定表头
            Hashtable obj = new Hashtable();
            obj.Add("BUName", BUName);
            obj.Add("Period", Period);
            obj.Add("CalPeriod", CalPeriod);

            DataSet queryDs = new DataSet();
            if (ExportType == "赠品")
            {
                queryDs = _business.GetGiftResult(obj);
            }
            else if (ExportType == "积分")
            {
                queryDs = _business.GetPointResult(obj);
            }

            DataTable dataHead = queryDs.Tables[0].Copy();
            //DataTable dataDetail = queryDs.Tables[2].Copy();

            #endregion

            #region 绑定汇总表
            if (dataHead.Rows.Count > 0)
            {
                InsertExcelDetailRows(dataSheet, dataHead.Rows.Count);
            }

            if (ExportType == "赠品")
            {
                int rowNub = 0;
                for (int i = 0; i < dataHead.Rows.Count; i++)
                {
                    rowNub = rowNub + 1;
                    dataSheet.GetRow(rowNub).GetCell(0).SetCellValue(dataHead.Rows[i]["BU"] != null ? dataHead.Rows[i]["BU"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(dataHead.Rows[i]["Period"] != null ? dataHead.Rows[i]["Period"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(2).SetCellValue(dataHead.Rows[i]["PolicyNo"] != null ? dataHead.Rows[i]["PolicyNo"].ToString() : "");
                    //dataSheet.GetRow(rowNub).GetCell(3).SetCellValue(dataHead.Rows[i]["PresentType"] != null ? dataHead.Rows[i]["PresentType"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(3).SetCellValue(dataHead.Rows[i]["ParentDealerCode"] != null ? dataHead.Rows[i]["ParentDealerCode"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(4).SetCellValue(dataHead.Rows[i]["ParentDealerName"] != null ? dataHead.Rows[i]["ParentDealerName"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(5).SetCellValue(dataHead.Rows[i]["DealerCode"] != null ? dataHead.Rows[i]["DealerCode"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(6).SetCellValue(dataHead.Rows[i]["DealerName"] != null ? dataHead.Rows[i]["DealerName"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(7).SetCellValue(dataHead.Rows[i]["HospitalCode"] != null ? dataHead.Rows[i]["HospitalCode"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(8).SetCellValue(dataHead.Rows[i]["HospitalName"] != null ? dataHead.Rows[i]["HospitalName"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(9).SetCellValue(dataHead.Rows[i]["PresentValueConverted"] != null ? dataHead.Rows[i]["PresentValueConverted"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(10).SetCellValue(dataHead.Rows[i]["AdjustPresentValue"] != null ? dataHead.Rows[i]["AdjustPresentValue"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(11).SetCellValue(dataHead.Rows[i]["ActualValueLeft"] != null ? dataHead.Rows[i]["ActualValueLeft"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(12).SetCellValue(dataHead.Rows[i]["UnitPrice"] != null ? dataHead.Rows[i]["UnitPrice"].ToString() : "");

                }
            }
            else if (ExportType == "积分")
            {
                int rowNub = 0;
                for (int i = 0; i < dataHead.Rows.Count; i++)
                {
                    rowNub = rowNub + 1;
                    dataSheet.GetRow(rowNub).GetCell(0).SetCellValue(dataHead.Rows[i]["BU"] != null ? dataHead.Rows[i]["BU"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(dataHead.Rows[i]["Period"] != null ? dataHead.Rows[i]["Period"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(2).SetCellValue(dataHead.Rows[i]["PolicyNo"] != null ? dataHead.Rows[i]["PolicyNo"].ToString() : "");
                    //dataSheet.GetRow(rowNub).GetCell(3).SetCellValue(dataHead.Rows[i]["PresentType"] != null ? dataHead.Rows[i]["PresentType"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(3).SetCellValue(dataHead.Rows[i]["ParentDealerCode"] != null ? dataHead.Rows[i]["ParentDealerCode"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(4).SetCellValue(dataHead.Rows[i]["ParentDealerName"] != null ? dataHead.Rows[i]["ParentDealerName"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(5).SetCellValue(dataHead.Rows[i]["DealerCode"] != null ? dataHead.Rows[i]["DealerCode"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(6).SetCellValue(dataHead.Rows[i]["DealerName"] != null ? dataHead.Rows[i]["DealerName"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(7).SetCellValue(dataHead.Rows[i]["HospitalCode"] != null ? dataHead.Rows[i]["HospitalCode"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(8).SetCellValue(dataHead.Rows[i]["HospitalName"] != null ? dataHead.Rows[i]["HospitalName"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(9).SetCellValue(dataHead.Rows[i]["PresentValueConverted"] != null ? dataHead.Rows[i]["PresentValueConverted"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(10).SetCellValue(dataHead.Rows[i]["AdjustPresentValue"] != null ? dataHead.Rows[i]["AdjustPresentValue"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(11).SetCellValue(dataHead.Rows[i]["ActualValueLeft"] != null ? dataHead.Rows[i]["ActualValueLeft"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(12).SetCellValue(dataHead.Rows[i]["PointType"] != null ? dataHead.Rows[i]["PointType"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(13).SetCellValue(dataHead.Rows[i]["LPPointConvertRate"] != null ? dataHead.Rows[i]["LPPointConvertRate"].ToString() : "");
                    dataSheet.GetRow(rowNub).GetCell(14).SetCellValue(dataHead.Rows[i]["PointValidEndDate"] != null ? dataHead.Rows[i]["PointValidEndDate"].ToString() : "");
                }
            }

            //if (dataDetail.Rows.Count > 0)
            //{
            //    InsertExcelDetailRows(dataSheetDetail, dataDetail.Rows.Count);
            //}

            //if (ExportType == "赠品")
            //{
            //    int coulmNub = 0;
            //    for (int i = 0; i < dataDetail.Rows.Count; i++)
            //    {

            //        coulmNub = coulmNub + 1;
            //        dataSheetDetail.GetRow(coulmNub).GetCell(0).SetCellValue(dataDetail.Rows[i]["PolicyNo"] != null ? dataDetail.Rows[i]["PolicyNo"].ToString() : "");
            //        dataSheetDetail.GetRow(coulmNub).GetCell(1).SetCellValue(dataDetail.Rows[i]["Contain"] != null ? dataDetail.Rows[i]["Contain"].ToString() : "");
            //        dataSheetDetail.GetRow(coulmNub).GetCell(2).SetCellValue(dataDetail.Rows[i]["ProductLine"] != null ? dataDetail.Rows[i]["ProductLine"].ToString() : "");
            //        dataSheetDetail.GetRow(coulmNub).GetCell(3).SetCellValue(dataDetail.Rows[i]["ProductLineID"] != null ? dataDetail.Rows[i]["ProductLineID"].ToString() : "");
            //        dataSheetDetail.GetRow(coulmNub).GetCell(4).SetCellValue(dataDetail.Rows[i]["UPNDescription"] != null ? dataDetail.Rows[i]["UPNDescription"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(5).SetCellValue(dataDetail.Rows[i]["LPSAPCode"] != null ? dataDetail.Rows[i]["LPSAPCode"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(6).SetCellValue(dataDetail.Rows[i]["LPName"] != null ? dataDetail.Rows[i]["LPName"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(7).SetCellValue(dataDetail.Rows[i]["DealerSAPCode"] != null ? dataDetail.Rows[i]["DealerSAPCode"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(8).SetCellValue(dataDetail.Rows[i]["DealerName"] != null ? dataDetail.Rows[i]["DealerName"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(9).SetCellValue(dataDetail.Rows[i]["HospitalId"] != null ? dataDetail.Rows[i]["HospitalId"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(10).SetCellValue(dataDetail.Rows[i]["HospitalName"] != null ? dataDetail.Rows[i]["HospitalName"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(11).SetCellValue(dataDetail.Rows[i]["Amount"] != null ? dataDetail.Rows[i]["Amount"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(12).SetCellValue(dataDetail.Rows[i]["AdjustAmount"] != null ? dataDetail.Rows[i]["AdjustAmount"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(13).SetCellValue(dataDetail.Rows[i]["LeftAmount"] != null ? dataDetail.Rows[i]["LeftAmount"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(14).SetCellValue(dataDetail.Rows[i]["AdjustLeftAmount"] != null ? dataDetail.Rows[i]["AdjustLeftAmount"].ToString() : "");

            //    }
            //}
            //else if (ExportType == "积分")
            //{
            //    int coulmNub = 0;
            //    for (int i = 0; i < dataDetail.Rows.Count; i++)
            //    {
            //        coulmNub = coulmNub + 1;
            //        dataSheetDetail.GetRow(coulmNub).GetCell(0).SetCellValue(dataDetail.Rows[i]["PolicyNo"] != null ? dataDetail.Rows[i]["PolicyNo"].ToString() : "");
            //        dataSheetDetail.GetRow(coulmNub).GetCell(1).SetCellValue(dataDetail.Rows[i]["Contain"] != null ? dataDetail.Rows[i]["Contain"].ToString() : "");
            //        dataSheetDetail.GetRow(coulmNub).GetCell(2).SetCellValue(dataDetail.Rows[i]["ProductLine"] != null ? dataDetail.Rows[i]["ProductLine"].ToString() : "");
            //        dataSheetDetail.GetRow(coulmNub).GetCell(3).SetCellValue(dataDetail.Rows[i]["ProductLineID"] != null ? dataDetail.Rows[i]["ProductLineID"].ToString() : "");
            //        dataSheetDetail.GetRow(coulmNub).GetCell(4).SetCellValue(dataDetail.Rows[i]["UPNDescription"] != null ? dataDetail.Rows[i]["UPNDescription"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(4).SetCellValue(dataDetail.Rows[i]["LPSAPCode"] != null ? dataDetail.Rows[i]["LPSAPCode"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(5).SetCellValue(dataDetail.Rows[i]["LPName"] != null ? dataDetail.Rows[i]["LPName"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(6).SetCellValue(dataDetail.Rows[i]["DealerSAPCode"] != null ? dataDetail.Rows[i]["DealerSAPCode"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(7).SetCellValue(dataDetail.Rows[i]["DealerName"] != null ? dataDetail.Rows[i]["DealerName"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(8).SetCellValue(dataDetail.Rows[i]["HospitalId"] != null ? dataDetail.Rows[i]["HospitalId"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(9).SetCellValue(dataDetail.Rows[i]["HospitalName"] != null ? dataDetail.Rows[i]["HospitalName"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(10).SetCellValue(dataDetail.Rows[i]["Amount"] != null ? dataDetail.Rows[i]["Amount"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(11).SetCellValue(dataDetail.Rows[i]["AdjustAmount"] != null ? dataDetail.Rows[i]["AdjustAmount"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(12).SetCellValue(dataDetail.Rows[i]["PointType"] != null ? dataDetail.Rows[i]["PointType"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(13).SetCellValue(dataDetail.Rows[i]["Ratio"] != null ? dataDetail.Rows[i]["Ratio"].ToString() : "");
            //        //dataSheetDetail.GetRow(coulmNub).GetCell(14).SetCellValue(dataDetail.Rows[i]["PointValidDate"] != null ? dataDetail.Rows[i]["PointValidDate"].ToString() : "");
            //    }
            //}



            #endregion

        }

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

        private MemoryStream GetExcelStream()
        {
            MemoryStream file = new MemoryStream();
            hssfworkbook.Write(file);
            return file;
        }

        private void InsertExcelDetailRows(ISheet dataSheet, int rowCount)
        {
            // '将fromRowIndex行以后的所有行向下移动rowCount行，保留行高和格式
            dataSheet.ShiftRows(1, 1, rowCount, true, false);

            // '取得源格式行
            IRow rowSource = dataSheet.GetRow(0);
            ICellStyle rowstyle = rowSource.RowStyle;

            for (int rowIndex = 1; rowIndex < 1 + rowCount; rowIndex++)
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
    }
}
