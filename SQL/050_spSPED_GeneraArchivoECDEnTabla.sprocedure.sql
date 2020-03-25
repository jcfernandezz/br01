IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = 'dbo'
     AND SPECIFIC_NAME = 'SPED_GeneraArchivoECDEnTabla' 
)
   DROP PROCEDURE dbo.SPED_GeneraArchivoECDEnTabla;
GO

-- =========================================================================================================================
-- Prop�sito. Llama al stored procedure que genera los datos del SPED en la tabla spedtbl9000. El layout corresponde al a�o.
-- Requisito. -
--24/06/19 jcf Creaci�n
--18/03/20 jcf Agrega layout 800
-- =========================================================================================================================


CREATE PROCEDURE dbo.SPED_GeneraArchivoECDEnTabla
	@IdCompania varchar (8),
	@FechaDesde varchar(10),
	@FechaHasta varchar(10)
AS
BEGIN
	DECLARE @layout varchar(10);
	select @layout = parametros.param1
	from dbo.fSpedParametros('LAYOUT'+convert(varchar(4), YEAR(@FechaHasta)), 'na', 'na', 'na', 'na', 'na', 'SPED') parametros;

	if (@layout = '600')		--ecd layout v600
		exec [dbo].[SPED_ArchivoTXT_l600] @IdCompania, @FechaDesde, @FechaHasta; 
	else if (@layout = '800')		--ecd layout v800
		exec [dbo].[SPED_ArchivoTXT_l800] @IdCompania, @FechaDesde, @FechaHasta; 
	else
		begin 
			delete from spedtbl9000;
			INSERT INTO spedtbl9000 (LINEA,seccion, datos) 
					values(0, 'err', 'Verifique la versi�n de layout SPED en la configuraci�n de compa��a. No existe para el a�o: '+ convert(varchar(4), YEAR(@FechaHasta)));
		end
END
go

grant execute on [dbo].SPED_GeneraArchivoECDEnTabla to DYNGRP;
GO
---------------------------------------------------------------------------------------------------------------------------------
IF (@@Error = 0) PRINT 'Creaci�n exitosa de: SPED_GeneraArchivoECDEnTabla'
ELSE PRINT 'Error en la creaci�n de: SPED_GeneraArchivoECDEnTabla'
GO

