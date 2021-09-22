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

namespace DMS.Website.Revolution.Pages.Order
{
    public partial class OrderPrint : System.Web.UI.Page
    {
        #region 公用
        private static HSSFWorkbook hssfworkbook;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private IDealerMasters _dealerMasters = new DealerMasters();
        private IWarehouses _warehouses = new Warehouses();
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) 
            {
                if (Request.QueryString["OrderID"] != null)
                {
                    PrintOrder(Request.QueryString["OrderID"].ToString());
                }
            }
        }

        private void PrintOrder(string orderID) 
        {
            string templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Template_OrderPrint_T1.xls");

            FileStream file = new FileStream(templateName, FileMode.Open, FileAccess.Read);
            hssfworkbook = new HSSFWorkbook(file);
            GenerateData(orderID);

            //FileStream filein = new FileStream(@"test.xls", FileMode.Create);
            //hssfworkbook.Write(filein);

            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "OrderData.xls"));
            Response.Clear();
            GetExcelStream().WriteTo(Response.OutputStream);
            Response.Flush();
            Response.End();
            
        }

        private void GenerateData(string orderID) 
        {
            ISheet dataSheet = hssfworkbook.GetSheetAt(0);
            
            //获取页面数据
            Guid InstanceId = (orderID == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(orderID));

            #region 绑定表头
            PurchaseOrderHeader header = _business.GetPurchaseOrderHeaderById(InstanceId);
            //经销商ID/名称
            Guid dealerId = header.DmaId.Value;
            DealerMaster dm = _dealerMasters.GetDealerMaster(header.DmaId.Value);
            dataSheet.GetRow(0).GetCell(5).SetCellValue(dm.ChineseName + "    采购订单");

            //订单编号
            dataSheet.GetRow(3).GetCell(5).SetCellValue(header.OrderNo);

            //供应商
            string orderTo = null;
            if (string.IsNullOrEmpty(header.Vendorid))
            {
                orderTo = DealerCacheHelper.GetDealerById(DealerCacheHelper.GetDealerById(header.DmaId.Value).ParentDmaId.Value).ChineseName;
            }
            else
            {
                orderTo = DealerCacheHelper.GetDealerById(new Guid(header.Vendorid.ToString())).ChineseName;
            }
            dataSheet.GetRow(3).GetCell(15).SetCellValue(orderTo);

            //订单类型
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Order_Type);
            dataSheet.GetRow(5).GetCell(5).SetCellValue(header.OrderType == null ? "": dicts[header.OrderType]);

            //产品线ID
            string productLine = header.ProductLineBumId.HasValue ? header.ProductLineBumId.Value.ToString() : "00000000-0000-0000-0000-000000000000";
            DataTable dtProLine= _dealerMasters.GetProductLineById(new Guid(productLine)).Tables[0];
            if (dtProLine.Rows.Count > 0) 
            {
                dataSheet.GetRow(5).GetCell(15).SetCellValue(dtProLine.Rows[0]["AttributeName"].ToString());
            }
           
            //订单提交时间
            dataSheet.GetRow(7).GetCell(5).SetCellValue( header.SubmitDate.HasValue ? header.SubmitDate.Value.ToString("yyyy-MM-dd HH:mm:ss") : "");

            //下单人员ID
            Guid submintUser = header.SubmitUser.HasValue ? header.SubmitUser.Value : new Guid("00000000-0000-0000-0000-000000000000");
            DataTable dtSubmintUser= _business.GetSubmintUserByUserID(submintUser).Tables[0];
            dataSheet.GetRow(7).GetCell(15).SetCellValue(dtSubmintUser.Rows[0]["IDENTITY_NAME"].ToString());

            //金额/数量汇总
            DataSet ds = _business.SumPurchaseOrderByHeaderId(InstanceId);
            if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
            {
                dataSheet.GetRow(9).GetCell(5).SetCellValue( Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2"));
                dataSheet.GetRow(9).GetCell(15).SetCellValue( Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalQty"]).ToString("F2"));
            }
            //收货仓库/地址
            string warehouse = header.WhmId.HasValue ? header.WhmId.Value.ToString() : "00000000-0000-0000-0000-000000000000";
            Warehouse getwarehouse = _warehouses.GetWarehouse(new Guid(warehouse));
            dataSheet.GetRow(11).GetCell(5).SetCellValue(getwarehouse == null ? "" : getwarehouse.Name);

            dataSheet.GetRow(11).GetCell(15).SetCellValue(header.ShipToAddress);

            //订单备注
            dataSheet.GetRow(13).GetCell(5).SetCellValue(header.Remark);
            #endregion

            #region 绑定产品明细
            DataTable dtOrderDetail = _business.QueryLPPurchaseOrderDetailByHeaderId(InstanceId, header.Virtualdc).Tables[0];
            if (dtOrderDetail.Rows.Count > 1)
            {
                InsertExcelDetailRows(dataSheet, dtOrderDetail.Rows.Count-1);
            }
            
            int rowNub = 15;

            for (int i = 0; i < dtOrderDetail.Rows.Count; i++) 
            {
                rowNub = rowNub + 1;
                dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(dtOrderDetail.Rows[i]["row_number"].ToString());
                dataSheet.AddMergedRegion(new CellRangeAddress(rowNub, rowNub,1, 2));

                dataSheet.GetRow(rowNub).GetCell(3).SetCellValue(dtOrderDetail.Rows[i]["CustomerFaceNbr"].ToString());
                dataSheet.AddMergedRegion(new CellRangeAddress(rowNub, rowNub, 3, 7));

                dataSheet.GetRow(rowNub).GetCell(8).SetCellValue(dtOrderDetail.Rows[i]["CfnChineseName"].ToString());
                dataSheet.AddMergedRegion(new CellRangeAddress(rowNub, rowNub, 8, 12));

                dataSheet.GetRow(rowNub).GetCell(13).SetCellValue(dtOrderDetail.Rows[i]["CfnEnglishName"].ToString());
                dataSheet.AddMergedRegion(new CellRangeAddress(rowNub, rowNub, 13, 16));

                dataSheet.GetRow(rowNub).GetCell(17).SetCellValue(Convert.ToDecimal(dtOrderDetail.Rows[i]["CfnPrice"]).ToString("F2"));
                dataSheet.AddMergedRegion(new CellRangeAddress(rowNub, rowNub, 17, 19));

                dataSheet.GetRow(rowNub).GetCell(20).SetCellValue(Convert.ToDecimal(dtOrderDetail.Rows[i]["RequiredQty"]).ToString("F2"));

                dataSheet.GetRow(rowNub).GetCell(21).SetCellValue(Convert.ToDecimal(dtOrderDetail.Rows[i]["Amount"]).ToString("F2"));
                dataSheet.AddMergedRegion(new CellRangeAddress(rowNub, rowNub, 21, 23));
            }

            dataSheet.GetRow(rowNub + 1).GetCell(20).SetCellValue(Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalQty"]).ToString("F2"));
            dataSheet.GetRow(rowNub + 1).GetCell(21).SetCellValue(Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2"));
            dataSheet.AddMergedRegion(new CellRangeAddress(rowNub + 1, rowNub + 1, 21, 23));

            #endregion

        }

        private MemoryStream GetExcelStream()
        {
            //Write the stream data of workbook to the root directory
            MemoryStream file = new MemoryStream();
            hssfworkbook.Write(file);
            return file;
        }

        private void InsertExcelDetailRows(ISheet dataSheet,int rowCount) 
        {
            // '将fromRowIndex行以后的所有行向下移动rowCount行，保留行高和格式
            dataSheet.ShiftRows(17, dataSheet.LastRowNum, rowCount, true, false);

            // '取得源格式行
            IRow rowSource = dataSheet.GetRow(16);
            ICellStyle rowstyle = rowSource.RowStyle;

            for (int rowIndex = 17; rowIndex < 17 + rowCount; rowIndex++)
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
                    cellInsert.CellStyle = cellSource.CellStyle;
                }
            }
        }
    }
}
