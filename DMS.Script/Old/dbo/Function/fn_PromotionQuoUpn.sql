
DROP FUNCTION [dbo].[fn_PromotionQuoUpn]
GO



CREATE FUNCTION [dbo].[fn_PromotionQuoUpn]
(@Dlid int,@Type nvarchar(50))
  RETURNS NVARCHAR(500)
as

Begin
declare @YesMess nvarchar(MAX) ;
declare @NoMess nvarchar(MAX) ;
declare @Restu nvarchar(MAX);
declare @NoRestu nvarchar(MAX); 
declare @RestuPN nvarchar(MAX) 
declare @NoRestuPN nvarchar(MAX) ;
DECLARE @Sql NVARCHAR(MAX);
DECLARE @Cola NVARCHAR(500);
DECLARE @Colb NVARCHAR(500);
DECLARE @TB TABLE
(
  CfnName NVARCHAR(100),
  Upn NVARCHAR(100),
  ID UNIQUEIDENTIFIER 
)
SET @YesMess='';
SET @NoMess='';
IF(@Type='ZP')
BEGIN
--包含产品upn

  select   @RestuPN=STUFF((SELECT  CAST('|'+A.ConditionValue AS NVARCHAR(MAX)) 
      FROM Promotion.PRO_DEALER_LARGESS_DETAIL A  WHERE A.ConditionId='1' AND A.DLid=@Dlid AND A.OperTag='包含' FOR XML PATH('')),1,1,'')

--不包含产品upn
  select   @NoRestuPN=STUFF((SELECT  CAST('|'+A.ConditionValue AS NVARCHAR(MAX)) 
      FROM Promotion.PRO_DEALER_LARGESS_DETAIL A  WHERE A.ConditionId='1' AND A.DLid=@Dlid AND A.OperTag='不包含' FOR XML PATH('')),1,1,'')
  
--包含产品分组
 
  select  @Restu=STUFF((SELECT  CAST('|'+A.ConditionValue AS NVARCHAR(MAX)) 
      FROM Promotion.PRO_DEALER_LARGESS_DETAIL A  WHERE A.ConditionId='3' AND A.DLid=@Dlid  AND  A.OperTag='包含'  FOR XML PATH('')),1,1,'')
      
 select  @nORestu=STUFF((SELECT  CAST('|'+A.ConditionValue AS NVARCHAR(MAX)) 
      FROM Promotion.PRO_DEALER_LARGESS_DETAIL A  WHERE A.ConditionId='3' AND A.DLid=@Dlid AND A.OperTag='不包含'  FOR XML PATH('')),1,1,'')     

    IF(@RestuPN<>'')
      BEGIN
      --拼接已包含UPN关联的产品
         SELECT @YesMess=@YesMess+STUFF((SELECT CAST(';'+A.CFN_CustomerFaceNbr AS NVARCHAR(MAX)) FROM CFN A INNER JOIN 
        (SELECT  ColA,ColB from [Promotion].[func_Pro_Utility_getStringSplit]
        (@RestuPN)) B
         ON A.CFN_CustomerFaceNbr=B.ColA FOR XML PATH('')),1,2,'')
      END
      IF(@NoRestuPN<>'')
        BEGIN
      --拼接不包含UPN关联的产品
       SELECT @NoMess=@NoMess+STUFF((SELECT CAST(';'+A.CFN_CustomerFaceNbr AS NVARCHAR(MAX)) FROM CFN A INNER JOIN 
        (SELECT  ColA,ColB from [Promotion].[func_Pro_Utility_getStringSplit]
        (@NoRestuPN)) B
         ON A.CFN_CustomerFaceNbr=B.ColA FOR XML PATH('')),1,2,'') 
        END 
         IF(@Restu<>'')
         BEGIN
        
         DECLARE SltCursor CURSOR FOR SELECT ColA,ColB FROM [Promotion].[func_Pro_Utility_getStringSplit](@Restu) 
         OPEN SltCursor
          	FETCH NEXT FROM SltCursor INTO @Cola,@Colb
          	  	WHILE @@FETCH_STATUS = 0
          	  	  BEGIN
          	  
          	  	IF(@Cola='Level1')
          	  	    BEGIN
          	  	    INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level1Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level1Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+ CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level1Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	    END
          	  	 ELSE IF(@Cola='Level2')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level2Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level2Code=@Colb
          	  	    -- SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+ CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level2Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	   ELSE IF(@Cola='Level3')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level3Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level3Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level3Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	    ELSE IF(@Cola='Level4')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level4Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level4Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level4Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	    ELSE IF(@Cola='Level5')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level5Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level5Code=@Colb
          	  	    -- SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level5Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END         
          	  	  --SELECT @YesMess=@YesMess+STUFF((SELECT CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE 'CFN.CFN_'+@Cola+''+'Code'=''''+@Colb+'''' FOR XML PATH('')),1,2,'') 
          	  	  --SELECT CFN.CFN_Level1Code FROM CFN
          	  	   --SELECT STUFF((SELECT CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN FOR XML PATH('')),1,2,'') 
          	  	    --SET @Sql=' SELECT @YesMess=@YesMess+STUFF((SELECT CAST('';''+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN ';
          	  	    --SET @Sql=@Sql + 'WHERE CFN.CFN_'+@Cola+''+'Code';
          	  	    --SET @Sql=@Sql + ' ='''+@Colb+'''';
          	  	    --SET @Sql=@Sql +' FOR XML PATH('''')),1,2,'''')'
          	  	   	FETCH NEXT FROM SltCursor INTO @Cola,@Colb
          	  	    --EXEC sp_executesql @Sql
          	  	  END
          	  	    CLOSE SltCursor
             DEALLOCATE SltCursor
              SELECT @YesMess=STUFF((SELECT distinct CAST(';'+ CfnName AS  NVARCHAR(MAX)) FROM @TB FOR XML PATH('')),1,2,'') 
         END 
          IF(@NoRestu<>'')
         BEGIN
       
         DECLARE SltCursorNo CURSOR FOR SELECT ColA,ColB FROM [Promotion].[func_Pro_Utility_getStringSplit](@NoRestu) 
         OPEN SltCursorNo
          	FETCH NEXT FROM SltCursorNo INTO @Cola,@Colb
          	  	WHILE @@FETCH_STATUS = 0
          	  	  BEGIN
          	  	  
          	  	 IF(@Cola='Level1')
          	  	    BEGIN
          	  	    INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level1Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level1Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+ CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level1Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	    END
          	  	 ELSE IF(@Cola='Level2')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level2Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level2Code=@Colb
          	  	    -- SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+ CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level2Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	   ELSE IF(@Cola='Level3')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level3Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level3Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level3Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	    ELSE IF(@Cola='Level4')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level4Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level4Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level4Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	    ELSE IF(@Cola='Level5')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level5Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level5Code=@Colb
          	  	    -- SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level5Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END         
          	  	  	--SET  @YesMess='B'
          	  	  -- SELECT @NoMess=@NoMess+STUFF((SELECT CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE 'CFN.CFN_'+@Cola+''+'Code'=''''+@Colb+'''' FOR XML PATH('')),1,2,'') 
          	  	  --SELECT CFN.CFN_Level1Code FROM CFN
          	  	   --SELECT STUFF((SELECT CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN FOR XML PATH('')),1,2,'') 
          	  	   -- SET @Sql=' SELECT @NoMess=@NoMess+STUFF((SELECT CAST('';''+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN ';
          	  	   --   SET @Sql=@Sql + 'WHERE CFN.CFN_'+@Cola+''+'Code';
          	  	   -- SET @Sql=@Sql + ' ='''+@Colb+'''';
          	  	   -- SET @Sql=@Sql +' FOR XML PATH('''')),1,2,'''')'
          	  	   	FETCH NEXT FROM SltCursorNo INTO @Cola,@Colb
          	  	   --EXEC sp_executesql @Sql
          	  	  END
          	  	    CLOSE SltCursorNo
             DEALLOCATE SltCursorNo
             SELECT @NoMess=STUFF((SELECT distinct CAST(';'+ CfnName AS  NVARCHAR(MAX)) FROM @TB FOR XML PATH('')),1,2,'') 
          END 
        
         END
     ELSE IF(@Type='JF')
     BEGIN
--包含产品upn

  select   @RestuPN=STUFF((SELECT  CAST('|'+A.ConditionValue AS NVARCHAR(MAX)) 
      FROM Promotion.PRO_DEALER_POINT_DETAIL A  WHERE A.ConditionId='1' AND A.DLid=@Dlid AND A.OperTag='包含' FOR XML PATH('')),1,1,'')

--不包含产品upn
  select   @NoRestuPN=STUFF((SELECT  CAST('|'+A.ConditionValue AS NVARCHAR(MAX)) 
      FROM Promotion.PRO_DEALER_POINT_DETAIL A  WHERE A.ConditionId='1' AND A.DLid=@Dlid AND A.OperTag='不包含' FOR XML PATH('')),1,1,'')
  
--包含产品分组
 
  select  @Restu=STUFF((SELECT  CAST('|'+A.ConditionValue AS NVARCHAR(MAX)) 
      FROM Promotion.PRO_DEALER_POINT_DETAIL A  WHERE A.ConditionId='3' AND A.DLid=@Dlid  AND  A.OperTag='包含'  FOR XML PATH('')),1,1,'')
      
 select  @nORestu=STUFF((SELECT  CAST('|'+A.ConditionValue AS NVARCHAR(MAX)) 
      FROM Promotion.PRO_DEALER_POINT_DETAIL A  WHERE A.ConditionId='3' AND A.DLid=@Dlid AND A.OperTag='不包含'  FOR XML PATH('')),1,1,'')     

    IF(@RestuPN<>'')
      BEGIN
      --拼接已包含UPN关联的产品
         SELECT @YesMess=@YesMess+STUFF((SELECT CAST(';'+A.CFN_CustomerFaceNbr AS NVARCHAR(MAX)) FROM CFN A INNER JOIN 
        (SELECT  ColA,ColB from [Promotion].[func_Pro_Utility_getStringSplit]
        (@RestuPN)) B
         ON A.CFN_CustomerFaceNbr=B.ColA FOR XML PATH('')),1,2,'')
      END
      IF(@NoRestuPN<>'')
        BEGIN
      --拼接不包含UPN关联的产品
       SELECT @NoMess=@NoMess+STUFF((SELECT CAST(';'+A.CFN_CustomerFaceNbr AS NVARCHAR(MAX)) FROM CFN A INNER JOIN 
        (SELECT  ColA,ColB from [Promotion].[func_Pro_Utility_getStringSplit]
        (@NoRestuPN)) B
         ON A.CFN_CustomerFaceNbr=B.ColA FOR XML PATH('')),1,2,'') 
        END 
         IF(@Restu<>'')
         BEGIN
        
         DECLARE SltCursor CURSOR FOR SELECT ColA,ColB FROM [Promotion].[func_Pro_Utility_getStringSplit](@Restu) 
         OPEN SltCursor
          	FETCH NEXT FROM SltCursor INTO @Cola,@Colb
          	  	WHILE @@FETCH_STATUS = 0
          	  	  BEGIN
          	  
          	  	IF(@Cola='Level1')
          	  	    BEGIN
          	  	    INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level1Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level1Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+ CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level1Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	    END
          	  	 ELSE IF(@Cola='Level2')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level2Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level2Code=@Colb
          	  	    -- SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+ CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level2Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	   ELSE IF(@Cola='Level3')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level3Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level3Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level3Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	    ELSE IF(@Cola='Level4')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level4Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level4Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level4Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	    ELSE IF(@Cola='Level5')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_Level5Desc,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level5Code=@Colb
          	  	    -- SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level5Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END         
          	  	  --SELECT @YesMess=@YesMess+STUFF((SELECT CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE 'CFN.CFN_'+@Cola+''+'Code'=''''+@Colb+'''' FOR XML PATH('')),1,2,'') 
          	  	  --SELECT CFN.CFN_Level1Code FROM CFN
          	  	   --SELECT STUFF((SELECT CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN FOR XML PATH('')),1,2,'') 
          	  	    --SET @Sql=' SELECT @YesMess=@YesMess+STUFF((SELECT CAST('';''+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN ';
          	  	    --SET @Sql=@Sql + 'WHERE CFN.CFN_'+@Cola+''+'Code';
          	  	    --SET @Sql=@Sql + ' ='''+@Colb+'''';
          	  	    --SET @Sql=@Sql +' FOR XML PATH('''')),1,2,'''')'
          	  	   	FETCH NEXT FROM SltCursor INTO @Cola,@Colb
          	  	    --EXEC sp_executesql @Sql
          	  	  END
          	  	    CLOSE SltCursor
             DEALLOCATE SltCursor
              SELECT @YesMess=STUFF((SELECT distinct CAST(';'+ CfnName AS  NVARCHAR(MAX)) FROM @TB FOR XML PATH('')),1,2,'') 
         END 
          IF(@NoRestu<>'')
         BEGIN
       
         DECLARE SltCursorNo CURSOR FOR SELECT ColA,ColB FROM [Promotion].[func_Pro_Utility_getStringSplit](@NoRestu) 
         OPEN SltCursorNo
          	FETCH NEXT FROM SltCursorNo INTO @Cola,@Colb
          	  	WHILE @@FETCH_STATUS = 0
          	  	  BEGIN
          	  	  
          	  	 IF(@Cola='Level1')
          	  	    BEGIN
          	  	    INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level1Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+ CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level1Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	    END
          	  	 ELSE IF(@Cola='Level2')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level2Code=@Colb
          	  	    -- SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+ CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level2Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	   ELSE IF(@Cola='Level3')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level3Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level3Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	    ELSE IF(@Cola='Level4')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level4Code=@Colb
          	  	     --SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level4Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END
          	  	    ELSE IF(@Cola='Level5')
          	  	   BEGIN
          	  	   INSERT INTO @TB(ID,CfnName,Upn) SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr FROM CFN WHERE CFN_Level5Code=@Colb
          	  	    -- SELECT @YesMess=@YesMess+STUFF((SELECT distinct CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE CFN.CFN_Level5Code=@Colb FOR XML PATH('')),1,2,'') 
          	  	   END         
          	  	  	--SET  @YesMess='B'
          	  	  -- SELECT @NoMess=@NoMess+STUFF((SELECT CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN WHERE 'CFN.CFN_'+@Cola+''+'Code'=''''+@Colb+'''' FOR XML PATH('')),1,2,'') 
          	  	  --SELECT CFN.CFN_Level1Code FROM CFN
          	  	   --SELECT STUFF((SELECT CAST(';'+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN FOR XML PATH('')),1,2,'') 
          	  	   -- SET @Sql=' SELECT @NoMess=@NoMess+STUFF((SELECT CAST('';''+CFN.CFN_ChineseName AS  NVARCHAR(MAX)) FROM CFN ';
          	  	   --   SET @Sql=@Sql + 'WHERE CFN.CFN_'+@Cola+''+'Code';
          	  	   -- SET @Sql=@Sql + ' ='''+@Colb+'''';
          	  	   -- SET @Sql=@Sql +' FOR XML PATH('''')),1,2,'''')'
          	  	   	FETCH NEXT FROM SltCursorNo INTO @Cola,@Colb
          	  	   --EXEC sp_executesql @Sql
          	  	  END
          	  	    CLOSE SltCursorNo
             DEALLOCATE SltCursorNo
             SELECT @NoMess=STUFF((SELECT distinct CAST(';'+ CfnName AS  NVARCHAR(MAX)) FROM @TB FOR XML PATH('')),1,2,'') 
          END 
        
         END
        
        DECLARE @Messing NVARCHAR(MAX);
         SET @Messing='';
         IF(@YesMess<>'')
          BEGIN
          SET @Messing='包含产品:'+@YesMess;
          END
          IF(@NoMess<>'')
          BEGIN
           SET @Messing=@Messing+';不包含产品:'+@NoMess;
          END
       RETURN @Messing;
      END
	
GO


