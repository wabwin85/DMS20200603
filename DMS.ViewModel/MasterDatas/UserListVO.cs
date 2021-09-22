using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class UserListVO : BaseQueryVO
    {               
        public String QryLoginId;
        public String QryFullName;
        public String QryEmail;


        public ArrayList RstResultList = null;
        public ArrayList RstUploadUserInfo = null;


        //public ArrayList LstUserID = null;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
