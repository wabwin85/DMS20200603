
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Contract].[GC_Fn_Termination_FormData_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Contract].[GC_Fn_Termination_FormData_List]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**********************************************
 ����:��ȡ��ֹ�����ͬ��Ϣ
 ���ߣ�Grapecity
 ������ʱ�䣺 2017-11-20
 ���¼�¼˵����
 1.���� 2017-11-20
**********************************************/

CREATE FUNCTION [Contract].[GC_Fn_Termination_FormData_List]
(
	 @InstanceId UNIQUEIDENTIFIER
)
RETURNS @temp TABLE 
(
	ContractId		UNIQUEIDENTIFIER NOT NULL,	--��ͬId
	ContractNo		NVARCHAR(200)	NOT NULL,	--��ͬ���
	CompanyId		NVARCHAR(36)	NULL,		--������ID
	CompanyName		NVARCHAR(200)	NULL,		--������������
	CompanyEName	NVARCHAR(500)	NULL,		--������Ӣ����
	OfficeAddress	NVARCHAR(500)	NULL,		--���������ĵ�ַ
	Contact			NVARCHAR(500)	NULL,		--��ϵ��������
	TerminationType	NVARCHAR(500)	NULL,		--��ֹ����
	ProductName		NVARCHAR(500)	NULL,		--BU����ȫ��
	ProductEName	NVARCHAR(500)	NULL,		--BUӢ��ȫ��
	SubProductName		NVARCHAR(500)	NULL,		--SubBU����ȫ��
	SubProductEName		NVARCHAR(500)	NULL,		--SubBUӢ������
	PlanExpiration	DateTime		NULL,		--Э����Ч����
	EndExpiration	DateTime		NULL,		--��ֹ��Ч����
	CurrentAR		Decimal(18, 2)	NULL,		--������Ӧ������
	LPName			NVARCHAR(300)	NULL,		--ƽ̨����
	LPAddress		NVARCHAR(500)	NULL,		--ƽ̨��ַ
	LPContacts		NVARCHAR(200)	NULL,		--ƽ̨��ϵ��
	SubmitUserCN	NVARCHAR(200)	NULL,		--������������
	SubmitUserEN	NVARCHAR(200)	NULL		--������Ӣ����
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



