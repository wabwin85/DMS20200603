using DMS.ViewModel.Common;
using System;
using DMS.Common.Extention;
using DMS.DataAccess.Platform;
using DMS.Model.Platform;
using System.Collections;
using System.Collections.Generic;

namespace DMS.BusinessService
{
    public abstract class ABaseBusinessService : ABaseService
    {
        protected ApplyBasic CreateDefaultApplyBasic()
        {
            return new ApplyBasic(DateTime.Now.To_yyyy_MM_dd_HH_mm_ss(), base.UserInfo.FullName, "系统自动生成", "草稿");
        }

        protected virtual bool CheckApplyRole()
        {
            return true;
            //    PageRoleAccessDao pageRoleAccessDao = new PageRoleAccessDao();
            //    //检查提交人的角色
            //    return pageRoleAccessDao.HasPageRoleAccess(this.UserProperty.Role, this.BuesinessPagePath);
        }

        protected IList<Hashtable> GetLog(String DataSource, Guid InstanceId)
        {
            OperLogMasterDao operLogMasterDao = new OperLogMasterDao();

            return operLogMasterDao.SelectListByForeignTable(DataSource, InstanceId);
        }

        protected void InsertLog(String DataSource, Guid InstanceId, String DataContent, String OperType, String OperRole)
        {
            OperLogMasterDao operLogMasterDao = new OperLogMasterDao();

            OperLogMasterPO operLogMaster = new OperLogMasterPO();
            operLogMaster.LogId = Guid.NewGuid();
            operLogMaster.MainId = InstanceId;
            operLogMaster.OperUser = base.UserInfo.FullName;
            operLogMaster.OperDate = DateTime.Now;
            operLogMaster.OperType = OperType;
            operLogMaster.OperRole = OperRole;
            operLogMaster.DataSource = DataSource;
            operLogMaster.UserAccount = base.UserInfo.LoginId;
            operLogMaster.DataContent = DataContent;

            operLogMasterDao.Insert(operLogMaster);
        }

        //protected abstract String BuesinessPagePath { get; }
    }
}