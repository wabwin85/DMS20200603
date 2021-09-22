using DMS.DataAccess.EKPWorkflow;
using DMS.Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DMS.Model.EKPWorkflow;
using System.Text;
using DMS.Common;
using System.Data;
using Common.Logging;
using DMS.Business.kmReviewWebserviceService;

namespace DMS.Business.EKPWorkflow
{
    public class EkpWorkflow_TestBLL
    {
        public void test()
        {
            kmReviewWebserviceService.IKmReviewWebserviceServiceService service = new kmReviewWebserviceService.IKmReviewWebserviceServiceService();
            service.RequestSOAPHeader = new RequestSOAPHeader("admin", "c4ca4238a0b923820dcc509a6f75849b");
            service.addReview(new kmReviewParamterForm());
        }
    }
}
