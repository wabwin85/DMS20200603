using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;

namespace DMS.Business.DP
{
    public interface IDealerInfoService
    {
        DataSet GetDealerInfoAllServiceByModleID(Guid ModleID);

        DataSet GetDealerInfoMain(Hashtable obj);

        DataSet GetVersionByCustCD(Hashtable obj);

        DataSet MaintainBasicData(Hashtable obj);

        DataSet GetDearDataForLatest(string User_Code);

        DataSet GetDealerDataByVersion(Hashtable obj);

        DataSet GetDealerGridData(string User_Code);

        DataSet GetDealerInfoBySmallClass(Hashtable table);

        DataSet GetVersionComparison(Hashtable obj);

        DataSet GetKeyPerformance(Hashtable obj);

        DataSet GetKeyPerformanceForKPI(Hashtable obj);

        DataSet GetKPILogeDate(Hashtable obj);

        DataSet GetKPIStandard(Hashtable obj);

        int DeleteDealerInfo(Hashtable obj);

        DataSet GetDstrTwoByUdstrId(string obj);

        DataSet GetFModePermissions(Hashtable obj);

        DataSet GetKPIStandardList(Hashtable obj);

        DataSet GetKPIStandardByKPIDateAndModleID(Hashtable obj);

        int DeleteKPIStandard(Hashtable obj);

        DataSet GetCheckIsNoHaveYear(Hashtable obj);

        int UpdateDealerInfoForAssessData(Hashtable obj);

        DataSet InsertKPIStandard(Hashtable obj);

        DataSet GetDepartmentByTrain(Hashtable obj);

        DataSet GetDstrByUdstrId(string UdstrId); //根据经销商ID得到分销商信息

        DataSet GetContractDate(string Cust_CD);

        DataSet GetAuthorizeDate(string Cust_CD);

        DataSet GetRewardDate(string Cust_CD);

        DataSet GetPunishDate(string Cust_CD);

        DataSet GetRight(Hashtable obj);

        DataSet SelectDealerInfoByUdstrDP(Hashtable table);

        DataSet GetDealerGridDataByPMID(Hashtable obj);

        DataSet GetDealerLatestDataByPMID(Hashtable obj);

        DataSet GetDealerDetailByPMID(Hashtable obj);

        DataSet GetDateChanngNameGrid(Hashtable obj);

        //Add by BSC Project
        DataSet GetReminderTime();
        DataSet GetDealerNameByID(string id);
        DataSet GetRoleList(Hashtable obj, int start, int limit, out int totalRowCount);
    }
}
