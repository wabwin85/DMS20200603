
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ShipmentInit
 * Created Time: 2013/8/2 16:55:51
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// ShipmentInit的Dao
    /// </summary>
    public class ShipmentInitDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ShipmentInitDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentInit GetObject(Guid objKey)
        {
            ShipmentInit obj = this.ExecuteQueryForObject<ShipmentInit>("SelectShipmentInit", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentInit> GetAll()
        {
            IList<ShipmentInit> list = this.ExecuteQueryForList<ShipmentInit>("SelectShipmentInit", null);
            return list;
        }


        /// <summary>
        /// 查询ShipmentInit
        /// </summary>
        /// <returns>返回ShipmentInit集合</returns>
        public IList<ShipmentInit> SelectByFilter(ShipmentInit obj)
        {
            IList<ShipmentInit> list = this.ExecuteQueryForList<ShipmentInit>("SelectByFilterShipmentInit", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShipmentInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentInit", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentInit", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShipmentInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShipmentInit", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShipmentInit obj)
        {
            this.ExecuteInsert("InsertShipmentInit", obj);
        }

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInsert(IList<ShipmentInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("SPI_ID", typeof(Guid));
            dt.Columns.Add("SPI_USER", typeof(Guid));
            dt.Columns.Add("SPI_UploadDate", typeof(DateTime));
            dt.Columns.Add("SPI_LineNbr", typeof(int));
            dt.Columns.Add("SPI_FileName");
            dt.Columns.Add("SPI_ErrorFlag", typeof(bool));
            dt.Columns.Add("SPI_ErrorDescription");
            dt.Columns.Add("SPI_SaleType");
            //dt.Columns.Add("SPI_HospitalCode");
            dt.Columns.Add("SPI_HospitalName");
            dt.Columns.Add("SPI_HospitalOffice");
            dt.Columns.Add("SPI_InvoiceNumber");
            dt.Columns.Add("SPI_InvoiceTitle");
            dt.Columns.Add("SPI_InvoiceDate");
            dt.Columns.Add("SPI_ShipmentDate");
            dt.Columns.Add("SPI_ArticleNumber");
            dt.Columns.Add("SPI_ChineseName");
            dt.Columns.Add("SPI_LotNumber");
            dt.Columns.Add("SPI_Price");
            dt.Columns.Add("SPI_ExpiredDate");
            //dt.Columns.Add("SPI_UOM");
            dt.Columns.Add("SPI_Qty");
            dt.Columns.Add("SPI_DMA_ID", typeof(Guid));
            //dt.Columns.Add("SPI_HOS_ID", typeof(Guid));
            //dt.Columns.Add("SPI_CFN_ID", typeof(Guid));
            //dt.Columns.Add("SPI_PMA_ID", typeof(Guid));
            //dt.Columns.Add("SPI_BUM_ID", typeof(Guid));
            dt.Columns.Add("SPI_HospitalCode_ErrMsg");
            dt.Columns.Add("SPI_ShipmentDate_ErrMsg");
            dt.Columns.Add("SPI_ArticleNumber_ErrMsg");
            dt.Columns.Add("SPI_LotNumber_ErrMsg");
            dt.Columns.Add("SPI_Qty_ErrMsg");
            dt.Columns.Add("SPI_Price_ErrMsg");
            dt.Columns.Add("SPI_Warehouse");
            dt.Columns.Add("SPI_Warehouse_ErrMsg");
            dt.Columns.Add("SPI_InvoiceDate_ErrMsg");
            dt.Columns.Add("SPI_HospitalName_ErrMsg");
            dt.Columns.Add("SPI_LotShipmentDate");
            dt.Columns.Add("SPI_Remark");
            dt.Columns.Add("SPI_LotShipmentDate_ErrMsg");
            dt.Columns.Add("SPI_Remark_ErrMsg");
            dt.Columns.Add("SPI_ConsignmentNbr");
            dt.Columns.Add("SPI_ConsignmentNbr_ErrMsg");
            dt.Columns.Add("SPI_QrCode_ErrMsg");
            dt.Columns.Add("SPI_QrCode");
            dt.Columns.Add("SPI_NO");
            dt.Columns.Add("SPI_OperType");
            foreach (ShipmentInit data in list)
            {
                DataRow row = dt.NewRow();
                row["SPI_ID"] = data.Id;
                row["SPI_USER"] = data.User;
                row["SPI_UploadDate"] = data.UploadDate;
                row["SPI_LineNbr"] = data.LineNbr;
                row["SPI_FileName"] = data.FileName;
                row["SPI_ErrorFlag"] = data.ErrorFlag;
                row["SPI_ErrorDescription"] = data.ErrorDescription;
                row["SPI_SaleType"] = "";
                //row["SPI_HospitalCode"] = data.HospitalCode;
                row["SPI_HospitalName"] = data.HospitalName;
                row["SPI_HospitalOffice"] = data.HospitalOffice;
                row["SPI_InvoiceNumber"] = data.InvoiceNumber;
                row["SPI_InvoiceTitle"] = data.InvoiceTitle;
                row["SPI_InvoiceDate"] = data.InvoiceDate;
                row["SPI_ShipmentDate"] = data.ShipmentDate;
                row["SPI_ArticleNumber"] = data.ArticleNumber;
                row["SPI_ChineseName"] = data.ChineseName;
                row["SPI_LotNumber"] = data.LotNumber;
                row["SPI_Price"] = data.Price;
                row["SPI_ExpiredDate"] = data.ExpiredDate;
                //row["SPI_UOM"] = data.Uom;
                row["SPI_Qty"] = data.Qty;
                row["SPI_DMA_ID"] = data.DmaId;
                //row["SPI_HOS_ID"] = data.HosId;
                //row["SPI_CFN_ID"] = data.CfnId;
                //row["SPI_PMA_ID"] = data.PmaId;
                //row["SPI_BUM_ID"] = data.BumId;
                row["SPI_HospitalCode_ErrMsg"] = data.HospitalCodeErrMsg;
                row["SPI_ShipmentDate_ErrMsg"] = data.ShipmentDateErrMsg;
                row["SPI_ArticleNumber_ErrMsg"] = data.ArticleNumberErrMsg;
                row["SPI_LotNumber_ErrMsg"] = data.LotNumberErrMsg;
                row["SPI_Qty_ErrMsg"] = data.QtyErrMsg;
                row["SPI_Price_ErrMsg"] = data.PriceErrMsg;
                row["SPI_Warehouse"] = data.Warehouse;
                row["SPI_Warehouse_ErrMsg"] = data.WarehouseErrMsg;
                row["SPI_InvoiceDate_ErrMsg"] = data.InvoiceDateErrMsg;
                row["SPI_HospitalName_ErrMsg"] = data.HospitalNameErrMsg;
                row["SPI_LotShipmentDate"] = data.LotShipmentDate;
                row["SPI_Remark"] = data.Remark;
                row["SPI_LotShipmentDate_ErrMsg"] = data.LotShipmentDateErrMsg;
                row["SPI_Remark_ErrMsg"] = data.RemarkErrMsg;
                row["SPI_ConsignmentNbr"] = data.ConsignmentNbr;
                row["SPI_ConsignmentNbr_ErrMsg"] = data.ConsignmentNbrErrMsg;
                row["SPI_QrCode_ErrMsg"] = data.QrCodeErrMsg;
                row["SPI_QrCode"] = data.QrCode;
                row["SPI_NO"] = data.No;
                row["SPI_OperType"] = data.OperType;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("ShipmentInit", dt);
        }


        public int UpdateForEdit(ShipmentInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentInitForEdit", obj);
            return cnt;
        }

        /// <summary>
        /// 调用存储过程二次初始化库存

        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(Guid UserId, int IsImport, Guid SubCompanyId, Guid BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("IsImport", IsImport);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_ShipmentInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public IList<ShipmentInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<ShipmentInit> list = this.ExecuteQueryForList<ShipmentInit>("SelectShipmentInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }

        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentInitByUser", UserId);
            return cnt;
        }

        public ShipmentInit SelectShipmentCount(Guid userId)
        {
            ShipmentInit obj = this.ExecuteQueryForObject<ShipmentInit>("SelectShipmentCount", userId);
            return obj;
        }

        public void InsertImportData(Guid userId, string SubCompanyId, string BrandId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("BatchNbr", null);
            ht.Add("ClientID", null);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_Sales", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();

        }

        #region 
        public DataSet SelectShipmentInitList(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentInitList", table);
            return ds;
        }
        public DataSet GetShipmentInit(string dmaId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckShipmentInit", dmaId);
            return ds;
        }
        public DataSet QueryShipmentInitResult(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentInitResult", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet ExportShipmentInitResult(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportShipmentInitResult", table);
            return ds;
        }
        public DataSet QueryShipmentInitProcessing(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentInitProcessing", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet QueryDealerAuthorizationList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerAuthorizationListByFilter", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet GetShipmentInitSum(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentInitSum", table);
            return ds;
        }
        public DataSet GetShipmentInitNoConfirm(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentInitNoConfirm", table);
            return ds;
        }
        public int ConfirmShipmenInit(string stringNo)
        {
            int cnt = (int)this.ExecuteUpdate("ConfirmShipmenInit", stringNo);
            return cnt;
        }
        #endregion

    }
}