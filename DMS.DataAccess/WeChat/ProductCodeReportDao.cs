
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : Wechatfqa
 * Created Time: 2014/5/29 13:48:01
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
    /// ProductCodeReport的Dao
    /// </summary>
    public class ProductCodeReportDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ProductCodeReportDao()
            : base()
        {
        }

        public DataSet SelectProductCodeReportList(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectProductCodeReportList", condition, start, limit, out totalCount);
            return list;
        }

        public ProductCodeReport SelectProductCodeReportById(String reportId)
        {
            ProductCodeReport obj = this.ExecuteQueryForObject<ProductCodeReport>("SelectProductCodeReportById", reportId);
            return obj;
        }

        /// <summary>
        /// 查询二维码对应的产品 2016-1-29
        /// </summary>
        /// <param name="QrCode"></param>
        /// <returns></returns>
        public DataSet ProductCodeQuery(string QrCode)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ProductCodeQuery", QrCode);
            return ds;
        }
        /// <summary>
        /// 查询二维码产品的经销商
        /// </summary>
        /// <param name="QrCode"></param>
        /// <returns></returns>
        public DataSet ProductDelareQuery(string QrCode)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ProductDelareQuery", QrCode);
            return ds;
        }


        public DataSet SelectQrCodeByCode(string qrCode)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ProductCodeReportMap.SelectQrCodeByCode", qrCode);
            return ds;
        }
    }
}