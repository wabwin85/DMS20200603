using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.HCPPassport;
using DMS.ViewModel.Common;
using DMS.ViewModel.HCPPassport;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.HCPPassport
{
    public class DealerAccountInfoService : ABaseQueryService
    {
        public DealerAccountInfoVO Init(DealerAccountInfoVO model)
        {
            try
            {
                DealerAccountDao dao = new DealerAccountDao();
                DataTable tb = new DataTable();
                if (!string.IsNullOrEmpty(model.ID))
                {
                    bool IptIsFlag = false;
                    tb = dao.SelectIDENTITYInfoList(model.ID);

                    if (tb.Rows[0]["BOOLEAN_FLAG"].ToString() == "1" && tb.Rows[0]["DELETE_FLAG"].ToString() == "0")
                    {

                        IptIsFlag = true;
                    }
                    model.IptEmail = tb.Rows[0]["EMAIL1"].ToString();
                    model.IptPhone = tb.Rows[0]["PHONE"].ToString();
                    model.IptName = tb.Rows[0]["IDENTITY_NAME"].ToString();
                    model.IptIsFlag = IptIsFlag;
                    model.RstResultList = JsonHelper.DataTableToArrayList(dao.SelectIDENTITYMAPInfo(model.ID));

                    if (RoleModelContext.Current.User.Id.ToLower() == model.ID.ToLower())
                    {
                        model.IsAdmin = true;
                    }
                    else
                    {
                        model.IsAdmin = false;
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

        public DealerAccountInfoVO Save(DealerAccountInfoVO model)
        {
            try
            {
                DealerAccountDao dao = new DealerAccountDao();
                Guid ID = Guid.NewGuid();
                if (string.IsNullOrEmpty(model.ID))
                {

                    dao.InsertIDENTITY(ID, model.IptName, model.IptPhone, model.IptEmail);
                    dao.InsertMembership(ID);
                    for (int i = 0; i < model.Roles.Count; i++)
                    {
                        dao.InsertIDENTITYMAP(ID, model.Roles[i].ToString());
                    }
                }
                else
                {

                    dao.UpdateIDENTITY(new Guid(model.ID), model.IptIsFlag);
                    dao.DeleteIDENTITYMAP(model.ID);
                    for (int i = 0; i < model.Roles.Count; i++)
                    {
                        dao.InsertIDENTITYMAP(new Guid(model.ID), model.Roles[i].ToString());
                    }
                }

                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }


        public static String ConvertKeyValueList(IList<KeyValue> Value)
        {
            String result = "";

            if (Value != null)
            {
                for (int i = 0; i < Value.Count; i++)
                {
                    result += Value[i].Key;
                    if (i != Value.Count - 1)
                    {
                        result += ",";
                    }
                }
            }

            return result;
        }


    }
}
