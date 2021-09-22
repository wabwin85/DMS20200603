using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.OBORESign
{
    public class OBORESignDao : BaseSqlMapDao
    {
        public OBORESignDao()
            : base()
        {
        }

        public DataTable SelectOBORESignList(string ES_AgreementNo,string ES_ProductLineID,string ES_SubBu,string ES_SignA,string ES_SignB,string ES_Status,string ES_AgreementType,string StartDate,string EndDate,string CorpType)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_AgreementNo", ES_AgreementNo);
            tb.Add("ES_ProductLineID", ES_ProductLineID);
            tb.Add("ES_SubBu", ES_SubBu);
            //tb.Add("ES_SignA", ES_SignA == "" ? RoleModelContext.Current.User.CorpId.ToString() : ES_SignA);
            //tb.Add("ES_SignB", ES_SignB);
            tb.Add("ES_Status", ES_Status);
            tb.Add("ES_AgreementType", ES_AgreementType);
            tb.Add("StartDate", StartDate);
            tb.Add("EndDate", EndDate);
            if (CorpType == "LP" || CorpType == "LS")
            {
                tb.Add("ES_SignA", RoleModelContext.Current.User.CorpId.ToString());
                tb.Add("ES_SignB", ES_SignB);
                tb.Add("T1OrT2", false);
            }
            else if (CorpType == "T1" || CorpType == "T2") {

                tb.Add("ES_SignA", "");
                tb.Add("ES_SignB", ES_SignB==""? RoleModelContext.Current.User.CorpId.ToString(): ES_SignB);
                tb.Add("T1OrT2", true);

            }
            else {
                tb.Add("ES_SignA", ES_SignA==""?"": ES_SignA);
                tb.Add("ES_SignB", ES_SignB == "" ? "" : ES_SignB);
                tb.Add("T1OrT2", false);
            }

            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.SelectOBORESignList", tb).Tables[0];
            return ds;
        }
        public DataTable SelectSignA()
        {

            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.SelectSignA", "").Tables[0];
            return ds;

        }
        public DataTable SelectSignB(string DMA_ID,string CorpType)
        {
            Hashtable tb = new Hashtable();
            tb.Add("DMA_ID", DMA_ID);
            DataTable ds = new DataTable();

            if (CorpType == "T1" || CorpType == "T2")
            {
                ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.DealerSelectSignB", tb).Tables[0];
            }
            else
            {
                ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.SelectSignB", tb).Tables[0];
            }
          
            return ds;

        }



        public DataTable DICTTYPE(string Type)
        {
            Hashtable tb = new Hashtable();
            tb.Add("DICT_TYPE", Type);

            DataTable ds = this.ExecuteQueryForDataSet("MasterPage.DealerSpecialUPN.DealerType", tb).Tables[0];
            return ds;
        }

        public DataTable SelectOBORESignInfo(string ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ID);

            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.SelectOBORESignInfo", tb).Tables[0];
            return ds;
        }


        public void Save(string ES_ID, string pdfname, string Name,string SignA,string CreateUser)
        {

            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);
            tb.Add("ES_FileName", Name);
            tb.Add("ES_UploadFilePath", "~/Upload/temp/" + pdfname);
            tb.Add("ES_SignA", SignA);
            tb.Add("ES_CreateUser", CreateUser);
            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.CheckOBORESignPDF", tb).Tables[0];
            if (ds.Rows.Count > 0&& !string.IsNullOrEmpty(ES_ID))
            {
                this.ExecuteUpdate("OBORESign.OBORESign.Update", tb);
            }
            else
            {
                this.ExecuteInsert("OBORESign.OBORESign.Insert", tb);
            }


        }


        public DataTable SelectOBORESignUrl(string ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ID);
            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.SelectOBORESignUrl", tb).Tables[0];
            return ds;
        }


        public void UpdateDealerSign(string ES_ID, string FileName, string SignUser)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);
            tb.Add("ES_Status", "WaitLPSign");
            tb.Add("ES_UploadFilePath", "~/Upload/temp/"+ FileName);
            tb.Add("ES_DealerSignUser", SignUser);
            tb.Add("ES_DealerSignDate", DateTime.Now);

            this.ExecuteUpdate("OBORESign.OBORESign.UpdateDealerSign", tb);
        }

        public void UpdateLPSign(string ES_ID, string FileName, string SignUser)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);
            tb.Add("ES_Status", "SignComplete");
            tb.Add("ES_UploadFilePath", "~/Upload/temp/" + FileName);
            tb.Add("ES_LPSignUser", SignUser);
            tb.Add("ES_LPSignDate", DateTime.Now);

            this.ExecuteUpdate("OBORESign.OBORESign.UpdateLPSign", tb);
        }


        public void SaveOBORInfo(string ES_ID,string ES_ProductLineID,string ES_SubBu,string ES_SignA,string ES_SignB,string ES_CreateDate,string ES_CreateUser,string Type)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);
            tb.Add("ES_ProductLineID", ES_ProductLineID);
            tb.Add("ES_SubBu", ES_SubBu);
            tb.Add("ES_SignA", ES_SignA);
            tb.Add("ES_SignB", ES_SignB);
            tb.Add("ES_CreateDate", "");
            tb.Add("ES_CreateUser", ES_CreateUser);

            if (Type == "Update")
            {
                this.ExecuteUpdate("OBORESign.OBORESign.SaveOBORInfoUpdate", tb);
            }
            else {
                this.ExecuteInsert("OBORESign.OBORESign.SaveOBORInfoInsert", tb);
            }
            
        }

        public void SubmitOBORInfo(string ES_ID, string ES_ProductLineID, string ES_SubBu, string ES_SignA, string ES_SignB, string ES_CreateDate, string ES_CreateUser,string ES_AgreementNo)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);
            
            tb.Add("ES_ProductLineID", ES_ProductLineID);
            tb.Add("ES_SubBu", ES_SubBu);
            tb.Add("ES_SignA", ES_SignA);
            tb.Add("ES_SignB", ES_SignB);
            tb.Add("ES_CreateDate", ES_CreateDate);
            tb.Add("ES_CreateUser", ES_CreateUser);
            tb.Add("ES_AgreementNo", ES_AgreementNo);
            //tb.Add("ES_AgreementNo", ProcGetNextAutoNumberOBOR(SAPCode, "", "OBOR", "Next_OBORAppointment"));

            this.ExecuteUpdate("OBORESign.OBORESign.SubmitOBORInfo", tb);
        }


        public string ProcGetNextAutoNumberOBOR(String DealerCode, String TypeCode, String clientId, String settings)
        {
            string nextNum = "";

            Hashtable ht = new Hashtable();
            ht.Add("DealerCode", DealerCode);
            ht.Add("TypeCode", TypeCode);
            ht.Add("ClientId", clientId);
            ht.Add("Settings", settings);
            ht.Add("NextNum", nextNum);

            base.ExecuteInsert("Consignment.ConsignCommonMap.ProcGetNextAutoNumberOBOR", ht);

            nextNum = ht["NextNum"].ToString();
            return nextNum;
        }

        public IList<Hashtable> BuChange(string Bu)
        {

            Hashtable tb = new Hashtable();
            tb.Add("Bu", Bu);

            return base.ExecuteQueryForList<Hashtable>("OBORESign.OBORESign.BuChange", tb);
            
        }


        public DataTable QueryBuChange(string Bu)
        {

            Hashtable tb = new Hashtable();
            tb.Add("Bu", Bu);
            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.QueryBuChange", tb).Tables[0];
            return ds;
        }

        public int Delete(string ES_ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);

            int cnt = (int)this.ExecuteDelete("OBORESign.OBORESign.Delete", tb);
            return cnt;
        }


        public void Revoke(string ES_ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);
          
            this.ExecuteUpdate("OBORESign.OBORESign.Revoke", tb);
        }

        public string SelectDealerSapCode(string DMA_ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("DMA_ID", DMA_ID);

            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.SelectDealerSapCode", tb).Tables[0];
            return ds.Rows.Count>0?ds.Rows[0][0].ToString():"";
        }


        public string SelectClientID(string ES_ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);

            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.SelectClientID", tb).Tables[0];
            return ds.Rows.Count > 0 ? ds.Rows[0][0].ToString() : "";
        }

        public string SelectLPPhone(string ES_ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);
            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.SelectLPPhone", tb).Tables[0];
            return ds.Rows.Count > 0 ? ds.Rows[0][0].ToString() : "";
        }

        public string SelectDealerPhone(string ES_ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ES_ID", ES_ID);
            DataTable ds = this.ExecuteQueryForDataSet("OBORESign.OBORESign.SelectDealerPhone", tb).Tables[0];
            return ds.Rows.Count > 0 ? ds.Rows[0][0].ToString() : "";
        }

    }
}
