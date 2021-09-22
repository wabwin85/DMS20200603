DROP PROCEDURE [Workflow].[Proc_Attachment_GetHtmlData]
GO

CREATE PROCEDURE [Workflow].[Proc_Attachment_GetHtmlData]
	@InstanceId uniqueidentifier,
	@Type NVARCHAR(100)
AS

SELECT AT_ID AS Id,AT_Main_ID AS MainId,AT_Name AS Name,AT_Url AS Url,AT_Type AS Type,DIC.VALUE1 AS  TypeName ,AT_UploadUser AS UploadUser,Convert(NVARCHAR(20),AT_UploadDate,120) AS UploadDate
,li.Identity_Name,row_number() OVER (ORDER BY AT_UploadDate DESC) AS row_number
FROM Attachment a
INNER JOIN Lafite_Identity li ON a.AT_UploadUser = li.Id
LEFT JOIN dbo.Lafite_DICT DIC ON DIC.DICT_KEY=a.AT_Type
WHERE AT_Main_ID=@InstanceId
AND (@Type IS NULL OR AT_Type = @Type )

GO


