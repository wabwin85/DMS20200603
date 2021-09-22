using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel
{
    public class ChangePasswordVO : BaseQueryVO
    {
        public String OldPassword = String.Empty;
        public String NewPassword = String.Empty;
        public String ComNewPassWord = String.Empty;
        
    }
}
