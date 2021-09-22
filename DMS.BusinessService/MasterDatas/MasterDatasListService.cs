using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.MasterDatas;
using DMS.ViewModel.MasterDatas;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class MasterDatasListService : ABaseQueryService
    {
        #region Ajax Method

        public MasterDatasListVo Init(MasterDatasListVo model)
        {
            try
            {

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public MasterDatasListVo Query(MasterDatasListVo model)
        {
            try
            {
                MasterDatasDao Dao = new MasterDatasDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(Dao.SelectMasterDatasList
                  (model.QryApplyDate));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        #endregion
    }
}
