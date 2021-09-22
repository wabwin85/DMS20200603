/**********************************************
 *
 * NameSpace   : DMS.Business 
 * ClassName   : ProductClassification
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Data
{
    using DMS.Model;

    public class ProductClassification  : PartsClassification
    {
        ProductClassification _parent = null;

        public ProductClassification Parent {
            get { return _parent; }
            set { _parent = value; }
        }
    }
}
