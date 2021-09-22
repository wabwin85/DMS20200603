using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Text;
using DMS.Business;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
namespace DMS.Website.Service
{
    /// <summary>
    /// $codebehindclassname$ 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ProductQrCodeQuery : IHttpHandler
    {
        public static string token = "A5520A36-4C66-4AE5-BE96-ED9A1B0D8E1A";
        ProductCodeQueryBLL bll = new ProductCodeQueryBLL();
        HttpQrcode QrCodeMode = new HttpQrcode();
        HttpPostResultModel ResultMode = new HttpPostResultModel();
        public void ProcessRequest(HttpContext context)
        {

            //if (context.Request.HttpMethod.ToLower() == "post")
            //{
                PostInput(context);
                IsoDateTimeConverter timeFormat = new IsoDateTimeConverter();
                timeFormat.DateTimeFormat = "yyyy-MM-dd";
                string strResult = JsonConvert.SerializeObject(QueryProductInfo(QrCodeMode), Formatting.None, timeFormat);
                context.Response.Write(strResult);
                context.Response.End();
            //}
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        /// <summary>
        /// 获取post返回来的数据
        /// </summary>
        /// <returns></returns>
        private void PostInput(HttpContext context)
        {
            QrCodeMode.token = context.Request.Params["token"];
            QrCodeMode.Qrcode = context.Request.Params["Qrcode"];

            //System.IO.Stream s = System.Web.HttpContext.Current.Request.InputStream;
            //byte[] b = new byte[s.Length];
            //s.Read(b, 0, (int)s.Length);
            //string[] temp = HttpUtility.UrlDecode(b, Encoding.GetEncoding("utf-8")).Split('&');
            //if (temp.Length >= 2)
            //{
            //    QrCodeMode.token = temp[0].Split('=')[1];
            //    QrCodeMode.Qrcode = temp[1].Split('=')[1];
            //}
        }
        public HttpPostResultModel QueryProductInfo(HttpQrcode QrCodeMode)
        {
            Object Product = new Object();
            try
            {
                if (QrCodeMode.token == token)//判断toke是否正确
                {
                    DataSet Productds = bll.SelectProductCode(QrCodeMode.Qrcode);
                    if (Productds.Tables[0].Rows.Count > 0)
                    {
                        ResultMode.errcode = "200";//调用成功
                        ResultMode.errmsg = "ok";

                        List<Object> Dealares = new List<Object>();
                        DataSet Dealareds = bll.ProductDelareQuery(QrCodeMode.Qrcode);
                        foreach (DataRow row in Dealareds.Tables[0].Rows)
                        {
                            Object Dealare = new
                            {
                                dealdate = row["dealdate"],
                                from = row["from"],
                                to = row["to"],
                                TransType = row["TransType"],
                                MktType = row["MktType"]
                            };
                            Dealares.Add(Dealare);
                        }

                        Product = new
                        {
                            saleType = "",
                            productcode = "",
                            upn = Productds.Tables[0].Rows[0]["UPN"],
                            productname = Productds.Tables[0].Rows[0]["productname"],
                            qrcode = Productds.Tables[0].Rows[0]["qrcode"],
                            lot = Productds.Tables[0].Rows[0]["LOT"],
                            expiretime = Productds.Tables[0].Rows[0]["expiretime"]==DBNull.Value ? "" : Productds.Tables[0].Rows[0]["expiretime"],
                            uom = Productds.Tables[0].Rows[0]["uom"],
                            logistics = Dealares
                        };
                    }
                    else
                    {
                        if (!bll.IsQrCodeExists(QrCodeMode.Qrcode))
                        {
                            ResultMode.errcode = "300";
                            ResultMode.errmsg = "该二维码不存在";
                        }
                        else
                        {
                            ResultMode.errcode = "500";
                            ResultMode.errmsg = "该二维码未关联产品信息";
                        }
                    }
                }
                else
                {
                    ResultMode.errcode = "100";
                    ResultMode.errmsg = "token错误";
                }
            }
            catch (Exception ex)
            {
                ResultMode.errcode = "400";
                ResultMode.errmsg = ex.Message.ToString();
            }
            ResultMode.data = Product;
            return ResultMode;
        }
        public class HttpPostResultModel
        {
            public string errcode { get; set; }
            public string errmsg { get; set; }
            public Object data { get; set; }

        }
        public class HttpQrcode
        {
            public string token { get; set; }
            public string Qrcode { get; set; }
        }
    }
}
