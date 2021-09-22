using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Contract
{
    using DMS.Model;
    using System.Data;
    using System.Collections;
    public interface ITrainingSignInService
    {
        DataSet GetTrainingSignInByContId(Guid obj);
        DataSet GetTrainingSignInByContId(Guid obj, int start, int limit, out int totalRowCount);
        void SaveTrainingSignIn(TrainingSignIn trainSignIn);
        void DeleteTrainingSignIn(Guid detailId);
        void UpdateTrainingSignIn(TrainingSignIn trainSignIn);

        TrainingSignIn GetTrainingSignInById(Guid id);

    }
}
