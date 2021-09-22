using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using System.Data;
    using System.Data.OleDb;
    using System.IO;

    using Coolite.Ext.Web;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;
    using DMS.DataAccess;
    using DMS.Model;
    using Lafite.RoleModel.Security.Authorization;
    using Grapecity.Logging.CallHandlers;
    using System.Collections;
    using DMS.Model.Data;
    using DataAccess.APIManage;
    using Model.ApiModel;

    /// <summary>
    /// cfn 产品信息维护
    /// </summary>
    public class Cfns : BaseBusiness, ICfns
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public Cfns()
        { }
        #region Consts Define
        public const string Action_Cfns = "CFNInfo";
        public const string Action_CFNBatch = "CFNBatch";
        #endregion

        /// <summary>
        /// 返回单个对象
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public Cfn GetObject(Guid Id)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.GetCfn(Id);
            }
        }

        public Cfn GetObjectByUPN(String upn)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.GetCfnByUpn(upn);
            }
        }

        public Cfn SelectByPMAID(String upn)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.SelectByPMAID(upn);
            }
        }

        /// <summary>
        /// 查询，带分页
        /// </summary>
        /// <param name="hospital"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_Cfns, Description = "CFN查询", Permissoin = PermissionType.Read)]
        public IList<Cfn> SelectByFilter(Cfn cfn, int start, int limit, out int totalRowCount)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            cfn.SubCompanyId = string.IsNullOrEmpty(Convert.ToString(ht["SubCompanyId"])) ? Guid.Empty : new Guid(ht["SubCompanyId"].ToString());
            cfn.BrandId = string.IsNullOrEmpty(Convert.ToString(ht["BrandId"])) ? Guid.Empty : new Guid(ht["BrandId"].ToString());
            using (CfnDao dao = new CfnDao())
            {
                cfn.DeletedFlag = false;
                return dao.SelectByFilter(cfn, start, limit, out totalRowCount);
            }
        }


        [AuthenticateHandler(ActionName = Action_Cfns, Description = "CFN查询", Permissoin = PermissionType.Read)]
        public IList<Cfn> SelectByFilter(Cfn cfn)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            cfn.SubCompanyId = new Guid(ht["SubCompanyId"].ToString());
            cfn.BrandId = new Guid(ht["BrandId"].ToString());
            using (CfnDao dao = new CfnDao())
            {
                cfn.DeletedFlag = false;
                return dao.SelectByFilter(cfn);
            }
        }

        [AuthenticateHandler(ActionName = Action_Cfns, Description = "CFN查询", Permissoin = PermissionType.Read)]
        public IList<Cfn> SelectByFilterIsContain(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (CfnDao dao = new CfnDao())
            {
                BaseService.AddCommonFilterCondition(obj);
                return dao.SelectByFilterIsContain(obj, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_Cfns, Description = "CFN查询", Permissoin = PermissionType.Read)]
        public IList<Cfn> SelectByFilterNoSet(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            BaseService.AddCommonFilterCondition(obj);
            using (CfnDao dao = new CfnDao())
            {
                return dao.SelectByFilterNoSet(obj, start, limit, out totalRowCount);
            }
        }

        public IList<Cfn> SelectByCustomerFaceNbr(Cfn cfn)
        {
            using (CfnDao dao = new CfnDao())
            {
                cfn.DeletedFlag = false;
                return dao.SelectByCustomerFaceNbr(cfn);
            }
        }


        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        public bool Insert(Cfn cfn)
        {
            bool result = false;
            using (CfnDao dao = new CfnDao())
            {
                cfn.LastUpdateDate = DateTime.Now;
                cfn.LastUpdateUser = new Guid(_context.User.Id);

                cfn.CreateDate = cfn.LastUpdateDate;
                cfn.CreateUser = cfn.LastUpdateUser;

                object ojb = dao.Insert(cfn);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        public bool Update(Cfn cfn)
        {
            bool result = false;
            using (CfnDao dao = new CfnDao())
            {
                cfn.LastUpdateDate = DateTime.Now;
                cfn.LastUpdateUser = new Guid(_context.User.Id);

                int afterRow = dao.Update(cfn);
            }
            return result;
        }

        /// <summary>
        /// 逻辑删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        public bool FakeDelete(Guid Id)
        {
            bool result = false;
            using (CfnDao dao = new CfnDao())
            {
                Cfn cfn = new Cfn();
                cfn.Id = Id;

                cfn.DeletedFlag = true;
                cfn.LastUpdateDate = DateTime.Now;
                cfn.LastUpdateUser = new Guid(_context.User.Id);


                int afterRow = dao.FakeDelete(cfn);
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        public bool Delete(Guid Id)
        {
            bool result = false;

            using (CfnDao dao = new CfnDao())
            {
                object obj = dao.Delete(Id);
            }
            return result;
        }

        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_Cfns, Description = "CFN维护", Permissoin = PermissionType.Write)]
        public bool SaveChanges(ChangeRecords<Cfn> data)
        {
            bool result = false;


            using (TransactionScope trans = new TransactionScope())
            {
                foreach (Cfn cfn in data.Deleted)
                {
                    this.FakeDelete(cfn.Id);
                }

                foreach (Cfn cfn in data.Updated)
                {
                    this.Update(cfn);
                }

                foreach (Cfn cfn in data.Created)
                {
                    this.Insert(cfn);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }


        [AuthenticateHandler(ActionName = Action_Cfns, Description = "CFN和产品分类关系维护", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Cfns, Title = "CFN和产品分类关系维护", Message = "CFN和产品分类关系维护", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool SaveCfnOfCatagory(Coolite.Ext.Web.ChangeRecords<Cfn> data, Guid catagoryId, Guid lineId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                CfnDao dao = new CfnDao();

                foreach (Cfn param in data.Deleted)
                {
                    param.LastUpdateUser = new Guid(_context.User.Id);
                    param.LastUpdateDate = DateTime.Now;
                    param.ProductCatagoryPctId = null;
                    param.ProductLineBumId = null;

                    dao.UpdateCatagory(param);
                }

                foreach (Cfn param in data.Updated)
                {
                    param.LastUpdateUser = new Guid(_context.User.Id);
                    param.LastUpdateDate = DateTime.Now;
                    param.ProductCatagoryPctId = catagoryId;
                    param.ProductLineBumId = lineId;

                    dao.UpdateCatagory(param);
                }

                foreach (Cfn param in data.Created)
                {
                    param.LastUpdateUser = new Guid(_context.User.Id);
                    param.LastUpdateDate = DateTime.Now;
                    param.ProductCatagoryPctId = catagoryId;
                    param.ProductLineBumId = lineId;

                    dao.UpdateCatagory(param);
                }

                trans.Complete();

                result = true;
            }

            return result;

        }

        [AuthenticateHandler(ActionName = Action_Cfns, Description = "CFN和产品分类关系维护", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Cfns, Title = "CFN和产品分类关系维护", Message = "CFN和产品分类关系维护", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool SaveCfnPartsRelation(DMS.ViewModel.Common.ChangeRecords<Cfn> data, Guid catagoryId, Guid lineId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                CfnDao dao = new CfnDao();

                foreach (Cfn param in data.Deleted)
                {
                    param.LastUpdateUser = new Guid(_context.User.Id);
                    param.LastUpdateDate = DateTime.Now;
                    param.ProductCatagoryPctId = null;
                    param.ProductLineBumId = null;

                    dao.UpdateCatagory(param);
                }

                foreach (Cfn param in data.Updated)
                {
                    param.LastUpdateUser = new Guid(_context.User.Id);
                    param.LastUpdateDate = DateTime.Now;
                    param.ProductCatagoryPctId = catagoryId;
                    param.ProductLineBumId = lineId;

                    dao.UpdateCatagory(param);
                }

                foreach (Cfn param in data.Created)
                {
                    param.LastUpdateUser = new Guid(_context.User.Id);
                    param.LastUpdateDate = DateTime.Now;
                    param.ProductCatagoryPctId = catagoryId;
                    param.ProductLineBumId = lineId;

                    dao.UpdateCatagory(param);
                }

                trans.Complete();

                result = true;
            }

            return result;

        }

        [AuthenticateHandler(ActionName = Action_CFNBatch, Description = "产品(CFN)批量导入", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Cfns, Title = "产品(CFN)批量导入", Message = "产品(CFN)批量导入", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public void ImportFromExcel(string source, ref int intTotal, ref int intSuccess, ref int intFalse)
        {
            //string strConn = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + source + ";" + "Extended Properties=Excel 8.0;";
            string strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + source + ";" + "Extended Properties=Excel 12.0;";

            DataSet ds = null;

            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                conn.Open();

                string strExcel = "";
                OleDbDataAdapter myCommand = null;

                strExcel = "select * from [sheet1$]";
                myCommand = new OleDbDataAdapter(strExcel, strConn);
                ds = new DataSet();
                myCommand.Fill(ds, "table1");

                intTotal = ds.Tables["table1"].Rows.Count;


                conn.Close();
            }


            //插入数据库

            ICfns bll = new Cfns();

            Cfn param = new Cfn();
            for (int j = 0; j < intTotal; j++)
            {

                //检索是否存在相同的CFN
                param.CustomerFaceNbr = ds.Tables["table1"].Rows[j].ItemArray.GetValue(0).ToString();

                IList<Cfn> query = bll.SelectByCustomerFaceNbr(param);

                if (query.Count == 0)
                {
                    param.Id = this.GetGuid();
                    param.EnglishName = ds.Tables["table1"].Rows[j].ItemArray.GetValue(1).ToString();
                    param.ChineseName = ds.Tables["table1"].Rows[j].ItemArray.GetValue(2).ToString();

                    if (ds.Tables["table1"].Rows[j].ItemArray.GetValue(3).ToString().Trim() == "TRUE")
                    {
                        param.Implant = true;
                    }
                    else
                    {
                        param.Implant = false;
                    }

                    param.Property1 = ds.Tables["table1"].Rows[j].ItemArray.GetValue(4).ToString();
                    param.Property2 = ds.Tables["table1"].Rows[j].ItemArray.GetValue(5).ToString();
                    param.Property3 = ds.Tables["table1"].Rows[j].ItemArray.GetValue(6).ToString();
                    param.Property4 = ds.Tables["table1"].Rows[j].ItemArray.GetValue(7).ToString();
                    param.Property5 = ds.Tables["table1"].Rows[j].ItemArray.GetValue(8).ToString();
                    param.Property6 = ds.Tables["table1"].Rows[j].ItemArray.GetValue(9).ToString();
                    param.Property7 = ds.Tables["table1"].Rows[j].ItemArray.GetValue(10).ToString();
                    param.Property8 = ds.Tables["table1"].Rows[j].ItemArray.GetValue(11).ToString();

                    param.DeleteFlag = false;
                    param.ProductCatagoryPctId = null;
                    param.ProductLineBumId = null;



                    bool boolInsert = bll.Insert(param);
                    if (boolInsert)
                    {
                        intSuccess = intSuccess + 1;
                    }
                }
                else
                {
                    intFalse = intFalse + 1;
                    continue;
                }


            }
        }

        //added by bozhenfei on 20110216
        /// <summary>
        /// 根据经销商和产品线，根据经销商授权查询可订购产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderByAuth(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnDao dao = new CfnDao())
            {
                //Edited By Song Yuqi On 2016-05-31
                DealerContracts dc = new DealerContracts();
                dc.GetDealerSpecialAuthByType(table, DealerAuthorizationType.Order
                        , new Guid(table["DealerId"].ToString())
                        , new Guid(table["ProductLineId"].ToString()));

                BaseService.AddCommonFilterCondition(table);
                return dao.QueryCfnForPurchaseOrderByAuth(table, start, limit, out totalRowCount);

            }
        }

        //added by SongWeiming on 20150203
        /// <summary>
        /// 根据经销商和产品线以及促销政策，查询可订购产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderByPromotion(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnDao dao = new CfnDao())
            {
                //Edied By Song Yuqi On 2016-05-31
                DealerContracts dc = new DealerContracts();
                dc.GetDealerSpecialAuthByType(table, DealerAuthorizationType.Order
                        , new Guid(table["DealerId"].ToString())
                        , new Guid(table["ProductLineId"].ToString()));
                BaseService.AddCommonFilterCondition(table);

                return dao.QueryCfnForPurchaseOrderByPromotion(table, start, limit, out totalRowCount);
            }
        }

        public DataSet GetPromotionTypeById(string Id)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.GetPromotionTypeById(Id);
            }
        }


        //added by songweiming on 20130927
        /// <summary>
        /// 根据经销商和产品线，根据二级经销商授权查询可订购产品（与一级经销商的区别是，只要是CFN表中有的，都可以订购）
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderT2ByAuth(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //Edited By Song Yuqi On 2016-05-30
            using (CfnDao dao = new CfnDao())
            {
                DealerContracts dc = new DealerContracts();
                dc.GetDealerSpecialAuthByType(table, DealerAuthorizationType.Order
                        , new Guid(table["DealerId"].ToString())
                        , new Guid(table["ProductLineId"].ToString()));

                BaseService.AddCommonFilterCondition(table);
                return dao.QueryCfnForPurchaseOrderT2ByAuth(table, start, limit, out totalRowCount);
            }
        }

        //added  by huakaichun on 20151013
        /// <summary>
        /// 获取赠品池产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderByPRO(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnDao dao = new CfnDao())
            {
                //Edied By Song Yuqi On 2016-05-31
                DealerContracts dc = new DealerContracts();
                dc.GetDealerSpecialAuthByType(table, DealerAuthorizationType.Order
                        , new Guid(table["DealerId"].ToString())
                        , new Guid(table["ProductLineId"].ToString()));
                BaseService.AddCommonFilterCondition(table);

                return dao.QueryCfnForPurchaseOrderByPRO(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 获取赠品池产品类型
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public DataSet QueryPromotionProductLineType(Hashtable table)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.QueryPromotionProductLineType(table);
            }
        }

        /// <summary>
        /// 根据经销商、产品线、特殊价格政策编号，查询可订购产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderBySpecialPrice(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.QueryCfnForPurchaseOrderBySpecialPrice(table, start, limit, out totalRowCount);
            }

        }

        /// <summary>
        /// 根据经销商和产品线查询共享产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderByShare(Hashtable table, int start, int limit, out int totalRowCount)
        {
            BaseService.AddCommonFilterCondition(table);
            using (CfnDao dao = new CfnDao())
            {
                return dao.QueryCfnForPurchaseOrderByShare(table, start, limit, out totalRowCount);
            }
        }

        //added by songyuqi on 20100608
        public DataSet SelectCFNForDealerShare(Hashtable table, int start, int limit, out int totalRowCount)
        {
            BaseService.AddCommonFilterCondition(table);
            using (CfnDao dao = new CfnDao())
            {
                return dao.SelectCFNForDealerShare(table, start, limit, out totalRowCount);
            }
        }

        public DataSet SelectCFNForDealerNotShare(Hashtable table, int start, int limit, out int totalRowCount)
        {
            BaseService.AddCommonFilterCondition(table);
            using (CfnDao dao = new CfnDao())
            {
                return dao.SelectCFNForDealerNotShare(table, start, limit, out totalRowCount);
            }
        }

        public DataSet P_GetAllCRMProduction()
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.P_GetAllCRMProduction();
            }
        }

        public IList<ProductData> QueryProductDataInfo()
        {
            using (ProductDao dao = new ProductDao())
            {
                return dao.QueryProductDataInfo();
            }
        }

        public IList<ProductDataForQAComplain> QueryProductDataInfoByUPN(Hashtable ht)
        {
            BaseService.AddCommonFilterCondition(ht);
            using (ProductDao dao = new ProductDao())
            {
                return dao.QueryProductDataInfoByUPN(ht);
            }
        }

        //added by huyong 2014-6-5
        public DataSet P_GetAllCFN()
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.P_GetAllCFN();
            }
        }

        public DataSet P_GetAllProductList()
        {
            using (ProductDao dao = new ProductDao())
            {
                return dao.P_GetAllProductList();
            }
        }

        public string CheckProductMinQty(string cfn, decimal qty)
        {
            string rtnVal = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("CFN", cfn);
            ht.Add("QTY", qty);
            using (ProductDao dao = new ProductDao())
            {

                DataSet ds = dao.CheckProductMinQty(ht);
                rtnVal = ds.Tables[0].Rows[0][0].ToString();
            }
            return rtnVal;
        }

        public IList<Cfn> QueryCfnByFilter(Hashtable table)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.QueryCfnByFilter(table);
            }
        }

        //Add By Hua Kaichun
        public DataSet SelectCFNRegistration(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.SelectCFNRegistration(table, start, limit, out totalRowCount);
            }
        }
        /// <summary>
        /// 短期寄售根据产品线查询组套产品
        /// </summary>
        /// <param name="ProductLineId"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryConsignmentCfnSetBy(string ProductLineId, int start, int limit, out int totalRowCount)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.QueryConsignmentCfnSetBy(ProductLineId, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryCfnForConsignmentMaster(Hashtable table, int start, int limit, out int totalRowCount)
        {
            BaseService.AddCommonFilterCondition(table);
            using (CfnDao dao = new CfnDao())
            {
                return dao.QueryCfnForConsignmentMaster(table, start, limit, out totalRowCount);
            }

        }
        public DataSet SelectCFNRegistrationByUpn(Hashtable ht)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.SelectCFNRegistrationByUpn(ht);
            }
        }
        public DataSet QueryCfnForPurchaseOrderT2ByPRO(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnDao dao = new CfnDao())
            {
                DealerContracts dc = new DealerContracts();
                dc.GetDealerSpecialAuthByType(table, DealerAuthorizationType.Order
                        , new Guid(table["DealerId"].ToString())
                        , new Guid(table["ProductLineId"].ToString()));
                table["DisplayCanOrder"] = table["DisplayCanOrder"].ToString() == "1" ? "是" : "否";
                BaseService.AddCommonFilterCondition(table);
                return dao.QueryCfnForPurchaseOrderT2ByPRO(table, start, limit, out totalRowCount);
            }
        }

        public DataSet SelectCFNRegistrationBylot(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CfnDao dao = new CfnDao())
            {
                return dao.SelectCFNRegistrationBylot(table, start, limit, out totalRowCount);
            }
        }

        public List<UPNDocumentItem> SelectCFNRegistrationBylotAPI(string upnCode, string queryType, string lot)
        {
            List<UPNDocumentItem> ProductDocument = ApiService.GetDMSCMSDocumentLinkDetail(upnCode, queryType, lot).datas;
            return ProductDocument;
        }
    }
}
