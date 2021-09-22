using Common.Logging;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.PagesKendo.ESign
{
    public partial class EnterprisePayResult : System.Web.UI.Page
    {
        private static ILog _log = LogManager.GetLogger(typeof(EnterprisePayResult));
        protected void Page_Load(object sender, EventArgs e)
        {
            try {
                String type = String.Empty;
                String Re = String.Empty;
                Re += "数据传送方式：";

                if (Request.RequestType.ToUpper() == "POST")
                {
                    type = "POST";
                    Re += type + "<br/>参数分别是：<br/>";
                    SortedList table = Param();
                    if (table != null)
                    {
                        foreach (DictionaryEntry De in table) { Re += "参数名：" + De.Key + " 值：" + De.Value + "<br/>"; }
                    }
                    else
                    {
                        Re = "你没有传递任何参数过来！";
                    }
                }
                else
                {
                    type = "GET";
                    Re += type + "<br/>参数分别是：<br/>";
                    NameValueCollection nvc = GETInput();
                    if (nvc.Count != 0)
                    {
                        for (int i = 0; i < nvc.Count; i++) { Re += "参数名：" + nvc.GetKey(i) + " 值：" + nvc.GetValues(i)[0] + "<br/>"; }
                    }
                    else
                    {
                        Re = "你没有传递任何参数过来！";
                    }
                }

                _log.Info(Re);
            }
            catch (Exception ex)
            {
                _log.Info(ex.ToString());
            }
        }

        private NameValueCollection GETInput()
        {
            return Request.QueryString;
        }

        private String PostInput()
        {
            try
            {
                System.IO.Stream s = Request.InputStream;
                int count = 0;
                byte[] buffer = new byte[1024];
                StringBuilder builder = new StringBuilder();
                while ((count = s.Read(buffer, 0, 1024)) > 0)
                {
                    builder.Append(Encoding.UTF8.GetString(buffer, 0, count));
                }
                s.Flush();
                s.Close();
                s.Dispose();
                return builder.ToString();
            }
            catch (Exception ex)
            {
                _log.Info(ex);
                throw ex;
            }
        }

        private SortedList Param()
        {
            String POSTStr = PostInput();
            SortedList SortList = new SortedList();
            int index = POSTStr.IndexOf("&");
            String[] Arr = { };

            if (index != -1)
            {
                Arr = POSTStr.Split('&');
                for (int i = 0; i < Arr.Length; i++)
                {
                    int equalindex = Arr[i].IndexOf('=');
                    string paramN = Arr[i].Substring(0, equalindex);
                    string paramV = Arr[i].Substring(equalindex + 1);
                    if (!SortList.ContainsKey(paramN))
                    {
                        SortList.Add(paramN, paramV);
                    }
                    else
                    {
                        SortList.Remove(paramN); SortList.Add(paramN, paramV);
                    }
                }
            }
            else
            {
                int equalindex = POSTStr.IndexOf('=');
                if (equalindex != -1)
                {
                    //参数是1项
                    string paramN = POSTStr.Substring(0, equalindex);
                    string paramV = POSTStr.Substring(equalindex + 1);
                    SortList.Add(paramN, paramV);
                }
                else
                {
                    SortList = null;
                }
            }
            return SortList;
        }
    }
}