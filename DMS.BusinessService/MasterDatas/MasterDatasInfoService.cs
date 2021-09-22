using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess.MasterDatas;
using DMS.ViewModel.Common;
using DMS.ViewModel.MasterDatas;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class MasterDatasInfoService : ABaseBusinessService
    {
        #region Ajax Method
        IRoleModelContext _context = RoleModelContext.Current;
        public MasterDatasInfoVo Init(MasterDatasInfoVo model)
        {
            MasterDatasDao Dao = new MasterDatasDao();
            try
            {

                if (model.Year == "undefined")
                {
                    bool IptIsFlag = false;
                    model.IptIsFlag = IptIsFlag;
                }
                else
                {
                    DataTable tb = new DataTable();
                    tb = Dao.SelectMasterDatasInfo(model.Year);
                    if (tb.Rows.Count > 0)
                    {
                        if (tb.Rows[0]["Date10"].ToString() == "是")
                        {
                            model.IptIsFlag = true;
                        }
                        else
                        {
                            model.IptIsFlag = false;
                        }
                        model.QryApplyDate = tb.Rows[0].GetSafeDatetimeValue("Date1").To_yyyy_MM_dd();
                    }
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public MasterDatasInfoVo Submit(MasterDatasInfoVo model)
        {
            try
            {
                string operation = "";
                MasterDatasDao Dao = new MasterDatasDao();
                DataTable tb = new DataTable();
                tb = Dao.SelectMasterDatasInfoUpdate(model.QryApplyDate.ToString());
                DateTime dt = DateTime.Parse(model.QryApplyDate.ToString());
                string yy = dt.Year.ToString();
                string mm = dt.Month.ToString();
                if (mm != "10" && mm != "11" && mm != "12")
                {
                    mm = "0" + mm;
                }
                string Date = yy + mm;
                if (model.Year == "undefined")
                {
                    Dao.InsertMasterDatas(model.IptIsFlag, model.QryApplyDate.ToString());
                    operation = "Insert";
                    model.messages = true;
                }
                else
                {
                    if (model.Year == Date)
                    {
                        Dao.UpdateMasterDatas(model.IptIsFlag, model.QryApplyDate.ToString());
                        operation = "Update";
                        model.messages = true;
                    }
                    else
                    {
                        model.messages = false;
                    }
                }
                Dao.InsertCalendarDateLog(_context.UserName, model.QryApplyDate.ToString(), operation);
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
