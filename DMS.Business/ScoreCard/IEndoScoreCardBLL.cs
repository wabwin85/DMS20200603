using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.Business.ScoreCard
{
    public interface IEndoScoreCardBLL
    {
        DataSet GetESCAttachment(Guid obj, int start, int limit, out int totalRowCount);
        DataSet QueryESCAttachmentByESCNo(string obj, int start, int limit, out int totalRowCount);
        EndoScoreCard QueryEndoScoreCardByID(Guid Id);
        
        DataSet QueryEndoScoreCardByIDForDS(string Id);
        DataSet QueryEndoScoreCardByCondition(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet QueryScoreCardLogByFilter(Hashtable obj, int start, int limit, out int totalRowCount);
        bool Delete(Guid id);
        int UpdateDealerConfirm(Hashtable obj);
        int UpdateLPConfirm(string obj);
        void AddScAttachment(ScAttachment obj);
        int GetFileCount(Guid obj);
        int UpdateAdminScore(Hashtable obj);
        DataSet GetEditTotalScoreById(Hashtable obj);
        void Insert(ScoreCardLog obj);
        DataSet GetScoreCardIdByNo(string obj);
        DataSet GetUserIdByName(string obj);

        DataSet QueryEndoScoreCardHeaderByCondition(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet QueryEndoScoreCardDetailById(Guid Id, int start, int limit, out int totalRowCount);
        EndoScoreCardHeader QueryEndoScoreCardHeaderByID(Guid Id);
        DataSet ExportEndoScoreCardDetailForLP(Guid EschID);
    }
}
