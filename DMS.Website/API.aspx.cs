using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using System.Web.Security;

namespace DMS.Website
{
    public partial class API : BasePage
    {
        private String needAuth;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.hidPageId.Value = this.Request.QueryString["PageId"];
                this.hidContractType.Value = this.Request.QueryString["ContractType"];
                needAuth = this.Request.QueryString["NeedAuth"];
                PageRedirection();
            }
        }

        private void Auth()
        {
            if (String.IsNullOrEmpty(needAuth) || needAuth == "True")
            {
                FormsAuthentication.SetAuthCookie("API", false);
            }
        }

        private void PageRedirection()
        {
            string url = "";

            #region  DCMS
            //ContractTerritoryEditor.aspx
            if (this.hidPageId.Value.Equals("1"))
            {
                Auth();
                if (this.Request.QueryString["IsArea"] != null && this.Request.QueryString["IsArea"].ToString().Equals("1"))
                {
                    url = "/Pages/Contract/ContractTerritoryAreaEditorV2.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                     + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                     + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                     + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                     + "&ContractType=" + this.Request.QueryString["ContractType"]
                     + "&ProductAmend=" + this.Request.QueryString["ProductAmend"]
                     + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                     + "&OperationType=Modify";
                }
                else
                {
                    url = "/Pages/Contract/ContractTerritoryEditor.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                        + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                        + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                        + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                        + "&ContractType=" + this.Request.QueryString["ContractType"]
                        + "&ProductAmend=" + this.Request.QueryString["ProductAmend"]
                        + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                        + "&OperationType=Modify";
                }

                this.Response.Redirect(url);
            }

            //ContractTerritoryQuery.aspx
            if (this.hidPageId.Value.Equals("2"))
            {
                Auth();
                if (this.Request.QueryString["IsArea"] != null && this.Request.QueryString["IsArea"].ToString().Equals("1"))
                {
                    url = "/Pages/Contract/ContractTerritoryAreaQuery.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                      + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                      + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                      + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                      + "&ContractType=" + this.Request.QueryString["ContractType"]
                         + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                      + "&OperationType=Query";
                }
                else
                {
                    url = "/Pages/Contract/ContractTerritoryEditor.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                        + "&DivisionID=" + this.Request.QueryString["DivisionID"]
                        + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                        + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"]
                        + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                        + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                        + "&ContractType=" + this.Request.QueryString["ContractType"]
                        + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                        + "&OperationType=Query";
                }
                this.Response.Redirect(url);
            }

            //ContractAOPListV2.aspx
            if (this.hidPageId.Value.Equals("3"))
            {
                Auth();

                if (this.Request.QueryString["DealerType"].ToString().Equals("LP")  || this.Request.QueryString["DealerType"].ToString().Equals("LS") || this.Request.QueryString["AOPType"].ToString().Equals("Month"))
                {
                    url = "/Pages/Contract/ContractDealerAOPList.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                       + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                       + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                       + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                       + "&ContractType=" + this.Request.QueryString["ContractType"]
                       + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                       + "&OperationType=Modify";
                }
                else
                {
                    if (this.hidContractType.Value.Equals("Appointment") || this.hidContractType.Value.Equals("Renewal"))
                    {
                        if (this.Request.QueryString["AOPType"].ToString().Equals("Unit"))
                        {
                            url = "/Pages/Contract/ContractDealerHospitalAOPUnitList.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                                + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                                + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                                + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                                + "&ContractType=" + this.Request.QueryString["ContractType"]
                                + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                                + "&OperationType=Modify";
                        }
                        else
                        {
                            url = "/Pages/Contract/ContractDealerHospitalAOPList.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                                  + "&DivisionID=" + this.Request.QueryString["DivisionID"]
                                  + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                                  + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"]
                                  + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                                  + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                                  + "&ContractType=" + this.Request.QueryString["ContractType"]
                                  + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                                  + "&OperationType=Modify";
                        }
                    }
                    else
                    {

                        if (this.Request.QueryString["AOPType"].ToString().Equals("Unit"))
                        {
                            url = "/Pages/Contract/ContractDealerHospitalAOPUnitListAmendment.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                              + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                              + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                              + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                              + "&ContractType=" + this.Request.QueryString["ContractType"]
                              + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                              + "&OperationType=Modify";
                        }
                        else
                        {
                            url = "/Pages/Contract/ContractDealerHospitalAOPListAmendment.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                                + "&DivisionID=" + this.Request.QueryString["DivisionID"]
                                + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                                + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"]
                                + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                                + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                                + "&ContractType=" + this.Request.QueryString["ContractType"]
                                + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                                + "&OperationType=Modify";
                        }
                    }
                }
                this.Response.Redirect(url);
            }

            //ContractDealerAOPQuery.aspx
            if (this.hidPageId.Value.Equals("4"))
            {
                Auth();
                if (this.Request.QueryString["DealerType"] == null || this.Request.QueryString["DealerType"].ToString().Equals("LP")  || this.Request.QueryString["AOPType"].ToString().Equals("Month"))
                {
                    url = "/Pages/Contract/ContractDealerAOPQuery.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                        + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                        + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                        + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                        + "&ContractType=" + this.Request.QueryString["ContractType"]
                        + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"];
                }
                else
                {
                    if (this.hidContractType.Value.Equals("Appointment") || this.hidContractType.Value.Equals("Renewal"))
                    {
                        if (this.Request.QueryString["AOPType"].ToString().Equals("Unit"))
                        {
                            url = "/Pages/Contract/ContractDealerHospitalAOPUnitList.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                                + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                                + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                                + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                                + "&ContractType=" + this.Request.QueryString["ContractType"]
                                + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                                + "&OperationType=Query";
                        }
                        else
                        {
                            url = "/Pages/Contract/ContractDealerHospitalAOPList.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                                + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                                + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                                + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                                + "&ContractType=" + this.Request.QueryString["ContractType"]
                                + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                                + "&OperationType=Query";
                        }
                    }
                    else
                    {

                        if (this.Request.QueryString["AOPType"].ToString().Equals("Unit"))
                        {
                            url = "/Pages/Contract/ContractDealerHospitalAOPUnitListAmendment.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                              + "&DivisionID=" + this.Request.QueryString["DivisionID"] + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                              + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"] + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                              + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                              + "&ContractType=" + this.Request.QueryString["ContractType"]
                              + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                              + "&OperationType=Query";
                        }
                        else
                        {
                            url = "/Pages/Contract/ContractDealerHospitalAOPListAmendment.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                                + "&DivisionID=" + this.Request.QueryString["DivisionID"]
                                + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                                + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"]
                                + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                                + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                                + "&ContractType=" + this.Request.QueryString["ContractType"]
                                + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                                + "&OperationType=Query";
                        }
                    }
                }
                this.Response.Redirect(url);
            }

            //FormalTerritory.aspx
            if (this.hidPageId.Value.Equals("9"))
            {
                Auth();
                url = "/Pages/Contract/FormalTerritory.aspx?DivisionID=" + this.Request.QueryString["DivisionID"]
                    + "&DealerID=" + this.Request.QueryString["DealerID"]
                    + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                    + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                    + "&InstanceID=" + this.Request.QueryString["InstanceID"];

                this.Response.Redirect(url);
            }

            //FormalTerritoryArea.aspx
            if (this.hidPageId.Value.Equals("10"))
            {
                Auth();
                url = "/Pages/Contract/FormalTerritoryArea.aspx?DivisionID=" + this.Request.QueryString["DivisionID"]
                    + "&DealerID=" + this.Request.QueryString["DealerID"]
                    + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                    + "&InstanceID=" + this.Request.QueryString["InstanceID"];

                this.Response.Redirect(url);
            }

            //FormalDealerHospitalAOP.aspx
            if (this.hidPageId.Value.Equals("11"))
            {
                Auth();
                if (this.Request.QueryString["DealerType"].ToString().Equals("LP"))
                {
                    url = "/Pages/Contract/FormalDealerAOP.aspx?DivisionID=" + this.Request.QueryString["DivisionID"]
                            + "&DealerID=" + this.Request.QueryString["DealerID"]
                            + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                            + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                            + "&InstanceID=" + this.Request.QueryString["InstanceID"]
                            + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"]
                            + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"];
                }
                else
                {
                    if (this.Request.QueryString["AOPType"].ToString().Equals("Unit"))
                    {
                        url = "/Pages/Contract/FormalDealerHospitalProductAOP.aspx?DivisionID=" + this.Request.QueryString["DivisionID"]
                            + "&DealerID=" + this.Request.QueryString["DealerID"]
                            + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                            + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                            + "&InstanceID=" + this.Request.QueryString["InstanceID"]
                            + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"]
                            + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"];
                    }
                    else
                    {
                        url = "/Pages/Contract/FormalDealerHospitalAOP.aspx?DivisionID=" + this.Request.QueryString["DivisionID"]
                            + "&DealerID=" + this.Request.QueryString["DealerID"]
                            + "&PartsContractCode=" + this.Request.QueryString["PartsContractCode"]
                            + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                            + "&InstanceID=" + this.Request.QueryString["InstanceID"]
                            + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"]
                            + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"];
                    }
                }
                this.Response.Redirect(url);
            }

            //适用于蓝海市场
            if (this.hidPageId.Value.Equals("13"))
            {
                Auth();
                url = "/Pages/Contract/ContractAOPEquipmentList.aspx?InstanceID=" + this.Request.QueryString["InstanceID"]
                    + "&DivisionID=" + this.Request.QueryString["DivisionID"]
                    + "&TempDealerID=" + this.Request.QueryString["TempDealerID"]
                    + "&EffectiveDate=" + this.Request.QueryString["EffectiveDate"]
                    + "&ExpirationDate=" + this.Request.QueryString["ExpirationDate"]
                    + "&IsChange=" + this.Request.QueryString["IsChange"]
                    + "&IsEmerging=" + this.Request.QueryString["IsEmerging"]
                    + "&ContractType=" + this.Request.QueryString["ContractType"];
                this.Response.Redirect(url);
            }


            #endregion

            #region EndoScoreCard
            if (this.hidPageId.Value.Equals("20"))
            {
                Auth();
                url = "/Pages/ScoreCard/EndoScoreCardAttachment.aspx?InstanceID=" + this.Request.QueryString["ESCId"];
                this.Response.Redirect(url);
            }
            #endregion

            #region RedeemGift
            if (this.hidPageId.Value.Equals("30"))
            {
                Auth();
                url = "/Pages/WeChat/RedeemGift.aspx";
                this.Response.Redirect(url);
            }
            #endregion

            #region PromotionDealer
            if (this.hidPageId.Value.Equals("50"))
            {
                Auth();
                url = "/Pages/Order/ImportSAPCode.aspx";
                this.Response.Redirect(url);
            }
            #endregion

            #region Promotion Attachment
            if (this.hidPageId.Value.Equals("60"))
            {
                Auth();
                url = "/Pages/Promotion/PolicyAttachment.aspx?InstanceID=" + this.Request.QueryString["InstanceID"];
                this.Response.Redirect(url);
            }
            #endregion

            #region Promotion Attachment
            if (this.hidPageId.Value.Equals("70"))
            {
                Auth();
                url = "/Pages/Promotion/PolicyAttachment.aspx?InstanceID=" + this.Request.QueryString["InstanceID"] + "&Type=Gift";
                this.Response.Redirect(url);
            }

            if (this.hidPageId.Value.Equals("80"))
            {
                Auth();
                url = "/Pages/Promotion/PolicyAttachment.aspx?InstanceID=" + this.Request.QueryString["InstanceID"] + "&Type=GiftInit";
                this.Response.Redirect(url);
            }
            #endregion

        }
    }
}
