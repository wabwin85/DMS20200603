DROP  PROCEDURE [dbo].[GC_PurchaseOrderBSC_BeforeSubmit]
GO

/*
�����ύǰ���
*/
CREATE PROCEDURE [dbo].[GC_PurchaseOrderBSC_BeforeSubmit]
   @PohId          UNIQUEIDENTIFIER,
   @DealerId       UNIQUEIDENTIFIER,  
   @PromotionPolicyID NVARCHAR (100), 
   @PriceType      NVARCHAR (100),
   @OrderType      NVARCHAR (100),
   @RtnVal         NVARCHAR (20) OUTPUT,
   @RtnMsg         NVARCHAR (1000) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER
   
   	CREATE TABLE #TMP_PRO(
	Dlid NVARCHAR(200),
	QTY decimal(14,2)
	PRIMARY KEY (Dlid)
	)
 
--insert into hua(PohId,DealerId,CfnString,DealerType,OrderType,SpecialPriceId) 
--values(@PohId,@DealerId,@PromotionPolicyID,@PriceType,@OrderType,'')

	---------------Promotion-- ������Only -----------
	Declare @PRCode nvarchar(50)
		   ,@PRPQty int,@PRFreeQty int
		   ,@IsBundle bit, @IsSuit bit
		   ,@PurchaseQty int,@FreeQty int --������ѡ��Ĺ�����������Ʒ����
	
	---����������ʹ��ʱ����Ҫ����������͵��ж�-----
	--select @PRCode=PMP_Code from PromotionPolicy where PromotionPolicy.PMP_ID=@PromotionPolicyID
	--                                                   and DMAID=@DealerId
	--select @IsBundle=IsBundle from  PromotionPolicy
	--join Interface.T_I_EW_PromotionRules b on PRCode=PMP_Code
	-- where PromotionPolicy.PMP_ID=@PromotionPolicyID and DMAID=@DealerId
	 
	--select @IsSuit=IsSuit from  PromotionPolicy
	--join Interface.T_I_EW_PromotionRules b on PRCode=PMP_Code
	-- where PromotionPolicy.PMP_ID=@PromotionPolicyID and DMAID=@DealerId
	 
 --  	select @PRPQty=PurchaseQty from PromotionPolicy
	-- where PromotionPolicy.PMP_ID=@PromotionPolicyID and DMAID=@DealerId and @IsBundle=0
	 	 	                                                   
	--select @PRFreeQty=b.FreeQty from PromotionPolicy
	--join Interface.T_I_EW_PromotionRules b on PRCode=PMP_Code
	-- where PromotionPolicy.PMP_ID=@PromotionPolicyID and DMAID=@DealerId and @IsSuit=0	                                            	                                                   
  ------------------------------------------
   

   CREATE TABLE #TMP_CHECK
   (
      CfnId           UNIQUEIDENTIFIER,
      ArticleNumber   NVARCHAR (30),
      CfnQty          DECIMAL (18, 6),
      CfnAmount       DECIMAL (18, 6),
      ErrorDesc       NVARCHAR (50),
      IsReg           BIT--,
      --PRIMARY KEY (CfnId)
   )

   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''

      IF EXISTS (SELECT 1 FROM PurchaseOrderDetail WHERE POD_POH_ID = @PohId)
         BEGIN
            INSERT INTO #TMP_CHECK
               SELECT C.CFN_ID,
                      C.CFN_CustomerFaceNbr,
                      D.POD_RequiredQty,
                      D.POD_Amount,
                      NULL,
                      NULL
                 FROM PurchaseOrderDetail AS D
                      INNER JOIN CFN AS C ON C.CFN_ID = D.POD_CFN_ID
                WHERE D.POD_POH_ID = @PohId
               ORDER BY C.CFN_CustomerFaceNbr

			--����Ǵ�������ȷ���Ƿ���ϴ�����������
			If(@OrderType = 'PRO')
			BEGIN
			INSERT INTO #TMP_PRO(Dlid,QTY)
			SELECT A.Dlid,(B.LargessAmount-B.OrderAmount+B.OtherAmount-A.QTY) AS QTY 
			FROM (SELECT POD_Field3 AS Dlid ,SUM(POD_RequiredQty) AS QTY FROM PurchaseOrderDetail WHERE POD_POH_ID=@PohId  GROUP BY POD_Field3 ) a 
			left join Promotion.PRO_DEALER_LARGESS b ON A.Dlid=CONVERT(NVARCHAR(100),B.DLid);
			
			UPDATE A  SET ErrorDesc = ArticleNumber + '���Ͳ�Ʒ����������'
			FROM #TMP_CHECK  A, #TMP_PRO B ,(SELECT DISTINCT POD_CFN_ID CFNId,POD_Field3 AS DLid FROM PurchaseOrderDetail) C 
			WHERE ErrorDesc IS NULL AND A.CfnId=C.CFNId AND B.Dlid=C.DLid AND B.QTY <0
			end
			
            --����Ʒ��Ȩ
            UPDATE #TMP_CHECK
               SET ErrorDesc = ArticleNumber + '��Ȩδͨ��'
             WHERE     ErrorDesc IS NULL
                   AND dbo.GC_Fn_CFN_CheckDealerAuth (@DealerId, CfnId) = 0

            --����Ƿ�ɶ���
            IF @PriceType = 'DealerSpecial'
              UPDATE #TMP_CHECK
                 SET ErrorDesc = ArticleNumber + '���ɶ���'
               WHERE     ErrorDesc IS NULL
                   AND dbo.GC_Fn_CFN_CheckBSCDealerCanOrder(@DealerId, CfnId, 'Dealer') = 0
            ELSE
              UPDATE #TMP_CHECK
                 SET ErrorDesc = ArticleNumber + '���ɶ���'
               WHERE     ErrorDesc IS NULL
                   AND dbo.GC_Fn_CFN_CheckBSCDealerCanOrder(@DealerId, CfnId, @PriceType) = 0

             --��鶩�������ͽ���Ƿ����0
            UPDATE #TMP_CHECK
               SET ErrorDesc = ArticleNumber + '���������������0,��������ڻ����0'
             WHERE ErrorDesc IS NULL AND (CfnQty <= 0 OR CfnAmount < 0)
            
          
            --����Ƿ������Чע��֤��Ϣ
            --UPDATE #TMP_CHECK
            --   SET IsReg = dbo.GC_Fn_CFN_CheckRegistration (ArticleNumber)
            -- WHERE ErrorDesc IS NULL
           
            --�����ָ�����Ŷ����Ƿ��¼��LOG��
            /*
            Declare @cnt int;
            Declare @type nvarchar(30);
            SELECT @cnt = COUNT(pa.POH_ID),@type = poh.POH_OrderType 
            FROM PurchaseOrderHeader poh 
            LEFT JOIN PurchaseOrderHeader_AutoGenLog pa ON poh.POH_ID = pa.POH_ID
            WHERE poh.POH_ID= @PohId
            group by poh.POH_OrderType            
			
      			If(@cnt = 0 and @OrderType = 'ClearBorrowManual')
      			BEGIN
      				UPDATE #TMP_CHECK 
      				SET ErrorDesc = '��ָ�����Ŷ��������ֹ��ύ'
      				WHERE ErrorDesc IS NULL
      			
      			END
		     */
			If(@OrderType = 'PRO')
			BEGIN
				--UPDATE #TMP_CHECK 
				--SET ErrorDesc = '�������������ֹ��ύ'
				--WHERE ErrorDesc IS NULL
				insert into PurchaseOrderHeader_AutoGenLog 
				select POH_ID,
					   POH_OrderNo,
					   POH_ProductLine_BUM_ID,
					   POH_DMA_ID,
					   POH_VendorID,
					   POH_TerritoryCode,
					   POH_RDD,
					   POH_ContactPerson,
					   POH_Contact,
					   POH_ContactMobile,
					   POH_Consignee,
					   POH_ShipToAddress,
					   POH_ConsigneePhone,
					   POH_Remark ,
					   POH_InvoiceComment,
					   POH_CreateType,
					   POH_CreateUser,
					   POH_CreateDate,
					   POH_UpdateUser,
					   POH_UpdateDate,
					   POH_SubmitUser,
					   POH_SubmitDate,
					   POH_LastBrowseUser,
					   POH_LastBrowseDate,
					   POH_OrderStatus,
					   POH_LatestAuditDate,
					   POH_IsLocked,
					   POH_SAP_OrderNo,
					   POH_SAP_ConfirmDate,
					   POH_LastVersion,
					   POH_OrderType,
					   POH_VirtualDC,
					   POH_SpecialPriceID,
					   POH_WHM_ID ,
					   POH_POH_ID,
					   null from PurchaseOrderHeader a where a.POH_ID=@PohId 
				and not exists (select 1 from PurchaseOrderHeader_AutoGenLog b where b.POH_ID=a.POH_ID)
			END  
			
			
			/*
		   ------Promotion------------------
            ----------Bundle(Yes)&&Suit(No)
            Declare @Result int, @BundlePQty int

			select PurchaseQty=SUM(CfnQty),
			       PQty=case when qty<>0 then convert(int,SUM(CfnQty))/Qty
			              else null end
			       into #PQty 
			       from #TMP_CHECK
			inner join Interface.T_I_EW_PromotionProduct p on p.PRCode=@PRCode 
			           and p.UPN=ArticleNumber
	        where CfnAmount<>0 and @IsBundle=1
	        group by Rownumber,Qty
	         
	           
	        set @BundlePQty=
	          (select min(PQty) from #PQty where 
	            (select count(*) from #PQty)=(select count(distinct Rownumber) from 
	            Interface.T_I_EW_PromotionProduct p where p.PRCode=@PRCode)
	            and @IsBundle=1)
	        set @Result=@BundlePQty*@PRFreeQty
	         
	        select @FreeQty=sum(CfnQty) from #TMP_CHECK
	        inner join Interface.T_I_EW_PromotionFreeGoods p on p.PRCode=@PRCode 
	        and p.UPN=ArticleNumber
	        where CfnAmount=0 and @IsSuit=0
	       
	        UPDATE #TMP_CHECK SET ErrorDesc = 'Promotion:����ӵĲ�Ʒ��ϸ�����ϴ������ߵ�Ҫ�����޸ĺ��ύ'
			WHERE ErrorDesc IS NULL and @PromotionPolicyID is not null
			and @IsBundle=1 and @IsSuit=0
			and (@Result<>@FreeQty or isnull(@Result,0)=0)

	      ------------Bundle(Yes)&&Suit(Yes)   
	        select Rownumber,
			       PQty=@BundlePQty*Qty
			       into #FQty from interface.T_I_EW_PromotionFreeGoods p 
	        where p.PRCode=@PRCode  and @IsBundle=1
	        group by Rownumber,Qty 
	        
	       select Rownumber,PQty=SUM(CfnQty) into #DealerQty from #TMP_CHECK
	        inner join interface.T_I_EW_PromotionFreeGoods p on 
	         p.PRCode=@PRCode and p.UPN=ArticleNumber
	       where CfnAmount=0 and @IsSuit=1
	       group by Rownumber
	       
	       select f.PQTY into #check from #FQty f
	         left join #DealerQty d
	         on f.Rownumber=d.Rownumber
	         where isnull(f.PQty,0)<>isnull(d.PQty,0) or isnull(f.PQty,0)=0
	        
	        UPDATE #TMP_CHECK SET ErrorDesc = 'Promotion:����ӵĲ�Ʒ��ϸ�����ϴ������ߵ�Ҫ�����޸ĺ��ύ'
			WHERE ErrorDesc IS NULL and @PromotionPolicyID is not null
			and @IsBundle=1 and @IsSuit=1
			and exists (select 1 from #check)
	        
	       ------------Bundle(No)&&Suit(Yes)----
	       Declare @Multiple int, @MultipleFree int
	       	select @PurchaseQty=convert(int,SUM(CfnQty)) from #TMP_CHECK
	        inner join Interface.T_I_EW_PromotionProduct p on p.PRCode=@PRCode and p.UPN=ArticleNumber
	         and CfnAmount<>0 and @IsBundle=0
	         
	       set @Multiple=@PurchaseQty/@PRPQty
	         
	       select FQty=SUM(CfnQty)/Qty into #SQty from #TMP_CHECK
	        inner join interface.T_I_EW_PromotionFreeGoods p on 
	         p.PRCode=@PRCode and p.UPN=ArticleNumber
	       where CfnAmount=0 and @IsSuit=1
	       group by Rownumber,Qty
	       
	       set @MultipleFree=(select top 1 FQty from #SQty where 
	                   (select COUNT(1) from #SQty)=(select COUNT(distinct Rownumber) from interface.T_I_EW_PromotionFreeGoods p where 
	         p.PRCode=@PRCode)
	         and (select count(distinct FQty) from #SQty)=1 and @IsSuit=1)
	       
	        UPDATE #TMP_CHECK SET ErrorDesc = 'Promotion:����ӵĲ�Ʒ��ϸ�����ϴ������ߵ�Ҫ�����޸ĺ��ύ'
			WHERE ErrorDesc IS NULL and @PromotionPolicyID is not null
			and @IsBundle=0 and @IsSuit=1
			and (ISNULL(@Multiple,0)<>ISNULL(@MultipleFree,0) or ISNULL(@MultipleFree,0)=0)
	       
	       ------------Bundle(No)&&Suit(No)----
			UPDATE #TMP_CHECK SET ErrorDesc = 'Promotion:��Ҫ���'+convert(nvarchar(20),@PRPQty-@PurchaseQty)+'����Ʒ��������Ʒ'
			WHERE ErrorDesc IS NULL and @PromotionPolicyID is not null
			and @IsBundle=0 and @IsSuit=0 and @PurchaseQty<@PRPQty
			
			and @FreeQty>@PurchaseQty/@PRPQty*@PRFreeQty
			UPDATE #TMP_CHECK SET ErrorDesc = 'Promotion:������Ʒ����̫��'
			WHERE ErrorDesc IS NULL and @PromotionPolicyID is not null
			and @IsBundle=0 and @IsSuit=0
			and @FreeQty>@PurchaseQty/@PRPQty*@PRFreeQty
			
			UPDATE #TMP_CHECK SET ErrorDesc = 'Promotion:������Ʒδ����'
			WHERE ErrorDesc IS NULL and @PromotionPolicyID is not null
			and @IsBundle=0 and @IsSuit=0
			and @FreeQty<@PurchaseQty/@PRPQty*@PRFreeQty
			
	
			UPDATE #TMP_CHECK SET ErrorDesc = 'Promotion:��ѡ���˴������ߵ�δ�����Ʒ����Ʒ�۸�Ӧ�ֶ���Ϊ0��'
			WHERE ErrorDesc IS NULL and @PromotionPolicyID is not null and ISNULL(@FreeQty,0)=0
			--and @PurchaseQty>@PRPQty
			and @IsBundle=0 and @IsSuit=0
		   
		    --Check Promotion Price
		    UPDATE #TMP_CHECK SET ErrorDesc = 'Promotion:��Ʒ�۸�Ӧ�ֶ���Ϊ0��������Ʒ�۸��ܸ���'
		    from #TMP_CHECK 
		    join CFNPrice on CfnId=CFNP_CFN_ID and CFNP_Group_ID=@DealerId
		    and CFNP_DeletedFlag=0 and CFNP_PriceType='Dealer'
			WHERE ErrorDesc IS NULL and @PromotionPolicyID is not null 
			and @PromotionPolicyID<>'00000000-0000-0000-0000-000000000000'
			and convert(decimal(18,6),CfnAmount)<>convert(decimal(18,6),CFNP_Price*CfnQty)
			and CfnAmount<>0
			  
			  --select * from #TMP_CHECK
			  
			  --select * from #TMP_CHECK 
		   -- join CFNPrice on CfnId=CFNP_CFN_ID and CFNP_Group_ID=@DealerId
		   -- and CFNP_DeletedFlag=0 and CFNP_PriceType='Dealer'
			  
			 select ArticleNumber into #checkprice from  #TMP_CHECK 
			 left join interface.T_I_EW_PromotionFreeGoods p on 
	         p.PRCode=@PRCode and p.UPN=ArticleNumber
	         where CfnAmount=0 and UPN is null
	         
	        UPDATE #TMP_CHECK SET ErrorDesc = 'Promotion:����Ʒ�⣬������Ʒ�۸���Ϊ0'
		    from #TMP_CHECK 
			WHERE ErrorDesc IS NULL and @PromotionPolicyID is not null 
			and @PromotionPolicyID<>'00000000-0000-0000-0000-000000000000'
			and exists (select 1 from #checkprice)
			 
			--print @FreeQty
			--print @PurchaseQty print @PRPQty print @PRFreeQty
		   ----------------------------------------------
			*/
			
            --ƴ�Ӵ�����Ϣ
            SET @RtnMsg =
                   ISNULL ( (SELECT ErrorDesc + '$$'
                               FROM #TMP_CHECK
                              WHERE ErrorDesc IS NOT NULL and ErrorDesc not like '%Promotion:%'
                             ORDER BY ArticleNumber
                             FOR XML PATH ( '' )),
                           '')
            --------Promotion-----------  
            if ISNULL(@RtnMsg,'')=''
            begin        
             SET @RtnMsg =
                  isnull((SELECT top 1 ErrorDesc 
                               FROM #TMP_CHECK
                              WHERE ErrorDesc IS NOT NULL and ErrorDesc like '%Promotion:%'),'')
            end            
                       
            ---------------------------     
         END
      ELSE
         SET @RtnMsg = '����Ӳ�Ʒ'

      IF LEN (@RtnMsg) > 0
         SET @RtnVal = 'Error'
      ELSE
         IF EXISTS
               (SELECT 1
                  FROM #TMP_CHECK
                 WHERE ErrorDesc IS NULL AND IsReg = 0)
            BEGIN
               --ƴ�Ӿ�����Ϣ
               SET @RtnVal = 'Warn'
               SET @RtnMsg =
                        (SELECT ArticleNumber + '$$'
                           FROM #TMP_CHECK
                          WHERE ErrorDesc IS NULL AND IsReg = 0
                         ORDER BY ArticleNumber
                         FOR XML PATH ( '' ))
                      + '��Ʒ��δ���ע�ᣬ������ѧ��չʾ֮�ã����ý������ۡ�'
            END
            
      IF @RtnVal = 'Success' and @PriceType = 'DealerSpecial' 
        BEGIN
          
          Declare @StdAmount decimal(18,6)
          Declare @OrderAmount decimal(18,6)
          
          select @StdAmount = sum(t1.POD_RequiredQty * isnull(t2.CFNP_Price,0))  from PurchaseOrderDetail t1, CFNPrice t2
          where t1.POD_CFN_ID=t2.CFNP_CFN_ID
          and t2.CFNP_Group_ID = @DealerId
          and POD_POH_ID=@PohId
          and t2.CFNP_PriceType='Dealer'
          
          select @OrderAmount = sum(isnull(POD_Amount,0)) from PurchaseOrderDetail where POD_POH_ID=@PohId
          
          update PurchaseOrderDetail set POD_Field2= Convert(nvarchar(50),Convert(decimal(18,6),@OrderAmount/@StdAmount)) where POD_POH_ID=@PohId
          
          --Discount should less than 70%
          --IF (LEN(@RtnMsg)= 0 and Convert(decimal(18,6),@OrderAmount/@StdAmount)<0.8) and (select DMA_DealerType from DealerMaster where DMA_ID=@DealerId)='LP'
          --  BEGIN
          --    SET @RtnVal = 'Error'
          --    SET @RtnMsg = '�ۿ��ʲ��ܴ���20%'
          --  END
        END
      
      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @RtnVal = 'Failure'
      
       
      declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	

	set @RtnMsg=@vError
      RETURN -1
   END CATCH
GO


