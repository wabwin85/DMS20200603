using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;

namespace DMS.ViewModel.Platform
{
    public class BulletinReadVO : BaseBusinessVO
    {
        public String IptTitle;
        public String IptPublishedDate;
        public String IptBody;
        public bool IptConfirmFlag;

        public ArrayList RstAttachment;
    }
}
