using DMS.Common;
using DMS.Model;
using Lafite.RoleModel.Domain;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using DMS.ViewModel.Common;
using System.Data;
using DMS.Common.Extention;
using Lafite.RoleModel.Service;

namespace DMS.Business
{
    public class BaseService
    {
        private AttributeBiz bizAttribute = new AttributeBiz();
        protected LoginUser UserInfo = RoleModelContext.Current.User;
        private static ProductLineBLL bllProductLine = new ProductLineBLL();
        protected bool IsDealer
        {
            get
            {
                return this.UserInfo.IdentityType == "Dealer";
            }
        }

        protected string LoginId
        {
            get
            {
                return this.UserInfo.LoginId;
            }
        }

        public static KeyValue CurrentSubCompany
        {
            get
            {
                if (null != HttpContext.Current.Session && null != HttpContext.Current.Session["CurrentSubCompany"])
                {
                    return HttpContext.Current.Session["CurrentSubCompany"] as KeyValue;
                }
                else
                {
                    return null;
                }
            }
            set { HttpContext.Current.Session["CurrentSubCompany"] = value; }
        }

        public static KeyValue CurrentBrand
        {
            get
            {
                if (null != HttpContext.Current.Session && null != HttpContext.Current.Session["CurrentBrand"])
                {
                    return HttpContext.Current.Session["CurrentBrand"] as KeyValue;
                }
                else
                {
                    return null;
                }
            }
            set { HttpContext.Current.Session["CurrentBrand"] = value; }
        }

        public static Hashtable AddCommonFilterCondition(Hashtable table)
        {
            if (!table.ContainsKey("SubCompanyId"))
            {
                table.Add("SubCompanyId", CurrentSubCompany?.Key);
            }
            else
            {
                table["SubCompanyId"] = CurrentSubCompany?.Key;
            }

            if (!table.ContainsKey("BrandId"))
            {
                table.Add("BrandId", CurrentBrand?.Key);
            }
            else
            {
                table["BrandId"] = CurrentBrand?.Key;
            }
            return table;
        }

        public IList<KeyValuePair<string, string>> FilterProductLine(IList<KeyValuePair<string, string>> productlines)
        {
            var lstAuthProductLine = bllProductLine.SelectViewProductLine(CurrentSubCompany?.Key, CurrentBrand?.Key,
                null);
            return
                productlines.Where(
                    item => lstAuthProductLine.Any(p => p.Id.Equals(item.Key, StringComparison.OrdinalIgnoreCase))).ToList();
        }

        public static IList<KeyValue> FilterProductLine(IList<KeyValue> productlines)
        {
            var lstAuthProductLine = bllProductLine.SelectViewProductLine(CurrentSubCompany?.Key, CurrentBrand?.Key,
                null);
            return
                productlines.Where(
                    item => lstAuthProductLine.Any(p => p.Id.Equals(item.Key, StringComparison.OrdinalIgnoreCase))).ToList();
        }

        public static IList<OrganizationUnit> FilterProductLine(IList<OrganizationUnit> productlines)
        {
            var lstAuthProductLine = bllProductLine.SelectViewProductLine(CurrentSubCompany?.Key, CurrentBrand?.Key,
                null);
            return
                productlines.Where(
                    item => lstAuthProductLine.Any(p => p.Id.Equals(item.Id, StringComparison.OrdinalIgnoreCase)))
                    .ToList();
        }

        public static IList<AttributeDomain> FilterProductLine(IList<AttributeDomain> productlines)
        {
            var lstAuthProductLine = bllProductLine.SelectViewProductLine(CurrentSubCompany?.Key, CurrentBrand?.Key,
                null);
            return
                productlines.Where(
                    item => lstAuthProductLine.Any(p => p.Id.Equals(item.Id, StringComparison.OrdinalIgnoreCase)))
                    .ToList();
        }


        #region Protected Function

        /// <summary>
        /// 获取用户产品线列表
        /// </summary>
        /// <returns></returns>
        protected IList<KeyValuePair<string, string>> GetProductLineDataSource(bool isFilterBySubCompanyAndBrand = true)
        {
            IList<KeyValuePair<string, string>> datasource = new List<KeyValuePair<string, string>>();
            IRoleModelContext context = RoleModelContext.Current;

            //普通用户登陆，从组织结构缓存中获取ProductLine
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> v = this.GetCurrentProductLines(isFilterBySubCompanyAndBrand);
                foreach (OrganizationUnit ou in v)
                {
                    datasource.Add(new KeyValuePair<string, string>(ou.Id, ou.AttributeName));
                }
            }
            else
            {
                //经销商登陆 , 利用缓存中已有的信息，排除与登陆经销商不相关的
                if (context.User.CorpId.HasValue)
                {
                    IDealerContracts dealers = new DealerContracts();

                    DealerAuthorization param = new DealerAuthorization();

                    DealerAuthorization da = new DealerAuthorization();
                    da.DmaId = context.User.CorpId.Value;

                    IList<DealerAuthorization> auths = dealers.GetAuthorizationListByDealer(da);

                    IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

                    var lines = from p in dataSet
                                where auths.FirstOrDefault<DealerAuthorization>(c => c.ProductLineBumId.Value == new Guid(p.Id)) != null
                                select p;

                    foreach (AttributeDomain ad in lines.ToList<AttributeDomain>())
                    {
                        datasource.Add(new KeyValuePair<string, string>(ad.Id, ad.AttributeName));
                    }
                }

            }
            return isFilterBySubCompanyAndBrand ? FilterProductLine(datasource) : datasource;
        }

        public IList<OrganizationUnit> GetCurrentProductLines(bool isFilterBySubCompanyAndBrand = true)
        {
            IList<OrganizationUnit> list = new List<OrganizationUnit>();
            IList<AttributeDomain> units = bizAttribute.GetProductLineListByUser(this.UserInfo.LoginId);
            foreach (var unit in units)
            {
                OrganizationUnit OrgUnit = new OrganizationUnit();
                OrgUnit.Clone(unit);
                list.Add(OrgUnit);
            }
            return isFilterBySubCompanyAndBrand ? BaseService.FilterProductLine(list) : list;
        }

        private IList<OrganizationUnit> FindProductLine(OrganizationUnit unitForFind, IList<OrganizationUnit> list)
        {
            if (null != unitForFind)
            {
                if (unitForFind.Level < SR.Organization_ProductLine_Level)
                {
                    var us = OrganizationHelper.GetChildOrganizationUnit(SR.Organization_ProductLine, unitForFind.Id);
                    list = list.Union<OrganizationUnit>(us).ToList<OrganizationUnit>();
                }
                else if (unitForFind.Level == SR.Organization_ProductLine_Level || unitForFind.AttributeType == SR.Organization_ProductLine)
                {
                    OrganizationUnit u = unitForFind;
                    if (!list.Contains(u))
                        list.Add(u);
                }
                else
                {
                    OrganizationUnit u = OrganizationHelper.GetParentOrganizationUnit(SR.Organization_ProductLine, unitForFind.Id);
                    if (!list.Contains(u) && u != null)
                        list.Add(u);
                }
            }
            return list;
        }

        public IList<AttributeDomain> GetCurrentProductLines_Attribute(bool isFilterBySubCompanyAndBrand = true)
        {
            IList<OrganizationUnit> lstResults = GetCurrentProductLines(isFilterBySubCompanyAndBrand);
            return lstResults.Cast<AttributeDomain>().ToList();
        }

        #endregion

        #region Private Function

        protected DataSet GetAuthSubCompany()
        {
            IList<KeyValue> lstAllAuthProductLine = GetProductLine(false);
            DealerContracts bizDealerContract = new DealerContracts();
            return
                bizDealerContract.GetAuthSubCompany(lstAllAuthProductLine.Select(item => new Guid(item.Key)).ToArray());
        }

        protected DataSet GetAuthBrand(Guid idSubComapny)
        {
            IList<KeyValue> lstAllAuthProductLine = GetProductLine(false);
            DealerContracts bizDealerContract = new DealerContracts();
            return bizDealerContract.GetAuthBrand(idSubComapny, lstAllAuthProductLine.Select(item => new Guid(item.Key)).ToArray());
        }

        /// <summary>
        /// 获取授权范围内的产品线
        /// </summary>
        /// <param name="isFilterBySubCompanyAndBrand">是否根据子公司和品牌进行过滤</param>
        /// <returns></returns>
        protected IList<KeyValue> GetProductLine(bool isFilterBySubCompanyAndBrand = true)
        {
            IList<KeyValue> rtn = new List<KeyValue>();
            IList<AttributeDomain> result = null;

            //普通用户登陆，从组织结构缓存中获取ProductLine
            if (this.UserInfo.IdentityType == IdentityType.User.ToString())
            {
                result = this.GetCurrentProductLines_Attribute(isFilterBySubCompanyAndBrand);
            }
            else
            {
                //经销商登陆 , 利用缓存中已有的信息，排除与登陆经销商不相关的
                if (this.UserInfo.CorpId.HasValue)
                {
                    IDealerContracts dealers = new DealerContracts();

                    DealerAuthorization param = new DealerAuthorization();

                    DealerAuthorization da = new DealerAuthorization();
                    da.DmaId = this.UserInfo.CorpId.Value;

                    IList<DealerAuthorization> auths = dealers.GetAuthorizationListByDealer(da);

                    IList<AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

                    var lines = from p in dataSet
                                where auths.FirstOrDefault<DealerAuthorization>(c => c.ProductLineBumId.Value == p.Id.ToSafeGuid()) != null
                                select p;

                    result = lines.ToList<AttributeDomain>();
                }
            }
            foreach (AttributeDomain item in result)
            {
                rtn.Add(new KeyValue(item.Id, item.AttributeName));
            }

            return isFilterBySubCompanyAndBrand ? BaseService.FilterProductLine(rtn) : rtn;
        }

        #endregion
    }
}
