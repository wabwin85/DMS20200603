using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Contract
{
    using DMS.DataAccess;
    using DMS.Model;
    using System.Collections;
    using System.Data;
    using Lafite.RoleModel.Security.Authorization;
    using Lafite.RoleModel.Security;

    public class TrainingSignInService : ITrainingSignInService
    {
        public DataSet GetTrainingSignInByContId(Guid obj, int start, int limit, out int totalRowCount)
        {
            using (TrainingSignInDao dao = new TrainingSignInDao())
            {
                return dao.SelectTrainingSignInByContId(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet GetTrainingSignInByContId(Guid obj)
        {
            using (TrainingSignInDao dao = new TrainingSignInDao())
            {
                return dao.SelectTrainingSignInByContId(obj);
            }
        }


        public void SaveTrainingSignIn(TrainingSignIn trainSignIn) 
        {
            using (TrainingSignInDao dao = new TrainingSignInDao())
            {
                dao.Insert(trainSignIn);
            }
        }

        public void DeleteTrainingSignIn(Guid detailId)
        {
            using (TrainingSignInDao dao = new TrainingSignInDao())
            {
                dao.Delete(detailId);
            }
        }

        public void UpdateTrainingSignIn(TrainingSignIn trainSignIn)
        {
            using (TrainingSignInDao dao = new TrainingSignInDao())
            {
                dao.Update(trainSignIn);
            }
        }

        public TrainingSignIn GetTrainingSignInById(Guid id) 
        {
            using (TrainingSignInDao dao = new TrainingSignInDao())
            {
                return dao.GetObject(id);
            }
        }
    }
}
