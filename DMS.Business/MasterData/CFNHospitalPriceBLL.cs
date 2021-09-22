using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business 
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using DMS.Model;
    using DMS.DataAccess;
    using DMS.Common;
    using System.Collections;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security.Authorization;
    using Grapecity.Logging.CallHandlers;

    public class CFNHospitalPriceBLL : ICFNHospitalPriceBLL
    {
        #region Action Define
        public const string Action_CFNHospitalPrice = "CFNHospitalPrice";
        #endregion

        private IRoleModelContext _context = RoleModelContext.Current;

        [AuthenticateHandler(ActionName = Action_CFNHospitalPrice, Description = "医院产品价格维护", Permissoin = PermissionType.Read)]
        public IList<CfnHospitalPrice> SelectByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (CfnHospitalPriceDao dao = new CfnHospitalPriceDao())
            {
                return dao.SelectByFilter(obj, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_CFNHospitalPrice, Description = "医院产品价格维护", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_CFNHospitalPrice, Title = "新增医院产品价格", Message = "医院产品价格查询", Categories = new string[] { Data.DMSLogging.CFNHospitalPriceCategory })]
        public bool SaveChanges(ChangeRecords<CfnHospitalPrice> data, Guid ProductLineID, Guid CFN_ID)
        {
            bool result = false;

            CfnHospitalPrice price = new CfnHospitalPrice();
            price.CfnId = CFN_ID;
            price.ProductLineBumId = ProductLineID;

            using (TransactionScope trans = new TransactionScope())
            {
                CfnHospitalPriceDao dao = new CfnHospitalPriceDao();
                foreach (CfnHospitalPrice hospital in data.Deleted)
                {
                    dao.Delete(hospital.Id.Value);
                }

                foreach (CfnHospitalPrice hospital in data.Created)
                {
                    hospital.CreateUser = new Guid(_context.User.Id);
                    hospital.CreateDate = DateTime.Now;
                    hospital.DeletedFlag = false;
                    hospital.CfnId = CFN_ID;
                    dao.Insert(hospital);
                }

                foreach (CfnHospitalPrice hospital in data.Updated)
                {
                    hospital.UpdateUser = new Guid(_context.User.Id);
                    hospital.UpdateDate = DateTime.Now;
                    hospital.CfnId = CFN_ID;
                    dao.Update(hospital);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_CFNHospitalPrice, Description = "医院产品价格维护", Permissoin = PermissionType.Read)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_CFNHospitalPrice, Title = "新增医院产品价格", Message = "医院产品价格查询", Categories = new string[] { Data.DMSLogging.CFNHospitalPriceCategory })]
        public bool SaveChanges(ChangeRecords<CfnHospitalPrice> data)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                CfnHospitalPriceDao dao = new CfnHospitalPriceDao();
                foreach (CfnHospitalPrice price in data.Deleted)
                {
                    dao.Delete(price.Id.Value);
                }

                foreach (CfnHospitalPrice price in data.Created)
                {
                    price.CreateUser = new Guid(_context.User.Id);
                    price.CreateDate = DateTime.Now;
                    price.DeletedFlag = false;
                    dao.Insert(price);
                }

                foreach (CfnHospitalPrice price in data.Updated)
                {
                    price.UpdateUser = new Guid(_context.User.Id);
                    price.UpdateDate = DateTime.Now;
                    dao.Update(price);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }

        [AuthenticateHandler(ActionName = Action_CFNHospitalPrice, Description = "医院产品价格维护", Permissoin = PermissionType.Write)]
        public IList<Hospital> getHospitalList(Guid lineId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict)
        {
            IList<Hospital> list = new List<Hospital>();

            Hospital hos = new Hospital();

            Hashtable table = new Hashtable();

            if (selectType == SelectTerritoryType.Default)
            {
                if (changes.Length > 0)
                {
                    using (HospitalDao dao = new HospitalDao())
                    {

                        foreach (Dictionary<string, string> hospital in changes)
                        {
                            hos = dao.GetHospital(new Guid(hospital["Key"]));
                            list.Add(hos);
                        }
                    }
                }
            }
            else
            {
                using (HospitalDao dao = new HospitalDao())
                {
                    string hos_City = hosCity;
                    string hos_District = hosDistrict;

                    foreach (Dictionary<string, string> territory in changes)
                    {
                        if (selectType == SelectTerritoryType.District)
                        {
                            hos_District = territory["Value"];
                            hos.HosDistrict = hos_District;
                        }
                        else
                        {
                            hos_District = string.Empty;
                            hos_City = territory["Value"];
                            hos.HosCity = hos_City;
                        }

                        IList<Hospital> temp = this.SelectByProductLine(hos, ExistsState.IsExists, lineId);

                        foreach (Hospital hospital in temp)
                        {
                            list.Add(hospital);
                        }
                    }
                }

            }
            return list;
            
        }

        #region 私有方法
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

        private IList<Hospital> SelectByProductLine(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId)
        {
            Hashtable table = BuildProductLineParams(hospital, isCheckProductLine, ref productLineId);

            using (HospitalDao dao = new HospitalDao())
            {
                return dao.SelectByProductLine(table);
            }
        }
        #endregion


    }
}
