using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using DMS.DataAccess;
    using System.Data;
    using System.Collections;
    using Grapecity.DataAccess.Transaction;

    public class ContractCommonBLL : IContractCommonBLL
    {
        public IList<ClassificationContract> GetPartContractIdByCCCode(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetPartContractIdByCCCode(obj);
            }
        }
        public string CheckSubBUType(string subBUCode)
        {
            string subType = "";
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                DataTable getdate = dao.GetSubBUbyCode(subBUCode).Tables[0];
                if (getdate.Rows.Count > 0)
                {
                    subType = getdate.Rows[0]["Rv3"] != null ? getdate.Rows[0]["Rv3"].ToString() : "";
                }
            }
            return subType;
        }

        public DataSet GetPartContractIdByProductId(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetPartContractIdByProductId(obj);
            }
        }

        public IList<ClassificationAuthorization> GetPartsAuthorization(string partsContractId)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetPartsAuthorization(partsContractId);
            }
        }

        public DataSet GetPartsAuthorizedTemp(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetPartsAuthorizedTemp(obj);
            }
        }

        public DataSet GetPartAuthorizationHospitalTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetPartAuthorizationHospitalTemp(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet GetPartAuthorizationHospitalTempNoBR(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetPartAuthorizationHospitalTempNoBR(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet GetPartAuthorizationHospitalTempP(Hashtable obj, int start, int limit)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                obj.Add("start", start);
                obj.Add("limit", limit);
                return dao.GetPartAuthorizationHospitalTempP(obj);
            }
        }

        public void RemoveAuthorizationTemp(string contractId, Guid[] changes)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                ContractCommonDao dao = new ContractCommonDao();

                foreach (Guid item in changes)
                {
                    dao.RemoveAuthorizationTemp(contractId, item);
                }
                trans.Complete();
            }
        }

        public void ModifyPartsAuthorizationTemp(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                dao.ModifyPartsAuthorizationTemp(obj);

            }
        }

        public void SysFormalAuthorizationToTemp(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                dao.SysFormalAuthorizationToTemp(obj);

            }
        }

        public void UpdateContractTerritoryDepartment(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                dao.UpdateContractTerritoryDepartment(obj);
            }
        }

        public void SynchronousAOPToTempUnit(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                dao.SynchronousAOPToTempUnit(obj);
            }
        }

        public void SynchronousAOPToTempAmount(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                dao.SynchronousAOPToTempAmount(obj);
            }
        }

        public void ResetAopAmount(Hashtable objHos, Hashtable objDealer, string contractId)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                ContractCommonDao dao = new ContractCommonDao();
                AopRemarkDao remarkdao = new AopRemarkDao();
                AopRemark rem = new AopRemark();
                rem.Contractid = new Guid(contractId);
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", contractId);
                dao.DeleteDealerTempAop(obj);
                dao.DeleteHospitalAmountTempAop(obj);
                remarkdao.DeleteAopRemark(rem);

                dao.SynchronousAOPToTempAmount(objHos);
                dao.MaintainDealerAOPByHospitalAOP(objDealer);

                trans.Complete();
            }
        }

        public DataSet GetClassificationQuotaTempByContractId(string obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetClassificationQuotaTempByContractId(obj);
            }
        }

        public DataSet GetQuotaPriceTempByContractId(string obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetQuotaPriceTempByContractId(obj);
            }
        }

        public DataSet GetAllQuotaPriceForTemp(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetAllQuotaPriceForTemp(obj);
            }
        }

        public void MaintainDealerAOPByHospitalAOP(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                dao.MaintainDealerAOPByHospitalAOP(obj);
            }
        }

        public DataSet QueryHospitalProductAOPTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalProductAOPTemp(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryHospitalProductAOPTemp2(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalProductAOPTemp2(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryHospitalProductAOPTemp(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalProductAOPTemp(obj);
            }
        }

        public DataSet QueryHospitalProductAmountTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalProductAmountTemp(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryHospitalProductAmountTemp2(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalProductAmountTemp2(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryHospitalProductAmountTemp(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalProductAmountTemp(obj);
            }
        }

        public DataSet QueryHospitalProductAmountAmendmentTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalProductAmountAmendmentTemp(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet GetHospitalProductAmountTemp(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetHospitalProductAmountTemp(obj);
            }
        }

        public DataSet QueryAopDealerUnionHospitalAmount(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryAopDealerUnionHospitalAmount(obj);
            }
        }

        public DataSet GetAopDealerUnionHospitalUnitHistoryQuery(Hashtable obj)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                return dao.GetAopDealerUnionHospitalUnitHistoryQuery(obj);
            }
        }


        public bool SaveHospitalProductAOPUnit(Guid ContractId, string PartsContractCode, VAopICDealerHospital aopDealers, int month)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", ContractId);
                    obj.Add("DealerDmaId", aopDealers.DmaId);
                    obj.Add("ProductLineBumId", aopDealers.ProductLineId);
                    obj.Add("Year", aopDealers.Year);
                    obj.Add("HospitalId", aopDealers.HospitalId);
                    obj.Add("Classification", aopDealers.PctId);
                    int cnt = dao.Delete(obj);

                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "01", aopDealers.Unit1));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "02", aopDealers.Unit2));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "03", aopDealers.Unit3));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "04", aopDealers.Unit4));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "05", aopDealers.Unit5));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "06", aopDealers.Unit6));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "07", aopDealers.Unit7));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "08", aopDealers.Unit8));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "09", aopDealers.Unit9));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "10", aopDealers.Unit10));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "11", aopDealers.Unit11));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "12", aopDealers.Unit12));

                    //更新经销商指标列表
                    using (AopDealerTempDao daoDealerAopTemp = new AopDealerTempDao())
                    {
                        Hashtable objDealer = new Hashtable();
                        objDealer.Add("ContractId", ContractId);
                        objDealer.Add("DealerDmaId", aopDealers.DmaId);
                        objDealer.Add("ContractCode", PartsContractCode);
                        objDealer.Add("ProductLineBumId", aopDealers.ProductLineId);
                        objDealer.Add("Year", aopDealers.Year);
                        objDealer.Add("MarketType", aopDealers.MarketType);
                        objDealer.Add("MinMonth", month);
                        daoDealerAopTemp.Delete(objDealer);

                        daoDealerAopTemp.InsertAopDealerTempByHospitalProduct(objDealer);
                    }


                }
                trans.Complete();
                result = true;
            }

            return result;
        }
        public bool SaveHospitalProductAOPAmount(Guid ContractId, string PartsContractCode, VAopDealerHospitalTemp aopHospital, int month)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", ContractId);
                    obj.Add("DealerDmaId", aopHospital.DealerDmaId);
                    obj.Add("ProductLineBumId", aopHospital.ProductLineBumId);
                    obj.Add("Year", aopHospital.Year);
                    obj.Add("HospitalId", aopHospital.HospitalId);
                    obj.Add("PctId", aopHospital.PctId);

                    int cnt = dao.Delete(obj);

                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "01", aopHospital.Amount1));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "02", aopHospital.Amount2));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "03", aopHospital.Amount3));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "04", aopHospital.Amount4));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "05", aopHospital.Amount5));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "06", aopHospital.Amount6));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "07", aopHospital.Amount7));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "08", aopHospital.Amount8));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "09", aopHospital.Amount9));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "10", aopHospital.Amount10));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "11", aopHospital.Amount11));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "12", aopHospital.Amount12));

                    //更新经销商指标列表
                    using (AopDealerTempDao daoDealerAopTemp = new AopDealerTempDao())
                    {
                        Hashtable objDealer = new Hashtable();
                        objDealer.Add("ContractId", ContractId);
                        objDealer.Add("DealerDmaId", aopHospital.DealerDmaId);
                        objDealer.Add("ContractCode", PartsContractCode);
                        objDealer.Add("ProductLineBumId", aopHospital.ProductLineBumId);
                        objDealer.Add("Year", aopHospital.Year);
                        objDealer.Add("MarketType", aopHospital.MarketType);
                        objDealer.Add("MinMonth", month);
                        daoDealerAopTemp.Delete(objDealer);

                        daoDealerAopTemp.InsertAopDealerTempByHospitalProductAmount(objDealer);
                    }


                }
                trans.Complete();
                result = true;
            }

            return result;
        }

        public VAopDealer QueryDealerAOPAndHospitalAOPUnitTemp(Hashtable obj)
        {
            VAopDealer yearAopDealer = new VAopDealer();
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                DataTable dt = dao.QueryDealerAOPAndHospitalAOPUnitTemp(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    yearAopDealer.DealerDmaId = new Guid(dt.Rows[0]["Dealer_DMA_ID"].ToString());
                    yearAopDealer.ProductLineBumId = new Guid(dt.Rows[0]["ProductLine_BUM_ID"].ToString());
                    yearAopDealer.Year = dt.Rows[0]["Year"].ToString();
                    yearAopDealer.Amount1 = double.Parse(dt.Rows[0]["Amount_1"].ToString());
                    yearAopDealer.Amount2 = double.Parse(dt.Rows[0]["Amount_2"].ToString());
                    yearAopDealer.Amount3 = double.Parse(dt.Rows[0]["Amount_3"].ToString());
                    yearAopDealer.Amount4 = double.Parse(dt.Rows[0]["Amount_4"].ToString());
                    yearAopDealer.Amount5 = double.Parse(dt.Rows[0]["Amount_5"].ToString());
                    yearAopDealer.Amount6 = double.Parse(dt.Rows[0]["Amount_6"].ToString());
                    yearAopDealer.Amount7 = double.Parse(dt.Rows[0]["Amount_7"].ToString());
                    yearAopDealer.Amount8 = double.Parse(dt.Rows[0]["Amount_8"].ToString());
                    yearAopDealer.Amount9 = double.Parse(dt.Rows[0]["Amount_9"].ToString());
                    yearAopDealer.Amount10 = double.Parse(dt.Rows[0]["Amount_10"].ToString());
                    yearAopDealer.Amount11 = double.Parse(dt.Rows[0]["Amount_11"].ToString());
                    yearAopDealer.Amount12 = double.Parse(dt.Rows[0]["Amount_12"].ToString());
                    yearAopDealer.AmountY = double.Parse(dt.Rows[0]["Amount_Y"].ToString());
                    yearAopDealer.RmkBody = dt.Rows[0]["RmkBody"].ToString();

                    yearAopDealer.FormalAmount1 = double.Parse((dt.Rows[0]["FormalAmount_1"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_1"].ToString()));
                    yearAopDealer.FormalAmount2 = double.Parse((dt.Rows[0]["FormalAmount_2"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_2"].ToString()));
                    yearAopDealer.FormalAmount3 = double.Parse((dt.Rows[0]["FormalAmount_3"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_3"].ToString()));
                    yearAopDealer.FormalAmount4 = double.Parse((dt.Rows[0]["FormalAmount_4"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_4"].ToString()));
                    yearAopDealer.FormalAmount5 = double.Parse((dt.Rows[0]["FormalAmount_5"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_5"].ToString()));
                    yearAopDealer.FormalAmount6 = double.Parse((dt.Rows[0]["FormalAmount_6"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_6"].ToString()));
                    yearAopDealer.FormalAmount7 = double.Parse((dt.Rows[0]["FormalAmount_7"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_7"].ToString()));
                    yearAopDealer.FormalAmount8 = double.Parse((dt.Rows[0]["FormalAmount_8"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_8"].ToString()));
                    yearAopDealer.FormalAmount9 = double.Parse((dt.Rows[0]["FormalAmount_9"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_9"].ToString()));
                    yearAopDealer.FormalAmount10 = double.Parse((dt.Rows[0]["FormalAmount_10"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_10"].ToString()));
                    yearAopDealer.FormalAmount11 = double.Parse((dt.Rows[0]["FormalAmount_11"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_11"].ToString()));
                    yearAopDealer.FormalAmount12 = double.Parse((dt.Rows[0]["FormalAmount_12"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_12"].ToString()));

                    yearAopDealer.ReAmount1 = double.Parse((dt.Rows[0]["HosAmount1"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount1"].ToString()));
                    yearAopDealer.ReAmount2 = double.Parse((dt.Rows[0]["HosAmount2"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount2"].ToString()));
                    yearAopDealer.ReAmount3 = double.Parse((dt.Rows[0]["HosAmount3"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount3"].ToString()));
                    yearAopDealer.ReAmount4 = double.Parse((dt.Rows[0]["HosAmount4"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount4"].ToString()));
                    yearAopDealer.ReAmount5 = double.Parse((dt.Rows[0]["HosAmount5"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount5"].ToString()));
                    yearAopDealer.ReAmount6 = double.Parse((dt.Rows[0]["HosAmount6"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount6"].ToString()));
                    yearAopDealer.ReAmount7 = double.Parse((dt.Rows[0]["HosAmount7"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount7"].ToString()));
                    yearAopDealer.ReAmount8 = double.Parse((dt.Rows[0]["HosAmount8"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount8"].ToString()));
                    yearAopDealer.ReAmount9 = double.Parse((dt.Rows[0]["HosAmount9"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount9"].ToString()));
                    yearAopDealer.ReAmount10 = double.Parse((dt.Rows[0]["HosAmount10"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount10"].ToString()));
                    yearAopDealer.ReAmount11 = double.Parse((dt.Rows[0]["HosAmount11"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount11"].ToString()));
                    yearAopDealer.ReAmount12 = double.Parse((dt.Rows[0]["HosAmount12"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount12"].ToString()));

                    if (!dt.Rows[0]["RmkId"].ToString().Equals(""))
                    {
                        yearAopDealer.RmkId = new Guid(dt.Rows[0]["RmkId"].ToString());
                    }
                    return yearAopDealer;
                }
                else
                {
                    return null;
                }


            }
        }
        public VAopDealer GetDealerAOPAndHospitalAOPAmountTemp(Hashtable obj)
        {
            VAopDealer yearAopDealer = new VAopDealer();
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                DataTable dt = dao.GetDealerAOPAndHospitalAOPAmountTemp(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    yearAopDealer.DealerDmaId = new Guid(dt.Rows[0]["Dealer_DMA_ID"].ToString());
                    yearAopDealer.ProductLineBumId = new Guid(dt.Rows[0]["ProductLine_BUM_ID"].ToString());
                    yearAopDealer.Year = dt.Rows[0]["Year"].ToString();
                    yearAopDealer.Amount1 = double.Parse(dt.Rows[0]["Amount_1"].ToString());
                    yearAopDealer.Amount2 = double.Parse(dt.Rows[0]["Amount_2"].ToString());
                    yearAopDealer.Amount3 = double.Parse(dt.Rows[0]["Amount_3"].ToString());
                    yearAopDealer.Amount4 = double.Parse(dt.Rows[0]["Amount_4"].ToString());
                    yearAopDealer.Amount5 = double.Parse(dt.Rows[0]["Amount_5"].ToString());
                    yearAopDealer.Amount6 = double.Parse(dt.Rows[0]["Amount_6"].ToString());
                    yearAopDealer.Amount7 = double.Parse(dt.Rows[0]["Amount_7"].ToString());
                    yearAopDealer.Amount8 = double.Parse(dt.Rows[0]["Amount_8"].ToString());
                    yearAopDealer.Amount9 = double.Parse(dt.Rows[0]["Amount_9"].ToString());
                    yearAopDealer.Amount10 = double.Parse(dt.Rows[0]["Amount_10"].ToString());
                    yearAopDealer.Amount11 = double.Parse(dt.Rows[0]["Amount_11"].ToString());
                    yearAopDealer.Amount12 = double.Parse(dt.Rows[0]["Amount_12"].ToString());
                    yearAopDealer.RmkBody = dt.Rows[0]["RmkBody"].ToString();

                    yearAopDealer.FormalAmount1 = double.Parse((dt.Rows[0]["FormalAmount_1"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_1"].ToString()));
                    yearAopDealer.FormalAmount2 = double.Parse((dt.Rows[0]["FormalAmount_2"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_2"].ToString()));
                    yearAopDealer.FormalAmount3 = double.Parse((dt.Rows[0]["FormalAmount_3"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_3"].ToString()));
                    yearAopDealer.FormalAmount4 = double.Parse((dt.Rows[0]["FormalAmount_4"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_4"].ToString()));
                    yearAopDealer.FormalAmount5 = double.Parse((dt.Rows[0]["FormalAmount_5"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_5"].ToString()));
                    yearAopDealer.FormalAmount6 = double.Parse((dt.Rows[0]["FormalAmount_6"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_6"].ToString()));
                    yearAopDealer.FormalAmount7 = double.Parse((dt.Rows[0]["FormalAmount_7"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_7"].ToString()));
                    yearAopDealer.FormalAmount8 = double.Parse((dt.Rows[0]["FormalAmount_8"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_8"].ToString()));
                    yearAopDealer.FormalAmount9 = double.Parse((dt.Rows[0]["FormalAmount_9"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_9"].ToString()));
                    yearAopDealer.FormalAmount10 = double.Parse((dt.Rows[0]["FormalAmount_10"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_10"].ToString()));
                    yearAopDealer.FormalAmount11 = double.Parse((dt.Rows[0]["FormalAmount_11"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_11"].ToString()));
                    yearAopDealer.FormalAmount12 = double.Parse((dt.Rows[0]["FormalAmount_12"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_12"].ToString()));

                    yearAopDealer.ReAmount1 = double.Parse((dt.Rows[0]["HosAmount1"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount1"].ToString()));
                    yearAopDealer.ReAmount2 = double.Parse((dt.Rows[0]["HosAmount2"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount2"].ToString()));
                    yearAopDealer.ReAmount3 = double.Parse((dt.Rows[0]["HosAmount3"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount3"].ToString()));
                    yearAopDealer.ReAmount4 = double.Parse((dt.Rows[0]["HosAmount4"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount4"].ToString()));
                    yearAopDealer.ReAmount5 = double.Parse((dt.Rows[0]["HosAmount5"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount5"].ToString()));
                    yearAopDealer.ReAmount6 = double.Parse((dt.Rows[0]["HosAmount6"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount6"].ToString()));
                    yearAopDealer.ReAmount7 = double.Parse((dt.Rows[0]["HosAmount7"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount7"].ToString()));
                    yearAopDealer.ReAmount8 = double.Parse((dt.Rows[0]["HosAmount8"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount8"].ToString()));
                    yearAopDealer.ReAmount9 = double.Parse((dt.Rows[0]["HosAmount9"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount9"].ToString()));
                    yearAopDealer.ReAmount10 = double.Parse((dt.Rows[0]["HosAmount10"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount10"].ToString()));
                    yearAopDealer.ReAmount11 = double.Parse((dt.Rows[0]["HosAmount11"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount11"].ToString()));
                    yearAopDealer.ReAmount12 = double.Parse((dt.Rows[0]["HosAmount12"].ToString().Equals("") ? "0" : dt.Rows[0]["HosAmount12"].ToString()));

                    if (!dt.Rows[0]["RmkId"].ToString().Equals(""))
                    {
                        yearAopDealer.RmkId = new Guid(dt.Rows[0]["RmkId"].ToString());
                    }
                    return yearAopDealer;
                }
                else
                {
                    return null;
                }


            }
        }

        public bool SaveAopDealerTemp(string contractId, string partsContractId, VAopDealer aopDealers)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopDealerTempDao dao = new AopDealerTempDao())
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", contractId);
                    obj.Add("DealerDmaId", aopDealers.DealerDmaId);
                    obj.Add("ProductLineBumId", aopDealers.ProductLineBumId);
                    obj.Add("PartsContractId", partsContractId);
                    obj.Add("Year", aopDealers.Year);
                    int cnt = dao.Delete(obj);

                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "01", aopDealers.Amount1));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "02", aopDealers.Amount2));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "03", aopDealers.Amount3));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "04", aopDealers.Amount4));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "05", aopDealers.Amount5));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "06", aopDealers.Amount6));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "07", aopDealers.Amount7));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "08", aopDealers.Amount8));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "09", aopDealers.Amount9));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "10", aopDealers.Amount10));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "11", aopDealers.Amount11));
                    dao.Insert(this.getAopDealerFromVAopDealer(new Guid(contractId), new Guid(partsContractId), aopDealers, "12", aopDealers.Amount12));

                }
                trans.Complete();
                result = true;
            }

            return result;
        }


        private AopicDealerHospitalTemp getAopDealerFromVAopHospitalForIC(Guid ContractId, VAopICDealerHospital aopDealers, string month, double? number)
        {
            AopicDealerHospitalTemp aopHospital = new AopicDealerHospitalTemp();
            aopHospital.ContractId = ContractId;
            aopHospital.Id = Guid.NewGuid();
            aopHospital.DmaId = aopDealers.DmaId;
            aopHospital.ProductLineId = aopDealers.ProductLineId;
            aopHospital.PctId = aopDealers.PctId;
            aopHospital.HospitalId = aopDealers.HospitalId;
            aopHospital.Year = aopDealers.Year;
            aopHospital.Month = month;
            aopHospital.Unit = number;

            aopHospital.UpdateUserId = Guid.Empty;
            aopHospital.UpdateDate = DateTime.Now;

            return aopHospital;
        }
        private AopDealerHospitalTemp getAopDealerFromVAopHospital(Guid ContractId, VAopDealerHospitalTemp aopDealers, string month, double? amount)
        {
            AopDealerHospitalTemp aopHospital = new AopDealerHospitalTemp();
            aopHospital.ContractId = ContractId;
            aopHospital.Id = Guid.NewGuid();
            aopHospital.DealerDmaId = aopDealers.DealerDmaId;
            aopHospital.ProductLineBumId = aopDealers.ProductLineBumId;
            aopHospital.PctId = aopDealers.PctId;
            aopHospital.HospitalId = aopDealers.HospitalId;
            aopHospital.Year = aopDealers.Year;
            aopHospital.Month = month;
            aopHospital.Amount = amount;
            aopHospital.CcId = aopDealers.CcId;

            aopHospital.UpdateUserId = Guid.Empty;
            aopHospital.UpdateDate = DateTime.Now;

            return aopHospital;
        }
        private AopDealerTemp getAopDealerFromVAopDealer(Guid ContractId, Guid CCId, VAopDealer aopDealers, string month, double amount)
        {
            AopDealerTemp aopDealer = new AopDealerTemp();
            aopDealer.AopdContractId = ContractId;
            aopDealer.CcId = CCId;
            aopDealer.AopdId = Guid.NewGuid();
            aopDealer.AopdDealerDmaId = aopDealers.DealerDmaId;
            aopDealer.AopdProductLineBumId = aopDealers.ProductLineBumId;
            aopDealer.AopdMarketType = aopDealers.MarketType;
            aopDealer.AopdYear = aopDealers.Year;
            aopDealer.AopdMonth = month;
            aopDealer.AopdAmount = amount;
            //aopDealer.AopdUpdateUserId = new Guid(this._context.User.Id);
            aopDealer.AopdUpdateUserId = Guid.Empty;
            aopDealer.AopdUpdateDate = DateTime.Now;
            return aopDealer;
        }

        public DataSet QueryClassificationQuotaByQuery(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryClassificationQuotaByQuery(obj);
            }
        }

        public DataSet QueryAuthorizationClassificationQuotaByQuery(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryAuthorizationClassificationQuotaByQuery(obj);
            }
        }

        #region add new dcms Project on 20160629
        public DataSet GetDealerTempIndex(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetDealerTempIndex(obj);
            }
        }

        public DataSet GetDealerIndexTempYears(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetDealerIndexTempYears(obj);
            }
        }

        public DataSet GetHospitalTempIndexSum(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetHospitalTempIndexSum(obj);
            }
        }

        public DataSet QueryHospitalIndexTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalIndexTemp(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryProductIndexTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryProductIndexTemp(obj, start, limit, out totalRowCount);
            }
        }

        public bool HospitalProductAOPInput(DataTable table, string contractId)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ContractCommonDao dao = new ContractCommonDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<HospitalProductaopInputTemp> list = new List<HospitalProductaopInputTemp>();
                    foreach (DataRow dr in table.Rows)
                    {
                        errmsg = "";

                        HospitalProductaopInputTemp data = new HospitalProductaopInputTemp();
                        data.Contractid = contractId;

                        data.ProductCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.ProductName = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        data.HospitalCode = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        data.HospitalName = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        data.Year = dr[4] == DBNull.Value ? null : dr[4].ToString();

                        int iMonth = 1;
                        for (int i = 5; i <= 16; i++)
                        {
                            if (!string.IsNullOrEmpty(dr[i].ToString()))
                            {
                                decimal price;
                                if (!Decimal.TryParse(dr[i].ToString(), out price))
                                {
                                    errmsg = iMonth.ToString() + "月指标格式不正确、";
                                }
                                else if (Decimal.Parse(dr[i].ToString()) < 0)
                                {
                                    errmsg = iMonth.ToString() + "月指标不能小于0、";
                                }
                                else
                                {
                                    switch (iMonth)
                                    {
                                        case 1:
                                            data.M1 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 2:
                                            data.M2 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 3:
                                            data.M3 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 4:
                                            data.M4 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 5:
                                            data.M5 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 6:
                                            data.M6 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 7:
                                            data.M7 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 8:
                                            data.M8 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 9:
                                            data.M9 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 10:
                                            data.M10 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 11:
                                            data.M11 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                        case 12:
                                            data.M12 = Convert.ToDouble(dr[i].ToString());
                                            break;
                                    }
                                    iMonth += 1;
                                }
                            }
                            else
                            {
                                errmsg = iMonth.ToString() + "月指标为空、";
                            }
                        }

                        data.ErrMassage = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchHospitalProductAOPInsert(list);

                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyHospitalProductImport(out string IsValid, string contractId, DateTime beginDate)
        {
            System.Diagnostics.Debug.WriteLine("VerifyHospitalProductImport Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                IsValid = dao.VerifyHospitalProductImport(contractId, beginDate);
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyHospitalProductImport Finish : " + DateTime.Now.ToString());
            return result;
        }

        public DataSet QueryHospitalIndexImputError(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalIndexImputError(obj, start, limit, out totalRowCount);
            }
        }

        public string HospitalProductAOPInputSubmint(string contractId)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.HospitalProductAOPInputSubmint(contractId);
            }
        }

        public int DeleteProductHospitalInitById(string contractId)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.DeleteProductHospitalInitById(contractId);
            }
        }



        public DataSet QueryHospitalIndexUnitTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalIndexUnitTemp(obj, start, limit, out totalRowCount);
            }
        }


        public DataSet QueryProductIndexUnitTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryProductIndexUnitTemp(obj, start, limit, out totalRowCount);
            }
        }

        public string DealerAOPMerge(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.DealerAOPMerge(obj);
            }
        }

        public DataSet QueryDealerAndHospitalSumAOPTemp(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryDealerAndHospitalSumAOPTemp(obj);
            }
        }

        public DataSet GetHospitalTempIndexUnitToAmountSum(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetHospitalTempIndexUnitToAmountSum(obj);
            }
        }

        public DataSet QueryHospitalUnitAopTempP(Hashtable obj, int start, int limit)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                obj.Add("start", start);
                obj.Add("limit", limit);
                return dao.QueryHospitalUnitAopTempP(obj);
            }
        }

        public bool SaveHospitalProductAOPUnitMerge(Guid ContractId, string PartsContractCode, VAopDealerHospitalTemp aopHospital, int month)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", ContractId);
                    obj.Add("DealerDmaId", aopHospital.DealerDmaId);
                    obj.Add("ProductLineBumId", aopHospital.ProductLineBumId);
                    obj.Add("Year", aopHospital.Year);
                    obj.Add("HospitalId", aopHospital.HospitalId);
                    obj.Add("PctId", aopHospital.PctId);

                    int cnt = dao.Delete(obj);

                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "01", aopHospital.Amount1));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "02", aopHospital.Amount2));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "03", aopHospital.Amount3));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "04", aopHospital.Amount4));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "05", aopHospital.Amount5));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "06", aopHospital.Amount6));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "07", aopHospital.Amount7));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "08", aopHospital.Amount8));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "09", aopHospital.Amount9));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "10", aopHospital.Amount10));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "11", aopHospital.Amount11));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, aopHospital, "12", aopHospital.Amount12));

                    //更新经销商指标列表
                    using (AopDealerTempDao daoDealerAopTemp = new AopDealerTempDao())
                    {
                        Hashtable objDealer = new Hashtable();
                        objDealer.Add("ContractId", ContractId);
                        objDealer.Add("DealerDmaId", aopHospital.DealerDmaId);
                        objDealer.Add("ContractCode", PartsContractCode);
                        objDealer.Add("ProductLineBumId", aopHospital.ProductLineBumId);
                        objDealer.Add("Year", aopHospital.Year);
                        objDealer.Add("MarketType", aopHospital.MarketType);
                        objDealer.Add("MinMonth", month);
                        daoDealerAopTemp.Delete(objDealer);

                        daoDealerAopTemp.MerageDealerAopTemp(objDealer);
                    }


                }
                trans.Complete();
                result = true;
            }

            return result;
        }

        public DataSet QueryHospitalProductAmountAmendmentTemp2(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalProductAmountAmendmentTemp2(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet GetHospitalCriterionAOP(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetHospitalCriterionAOP(obj);
            }
        }

        public DataSet GetHospitalHistoryAOP(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetHospitalHistoryAOP(obj);
            }
        }

        public DataSet GetHospitalCurrentAOP(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetHospitalCurrentAOP(obj);
            }
        }

        public DataSet QueryHospitalCurrentAOP(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryHospitalCurrentAOP(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryDealerAOPTempAmendment(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryDealerAOPTempAmendment(obj);
            }
        }

        public DataSet QueryDealerAOPTempUnitAmendment(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.QueryDealerAOPTempUnitAmendment(obj);
            }
        }

        public DataSet GetDelaerHistoryAOP(Hashtable obj)
        {
            using (ContractCommonDao dao = new ContractCommonDao())
            {
                return dao.GetDelaerHistoryAOP(obj);
            }
        }

        #endregion
    }
}
