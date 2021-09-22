USE [BSC_Prd]
GO
/****** Object:  StoredProcedure [dbo].[GC_GetNextAutoNumberForTender]    Script Date: 2018/1/24 14:24:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[GC_GetNextCFDANo]
	@ClientID		nvarchar(50),
	@Settings        NVarChar(50),
	@nextnbr    NVarChar(50) = '0' OUTPUT
AS
    DECLARE @LastIDDate NVARCHAR(50)
	declare @NextID NVARCHAR(50)
SET NOCOUNT ON

	--判断是否存在
	IF  EXISTS (SELECT 1 FROM InterfaceAutoNbrData WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Settings)
	 begin
	 select @NextID=IAND_NextID,@LastIDDate=IAND_AutoNbrDate from InterfaceAutoNbrData where IAND_ClientID=@ClientID and IAND_ATO_Setting = @Settings
	 end	 
	
	
	IF DATEDIFF(YY,@LastIDDate, getdate()) <> 0
	Begin
		Update InterfaceAutoNbrData Set IAND_AutoNbrDate = getdate(), IAND_NextID = '0' 
		WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Settings
		
		SET @NextID = '0'
	end
		
	--更新计数器
	UPDATE InterfaceAutoNbrData SET 
	IAND_NextID = Convert(nVarChar(50), Convert(Int, @NextID) + 1)
	WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Settings
     
	IF LEN(@NextID) < 4
	begin
	SET @nextnbr = @ClientID+'-'+Convert(nvarchar(4),getdate(),112) +'-' + REPLICATE('0',4-LEN(@NextID))+ convert(varchar(50),isnull(@NextID,'')) 
	end