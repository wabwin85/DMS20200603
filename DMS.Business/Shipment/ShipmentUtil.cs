using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using DMS.Business.Cache;
using Lafite.RoleModel.Domain;

namespace DMS.Business
{
    public class ShipmentUtil
    {
        public ProductLineAttribute GetProductLineAttribute(Guid id)
        {
            ProductLineAttribute ret = null;
            IList<AttributeDomain> list = OrganizationCacheHelper.GetDictionary(SR.Organization_ProductLine).Where<AttributeDomain>(p => p.Id == id.ToString()).ToList<AttributeDomain>();
            if (list != null && list.Count > 0)
            {
                AttributeDomain attr = list[0];
                if (!string.IsNullOrEmpty(attr.AttributeField1))
                {
                    string[] parameters = attr.AttributeField1.Split(',');
                    if (parameters.Length == 3)
                    {
                        ret = new ProductLineAttribute();
                        ret.Due1 = Convert.ToInt32(parameters[0]);
                        ret.Due2 = Convert.ToInt32(parameters[1]);
                        ret.Due3 = Convert.ToInt32(parameters[2]);
                    }
                }
            }
            return ret;
        }

        public Boolean GetDateConstraints(String DateType, DateTime ShipmentDate, Guid productLineId)
        {
            Boolean rtn = false;
            ShipmentUtil shipmentUtil = new ShipmentUtil();

            ProductLineAttribute plAttr = shipmentUtil.GetProductLineAttribute(productLineId);
            if (plAttr != null)
            {
                if (DateType == "ShipmentDate") //销售达成日期限制校验
                {
                    CalendarDateDao dao = new CalendarDateDao();
                    string ym = DateTime.Now.ToString("yyyyMM").Substring(0, 6);
                    CalendarDate cd = dao.GetObject(ym);
                    DateTime dateMax = DateTime.Now;

                    //DateTime dateMin = DateTime.Now.AddDays(-plAttr.Due1);
                    if (cd == null)
                    {
                        if (DateTime.Compare(dateMax, ShipmentDate) >= 0)
                        {
                            rtn = true;
                        }
                    }
                    else
                    {
                        int limitNo = Convert.ToInt32(cd.Date1);

                        int day = DateTime.Now.Day - 1;
                        if (day > limitNo)
                        {
                            DateTime dateMin = DateTime.Now.AddDays(-day).Date;
                            if (DateTime.Compare(dateMax, ShipmentDate) >= 0 && DateTime.Compare(dateMin, ShipmentDate) <= 0)
                                rtn = true;
                        }
                        else
                        {
                            DateTime dateMin = DateTime.Now.AddDays(-day).AddMonths(-1).Date;
                            if (DateTime.Compare(dateMax, ShipmentDate) >= 0 && DateTime.Compare(dateMin, ShipmentDate) <= 0)
                                rtn = true;
                        }

                    }

                }
                else if (DateType == "RevokeDate")  //冲红日期限制校验
                {
                    DateTime dateMax = ShipmentDate.AddDays(plAttr.Due2);
                    DateTime dateMin = ShipmentDate;
                    if (DateTime.Compare(dateMax, DateTime.Now) >= 0 && DateTime.Compare(dateMin, DateTime.Now) <= 0)
                    {
                        rtn = true;
                    }
                }
                else if (DateType == "OperationDate") //手术报台日期限制校验
                {
                    DateTime dateMax = ShipmentDate.AddDays(plAttr.Due3);
                    DateTime dateMin = ShipmentDate;
                    if (DateTime.Compare(dateMax, DateTime.Now) >= 0 && DateTime.Compare(dateMin, DateTime.Now) <= 0)
                    {
                        rtn = true;
                    }
                }
                else
                {
                    rtn = false;
                }
            }

            return rtn;
        }

        public CalendarDate GetCalendarDate()
        {
            CalendarDateDao dao = new CalendarDateDao();
            string ym = DateTime.Now.ToString("yyyyMM").Substring(0, 6);
            CalendarDate cd = dao.GetObject(ym);
            return cd;
        }

        public DataTable GetContractDate(Guid dealerId, string productLineID)
        {
            ShipmentHeaderDao dao = new ShipmentHeaderDao();
            Hashtable table = new Hashtable();
            table.Add("DealerId", dealerId);
            table.Add("ProductLineId", productLineID == "" ? null : productLineID);
            DataTable dt = dao.GetContractDate(table).Tables[0];
            return dt;
        }

    }

    public class ProductLineAttribute
    {
        //销售日期限定
        public int Due1
        {
            get;
            set;
        }
        //冲红日期限定
        public int Due2
        {
            get;
            set;
        }
        //手术报台填写期限
        public int Due3
        {
            get;
            set;
        }

    }
}
