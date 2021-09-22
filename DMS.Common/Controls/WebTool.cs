using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Linq;

namespace DMS.Common.WebControls
{
	/// <summary>
	/// Post方式传递的参数
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
		/// 使用Post方式传递一个参数
		/// </summary>
		/// <param name="url">接收参数的URL</param>
		/// <param name="name">参数的名称</param>
		/// <param name="value">参数值</param>
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
		/// 使用Post方式传递一组参数
		/// </summary>
		/// <param name="url">接收参数的URL</param>
		/// <param name="paramsList">参数列表（由WebParem构成）</param>
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
		/// 取得Post方法传递的参数
		/// </summary>
		/// <param name="name">参数名称</param>
		/// <returns>参数值</returns>
		public string getParam(string name)
		{
			if (request.Params[name] == null) return "";
			return request.Params[name].ToString();
		}

		/// <summary>
		/// 弹出警告框
		/// </summary>
		/// <param name="text">警告框内容</param>
		public void alert(string text)
		{
            text = text.Replace("'", "\\'");
			response.Write(@"<script language='JavaScript' type='text/JavaScript'>alert('" + text + @"');</script>");
		}

		/// <summary>
		/// 关闭IE窗体
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
