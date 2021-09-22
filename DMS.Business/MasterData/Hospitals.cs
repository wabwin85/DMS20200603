/**********************************************
 *
 * NameSpace   : DMS.Business 
 * ClassName   : Hospitals
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Grapecity.Logging.CallHandlers;

    using Coolite.Ext.Web;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;
    using Lafite.RoleModel.Security.Authorization;
    using DMS.DataAccess;
    using DMS.Model;
    using DMS.Common;
    using System.Data;

    /// <summary>
    /// </summary>
    /// <remarks>Hospitals 医院信息维护</remarks>
    public class Hospitals : BaseBusiness, IHospitals
    {
        #region Action Define
        public const string Action_Hospitals = "Hospitals";
        public const string Action_HospitalsOfProductLine = "HospitalOfProductLine";
        public const string Action_HospitalOfSales = "HospitalOfSales";

        #endregion


        public Hospitals()
        { }

        private IRoleModelContext _context = RoleModelContext.Current;



        #region GetObject, Insert, Update , Delete

        /// <summary>
        /// 返回单个对象
        /// </summary>
        /// <param name="hosId"></param>
        /// <returns></returns>
        public Hospital GetObject(Guid hosId)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                return dao.GetHospital(hosId);
            }
        }

        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        public bool Insert(Hospital hospital)
        {
            bool result = false;
            using (HospitalDao dao = new HospitalDao())
            {
                hospital.HosLastModifiedDate = DateTime.Now;
                hospital.HosLastModifiedByUsrUserid = new Guid(_context.User.Id);

                hospital.HosCreatedDate = hospital.HosLastModifiedDate;
                hospital.HosCreatedBy = hospital.HosLastModifiedByUsrUserid;

                object ojb = dao.Insert(hospital);
                dao.InsertProductLineHospital();
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        public bool Update(Hospital hospital)
        {
            bool result = false;
            using (HospitalDao dao = new HospitalDao())
            {
                hospital.HosLastModifiedDate = DateTime.Now;
                hospital.HosLastModifiedByUsrUserid = new Guid(_context.User.Id);

                int afterRow = dao.Update(hospital);
            }
            return result;
        }

        /// <summary>
        /// 逻辑删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        public bool FakeDelete(Guid hospitalId)
        {
            bool result = false;
            using (HospitalDao dao = new HospitalDao())
            {
                Hospital hospital = new Hospital();
                hospital.HosId = hospitalId;
                hospital.HosDeletedFlag = true;

                hospital.HosLastModifiedDate = DateTime.Now;
                hospital.HosLastModifiedByUsrUserid = new Guid(_context.User.Id);


                int afterRow = dao.FakeDelete(hospital);
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        public bool Delete(Guid hospitalId)
        {
            bool result = false;

            using (HospitalDao dao = new HospitalDao())
            {
                object obj = dao.Delete(hospitalId);
            }
            return result;
        }
        #endregion


        #region 查询
        /// <summary>
        /// 查询，带分页
        /// </summary>
        /// <param name="hospital"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>

        [AuthenticateHandler(ActionName = Action_Hospitals, Description = "医院信息维护", Permissoin = PermissionType.Read)]
        public IList<Hospital> SelectByFilter(Hospital hospital, int start, int limit, out int totalRowCount)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                hospital.HosDeletedFlag = false;
                return dao.SelectByFilter(hospital, start, limit, out totalRowCount);
            }
        }
        
        [AuthenticateHandler(ActionName = Action_Hospitals, Description = "医院信息维护", Permissoin = PermissionType.Read)]
        public DataSet SelectByFilter_DataSet(Hospital hospital, int start, int limit, out int totalRowCount)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                hospital.HosDeletedFlag = false;
                return dao.SelectByFilter_DataSet(hospital, start, limit, out totalRowCount);
            }
        }

        public IList<Hospital> SelectByFilter(Hospital hospital)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                hospital.HosDeletedFlag = false;
                return dao.SelectByFilter(hospital);
            }
        }
        #endregion

        #region 根据产品线查询医院

        private Hashtable BuildProductLineParams(Hospital hospital, ExistsState isCheckProductLine, ref Guid productLineId)
        {
            Hashtable table = new Hashtable();
            table.Add("HosDeletedFlag", false);

            if (isCheckProductLine != ExistsState.All)
            {
                table.Add("IsCheckProductLine", (short)isCheckProductLine);
                table.Add("ProductLineId", productLineId);
            }

            if (hospital != null)
            {
                table.Add("HosHospitalName", hospital.HosHospitalName);
                table.Add("HosGrade", hospital.HosGrade);
                table.Add("HosKeyAccount", hospital.HosKeyAccount);

                table.Add("HosProvince", hospital.HosProvince);
                table.Add("HosDistrict", hospital.HosDistrict);
                table.Add("HosCity", hospital.HosCity);
            }
            return table;
        }

        //重载，用于查找产品线相关的某医院
        private Hashtable BuildProductLineParams(Hospital hospital, ExistsState isCheckProductLine, ref Guid productLineId, string hosName)
        {
            Hashtable table = new Hashtable();
            table.Add("HosDeletedFlag", false);

            if (isCheckProductLine != ExistsState.All)
            {
                table.Add("IsCheckProductLine", (short)isCheckProductLine);
                table.Add("ProductLineId", productLineId);
            }

            if (hospital != null)
            {
                table.Add("HosHospitalName", hospital.HosHospitalName);
                table.Add("HosGrade", hospital.HosGrade);
                table.Add("HosKeyAccount", hospital.HosKeyAccount);

                table.Add("HosProvince", hospital.HosProvince);
                table.Add("HosDistrict", hospital.HosDistrict);
                table.Add("HosCity", hospital.HosCity);
            }
            if (hosName != null)
            {
                table.Add("HosHospitalName", hosName);
            }
            return table;
        }


        [AuthenticateHandler(ActionName = Action_HospitalsOfProductLine, Description = "医院与产品线关系", Permissoin = PermissionType.Read)]
        public IList<Hospital> GetListByProductLine(Guid lineId)
        {
            return this.SelectByProductLine(null, ExistsState.IsExists, lineId);
        }

        //重载，用于查找产品线相关的某医院
        [AuthenticateHandler(ActionName = Action_HospitalsOfProductLine, Description = "医院与产品线关系", Permissoin = PermissionType.Read)]
        public IList<Hospital> GetListByProductLine(Guid lineId, string hosName)
        {
            return this.SelectByProductLine(null, ExistsState.IsExists, lineId, hosName);
        }


        public IList<Hospital> SelectByProductLine(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId)
        {
            Hashtable table = BuildProductLineParams(hospital, isCheckProductLine, ref productLineId);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByProductLine(table);
            }
        }

        //重载，用于查找产品线相关的某医院
        public IList<Hospital> SelectByProductLine(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId, string hosName)
        {
            Hashtable table = BuildProductLineParams(hospital, isCheckProductLine, ref productLineId, hosName);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByProductLine(table);
            }
        }


        public IList<Hospital> SelectByProductLine(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId,
            int start, int limit, out int totalRowCount)
        {
            Hashtable table = BuildProductLineParams(hospital, isCheckProductLine, ref productLineId);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByProductLine(table, start, limit, out totalRowCount);
            }
        }

        public DataSet SelectByProductLine_DataSet(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId,
            int start, int limit, out int totalRowCount)
        {
            Hashtable table = BuildProductLineParams(hospital, isCheckProductLine, ref productLineId);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByProductLine_DataSet(table, start, limit, out totalRowCount);
            }
        }

        //重载，用于查找产品线相关的某医院
        public IList<Hospital> SelectByProductLine(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId, string hosName,
            int start, int limit, out int totalRowCount)
        {
            Hashtable table = BuildProductLineParams(hospital, isCheckProductLine, ref productLineId, hosName);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByProductLine(table, start, limit, out totalRowCount);
            }
        }

        //DCMS 区分新兴市场
        public DataSet SelectByProductLineForDCMS(Hashtable hospital, int start, int limit, out int totalRowCount)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByProductLineDCMS(hospital, start, limit, out totalRowCount);
            }
        }

        #endregion

        #region 根据销售人员(TSR)查询医院

        private Hashtable BuilderSalesParams(Hospital hospital, ExistsState isCheckSales, ref Guid productLineId, ref Guid saleId)
        {
            Hashtable table = new Hashtable();
            table.Add("HosDeletedFlag", false);
            table.Add("ProductLineId", productLineId);

            if (isCheckSales != ExistsState.All)
            {
                table.Add("IsCheckSales", (short)isCheckSales);
                table.Add("SaleId", saleId);
            }


            if (hospital != null)
            {
                table.Add("HosHospitalName", hospital.HosHospitalName);
                table.Add("HosGrade", hospital.HosGrade);
                table.Add("HosKeyAccount", hospital.HosKeyAccount);

                table.Add("HosProvince", hospital.HosProvince);
                table.Add("HosDistrict", hospital.HosDistrict);
                table.Add("HosCity", hospital.HosCity);
            }
            return table;
        }


        /// <summary>
        /// Gets the list by sales.
        /// </summary>
        /// <param name="saleId">The sale id.</param>
        /// <param name="lineId">The line id.</param>
        /// <returns></returns>
        public IList<Hospital> GetListBySales(Guid lineId, Guid saleId)
        {
            return this.SelectBySales(null, ExistsState.IsExists, lineId, saleId);
        }


        /// <summary>
        /// Selects the by sales.
        /// </summary>
        /// <param name="hospital">The hospital.</param>
        /// <param name="isCheckSales">The is check sales.</param>
        /// <param name="saleId">The sale id.</param>
        /// <param name="lineId">The line id.</param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_HospitalOfSales, Description = "医院与TSR关系", Permissoin = PermissionType.Read)]
        public IList<Hospital> SelectBySales(Hospital hospital, ExistsState isCheckSales, Guid lineId, Guid saleId)
        {
            Hashtable table = BuilderSalesParams(hospital, isCheckSales, ref lineId, ref saleId);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectBySales(table);
            }
        }


        /// <summary>
        /// Selects the by sales.
        /// </summary>
        /// <param name="hospital">The hospital.</param>
        /// <param name="isCheckSales">The is check sales.</param>
        /// <param name="saleId">The sale id.</param>
        /// <param name="start">The start.</param>
        /// <param name="limit">The limit.</param>
        /// <param name="totalRowCount">The total row count.</param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_HospitalOfSales, Description = "医院与TSR关系", Permissoin = PermissionType.Read)]
        public IList<Hospital> SelectBySales(Hospital hospital, ExistsState isCheckSales, Guid lineId, Guid saleId,
               int start, int limit, out int totalRowCount)
        {
            Hashtable table = BuilderSalesParams(hospital, isCheckSales, ref lineId, ref saleId);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectBySales(table, start, limit, out totalRowCount);
            }
        }

        #endregion

        #region 根据授权查医院


        private Hashtable BuilderAuthorizationParams(Hospital hospital, ExistsState isAuthorization, Guid? authorizationId)
        {
            Hashtable table = new Hashtable();
            table.Add("HosDeletedFlag", false);

            if (isAuthorization != ExistsState.All)
            {
                table.Add("IsAuthorization", (short)isAuthorization);
                table.Add("AuthorizationId", authorizationId);
            }

            if (hospital != null)
            {
                table.Add("HosHospitalName", hospital.HosHospitalName);
                table.Add("HosGrade", hospital.HosGrade);
                table.Add("HosKeyAccount", hospital.HosKeyAccount);

                table.Add("HosProvince", hospital.HosProvince);
                table.Add("HosDistrict", hospital.HosDistrict);
                table.Add("HosCity", hospital.HosCity);
            }

            return table;
        }


        /// <summary>
        /// Selects the by as authorization.
        /// </summary>
        /// <param name="hospital">The hospital.</param>
        /// <param name="authorizationId">The authorization id.</param>
        /// <param name="start">The start.</param>
        /// <param name="limit">The limit.</param>
        /// <param name="totalRowCount">The total row count.</param>
        /// <returns></returns>
        public IList<Hospital> SelectByAsAuthorization(Hospital hospital, Guid authorizationId, int start, int limit, out int totalRowCount)
        {
            Hashtable table = BuilderAuthorizationParams(hospital, ExistsState.IsExists, authorizationId);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByAuthorization(table, start, limit, out totalRowCount);
            }
        }
        public DataSet SelectByAsAuthorizationTemp(Hospital hospital, Guid authorizationId, DateTime EffectiveDate, string isEmerging, int start, int limit, out int totalRowCount)
        {
            Hashtable table = BuilderAuthorizationParams(hospital, ExistsState.IsExists, authorizationId);
            table.Add("EffectiveDate", EffectiveDate);
            table.Add("isEmerging", isEmerging);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByAuthorizationTemp(table, start, limit, out totalRowCount);
            }
        }

        public DataSet SelectByAsAuthorizationTemp(Hospital hospital, Guid authorizationId, DateTime EffectiveDate, string isEmerging)
        {
            Hashtable table = BuilderAuthorizationParams(hospital, ExistsState.IsExists, authorizationId);
            table.Add("EffectiveDate", EffectiveDate);
            table.Add("isEmerging", isEmerging);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByAuthorizationTemp(table);
            }
        }


        public IList<Hospital> SelectByAsAuthorization(Hospital hospital, Guid authorizationId)
        {
            Hashtable table = BuilderAuthorizationParams(hospital, ExistsState.IsExists, authorizationId);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByAuthorization(table);
            }
        }

        #endregion

        #region 根据经销商查医院

        private Hashtable BuilderDealerParams(Hospital hospital, Guid? DealerID)
        {
            Hashtable table = new Hashtable();
            table.Add("HosDeletedFlag", false);
            table.Add("DealerID", DealerID);

            if (hospital != null)
            {
                table.Add("HosHospitalName", hospital.HosHospitalName);
                table.Add("HosGrade", hospital.HosGrade);
                table.Add("HosKeyAccount", hospital.HosKeyAccount);

                table.Add("HosProvince", hospital.HosProvince);
                table.Add("HosDistrict", hospital.HosDistrict);
                table.Add("HosCity", hospital.HosCity);

                //add by songyuqi on 20100713
                //增加医院院长的查询条件
                if (!string.IsNullOrEmpty(hospital.HosDirector))
                {
                    table.Add("HosDirector", hospital.HosDirector);
                }
            }

            return table;
        }

        /// <summary>
        /// 根据经销商查医院
        /// </summary>
        /// <param name="DealerID"></param>
        /// <param name="start">The start.</param>
        /// <param name="limit">The limit.</param>
        /// <param name="totalRowCount">The total row count.</param>
        /// <returns></returns>
        public IList<Hospital> SelectHospitalListOfDealerAuthorized(Hospital hospital, Guid DealerID, int start, int limit, out int totalRowCount)
        {
            Hashtable table = BuilderDealerParams(hospital, DealerID);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectHospitalListOfDealerAuthorized(table, start, limit, out totalRowCount);
            }
        }
        #endregion

        #region Save Changes
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中
        /// </summary>
        /// <param name="data"med></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_Hospitals, Description = "医院信息维护", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Hospital, Title = "医院信息维护", Message = "医院信息维护新增、修改、删除", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool SaveChanges(ChangeRecords<Hospital> data)
        {
            bool result = false;

            HospitalDao dao = new HospitalDao();
            using (TransactionScope trans = new TransactionScope())
            {
                foreach (Hospital hospital in data.Deleted)
                {
                    this.FakeDelete(hospital.HosId);
                }

                foreach (Hospital hospital in data.Updated)
                {
                    if (dao.SelectNotDeleteHospitalByCode(hospital.HosKeyAccount, hospital.HosId).Count > 0)
                    {
                        throw new Exception("医院编号:" + hospital.HosKeyAccount + "重复。");
                    }

                    if (dao.SelectNotDeleteHospitalByName(hospital.HosHospitalName, hospital.HosId).Count > 0)
                    {
                        throw new Exception("医院名称:" + hospital.HosHospitalName + "重复。");
                    }
                    this.Update(hospital);
                }

                foreach (Hospital hospital in data.Created)
                {
                    if (dao.SelectNotDeleteHospitalByName(hospital.HosHospitalName, hospital.HosId).Count > 0)
                    {
                        throw new Exception("医院名称:" + hospital.HosHospitalName + "重复。");
                    }

                    //如果是新建医院，则系统自动分配编号
                    AutoNumberBLL autoNumberBll = new AutoNumberBLL();
                    string code = autoNumberBll.GetNextAutoNumberForCode(CodeAutoNumberSetting.Next_HospitalNbr);
                    hospital.HosKeyAccount = code;

                    if (dao.SelectNotDeleteHospitalByCode(hospital.HosKeyAccount, hospital.HosId).Count > 0)
                    {
                        throw new Exception("医院编号:" + hospital.HosKeyAccount + "重复。");
                    }

                    this.Insert(hospital);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }



        [AuthenticateHandler(ActionName = Action_HospitalsOfProductLine, Description = "医院与产品线关系", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Hospital, Title = "医院信息维护", Message = "医院与产品线关系新增、删除", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool SaveHospitalOfProductLineChanges(ChangeRecords<Hospital> data, Guid productLineId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                HospitalDao dao = new HospitalDao();

                foreach (Hospital hospital in data.Deleted)
                {
                    dao.DetachHospitalFromProductLine(productLineId, hospital.HosId);
                }

                foreach (Hospital hospital in data.Created)
                {
                    dao.AttachHospitalToProductLine(productLineId, hospital.HosId);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }


        [AuthenticateHandler(ActionName = Action_HospitalOfSales, Description = "医院与TSR关系", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Hospital, Title = "医院与TSR关系", Message = "医院与TSR关系新增、删除", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool SaveHospitalOfSales(Guid saleId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict, Guid lineId)
        {
            bool result = false;
            if (selectType == SelectTerritoryType.Default)
            {
                if (changes.Length > 0)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        HospitalDao dao = new HospitalDao();

                        foreach (Dictionary<string, string> hospital in changes)
                        {
                            dao.AttachHospitalToSales(lineId, saleId, new Guid(hospital["Key"]));
                        }

                        trans.Complete();
                    }

                    result = true;
                }
            }
            else
            {
                int rows = 0;


                using (TransactionScope trans = new TransactionScope())
                {
                    HospitalDao dao = new HospitalDao();

                    string hos_City = hosCity;
                    string hos_District = hosDistrict;

                    foreach (Dictionary<string, string> territory in changes)
                    {
                        if (selectType == SelectTerritoryType.District)
                            hos_District = territory["Value"];
                        else
                        {
                            hos_District = string.Empty;
                            hos_City = territory["Value"];
                        }
                        rows += dao.AttachHospitalToSales(saleId, hosProvince, hos_City, hos_District, lineId);
                    }
                    if (rows > 0)
                    {
                        trans.Complete();
                    }
                }

                if (rows > 0)
                    result = true;
            }

            return result;
        }

        public bool SaveHospitalOfSalesChanges(ChangeRecords<Hospital> data, Guid lineId, Guid saleId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                HospitalDao dao = new HospitalDao();

                foreach (Hospital hospital in data.Deleted)
                {
                    dao.DetachHospitalFromSales(lineId, saleId, hospital.HosId);
                }

                foreach (Hospital hospital in data.Created)
                {
                    dao.AttachHospitalToSales(lineId, saleId, hospital.HosId);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }

        public IList<LpHospitalData> QueryLPHospitalInfo(string batchNbr)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                return dao.QueryLPHospitalInfo(batchNbr);
            }
        }
        #endregion

        #region 接口
        public DataSet GetAllHospitals()
        {
            using (HospitalDao dao = new HospitalDao())
            {
                return dao.GetAllHospitals();
            }
        }

        public DataSet GetInHospitalSales(int Year, int Month, int DivisionID)
        {
            Hashtable table = new Hashtable();
            table.Add("Year", Year);
            table.Add("Month", Month);
            table.Add("DivisionID", DivisionID);
            using (HospitalDao dao = new HospitalDao())
            {
                return dao.GetInHospitalSales(table);
            }
        }

        public void UploadHospitalSales(string Upn, string Lot, string HosId, string SubUser, string Rv1, string Rv2, string Rv3, out string rtnVal, out string rtnMsg)
        {
            using (InterfaceSalesDao dao = new InterfaceSalesDao())
            {
                dao.UploadHospitalSales(Upn, Lot, HosId, SubUser, Rv1, Rv2, Rv3, out rtnVal, out rtnMsg);
            }
        }
        #endregion

        //投诉退换货获取医院
        public IList<Hospital> SelectHospitalByAuthorization(Guid hosID)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                Hashtable talbe = new Hashtable();
                talbe.Add("DealerId", hosID);

                return dao.SelectHospitalByAuthorization(talbe);
            }
        }

        public DataSet SelectHospitalByAuthorization(Hashtable talbe, int start, int limit, out int totalRowCount)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectHospitalByAuthorization(talbe, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// Selects the by as authorization.
        /// </summary>
        /// <param name="hospital">The hospital.</param>
        /// <param name="authorizationId">The authorization id.</param>
        /// <param name="start">The start.</param>
        /// <param name="limit">The limit.</param>
        /// <param name="totalRowCount">The total row count.</param>
        /// <returns></returns>
        public IList<Hospital> QueryAuthorizationHospitalList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("HosDeletedFlag", false);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.QueryAuthorizationHospitalList(table, start, limit, out totalRowCount);
            }
        }

        public DataSet GetAuthorizationHospitalList(Hashtable tb, int start, int limit, out int totalRowCount)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                return dao.GetAuthorizationHospitalList(tb, start, limit, out totalRowCount);
            }
        }
        public DataSet GetAuthorizationHospitalListT1(Hashtable tb, int start, int limit, out int totalRowCount)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                return dao.GetAuthorizationHospitalListT1(tb, start, limit, out totalRowCount);
            }
        }

        public bool ExistsHospitalCode(string keyAccount)
        {
            using (HospitalDao dao = new HospitalDao())
            {
                return (dao.recordsOfSameHospitalKeyAccount(keyAccount) >= 1);
            }
        }
    }
}
