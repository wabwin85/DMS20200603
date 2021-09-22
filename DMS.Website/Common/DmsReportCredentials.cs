using Microsoft.Reporting.WebForms;
using System.Net;
using System.Configuration;
using System;
using System.Security.Principal;

[Serializable]
class DmsReportCredentials : IReportServerCredentials
{
    public DmsReportCredentials()
    {
    }

    public WindowsIdentity ImpersonationUser
    {
        get { return null; }
    }

    public ICredentials NetworkCredentials
    {
        get
        {
            return new NetworkCredential(
                ConfigurationManager.AppSettings["ReportViewerUserID"],
                ConfigurationManager.AppSettings["ReportViewerPassword"]);
        }
    }

    public bool GetFormsCredentials(out Cookie authCookie, out string userName, out string password, out string authority)
    {
        authCookie = null;
        userName = null;
        password = null;
        authority = null;
        return false;
    }
}