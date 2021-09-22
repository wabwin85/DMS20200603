
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Contract].[GC_Fn_HospitalAopData_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Contract].[GC_Fn_HospitalAopData_List]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**********************************************
 ����:��ȡ�¾���������ҽԺָ��
 ���ߣ�Grapecity
 ������ʱ�䣺 2017-11-20
 ���¼�¼˵����
 1.���� 2017-11-20
**********************************************/

CREATE FUNCTION [Contract].[GC_Fn_HospitalAopData_List]
(
	 @InstanceId UNIQUEIDENTIFIER
)
RETURNS @temp TABLE 
(
	ContractId		UNIQUEIDENTIFIER NOT NULL,	--��ͬId
	ProductName		NVARCHAR(200)	NOT NULL,	--��Ʒ����
	HospitalCode	NVARCHAR(200)	NULL,	--ҽԺ���
	HospitalName	NVARCHAR(200)	NULL,	--ҽԺ����
	HospitalEName	NVARCHAR(200)	NULL,	--ҽԺӢ������
	Year			NVARCHAR(50)	NULL,	--ָ�����
	Month1			float	NULL,	--1��
	Month2			float	NULL,	--2��
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
	TotalYaer		float	NULL	--ȫ��ָ��
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
		INSERT INTO @temp(ContractId,ProductName,HospitalCode,HospitalName,HospitalEName,Year
			,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12
			,Q1,Q2,Q3,Q4,TotalYaer)
		SELECT a.AOPDH_Contract_ID,d.CQ_NameCN,B.HOS_Key_Account,B.HOS_HospitalName,B.HOS_HospitalNameEN,A.AOPDH_Year
			,A.AOPDH_Amount_1,A.AOPDH_Amount_2,A.AOPDH_Amount_3,A.AOPDH_Amount_4,A.AOPDH_Amount_5,A.AOPDH_Amount_6,A.AOPDH_Amount_7,A.AOPDH_Amount_8,A.AOPDH_Amount_9,A.AOPDH_Amount_10,A.AOPDH_Amount_11,A.AOPDH_Amount_12
			,A.AOPDH_Amount_1+A.AOPDH_Amount_2+A.AOPDH_Amount_3
			,A.AOPDH_Amount_4+A.AOPDH_Amount_5+A.AOPDH_Amount_6
			,A.AOPDH_Amount_7+A.AOPDH_Amount_8+A.AOPDH_Amount_9
			,A.AOPDH_Amount_10+A.AOPDH_Amount_11+A.AOPDH_Amount_12
			,a.AOPDH_Amount_Y
			FROM V_AOPDealerHospital_Temp A
			INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID
			LEFT JOIN (SELECT DISTINCT CQ_ID,CQ_NameCN,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
			WHERE A.AOPDH_Contract_ID=@InstanceId
		RETURN
    END

GO


