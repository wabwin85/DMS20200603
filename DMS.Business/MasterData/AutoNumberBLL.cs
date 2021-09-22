using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;
    using DMS.DataAccess;
    using DMS.Model;
    using DMS.Common;
    using System.Collections;

    public class AutoNumberBLL
    {
        public AutoNumberBLL()
        {
        }

        /// <summary>
        /// 通过产品线获得自动编号
        /// </summary>
        /// <param name="DMA_ID">经销商代码</param>
        /// <param name="orderType">业务单据类型</param>
        /// <param name="productLineID">字符型产品线代码</param>
        /// <returns>业务单据编号</returns>
        public string GetNextAutoNumber(Guid DMA_ID, OrderType orderType, string productLineID)
        {
            OrganizationUnit bu = OrganizationHelper.GetParentOrganizationUnit(BusinessUnitType.BU.ToString(), productLineID);
            string strBU = bu.AttributeName;
            return GetNextAutoNumberByBUName(DMA_ID, orderType, strBU);
        }

        /// <summary>
        /// 通过产品线获得自动编号
        /// </summary>
        /// <param name="DMA_ID">经销商代码</param>
        /// <param name="orderType">业务单据类型</param>
        /// <param name="productLineID">产品线代码</param>
        /// <returns>业务单据编号</returns>
        public string GetNextAutoNumber(Guid DMA_ID, OrderType orderType, Guid productLineID)
        {
            OrganizationUnit bu = OrganizationHelper.GetParentOrganizationUnit(BusinessUnitType.BU.ToString(), productLineID.ToString());
            string strBU = bu.AttributeName;
            return GetNextAutoNumberByBUName(DMA_ID, orderType, strBU);
        }

        /// <summary>
        /// 通过经销商编号、单据类型获得自动编号

        /// </summary>
        /// <param name="DMA_ID">经销商代码</param>
        /// <param name="orderType">业务单据类型</param>       
        /// <returns>业务单据编号</returns>
        public string GetNextAutoNumber(Guid DMA_ID, OrderType orderType)
        {
            return GetNextAutoNumberByBUName(DMA_ID, orderType, "");
        }

        /// <summary>
        /// 得到业务单据的编号
        /// </summary>
        /// <param name="DMA_ID">经销商记录代码</param>
        /// <param name="orderType">业务单据类型</param>
        /// <param name="strBU">部门</param>
        /// <returns></returns>
        public string GetNextAutoNumberByBUName(Guid DMA_ID, OrderType orderType, string strBU)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (AutoNumberDao dao = new AutoNumberDao())
            {
                return dao.GetNextAutoNumber(DMA_ID, orderType.ToString(), strBU, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        /// </summary>
        /// <param name="DMA_ID">经销商代码</param>
        /// <param name="orderType">业务单据类型</param>
        /// <param name="productLineID">字符型产品线代码</param>
        /// <returns>业务单据编号</returns>
        public string GetNextAutoNumberForPO(Guid DMA_ID, OrderType strSettings, Guid productLineID, string orderType)
        {

            using (AutoNumberDao dao = new AutoNumberDao())
            {
                return dao.GetNextAutoNumberForPO(DMA_ID, strSettings.ToString(), productLineID, orderType);
            }
        }

        /// <summary>
        /// 二级经销商订单申请生成订单编号 20190925
        /// </summary>
        /// <param name="DMA_ID"></param>
        /// <param name="strSettings"></param>
        /// <param name="productLineID"></param>
        /// <param name="orderType"></param>
        /// <returns></returns>
        public string GetNextAutoNumberForPO_PurchaseNew(Guid DMA_ID, OrderType strSettings, Guid productLineID, string orderType, Guid SubCompanyId, Guid BrandId)
        {

            using (AutoNumberDao dao = new AutoNumberDao())
            {
                return dao.GetNextAutoNumberForPO_PurchaseNew(DMA_ID, strSettings.ToString(), productLineID, orderType, SubCompanyId, BrandId);
            }
        }

        /// <summary>
        /// 生成盘点单据号 @added by bozhenfei on 20100609
        /// </summary>
        /// <param name="DMA_ID"></param>
        /// <param name="orderType"></param>
        /// <param name="productLineID"></param>
        /// <returns></returns>
        public string GetNextAutoNumberForST(Guid DMA_ID, OrderType orderType)
        {

            using (AutoNumberDao dao = new AutoNumberDao())
            {
                return dao.GetNextAutoNumberForST(DMA_ID, orderType.ToString());
            }
        }

        /// <summary>
        /// 生成经销商付款通知单号 @added by bozhenfei on 20100223
        /// </summary>
        /// <param name="DMA_ID"></param>
        /// <param name="orderType"></param>
        /// <returns></returns>
        public string GetNextAutoNumberForPayment(Guid DMA_ID, OrderType orderType)
        {

            using (AutoNumberDao dao = new AutoNumberDao())
            {
                return dao.GetNextAutoNumberForST(DMA_ID, orderType.ToString());
            }
        }

        /// <summary>
        /// 生成接口批处理号 @added by bozhenfei on 20110224
        /// </summary>
        /// <param name="orderType"></param>
        /// <returns></returns>
        public string GetNextAutoNumberForInt(string clientid, DataInterfaceType interfaceType)
        {

            using (AutoNumberDao dao = new AutoNumberDao())
            {
                return dao.GetNextAutoNumberForInt(clientid, interfaceType.ToString());
            }
        }

        public string GetNextAutoNumberForCode(CodeAutoNumberSetting setting)
        {

            using (AutoNumberDao dao = new AutoNumberDao())
            {
                return dao.GetNextAutoNumberForCode(setting.ToString());
            }
        }
    }
}
