using System;
using System.Collections.Generic;
using DMS.Common;
using DMS.Model;
using System.Data;
using System.Collections;
using DMS.ViewModel.Common;
using DMS.ViewModel.MasterDatas;

namespace DMS.Business
{
    public interface IPositionHospital
    {
        DataSet ExportHospitalPosition(string positionID);

       DataSet SelectOrgsForPositionHospital(string attributeId);
        DataSet SelectHospitalPosition_ValidByFilter(string positionID, int start, int limit, out int rowCount);
        bool SaveHospitalPositionMapChanges(ChangeRecords<View_HospitalPosition> data);

        void DeleteUploadInfoByUser();
        void UploadInfoVerify(int IsImport, out string RtnVal, out string RtnMsg);
        bool UploadInfoImport(DataTable dt, string fileName);
        DataSet QueryUploadInfo(Hashtable table, int start, int limit, out int totalRowCount);
    }
}
