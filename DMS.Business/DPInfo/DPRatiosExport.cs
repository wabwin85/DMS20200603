using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Common.Common;
using System.Collections;
using Microsoft.Office.Interop.Excel;

namespace DMS.Business.DPInfo
{
    public class DPRatiosExport : ExcelApp
    {
        public void Export(Hashtable ratiosValues)
        {
            try
            {
                this.InitApp();
                this.OpenFile("DPTemplate/Template_Ratios.xlsx");
                this.FillData(ratiosValues);
                this.SaveFile("DPScoreCard");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                try
                {
                    this.Close();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }

            try
            {
                this.ExportFile("Ratios.xlsx");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                try
                {
                    this.DeleteFile();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        private void FillData(Hashtable ratiosValues)
        {
            try
            {
                this.sheet = (Worksheet)this.book.Sheets[2];

                int row = 1;
                if (ratiosValues != null)
                {
                    foreach (DictionaryEntry item in ratiosValues)
                    {
                        this.sheet.Cells[row, 1] = item.Key.ToString();
                        this.sheet.Cells[row, 2] = item.Value.ToString();
                        row++;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
