using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Common.Common;
using System.Collections;
using Microsoft.Office.Interop.Excel;

namespace DMS.Business.DPInfo
{
    public class DPStatementsExport : ExcelApp
    {
        public void Export(Hashtable statementsValues)
        {
            try
            {
                this.InitApp();
                this.OpenFile("DPTemplate/Template.xlsx");
                this.FillData(statementsValues);
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
                this.ExportFile("Statements.xlsx");
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

        private void FillData(Hashtable statementsValues)
        {
            try
            {
                this.sheet = (Worksheet)this.book.Sheets[2];

                int row = 1;
                if (statementsValues != null)
                {
                    foreach (DictionaryEntry item in statementsValues)
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
