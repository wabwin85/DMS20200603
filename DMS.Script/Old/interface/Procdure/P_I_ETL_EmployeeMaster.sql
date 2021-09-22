DROP PROC [interface].[P_I_ETL_EmployeeMaster]
GO



CREATE PROC [interface].[P_I_ETL_EmployeeMaster]
AS
BEGIN

	TRUNCATE TABLE [interface].[MDM_EmployeeMaster]
	
	INSERT INTO [interface].[MDM_EmployeeMaster](
			EID
		  ,ACCOUNT
		  ,NAME
		  ,ENAME
		  ,DepID
		  ,DepCode
		  ,DEPFULLCODE
		  ,DEPABBR
		  ,TITLE
		  ,REPORTTO
		  ,REPORTTONAME
		  ,COSTCENTER
		  ,EMAIL
		  ,MOBILE
		  ,STATUS	
	)
	SELECT 	
		  EID
		  ,ACCOUNT
		  ,NAME
		  ,ENAME
		  ,DepID
		  ,DepCode
		  ,DEPFULLCODE
		  ,DEPABBR
		  ,TITLE
		  ,REPORTTO
		  ,REPORTTONAME
		  ,COSTCENTER
		  ,EMAIL
		  ,MOBILE
		  ,STATUS
	FROM [interface].[Stage_MDM_EmployeeMaster]

END
GO


