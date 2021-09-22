using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Contract
{

    using DMS.Model;
    using System.Data;
    using System.Collections;
    public interface IThirdPartyDisclosureService
    {
        void SaveThirdPartyDisclosure(ThirdPartyDisclosure thirdParty);

        DataSet GetThirdPartyDisclosureQuery(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet GetThirdPartyDisclosureQuery(Hashtable obj);
        DataSet GetThirdPartyDisclosureQueryNoPL(Hashtable obj);

        DataSet GetThirdPartyDisclosureById(Guid Id);

        int DeleteThirdPartyDisclosureById(Guid Id);

        int UpdateThirdPartyDisclosureById(ThirdPartyDisclosure thirdParty);

        bool SynchronousHospitalToThirdParty(Guid DmaId);

        void SetHospitalNoDisclosure(string[] Id);

        int ApprovalThirdParty(Hashtable obj);

        DataSet GetThirdPartyBuType(Hashtable obj);
        //获取第三方披露表信息 lijie add 20160614
        DataSet QueryThirdPartyDisclosure(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet ExportThirdPartyDisclosure(Hashtable obj);
        //获取第三方披露表经销商对应的医院产品线 lijie add 20160816
        DataSet SelectThirdPartyDisclosureHospitBU(Hashtable obj);
        bool InsertContractLog(Hashtable obj);
        DataSet ThirdPartyDisclosureHospitBU(Hashtable obj);

        DataSet DealerAuthorizationHospital(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet SelectThirdPartyDisclosureList(Hashtable obj, int start, int limit, out int totalRowCount);

        int UpdateThirdPartyDisclosureListById(ThirdPartyDisclosureList thirdParty);

        void SaveThirdPartyDisclosureList(ThirdPartyDisclosureList thirdParty);

        int DeleteThirdPartyDisclosureListById(Guid Id);

        DataSet GetThirdPartyDisclosureListById(Guid Id);
        int ApprovalThirdPartyDisclosureList(Hashtable obj);

        DataSet ThirdPartyDisclosureListByBU(Hashtable obj);
        int RefuseThirdPartyDisclosureList(Hashtable obj);
        DataSet SelectThirdPartyDisclosureList(Hashtable obj);

        DataSet GetThirdPartyDisclosureListBuType(Hashtable obj);

        DataSet SelectThirdPartyDisclosureListHospitBU(Hashtable obj);

        int UpdateThirdPartyDisclosureListend(Hashtable obj);

        void InsertThirdPartyDisclosureListLp(ThirdPartyDisclosureList thirdParty);

        DataSet SelectThirdPartyDisclosureListType(Hashtable obj, int start, int limit, out int totalRowCount);

        DataSet SelectThirdPartylist(Hashtable obj);
        DataSet ThirdPartylist(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet ThirdPartylist(Hashtable obj);

        DataSet Authorinformation(Hashtable obj);

        int updateendThirdPartyList(Hashtable obj);

        int endThirdPartyList(Hashtable obj);

        DataSet ThirdPartyDisclosureListALL(Hashtable obj);

        DataSet ExportThirdPartylist(Hashtable obj);

        int TerminationThirdPartyList(Hashtable obj);
    }

}
