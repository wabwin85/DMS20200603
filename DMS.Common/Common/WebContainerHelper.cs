/***********************************************************************************************
 *
 ****** Copyright (C) 2009/2010 - GrapeCity  ******** http://www.grapecity.com *****************
 ****** ********************
 *
 * NameSpace   : DMS.Common.Common
 * ClassName   : WebContainerHelper
 * Created Time: 8/3/2009 5:01:35 PM  
 * Author      : DonsonWan 
 * Description :
 *
 * history: * Created By DonsonWan ,8/3/2009 5:01:35 PM 
 * 
 * 
***********************************************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common
{
    using System.Configuration;
    using Grapecity.Logging;
    using Microsoft.Practices.Unity;
    using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
    using Microsoft.Practices.Unity.Configuration;
    using Microsoft.Practices.EnterpriseLibrary.PolicyInjection.Configuration;
    using Microsoft.Practices.Unity.InterceptionExtension;

    public static class WebContainerHelper
    {


        public static void ConfigureContainer(IUnityContainer container, string containerName)
        {
            IConfigurationSource config = ConfigurationSourceFactory.Create();

            UnityConfigurationSection section
                = config.GetSection("unity") as UnityConfigurationSection;


            if (section != null)
            {
                //if (section.Containers.Default != null)
                //    section.Containers.Default.Configure(container);

                UnityContainerElement containerElement = section.Containers[containerName];
                if (containerElement != null)
                {
                    containerElement.Configure(container);
                }
            }
        }
    }
}
