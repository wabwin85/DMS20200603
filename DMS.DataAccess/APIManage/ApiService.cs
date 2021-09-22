using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using DMS.Model.ApiModel;
using DMS.Common;
using Newtonsoft.Json;

namespace DMS.DataAccess.APIManage
{
    public class ApiService
    {
        /// <summary>
        /// 获取UPN证照信息
        /// </summary>
        /// <param name="UPN"></param>
        /// <param name="Category"></param>
        /// <param name="Lot"></param>
        /// <returns></returns>
        public static UPNDocumentDetail GetDMSCMSDocumentLinkDetail(String UPN, String Category, String Lot)
        {
            Hashtable ht = new Hashtable();
            Hashtable htParams = new Hashtable();

            htParams.Add("UPN", UPN);
            htParams.Add("Category", Category);
            htParams.Add("Lot", Lot);
            ht.Add("parameters", htParams);

            String str = CallAPI("getDMSCMSDocumentLinkDetail", JsonHelper.Serialize(ht));

            BaseApiModel baseApiModel = JsonConvert.DeserializeObject<BaseApiModel>(str);
            if (baseApiModel.status != 200)
            {
                ErrorApiModel errorApiModel = JsonConvert.DeserializeObject<ErrorApiModel>(str);
                throw new Exception(errorApiModel.datas);
            }

            return JsonConvert.DeserializeObject<UPNDocumentDetail>(str);
        }

        private static string CallAPI(string apiName, string postData)
        {
            var section = ConfigurationManager.GetSection("BSC.OpenApi/" + apiName) as IDictionary;

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(section["requesturl"].ToString());
            request.Method = "POST";
            request.Accept = "application/json";
            request.ContentType = "application/json";

            request.Headers.Add("accesstoken", section["accesstoken"].ToString());
            request.Headers.Add("apptoken", section["apptoken"].ToString());

            byte[] buffer = Encoding.UTF8.GetBytes(postData);
            request.ContentLength = buffer.Length;
            request.GetRequestStream().Write(buffer, 0, buffer.Length);
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            using (StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8))
            {
                return reader.ReadToEnd();
            }
        }
    }
}
