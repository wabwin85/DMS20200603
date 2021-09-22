using System;
using System.Collections.Generic;

namespace DMS.Business
{
    using DMS.Common;
    using DMS.Model;
    using Coolite.Ext.Web;
    using System.Data;
    using System.Collections;

    public interface IDealerContracts
    {
        IList<DealerContract> SelectByFilter(DealerContract dealerContract, int start, int limit, out int rowCount);
        IList<DealerAuthorization> GetAuthorizationList(DealerAuthorization param);//Edited By Song Yuqi On 2016-05-23
        IList<DealerAuthorization> GetAuthorizationListByDealer(DealerAuthorization param);//Edited By Song Yuqi On 2016-05-23
        DataSet GetAuthorizationListForDataSet(DealerAuthorization param);//Edited By Song Yuqi On 2016-05-23
        DataSet GetAuthorizationListForDataSetExclude(Guid contractId, Guid authId);
        /// <summary>
        /// Checks the authorization parts.
        /// 检查选择的分类是否已存在，如果存在则验证通不过则返回false, 验证通过返回true
        /// </summary>
        /// <param name="categoryID">The category ID.</param>
        /// <param name="dealerID">The dealer ID.</param>
        /// <param name="flag">The flag.</param>
        /// <returns></returns>
        bool CheckAuthorizationParts(Guid categoryID, Guid dealerID, out int flag);

        bool DeleteAuthorization(Guid authId);
        DealerContract GetContract(Guid contractId);
        bool DeleteContract(Guid contractId);
        bool SaveContract(DealerContract contract);

        bool SaveAuthorizationOfDealerChanges(ChangeRecords<DealerAuthorization> data);
        bool SaveAuthorizationChanges(DealerAuthorization data,string optionStatus);
        
        bool SaveHospitalOfAuthorization(Guid datId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict, Guid productLineId, string hosRemark, DateTime AuthStartDate, DateTime AuthStopDate);
        void DetachHospitalFromAuthorization(Guid datId, Guid[] changes);

        void CopyHospitalFromOtherAuth(Guid datId, Guid fromDatId, DateTime startDate, DateTime endDate);

        //added by songyuqi on 20100901
        bool VerifyDealerIsUniqueness(Guid dealerID);

        bool SaveHositalAuthDate(Guid datId, Guid hosId, DateTime authStartDate, DateTime authEndDate);

        IList<DealerAuthorization> GetLimitAuthorizationListByDealer(DealerAuthorization param);
        DataSet SelectByDealerDealerContractActiveFlag(Hashtable obj);
    }
}
