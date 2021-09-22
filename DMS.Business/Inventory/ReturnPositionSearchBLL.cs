using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;

using DMS.DataAccess;
using Lafite.RoleModel.Security;

namespace DMS.Business
{
    public class ReturnPositionSearchBLL : IReturnPositionSearchBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet baocuo(Guid id)
        {
            using (ReturnPositionSearchDao dao = new ReturnPositionSearchDao())
            {
                return dao.Gettype(id);
            }

        }

        public DataSet ExcleGetPosition(Hashtable obj)
        {
            using (ReturnPositionSearchDao dao = new ReturnPositionSearchDao())
            {
                return dao.ExcelGetPosition(obj);
            }
        }

      
        public DataSet GetObjectid(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ReturnPositionSearchDao dao = new ReturnPositionSearchDao())
            {
                return dao.GetObjectid(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetPosition(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ReturnPositionSearchDao dao = new ReturnPositionSearchDao())
            {
              return dao.GetPosition(obj, start, limit, out totalRowCount);              
            }
        }

        public bool insert(Hashtable obj)
        {
            bool relult = false;
            try
            {
                using (ReturnPositionSearchDao dao = new ReturnPositionSearchDao())
                {
                    obj.Add("CreateUser", new Guid(_context.User.Id));
                    obj.Add("ID", Guid.NewGuid());
                    obj.Add("Type","调整数据");             
                    obj.Add("Isinit", "0");
                    obj.Add("IsActived", "1");
                    obj.Add("CreateUserName",this._context.UserName);
                    obj.Add("CreateDate", DateTime.Now.ToString("yyyy - MM - dd HH: mm:ss.fff"));
                    dao.Insert(obj);
                    relult = true;
                }

            }
            catch (Exception ex)
            {
                relult = false;
            }
            return relult;
        }

       
    }
}
