using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using System.Data;
    using System.Collections;

    public interface IDealerTrainBLL
    {
        #region 培训课程维护
        DataSet GetTrainMasterList(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryDealerTrainList(Hashtable obj);
        IList<TrainDetail> SelectDealerTrainDetailByFilter(TrainDetail obj);
        void InsertTrainMaster(TrainMaster TrainM);
        void InsertTrainDetail(TrainDetail TrainD);
        int UpdateTrainMaster(TrainMaster TrainM);
        int UpdateTrainDetail(TrainDetail TrainD);
        int DeleteTrainMasterById(Guid Id);
        int DeleteTrainDetailById(Guid Id);
        int DeleteTrainDetail(TrainDetail Detail);
        DataSet QueryDealerTrainDetailList(Hashtable obj, int start, int limit, out int totalCount);
        TrainDetail GetTrainDetailById(Guid id);
        DataSet GetActiveTrainCourse();
        #endregion

        #region 签约维护
        DataSet QueryDealerSignList(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryDealerSignDetailList(Hashtable obj, int start, int limit, out int totalCount);
        void DeleteDealerSignById(Hashtable obj);
        DataSet QueryDealerSignById(Guid Id);
        #endregion

    }
}
