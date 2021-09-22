using Bsc.HcpPassport;
using Bsc.HcpPassport.Entities.Request;
using Bsc.HcpPassport.Entities.Response;
using DMS.Common.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using FrameLib.Common.Extention;
using System.Web.Security;
using DMS.BusinessService;

namespace DMS.Website
{
    public partial class Logon : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                LogonService logonService = new LogonService();

                AppTokenRequest request = new AppTokenRequest();
                request.ClientId = PassportConfig.PassportClienId;
                request.ClientSecret = PassportConfig.PassportClientSecret;
                AppTokenReponse appTokenReponse = CommonApi.AppToken(request);

                UserInfoRequest userInfoRequest = new UserInfoRequest();
                userInfoRequest.AppToken = appTokenReponse.AppToken;
                userInfoRequest.UserAccessToken = Request.QueryString["access_token"].ToSafeString();

                UserInfoResponse userInfoResponse = CommonApi.UserInfo(userInfoRequest);

                logonService.Logon(userInfoResponse.Mobile);

                this.Response.Redirect(FormsAuthentication.DefaultUrl);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                throw ex;
            }
        }
    }
}