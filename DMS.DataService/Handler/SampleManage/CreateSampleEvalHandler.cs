using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using System.Text;
using System.Globalization;
using DMS.Model;
using DMS.Business.DataInterface;
using DMS.DataService.Util;
using DMS.Model.DataInterface;
using DMS.Model.DataInterface.SampleManage;
using DMS.Business;

namespace DMS.DataService.Handler
{
    public class CreateSampleEvalHandler : UploadData
    {
        public CreateSampleEvalHandler(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.SampleEvalUploader;
            this.LoadData += new EventHandler<DataEventArgs>(CreateSampleEvalHandler_LoadData);
        }

        //空格-32 \r-13 \n-10
        void CreateSampleEvalHandler_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                {
                    throw new Exception("传入字符串为空");
                }

                SoapCreateSampleEval soap = DataHelper.Deserialize<SoapCreateSampleEval>(e.ReturnXml);

                if (soap == null || soap.SampleEvalHead == null)
                {
                    throw new Exception("传入数据为空");
                }

                SampleApplyBLL sampleApplyBLL = new SampleApplyBLL();

                IList<SampleEval> evalList = new List<SampleEval>();

                SampleApplyHead existsHead = sampleApplyBLL.GetSampleApplyHeadByApplyNo(soap.SampleEvalHead.ApplyNo);
                if (existsHead == null)
                {
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[申请号不存在]]></rtnMsg></result>";
                    e.Success = true;
                    return;
                }

                if (soap.SampleEvalHead.EvalList != null)
                {
                    for (int i = 0; i < soap.SampleEvalHead.EvalList.Length; i++)
                    {
                        //TODO 判断评估单数量是否超过剩余数量
                        SampleEval eval = new SampleEval();
                        eval.SampleEvalId = Guid.NewGuid();
                        eval.SampleHeadId = existsHead.SampleApplyHeadId;
                        eval.UpnNo = soap.SampleEvalHead.EvalList[i].UpnNo;
                        eval.Lot = soap.SampleEvalHead.EvalList[i].Lot;
                        //eval.EvalQuantity = Convert.ToInt32(soap.SampleEvalHead.EvalList[i].EvalQuantity);
                        //eval.UpnMemo = soap.SampleEvalHead.EvalList[i].UpnMemo;
                        //eval.SortNo = i + 1;
                        eval.CreateDate = DateTime.Now;
                        eval.UpdateDate = DateTime.Now;
                        
                        evalList.Add(eval);
                    }
                }

                sampleApplyBLL.CreateSampleEval(evalList);

                e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";
                e.Success = true;
            }
            catch (Exception ex)
            {
                e.Success = false;
                e.Message = ex.Message;
            }
        }
    }
}
