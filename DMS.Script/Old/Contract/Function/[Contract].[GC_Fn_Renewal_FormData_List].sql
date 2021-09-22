
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Contract].[GC_Fn_Renewal_FormData_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Contract].[GC_Fn_Renewal_FormData_List]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**********************************************
 ����:��ȡ��Լ�����ͬ��Ϣ
 ���ߣ�Grapecity
 ������ʱ�䣺 2017-11-20
 ���¼�¼˵����
 1.���� 2017-11-20
**********************************************/

CREATE FUNCTION [Contract].[GC_Fn_Renewal_FormData_List]
(
	 @InstanceId UNIQUEIDENTIFIER
)
RETURNS @temp TABLE 
(
	ContractId	UNIQUEIDENTIFIER NOT NULL,	--��ͬId
	ContractNo	NVARCHAR(200)	NOT NULL,	--��ͬ���
	CompanyId			NVARCHAR(36)	NULL,		--������ID
	CompanyName	NVARCHAR(200)	NULL,		--������������
	CompanyEName NVARCHAR(500)	NULL,		--������Ӣ����
	OfficeAddress NVARCHAR(500)	NULL,		--���������ĵ�ַ
	Mobile		 NVARCHAR(500)	NULL,		--��������ϵ�绰
	OfficeNumber NVARCHAR(500)	NULL,		--�����̴���
	EMail		NVARCHAR(500)	NULL,		--����������
	Contact		NVARCHAR(500)	NULL,		--��ϵ��������
	AgreementBegin	DateTime	NULL,		--Э����ʼ����
	AgreementEnd	DateTime	NULL,		--Э����ʼ����
	ProductName		NVARCHAR(500)	NULL,	--BU����ȫ��
	ProductEName	NVARCHAR(500)	NULL,	--BUӢ��ȫ��
	SubProductName		NVARCHAR(500)	NULL,		--SubBU����ȫ��
	SubProductEName		NVARCHAR(500)	NULL,		--SubBUӢ������
	Payment			NVARCHAR(500)	NULL,	--���ʽ
	CreditTerm		INT			NULL,		--��������(����)
	CreditLimit		DECIMAL(18,4)	NULL,	--���ö��(CNY, ����ֵ˰)
	PayTerm			NVARCHAR(100)	NULL,	--����������ֻ��PaymentΪLCʱ����Ҫ��д��
	IsDeposit		int			NULL,		--�Ƿ��е���
	Deposit			int			NULL,		--��֤��
	Inform			NVARCHAR(100)	NULL,	--��֤����ʽ
	InformOther		NVARCHAR(500)	NULL,	--��֤��������ʽ
	Comment			NVARCHAR(300)	NULL,	--���ע
	LPName			NVARCHAR(300)	NULL,	--ƽ̨����
	LPAddress		NVARCHAR(500)	NULL,	--ƽ̨��ַ
	LPContacts		NVARCHAR(200)	NULL	--ƽ̨��ϵ��
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
		INSERT INTO @temp(ContractId,ContractNo,CompanyName,CompanyEName,OfficeAddress,Mobile,OfficeNumber,EMail,Contact,AgreementBegin,AgreementEnd,ProductName,ProductEName,SubProductName,SubProductEName,Payment,CreditTerm,CreditLimit,PayTerm,IsDeposit,Deposit,Inform,InformOther,Comment,LPName,LPAddress,LPContacts,CompanyId)
		SELECT a.ContractId,A.ContractNo,B.DMA_ChineseName,B.DMA_EnglishName,B.DMA_Address,B.DMA_Phone,DMA_Fax,DMA_Email,DMA_ContactPerson,AgreementBegin,AgreementEnd
		,ProductName =(SELECT TOP 1 PR.ProductLineName FROM V_DivisionProductLineRelation PR WHERE PR.DivisionCode=A.DepId AND PR.IsEmerging='0')
		,ProductEName =(SELECT TOP 1 PR.DivisionName FROM V_DivisionProductLineRelation PR WHERE PR.DivisionCode=A.DepId AND PR.IsEmerging='0')
		,SubProductName=D.CC_NameCN
		,SubProductEName=D.CC_NameEN
		,Payment,CreditTerm,CreditLimit,PayTerm,IsDeposit,Deposit,Inform,InformOther,Comment
		,LPName=(SELECT DMA_ChineseName FROM DealerMaster WHERE DealerMaster.DMA_ID=B.DMA_Parent_DMA_ID AND DealerMaster.DMA_DealerType='LP')
		,LPAddress=(SELECT DMA_Address FROM DealerMaster WHERE DealerMaster.DMA_ID=b.DMA_Parent_DMA_ID AND DMA_DealerType='LP')
		,LPContacts=(SELECT DMA_ContactPerson FROM DealerMaster WHERE DealerMaster.DMA_ID=b.DMA_Parent_DMA_ID AND DMA_DealerType='LP')
		,CompanyId=B.DMA_ID
		FROM Contract.RenewalMain A 
		INNER JOIN DealerMaster B ON B.DMA_SAP_Code=A.DealerName
		INNER JOIN Contract.RenewalProposals C ON A.ContractId=  C.ContractId
		INNER JOIN INTERFACE.ClassificationContract D ON D.CC_Code=A.SUBDEPID
		WHERE A.ContractId=@InstanceId
		AND A.ContractStatus NOT IN ('Draft','Delete')
		
		RETURN
    END



GO


