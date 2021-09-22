DROP FUNCTION [dbo].[fn_GetConsignmentDiscount]
GO




CREATE FUNCTION [dbo].[fn_GetConsignmentDiscount] (
@DEALERID NVARCHAR(36), @DATETYPE nvarchar(100),@VALUE1 nvarchar(100),@VALUE2 nvarchar(100))

   RETURNS  decimal(18,5)
AS
   BEGIN
      DECLARE @DiscountValue  DECIMAL(18,5)
      IF EXISTS(SELECT 1 FROM DealerMaster WHERE DMA_Taxpayer='直销医院' AND DMA_ID=@DEALERID)
      BEGIN
		SET @DiscountValue=1.0
      END
      ELSE
      BEGIN
      
		  IF @DATETYPE='QRCode'
		  BEGIN
			--c.JudgmentLeft,c.LeftValue,c.JudgmentRight,c.RightValue
	      
			IF EXISTS(SELECT 1 FROM [dbo].[ConsignmentDiscountRule] A WHERE A.QRCode=@VALUE1)
				BEGIN
				--通过二维码确认具体产品有效期
				 SELECT TOP(1) @DiscountValue=ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
				  INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
				  INNER JOIN dbo.ConsignmentDiscountRule c on c.QRCode=a.LTM_QrCode
				  WHERE A.LTM_QrCode=@VALUE1  
				  AND C.DealerId=@DEALERID
				  AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
				  AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
				  AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
				  ORDER BY C.CreateDate DESC
				  
				  IF ISNULL(@DiscountValue,1.0)=1.0
				  BEGIN
					 SELECT TOP(1) @DiscountValue=ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
					  INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
					  INNER JOIN dbo.ConsignmentDiscountRule c on c.QRCode=a.LTM_QrCode
					  WHERE A.LTM_QrCode=@VALUE1  
					  --AND C.DealerId=@DEALERID
					  AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
					  AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
					  AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
					  ORDER BY C.CreateDate DESC
				  END
				  
				END
			IF NOT EXISTS(SELECT 1 FROM [dbo].[ConsignmentDiscountRule] A WHERE A.QRCode=@VALUE1)
				BEGIN
					--二维码不能打折，查看UPN(不设置lot号的)（指定经销商）
					SELECT TOP(1) @DiscountValue= ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
						INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
						INNER JOIN CFN ON CFN.CFN_ID=B.PMA_CFN_ID
						INNER JOIN dbo.ConsignmentDiscountRule c on c.UPN=cfn.CFN_CustomerFaceNbr
					WHERE A.LTM_QrCode=@VALUE1 and isnull(c.LOT,'')='' and isnull(c.QRCode ,'')=''
						AND C.DealerId=@DEALERID
						AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
						AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
						AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
						ORDER BY C.CreateDate DESC
						
						--（不指定经销商）	
					  IF ISNULL(@DiscountValue,1.0)=1.0
					  BEGIN
						SELECT TOP(1) @DiscountValue= ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
						INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
						INNER JOIN CFN ON CFN.CFN_ID=B.PMA_CFN_ID
						INNER JOIN dbo.ConsignmentDiscountRule c on c.UPN=cfn.CFN_CustomerFaceNbr
						WHERE A.LTM_QrCode=@VALUE1 and isnull(c.LOT,'')='' and isnull(c.QRCode ,'')=''
						AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
						AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
						AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
						ORDER BY C.CreateDate DESC
					  END	
				END
		  END
		  ELSE IF @DATETYPE='Lot'
		  BEGIN
				--@VALUE1=UPN；@VALUE2=LOT
				
				IF EXISTS(SELECT 1 FROM [dbo].[ConsignmentDiscountRule] A inner join CFN B ON A.UPN=B.CFN_CustomerFaceNbr WHERE B.CFN_ID=@VALUE1 AND A.LOT=@VALUE2)
				BEGIN
					-- UPN,LOT 最大折扣(最小值)
					SELECT TOP(1) @DiscountValue= ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
						INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
						INNER JOIN CFN ON CFN.CFN_ID=B.PMA_CFN_ID
						INNER JOIN dbo.ConsignmentDiscountRule c on c.UPN=cfn.CFN_CustomerFaceNbr and c.LOT=LTM_LotNumber
					WHERE CFN.CFN_ID=@VALUE1 and isnull(c.LOT,'')=@VALUE2 and isnull(c.QRCode ,'')=''
						AND C.DealerId=@DEALERID
						AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
						AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
						AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
						ORDER BY C.CreateDate DESC
						
						
					--（不指定经销商）	
					IF ISNULL(@DiscountValue,1.0)=1.0
					BEGIN
						SELECT TOP(1) @DiscountValue= ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
						INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
						INNER JOIN CFN ON CFN.CFN_ID=B.PMA_CFN_ID
						INNER JOIN dbo.ConsignmentDiscountRule c on c.UPN=cfn.CFN_CustomerFaceNbr and c.LOT=LTM_LotNumber
						WHERE CFN.CFN_ID=@VALUE1 and isnull(c.LOT,'')=@VALUE2 and isnull(c.QRCode ,'')=''
						AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
						AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
						AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
						ORDER BY C.CreateDate DESC
					END	
					
				END
				ELSE
				BEGIN
					-- UPN,LOT不能打折，查看UPN(不设置lot号的)
					SELECT TOP(1) @DiscountValue= ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
						INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
						INNER JOIN CFN ON CFN.CFN_ID=B.PMA_CFN_ID
						INNER JOIN dbo.ConsignmentDiscountRule c on c.UPN=cfn.CFN_CustomerFaceNbr --and c.LOT=LTM_LotNumber
					WHERE CFN.CFN_ID=@VALUE1 and isnull(c.LOT,'')='' and isnull(c.QRCode ,'')=''
						AND C.DealerId=@DEALERID
						AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
						AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
						AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
						ORDER BY C.CreateDate DESC
				
					--（不指定经销商）	
					IF ISNULL(@DiscountValue,1.0)=1.0
					BEGIN
						SELECT TOP(1) @DiscountValue= ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
						INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
						INNER JOIN CFN ON CFN.CFN_ID=B.PMA_CFN_ID
						INNER JOIN dbo.ConsignmentDiscountRule c on c.UPN=cfn.CFN_CustomerFaceNbr --and c.LOT=LTM_LotNumber
						WHERE CFN.CFN_ID=@VALUE1 and isnull(c.LOT,'')='' and isnull(c.QRCode ,'')=''
						AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
						AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
						AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
						ORDER BY C.CreateDate DESC
					END	
					
				END
		  END
		  ELSE IF @DATETYPE='UPN'
		  BEGIN
				-- UPN 最大折扣(最小值)
				SELECT TOP(1) @DiscountValue= ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
					INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
					INNER JOIN CFN ON CFN.CFN_ID=B.PMA_CFN_ID
					INNER JOIN dbo.ConsignmentDiscountRule c on c.UPN=cfn.CFN_CustomerFaceNbr
				WHERE CFN.CFN_ID=@VALUE1 and isnull(c.LOT,'')='' and isnull(c.QRCode ,'')=''
					AND C.DealerId=@DEALERID
					AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
					AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
					AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
					ORDER BY C.CreateDate DESC
				
					--（不指定经销商）	
					IF ISNULL(@DiscountValue,1.0)=1.0
					BEGIN
						SELECT TOP(1) @DiscountValue= ISNULL(c.DiscountValue,1.0) FROM V_LotMaster a
						INNER JOIN Product b on a.LTM_Product_PMA_ID=b.PMA_ID
						INNER JOIN CFN ON CFN.CFN_ID=B.PMA_CFN_ID
						INNER JOIN dbo.ConsignmentDiscountRule c on c.UPN=cfn.CFN_CustomerFaceNbr
						WHERE CFN.CFN_ID=@VALUE1 and isnull(c.LOT,'')='' and isnull(c.QRCode ,'')=''
						AND (ISNULL(c.LeftValue,'')='' OR (ISNULL(c.LeftValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) >= c.LeftValue))
						AND (ISNULL(c.RightValue,'')='' OR (ISNULL(c.RightValue,'')<>'' and  datediff(DAY,getdate(),a.LTM_ExpiredDate) < c.RightValue))
						AND GETDATE() BETWEEN C.BeginDate AND C.EndDate
						ORDER BY C.CreateDate DESC
					END	
				
		  END
		  
		  IF ISNULL(@DiscountValue,1.0)=1.0
		  BEGIN
			IF @DATETYPE='UPN' OR @DATETYPE='Lot'
				--SELECT TOP(1) @DiscountValue= ISNULL(B.DiscountValue,1.0) FROM (
				--SELECT CFN_CustomerFaceNbr,DivisionCode,'LEVEL1' PctLevel,CFN_Level1Code PctLevelCode FROM CFN INNER JOIN V_DivisionProductLineRelation ON CFN_ProductLine_BUM_ID =ProductLineID AND IsEmerging='0' WHERE CFN_ID=@VALUE1
				--UNION
				--SELECT CFN_CustomerFaceNbr,DivisionCode,'LEVEL2',CFN_Level2Code FROM CFN INNER JOIN V_DivisionProductLineRelation ON CFN_ProductLine_BUM_ID =ProductLineID AND IsEmerging='0' WHERE CFN_ID=@VALUE1
				--UNION
				--SELECT CFN_CustomerFaceNbr,DivisionCode,'LEVEL3',CFN_Level3Code FROM CFN INNER JOIN V_DivisionProductLineRelation ON CFN_ProductLine_BUM_ID =ProductLineID AND IsEmerging='0' WHERE CFN_ID=@VALUE1
				--UNION
				--SELECT CFN_CustomerFaceNbr,DivisionCode,'LEVEL4',CFN_Level4Code FROM CFN INNER JOIN V_DivisionProductLineRelation ON CFN_ProductLine_BUM_ID =ProductLineID AND IsEmerging='0' WHERE CFN_ID=@VALUE1
				--UNION
				--SELECT CFN_CustomerFaceNbr,DivisionCode,'LEVEL5',CFN_Level5Code FROM CFN INNER JOIN V_DivisionProductLineRelation ON CFN_ProductLine_BUM_ID =ProductLineID AND IsEmerging='0' WHERE CFN_ID=@VALUE1
				--) Tab
				--INNER JOIN dbo.ProductDiscountRule B ON Tab.PctLevel=B.PctLevel AND Tab.PctLevelCode=B.PctLevelCode AND CONVERT(NVARCHAR(10),B.BU)=Tab.DivisionCode
				--INNER JOIN CFN ON CFN.CFN_CustomerFaceNbr=Tab.CFN_CustomerFaceNbr
				--INNER JOIN Product C on CFN.CFN_ID=C.PMA_CFN_ID
				--INNER JOIN V_LotMaster D ON D.LTM_Product_PMA_ID=C.PMA_ID
				--WHERE CFN.CFN_ID=@VALUE1
				--	AND (ISNULL(B.LeftValue,'')='' OR (ISNULL(B.LeftValue,'')<>'' and  datediff(DAY,getdate(),D.LTM_ExpiredDate) >= B.LeftValue))
				--	AND (ISNULL(B.RightValue,'')='' OR (ISNULL(B.RightValue,'')<>'' and  datediff(DAY,getdate(),D.LTM_ExpiredDate) < B.RightValue))
				--	AND GETDATE() BETWEEN B.BeginDate AND B.EndDate
				
				SELECT TOP(1) @DiscountValue= ISNULL(A.DiscountValue,1.0) 
					FROM dbo.ProductDiscountRule A 
					INNER JOIN V_DivisionProductLineRelation B ON B.DivisionCode=A.BU
					INNER JOIN CFN ON B.ProductLineID=CFN.CFN_ProductLine_BUM_ID AND CFN.CFN_ID=@VALUE1
					INNER JOIN Product C on CFN.CFN_ID=C.PMA_CFN_ID
					INNER JOIN V_LotMaster D ON D.LTM_Product_PMA_ID=C.PMA_ID and(ISNULL(@VALUE2,'')='' OR D.LTM_LotNumber=@VALUE2)
					WHERE 
						(ISNULL(A.LeftValue,'')='' OR (ISNULL(A.LeftValue,'')<>'' AND  datediff(DAY,getdate(),D.LTM_ExpiredDate) >= A.LeftValue))
						AND (ISNULL(A.RightValue,'')='' OR (ISNULL(A.RightValue,'')<>'' AND  datediff(DAY,getdate(),D.LTM_ExpiredDate) < A.RightValue))
						AND GETDATE() BETWEEN A.BeginDate AND A.EndDate
						AND EXISTS (SELECT 1 FROM dbo.func_DiscountRule_getUPN(a.ID) ttt  WHERE ttt.UPN=CFN.CFN_CustomerFaceNbr)
					ORDER BY a.BeginDate DESC;
				
		  END
	  END
	  
      SET @DiscountValue=ISNULL(@DiscountValue,1.0);
      RETURN @DiscountValue;
   END



GO


