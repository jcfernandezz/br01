USE [GBRA]
GO
/****** Object:  StoredProcedure [dbo].[SPED_Buscar_CuentasNivel]    Script Date: 1/22/2017 10:30:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SPED_Buscar_CuentasNivel]
	@Nivel1 as varchar(20),
	@Nivel2 as varchar(20),
	@Nivel3 as varchar(20),
	@Nivel4 as varchar(20),
	@AsignSI_NO as int		----- 1= Si y 0= No
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if @AsignSI_NO = 1 
	begin
		SELECT rtrim(cta.USERDEF1),rtrim(cta.USERDEF2) from GL00100 cta LEFT join spedtbl003 acta on cta.USERDEF1= acta.userdef1
		where RTRIM(acta.SPED_Nivel_1)+RTRIM(acta.SPED_Nivel_2)+RTRIM(acta.SPED_Nivel_3)+RTRIM(acta.SPED_Nivel_4) =
			RTRIM(@nivel1)+RTRIM(@nivel2)+RTRIM(@nivel3)+RTRIM(@nivel4) ----and acta.userdef1 is not null
			ORDER BY CTA.USERDEF1
	end
	else
	begin
		SELECT rtrim(cta.USERDEF1),rtrim(cta.USERDEF2),acta.USERDEF1 from gl00100 cta LEFT join spedtbl003 acta on cta.USERDEF1= acta.userdef1
		where ---RTRIM(acta.SPED_Nivel_1)+RTRIM(acta.SPED_Nivel_2)+RTRIM(acta.SPED_Nivel_3)+RTRIM(acta.SPED_Nivel_4)=
			----RTRIM(@nivel1)+RTRIM(@nivel2)+RTRIM(@nivel3)+RTRIM(@nivel4) and 
			acta.userdef1 is null ORDER BY CTA.USERDEF1
	end
END
