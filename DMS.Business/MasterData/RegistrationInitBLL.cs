using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;

namespace DMS.Business
{
    public class RegistrationInitBLL : IRegistrationInitBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;


        #region Action Define
        public const string Action_RegistrationInit = "RegistrationInit";
        #endregion

        
        /// <summary>
        /// 将Excel文件中的数据导入到RegistrationInit表，并做相应的初始化
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_RegistrationInit, Description = "注册证导入", Permissoin = PermissionType.Write)]
        //[LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_RegistrationInit, Title = "注册证导入", Message = "注册证导入", Categories = new string[] { Data.DMSLogging.RegistrationInitCategory })]
        public bool Import(DataSet ds)
        {
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    RegistrationInitDao dao = new RegistrationInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));
                    //读取DataSet数据至数据库
                    int lineNbr = 1;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        string errString = string.Empty;
                        RegistrationInit data = new RegistrationInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);

                        //RegistrationNbrcn
                        if (dr[22] == DBNull.Value)
                        {
                            errString += "注册证中文名为空,";
                        }
                        else
                        {
                            data.RegistrationNbrcn = dr[22].ToString();
                        }
                        //RegistrationNbren
                        if (dr[23] == DBNull.Value)
                        {
                            errString += "注册证中英文为空,";
                        }
                        else
                        {
                            data.RegistrationNbren = dr[23].ToString();
                        }
                        //RegistrationProductName
                        if (dr[24] == DBNull.Value)
                        {
                            errString += "注册证产品名称为空,";
                        }
                        else
                        {
                            data.RegistrationProductName = dr[24].ToString();
                        }
                        //OpeningDate
                        if (dr[25] == DBNull.Value)
                        {
                            errString += "注册证开证日期为空,";
                        }
                        else
                        {
                            try
                            {
                                data.OpeningDate = DateTime.Parse(dr[25].ToString());
                            }
                            catch
                            {
                                errString += "注册证开证日期不是日期格式,";
                            }

                        }
                        //ExpirationDate
                        if (dr[26] == DBNull.Value)
                        {
                            errString += "注册证有效期为空,";
                        }
                        else
                        {
                            try
                            {
                                data.ExpirationDate = DateTime.Parse(dr[26].ToString());
                            }
                            catch
                            {
                                errString += "注册证有效期不是日期格式,";
                            }
                        }
                        //ArticleNumber
                        if (dr[0] == DBNull.Value)
                        {
                            errString += "ArticleNumber为空,";
                        }
                        else
                        {
                            data.ArticleNumber = dr[0].ToString();
                        }
                        //ChineseName
                        if (dr[1] == DBNull.Value)
                        {
                            errString += "产品中文名为空,";
                        }
                        else
                        {
                            data.ChineseName = dr[1].ToString();
                        }
                        //EnglishName
                        if (dr[2] == DBNull.Value)
                        {
                            //errString += "产品英文名为空,";
                            data.EnglishName = null;
                        }
                        else
                        {
                            data.EnglishName = dr[2].ToString();
                        }
                        //Specification
                        if (dr[3] == DBNull.Value)
                        {
                            data.Specification = null;
                        }
                        else
                        {
                            data.Specification = dr[3].ToString();
                        }
                        //ManufacturerId
                        if (dr[4] == DBNull.Value)
                        {
                            data.ManufacturerId = null;
                        }
                        else
                        {
                            data.ManufacturerId = dr[4].ToString();
                        }
                        //ManufacturerName
                        if (dr[5] == DBNull.Value)
                        {
                            data.ManufacturerName = null;
                        }
                        else
                        {
                            data.ManufacturerName = dr[5].ToString();
                        }
                        //ManufacturerAddress
                        if (dr[6] == DBNull.Value)
                        {
                            data.ManufacturerAddress = null;
                        }
                        else
                        {
                            data.ManufacturerAddress = dr[6].ToString();
                        }
                        //ManufacturerAddress
                        if (dr[7] == DBNull.Value)
                        {
                            data.ManufactoryAddress = null;
                        }
                        else
                        {
                            data.ManufactoryAddress = dr[7].ToString();
                        }
                        //Scope
                        if (dr[8] == DBNull.Value)
                        {
                            data.Scope = null;
                        }
                        else
                        {
                            data.Scope = dr[8].ToString();
                        }
                        //RegisteredAgent
                        if (dr[9] == DBNull.Value)
                        {
                            data.RegisteredAgent = null;
                        }
                        else
                        {
                            data.RegisteredAgent = dr[9].ToString();
                        }
                        //Service
                        if (dr[10] == DBNull.Value)
                        {
                            data.Service = null;
                        }
                        else
                        {
                            data.Service = dr[10].ToString();
                        }
                        //Import
                        if (dr[11] == DBNull.Value)
                        {
                            data.Import = null;
                        }
                        else
                        {
                            data.Import = dr[11].ToString();
                        }
                        //Implant
                        if (dr[12] == DBNull.Value)
                        {
                            data.Implant = null;
                        }
                        else
                        {
                            data.Implant = dr[12].ToString();
                        }
                        //Lot
                        if (dr[13] == DBNull.Value)
                        {
                            data.Lot = null;
                        }
                        else
                        {
                            data.Lot = dr[13].ToString();
                        }
                        //Sn
                        if (dr[14] == DBNull.Value)
                        {
                            data.Sn = null;
                        }
                        else
                        {
                            data.Sn = dr[14].ToString();
                        }
                        //Pacemaker
                        if (dr[15] == DBNull.Value)
                        {
                            data.Pacemaker = null;
                        }
                        else
                        {
                            data.Pacemaker = dr[15].ToString();
                        }
                        //GuaranteePeriod
                        if (dr[16] == DBNull.Value)
                        {
                            data.GuaranteePeriod = null;
                        }
                        else
                        {
                            data.GuaranteePeriod = dr[16].ToString();
                        }
                        //MinUnit
                        if (dr[17] == DBNull.Value)
                        {
                            data.MinUnit = null;
                        }
                        else
                        {
                            data.MinUnit = dr[17].ToString();
                        }
                        //Barcode1
                        if (dr[18] == DBNull.Value)
                        {
                            data.Barcode1 = null;
                        }
                        else
                        {
                            data.Barcode1 = dr[18].ToString();
                        }
                        //Barcode2
                        if (dr[19] == DBNull.Value)
                        {
                            data.Barcode2 = null;
                        }
                        else
                        {
                            data.Barcode2 = dr[19].ToString();
                        }
                        //Barcode3
                        if (dr[20] == DBNull.Value)
                        {
                            data.Barcode3 = null;
                        }
                        else
                        {
                            data.Barcode3 = dr[20].ToString();
                        }
                        //Barcode4
                        if (dr[21] == DBNull.Value)
                        {
                            data.Barcode4 = null;
                        }
                        else
                        {
                            data.Barcode4 = dr[21].ToString();
                        }

                        data.LineNbr = lineNbr++;
                        data.Error = !string.IsNullOrEmpty(errString);
                        data.ErrorDesc = errString;

                        dao.Insert(data);
                    }
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {
            }
            return result;
        }

        public bool Verify(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (RegistrationInitDao dao = new RegistrationInitDao())
            {
                IsValid = dao.Initialize(new Guid(_context.User.Id));
                result = true;
            }
            return result;
        }

        public DataSet QueryErrorData(int start, int limit, out int totalRowCount)
        {
            using (RegistrationInitDao dao = new RegistrationInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("User", _context.User.Id);
                param.Add("Error", true);
                return dao.SelectByFilter(param, start, limit, out totalRowCount);
            }
        }
    }
}
