DROP FUNCTION [dbo].[GC_CheckDealer] 
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GC_CheckDealer] 
(
   @UserId uniqueidentifier,
   @DealerId uniqueidentifier
)
RETURNS bit
AS
BEGIN
declare @result  bit ;
WITH OrganizationUnits(AttributeId, AttributeName, AttributeType,AttributeLevel,UserID) AS 
(
    SELECT
		LA.[Id] AS AttributeId,
		LA.[ATTRIBUTE_NAME] AS AttributeName,
		LA.[ATTRIBUTE_TYPE] AS AttributeType,
		LA.[ATTRIBUTE_LEVEL] AS AttributeLevel,
		@UserId UserID
		FROM Lafite_ATTRIBUTE LA
		where LA.DELETE_FLAG=0 
		AND exists(SELECT 1 from Lafite_IDENTITY_MAP IM where LA.ID = IM.MAP_ID and IM.MAP_TYPE='Organization'  
		AND IM.IDENTITY_ID=@UserId)
    UNION ALL
   SELECT
		LA.[Id] AS AttributeId,
		LA.[ATTRIBUTE_NAME] AS AttributeName,
		LA.[ATTRIBUTE_TYPE] AS AttributeType,
		LA.[ATTRIBUTE_LEVEL] AS AttributeLevel,
		@UserId UserID
		FROM Lafite_ATTRIBUTE LA , OrganizationUnits OU
		where LA.DELETE_FLAG=0 and exists( select 1 from Lafite_ATTRIBUTE_RELATION R1 
		 where R1.ATTRIBUTE1_ID =OU.AttributeId
		 and R1.ATTRIBUTE2_ID = LA.Id )
)


select @result = case when EXISTS( SELECT 1 FROM OrganizationUnits OU, Lafite_IDENTITY_MAP IM 
where OU.AttributeId = IM.MAP_ID and IM.MAP_TYPE='Organization' 
and  EXISTS(SELECT 1  FROM dbo.DealerAuthorizationTable AS DA , dbo.DealerContract AS DC ,dbo.SalesRepHospital AS SH
			WHERE DA.DAT_DCL_ID = DC.DCL_ID AND SH.SRH_USR_UserID = IM.IDENTITY_ID and  DC.DCL_DMA_ID =@DealerId and 
					EXISTS(SELECT 1 FROM dbo.HospitalList AS DAH WHERE HLA_DAT_ID = DA.DAT_ID AND SH.SRN_HOS_ID = HLA_HOS_ID)
			)
	) then 1 else 0 end

	return @result 
END

GO


