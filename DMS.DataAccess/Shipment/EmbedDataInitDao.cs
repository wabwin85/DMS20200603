using DMS.Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;

namespace DMS.DataAccess
{
    public class EmbedDataInitDao:BaseSqlMapDao
    {
        public DataSet QueryEmbedDataInfo(Hashtable table, int start, int limit, out int rowscount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryTempEmbedDataInfo", table, start, limit, out rowscount);
            return ds;
        }

        public int DeleteTempEmbedData()
        {
            int cnt = (int)this.ExecuteDelete("DelTempEmbedDataInfo",null);
            return cnt;
        }

        public void BatchInsertData(List<SellOutDetailInfoTemp> items)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id", typeof(Guid));
            dt.Columns.Add("SubCompany",typeof(string));
            dt.Columns.Add("Brand", typeof(string));
            dt.Columns.Add("AccountingYear", typeof(string));
            dt.Columns.Add("AccountingMonth", typeof(string));
            dt.Columns.Add("DealerCode", typeof(string));
            dt.Columns.Add("DealerName", typeof(string));
            dt.Columns.Add("LegalEntity", typeof(string));
            dt.Columns.Add("SalesEntity", typeof(string));
            dt.Columns.Add("Hos_Level", typeof(string));
            dt.Columns.Add("Hos_Type", typeof(string));
            dt.Columns.Add("Hos_Code", typeof(string));
            dt.Columns.Add("Hos_Name", typeof(string));
            dt.Columns.Add("NewOpenMonth", typeof(string));
            dt.Columns.Add("NewOpenProduct", typeof(string));
            dt.Columns.Add("Region", typeof(string));
            dt.Columns.Add("Province", typeof(string));
            dt.Columns.Add("City", typeof(string));
            dt.Columns.Add("CityLevel", typeof(string));
            dt.Columns.Add("RegionOwner", typeof(string));
            dt.Columns.Add("SalesRepresentative", typeof(string));
            dt.Columns.Add("PMA_UPN", typeof(string));
            dt.Columns.Add("CFN_Name", typeof(string));
            dt.Columns.Add("ProductLine", typeof(string));
            dt.Columns.Add("ShipmentNbr", typeof(string));
            dt.Columns.Add("UsedDate", typeof(DateTime));
            dt.Columns.Add("InvoiceNumber", typeof(string));
            dt.Columns.Add("InvoiceDate", typeof(DateTime));
            dt.Columns.Add("InvoiceUploadDate", typeof(DateTime));
            dt.Columns.Add("Status", typeof(string));
            dt.Columns.Add("IsValidate", typeof(bool)); 
            dt.Columns.Add("Unit", typeof(string));
            dt.Columns.Add("Quantity", typeof(decimal));
            dt.Columns.Add("InvoicePrice", typeof(decimal));
            dt.Columns.Add("InvoiceRate", typeof(decimal));
            dt.Columns.Add("AssessUnitPrice", typeof(decimal));
            dt.Columns.Add("AssessPrice", typeof(decimal));
            dt.Columns.Add("Remark", typeof(string));
            dt.Columns.Add("InsertTime", typeof(DateTime));
            dt.Columns.Add("ModifiedTime", typeof(DateTime));
            dt.Columns.Add("CreatedBy", typeof(Guid));
            dt.Columns.Add("ModifiedBy", typeof(Guid));
            dt.Columns.Add("ErrorMsg");
            dt.Columns.Add("IsError", typeof(bool));
            foreach (SellOutDetailInfoTemp data in items)
            {
                DataRow dr = dt.NewRow();
                dr["Id"] = data.Id;
                dr["SubCompany"] = data.SubCompany;
                dr["Brand"] = data.Brand;
                dr["AccountingYear"] = data.AccountingYear;
                dr["AccountingMonth"] = data.AccountingMonth;
                dr["DealerCode"] = data.DealerCode;
                dr["DealerName"] = data.DealerName;
                dr["LegalEntity"] = data.LegalEntity;
                dr["SalesEntity"] = data.SalesEntity;
                dr["Hos_Level"] = data.Hos_Level;
                dr["Hos_Type"] = data.Hos_Type;
                dr["Hos_Code"] = data.Hos_Code;
                dr["Hos_Name"] = data.Hos_Name;
                dr["NewOpenMonth"] = data.NewOpenMonth;
                dr["NewOpenProduct"] = data.NewOpenProduct;
                dr["Region"] = data.Region;
                dr["Province"] = data.Province;
                dr["City"] = data.City;
                dr["CityLevel"] = data.CityLevel;
                dr["RegionOwner"] = data.RegionOwner;
                dr["SalesRepresentative"] = data.SalesRepresentative;
                dr["PMA_UPN"] = data.PMA_UPN;
                dr["CFN_Name"] = data.CFN_Name;
                dr["ProductLine"] = data.ProductLine;
                dr["ShipmentNbr"] = data.ShipmentNbr;
                if(data.UsedDate != null && data.UsedDate.HasValue)
                    dr["UsedDate"] = data.UsedDate;
                dr["InvoiceNumber"] = data.InvoiceNumber;
                if(null != data.InvoiceDate && data.InvoiceDate.HasValue)
                    dr["InvoiceDate"] = data.InvoiceDate;
                if(null != data.InvoiceUploadDate && data.InvoiceUploadDate.HasValue)
                    dr["InvoiceUploadDate"] = data.InvoiceUploadDate;
                dr["Status"] = data.Status;
                dr["IsValidate"] = data.IsValidate;
                dr["Unit"] = data.Unit;
                if(data.Quantity.HasValue)
                    dr["Quantity"] = data.Quantity;
                if(data.InvoicePrice.HasValue)
                    dr["InvoicePrice"] = data.InvoicePrice;
                if(data.InvoicePrice.HasValue)
                    dr["InvoiceRate"] = data.InvoiceRate;
                if(data.AssessUnitPrice.HasValue)
                    dr["AssessUnitPrice"] = data.AssessUnitPrice;
                if(data.AssessPrice.HasValue)
                    dr["AssessPrice"] = data.AssessPrice;
                dr["Remark"] = data.Remark;
                dr["InsertTime"] = data.CreateDate;
                dr["ModifiedTime"] = data.ModifiedTime;
                if(null != data.CreatedBy)
                    dr["CreatedBy"] = data.CreatedBy;
                if(null != data.ModifiedBy)
                    dr["ModifiedBy"] = data.ModifiedBy;
                dr["ErrorMsg"] = data.ErrorMsg;
                dr["IsError"] = data.IsError;
                dt.Rows.Add(dr);
            }
            this.ExecuteBatchInsert("SellOutDetailInfoTemp", dt);
        }

        public string ExecuteVerifiyTempData(Hashtable ht)
        {
            this.ExecuteInsert("Usp_ValidateEmbedDataImport", ht);

            string rtnval = ht["RtnVal"].ToString();

            return rtnval; 
        }

        public DataSet QueryTempEmbedDataInfo()
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryTempEmbedDataInfo",null);
            return ds;
        }
    }
}