using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.Business
{
    public interface IReturnPositionSearchBLL
    {   //查询
        DataSet GetPosition(Hashtable obj, int start, int limit, out int totalCount);
        //导出详细
        DataSet ExcleGetPosition(Hashtable obj);
      //详细查询
        DataSet GetObjectid(Hashtable obj, int start, int limit, out int totalCount);

        bool insert (Hashtable obj);
        DataSet baocuo(Guid id);
    }
}
