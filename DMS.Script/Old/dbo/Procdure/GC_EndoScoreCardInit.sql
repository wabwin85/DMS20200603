DROP PROcedure [dbo].[GC_EndoScoreCardInit]
GO

CREATE PROcedure [dbo].[GC_EndoScoreCardInit]
	@UserId uniqueidentifier,
    @ImportType NVARCHAR(20),   
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
AS

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN


Update EndoScoreCardInit set ESCI_ErrorFlag = 0  where ESCI_User = @UserId

Update EndoScoreCardInit
set ESCI_DMAID = ESC_DMA_ID
from EndoScoreCard
where ESCI_No = ESC_No 
and ESCI_User = @UserId


--单号是否存在
Update ESCI
set ESCI_ErrorFlag = 1,ESCI_No_ErrMsg = N'评分单据号不存在'
from EndoScoreCardInit ESCI left join EndoScoreCard ESC
ON ESCI.ESCI_No = ESC.ESC_No
WHERE ESCI.ESCI_User = @UserId
AND ESC.ESC_ID IS NULL

--经销商是否存在
Update EndoScoreCardInit
set ESCI_ErrorFlag = 1,ESCI_DealerName_ErrMsg =  N'经销商不存在'
where ESCI_User = @UserId
and ESCI_DMAID is null


--经销商该季度是否有单据
Update ESCI
set ESCI_ErrorFlag = 1,ESCI_Quarter_ErrMsg = N'经销商本季度没有评分单据'
from EndoScoreCardInit ESCI left join EndoScoreCard ESC
ON ESCI.ESCI_DMAID = ESC.ESC_DMA_ID
AND ESCI.ESCI_Year = ESC.ESC_Year
AND ESCI.ESCI_Quarter = ESC.ESC_Quarter
WHERE ESCI.ESCI_User = @UserId
AND ESC.ESC_ID IS NULL

--是否已经有周数信息
Update ESCI
set ESCI_ErrorFlag = 1,ESCI_Quarter_ErrMsg = N'本季度还没有上传[季度不上传周数]'
from EndoScoreCardInit ESCI left join Interface.T_I_QV_ScoreCard_KPI IT
ON ESCI.ESCI_DMAID = IT.DMA_ID
AND ESCI.ESCI_Year = IT.[Year]
AND ESCI.ESCI_Quarter = IT.[Quarter]
WHERE ESCI.ESCI_User = @UserId
AND IT.WeekUploadStaticValue is null



IF (SELECT COUNT(*) FROM EndoScoreCardInit WHERE ESCI_ErrorFlag = 1 AND ESCI_USER = @UserId) > 0
	BEGIN
		/*如果存在错误，则返回Error*/
		SET @IsValid = 'Error'
	END
ELSE
	BEGIN
		/*如果不存在错误，则返回Success*/		
		SET @IsValid = 'Success'
		
		create table #tmp_endoscorecard(
		TE_ID			uniqueidentifier not null,
		TE_DMA_ID		uniqueidentifier not null,
		TE_No			nvarchar(20) null,
		TE_Year			nvarchar(4) null,
		TE_Quarter		nvarchar(2) null,
		TE_Weeks		nvarchar(2) null,--季度不上传周数
 		TE_Score1		nvarchar(10) null,
		TE_Score2		nvarchar(10) null,
		TE_QuarterScore	nvarchar(4) null,--季度不上传周数得分
		TE_DataScore	nvarchar(4) null,--数据核实配合度得分
		TE_Remark		nvarchar(300) null
		)
		
		
		/*上传按钮不更新正式表，导入按钮才写*/
		IF @ImportType = 'Import'
		BEGIN
			--计算数据管理得分情况，配合则计算季度不上传周数分数+上报销量分数，不配合则得0分
			Insert into #tmp_endoscorecard
			select ESC_ID,ESCI_DMAID,ESCI_No,ESCI_Year,ESCI_Quarter,IT.WeekUploadStaticValue,replace(ESCI_Score1,'%',''),ESCI_Score2,IT.WeekUploadStaticScore,'0',ESCI_Remark
			from EndoScoreCardInit EI
			inner join Interface.T_I_QV_ScoreCard_KPI IT
			on EI.ESCI_DMAID = IT.DMA_ID
			AND EI.ESCI_Year = IT.Year
			AND EI.ESCI_Quarter = IT.[Quarter]
			inner join EndoScoreCard ESC
			on EI.ESCI_No = ESC.ESC_No
			WHERE ESCI_User = @UserId
			
			update #tmp_endoscorecard
			set TE_DataScore = case when TE_Score1 >= 90 then '10' else case when TE_Score1 >= 80 and TE_Score1 < 90 then '5' else '0' end end
			where TE_Score2 = '配合'
			
			update #tmp_endoscorecard
			set TE_DataScore = '0'
			where TE_Score2 = '不配合'
			
			--更新评分表中的分数
			Update ESC
			SET ESC_Score2 = 
				case when ESCI.TE_Score2 = '配合' 
					then  CONVERT(decimal(4),ESCI.TE_QuarterScore) + CONVERT(decimal(4),ESCI.TE_DataScore)
					else '0'
				end,
				ESC_GradeValue4 = ESCI.TE_Score1,
				ESC_GradeValue5 = ESCI.TE_Score2
			from EndoScoreCard ESC,#tmp_endoscorecard ESCI
			where ESC.ESC_DMA_ID = ESCI.TE_DMA_ID	
			and ESC.ESC_Year = ESCI.TE_Year
			and ESC.ESC_Quarter = ESCI.TE_Quarter
			and ESC.ESC_No = ESCI.TE_No
			
			--记录操作日志
			insert into ScoreCardlog
			select NEWID(),TE_ID,'系统管理员',GETDATE(),'上传数据管理评分',TE_Remark
			from #tmp_endoscorecard
			
			--清除中间表的数据
			DELETE FROM EndoScoreCardInit WHERE ESCI_USER = @UserId
		END
	END




COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    return -1
    
END CATCH


GO


