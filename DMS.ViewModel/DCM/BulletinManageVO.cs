using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.DCM
{
    public class BulletinManageVO : BaseQueryVO
    {
        //主页面
        public String QryTitle;
        public String QryPublishedUser;
        public KeyValue QryUrgentDegree;
        public KeyValue QryStatus;
        public DatePickerRange QryPublishedDate;
        public DatePickerRange QryExpirationDate;
        public bool ShowSearch;
        public bool ShowImport;

        public ArrayList LstUrgentDegree = null;
        public ArrayList LstStatus = null;
        public ArrayList RstResultList = null;

        //明细
        public String BulletId;
        public KeyValue WinUrgentDegree;
        public KeyValue WinStatus;
        public DateTime WinExpirationDate;
        public bool WinIsRead;
        public bool WinIsPublisher;
        //public bool WinIsDraft;
        //public bool WinIsPageNew;
        //public bool WinIsSaved;
        public bool WinIsEmptyId;
        public String WinHdStatus;
        public String WinTitle;
        public String WinBody;

        //经销商列表
        public String DelDealerId;
        public String ChooseParam;
        public ArrayList RstDealerDetailList = null;

        public String WinFilterDealer;
        public String WinFilterSAPCode;
        public KeyValue WinFilterDealerType;

        public ArrayList LstDealerType = null;
        public ArrayList RstFilterDealerResult = null;

        //附件列表
        public String DelAttachId;
        public ArrayList RstAttachmentList = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
