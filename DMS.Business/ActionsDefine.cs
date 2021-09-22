/***********************************************************************************************
 *
 ****** Copyright (C) 2009/2010 - GrapeCity  ******** http://www.grapecity.com *****************
 ****** ********************
 *
 * NameSpace   : DMS.Business
 * ClassName   : ActionsDefine
 * Created Time: 8/31/2009 4:30:32 PM  
 * Author      : DonsonWan 
 * Description :
 *
 * history: * Created By DonsonWan ,8/31/2009 4:30:32 PM 
 * 
 * 
***********************************************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    /// <summary>
    /// 基础数据日志记录的事件定义

    /// </summary>
    public class ActionsDefine
    {
        public const int EventId_Hospital = Data.DMSLogging.BaseEventId + 1;
        public const int EventId_Authorization= Data.DMSLogging.BaseEventId + 2;
        public const int EventId_Classification = Data.DMSLogging.BaseEventId + 3;
        public const int EventId_Dealer = Data.DMSLogging.BaseEventId + 4;
        public const int EventId_Cfns = Data.DMSLogging.BaseEventId + 5;

        public const int EventId_DealerAop = Data.DMSLogging.BaseEventId + 6;
        public const int EventId_SalerAop = Data.DMSLogging.BaseEventId + 7;

        public const int EventId_DealerForeCast = Data.DMSLogging.BaseEventId + 8;
        public const int EventId_FlowTemplate = Data.DMSLogging.BaseEventId + 9;

        public const int EventId_BulletinManage = Data.DMSLogging.BaseEventId + 10;
        public const int EventId_BulletinSearch = Data.DMSLogging.BaseEventId + 11;
        public const int EventId_DealerQA = Data.DMSLogging.BaseEventId + 12;
        public const int EventId_IssuesList = Data.DMSLogging.BaseEventId + 13;

        public const int EventId_RegistrationInit = Data.DMSLogging.BaseEventId + 14;
        public const int EventId_Registration = Data.DMSLogging.BaseEventId + 15;

        public const int EventId_CFNSet = Data.DMSLogging.BaseEventId + 16;
        public const int EventId_CFNHospitalPrice = Data.DMSLogging.BaseEventId + 17;

        public const int EventId_DealerRelation = Data.DMSLogging.BaseEventId + 18;

        public const int EventId_Stocktaking = Data.DMSLogging.BaseEventId + 19;
    }
}
