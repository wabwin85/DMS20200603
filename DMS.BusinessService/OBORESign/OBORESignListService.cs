using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.OBORESign;
using DMS.ViewModel.Common;
using DMS.ViewModel.OBORESign;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Data;
using DMS.DataAccess.MasterPage;
using DMS.Business;

namespace DMS.BusinessService.OBORESign
{
    public class OBORESignListService : ABaseQueryService
    {

        public OBORESignListVO Init(OBORESignListVO model)
        {
            try
            {

                OBORESignDao dao = new OBORESignDao();
                QueryDao Bu = new QueryDao();
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstProductLineID = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
                if (RoleModelContext.Current.User.CorpType == "LP" || RoleModelContext.Current.User.CorpType == "LS")
                {
                    model.ButtomReadonly = false;
                    model.LstSignA = JsonHelper.DataTableToArrayList(KV(RoleModelContext.Current.User.CorpId.ToString(), RoleModelContext.Current.User.CorpName));
                    model.LstSignB= JsonHelper.DataTableToArrayList(dao.SelectSignB(RoleModelContext.Current.User.CorpId.ToString(), RoleModelContext.Current.User.CorpType));
                }
                else if (RoleModelContext.Current.User.CorpType == "T1" || RoleModelContext.Current.User.CorpType == "T2")
                {
                    model.LstSignA = null;
                    model.LstSignB = JsonHelper.DataTableToArrayList(KV(RoleModelContext.Current.User.CorpId.ToString(), RoleModelContext.Current.User.CorpName));
                }
                else
                {
                    model.LstSignA = JsonHelper.DataTableToArrayList(dao.SelectSignA());
                    model.LstSignB = JsonHelper.DataTableToArrayList(dao.SelectSignB("", RoleModelContext.Current.User.CorpType));
                }
                model.LstStatus= JsonHelper.DataTableToArrayList(dao.DICTTYPE(SR.OBORESign_Status));
                model.LstAgreementType = JsonHelper.DataTableToArrayList(dao.DICTTYPE(SR.OBORESign_Type));







                //model.LstSignB = JsonHelper.DataTableToArrayList(dao.SelectSignB(RoleModelContext.Current.User.CorpType));
                //model.LstSignA = JsonHelper.DataTableToArrayList(dao.SelectSignA(RoleModelContext.Current.User.CorpType));


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }


        public DataTable KV(string a,string b)
        {

            DataTable tb = new DataTable();

            DataColumn Key = new DataColumn("Key", System.Type.GetType("System.String"));
            DataColumn Value = new DataColumn("Value", System.Type.GetType("System.String"));
            tb.Columns.Add(Key);
            tb.Columns.Add(Value);

            DataRow dr = tb.NewRow();
            dr["Key"] = a;
            dr["Value"] =b;
            tb.Rows.Add(dr);

            return tb;
        }

        public OBORESignListVO Query(OBORESignListVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(dao.SelectOBORESignList(model.QryAgreementNo,model.QryProductLineID.Key,model.QrySubBu.Key,model.QrySignA.Key
                    ,model.QrySignB.Key,model.QryStatus.Key,model.QryAgreementType.Key,model.QryCreateDate.StartDate,model.QryCreateDate.EndDate, RoleModelContext.Current.User.CorpType));



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


        public OBORESignListVO NewID(OBORESignListVO model)
        {
            try
            {
                model.NewID = Guid.NewGuid().ToString();

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

        public OBORESignListVO BuChange(OBORESignListVO model)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();


                model.LstSubBu = JsonHelper.DataTableToArrayList(dao.QueryBuChange(model.QryProductLineID.Key));
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



    }
}
