using DMS.Business;
using DMS.Business.Cache;
using DMS.Common;
using DMS.Common.Extention;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace DMS.BusinessService
{
    public abstract class ABaseQueryService : ABaseService
    {
        protected bool CheckApplyRole()
        {
            return true;
            //PageRoleAccessDao pageRoleAccessDao = new PageRoleAccessDao();
            //检查提交人的角色
            //return pageRoleAccessDao.HasPageRoleAccess(this.UserProperty.Role, this.BuesinessPagePath);
        }

        protected bool CheckApplyRole(String path)
        {
            return true;
            //PageRoleAccessDao pageRoleAccessDao = new PageRoleAccessDao();
            //检查提交人的角色
            //return pageRoleAccessDao.HasPageRoleAccess(this.UserProperty.Role, path);
        }

        //protected abstract String BuesinessPagePath { get; }

        /// <summary>
        /// 价差KeyValue
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        protected string CheckKeyValue(KeyValue resource)
        {
            if (!string.IsNullOrEmpty(resource.ToSafeString()))
                return "";
            else
                return resource.Key;
        }
        #region 省市地区绑定
        /// <summary>
        /// 省份
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual IList<Territory> Store_RefreshProvinces()
        {
            ITerritorys bll = new Territorys();
            IList<Territory> provinces = bll.GetProvinces();
            return provinces;
        }

        /// <summary>
        /// 地区
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual IList<Territory> Store_RefreshTerritorys(string parentId)
        {
            if (!string.IsNullOrEmpty(parentId))
            {
                ITerritorys bll = new Territorys();

                IList<Territory> cities = bll.GetTerritorysByParent(new Guid(parentId));
                return cities;
            }
            else
                return null;
        }

        #endregion

        public int iMaxCriteria = 10;
        public string[] oneRecord(string line)
        {
            //string[] aRec = new string[iMaxCriteria];
            //int iFieldCount = 0;

            //StringBuilder oneField = new StringBuilder();

            //for (int i = 0; i < line.Length; i++)
            //{
            //    if (nextField(line[i]))
            //    {
            //        aRec[iFieldCount] = (oneField.ToString());
            //        iFieldCount++;
            //        if (iFieldCount > iMaxCriteria)
            //        {
            //            line = line + string.Format("--最多只能处理{0}个模糊查找，后面的查找条件会省略。", iMaxCriteria);
            //            break;
            //        }
            //        oneField = new StringBuilder();
            //    }
            //    else
            //    {
            //        if (!omitchar(line[i])) oneField.Append(line[i]);
            //    }
            //}
            //if (oneField.Length != 0)
            //{
            //    aRec[iFieldCount] = (oneField.ToString());
            //}

            //return aRec;
            //if (line.LastIndexOf(',') == line.Length - 1)
            //{
            //    line = line.Substring(0, line.Length - 1);
            //}
            string[] aLine = line.Split(',');
            string[] aRec = new string[iMaxCriteria];
            int i = 0;
            int count = (aLine.Length > iMaxCriteria) ? iMaxCriteria : aLine.Length;
            while (i < count)
            {
                aRec[i] = aLine[i];
                i++;
            }
            return aRec;
        }


        public virtual IList<DealerMaster> DealerList()
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是普通用户则检查过滤该用户是否能够看到该Dealer
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = this.GetCurrentProductLines();
                Guid[] lines = (from p in list select new Guid(p.Id)).ToArray<Guid>();
                IDealerMasters dealerbiz = new DealerMasters();
                IList<Guid> dealers = dealerbiz.GetDealersBySales(context.User.Id, lines);
                var query = from p in dataSource
                            where dealers.Contains(p.Id.Value)
                            select p;
                dataSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();
                //dataSource = query.ToList<DealerMaster>();
            }

            return dataSource;
        }
        public virtual IList<DealerMaster> DealerListByFilter(bool showParent)
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是波科用户，则根据授权信息获得经销商列表
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = this.GetCurrentProductLines();
                Guid[] lines = (from p in list select new Guid(p.Id)).ToArray<Guid>();
                IDealerMasters dealerbiz = new DealerMasters();
                IList<Guid> dealers = dealerbiz.GetDealersBySales(context.User.Id, lines);
                var query = from p in dataSource
                            where dealers.Contains(p.Id.Value)
                            select p;
                dataSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();
                //dataSource = query.ToList<DealerMaster>();
            }
            else
            {
                //如果是经销商用户
                if (showParent)
                {
                    //显示自己及下级经销商
                    dataSource = (from t in dataSource where t.Id.Value == context.User.CorpId.Value || (t.ParentDmaId.HasValue && t.ParentDmaId.Value == context.User.CorpId.Value) select t).ToList<DealerMaster>();
                }
                else
                {
                    //显示下级经销商
                    dataSource = (from t in dataSource where (t.ParentDmaId.HasValue && t.ParentDmaId.Value == context.User.CorpId.Value) select t).ToList<DealerMaster>();
                }
            }

            return dataSource;
        }
        
        //经销商查询
        public virtual IList<Warehouse> WarehouseByDealerAndType(Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);


            if (dealerWarehouseType.Equals("Normal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() || t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("MoveNormal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString()  select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //配送商，使用Borrow类型
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() | t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科借货库
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //配送商，保持与平台相同逻辑
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Complain"))
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.Empty;
                wh.Name = "销售到医院";

                list.Add(wh);
            }
            //Added By Song Yuqi On 2015-11-27 Begin For 短期寄售
            //寄售类型订单的仓库可加载出【Consignment】、【Borrow】类型的仓库
            else if (dealerWarehouseType.Equals("Consignment,Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }

            else if (dealerWarehouseType.Equals("Noanddefault"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
            }
            //限定只能是医院库
            else if (dealerWarehouseType.Equals("HospitalOnly"))
            {
                list = (from t in list where t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
            }


            //Added By Song Yuqi On 2015-11-27 End

            return list;
        }


        public virtual IList<Warehouse> TransferWarehouseByDealerAndType(Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);


            if (dealerWarehouseType.Equals("Normal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() || t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() | t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科借货库
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Complain"))
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.Empty;
                wh.Name = "销售到医院";

                list.Add(wh);
            }
            //Added By Song Yuqi On 2015-11-27 Begin For 短期寄售
            //寄售类型订单的仓库可加载出【Consignment】、【Borrow】类型的仓库
            else if (dealerWarehouseType.Equals("Consignment,Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            //Added By Song Yuqi On 2015-11-27 End

            return list;
        }

        public virtual IList<Warehouse> NormalWarehousType(Guid dealerId, Guid productlineId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);


            if (dealerWarehouseType.Equals("Normal"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {

                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Normal.ToString() || t.Type == WarehouseType.DefaultWH.ToString() select t).ToList<Warehouse>();
                        break;
                    default:
                        list = (from t in list where t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
                        break;
                }



            }
            else if (dealerWarehouseType.Equals("MoveNormal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() | t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科借货库
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Complain"))
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.Empty;
                wh.Name = "销售到医院";

                list.Add(wh);
            }
            //Added By Song Yuqi On 2015-11-27 Begin For 短期寄售
            //寄售类型订单的仓库可加载出【Consignment】、【Borrow】类型的仓库
            else if (dealerWarehouseType.Equals("Consignment,Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }

            else if (dealerWarehouseType.Equals("Frozen"))
            {

                list = (from t in list where t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            //Added By Song Yuqi On 2015-11-27 End

            return list;
        }

        public virtual IList<Warehouse> GetWarehouseByDealerAndTypeWithoutDWH(Guid dealerId, Guid productlineId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);

            Hashtable ht = new Hashtable();
            ht.Add("ProductLineId", productlineId);
            ht.Add("DealerId", dealerId);
            DataTable dt = business.GetNoLimitWarehouse(ht).Tables[0];

            if (dealerWarehouseType.Equals("Normal"))
            {
                if (dt.Rows.Count > 0 && dt != null)
                {
                    if (dt.Rows[0]["cnt"].ToString() == "0")
                    {
                        //没有经销商或BU的限制，则允许显示主仓库
                        list = (from t in list where t.Type == WarehouseType.Normal.ToString() | t.Type == WarehouseType.DefaultWH.ToString()  select t).ToList<Warehouse>();
                    }
                    else
                    {
                        list = (from t in list where t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
                    }
                }

            }
            else if (dealerWarehouseType.Equals("Consignment"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() | t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科借货库
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Complain"))
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.Empty;
                wh.Name = "销售到医院";

                list.Add(wh);
            }
            //Added By Song Yuqi On 2015-11-27 Begin For 短期寄售
            //寄售类型订单的仓库可加载出【Consignment】、【Borrow】类型的仓库
            else if (dealerWarehouseType.Equals("Consignment,Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }

            else if (dealerWarehouseType.Equals("Frozen"))
            {

                list = (from t in list where t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            //Added By Song Yuqi On 2015-11-27 End

            return list;
        }


        #region 经销商仓库绑定
        /// <summary>
        /// 根据当前登录经销商的身份、传入经销商ID和仓库类型得到仓库列表
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected IList<Warehouse> WarehouseByDealer(string dealerId, string dealerWarehouseType)
        {
            Guid DealerId = Guid.Empty;

            if (dealerId != null && !string.IsNullOrEmpty(dealerId))
            {
                DealerId = new Guid(dealerId);
            }

            //added by bozhenfei on 20130703 根据当前登陆用户的类型再过滤可显示的仓库
            //接收参数DealerWarehouseType表示单据对应的仓库类型 Normal Consignment Borrow
            string DealerWarehouseType = "Normal";

            if (dealerWarehouseType != null && !string.IsNullOrEmpty(dealerWarehouseType))
            {
                DealerWarehouseType = dealerWarehouseType;
            }

            return Bind_WarehouseByDealer(DealerId, DealerWarehouseType);
        }

        public virtual IList<Warehouse> Bind_WarehouseByDealer(Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            if (context.User.IdentityType == IdentityType.Dealer.ToString())
            {

                if (dealerWarehouseType.Equals("Normal"))
                {
                    list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
                }
                else if (dealerWarehouseType.Equals("Consignment"))
                {
                    switch ((DealerType)Enum.Parse(typeof(DealerType), context.User.CorpType, true))
                    {
                        case DealerType.HQ:
                            //总部，波科公司，显示波科寄售库
                            list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.LP:
                            //平台，显示平台寄售库
                            list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.LS:
                            //配送商，保持与平台相同逻辑
                            list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.T2:
                            //T2，显示寄售库
                            list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        default: break;
                    }
                }
                else if (dealerWarehouseType.Equals("Borrow"))
                {
                    switch ((DealerType)Enum.Parse(typeof(DealerType), context.User.CorpType, true))
                    {
                        case DealerType.HQ:
                            //总部，波科公司，显示波科借货库
                            list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.LP:
                            //平台，显示平台借货库
                            list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.LS:
                            //配送商，保持与平台相同逻辑
                            list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.T1:
                            //平台，显示平台借货库
                            list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        default: break;
                    }
                }
            }

            return list;
        }

        public virtual IList<SapWarehouseAddress> Bind_SAPWarehouseAddress(Guid dealerId)
        {
            IRoleModelContext context = RoleModelContext.Current;

            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<SapWarehouseAddress> list = business.QueryForWarehouse(dealerId);

            if (list == null)
                list = new List<SapWarehouseAddress>();
            return list;
        }

        #endregion

    }
}
