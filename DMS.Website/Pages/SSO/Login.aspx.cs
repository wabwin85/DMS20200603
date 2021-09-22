using DMS.Model.SSO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Xml;
using Com.Zealan.Saml.Protocols;
using Com.Zealan.Saml;
using Com.Zealan.Saml.Assertions;
using System.Security.Cryptography.X509Certificates;
using Com.Zealan.Saml.Bindings;
using Com.Zealan.Saml.Profiles;
using Common.Logging;

namespace DMS.Website.Pages.SSO
{
    public partial class Login : System.Web.UI.Page
    {
        private static ILog _log = LogManager.GetLogger(typeof(Login));

        private const string bindingQueryParameter = "binding";

        private const string errorQueryParameter = "error";

        private RedirectUrl redirectUrl = new RedirectUrl();
        public RedirectUrl RedirectUrl
        {
            get
            {
                return redirectUrl;
            }

            set
            {
                redirectUrl = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            RedirectUrl.LoginUrl = FormsAuthentication.LoginUrl;
            RedirectUrl.DefaultUrl = FormsAuthentication.DefaultUrl;
            RedirectUrl.ReturnUrl = Request.QueryString["ReturnUrl"];
            RequestLoginAtIdentityProvider();
        }

        #region SSO
        private string CreateAbsoluteURL(string relativeURL)
        {
            return new Uri(Request.Url, ResolveUrl(relativeURL)).ToString();
        }

        private string CreateAssertionConsumerServiceURL()
        {
            return string.Format("{0}?{1}={2}", CreateAbsoluteURL("~/Pages/SSO/AssertionConsumerService.aspx"), bindingQueryParameter, SAMLIdentifiers.Binding.HTTPPost);
        }

        private string CreateSSOServiceURL()
        {
            return SPConfiguration.HttpRedirectSingleSignOnServiceURL;
        }

        private XmlElement CreateAuthnRequest()
        {
            string assertionConsumerServiceURL = CreateAssertionConsumerServiceURL();

            AuthnRequest authnRequest = new AuthnRequest();
            authnRequest.Destination = SPConfiguration.IdpEntityId;
            authnRequest.Issuer = new Issuer(CreateAbsoluteURL("~/"));

            authnRequest.NameIDPolicy = new NameIDPolicy(null, null, true);
            authnRequest.ForceAuthn = false;
            authnRequest.ProtocolBinding = SAMLIdentifiers.BindingURIs.HTTPPost;
            authnRequest.AssertionConsumerServiceURL = assertionConsumerServiceURL;

            XmlElement authnRequestXml = authnRequest.ToXml();

            return authnRequestXml;
        }

        private void RequestLoginAtIdentityProvider()
        {
            XmlElement authnRequestXml = CreateAuthnRequest();

            string spResourceURL = CreateAbsoluteURL(FormsAuthentication.GetRedirectUrl("", false));

            string relayState = DMS.Website.Common.RelayStateCache.Add(new RelayState(spResourceURL, RedirectUrl));

            _log.Info(relayState);

            string idpURL = CreateSSOServiceURL();

            switch (SPConfiguration.SingleSignOnServiceBinding)
            {
                case SAMLIdentifiers.Binding.HTTPRedirect:
                    ServiceProvider.SendAuthnRequestByHTTPRedirect(Response, idpURL, authnRequestXml, relayState, null);
                    break;
                case SAMLIdentifiers.Binding.HTTPPost:
                    ServiceProvider.SendAuthnRequestByHTTPPost(Response, idpURL, authnRequestXml, relayState);
                    Response.End();
                    break;
                case SAMLIdentifiers.Binding.HTTPArtifact:
                    string identificationURL = CreateAbsoluteURL("~/");
                    HTTPArtifactType4 httpArtifact = new HTTPArtifactType4(HTTPArtifactType4.CreateSourceId(identificationURL), HTTPArtifactType4.CreateMessageHandle());
                    HTTPArtifactState httpArtifactState = new HTTPArtifactState(authnRequestXml, null);
                    HTTPArtifactStateCache.Add(httpArtifact, httpArtifactState);
                    ServiceProvider.SendArtifactByHTTPArtifact(Response, idpURL, httpArtifact, relayState, false);
                    break;
                default:
                    throw new ArgumentException("Invalid binding type");
            }
        }
        #endregion
    }
}