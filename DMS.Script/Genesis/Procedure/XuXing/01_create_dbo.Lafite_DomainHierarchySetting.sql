SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


CREATE procedure Lafite_DomainHierarchySetting @DomainId UNIQUEIDENTIFIER ,
     @DomainType NVARCHAR(50) ,
     @OperateType NVARCHAR(50) ,
     @OperateUser NVARCHAR(50) ,
     @AppId NVARCHAR(50) ,
     @IsValid NVARCHAR(2000) = 'Success' OUTPUT as
BEGIN

		/********参数取值************
		@DomainType 对象类型:
			Attribute	组织节点
			Identity	人员
		@OperateType	操作类型:
			Delete		删除
			Active		有效
			InActive	失效
		*****************************/
    
        SET NOCOUNT ON

        BEGIN TRY
			
            DECLARE @TranCounter INT
            SET @TranCounter = @@TRANCOUNT
            IF @TranCounter > 0
                SAVE TRANSACTION S_ImportTransfer
            ELSE
                BEGIN TRAN T_ImportTransfer
	
            SET @IsValid = 'Success'

			--删属性
            IF @DomainType = 'Attribute'
                BEGIN
            
					--获取要删除的节点下的所有节点及岗位
                    WITH    OrganizationUnits ( AttributeId, AttributeName, AttributeType, AttributeLevel, ParentID, RootID )
                              AS ( SELECT   LA.[Id] AS AttributeId ,
                                            LA.[ATTRIBUTE_NAME] AS AttributeName ,
                                            LA.[ATTRIBUTE_TYPE] AS AttributeType ,
                                            LA.[ATTRIBUTE_LEVEL] AS AttributeLevel ,
                                            LA.[Id] AS ParentId ,
                                            @DomainId AS RootId
                                   FROM     Lafite_ATTRIBUTE LA
                                   WHERE    LA.DELETE_FLAG = 0
                                            AND LA.[ATTRIBUTE_TYPE] <> 'Role'
                                            AND LA.[Id] = @DomainId
                                            AND LA.APP_ID = @AppId
                                   UNION ALL
                                   SELECT   LA.[Id] AS AttributeId ,
                                            LA.[ATTRIBUTE_NAME] AS AttributeName ,
                                            LA.[ATTRIBUTE_TYPE] AS AttributeType ,
                                            LA.[ATTRIBUTE_LEVEL] AS AttributeLevel ,
                                            OU.AttributeId AS ParentId ,
                                            @DomainId RootId
                                   FROM     OrganizationUnits OU
                                            INNER JOIN dbo.Lafite_ATTRIBUTE_RELATION R1 ON R1.ATTRIBUTE1_ID = OU.AttributeId
                                            INNER JOIN Lafite_ATTRIBUTE LA ON R1.ATTRIBUTE2_ID = LA.Id
                                   WHERE    LA.[ATTRIBUTE_TYPE] <> 'Role'
                                            AND LA.APP_ID = @AppId
                                    --AND LA.DELETE_FLAG = 0
                                 )
                        SELECT  *
                        INTO    #OrganizationUnits
                        FROM    OrganizationUnits

                    IF @OperateType = 'Delete'
                        BEGIN
							--解除岗位与人的关系
                            DELETE  lim
							--SELECT  *
                            FROM    dbo.Lafite_IDENTITY_MAP lim
                            WHERE   lim.MAP_TYPE <> 'Role'
                                    AND EXISTS ( SELECT 1
                                                 FROM   #OrganizationUnits org
                                                 WHERE  lim.MAP_ID = org.AttributeId )

							--解除岗位与医院的关系，待添加

							--解除组织节构关系
                            DELETE  lar
							--SELECT  *
                            FROM    dbo.Lafite_ATTRIBUTE_RELATION lar
                            WHERE   lar.ATTRIBUTE2_ID IN (
                                    SELECT  AttributeId
                                    FROM    #OrganizationUnits )

							--Attribute设置删除标志
                            UPDATE  [Lafite_ATTRIBUTE]
                            SET     [DELETE_FLAG] = '1' ,
                                    [LAST_UPDATE_USER] = @OperateUser ,
                                    [LAST_UPDATE_DATE] = GETDATE()
                            WHERE   Id IN ( SELECT  AttributeId
                                            FROM    #OrganizationUnits )
                        END

                    IF @OperateType = 'InActive'
                        BEGIN
							--设置人员在岗结束日期为过期
						    UPDATE lim
							SET lim.VALID_DATE_END = GETDATE()
                            FROM    dbo.Lafite_IDENTITY_MAP lim
                            WHERE   lim.MAP_TYPE = 'Position'
									AND lim.VALID_DATE_END > GETDATE()
                                    AND EXISTS ( SELECT 1
                                                 FROM   #OrganizationUnits org
                                                 WHERE  lim.MAP_ID = org.AttributeId )

							--设置岗位有效期为过期
							UPDATE lar
							SET lar.VALID_DATE_END = GETDATE()
                            FROM    dbo.Lafite_ATTRIBUTE_RELATION lar
                            WHERE   lar.RELATION_TYPE = 'Position'
									AND lar.VALID_DATE_END > GETDATE() 
									AND lar.ATTRIBUTE2_ID IN (
                                    SELECT  AttributeId
                                    FROM    #OrganizationUnits )

							--设置属性为无效
							UPDATE  [Lafite_ATTRIBUTE]
                            SET     [BOOLEAN_FLAG] = '0' ,
                                    [LAST_UPDATE_USER] = @OperateUser ,
                                    [LAST_UPDATE_DATE] = GETDATE()
                            WHERE   Id IN ( SELECT  AttributeId
                                            FROM    #OrganizationUnits )
                        END
                    
					IF @OperateType = 'Active'
                        BEGIN
							--设置人员在岗结束日期为过期
						    UPDATE lim
							SET lim.VALID_DATE_END = DATEADD(SECOND,-1,'2200-1-1')
                            FROM    dbo.Lafite_IDENTITY_MAP lim
                            WHERE   lim.MAP_TYPE = 'Position'
                                    AND EXISTS ( SELECT 1
                                                 FROM   #OrganizationUnits org
                                                 WHERE  lim.MAP_ID = org.AttributeId )

							--设置岗位有效期为过期
							UPDATE lar
							SET lar.VALID_DATE_END = DATEADD(SECOND,-1,'2200-1-1')
                            FROM    dbo.Lafite_ATTRIBUTE_RELATION lar
                            WHERE   lar.RELATION_TYPE = 'Position'
									AND lar.ATTRIBUTE2_ID IN (
                                    SELECT  AttributeId
                                    FROM    #OrganizationUnits )

							--设置属性为有效
							UPDATE  [Lafite_ATTRIBUTE]
                            SET     [BOOLEAN_FLAG] = '1' ,
                                    [LAST_UPDATE_USER] = @OperateUser ,
                                    [LAST_UPDATE_DATE] = GETDATE()
                            WHERE   Id IN ( SELECT  AttributeId
                                            FROM    #OrganizationUnits )
                        END
                END
            

            IF @DomainType = 'Identity'
                BEGIN
					IF @OperateType = 'Delete'
					BEGIN
                        DELETE 
						FROM    dbo.Lafite_IDENTITY_MAP
						WHERE   IDENTITY_ID = @DomainId
								AND APP_ID = @AppId

						UPDATE  dbo.Lafite_IDENTITY
						SET     [DELETE_FLAG] = '1' ,
								[LAST_UPDATE_USER] = @OperateUser ,
								[LAST_UPDATE_DATE] = GETDATE()
						WHERE   Id = @DomainId
								AND APP_ID = @AppId
					END
                END

    
            COMMIT TRAN

            SET NOCOUNT OFF
            RETURN 1

        END TRY

        BEGIN CATCH 

            SELECT  @IsValid = 'ERROR_MESSAGE:' + ERROR_MESSAGE()
                    + ' ERROR_NUMBER:' + CAST(ERROR_NUMBER() AS NVARCHAR)
                    + ' ERROR_SEVERITY:' + CAST(ERROR_SEVERITY() AS NVARCHAR)
                    + ' ERROR_STATE:' + CAST(ERROR_STATE() AS NVARCHAR)
                    + ' ERROR_LINE:' + CAST(ERROR_LINE() AS NVARCHAR)

            SET NOCOUNT OFF
            
            IF @TranCounter > 0
                ROLLBACK TRANSACTION S_ImportTransfer
            ELSE
                ROLLBACK TRANSACTION T_ImportTransfer

            RETURN -1
    
        END CATCH

    END

GO

