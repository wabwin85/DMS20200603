using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Common.Common;
using System.Collections;
using Microsoft.Office.Interop.Excel;
using System.Data;

namespace DMS.Business.DealerTrain
{
    public class TrainScoreTemplateExport : ExcelApp
    {
        public void Export(System.Data.DataTable userList)
        {
            try
            {
                this.InitApp();
                this.OpenFile("ExcelTemplate/Template_TrainScore.xls");
                this.FillData(userList);
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
                this.ExportFile("TrainScoreTemplate.xls");
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

        private void FillData(System.Data.DataTable userList)
        {
            try
            {
                this.sheet = (Worksheet)this.book.Sheets[2];

                int row = 2;
                foreach (DataRow r in userList.Rows)
                {
                    this.sheet.Cells[row, 1] = r["DMA_SAP_Code"].ToString();
                    this.sheet.Cells[row, 2] = r["DMA_ChineseName"].ToString();
                    this.sheet.Cells[row, 3] = r["BWU_UserName"].ToString();
                    //this.sheet.Cells[row, 4] = r["IsPass"].ToString();

                    row++;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
