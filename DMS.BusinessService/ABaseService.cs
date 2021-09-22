using DMS.Business;
using DMS.Common;
using DMS.Model;
using Lafite.RoleModel.Domain;
using Lafite.RoleModel.Security;
using System.Collections.Generic;
using System.Web;
using System.Linq;
using DMS.Common.Extention;
using DMS.ViewModel.Common;
using System;
using System.Data;
using System.Diagnostics.Eventing.Reader;
using DMS.Business.Cache;
using Lafite.RoleModel.Service;
using BaseService = DMS.Business.BaseService;

namespace DMS.BusinessService
{
    public abstract class ABaseService
    {
        private BaseService serviceBase = new BaseService();
        protected HttpServerUtility Server
        {
            get
            {
                return HttpContext.Current.Server;
            }
        }

        protected HttpRequest Request
        {
            get
            {
                return HttpContext.Current.Request;
            }
        }

        protected HttpResponse Response
        {
            get
            {
                return HttpContext.Current.Response;
            }
        }

        protected LoginUser UserInfo = RoleModelContext.Current.User;
        protected bool IsDealer
        {
            get
            {
                return this.UserInfo.IdentityType == "Dealer";
            }
        }

        protected bool IsInRole(string role)
        {
            return RoleModelContext.Current.IsInRole(role);
        }

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
                rtn.Add(new KeyValue(item.Id.ToLower(), item.AttributeName));
            }

            return isFilterBySubCompanyAndBrand ? BaseService.FilterProductLine(rtn) : rtn;
        }

        public IList<OrganizationUnit> GetCurrentProductLines(bool isFilterBySubCompanyAndBrand = true)
        {
            return serviceBase.GetCurrentProductLines(isFilterBySubCompanyAndBrand);
        }

        public IList<AttributeDomain> GetCurrentProductLines_Attribute(bool isFilterBySubCompanyAndBrand = true)
        {
            return serviceBase.GetCurrentProductLines_Attribute(isFilterBySubCompanyAndBrand);
        }

        public IList<DealerMaster> GetDealerSource()
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dealerSource = DealerCacheHelper.GetDealers();
            //如果是波科用户，则根据授权信息获得经销商列表
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = GetCurrentProductLines();
                Guid[] lines = (from p in list select new Guid(p.Id)).ToArray<Guid>();
                IDealerMasters dealerbiz = new DealerMasters();
                IList<Guid> dealers = dealerbiz.GetDealersBySales(context.User.Id, lines);
                var query = from p in dealerSource
                            where dealers.Contains(p.Id.Value)
                            select p;
                dealerSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();
                //dataSource = query.ToList<DealerMaster>();
            }
            else
            {
                //显示自己及下级经销商
                dealerSource = (from t in dealerSource where t.Id.Value == context.User.CorpId.Value || (t.ParentDmaId.HasValue && t.ParentDmaId.Value == context.User.CorpId.Value) select t).ToList<DealerMaster>();
            }
            return dealerSource;
        }
        
    }
}
