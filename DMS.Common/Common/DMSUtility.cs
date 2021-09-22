/**********************************************
 *
 * NameSpace   : DMS.Common 
 * ClassName   : DMSUtility
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common
{
    using Grapecity.Core.Util;
    using Lafite.RoleModel.Security;



    public class DMSUtility
    {
        public static string GetLoginId()
        {
            return RoleModelContextHelper.GetLoginUserId();
        }

        /// <summary>
        /// GetGuid 统一调用，便于更改规则
        /// </summary>
        /// <returns></returns>
        public static Guid GetGuid()
        {
            return CombID.NewId();
        }

        /// <summary>
        /// string Guid 
        /// </summary>
        /// <returns></returns>
        public static string NewGuid()
        {
            return GetGuid().ToString();
        }
    }
}
