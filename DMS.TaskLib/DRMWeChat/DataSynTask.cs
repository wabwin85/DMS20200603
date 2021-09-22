using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Common.Logging;
using Fulper.TaskManager.TaskPlugin;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Data;
using DMS.Business;
using DMS.Model;
using System.Threading;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace DMS.TaskLib.DRMWeChat
{
    public class DataSynTask : ITask
    {
        //private static ILog _log = LogManager.GetLogger(typeof(DataSynTask));
        private IDictionary<string, string> _config = null;
        private DMS.TaskLib.WeChatService.zzcsc client = null;
        string uid = "Admin";
        string pwd = "Sh123456";


        public DataSynTask()
        {
            client = new DMS.TaskLib.WeChatService.zzcsc();
        }

        #region ITask 成员
        public void Execute()
        {

            string ConnectionString = this._config["connectionName"];
            DataTable dtUser = client.GetUserInformation(uid, pwd).Tables[0];
            DataTable dtUserProduct = client.GetUserProduct(uid, pwd).Tables[0];
            DataTable dtFqa = client.GetFQAList(uid, pwd).Tables[0];
            DataTable dtFqaAnnex = client.GetFQAAnnexList(uid, pwd).Tables[0];
            DataTable dtQuestion = client.GetQuestionList(uid, pwd).Tables[0];
            DataTable dtIntegralExchange = client.GetAllApprovedIntegralExchange(uid, pwd).Tables[0];
            DataTable dtAllIntegralExchange = client.GetAllIntegralExchange(uid, pwd).Tables[0];
            //调用接口，更改同步状态
            client.UpdateQuestionDmsToWc(uid, pwd);

            SqlConnection sqlConn = new SqlConnection(ConnectionString);
            SqlCommand cmd = null;

            #region User
            //先清空临时表
            sqlConn.Open();
            cmd = new SqlCommand("", sqlConn);
            cmd.CommandText = "Truncate Table Tmp_DrmUser";
            cmd.ExecuteNonQuery();
            //sqlConn.Close();

            if (dtUser != null && dtUser.Rows.Count > 0)
            {

                SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                bulkCopy.DestinationTableName = "Tmp_DrmUser";
                bulkCopy.BatchSize = dtUser.Rows.Count;
                foreach (DataColumn col in dtUser.Columns)
                {
                    bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);

                }
                try
                {
                    //sqlConn.Open();
                    bulkCopy.WriteToServer(dtUser);
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                finally
                {
                    if (bulkCopy != null)
                    {
                        bulkCopy.Close();
                        bulkCopy = null;
                    }
                    if (sqlConn != null)
                    {
                        sqlConn.Close();
                    }

                }
            }
            else
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }


            #endregion

            #region User Product
            //先清空临时表
            sqlConn.Open();
            cmd = new SqlCommand("", sqlConn);
            cmd.CommandText = "Truncate Table Tmp_DrmUserProduct";
            cmd.ExecuteNonQuery();
            //sqlConn.Close();

            if (dtUserProduct != null && dtUserProduct.Rows.Count > 0)
            {

                SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                bulkCopy.DestinationTableName = "Tmp_DrmUserProduct";
                bulkCopy.BatchSize = dtUserProduct.Rows.Count;
                foreach (DataColumn col in dtUserProduct.Columns)
                {
                    bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);
                }
                try
                {
                    //sqlConn.Open();
                    bulkCopy.WriteToServer(dtUserProduct);
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                finally
                {
                    if (bulkCopy != null)
                    {
                        bulkCopy.Close();
                        bulkCopy = null;
                    }
                    if (sqlConn != null)
                    {
                        sqlConn.Close();
                    }

                }
            }
            else
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }


            #endregion

            #region FQA
            //先清空临时表
            sqlConn.Open();
            cmd = new SqlCommand("", sqlConn);
            cmd.CommandText = "Truncate Table Tmp_DrmFQA";
            cmd.ExecuteNonQuery();
            //sqlConn.Close();

            if (dtFqa != null && dtFqa.Rows.Count > 0)
            {

                SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                bulkCopy.DestinationTableName = "Tmp_DrmFQA";
                bulkCopy.BatchSize = dtFqa.Rows.Count;
                foreach (DataColumn col in dtFqa.Columns)
                {
                    bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);

                }
                try
                {
                    //sqlConn.Open();
                    bulkCopy.WriteToServer(dtFqa);
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                finally
                {
                    if (bulkCopy != null)
                    {
                        bulkCopy.Close();
                        bulkCopy = null;
                    }
                    if (sqlConn != null)
                    {
                        sqlConn.Close();
                    }

                }
            }
            else
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }


            #endregion

            #region FQAAnnex
            //先清空临时表
            sqlConn.Open();
            cmd = new SqlCommand("", sqlConn);
            cmd.CommandText = "Truncate Table Tmp_DrmAnnex";
            cmd.ExecuteNonQuery();
            //sqlConn.Close();

            if (dtFqaAnnex != null && dtFqaAnnex.Rows.Count > 0)
            {

                SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                bulkCopy.DestinationTableName = "Tmp_DrmAnnex";
                bulkCopy.BatchSize = dtFqaAnnex.Rows.Count;
                foreach (DataColumn col in dtFqaAnnex.Columns)
                {
                    bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);

                }
                try
                {
                    //sqlConn.Open();
                    bulkCopy.WriteToServer(dtFqaAnnex);
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                finally
                {
                    if (bulkCopy != null)
                    {
                        bulkCopy.Close();
                        bulkCopy = null;
                    }
                    if (sqlConn != null)
                    {
                        sqlConn.Close();
                    }

                }
            }
            else
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }


            #endregion

            #region Question
            //先清空临时表
            sqlConn.Open();
            cmd = new SqlCommand("", sqlConn);
            cmd.CommandText = "Truncate Table Tmp_DrmQuestion";
            cmd.ExecuteNonQuery();

            if (dtQuestion != null && dtQuestion.Rows.Count > 0)
            {

                SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                bulkCopy.DestinationTableName = "Tmp_DrmQuestion";
                bulkCopy.BatchSize = dtQuestion.Rows.Count;
                foreach (DataColumn col in dtQuestion.Columns)
                {
                    bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);

                }
                try
                {
                    bulkCopy.WriteToServer(dtQuestion);
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                finally
                {
                    if (bulkCopy != null)
                    {
                        bulkCopy.Close();
                        bulkCopy = null;
                    }
                    if (sqlConn != null)
                    {
                        sqlConn.Close();
                    }

                }
            }
            else
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }


            #endregion

            #region Question
            //先清空礼品兑换临时表
            sqlConn.Open();
            cmd = new SqlCommand("", sqlConn);
            cmd.CommandText = "Truncate Table Tmp_IntegralExchange";
            cmd.ExecuteNonQuery();
            //sqlConn.Close();

            if (dtIntegralExchange != null && dtIntegralExchange.Rows.Count > 0)
            {

                SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                bulkCopy.DestinationTableName = "Tmp_IntegralExchange";
                bulkCopy.BatchSize = dtIntegralExchange.Rows.Count;
                foreach (DataColumn col in dtIntegralExchange.Columns)
                {
                    bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);

                }
                try
                {
                    //sqlConn.Open();
                    bulkCopy.WriteToServer(dtIntegralExchange);
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                finally
                {
                    if (bulkCopy != null)
                    {
                        bulkCopy.Close();
                        bulkCopy = null;
                    }
                    if (sqlConn != null)
                    {
                        sqlConn.Close();
                    }

                }
            }
            else
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }


            #endregion

            #region 调用SP同步数据

            //调用SP同步数据
            sqlConn.Open();
            try
            {
                cmd.CommandText = "exec dbo.GC_TransDrmWeChatData '' ";
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }
            #endregion

            #region 微信同步到DMS
            //1.投诉建议同步
            sqlConn.Open();
            try
            {
                string txtId = null;
                string txtWdtId = null;
                string txtWupId = null;
                string txtTitle = null;
                string txtBody = null;
                string txtCreateDate = null;
                string txtUserID = null;
                string txtStatus = null;

                string sql = " SELECT WQA_ID AS ID,WQA_WDT_ID AS WdtId,WQA_WUP_ID AS WupId,WQA_QuestionTitle AS Title,	WQA_QuestionBody AS Body,WQA_CreateDate AS CreateDate ,	WQA_UserID AS  UserID,WQA_Status AS [Status] ";
                sql += " FROM WechatQuestion WHERE WQA_Status='0' AND WQA_WC_DMS ='0' ";

                SqlDataAdapter da = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                da.Fill(ds);

                DataTable dt = ds.Tables[0];
                string msg = "";
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    txtId = dt.Rows[i]["ID"].ToString();
                    txtWdtId = dt.Rows[i]["WdtId"].ToString();
                    txtWupId = dt.Rows[i]["WupId"].ToString();
                    txtTitle = dt.Rows[i]["Title"].ToString();
                    txtBody = dt.Rows[i]["Body"].ToString();
                    txtCreateDate = dt.Rows[i]["CreateDate"].ToString();
                    txtUserID = dt.Rows[i]["UserID"].ToString();
                    txtStatus = dt.Rows[i]["Status"].ToString();
                    msg += client.InsertQuestionWcToDms(uid, pwd, txtId, txtWdtId, txtWupId, txtTitle, txtBody, txtCreateDate, txtUserID, txtStatus);
                }

            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }
            //更改同步状态
            sqlConn.Open();
            try
            {
                cmd.CommandText = "UPDATE WechatQuestion SET WQA_WC_DMS='1' WHERE WQA_Status='0' AND WQA_WC_DMS ='0' ";
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }


            //2.微消息同步
            //2.1 删除原有微消息
            client.DeleteDealerNews(uid, pwd);
            //2.2 删除原有微消息附件
            client.DeleteDealerNewsAnnex(uid, pwd);

            //2.3 微信全量微消息
            sqlConn.Open();
            try
            {
                string txtId = null;
                string txtProductLineID = null;
                string txtTital = null;
                string txtBody = null;
                string txtUserId = null;
                string txtCreateDate = null;


                string sql = " SELECT WRU_ID AS Id,WRU_ProductLineID as ProductLineID,WRU_Tital as Tital , WRU_Body as Body ,WRU_CreateUserId as CreateUserId,WRU_CreateDate as CreateDate  from WechatDealerNews  ";

                SqlDataAdapter da = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                da.Fill(ds);

                DataTable dt = ds.Tables[0];

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    txtId = dt.Rows[i]["Id"].ToString();
                    txtProductLineID = dt.Rows[i]["ProductLineID"].ToString();
                    txtTital = dt.Rows[i]["Tital"].ToString();
                    txtBody = dt.Rows[i]["Body"].ToString();
                    txtUserId = dt.Rows[i]["CreateUserId"].ToString();
                    txtCreateDate = dt.Rows[i]["CreateDate"].ToString();

                    client.InsertDealerNews(uid, pwd, txtId, txtProductLineID, txtTital, txtBody, txtUserId, txtCreateDate);
                }

            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }

            //2.4 微信全量微消息附件
            sqlConn.Open();
            try
            {
                string txtId = null;
                string txtMainId = null;
                string txtName = null;
                string txtUrl = null;
                string txtType = null;
                string txtUploadUser = null;
                string txtUploadDate = null;


                string sql = " SELECT AT_ID AS Id,AT_Main_ID AS MainId,AT_Name AS Name,AT_Url AS Url,	AT_Type AS [Type], AT_UploadUser AS UploadUser,	AT_UploadDate AS UploadDate FROM WechatAttachment WHERE AT_Type='WechatDNews'  ";

                SqlDataAdapter da = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                da.Fill(ds);

                DataTable dt = ds.Tables[0];

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    txtId = dt.Rows[i]["Id"].ToString();
                    txtMainId = dt.Rows[i]["MainId"].ToString();
                    txtName = dt.Rows[i]["Name"].ToString();
                    txtUrl = dt.Rows[i]["Url"].ToString();
                    txtType = dt.Rows[i]["Type"].ToString();
                    txtUploadUser = dt.Rows[i]["UploadUser"].ToString();
                    txtUploadDate = dt.Rows[i]["UploadDate"].ToString();

                    client.InsertDealerNewsAnnex(uid, pwd, txtId, txtMainId, txtName, txtUrl, txtType, txtUploadUser, txtUploadDate);
                }

            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }

            //3.1 更改新功能建议状态
            sqlConn.Open();
            try
            {
                cmd.CommandText = " UPDATE WechatFunctionSuggest SET WFS_Sny_Status=1 WHERE WFS_Sny_Status=0 ";
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }

            //3.2 微信全量微消息附件
            sqlConn.Open();
            try
            {
                string WFS_ID = null;
                string WFS_Body = null;
                string WFS_CreateUserId = null;
                string WFS_CreateDate = null;
                string WFS_Sny_Status = null;


                string sql = " SELECT WFS_ID,WFS_Body,WFS_CreateUserId	,WFS_CreateDate	,WFS_Sny_Status FROM  WechatFunctionSuggest WHERE WFS_Sny_Status=1  ";

                SqlDataAdapter da = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                da.Fill(ds);

                DataTable dt = ds.Tables[0];

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    WFS_ID = dt.Rows[i]["WFS_ID"].ToString();
                    WFS_Body = dt.Rows[i]["WFS_Body"].ToString();
                    WFS_CreateUserId = dt.Rows[i]["WFS_CreateUserId"].ToString();
                    WFS_CreateDate = dt.Rows[i]["WFS_CreateDate"].ToString();
                    WFS_Sny_Status = dt.Rows[i]["WFS_Sny_Status"].ToString();

                    client.InsertFunctionSuggest(uid, pwd, WFS_ID, WFS_Body, WFS_CreateUserId, WFS_CreateDate, WFS_Sny_Status);
                }
            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }

            //3.3 更改新功能建议状态
            sqlConn.Open();
            try
            {
                cmd.CommandText = " UPDATE WechatFunctionSuggest SET WFS_Sny_Status=2 WHERE WFS_Sny_Status=1 ";
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }


            //4.礼品兑换信息
            sqlConn.Open();
            try
            {
                string txtId = null;
                string txtUserId = null;
                string txtGiftId = null;
                string txtExchangenumber = null;
                string txtStatus = null;
                string txtDocumentnumber = null;
                string txtDeliverNumber = null;
                string txtReturnIntegral = null;
                string txtTypes = null;
                string txtData = null;
                string txtGiftName = null;

                string sql = @" SELECT ID AS Id,UserId AS UserId,GiftId AS GiftId,Exchangenumber AS Exchangenumber,Documentnumber AS Documentnumber,Status AS Status,DeliverNumber AS DeliverNumber,ReturnIntegral AS ReturnIntegral,Types AS Types,data AS Data,GiftName AS GiftName FROM IntegralExchange where status='Submitted'";

                SqlDataAdapter da = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                da.Fill(ds);

                DataTable dt = ds.Tables[0];
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    txtId = dt.Rows[i]["ID"].ToString();
                    txtUserId = dt.Rows[i]["UserID"].ToString();
                    txtStatus = dt.Rows[i]["Status"].ToString();
                    txtGiftId = dt.Rows[i]["GiftId"].ToString();
                    txtExchangenumber = dt.Rows[i]["Exchangenumber"].ToString();
                    txtDocumentnumber = dt.Rows[i]["Documentnumber"].ToString();
                    txtDeliverNumber = dt.Rows[i]["DeliverNumber"].ToString();
                    txtReturnIntegral = dt.Rows[i]["ReturnIntegral"].ToString();
                    txtTypes = dt.Rows[i]["Types"].ToString();
                    txtData = dt.Rows[i]["Data"].ToString();
                    txtGiftName = dt.Rows[i]["GiftName"].ToString();

                    bool IsExist = false;
                    for (int j = 0; j < dtAllIntegralExchange.Rows.Count; j++)
                    {
                        string Id = dtAllIntegralExchange.Rows[j]["Id"].ToString();
                        if (txtId == Id)
                        {
                            IsExist = true;
                        }

                    }

                    if (!IsExist)
                    {
                        client.InsertIntegralExchangeToDms(uid, pwd, txtId, txtUserId, txtStatus, txtGiftId,
                           txtExchangenumber, txtDocumentnumber, txtDeliverNumber, txtReturnIntegral, txtTypes, txtData, txtGiftName);
                    }
                }

            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }


            //5.更新微信用户OpenId
            sqlConn.Open();
            try
            {
                string txtUserId = null;
                string txtWechatCode = null;
                string textBindDate = null;
                string textNickName = null;


                string sql = @"SELECT BWU_ID ID,BWU_WeChat WeChat,BWU_BindDate  BindDate, BWU_NickName NickName FROM BusinessWechatUser WHERE BWU_WeChat IS NOT NULL AND BWU_BindDate IS NOT NULL";

                SqlDataAdapter da = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                da.Fill(ds);

                DataTable dt = ds.Tables[0];
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    txtUserId = dt.Rows[i]["ID"].ToString();
                    txtWechatCode = dt.Rows[i]["WeChat"].ToString();
                    textBindDate = dt.Rows[i]["BindDate"].ToString();
                    textNickName = dt.Rows[i]["NickName"].ToString();

                    client.UpdateWechatUserOpenId(uid, pwd, txtUserId, txtWechatCode, textBindDate, textNickName);
                }

            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }

            ////更改同步状态
            //sqlConn.Open();
            //try
            //{
            //    cmd.CommandText = "Update IntegralExchange set DeliverNumber=1 where status='Submitted' and isnull(DeliverNumber,0)<>1";
            //    cmd.ExecuteNonQuery();
            //}
            //catch (Exception ex1)
            //{
            //    throw ex1;
            //}
            //finally
            //{
            //    if (sqlConn != null)
            //    {
            //        sqlConn.Close();
            //    }

            //}
            #endregion


            #region
            // 删除DMS中的微信操作日志 Added by Hxw
            client.DeleteAllWechatOperatLog(uid, pwd);

            // 微信操作日志全量同步到DMS Added by Hxw
            sqlConn.Open();
            try
            {
                string txtId = null;
                string txtBwuId = null;
                string txtOperatTime = null;
                string txtOperatMenu = null;
                string txtRv1 = null;


                string sql = @"SELECT WOL_ID AS Id,WOL_BWU_ID AS BwuId,WOL_OperatTime AS OperatTime,WOL_OperatMenu AS OperatMenu,WOL_RV1 AS Rv1 FROM WechatOperatLog ";

                SqlDataAdapter da = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                da.Fill(ds);

                DataTable dt = ds.Tables[0];

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    txtId = dt.Rows[i]["Id"].ToString();
                    txtBwuId = dt.Rows[i]["BwuId"].ToString();
                    txtOperatTime = dt.Rows[i]["OperatTime"].ToString();
                    txtOperatMenu = dt.Rows[i]["OperatMenu"].ToString();
                    txtRv1 = dt.Rows[i]["Rv1"].ToString();

                    client.InsertWechatLog(uid, pwd, txtId, txtBwuId,txtOperatTime,txtOperatMenu,txtRv1);
                }

            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }

            #endregion

        }



        #endregion

        #region ITask 成员

        public Dictionary<string, string> Config
        {
            set
            {
                this._config = value;
                //_log.Info("TransDataTask Config : Count = " + this._config.Count);
            }
        }

     
           

    
        #endregion

    }
}
