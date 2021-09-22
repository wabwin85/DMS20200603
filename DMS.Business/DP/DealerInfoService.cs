using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;

namespace DMS.Business.DP
{
    public class DealerInfoService : IDealerInfoService
    {
        #region DealerInfo成员
        public DataSet GetDealerInfoAllServiceByModleID(Guid ModleID)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDealerInfoAllByModleID(ModleID);
            }
        }

        public DataSet GetDealerInfoMain(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDealerInfoMain(obj);
            }
        }

        public DataSet GetVersionByCustCD(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDealerVersionByCustCD(obj);
            }
        }

        public DataSet MaintainBasicData(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.MaintainBasicData(obj);
            }
        }

        public DataSet GetDearDataForLatest(string obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDearDataForLatest(obj);
            }
        }

        public DataSet GetDealerDataByVersion(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDealerDataByVersion(obj);
            }
        }

        public DataSet GetDealerGridData(string obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetGridData(obj);
            }
        }

        public DataSet GetVersionComparison(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetVersionComparison(obj);
            }
        }

        public DataSet GetKeyPerformance(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetKeyPerformance(obj);
            }
        }

        public DataSet GetKeyPerformanceForKPI(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetKeyPerformanceForKPI(obj);
            }
        }

        public DataSet GetKPILogeDate(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetKPILogeDate(obj);
            }
        }

        public DataSet GetKPIStandard(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetKPIStandard(obj);
            }
        }

        public int DeleteDealerInfo(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.DeleteDealerInfo(obj);
            }
        }

        public DataSet GetDstrTwoByUdstrId(string obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDstrTwoByUdstrId(obj);
            }
        }

        public DataSet GetFModePermissions(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetFModePermissions(obj);
            }
        }

        //added by songyuqi on 2012.05.23

        public DataSet GetDealerInfoBySmallClass(Hashtable table)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDealerInfoBySmallClass(table);
            }
        }

        //end

        public DataSet GetKPIStandardList(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetKPIStandardList(obj);
            }
        }

        public DataSet GetKPIStandardByKPIDateAndModleID(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetKPIStandardByKPIDateAndModleID(obj);
            }
        }

        public int DeleteKPIStandard(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.DeleteKPIStandard(obj);
            }
        }

        public DataSet GetCheckIsNoHaveYear(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetCheckIsNoHaveYear(obj);
            }
        }

        public int UpdateDealerInfoForAssessData(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.UpdateDealerInfoForAssessData(obj);
            }
        }


        public DataSet InsertKPIStandard(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.InsertKPIStandard(obj);
            }
        }


        public DataSet GetDepartmentByTrain(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDepartmentByTrain(obj);
            }
        }

        public DataSet GetDstrByUdstrId(string UdstrId)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDstrByUdstrId(UdstrId);
            }
        }


        public DataSet GetContractDate(string Cust_CD)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetContractDate(Cust_CD);
            }
        }


        public DataSet GetAuthorizeDate(string Cust_CD)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetAuthorizeDate(Cust_CD);
            }
        }

        public DataSet GetRewardDate(string Cust_CD)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetRewardDate(Cust_CD);
            }
        }

        public DataSet GetPunishDate(string Cust_CD)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetPunishDate(Cust_CD);
            }
        }

        public DataSet GetRight(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetRight(obj);
            }
        }

        public DataSet SelectDealerInfoByUdstrDP(Hashtable table)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.SelectDealerInfoByUdstrDP(table);
            }
        }

        public DataSet GetDealerGridDataByPMID(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetGridDataByPMID(obj);
            }
        }

        public DataSet GetDealerLatestDataByPMID(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDealerLatestDataByPMID(obj);
            }
        }

        public DataSet GetDealerDetailByPMID(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDealerDetailByPMID(obj);
            }
        }

        public DataSet GetDateChanngNameGrid(Hashtable obj)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDateChanngNameGrid(obj);
            }
        }

        //Add by BSC project
        public DataSet GetReminderTime()
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetReminderTime();
            }
        }

        public DataSet GetDealerNameByID(string id) 
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetDealerNameByID(id);
            }
        }

        public DataSet GetRoleList(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (DealerInfoDao dao = new DealerInfoDao())
            {
                return dao.GetRoleList(obj,start, limit, out totalRowCount);
            }
        }
        #endregion


        
    }
}
