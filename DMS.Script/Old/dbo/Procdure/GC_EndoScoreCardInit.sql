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


--�����Ƿ����
Update ESCI
set ESCI_ErrorFlag = 1,ESCI_No_ErrMsg = N'���ֵ��ݺŲ�����'
from EndoScoreCardInit ESCI left join EndoScoreCard ESC
ON ESCI.ESCI_No = ESC.ESC_No
WHERE ESCI.ESCI_User = @UserId
AND ESC.ESC_ID IS NULL

--�������Ƿ����
Update EndoScoreCardInit
set ESCI_ErrorFlag = 1,ESCI_DealerName_ErrMsg =  N'�����̲�����'
where ESCI_User = @UserId
and ESCI_DMAID is null


--�����̸ü����Ƿ��е���
Update ESCI
set ESCI_ErrorFlag = 1,ESCI_Quarter_ErrMsg = N'�����̱�����û�����ֵ���'
from EndoScoreCardInit ESCI left join EndoScoreCard ESC
ON ESCI.ESCI_DMAID = ESC.ESC_DMA_ID
AND ESCI.ESCI_Year = ESC.ESC_Year
AND ESCI.ESCI_Quarter = ESC.ESC_Quarter
WHERE ESCI.ESCI_User = @UserId
AND ESC.ESC_ID IS NULL

--�Ƿ��Ѿ���������Ϣ
Update ESCI
set ESCI_ErrorFlag = 1,ESCI_Quarter_ErrMsg = N'�����Ȼ�û���ϴ�[���Ȳ��ϴ�����]'
from EndoScoreCardInit ESCI left join Interface.T_I_QV_ScoreCard_KPI IT
ON ESCI.ESCI_DMAID = IT.DMA_ID
AND ESCI.ESCI_Year = IT.[Year]
AND ESCI.ESCI_Quarter = IT.[Quarter]
WHERE ESCI.ESCI_User = @UserId
AND IT.WeekUploadStaticValue is null



IF (SELECT COUNT(*) FROM EndoScoreCardInit WHERE ESCI_ErrorFlag = 1 AND ESCI_USER = @UserId) > 0
	BEGIN
		/*������ڴ����򷵻�Error*/
		SET @IsValid = 'Error'
	END
ELSE
	BEGIN
		/*��������ڴ����򷵻�Success*/		
		SET @IsValid = 'Success'
		
		create table #tmp_endoscorecard(
		TE_ID			uniqueidentifier not null,
		TE_DMA_ID		uniqueidentifier not null,
		TE_No			nvarchar(20) null,
		TE_Year			nvarchar(4) null,
		TE_Quarter		nvarchar(2) null,
		TE_Weeks		nvarchar(2) null,--���Ȳ��ϴ�����
 		TE_Score1		nvarchar(10) null,
		TE_Score2		nvarchar(10) null,
		TE_QuarterScore	nvarchar(4) null,--���Ȳ��ϴ������÷�
		TE_DataScore	nvarchar(4) null,--���ݺ�ʵ��϶ȵ÷�
		TE_Remark		nvarchar(300) null
		)
		
		
		/*�ϴ���ť��������ʽ�����밴ť��д*/
		IF @ImportType = 'Import'
		BEGIN
			--�������ݹ���÷�������������㼾�Ȳ��ϴ���������+�ϱ�������������������0��
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
			where TE_Score2 = '���'
			
			update #tmp_endoscorecard
			set TE_DataScore = '0'
			where TE_Score2 = '�����'
			
			--�������ֱ��еķ���
			Update ESC
			SET ESC_Score2 = 
				case when ESCI.TE_Score2 = '���' 
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
			
			--��¼������־
			insert into ScoreCardlog
			select NEWID(),TE_ID,'ϵͳ����Ա',GETDATE(),'�ϴ����ݹ�������',TE_Remark
			from #tmp_endoscorecard
			
			--����м�������
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


