using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.IO;

namespace DMS.Business.Excel
{
    public static class Utility
    {
        //返回 /path/
        public static string FormatPath(string strPath, string strTag)
        {
            string strReturn = strPath;
            strReturn = strReturn.EndsWith(strTag) ? strReturn : strReturn + strTag;
            strReturn = strReturn.StartsWith(strTag) ? strReturn : strTag + strReturn;
            return strReturn;
        }
        //返回 /pathA/pathB/
        public static string CombinePath(string strPathA, string strPathB, string strTag)
        {
            string strReturn = (strPathA.EndsWith(strTag) ? strPathA.Substring(0, strPathA.Length - 1) : strPathA)
                + strTag + (strPathB.StartsWith(strTag) ? strPathB.Substring(1) : strPathB);
            //return FormatPath(strReturn, strTag);
            return strReturn;
        }

        public static Hashtable GetExcelPosition(string strPosition)
        {
            string str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            Hashtable ht = new Hashtable();
            string[] strP = strPosition.Split(',');
            ht.Add("startX", Convert.ToInt32(strP[0]));
            if (strP[1].Length == 1)
            {
                ht.Add("startY", str.IndexOf(strP[1]) + 1);
            }
            else
            {
                ht.Add("startY", (str.IndexOf(strP[1].Substring(0, 1)) + 1) * 26 + str.IndexOf(strP[1].Substring(1, 1)) + 1);
            }
            return ht;
        }


        /*
        public static string GetExcelPositionRelative(string strPosition, int iRelative)
        {
            string strReturn = "";
            string str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            int iPos = 0;
            if (strPosition.Length == 1)
                iPos = str.IndexOf(strPosition) + 1;
            else
                iPos = (str.IndexOf(strPosition.Substring(0, 1)) + 1) * 26 + str.IndexOf(strPosition.Substring(1, 1)) + 1;
            iPos = iPos + iRelative;
            if (iPos <= 26)
                strReturn = str.Substring(iPos - 1, 1);
            else
                strReturn = "A" + str.Substring(iPos - 26 - 1, 1);
            return strReturn;
        }
         * */

        public static string GetExcelPositionRelative(string strPosition, int iRelative)
        {
            string strReturn = "";
            string str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            int iPos = 0;
            if (strPosition.Length == 1)
                iPos = str.IndexOf(strPosition) + 1;
            else
                iPos = (str.IndexOf(strPosition.Substring(0, 1)) + 1) * 26 + str.IndexOf(strPosition.Substring(1, 1)) + 1;

            iPos = iPos + iRelative;

            if (iPos <= 26)
                strReturn = str.Substring(iPos - 1, 1);
            else if (iPos > 26 && iPos <= 52)
            {
                strReturn = "A" + str.Substring(iPos - 26 - 1, 1);
            }
            else if (iPos > 52 && iPos <= 78)
            {
                strReturn = "B" + str.Substring(iPos - 52 - 1, 1);
            }
            else if (iPos > 78 && iPos <= 104)
            {
                strReturn = "C" + str.Substring(iPos - 78 - 1, 1);
            }
            else if (iPos > 104)
            {
                strReturn = "D" + str.Substring(iPos - 104 - 1, 1);
            }
            return strReturn;
        }

        public static string GetExcelFileName(string strOldFileName, string strFileNameFormat)
        {
            if (string.IsNullOrEmpty(strFileNameFormat)) return strOldFileName;

            string strReturnFileName = strOldFileName;
            //string strName = strOldFileName.Substring(0, strOldFileName.IndexOf(".") - 1);
            string strpostfix = strOldFileName.Substring(strOldFileName.IndexOf("."));
            if (strFileNameFormat.ToLower().EndsWith("_yyyymmdd"))
            {
                //strReturnFileName = strFileNameFormat.Substring(0, strFileNameFormat.IndexOf("_yyyymmdd") - 1) + "_" + DateTime.Now.ToString("yyyyMMdd") + strpostfix;
                strReturnFileName = strFileNameFormat.Replace("yyyymmdd", DateTime.Now.ToString("yyyyMMdd")) + strpostfix;

            }
            else
            {
                strReturnFileName = strFileNameFormat + strpostfix;
            }

            return strReturnFileName;
        }

        public static void DeleteFile(string strTempFile)
        {
            FileInfo fi = new FileInfo(strTempFile);
            if (fi != null)
            {
                fi.Delete();
            }
        }

        public static void CopyFile(string strSrcFile, string strDescFile)
        {
            FileInfo fi = new FileInfo(strSrcFile);
            if (fi != null)
            {
                fi.CopyTo(strDescFile, true);
            }

            if ((File.GetAttributes(strDescFile) & FileAttributes.ReadOnly) == FileAttributes.ReadOnly)
            {
                File.SetAttributes(strDescFile, FileAttributes.Normal);
            }

        }
    }
}
