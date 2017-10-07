/****** Object:  StoredProcedure [dbo].[SPED_VerificarBalance]    Script Date: 13/09/2017 08:23:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[SPED_VerificarBalance] 
	@Year1 as int,
	@Comentario as varchar(250) out,
	@error as int out
AS
BEGIN
	if isnull((select sum(o.perdblnc) from GL10110 O
	where o.YEAR1=@Year1),0)+isnull((select sum(o.perdblnc) from GL10111 O
	where o.YEAR1=@Year1),0)=0
	begin
		set @comentario='Balan�o OK'
		set @error=0
	end
	else 
	begin
		set @Comentario='Erro Balan�o'
		set @error=1
	end
END

GRANT EXECUTE ON SPED_VerificarBalance TO DYNGRP