DROP  procedure [dbo].[GC_AutoGenScoreCard]
GO

CREATE procedure [dbo].[GC_AutoGenScoreCard]
as

declare @year nvarchar(4);
declare @month nvarchar(2);
declare @quarter int;

set @year = substring(convert(nvarchar(10),getdate(),112),1,4)
set @month = substring(convert(nvarchar(10),getdate(),112),5,2)

if @month = '04'
	begin
	set @quarter = 1
	end
else if @month = '07'
	begin
	set @quarter = 2
	end
else if @month = '10'
	begin
	set @quarter = 3
	end
else 
	begin
	set @quarter =4	
	end

--生成主单据
insert into EndoScoreCardHeader
select NEWID(),DCM_DMA_ID,ProductLineID,@year,@quarter,'','Submit',
'c763e69b-616f-4246-8480-9df40126057c',GETDATE(),null,null,null,null,null
from (
select distinct DCM_DMA_ID,ProductLineID
from DealerContractMaster,V_DivisionProductLineRelation
where DCM_Division = DivisionCode
and ProductLineID in ('8f15d92a-47e4-462f-a603-f61983d61b7b','e9da0666-2eda-4883-8f28-a24301255cc3')
) t

--生成明细数据
INSERT INTO EndoScoreCardDetail
select NEWID(),ESCH_ID,11,'合计','','','','',0,''
from EndoScoreCardHeader
where ESCH_Year = @year
and ESCH_Quarter = @quarter
and ESCH_BUM_ID in ('8f15d92a-47e4-462f-a603-f61983d61b7b','e9da0666-2eda-4883-8f28-a24301255cc3')
union
select NEWID(),ESCH_ID,10,'分数调整','','系统管理员调整','0','','',''
from EndoScoreCardHeader
where ESCH_Year = @year
and ESCH_Quarter = @quarter
and ESCH_BUM_ID in ('8f15d92a-47e4-462f-a603-f61983d61b7b','e9da0666-2eda-4883-8f28-a24301255cc3')

--生成单据号
DECLARE @DealerDMAID uniqueidentifier
DECLARE @BusinessUnitName uniqueidentifier
DECLARE @ID uniqueidentifier
DECLARE @PONumber nvarchar(50)

DECLARE	curHandlePONumber CURSOR 
FOR SELECT ESCH_ID,ESCH_DMA_ID,ESCH_BUM_ID,ESCH_No FROM EndoScoreCardHeader WHERE ESCH_Year=@year AND ESCH_Quarter = @quarter
FOR UPDATE of ESCH_No

OPEN curHandlePONumber
FETCH NEXT FROM curHandlePONumber INTO @ID,@DealerDMAID,@BusinessUnitName,@PONumber

WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		EXEC [GC_GetNextAutoNumberForESC] @DealerDMAID,'Next_ScoreCardNbr',@BusinessUnitName, @PONumber output
		UPDATE EndoScoreCardHeader
		SET ESCH_No = @PONumber
		WHERE ESCH_ID= @ID
	END
	FETCH NEXT FROM curHandlePONumber INTO @ID,@DealerDMAID,@BusinessUnitName,@PONumber
END

CLOSE curHandlePONumber
DEALLOCATE curHandlePONumber


       
GO


