using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;

namespace DMS.Business.MasterData
{
    public interface IProductLevelRelationship
    {
        DataSet GetProductlevelRelation();
    }
}
