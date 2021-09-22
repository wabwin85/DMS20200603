
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : HospitalReportUser
 * Created Time: 2013/11/25 12:16:25
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// HospitalReportUser的Dao
    /// </summary>
    public class HospitalReportUserDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public HospitalReportUserDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public HospitalReportUser GetObject(Guid objKey)
        {
            HospitalReportUser obj = this.ExecuteQueryForObject<HospitalReportUser>("SelectHospitalReportUser", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<HospitalReportUser> GetAll()
        {
            IList<HospitalReportUser> list = this.ExecuteQueryForList<HospitalReportUser>("SelectHospitalReportUser", null);          
            return list;
        }


        /// <summary>
        /// 查询HospitalReportUser
        /// </summary>
        /// <returns>返回HospitalReportUser集合</returns>
		public IList<HospitalReportUser> SelectByFilter(HospitalReportUser obj)
		{ 
			IList<HospitalReportUser> list = this.ExecuteQueryForList<HospitalReportUser>("SelectByFilterHospitalReportUser", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(HospitalReportUser obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateHospitalReportUser", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteHospitalReportUser", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(HospitalReportUser obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteHospitalReportUser", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(HospitalReportUser obj)
        {
            this.ExecuteInsert("InsertHospitalReportUser", obj);           
        }


        /// <summary>
        /// 查询HospitalReportUser
        /// </summary>
        /// <returns>返回HospitalReportUser集合</returns>
        public IList<HospitalReportUser> QueryByFilter(Hashtable table)
        {
            IList<HospitalReportUser> list = this.ExecuteQueryForList<HospitalReportUser>("QueryByFilterHospitalReportUser", table);
            return list;
        } 

        
        /// <summary>
        /// 绑定微信号
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int BindingWeChatByMobile(HospitalReportUser obj)
        {
            int cnt = (int)this.ExecuteUpdate("BindingWeChatByMobile", obj);            
            return cnt;
        }

        /// <summary>
        /// 校验产品信息是否正确
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int CheckProductInfo(Hashtable table)
        {
            int ResultValue = 0;

            table.Add("ResultValue", ResultValue);

            this.ExecuteInsert("GC_CheckProductInfo", table);

            ResultValue = Convert.ToInt32(table["ResultValue"].ToString());

            return ResultValue;
        }
        
        /// <summary>
        /// 校验产品信息是否正确
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int CheckCfnWeChatBySpec(Hashtable table)
        {
            int ResultValue = 0;

            table.Add("ResultValue", ResultValue);

            this.ExecuteInsert("GC_CheckCfnWeChatBySpec", table);

            ResultValue = Convert.ToInt32(table["ResultValue"].ToString());

            return ResultValue;
        }
        
        /// <summary>
        /// 查询HospitalReportUser
        /// </summary>
        /// <returns>返回HospitalReportUser集合</returns>
        public DataSet QueryHospitalReportUserByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryHospitalReportUserByFilter", table);
            return ds;
        }

        /// <summary>
        /// 校验手机号是否已经存在
        /// </summary>
        /// <returns>返回HospitalReportUser集合</returns>
        public IList<HospitalReportUser> CheckUserPhoneExist(Hashtable table)
        {
            IList<HospitalReportUser> list = this.ExecuteQueryForList<HospitalReportUser>("CheckUserPhoneExist", table);
            return list;
        } 

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateHospitalReportUserByFilter(HospitalReportUser obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateHospitalReportUserByFilter", obj);            
            return cnt;
        }
        
    }
}