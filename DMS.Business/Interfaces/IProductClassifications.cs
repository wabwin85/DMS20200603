using System;
using System.Collections.Generic;

namespace DMS.Business
{
    using DMS.Model;
    using System.Collections;

    /// <summary>
    /// IProductClassifications, <see cref="ProductClassifications"/>
    /// </summary>
    public interface IProductClassifications
    {
        PartsClassification GetObject(Guid objKey);
        IList<PartsClassification> GetAll();
        IList<PartsClassification> GetRoot();
        IList<PartsClassification> SelectByFilter(PartsClassification obj);
        IList<PartsClassification> GetClassificationByLine(Guid lineId);

        void Insert(PartsClassification obj);
        int Update(PartsClassification obj);
        int Delete(Guid partId);
        string UpdatePartsClassification(Hashtable obj);
        string DeletePartsClassification(Hashtable obj);
    }
}
