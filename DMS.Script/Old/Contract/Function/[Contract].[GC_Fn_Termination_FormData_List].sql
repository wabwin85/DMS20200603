
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Contract].[GC_Fn_Termination_FormData_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Contract].[GC_Fn_Termination_FormData_List]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**********************************************
 功能:获取终止申请合同信息
 作者：Grapecity
 最后更新时间： 2017-11-20
 更新记录说明：
 1.创建 2017-11-20
**********************************************/

CREATE FUNCTION [Contract].[GC_Fn_Termination_FormData_List]
(
	 @InstanceId UNIQUEIDENTIFIER
)
RETURNS @temp TABLE 
(
	ContractId		UNIQUEIDENTIFIER NOT NULL,	--合同Id
	ContractNo		NVARCHAR(200)	NOT NULL,	--合同编号
	CompanyId		NVARCHAR(36)	NULL,		--经销商ID
	CompanyName		NVARCHAR(200)	NULL,		--经销商中文名
	CompanyEName	NVARCHAR(500)	NULL,		--经销商英文名
	OfficeAddress	NVARCHAR(500)	NULL,		--经销商中文地址
	Contact			NVARCHAR(500)	NULL,		--联系人中文名
	TerminationType	NVARCHAR(500)	NULL,		--终止类型
	ProductName		NVARCHAR(500)	NULL,		--BU中文全名
	ProductEName	NVARCHAR(500)	NULL,		--BU英文全名
	SubProductName		NVARCHAR(500)	NULL,		--SubBU中文全名
	SubProductEName		NVARCHAR(500)	NULL,		--SubBU英文名称
	PlanExpiration	DateTime		NULL,		--协议生效日期
	EndExpiration	DateTime		NULL,		--终止生效日期
	CurrentAR		Decimal(18, 2)	NULL,		--经销商应付款项
	LPName			NVARCHAR(300)	NULL,		--平台名称
	LPAddress		NVARCHAR(500)	NULL,		--平台地址
	LPContacts		NVARCHAR(200)	NULL,		--平台联系人
	SubmitUserCN	NVARCHAR(200)	NULL,		--申请人中文名
	SubmitUserEN	NVARCHAR(200)	NULL		--申请人英文名
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
		INSERT INTO @temp(ContractId,ContractNo,CompanyName,CompanyEName,OfficeAddress,Contact,TerminationType
		,ProductName,ProductEName,SubProductName,SubProductEName
		,PlanExpiration,EndExpiration,CurrentAR
		,LPName,LPAddress,LPContacts,SubmitUserCN,SubmitUserEN,CompanyId)
		SELECT a.ContractId,A.ContractNo,B.DMA_ChineseName,B.DMA_EnglishName,B.DMA_Address,DMA_ContactPerson,A.DealerEndTyp
		,ProductName =(SELECT TOP 1 PR.ProductLineName FROM V_DivisionProductLineRelation PR WHERE PR.DivisionCode=A.DepId AND PR.IsEmerging='0')
		,ProductEName =(SELECT TOP 1 PR.DivisionName FROM V_DivisionProductLineRelation PR WHERE PR.DivisionCode=A.DepId AND PR.IsEmerging='0')
		,SubProductName=F.CC_NameCN
		,SubProductEName=F.CC_NameEN
		,PlanExpiration,PlanExpiration,ISNULL(CurrentAR,0.0)
		,LPName=(SELECT DMA_ChineseName FROM DealerMaster WHERE DealerMaster.DMA_ID=B.DMA_Parent_DMA_ID AND DealerMaster.DMA_DealerType='LP')
		,LPAddress=(SELECT DMA_Address FROM DealerMaster WHERE DealerMaster.DMA_ID=b.DMA_Parent_DMA_ID AND DMA_DealerType='LP')
		,LPContacts=(SELECT DMA_ContactPerson FROM DealerMaster WHERE DealerMaster.DMA_ID=b.DMA_Parent_DMA_ID AND DMA_DealerType='LP')
		,SubmitUserCN=D.Name
		,SubmitUserEN=d.eName
		,CompanyId=B.DMA_ID
		FROM Contract.TerminationMain A 
		INNER JOIN INTERFACE.ClassificationContract F ON F.CC_Code=A.SUBDEPID
		INNER JOIN DealerMaster B ON B.DMA_SAP_Code=A.DealerName
		INNER JOIN Contract.TerminationStatus C ON A.ContractId=  C.ContractId
		LEFT JOIN INTERFACE.MDM_EmployeeMaster D ON D.EID=A.EId
		WHERE A.ContractId=@InstanceId
		AND A.ContractStatus NOT IN ('Draft','Delete')
		
		RETURN
    END


GO



