DROP proc [interface].[P_I_MDM_Hospital]
GO

CREATE proc [interface].[P_I_MDM_Hospital]


as

--更新已存在的数据
	update Hospital set
	HOS_HospitalName=b.HOS_HospitalName,
	HOS_HospitalShortName=b.HOS_HospitalShortName,
	HOS_Province=b.HOS_Province,
	HOS_City=b.HOS_City,
	HOS_District=b.HOS_District,
	HOS_Town=b.HOS_Town,
	HOS_Grade=b.HOS_Grade,
	HOS_Address=b.HOS_Address,
	HOS_PostalCode=b.HOS_PostalCode,
	HOS_Phone=b.HOS_Phone,
	HOS_PublicEmail=b.HOS_PublicEmail,
	HOS_Website=b.HOS_Website,
	HOS_ActiveFlag=b.HOS_ActiveFlag,
	HOS_DeletedFlag=CASE b.HOS_ActiveFlag WHEN 1 THEN 0 WHEN 0 THEN 1 END,
	HOS_LastModifiedDate=b.HOS_LastModifiedDate
	FROM
	Hospital a inner join 
	interface.MDM_Hospital b on a.HOS_Key_Account=b.HOS_Key_Account
			 

--添加新的数据
	insert into Hospital
	(HOS_ID,
	HOS_Key_Account,
	HOS_HospitalName,
	HOS_HospitalShortName,
	HOS_Province,
	HOS_City,
	HOS_District,
	HOS_Town,
	HOS_Grade,
	HOS_Address,
	HOS_PostalCode,
	HOS_Phone,
	HOS_PublicEmail,
	HOS_Website,
	HOS_ActiveFlag,
	HOS_DeletedFlag,
	HOS_CreatedDate,
	HOS_CreatedBy,
	HOS_LastModifiedDate
	)
	select 
	HOS_ID,
	HOS_Key_Account,
	HOS_HospitalName,
	HOS_HospitalShortName,
	HOS_Province,
	HOS_City,
	HOS_District,
	HOS_Town,
	HOS_Grade,
	HOS_Address,
	HOS_PostalCode,
	HOS_Phone,
	HOS_PublicEmail,
	HOS_Website,
	HOS_ActiveFlag,
	CASE HOS_ActiveFlag WHEN 1 THEN 0 WHEN 0 THEN 1 END,
	HOS_CreatedDate,
	NEWID(),
	HOS_LastModifiedDate
	from interface.MDM_Hospital   
	where HOS_Key_Account not in (select HOS_Key_Account from Hospital)
	
	
	--更新MDS未同步医院状态为无效属性
	UPDATE A SET 
	A.HOS_ActiveFlag=0,A.HOS_DeletedFlag=1,HOS_LastModifiedDate=GETDATE()
	FROM Hospital A
	WHERE NOT EXISTS (SELECT 1 FROM interface.MDM_Hospital B WHERE B.HOS_Key_Account=A.HOS_Key_Account)
	
GO


