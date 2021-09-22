using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.HCPPassport
{
    public class DealerAccountDao : BaseSqlMapDao
    {
        public DealerAccountDao()
            : base()
        {
        }


        public void InsertIDENTITY(Guid ID,string Name, string Phone, string Email)
        {
            Hashtable IDENTITY = new Hashtable();
            string IDENTITY_CODE = "";
            DataTable tb = SelectIDENTITYCODE();
            if (tb.Rows.Count > 0)
            {
                if (tb.Rows[0]["IDENTITY_CODE"].ToString()!="") {
                    IDENTITY_CODE = tb.Rows[0]["SAPCODE"].ToString() + "_" + (Convert.ToInt32(tb.Rows[0]["IDENTITY_CODE"].ToString()) + 1);
                }
                else
                {
                    IDENTITY_CODE = tb.Rows[0]["SAPCODE"].ToString() + "_101";
                }

            }
            
            IDENTITY.Add("ID", ID);
            IDENTITY.Add("Name", Name);
            IDENTITY.Add("Phone", Phone);
            IDENTITY.Add("Email", Email);
            IDENTITY.Add("CorpID", RoleModelContext.Current.User.CorpId);
            IDENTITY.Add("CreateUser", RoleModelContext.Current.User.Id);


            IDENTITY.Add("IDENTITY_CODE", IDENTITY_CODE);
            IDENTITY.Add("LOWERED_IDENTITY_CODE", IDENTITY_CODE);

            this.ExecuteInsert("HCPPassport.DealerAccount.InsertIDENTITY", IDENTITY);
        }

        public DataTable SelectIDENTITYCODE()
        {
            Hashtable tb = new Hashtable();
            tb.Add("DMA_ID", RoleModelContext.Current.User.CorpId);

            return this.ExecuteQueryForDataSet("HCPPassport.DealerAccount.SelectIDENTITYCODE", tb).Tables[0];

        }




        public void InsertIDENTITYMAP(Guid ID, string Roles)
        {

            Hashtable IDENTITY_MAP = new Hashtable();
            IDENTITY_MAP.Add("Roles", Roles);
            IDENTITY_MAP.Add("ID", ID);
            IDENTITY_MAP.Add("CreateUser", RoleModelContext.Current.User.UserName);
            this.ExecuteInsert("HCPPassport.DealerAccount.InsertIDENTITYMAP", IDENTITY_MAP);

        }


        public void InsertMembership(Guid ID)
        {
            Hashtable Insert_Membership = new Hashtable();
            Insert_Membership.Add("ID", ID);
            this.ExecuteInsert("HCPPassport.DealerAccount.InsertMembership", Insert_Membership);

        }

        public DataSet SelectByAccount(string Account)
        {
            Hashtable tb = new Hashtable();
            tb.Add("Account", Account);
            return this.ExecuteQueryForDataSet("Login.SelectUserByPhone", tb);
        }

        public void UpdateIDENTITY(Guid ID,bool FLAG)
        {

            Hashtable IDENTITY = new Hashtable();
            IDENTITY.Add("ID", ID);

            if (FLAG)
            {
                IDENTITY.Add("BOOLEAN_FLAG", 1);
                IDENTITY.Add("DELETE_FLAG", 0);
            }
            else
            {
                IDENTITY.Add("BOOLEAN_FLAG", 0);
                IDENTITY.Add("DELETE_FLAG", 1);
            }

            IDENTITY.Add("CorpID", RoleModelContext.Current.User.CorpId);
            IDENTITY.Add("CreateUser", RoleModelContext.Current.User.Id);
            this.ExecuteUpdate("HCPPassport.DealerAccount.UpdateIDENTITY", IDENTITY);

        }

        public int DeleteIDENTITYMAP(string ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ID", ID);
            int cnt = (int)this.ExecuteDelete("HCPPassport.DealerAccount.DeleteIDENTITYMAP", tb);
            return cnt;
        }




        public DataTable SelectRoles(string CorpType)
        {
            Hashtable tb = new Hashtable();
            tb.Add("DESCRIPTION", CorpType);

            return this.ExecuteQueryForDataSet("HCPPassport.DealerAccount.SelectRoles", tb).Tables[0];

        }


        public DataTable SelectIDENTITYList(string Name,string Phone,string Email)
        {
            Hashtable tb = new Hashtable();
            tb.Add("Name", Name);
            tb.Add("Phone", Phone);
            tb.Add("Email", Email);
            tb.Add("CorpID", RoleModelContext.Current.User.CorpId);

            DataTable ds = this.ExecuteQueryForDataSet("HCPPassport.DealerAccount.SelectIDENTITYList", tb).Tables[0];
            return ds;
        }

        public DataTable SelectIDENTITYInfoList(string ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ID", ID);

            DataTable ds = this.ExecuteQueryForDataSet("HCPPassport.DealerAccount.SelectIDENTITYInfoList", tb).Tables[0];
            return ds;
        }

        public DataTable SelectIDENTITYMAPInfo(string ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ID", ID);

            DataTable ds = this.ExecuteQueryForDataSet("HCPPassport.DealerAccount.SelectIDENTITYMAPInfo", tb).Tables[0];
            return ds;
        }



        public void SaveHome(String Phone,String Email)
        {

            Hashtable IDENTITY = new Hashtable();
            IDENTITY.Add("Phone", Phone);
            IDENTITY.Add("Email", Email);
            IDENTITY.Add("ID", RoleModelContext.Current.User.Id);

            this.ExecuteUpdate("HCPPassport.DealerAccount.SaveHome", IDENTITY);

        }


        public DataTable SelectPhoneEmail(string ID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("ID", ID);

            DataTable ds = this.ExecuteQueryForDataSet("HCPPassport.DealerAccount.SelectPhoneEmail", tb).Tables[0];
            return ds;
        }



    }
}
