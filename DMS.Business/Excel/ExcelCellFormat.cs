using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Office.Interop.Excel;

namespace DMS.Business.Excel
{
    public class ExcelCellFormat
    {
        private object _HorizontalAlignment = null;
        public object HorizontalAlignment
        {
            get { return _HorizontalAlignment; }
            set { _HorizontalAlignment = value; }
        }

        private object _VerticalAlignment = null;
        public object VerticalAlignment
        {
            get { return _VerticalAlignment; }
            set { _VerticalAlignment = value; }
        }

        private object _BordersWeight = null;
        public object BordersWeight
        {
            get { return _BordersWeight; }
            set { _BordersWeight = value; }
        }

        private object _InteriorColor = null;
        public object InteriorColor
        {
            get { return _InteriorColor; }
            set { _InteriorColor = value; }
        }

        private object _WrapText = null;
        public object WrapText
        {
            get { return _WrapText; }
            set { _WrapText = value; }
        }

        private object _FontName = null;
        public object FontName
        {
            get { return _FontName; }
            set { _FontName = value; }
        }

        private object _FontSize = null;
        public object FontSize
        {
            get { return _FontSize; }
            set { _FontSize = value; }
        }

        private object _FontStyle = null;
        public object FontStyle
        {
            get { return _FontStyle; }
            set { _FontStyle = value; }
        }

        private object _FontColor = null;
        public object FontColor
        {
            get { return _FontColor; }
            set { _FontColor = value; }
        }

        private object _NumberFormatLocal = null;
        public object NumberFormatLocal
        {
            get { return _NumberFormatLocal; }
            set { _NumberFormatLocal = value; }
        }

        public ExcelCellFormat(Worksheet worksheet, int row, int col)
        {
            Range range = (Range)worksheet.Cells[row, col];
            this.HorizontalAlignment = range.HorizontalAlignment;
            this.VerticalAlignment = range.VerticalAlignment;
            this.BordersWeight = range.Borders.Weight;
            this.BordersWeight = XlBorderWeight.xlThin;
            this.InteriorColor = range.Interior.Color;
            this.WrapText = range.WrapText;
            this.FontName = range.Font.Name;
            this.FontSize = range.Font.Size;
            this.FontStyle = range.Font.FontStyle;
            this.FontColor = range.Font.Color;
            this.NumberFormatLocal = range.NumberFormatLocal;
        }
    }
}
