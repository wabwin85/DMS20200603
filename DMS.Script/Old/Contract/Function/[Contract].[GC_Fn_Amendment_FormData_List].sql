
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Contract].[GC_Fn_Amendment_FormData_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Contract].[GC_Fn_Amendment_FormData_List]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**********************************************
 功能:获取修改申请合同信息
 作者：Grapecity
 最后更新时间： 2017-11-20
 更新记录说明：
 1.创建 2017-11-20
**********************************************/

CREATE FUNCTION [Contract].[GC_Fn_Amendment_FormData_List]
(
	 @InstanceId UNIQUEIDENTIFIER
)
RETURNS @temp TABLE 
(
	ContractId			UNIQUEIDENTIFIER NOT NULL,	--合同Id
	ContractNo			NVARCHAR(200)	NOT NULL,	--补充协议编号
	ContractNoCurrent	NVARCHAR(200)	NULL,		--原协议编号
	DealerBeginDate		DateTime	NULL,			--原协议生效日期
	DealerEndDate		DateTime	NULL,			--原协议到期日期
	AmendBegineDate		DateTime	NULL,			--补充协议生效日期
	AmendEndDate		DateTime	NULL,			--补充协议到期日期
	CompanyId			NVARCHAR(36)	NULL,		--经销商ID
	CompanyName			NVARCHAR(500)	NULL,		--经销商中文名
	CompanyEName		NVARCHAR(500)	NULL,		--经销商英文名
	ProductName			NVARCHAR(500)	NULL,		--BU中文全名
	ProductEName		NVARCHAR(500)	NULL,		--BU英文全名
	SubProductName		NVARCHAR(500)	NULL,		--SubBU中文全名
	SubProductEName		NVARCHAR(500)	NULL,		--SubBU英文名称
	Payment				NVARCHAR(20)	NULL,		--付款方式
	CreditTerm			NVARCHAR(50)	NULL,		--信用期限(天数)
	CreditLimit			INT				NULL,		--信用额度(CNY, 含增值税)
	PayTerm				NVARCHAR(50)	NULL,		--付款天数（只有Payment为LC时才需要填写）
	IsDeposit			INT				NULL,		--是否有担保
	Deposit				INT				NULL,		--保证金
	Inform				NVARCHAR(100)	NULL,		--保证金形式
	InformOther			NVARCHAR(500)	NULL,		--保证金其他形式
	Comment				NVARCHAR(300)	NULL,		--付款备注
	LPName				NVARCHAR(300)	NULL,	--平台名称
	LPAddress			NVARCHAR(500)	NULL,	--平台地址
	LPContacts		NVARCHAR(200)	NULL	--平台联系人
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
		INSERT INTO @temp(ContractId,ContractNo,ContractNoCurrent,DealerBeginDate,DealerEndDate,AmendBegineDate,AmendEndDate,
		CompanyName,CompanyEName,ProductName,ProductEName,SubProductName,SubProductEName,
		Payment,CreditTerm,CreditLimit,PayTerm,IsDeposit,Deposit,Inform,InformOther,Comment,LPName,LPAddress,LPContacts,CompanyId)
		SELECT a.ContractId,ContractNo,'',A.DealerBeginDate,A.DealerEndDate,A.AmendEffectiveDate,A.DealerEndDate
		,b.DMA_ChineseName,b.DMA_EnglishName
		,ProductName =(SELECT TOP 1 PR.ProductLineName FROM V_DivisionProductLineRelation PR WHERE PR.DivisionCode=A.DepId AND PR.IsEmerging='0')
		,ProductEName =(SELECT TOP 1 PR.DivisionName FROM V_DivisionProductLineRelation PR WHERE PR.DivisionCode=A.DepId AND PR.IsEmerging='0')
		,SubProductName=D.CC_NameCN
		,SubProductEName=D.CC_NameEN
		,Payment,CreditTerm,CreditLimit,PayTerm,IsDeposit,Deposit,Inform,InformOther,Comment
		,LPName=(SELECT DMA_ChineseName FROM DealerMaster WHERE DealerMaster.DMA_ID=B.DMA_Parent_DMA_ID AND DealerMaster.DMA_DealerType='LP')
		,LPAddress=(SELECT DMA_Address FROM DealerMaster WHERE DealerMaster.DMA_ID=b.DMA_Parent_DMA_ID AND DMA_DealerType='LP')
		,LPContacts=(SELECT DMA_ContactPerson FROM DealerMaster WHERE DealerMaster.DMA_ID=b.DMA_Parent_DMA_ID AND DMA_DealerType='LP')
		,CompanyId=B.DMA_ID
		FROM Contract.AmendmentMain A 
		INNER JOIN DealerMaster B ON A.CompanyID=B.DMA_ID
		INNER JOIN Contract.AmendmentProposals C ON A.ContractId=C.ContractId
		INNER JOIN INTERFACE.ClassificationContract D ON D.CC_Code=A.SUBDEPID
		WHERE A.ContractId=@InstanceId
		AND A.ContractStatus NOT IN ('Draft','Delete')
		
		RETURN
    END




