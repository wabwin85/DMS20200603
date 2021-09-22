using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Lafite.RoleModel.Security;
using System.Data;
using System.Collections;
using DMS.DataAccess;
using Grapecity.DataAccess.Transaction;
using DMS.Model;

namespace DMS.Business
{
    public class CfnPriceService : ICfnPriceService
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet QueryDealerPrice(Hashtable table, int start, int limit, out int totalRowCount) 
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(table);
            using (CfnPriceDao dao = new CfnPriceDao())
            {
                return dao.QueryDealerPrice(table, start, limit, out totalRowCount);
            }
        }
        public DataSet QueryDealerPrice2(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(table);
            using (CfnPriceDao dao = new CfnPriceDao())
            {
                return dao.QueryDealerPrice2(table, start, limit, out totalRowCount);
            }
        }
        public DataSet ExportDealerPrice(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(table);
            using (CfnPriceDao dao = new CfnPriceDao())
            {
                return dao.ExportDealerPrice(table);
            }
        }
        public DataSet ExportDealerPriceQuery(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(table);
            using (CfnPriceDao dao = new CfnPriceDao())
            {
                return dao.ExportDealerPriceQuery(table);
            }
        }
        public DataSet QueryErrorData(int start, int limit, out int totalCount)
        {
            using (CfnPriceImportInitDao dao = new CfnPriceImportInitDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("UserId", _context.User.Id.ToString());
                return dao.QueryErrorData(obj, start, limit, out totalCount);
            }
        }
        public bool Import(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    CfnPriceImportInitDao dao = new CfnPriceImportInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(_context.User.Id);

                    int lineNbr = 1;
                    IList<CfnPriceImportInit> list = new List<CfnPriceImportInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        CfnPriceImportInit data = new CfnPriceImportInit();
                        data.Id = Guid.NewGuid();
                        data.CreateUser = new Guid(_context.User.Id);
                        data.CreateDate = DateTime.Now;
                       
                        //UPN
                        data.CustomerFaceNbr = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.CustomerFaceNbr))
                            data.ErrMassage += "产品代码为空";

                        //价格
                        data.Price = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (!string.IsNullOrEmpty(data.Price))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.Price, out qty))
                                data.ErrMassage += "价格格式不正确";
                            else if (Decimal.Parse(data.Price) < 0)
                                data.ErrMassage += "价格不能小于0";
                        }
                        data.LevelValue = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.LevelValue))
                            data.ErrMassage += "价格类型为空";
                        //SAP_Code
                        data.SapCode = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        //if (string.IsNullOrEmpty(data.SapCode))
                        //{
                        //    data.ErrMassage += "ERPCode必须填写";
                        //}


                        //省份
                        data.Province = dr[4] == DBNull.Value ? null : dr[4].ToString();

                        //城市
                        data.City = dr[5] == DBNull.Value ? null : dr[5].ToString();

                       
                        

                        //开始时间
                        data.ValidDateFrom = dr[6] == DBNull.Value ? null : dr[6].ToString();
                        if (!string.IsNullOrEmpty(data.ValidDateFrom))
                        {
                            DateTime date;
                            if (DateTime.TryParse(data.ValidDateFrom, out date))
                                data.ValidDateFrom = date.ToString("yyyy-MM-dd");
                            else
                                data.ErrMassage += "开始时间格式不正确";
                        }

                        //终止时间
                        data.ValidDateTo = dr[7] == DBNull.Value ? null : dr[7].ToString();
                        if (!string.IsNullOrEmpty(data.ValidDateTo))
                        {
                            DateTime date;
                            if (DateTime.TryParse(data.ValidDateTo, out date))
                                data.ValidDateTo = date.ToString("yyyy-MM-dd");
                            else
                                data.ErrMassage += "终止时间格式不正确";
                        }
                        data.DealerType = dr[8] == DBNull.Value ? null : dr[8].ToString();
                        if (string.IsNullOrEmpty(data.SapCode))
                        {
                            if ("T1,T2,LP,".IndexOf(data.DealerType + ",") < 0)
                            {
                                data.ErrMassage += "价格所属不正确，必须为T1,T2,LP其中一种";
                            }
                        }
                        if (lineNbr != 1)
                        {
                            if (string.IsNullOrEmpty(data.ErrMassage))
                            {
                                data.ErrMassage = "";
                            }
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDealerPriceInit(string importType, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (CfnPriceImportInitDao dao = new CfnPriceImportInitDao())
            {
                IsValid = dao.Initialize(importType, new Guid(_context.User.Id), BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key);
                result = true;
            }
            return result;
        }
        public int DeleteDealerPriceByUser()
        {
            using (CfnPriceImportInitDao dao = new CfnPriceImportInitDao())
            {
                return dao.DeleteByUser(_context.User.Id);
            }
        }
        public int DeleteCFNPrice(CfnPrice cfnp)
        {
            using (CfnPriceImportInitDao dao = new CfnPriceImportInitDao())
            {
                cfnp.LastUpdateUser = new Guid(_context.User.Id);
                cfnp.LastUpdateDate = DateTime.Now;
                return dao.Delete(cfnp);
            }
        }
    }
}
