using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Linq;

namespace DMS.Common.WebControls
{
	/// <summary>
	/// Post��ʽ���ݵĲ���
	/// </summary>
	public class WebParam
	{
		private string _name = string.Empty;
        private string _value = string.Empty;

        public string Name{ 
            get { return _name; } 
            set { _name = value;}
        }

        public string Value{
            get { return _value;}
            set { _value = value;}
        }

        public WebParam(){}

        public WebParam(string name):this(name,string.Empty) {}

        public WebParam(string name, string value)
        {
            _name = name;
            _value = value;
        }

	}

    /// <summary>
    /// WebTool
    /// </summary>
	public class WebTool
	{
        public WebTool()
		{
			response = System.Web.HttpContext.Current.Response;
			request = System.Web.HttpContext.Current.Request;
		}
		private HttpResponse response;
		private HttpRequest request ;

		/// <summary>
		/// ʹ��Post��ʽ����һ������
		/// </summary>
		/// <param name="url">���ղ�����URL</param>
		/// <param name="name">����������</param>
		/// <param name="value">����ֵ</param>
		public void post(string url,string name,string value )
		{
			IList<WebParam> list = new List<WebParam>();
			WebParam p = new WebParam();
			p.Name = name;
			p.Value = value;
			list.Add(p);
			post(url,list);
		}


		/// <summary>
		/// ʹ��Post��ʽ����һ�����
		/// </summary>
		/// <param name="url">���ղ�����URL</param>
		/// <param name="paramsList">�����б���WebParem���ɣ�</param>
		public void post(string url, IList<WebParam> paramsList)
		{
			StringBuilder sb = new StringBuilder();
			sb.Append(@"<form id=""form1"" action=""" + url + @""" method=""post"">");
			for (int i = 0; i < paramsList.Count; i++)
			{
                WebParam p = (WebParam)paramsList[i];
				sb.Append(@"<input type=""hidden"" name=""" + p.Name + @""" value=""" + p.Value + @""">");
			}
			sb.Append(@"</form>");
			sb.Append(@"<script language=""javascript"">");
			sb.Append(@"document.getElementById('form1').submit();");
			sb.Append(@"</script>");
			
			response.Write(sb.ToString());
		}
		
		/// <summary>
		/// ȡ��Post�������ݵĲ���
		/// </summary>
		/// <param name="name">��������</param>
		/// <returns>����ֵ</returns>
		public string getParam(string name)
		{
			if (request.Params[name] == null) return "";
			return request.Params[name].ToString();
		}

		/// <summary>
		/// ���������
		/// </summary>
		/// <param name="text">���������</param>
		public void alert(string text)
		{
            text = text.Replace("'", "\\'");
			response.Write(@"<script language='JavaScript' type='text/JavaScript'>alert('" + text + @"');</script>");
		}

		/// <summary>
		/// �ر�IE����
		/// </summary>
		public void close()
		{
			//response.Write(@"<script language='JavaScript' type='text/JavaScript'>window.opener.document.viewHolidayForm.submit()</script>");
            response.Write(@"<script language='JavaScript' type='text/JavaScript'>window.close();</script>");
		}


		public void doJavaScript(string text)
		{
			response.Write(@"<script language='JavaScript' type='text/JavaScript'>" + text + @"</script>");
		}


	}
}
