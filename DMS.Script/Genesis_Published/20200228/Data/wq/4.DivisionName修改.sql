
UPDATE dbo.Lafite_ATTRIBUTE SET ATTRIBUTE_NAME='BSC-CARDIO' WHERE Id='0a85a0ad-b130-48c1-a6ab-9d6d00fb589f'
UPDATE dbo.Lafite_ATTRIBUTE SET ATTRIBUTE_NAME='BSC-ENDO' WHERE Id='2097969e-c553-44cf-b1e0-9d6d00fb9347'
UPDATE dbo.Lafite_ATTRIBUTE SET ATTRIBUTE_NAME='RQ-Surgical' WHERE Id='eaa755a6-ba41-4947-8c3c-aaee013a46e5'
UPDATE dbo.Lafite_ATTRIBUTE SET ATTRIBUTE_NAME='KDL-VA' WHERE Id='c95a2a93-9b45-494c-a38a-aaee013a8ec4'
UPDATE dbo.Lafite_ATTRIBUTE SET ATTRIBUTE_NAME='FLKM-Surgical' WHERE Id='ae8c3f9f-f8ae-4538-9832-aaee013ac47d'

UPDATE ContractAmendment SET CAM_Division='BSC-CARDIO' WHERE CAM_Division='Cardio'
UPDATE ContractAmendment SET CAM_Division='BSC-ENDO' WHERE CAM_Division='Endo'
UPDATE ContractAmendment SET CAM_Division='FLKM-Surgical' WHERE CAM_Division='FR-Surgical'
UPDATE ContractAmendment SET CAM_Division='KDL-VA' WHERE CAM_Division='IC'
UPDATE ContractAmendment SET CAM_Division='RQ-Surgical' WHERE CAM_Division='RQ_Surgical'

UPDATE ContractAppointment SET CAP_Division='BSC-CARDIO' WHERE CAP_Division='Cardio'
UPDATE ContractAppointment SET CAP_Division='BSC-ENDO' WHERE CAP_Division='Endo'
UPDATE ContractAppointment SET CAP_Division='FLKM-Surgical' WHERE CAP_Division='FR-Surgical'
UPDATE ContractAppointment SET CAP_Division='KDL-VA' WHERE CAP_Division='IC'
UPDATE ContractAppointment SET CAP_Division='RQ-Surgical' WHERE CAP_Division='RQ_Surgical'

UPDATE ContractRenewal SET CRE_Division='BSC-CARDIO' WHERE CRE_Division='Cardio'
UPDATE ContractRenewal SET CRE_Division='BSC-ENDO' WHERE CRE_Division='Endo'
UPDATE ContractRenewal SET CRE_Division='FLKM-Surgical' WHERE CRE_Division='FR-Surgical'
UPDATE ContractRenewal SET CRE_Division='KDL-VA' WHERE CRE_Division='IC'
UPDATE ContractRenewal SET CRE_Division='RQ-Surgical' WHERE CRE_Division='RQ_Surgical'

UPDATE ContractTermination SET CTE_Division='BSC-CARDIO' WHERE CTE_Division='Cardio'
UPDATE ContractTermination SET CTE_Division='BSC-ENDO' WHERE CTE_Division='Endo'
UPDATE ContractTermination SET CTE_Division='FLKM-Surgical' WHERE CTE_Division='FR-Surgical'
UPDATE ContractTermination SET CTE_Division='KDL-VA' WHERE CTE_Division='IC'
UPDATE ContractTermination SET CTE_Division='RQ-Surgical' WHERE CTE_Division='RQ_Surgical'

UPDATE t_DivisionProductLineRelation SET DivisionName='BSC-CARDIO' WHERE DivisionName='Cardio'
UPDATE t_DivisionProductLineRelation SET DivisionName='BSC-ENDO' WHERE DivisionName='Endo'
UPDATE t_DivisionProductLineRelation SET DivisionName='KDL-VA' WHERE DivisionName='KDL'
UPDATE t_DivisionProductLineRelation SET DivisionName='FLKM-Surgical' WHERE DivisionName='Frankman'
UPDATE t_DivisionProductLineRelation SET DivisionName='RQ-Surgical' WHERE DivisionName='Reach'

--需要同步修改积分中的BU信息
--SELECT BU,* FROM Promotion.PRO_DEALER_POINT
--需要同步修改赠品中的BU信息
--SELECT BU,* FROM PROMOTION.PRO_DEALER_LARGESS