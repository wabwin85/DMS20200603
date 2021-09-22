
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Contract].[GC_Fn_DealerAopData_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Contract].[GC_Fn_DealerAopData_List]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**********************************************
 功能:获取新经销商申请商业采购指标
 作者：Grapecity
 最后更新时间： 2017-11-20
 更新记录说明：
 1.创建 2017-11-20
**********************************************/

CREATE FUNCTION [Contract].[GC_Fn_DealerAopData_List]
(
	 @InstanceId UNIQUEIDENTIFIER
)
RETURNS @temp TABLE 
(
	ContractId		UNIQUEIDENTIFIER NOT NULL,	--合同Id
	DealerName		NVARCHAR(200)	NULL,		--经销商名称
	SubDeptName		NVARCHAR(200)	NOT NULL,	--SubBU
	Year			NVARCHAR(50)	NULL,	--指标年份
	Month1			float	NULL,	--1月
	Month2			float	NULL,	--2月
	Month3			float	NULL,	--3
	Month4			float	NULL,	--4
	Month5			float	NULL,	--5
	Month6			float	NULL,	--6
	Month7			float	NULL,	--7
	Month8			float	NULL,	--8
	Month9			float	NULL,	--9
	Month10			float	NULL,	--10
	Month11			float	NULL,	--11
	Month12			float	NULL,	--12
	Q1				float	NULL,	--Q1
	Q2				float	NULL,	--Q2
	Q3				float	NULL,	--Q3
	Q4				float	NULL,	--Q4
	TotalYaer		float	NULL	--全年指标
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
		DECLARE @DealerName nvarchar(500);
		
		SELECT @DealerName=CompanyName FROM Contract.AppointmentCandidate WHERE ContractId=@InstanceId
		
		IF ISNULL(@DealerName,'')=''
			SELECT @DealerName=B.DMA_ChineseName FROM Contract.AmendmentMain a INNER JOIN DealerMaster B ON A.DealerName=B.DMA_SAP_Code WHERE ContractId=@InstanceId
		
		IF ISNULL(@DealerName,'')=''
			SELECT @DealerName=B.DMA_ChineseName FROM Contract.RenewalMain a INNER JOIN DealerMaster B ON A.DealerName=B.DMA_SAP_Code WHERE ContractId=@InstanceId
		
		IF ISNULL(@DealerName,'')=''
			SELECT @DealerName=B.DMA_ChineseName FROM Contract.RenewalMain a INNER JOIN DealerMaster B ON A.DealerName=B.DMA_SAP_Code WHERE ContractId=@InstanceId
		
		
		INSERT INTO @temp(ContractId,DealerName,SubDeptName,Year
			,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
			,Q1,Q2,Q3,Q4,TotalYaer)
		SELECT a.AOPD_Contract_ID,@DealerName,d.CC_NameCN,a.AOPD_Year
			,A.AOPD_Amount_1,A.AOPD_Amount_2,A.AOPD_Amount_3,A.AOPD_Amount_4,A.AOPD_Amount_5,A.AOPD_Amount_6,A.AOPD_Amount_7,A.AOPD_Amount_8,A.AOPD_Amount_9,A.AOPD_Amount_10,A.AOPD_Amount_11,A.AOPD_Amount_12
			,A.AOPD_Amount_1+A.AOPD_Amount_2+A.AOPD_Amount_3
			,A.AOPD_Amount_4+A.AOPD_Amount_5+A.AOPD_Amount_6
			,A.AOPD_Amount_7+A.AOPD_Amount_8+A.AOPD_Amount_9
			,A.AOPD_Amount_10+A.AOPD_Amount_11+A.AOPD_Amount_12
			,A.AOPD_Amount_Y
			FROM V_AOPDealer_Temp A
			LEFT JOIN (SELECT DISTINCT CC_ID,CC_NameCN,CC_Code FROM INTERFACE.ClassificationContract) D ON D.CC_ID=A.AOPD_CC_ID
			WHERE A.AOPD_Contract_ID=@InstanceId
		RETURN
    END

GO


