using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.Business
{
    public interface ISampleApplyBLL
    {
        DataSet GetSampleApplyList(Hashtable table, int start, int limit, out int totalRowCount);
        SampleApplyHead GetSampleApplyHeadById(Guid Id);
        DataSet GetSampleUpnList(Guid HeadId);
        DataSet GetOperLogList(Guid HeadId);
        DataSet GetSampleTestingList(Guid HeadId);
        DataSet GetSampleReturnList(Hashtable table, int start, int limit, out int totalRowCount);
        SampleReturnHead GetSampleRetrunHeadById(Guid Id);

        SampleApplyHead GetSampleApplyHeadByApplyNo(String applyNo);
        SampleReturnHead GetSampleReturnHeadByReturnNo(String returnNo);

        void CreateSampleApply(SampleApplyHead applyHead, IList<SampleUpn> upnList, IList<SampleTesting> testingList);
        void CreateSampleReturn(SampleReturnHead applyHead, IList<SampleUpn> upnList);
        DataTable GetSampleApplyDelivery(String applyNo, String deliveryNo);
        void ReceiveSample(String deliveryNo);
        void CreateSampleEval(IList<SampleEval> evalList);
        decimal GetTotalAmountUsdBySamplyApplyId(Guid id);
    }
}
