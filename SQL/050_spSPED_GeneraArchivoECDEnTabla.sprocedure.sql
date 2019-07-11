USE [GBRA]
GO
-- =========================================================================================================================
-- Prop�sito. Llama al stored procedure que genera los datos del SPED en la tabla spedtbl9000. El layout corresponde al a�o.
-- Requisito. -
--24/6/19 jcf Creaci�n
-- =========================================================================================================================

create PROCEDURE [dbo].SPED_GeneraArchivoECDEnTabla 
	@IdCompa�ia varchar (8),
	@FechaDesde varchar(10),
	@FechaHasta varchar(10)
AS
BEGIN

	DECLARE @layout varchar(10)
	select @layout = parametros.param1
	from dbo.fSpedParametros('LAYOUT'+convert(varchar(4), YEAR(@FechaHasta)), 'na', 'na', 'na', 'na', 'na', 'SPED') parametros

	if (@layout = '600')		--ecd layout v600
		exec [dbo].[SPED_ArchivoTXT_l600] @IdCompa�ia, @FechaDesde, @FechaHasta; 
	else 
		INSERT INTO spedtbl9000 (LINEA,seccion, datos) 
				values(0, 'err', 'Verifique los par�metros SPED en la configuraci�n de compa��a: ' + @layout);
End
go

grant execute on [dbo].SPED_GeneraArchivoECDEnTabla to DYNGRP;
GO