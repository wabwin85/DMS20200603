using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;


namespace DMS.ViewModel.Contract
{
    public class MergeAttachmentVO : BaseQueryVO
    {
        public KeyValue WinFileType;

        public ArrayList RstResultList = null;
        public ArrayList LstFileType = null;

        public String HidContractId;
        public String SelectAttachId;
        public String HidDealerType;
        public String HidFileType;

        public KeyValue WinAttachType;
        public String WinAttachName;
        public String WinUploadDate;
        public String HidFileExt;
        public String HidOldType;

        public bool DisableUpload = false;
        public bool DisableDDL = false;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
