using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;

namespace DMS.Business
{
    public class TerritoryBLL : ITerritoryBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet GetBUList()
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                return dao.GetBUList();
            }
        }

        /// <summary>
        /// 得到层级
        /// </summary>
        /// <param name="ParentId"></param>
        /// <param name="flag">0:返回当前层级,1:返回下一层级</param>
        /// <returns></returns>
        public string GetLevel(string ParentId,int flag)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                if (flag == 0)
                {
                    return dao.GetCurrentLevel(ParentId);
                }
                else
                {
                    return dao.GetLevel(ParentId);
                }
            }
        }

        /// <summary>
        /// 得到产品线列表
        /// </summary>
        /// <param name="BuId"></param>
        /// <returns></returns>
        public DataSet GetProductLineList(string BuId)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                return dao.GetProductLineList(BuId);
            }
        }


        public void InsertTerritoryHierarchy(TerritoryHierarchy th)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                dao.Insert(th);
            }
        }

        public DataSet GetTerritoryHierarchyByThid(string thid)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
              return  dao.SelectByFilter(thid);
            }
        }

        public void UpdateTerritoryHierarchy(TerritoryHierarchy th)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                dao.Update(th);
            }
        }

        public void DeleteTerritoryHierarchy(Guid th)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                dao.Delete(th);
            }
        }

        /// <summary>
        /// 得到子节点
        /// </summary>
        /// <param name="ThId"></param>
        /// <returns></returns>
        public DataSet GetChildNode(string ThId)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
               return dao.GetChildNode(ThId);
            }
        }


        public DataSet GetProductLineByParentId(string ParentId)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                return dao.SelectProductLineByParentId(ParentId);               
            }
        }

        public DataSet GetProductLineById(string Buid)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                return dao.GetProductLineById(Buid);
            }
        }

        public DataSet GetTerritoryByProvinceId(string ProvinceId, int start, int limit, out int totalRowCount)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                return dao.GetTerritoryByProvinceId(ProvinceId, start, limit,out totalRowCount);
            }
        }

        /// <summary>
        /// 删除Province层时判断下面是否有Territory
        /// </summary>
        /// <param name="ProvinceId"></param>
        /// <returns></returns>
        public bool GetTerritoryByProvinceId(string ProvinceId)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                int totalRowCount = 0;
                bool result = false ;
                DataSet ds= dao.GetTerritoryByProvinceId(ProvinceId, 0, 15, out totalRowCount);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    result = true;
                }
                return result;
            }
        }

        public DataSet GetTerritoryByFilter(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                return dao.GetTerritoryByFilter(ht, start, limit, out totalRowCount);
            }
        }

        public DataSet GetDealerTerritoryByTemId(string TemId, int start, int limit, out int totalRowCount)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                return dao.GetDealerTerritoryByTemId(TemId, start, limit, out totalRowCount); 
            }
        }

        public bool AddTerritory(string ProvinceId, string[] TemId)
        { 
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                TerritoryHierarchyDao dao = new TerritoryHierarchyDao();
                foreach (string tid in TemId)
                {
                    if (tid != "")
                    {
                        Hashtable ht = new Hashtable();
                        ht.Add("TemId", tid);
                        ht.Add("ProvinceId", ProvinceId);
                        dao.AddTerritory(ht);
                    }
                }
                result = true;
                trans.Complete();
            }
            return result;
        }

        public bool deleteTerritory(string[] TemId)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                TerritoryHierarchyDao dao = new TerritoryHierarchyDao();
                foreach (string tid in TemId)
                {
                    if (tid != "")
                    {
                        dao.deleteDealerTerritoryByTemId(tid);
                        dao.deleteTerritory(tid);
                    }          
                }
                result = true;
                trans.Complete();
            }
            return result;
        }

        public bool InsertDealerTerritory(string TemId,string[] DmaId)
        { 
             bool result = false;
             using (TransactionScope trans = new TransactionScope())
             {
                 TerritoryHierarchyDao dao = new TerritoryHierarchyDao();
                 foreach (string did in DmaId)
                 {
                     Hashtable ht = new Hashtable();
                     ht.Add("TemId", TemId);
                     ht.Add("DmaId", did);
                     ht.Add("DTID", Guid.NewGuid().ToString());
                     dao.InsertDealerTerritory(ht);                    
                 }
                 result = true;
                 trans.Complete();
             }
             return result;
        }

        public void deleteDealerTerritory(string DTid)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                dao.deleteDealerTerritory(DTid);
            }
        }


       public DataSet GetDealerByTerritory(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                return dao.GetDealerByTerritory(obj, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 判断编号是否重复
        /// </summary>
        /// <param name="code">编号</param>
     
        /// <returns></returns>
       public bool validateCodeIdentical(string code)
       { 
            using (TerritoryHierarchyDao dao = new TerritoryHierarchyDao())
            {
                bool result = true;
                DataSet ds = dao.validateCodeIdentical(code);
                int count = int.Parse(ds.Tables[0].Rows[0]["num"].ToString());
                
                    if (count > 0)
                    {
                        result = false;
                    }
                
                return result;
            }
       }
    }
}
