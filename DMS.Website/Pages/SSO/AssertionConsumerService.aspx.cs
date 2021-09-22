using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Com.Zealan.Saml.Assertions;
using Com.Zealan.Saml.Bindings;
using Com.Zealan.Saml.Profiles;
using Com.Zealan.Saml.Protocols;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web.Security;
using DMS.Model.SSO;
using Com.Zealan.Saml;
using Common.Logging;

namespace DMS.Website.Pages.SSO
{
    public partial class AssertionConsumerService : System.Web.UI.Page
    {

        private static ILog _log = LogManager.GetLogger(typeof(AssertionConsumerService));

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

        private string CreateAbsoluteURL(string relativeURL)
        {
            return new Uri(Request.Url, ResolveUrl(relativeURL)).ToString();
        }

        private void ReceiveSAMLResponse(out SAMLResponse samlResponse, out string relayState)
        {
            SAMLIdentifiers.Binding bindingType = SAMLIdentifiers.Binding.HTTPPost;

            if (!string.IsNullOrEmpty(Request.QueryString[bindingQueryParameter]))
            {
                bindingType = (SAMLIdentifiers.Binding)Enum.Parse(typeof(SAMLIdentifiers.Binding), Request.QueryString[bindingQueryParameter]);
            }

            XmlElement samlResponseXml = null;
            switch (bindingType)
            {
                case SAMLIdentifiers.Binding.HTTPPost:
                    ServiceProvider.ReceiveSAMLResponseByHTTPPost(Request, out samlResponseXml, out relayState);
                    break;
                case SAMLIdentifiers.Binding.HTTPArtifact:
                    HTTPArtifact httpArtifact = null;
                    ServiceProvider.ReceiveArtifactByHTTPArtifact(Request, false, out httpArtifact, out relayState);
                    ArtifactResolve artifactResolve = new ArtifactResolve();
                    artifactResolve.Issuer = new Issuer(CreateAbsoluteURL("~/"));
                    artifactResolve.Artifact = new Artifact(httpArtifact.ToString());
                    XmlElement artifactResolveXml = artifactResolve.ToXml();
                    XmlElement artifactResponseXml =
                    ArtifactResolver.SendRequestReceiveResponse(Com.Zealan.Saml.SPConfiguration.ArtifactResolutionServiceURL,
                    artifactResolveXml);
                    ArtifactResponse artifactResponse = new ArtifactResponse(artifactResponseXml);
                    samlResponseXml = artifactResponse.SAMLMessage;
                    break;
                default:
                    throw new ArgumentException("Unknown binding type");
            }

            samlResponse = new SAMLResponse(samlResponseXml);
        }

        private void ProcessSuccessSAMLResponse(SAMLResponse samlResponse, string relayState)
        {
            SAMLAssertion samlAssertion = null;

            if (samlResponse.GetAssertions().Count > 0)
            {
                samlAssertion = samlResponse.GetAssertions()[0];
                if (SAMLAssertionSignature.IsSigned(samlAssertion.ToXml()))
                {
                    X509Certificate2 x509Certificate = new X509Certificate2();
                    x509Certificate.Import(Convert.FromBase64String("MIIFTjCCBDagAwIBAgIKZof09gAAAAAETzANBgkqhkiG9w0BAQUFADCBxzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExHzAdBgNVBAoTFlNlY3VyZUF1dGggQ29ycG9yYXRpb24xOzA5BgNVBAsTMihjKSAyMDEyIFNlY3VyZUF1dGggQ29ycCAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MR0wGwYDVQQLExRDZXJ0aWZpY2F0ZSBTZXJ2aWNlczEmMCQGA1UEAxMdU2VjdXJlQXV0aCBJbnRlcm1lZGlhdGUgQ0EgMUEwHhcNMTMwNTAxMjI1MjAyWhcNMjMwNTAxMjI1MjAyWjCBiDELMAkGA1UEBhMCVVMxFjAUBgNVBAgTDU1hc3NhY2h1c2V0dHMxDzANBgNVBAcTBk5hdGljazEaMBgGA1UEChMRQm9zdG9uIFNjaWVudGlmaWMxETAPBgNVBAsTCERpcmVjdG9yMSEwHwYDVQQDExhTZWN1cmVBdXRoMDRkVk0uYnNjaS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD7ZKcrap2c5ArDTvMqMe7cHqs7utoZuA/ZWPATXH0c/loHChG2CR9bb6ADrP0zasV19Q6+PWKf/jvcL/7fNJw9mfDCrHWS3c32ghsVsWVcmpG2nWQxYWIz/bQio774R0D4XE0BQdPxvE4ctuYdE7g8OoN4NQxzphkT4FltTuUDwE8fNjbmf+aPOuSd8svZcF9wYZQb/Y2e7Mp136TL4ZXJAeFcN8R+OQg+Zy79XrAGCCjRJJH+vj1zL0CuZ1yPG8+QiAKSfOBJKDDCo2ww8b50Mtf2gtOM05/Xeju+6XORhk2A1SbM4q1QXrjixEW+BrACXfRJTDqTCIxTuh5qaQ5dAgMBAAGjggF3MIIBczAOBgNVHQ8BAf8EBAMCBPAwIAYDVR0lAQH/BBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMB0GA1UdDgQWBBTdfk3fmTQkd8VxfChjbqu25giT/jAfBgNVHSMEGDAWgBTGBJ2Y8Mp2N8zRZdX8s/t1LLkWDTBjBgNVHR8EXDBaMFigVqBUhlJodHRwOi8veDUwOS5tdWx0aWZhY3RvcnRydXN0My5jb20vQ2VydEluZm8vU2VjdXJlQXV0aCUyMEludGVybWVkaWF0ZSUyMENBJTIwMUEuY3JsMIGZBggrBgEFBQcBAQSBjDCBiTCBhgYIKwYBBQUHMAKGemh0dHA6Ly94NTA5Lm11bHRpZmFjdG9ydHJ1c3QzLmNvbS9DZXJ0SW5mby9TQUludENBLTFBLmJhbm5lci5tdWx0aWZhY3RvcnRydXN0My5jb21fU2VjdXJlQXV0aCUyMEludGVybWVkaWF0ZSUyMENBJTIwMUEuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQCWx4eaq6H+If8LZ+iygwV3xz8fIlLVftqgeYm6+WD6RFaVVs9uEYMT0h9YpPzlUb1Flvo6TRPW0nwvajzsq81kYfl6TreGtY/gqf8OYgoTgZUUGuu/91pTlWriYNYGBMDPbVInc42Ua+hqdBN6fqyF/4RaxdKLn4pkTuWQHAGuBrzauMdhNxhMQxAgYylOlgg04iYaAr7n1sHoNJ21M/8U9HFLsmN9xqO3PleK9A/o5J2QhC4DQE0wJBMuhMOP4GMG9bKJDwPFrh4p13LQXehzu3Bma3RybXSKmPDrx2BOC0S4nGaBhVD7MuQeCvnoFN/GoyE7dQ3k8GHxPYVMmlZV"));
                    bool result = SAMLAssertionSignature.Verify(samlAssertion.ToXml(), x509Certificate);
                }
            }
            else if (samlResponse.GetEncryptedAssertions().Count > 0)
            {
                //samlAssertion = samlResponse.GetEncryptedAssertions()[0].Decrypt(x509Certificate.PrivateKey, null);
            }
            else
            {
                throw new ArgumentException("No assertions in response");
            }
            // 获得对象名称标识符
            string userName = null;

            if (samlAssertion.Subject.NameID != null)
            {
                userName = samlAssertion.Subject.NameID.NameIdentifier;
                _log.Info("###########################userName：" + userName);
            }
            else if (samlAssertion.Subject.EncryptedID != null)
            {
                //NameID nameID = samlAssertion.Subject.EncryptedID.Decrypt(x509Certificate.PrivateKey, null);
                //userName = nameID.NameIdentifier;
            }
            else
            {
                // throw new ArgumentException("No name in subject");
            }

            _log.Info("###########################relayState：" + relayState); 

            RelayState cachedRelayState = DMS.Website.Common.RelayStateCache.Get(relayState);
            //if (cachedRelayState == null || cachedRelayState.AdditionalState == null)
            //{
            //    throw new ArgumentException("Invalid relay state");
            //}

            RedirectUrl cachedRedirectUrl;

            if (cachedRelayState != null && cachedRelayState.AdditionalState != null)
            {
                cachedRedirectUrl = (RedirectUrl)cachedRelayState.AdditionalState;

                _log.Info("###########################cachedRedirectUrl.DefaultUrl：" + cachedRedirectUrl.DefaultUrl);
                _log.Info("###########################cachedRedirectUrl.LoginUrl：" + cachedRedirectUrl.LoginUrl);
                _log.Info("###########################cachedRedirectUrl.ReturnUrl：" + cachedRedirectUrl.ReturnUrl);
            }
            else
            {
                _log.Info("###########################RelayStateCache.Get(relayState is null");

                cachedRedirectUrl = new RedirectUrl();
                cachedRedirectUrl.LoginUrl = FormsAuthentication.LoginUrl;
                cachedRedirectUrl.DefaultUrl = FormsAuthentication.DefaultUrl;
                cachedRedirectUrl.ReturnUrl = FormsAuthentication.DefaultUrl;
            }

            RedirectUrl.LoginUrl = string.IsNullOrEmpty(cachedRedirectUrl.LoginUrl) ? FormsAuthentication.LoginUrl : cachedRedirectUrl.LoginUrl;
            RedirectUrl.DefaultUrl = string.IsNullOrEmpty(cachedRedirectUrl.DefaultUrl) ? FormsAuthentication.DefaultUrl : cachedRedirectUrl.DefaultUrl;
            RedirectUrl.ReturnUrl = cachedRedirectUrl.ReturnUrl;

            DMS.Website.Common.RelayStateCache.Remove(relayState);

            Login(samlAssertion, userName);
        }
        private void ProcessErrorSAMLResponse(SAMLResponse samlResponse)
        {
            string errorMessage = null;
            if (samlResponse.Status.StatusMessage != null)
            {
                errorMessage = samlResponse.Status.StatusMessage.Message;
            }
            if (string.IsNullOrEmpty(errorMessage))
            {
                errorMessage = "IDP端返回异常，请重新登录！";
            }
            string redirectURL = String.Format("~/Login.aspx?{0}={1}", errorQueryParameter, HttpUtility.UrlEncode(errorMessage));
            Response.Redirect(redirectURL, false);
        }
        private void ProcessSAMLResponse()
        {
            SAMLResponse samlResponse = null;
            string relayState = null;
            ReceiveSAMLResponse(out samlResponse, out relayState);

            _log.Info("###########################samlResponse：" + samlResponse.ToXml().InnerText);
            _log.Info("###########################relayState：" + relayState);

            if (samlResponse.IsSuccess())
            {
                ProcessSuccessSAMLResponse(samlResponse, relayState);
            }
            else
            {
                ProcessErrorSAMLResponse(samlResponse);
            }
        }
        private void Login(SAMLAssertion ass, string userName)
        {
            MembershipUser user = Membership.GetUser(userName);
            bool result = true;
            string message = null;        

            if (user == null)
            {
                message = "用户不存在";
            }
            else if (user.IsLockedOut)
            {
                message = "用户已锁定";
            }

            result = message == null;          

            if (result)
            {
                FormsAuthentication.SetAuthCookie(userName, false);

                if (RedirectUrl.ReturnUrl == null)
                {
                    this.Response.Redirect(RedirectUrl.DefaultUrl, false);
                }
                else
                {
                    this.Response.Redirect(RedirectUrl.ReturnUrl, false);
                }
            }
            else
            {
                //Page.ClientScript.RegisterStartupScript(this.GetType(), "error", "<script>alert('" + message + "');window.location.href = '" + RedirectUrl.LoginUrl + "';</script>");
                if (RedirectUrl.ReturnUrl == null)
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "error", "<script>alert('" + message + "');window.location.href = '" + this.ResolveUrl(RedirectUrl.LoginUrl) + "';</script>");
                else
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "error", "<script>alert('" + message + "');window.location.href = '" + this.ResolveUrl(RedirectUrl.LoginUrl) + "?ReturnUrl=" + HttpUtility.UrlEncode(RedirectUrl.ReturnUrl) + "';</script>");
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                ProcessSAMLResponse();
            }
            catch (Exception exception)
            {
                _log.Info(exception.ToString());
                Trace.Write("SP", "Error in assertion consumer service", exception);
            }
        }
    }
}