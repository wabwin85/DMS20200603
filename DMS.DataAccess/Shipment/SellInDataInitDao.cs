using DMS.Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.Shipment
{
    public class SellInDataInitDao:BaseSqlMapDao
    {
        public DataSet QuerySellInInitData(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryTempSellInDataInfo",table,start,limit,out totalRowCount);
            return ds;
        }

        public int DeleteTempSellInData()
        {
            int cnt = (int)this.ExecuteDelete("DelTempSellInDataInfo", null);
            return cnt;
        }

        public void BatchInsertData(List<SellInDetailInfoTemp> items)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id", typeof(Guid));
            dt.Columns.Add("SubCompany", typeof(string));
            dt.Columns.Add("Brand", typeof(string));
            dt.Columns.Add("AccountingYear", typeof(string));
            dt.Columns.Add("AccountingQuarter", typeof(string));
            dt.Columns.Add("AccountingMonth", typeof(string));
            dt.Columns.Add("Channel", typeof(string));
            dt.Columns.Add("SalesIdentity", typeof(string));
            dt.Columns.Add("SalesIdentityRow", typeof(string));
            dt.Columns.Add("OrderType", typeof(string));
            dt.Columns.Add("ActualDiscount", typeof(decimal));
            dt.Columns.Add("CompanyCode", typeof(string));
            dt.Columns.Add("CompanyName", typeof(string));
            dt.Columns.Add("IsRelated", typeof(string));
            dt.Columns.Add("RevenueType", typeof(string));
            dt.Columns.Add("BorderType", typeof(string));
            dt.Columns.Add("ProductLine", typeof(string));
            dt.Columns.Add("ProductProvince", typeof(string));
            dt.Columns.Add("InvoiceDate", typeof(DateTime));
            dt.Columns.Add("SoldPartyDealerCode", typeof(string));
            dt.Columns.Add("SoldPartySAPCode", typeof(string));
            dt.Columns.Add("SoldPartyName", typeof(string));
            dt.Columns.Add("BillingType", typeof(string));
            dt.Columns.Add("Province", typeof(string));
            dt.Columns.Add("ExchangeRate", typeof(decimal));
            dt.Columns.Add("MaterialCode", typeof(string));
            dt.Columns.Add("MaterialName", typeof(string));
            dt.Columns.Add("UPN", typeof(string));
            dt.Columns.Add("OutInvoiceNum", typeof(int));
            dt.Columns.Add("InvoiceNetAmount", typeof(decimal));
            dt.Columns.Add("InvoiceRate", typeof(decimal));
            dt.Columns.Add("RebateNetAmount", typeof(decimal));
            dt.Columns.Add("RebateRate", typeof(decimal));
            dt.Columns.Add("InvoiceAmount", typeof(decimal));
            dt.Columns.Add("LocalCurrencyAmount", typeof(decimal));
            dt.Columns.Add("KLocalCurrencyAmount", typeof(decimal));
            dt.Columns.Add("DeliveryDate", typeof(DateTime));
            dt.Columns.Add("OrderCreateDate", typeof(DateTime));
            dt.Columns.Add("ProductLineAndSoldParty", typeof(string));
            dt.Columns.Add("ActualLegalEntity", typeof(string));
            dt.Columns.Add("IsNeedRecovery", typeof(string));
            dt.Columns.Add("RecoveryComment", typeof(string));
            dt.Columns.Add("BusinessCaliber", typeof(decimal));
            dt.Columns.Add("ClosedAccount", typeof(decimal));
            dt.Columns.Add("Comment", typeof(string));
            dt.Columns.Add("ProductGeneration", typeof(string));
            dt.Columns.Add("StandardPrice", typeof(decimal));
            dt.Columns.Add("Region", typeof(string));
            dt.Columns.Add("InsertTime", typeof(DateTime));
            dt.Columns.Add("CreatedBy", typeof(Guid));
            dt.Columns.Add("ModifiedTime", typeof(DateTime));
            dt.Columns.Add("ModifiedBy", typeof(Guid));
            dt.Columns.Add("ErrorMsg", typeof(string));
            dt.Columns.Add("IsError", typeof(bool));

            foreach (SellInDetailInfoTemp data in items)
            {
                DataRow dr = dt.NewRow();
                dr["Id"] = data.Id;
                dr["SubCompany"] = data.SubCompany;
                dr["Brand"] = data.Brand;
                dr["AccountingYear"] = data.AccountingYear;
                dr["AccountingQuarter"] = data.AccountingQuarter;
                dr["AccountingMonth"] = data.AccountingMonth;
                dr["Channel"] = data.Channel;
                dr["SalesIdentity"] = data.SalesIdentity;
                dr["SalesIdentityRow"] = data.SalesIdentityRow;
                dr["OrderType"] = data.OrderType;
                dr["ActualDiscount"] = data.ActualDiscount;
                dr["CompanyCode"] = data.CompanyCode;
                dr["CompanyName"] = data.CompanyName;
                dr["IsRelated"] = data.IsRelated;
                dr["RevenueType"] = data.RevenueType;
                dr["BorderType"] = data.BorderType;
                dr["ProductLine"] = data.ProductLine;
                dr["ProductProvince"] = data.ProductProvince;
                dr["InvoiceDate"] = data.InvoiceDate;
                dr["SoldPartyDealerCode"] = data.SoldPartyDealerCode;
                dr["SoldPartySAPCode"] = data.SoldPartySAPCode;
                dr["SoldPartyName"] = data.SoldPartyName;
                dr["BillingType"] = data.BillingType;
                dr["Province"] = data.Province;
                if(!string.IsNullOrEmpty(data.ExchangeRate.ToString()))
                    dr["ExchangeRate"] = data.ExchangeRate;
                dr["MaterialCode"] = data.MaterialCode;
                dr["MaterialName"] = data.MaterialName;
                dr["UPN"] = data.UPN;
                if (!string.IsNullOrEmpty(data.OutInvoiceNum.ToString()))
                    dr["OutInvoiceNum"] = data.OutInvoiceNum;
                if (!string.IsNullOrEmpty(data.InvoiceNetAmount.ToString()))
                    dr["InvoiceNetAmount"] = data.InvoiceNetAmount;
                if (!string.IsNullOrEmpty(data.InvoiceRate.ToString()))
                    dr["InvoiceRate"] = data.InvoiceRate;
                if (!string.IsNullOrEmpty(data.RebateNetAmount.ToString()))
                    dr["RebateNetAmount"] = data.RebateNetAmount;
                if (!string.IsNullOrEmpty(data.RebateRate.ToString()))
                    dr["RebateRate"] = data.RebateRate;
                if (!string.IsNullOrEmpty(data.InvoiceAmount.ToString()))
                    dr["InvoiceAmount"] = data.InvoiceAmount;
                if (!string.IsNullOrEmpty(data.LocalCurrencyAmount.ToString()))
                    dr["LocalCurrencyAmount"] = data.LocalCurrencyAmount;
                if (!string.IsNullOrEmpty(data.KLocalCurrencyAmount.ToString()))
                    dr["KLocalCurrencyAmount"] = data.KLocalCurrencyAmount;
                dr["DeliveryDate"] = data.DeliveryDate;
                dr["OrderCreateDate"] = data.OrderCreateDate;
                dr["ProductLineAndSoldParty"] = data.ProductLineAndSoldParty;
                dr["ActualLegalEntity"] = data.ActualLegalEntity;
                dr["IsNeedRecovery"] = data.IsNeedRecovery;
                dr["RecoveryComment"] = data.RecoveryComment;
                if (!string.IsNullOrEmpty(data.BusinessCaliber.ToString()))
                    dr["BusinessCaliber"] = data.BusinessCaliber;
                if (!string.IsNullOrEmpty(data.ClosedAccount.ToString()))
                    dr["ClosedAccount"] = data.ClosedAccount;
                dr["Comment"] = data.Comment;
                dr["ProductGeneration"] = data.ProductGeneration;
                if(!string.IsNullOrEmpty(data.StandardPrice.ToString()))
                    dr["StandardPrice"] = data.StandardPrice;
                dr["Region"] = data.Region;
                dr["InsertTime"] = data.InsertTime;
                dr["CreatedBy"] = data.CreatedBy;
                dr["ModifiedTime"] = data.ModifiedTime;
                dr["ModifiedBy"] = data.ModifiedBy;
                dr["ErrorMsg"] = data.ErrorMsg;
                dr["IsError"] = data.IsError.HasValue?true:false;

                dt.Rows.Add(dr);
            }
            this.ExecuteBatchInsert("SellInDetailInfoTemp", dt);
        }

        public string ExecuteVerifiyTempData(Hashtable ht)
        {
            this.ExecuteInsert("Usp_ValidateSellInDataImport", ht);

            string rtnval = ht["RtnVal"].ToString();

            return rtnval;
        }

        public DataSet QueryTempSellInDataInfo()
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryTempSellInDataInfo", null);
            return ds;
        }
    }
}
