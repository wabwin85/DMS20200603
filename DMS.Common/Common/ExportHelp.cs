using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace DMS.Common
{
    public static class ExportHelp
    {
        #region 公共程序（导出excel）
        public static string ExportTable(DataTable tb)
        {
            StringBuilder data = new StringBuilder();
            data.Append("<table cellspacing=\"0\" cellpadding=\"5\" rules=\"all\" border=\"0\">");
            //写出列名
            data.Append("<tr style=\"font-weight: bold; white-space: nowrap;\">");
            foreach (DataColumn column in tb.Columns)
            {
                data.Append("<td>" + column.ColumnName + "</td>");
            }
            data.Append("</tr>");

            //写出数据
            foreach (DataRow row in tb.Rows)
            {
                data.Append("<tr>");
                foreach (DataColumn column in tb.Columns)
                {
                    data.Append("<td style=\"vnd.ms-excel.numberformat:@\">" + row[column].ToString() + "</td>");
                }
                //data.Append(row[0].ToString());
                data.Append("</tr>");
            }
            data.Append("</table>");

            return data.ToString();
        }

        public static string AddExcelHead()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:x=\"urn:schemas-microsoft-com:office:excel\">");
            //sb.Append("<?xmlversion='1.0' encoding='utf-8'?>");
            sb.Append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            sb.Append(" <head>");
            sb.Append(" <!--[if gte mso 9]><xml>");
            sb.Append("<x:ExcelWorkbook>");
            sb.Append("<x:ExcelWorksheets>");
            sb.Append("<x:ExcelWorksheet>");
            sb.Append("<x:Name></x:Name>");
            sb.Append("<x:WorksheetOptions>");
            sb.Append("<x:Print>");
            sb.Append("<x:ValidPrinterInfo />");
            sb.Append(" </x:Print>");
            sb.Append("</x:WorksheetOptions>");
            sb.Append("</x:ExcelWorksheet>");
            sb.Append("</x:ExcelWorksheets>");
            sb.Append("</x:ExcelWorkbook>");
            sb.Append("</xml>");
            sb.Append("<![endif]-->");
            sb.Append(" </head>");
            sb.Append("<body>");
            return sb.ToString();

        }

        public static string AddExcelbottom()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("</body>");
            sb.Append("</html>");
            return sb.ToString();
        }

        public static string ExportTableForInventory(DataTable tb)
        {
            StringBuilder data = new StringBuilder();
            data.Append("<table cellspacing=\"0\" cellpadding=\"5\" rules=\"all\" border=\"0\">");
            //写出列名
            data.Append("<tr style=\"font-weight: bold; white-space: nowrap;\">");
            data.Append("<td>" + "经销商中文名" + "</td>");
            data.Append("<td>" + "经销商类型" + "</td>");
            data.Append("<td>" + "上级经销商" + "</td>");
            data.Append("<td>" + "仓库名称" + "</td>");
            data.Append("<td>" + "仓库编号" + "</td>");
            data.Append("<td>" + "仓库类型" + "</td>");
            data.Append("<td>" + "产品线中文名" + "</td>");
            data.Append("<td>" + "产品线英文名" + "</td>");
            data.Append("<td>" + "产品型号" + "</td>");
            data.Append("<td>" + "产品中文名" + "</td>");
            data.Append("<td>" + "产品英文名" + "</td>");
            data.Append("<td>" + "注册证号" + "</td>");
            data.Append("<td>" + "GTIN条码" + "</td>");
            data.Append("<td>" + "生产厂商" + "</td>");
            data.Append("<td>" + "序列号/批号" + "</td>");
            data.Append("<td>" + "二维码" + "</td>");
            data.Append("<td>" + "产品生产日期" + "</td>");
            data.Append("<td>" + "有效期" + "</td>");
            data.Append("<td>" + "单位" + "</td>");
            data.Append("<td>" + "库存数量" + "</td>");
            //data.Append(tb.Columns[0]);
            data.Append("</tr>");

            //写出数据
            foreach (DataRow row in tb.Rows)
            {
                data.Append("<tr>");
                //foreach (DataColumn column in tb.Columns)
                //{
                //    data.Append("<td>" + row[column].ToString() + "</td>");
                //}
                data.Append(row[0].ToString());
                data.Append("</tr>");
            }
            data.Append("</table>");

            return data.ToString();
        }


        public static string ExportTableForPurchaseOrderLogForLPDealer(DataTable tb)
        {
            StringBuilder data = new StringBuilder();
            data.Append("<table cellspacing=\"0\" cellpadding=\"5\" rules=\"all\" border=\"0\">");
            //写出列名
            data.Append("<tr style=\"font-weight: bold; white-space: nowrap;\">");            
            data.Append("<td>" + "订单编号" + "</td>");
            data.Append("<td>" + "经销商中文名" + "</td>");
            data.Append("<td>" + "经销商编号" + "</td>");
            data.Append("<td>" + "订单提交日期" + "</td>");
            data.Append("<td>" + "订单类型" + "</td>");
            data.Append("<td>" + "订单状态" + "</td>");
            data.Append("<td>" + "产品线" + "</td>");
            data.Append("<td>" + "订单总数量" + "</td>");
            data.Append("<td>" + "订单总金额" + "</td>");
            data.Append("<td>" + "操作人员" + "</td>");
            data.Append("<td>" + "操作类型" + "</td>");
            data.Append("<td>" + "操作日期" + "</td>");
            data.Append("<td>" + "操作备注说明" + "</td>");            
            //data.Append(tb.Columns[0]);
            data.Append("</tr>");

            //写出数据
            foreach (DataRow row in tb.Rows)
            {
                data.Append("<tr>");
                //foreach (DataColumn column in tb.Columns)
                //{
                //    data.Append("<td>" + row[column].ToString() + "</td>");
                //}
                data.Append(row[0].ToString());
                data.Append("</tr>");
            }
            data.Append("</table>");

            return data.ToString();
        }

        public static string ExportTableForPurchaseOrderInvoiceForLPDealer(DataTable tb)
        {
            StringBuilder data = new StringBuilder();
            data.Append("<table cellspacing=\"0\" cellpadding=\"5\" rules=\"all\" border=\"0\">");
            //写出列名
            data.Append("<tr style=\"font-weight: bold; white-space: nowrap;\">");
            data.Append("<td>" + "订单编号" + "</td>");
            data.Append("<td>" + "经销商中文名" + "</td>");
            data.Append("<td>" + "经销商编号" + "</td>");
            data.Append("<td>" + "发票号" + "</td>");
            data.Append("<td>" + "发票日期" + "</td>");
            data.Append("<td>" + "发票状态" + "</td>");
            data.Append("<td>" + "发票金额" + "</td>");
            data.Append("<td>" + "733发票号" + "</td>");
            data.Append("<td>" + "发货单号" + "</td>");          
            //data.Append(tb.Columns[0]);
            data.Append("</tr>");

            //写出数据
            foreach (DataRow row in tb.Rows)
            {
                data.Append("<tr>");
                //foreach (DataColumn column in tb.Columns)
                //{
                //    data.Append("<td>" + row[column].ToString() + "</td>");
                //}
                data.Append(row[0].ToString());
                data.Append("</tr>");
            }
            data.Append("</table>");

            return data.ToString();
        }

        public static string ExportTableForDealerPrice(DataTable tb)
        {
            StringBuilder data = new StringBuilder();
            data.Append("<table cellspacing=\"0\" cellpadding=\"5\" rules=\"all\" border=\"0\">");
            //写出列名
            data.Append("<tr style=\"font-weight: bold; white-space: nowrap;\">");
            data.Append("<td>" + "经销商" + "</td>");
            data.Append("<td>" + "SAP代码" + "</td>");
            data.Append("<td>" + "上级经销商" + "</td>");
            data.Append("<td>" + "产品代码" + "</td>");
            data.Append("<td>" + "产品中文名称" + "</td>");
            data.Append("<td>" + "产品英文名称" + "</td>");
            data.Append("<td>" + "产品线" + "</td>");
            data.Append("<td>" + "价格类型" + "</td>");
            data.Append("<td>" + "价格" + "</td>");
            data.Append("<td>" + "币种" + "</td>");
            data.Append("<td>" + "单位" + "</td>");
            //data.Append(tb.Columns[0]);
            data.Append("</tr>");

            //写出数据
            foreach (DataRow row in tb.Rows)
            {
                data.Append("<tr>");
                //foreach (DataColumn column in tb.Columns)
                //{
                //    data.Append("<td>" + row[column].ToString() + "</td>");
                //}
                data.Append(row[0].ToString());
                data.Append("</tr>");
            }
            data.Append("</table>");

            return data.ToString();
        }

        public static string ExportTableForTransfer(DataTable tb)
        {
            StringBuilder data = new StringBuilder();
            data.Append("<table cellspacing=\"0\" cellpadding=\"5\" rules=\"all\" border=\"0\">");
            //写出列名
            data.Append("<tr style=\"font-weight: bold; white-space: nowrap;\">");
            data.Append("<td>" + "移入仓库名称" + "</td>");
            data.Append("<td>" + "移出仓库名称" + "</td>");
            data.Append("<td>" + "产品型号" + "</td>");
            data.Append("<td>" + "产品批次号" + "</td>");
            data.Append("<td>" + "二维码" + "</td>");
            data.Append("<td>" + "数量" + "</td>");
            data.Append("</tr>");

            //写出数据
            foreach (DataRow row in tb.Rows)
            {
                data.Append("<tr>");
                foreach (DataColumn column in tb.Columns)
                {
                    data.Append("<td style=\"vnd.ms-excel.numberformat:@\">" + row[column].ToString() + "</td>");
                }
                data.Append("</tr>");
            }
            data.Append("</table>");

            return data.ToString();
        }
        #endregion
    }
}
