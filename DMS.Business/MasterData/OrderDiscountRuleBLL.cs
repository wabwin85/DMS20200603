using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;
    using DMS.DataAccess;
    using DMS.Model;
    using DMS.Common;
    using DMS.Model.Data;
    using Lafite.RoleModel.Security.Authorization;
    using Grapecity.Logging.CallHandlers;

    using System.Data;
    using System.Collections;
    public class OrderDiscountRuleBLL: IOrderDiscountRule
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet QueryOrderDiscountRule(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ConsignmentDiscountRuleDao dao = new ConsignmentDiscountRuleDao())
            {
                return dao.QueryOrderDiscountRule(obj, start, limit, out totalCount);
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
                    ConsignmentDiscountRuleDao dao = new ConsignmentDiscountRuleDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<ConsignmentDiscountRuleInit> list = new List<ConsignmentDiscountRuleInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        ConsignmentDiscountRuleInit data = new ConsignmentDiscountRuleInit();
                        data.Id = Guid.NewGuid();
                        data.CreateUser = new Guid(_context.User.Id);
                        data.CreateDate = DateTime.Now;

                        //产品线
                        data.Bu = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.Bu))
                            data.ErrMassage = "所属产品线为空";

                        //经销商SAPCode
                        data.Dealersap = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.Dealersap))
                            data.ErrMassage = "经销商账号为空";

                        //Upn
                        data.Upn = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (string.IsNullOrEmpty(data.Upn))
                            data.ErrMassage = "产品型号为空";

                        //批号
                        data.Lot = dr[5] == DBNull.Value ? null : dr[5].ToString();

                        //二维码
                        data.QrCode = dr[7] == DBNull.Value ? null : dr[7].ToString();

                        //大于等于
                        data.LeftValue = dr[8] == DBNull.Value ? null : dr[8].ToString();
                        if (!string.IsNullOrEmpty(data.LeftValue))
                        {
                            int date;
                            if (int.TryParse(data.LeftValue, out date))
                                data.LeftValue = date.ToString();
                            else
                                data.ErrMassage = "左参数格式填写不正确";
                        }

                        //小于
                        data.RightValue = dr[9] == DBNull.Value ? null : dr[9].ToString();
                        if (!string.IsNullOrEmpty(data.RightValue))
                        {
                            int date;
                            if (int.TryParse(data.RightValue, out date))
                                data.RightValue = date.ToString();
                            else
                                data.ErrMassage = "右参数格式填写不正确";
                        }

                        //折扣率
                        data.DiscountValue = dr[10] == DBNull.Value ? null : dr[10].ToString();
                        if (!string.IsNullOrEmpty(data.DiscountValue))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.DiscountValue, out qty))
                                data.ErrMassage = "折扣格式不正确";
                            else if (Decimal.Parse(data.DiscountValue) < 0)
                                data.ErrMassage = "折扣不能小于0";
                        }

                        //开始时间
                        data.BeginDate = dr[11] == DBNull.Value ? null : dr[11].ToString();
                        if (!string.IsNullOrEmpty(data.BeginDate))
                        {
                            DateTime date;
                            if (DateTime.TryParse(data.BeginDate, out date))
                                data.BeginDate = date.ToString("yyyy-MM-dd");
                            else
                                data.ErrMassage = "生效日期格式不正确";
                        }

                        //终止时间
                        data.EndDate = dr[12] == DBNull.Value ? null : dr[12].ToString();
                        if (!string.IsNullOrEmpty(data.EndDate))
                        {
                            DateTime date;
                            if (DateTime.TryParse(data.EndDate, out date))
                                data.EndDate = date.ToString("yyyy-MM-dd");
                            else
                                data.ErrMassage = "终止日期格式不正确";
                        }

                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch(Exception ex)
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyOrderDiscountRuleInit(string importType, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (ConsignmentDiscountRuleDao dao = new ConsignmentDiscountRuleDao())
            {
                IsValid = dao.Initialize(importType, new Guid(_context.User.Id),BaseService.CurrentSubCompany?.Key,BaseService.CurrentBrand?.Key);
                result = true;
            }
            return result;
        }
        public DataSet QueryErrorData(int start, int limit, out int totalCount)
        {
            using (ConsignmentDiscountRuleDao dao = new ConsignmentDiscountRuleDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("UserId", _context.User.Id.ToString());
                return dao.QueryErrorData(obj, start, limit, out totalCount);
            }
        }
        public int DeleteDiscountRuleByUser()
        {
            using (ConsignmentDiscountRuleDao dao = new ConsignmentDiscountRuleDao())
            {
                return dao.DeleteByUser(new Guid(_context.User.Id));
            }
        }
    }
}
