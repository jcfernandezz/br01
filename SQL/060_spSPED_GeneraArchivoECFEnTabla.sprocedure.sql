IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = 'dbo'
     AND SPECIFIC_NAME = 'SPED_GeneraArchivoECFEnTabla' 
)
   DROP PROCEDURE dbo.SPED_GeneraArchivoECFEnTabla;
GO

-- =========================================================================================================================
-- Prop�sito. Llama al stored procedure que genera los datos del SPED en la tabla spedtbl9000. El layout corresponde al a�o.
-- Requisito. -
--24/06/19 jcf Creaci�n
--24/03/20 jcf Agrega layout 6 para el a�o 2019
-- =========================================================================================================================

CREATE PROCEDURE [dbo].[SPED_GeneraArchivoECFEnTabla] 
	@IdCompa�ia varchar (8),
	@FechaDesde varchar(10),
	@FechaHasta varchar(10)
AS
BEGIN

	DECLARE @layout varchar(10)
	select @layout = parametros.param1
	from dbo.fSpedParametros('LAYOUTECF'+convert(varchar(4), YEAR(@FechaHasta)), 'na', 'na', 'na', 'na', 'na', 'SPED') parametros

	if (@layout = '500')		--ecf layout 5
		exec [dbo].[SPED_ArchivoTXT_ECF_l500] @IdCompa�ia, @FechaDesde, @FechaHasta; 
	else if (@layout = '600')		--ecf layout 6
		exec [dbo].[SPED_ArchivoTXT_ECF_l600] @IdCompa�ia, @FechaDesde, @FechaHasta; 
	else 
	begin
		delete from dbo.spedtbl9000;
		INSERT INTO dbo.spedtbl9000 (LINEA,seccion, datos) 
				values(0, 'err', 'Verifique los par�metros SPED en la configuraci�n de compa��a. No existe el layout para el a�o: ' + convert(varchar(4), YEAR(@FechaHasta)));
	end
End

GO
---------------------------------------------------------------------------------------------------------------------------------
IF (@@Error = 0) PRINT 'Creaci�n exitosa de: SPED_GeneraArchivoECFEnTabla'
ELSE PRINT 'Error en la creaci�n de: SPED_GeneraArchivoECFEnTabla'
GO


