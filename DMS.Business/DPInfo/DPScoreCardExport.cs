using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Common.Common;
using System.Collections;
using Microsoft.Office.Interop.Excel;

namespace DMS.Business.DPInfo
{
    public class DPScoreCardExport : ExcelApp
    {
        public void Export(String dealerCode, String dealerName, String createDate, Hashtable scoreValues)
        {
            try
            {
                this.InitApp();
                this.OpenFile("DPTemplate/Tem_Finance.xlsx");
                this.FillData(dealerCode, dealerName, createDate, scoreValues);
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
                this.ExportFile("ScoreCard.xlsx");
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

        private void FillData(String dealerCode, String dealerName, String createDate, Hashtable scoreValues)
        {
            try
            {
                this.sheet = (Worksheet)this.book.Sheets[2];

                this.sheet.Cells[1, 1] = "DealerCode";
                this.sheet.Cells[1, 2] = dealerCode;
                this.sheet.Cells[2, 1] = "DealerName";
                this.sheet.Cells[2, 2] = dealerName;
                this.sheet.Cells[3, 1] = "CreateDate";
                this.sheet.Cells[3, 2] = createDate;

                int row = 6;
                if (scoreValues != null)
                {
                    foreach (DictionaryEntry item in scoreValues)
                    {
                        if (item.Key.ToString() == "SC06")
                        {
                            this.sheet.Cells[4, 1] = item.Key.ToString();
                            this.sheet.Cells[4, 2] = item.Value.ToString();
                        }
                        else if (item.Key.ToString() == "SC07")
                        {
                            this.sheet.Cells[5, 1] = item.Key.ToString();
                            this.sheet.Cells[5, 2] = item.Value.ToString() == "0" ? "COD" : item.Value.ToString();
                        }
                        else
                        {
                            this.sheet.Cells[row, 1] = item.Key.ToString();
                            this.sheet.Cells[row, 2] = item.Value.ToString();
                            row++;
                        }
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
