<?xml version="1.0" encoding="UTF-8"?>
<!-- Order Price Report XSL Template -->
<!-- Pharma Version 1.7.3 (IT) -->
<!-- Owner: Gem Wu -->
<!-- Updated on 11/12/2013 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html>
	<head>
		<xsl:apply-templates select="PayloadRecord" mode="head" />
		<style type="text/css">
			body {

			}
			table {
			width:950px;
			border-collapse:collapse;
			font-family:sans-serif;
			font-size:11px;
			}
			td {
			padding:3px 7px 2px 7px;
			}
			#colheader {
			font-size:9px;
			background-color:0070C0;
			color:#ffffff;
			}
			#header {
			}
			#orderfooter {
			background-color:DDEBF7;
			text-align:left;
			}
			.bomheader {
			font-weight:bold;
			}
			.bomitem {
			}
			.notbom {
			}
			.discount {
			font-size:10px;
			}
		</style>
	</head>
	<body>
		<table id="report">
			<tr>
				<xsl:apply-templates select="PayloadRecord" mode="content" />
			</tr>
		</table>
	</body>
</html>
</xsl:template>

<!-- HTML head -->
<xsl:template match="PayloadRecord" mode="head">
	<xsl:variable name="vbeln" select="@vbeln" />
	<title>Order <xsl:value-of select="$vbeln" /></title>
	<meta property="VBELN" content="{$vbeln}" />
</xsl:template>

<!-- Report Content -->
<xsl:template match="PayloadRecord" mode="content">
	<xsl:apply-templates select="PayloadItem[@posnr='000000']" mode="header" />
	<table id="orderitem">
		<tr id="colheader">
			<td width="10%" rowspan="2">CODICE MATERIAL</td>
			<td width="10%" rowspan="2">EAN UV</td>
			<td width="25%" rowspan="2">DESCRIZIONE PRODOTTO</td>
			<td width="5%" align="right" rowspan="2">LISTINO</td>
			<td width="5%" align="center" rowspan="2">QTA ORDINATA</td>
			<td width="5%" align="center" rowspan="2">QTA CONFERMATA</td>
			<td width="5%" align="center" rowspan="2">UM DESCRIZIONE</td>
			<td width="5%" align="center" rowspan="2"># PEZZI</td>
			<td width="10%" rowspan="2">DATA DI CONSEGNA CONFERMATA</td>
			<td width="10%" align="right">NET EX CASSA</td>
			<td width="10%" align="right">PREZZO NETTO</td>
		</tr>
		<tr id="colheader">
			<td align="right">NET PZ EX CASSA</td>
			<td align="right">PREZZO NETTO PZ</td>
		</tr>
		<xsl:apply-templates select="PayloadItem[@posnr &gt;'000000']" mode="item" />
	</table>
	<xsl:apply-templates select="PayloadItem[@posnr='000000']" mode="footer" />
</xsl:template>

<!-- Report Content Header -->
<xsl:template match="PayloadItem" mode="header">
	<table id="orderheader">
		<tr>
			<td width="28%">
				PUNTO CONSEGNA:
				<xsl:value-of select="VBPA_AG_KUNNR/VALUE1" />
			</td>
			<td width="22%">
				<xsl:value-of select="VBAK_VKORG/VALUE1" />/<xsl:value-of select="VBAK_VTWEG/VALUE1" />/<xsl:value-of select="VBAK_SPART/VALUE1" />
			</td>
			<td width="25%">
				DATA CONSEGNA:
				<xsl:if test="VBAK_VDATU">
					<xsl:value-of select="substring(VBAK_VDATU/VALUE1,7,2)" />/<xsl:value-of select="substring(VBAK_VDATU/VALUE1,5,2)" />/<xsl:value-of select="substring(VBAK_VDATU/VALUE1,1,4)" />
				</xsl:if>				
			</td>
			<td width="25%">
				STATO ORDINE:
				<xsl:choose>
					<xsl:when test="VBUK_GBSTK/VALUE1 = 'A'">
						APERTO
					</xsl:when>
					<xsl:when test="VBUK_GBSTK/VALUE1 = 'B'">
						NON COMPLETO
					</xsl:when>
					<xsl:when test="VBUK_GBSTK/VALUE1 = 'C'">
						COMPLETO
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>
				<xsl:value-of select="VBPA_RE_NAME1/VALUE1" />
				&#160;
				<xsl:value-of select="VBPA_RE_NAME2/VALUE1" />
			</td>
			<td>
				RIF. ORDINE:
				<xsl:value-of select="VBAK_VBELN/VALUE1" />
			</td>
			<td>
				DATA ORDINE:
				<xsl:if test="VBAK_AUDAT">
					<xsl:value-of select="substring(VBAK_AUDAT/VALUE1,7,2)" />/<xsl:value-of select="substring(VBAK_AUDAT/VALUE1,5,2)" />/<xsl:value-of select="substring(VBAK_AUDAT/VALUE1,1,4)" />
				</xsl:if>
			</td>
			<td>
				BLOCCO LOGISTICO:
				<xsl:choose>
					<xsl:when test="VBUK_LSSTK/VALUE1 = 'A'">
						NO
					</xsl:when>
					<xsl:when test="VBUK_LSSTK/VALUE1 = 'B'">
						NO
					</xsl:when>
					<xsl:when test="VBUK_LSSTK/VALUE1 = 'C'">
						SI
					</xsl:when>
					<xsl:otherwise>
						NO
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>
				<xsl:value-of select="VBPA_RE_STREET/VALUE1" />
			</td>
			<td>
				RIF. ORDINE CLIENTE:
				<xsl:value-of select="VBKD_BSTKD/VALUE1" />
			</td>
			<td>
				DATA CREAZIONE ORDINE:
				<xsl:if test="VBAK_ERDAT">
					<xsl:value-of select="substring(VBAK_ERDAT/VALUE1,7,2)" />/<xsl:value-of select="substring(VBAK_ERDAT/VALUE1,5,2)" />/<xsl:value-of select="substring(VBAK_ERDAT/VALUE1,1,4)" />
				</xsl:if>
			</td>
			<td>
				BLOCCO AMMINISTRATIVO:
				<xsl:choose>
					<xsl:when test="VBUK_CMGST/VALUE1 = 'A'">
						NO
					</xsl:when>
					<xsl:when test="VBUK_CMGST/VALUE1 = 'B'">
						SI
					</xsl:when>
					<xsl:when test="VBUK_CMGST/VALUE1 = 'C'">
						SI
					</xsl:when>
					<xsl:when test="VBUK_CMGST/VALUE1 = 'D'">
						NO
					</xsl:when>
					<xsl:otherwise>
						NO
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>
				<xsl:value-of select="VBPA_RE_PCODE/VALUE1" />
				&#160;
				<xsl:value-of select="VBPA_RE_CITY/VALUE1" />
				&#160;
				<xsl:value-of select="VBPA_RE_REGION/VALUE1" />
			</td>
			<td colspan="3">
				TERMINI DI PAGAMENTO:
				<xsl:choose>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V153'">
						60GG DATA FATTURA SC. 0%
					</xsl:when>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V769'">
						60GG SC.0%
					</xsl:when>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V773'">
						60GG SC.0%
					</xsl:when>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V794'">
						60 GG F.M. SC. 0%
					</xsl:when>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V814'">
						14 GG SC.3%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V136'">
						90GG. DATA FATT. SC 0%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V185'">
						120 gg data fattura sc.0%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V814'">
						14 GG SC.3%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V510'">
						180GG SC. 0%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V771'">
						90GG SC.0%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V786'">
						120 gg data fattura sc.0%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V776'">
						90GG SC.0%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V769'">
						60GG SC.0%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'G022'">
						PAG. ANTICIPATO SC 0%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'J065'">
						PAG. ALLA CONSEGNA SC. 0%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V156'">
						30GG. DATA FATT. SC 2.5%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'T260'">
						30GG 1%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'T263'">
						30GG 2.5%
					</xsl:when>					
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V767'">
						30GG SC.2.5%
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="VBKD_ZTERM/VALUE1" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</table>
</xsl:template>

<!-- Report Content Footer -->
<xsl:template match="PayloadItem" mode="footer">
	<table id="orderfooter">
		<tr>
			<td width="25%">
				SCONTO CASSA:
				<xsl:choose>
					<xsl:when test="COND_ZKT5">
						<xsl:choose>
							<xsl:when test="contains(COND_ZKT5/VALUE1, '-')">
								<xsl:value-of select="format-number(translate(translate(COND_ZKT5/VALUE1, '- %', ''), ',','.'), '#0.00')" />%
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number(translate(COND_ZKT5/VALUE1, ' %', ''), '#0.00')" />%
							</xsl:otherwise>
						</xsl:choose>
						&#160;
						<xsl:choose>
							<xsl:when test="contains(COND_ZKT5/VALUE3, '-')">
								<xsl:value-of select="translate(translate(translate(COND_ZKT5/VALUE3, '-', ''),'.',''),',','.')" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="translate(translate(COND_ZKT5/VALUE3,'.',''),',','.')" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						0.00
						&#160;
						<xsl:value-of select="VBAK_WAERK/VALUE1" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="25%">
				TOTALE IMPONIBILE:
				<xsl:choose>
					<xsl:when test="VBAK_NETWR">
						<xsl:value-of select="format-number(VBAK_NETWR/VALUE1, '#0.00')" />
					</xsl:when>
					<xsl:otherwise>
						0.00
					</xsl:otherwise>
				</xsl:choose>
				&#160;
				<xsl:value-of select="VBAK_WAERK/VALUE1" />
			</td>
			<td width="25%">
				IVA:
				<xsl:choose>
					<xsl:when test="COND_MWST">
						<xsl:value-of select="format-number(translate(translate(translate(normalize-space(COND_MWST/VALUE3), VBAK_WAERK/VALUE1, ''),'.',''),',','.'),'#0.00')" />
					</xsl:when>
					<xsl:otherwise>
						0.00
					</xsl:otherwise>
				</xsl:choose>
				&#160;
				<xsl:value-of select="VBAK_WAERK/VALUE1" />
			</td>			
			<td width="25%">
				TOTALE IVA INCLUSA:
				<xsl:choose>
					<xsl:when test="COND_MWST">
						<xsl:value-of select="format-number(number(VBAK_NETWR/VALUE1) + number(translate(translate(translate(normalize-space(COND_MWST/VALUE3), VBAK_WAERK/VALUE1, ''),'.',''),',','.')),'#0.00')" />
					</xsl:when>
					<xsl:otherwise>
						0.00
					</xsl:otherwise>
				</xsl:choose>
				&#160;
				<xsl:value-of select="VBAK_WAERK/VALUE1" />
			</td>
		</tr>
	</table>
</xsl:template>

<!-- Report Line Item Details -->
<xsl:template match="PayloadItem" mode="item">
	<xsl:variable name="netvalue" select="VBAP_KZWI2/VALUE1" />
	<xsl:variable name="bomdisplay">
		<xsl:choose>
			<xsl:when test="VBAP_PSTYV/VALUE1 = 'ZACP'">
				bomheader
			</xsl:when>
			<xsl:when test="VBAP_PSTYV/VALUE1 = 'ZGN1'">
				bomitem
			</xsl:when>
			<xsl:otherwise>
				notbom
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="quantity"
		select="format-number(VBAP_KWMENG/VALUE1, '#0')" />
	<xsl:variable name="coversionunit"
		select="format-number(VBAP_UMVKZ/VALUE1, '#0')" />
	<xsl:variable name="paymentdiscount">
		<xsl:choose>
			<xsl:when test="COND_ZKT5">
				<xsl:choose>
					<xsl:when test="contains(COND_ZKT5/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZKT5/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						0.00
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="paymentdiscountpercentage">
		<xsl:choose>
			<xsl:when test="COND_ZKT5">
				<xsl:choose>
					<xsl:when test="contains(COND_ZKT5/VALUE1, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZKT5/VALUE1, '-'), '.', ''), ',', '.')) div 100" />
					</xsl:when>
					<xsl:otherwise>
						0.00
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="ztp0">
		<xsl:choose>
			<xsl:when test="COND_ZTP0">
				<xsl:choose>
					<xsl:when test="contains(COND_ZTP0/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZTP0/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZTP0/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="zfr0">
		<xsl:choose>
			<xsl:when test="COND_ZFR0">
				<xsl:choose>
					<xsl:when test="contains(COND_ZFR0/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZFR0/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZFR0/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="zcp2">
		<xsl:choose>
			<xsl:when test="COND_ZCP2">
				<xsl:choose>
					<xsl:when test="contains(COND_ZCP2/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZCP2/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZCP2/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="zqtx">
		<xsl:choose>
			<xsl:when test="COND_ZQTX">
				<xsl:choose>
					<xsl:when test="contains(COND_ZQTX/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZQTX/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZQTX/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="zqtz">
		<xsl:choose>
			<xsl:when test="COND_ZQTZ">
				<xsl:choose>
					<xsl:when test="contains(COND_ZQTZ/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZQTZ/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZQTZ/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="zk1f">
		<xsl:choose>
			<xsl:when test="COND_ZK1F">
				<xsl:choose>
					<xsl:when test="contains(COND_ZK1F/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZK1F/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZK1F/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="zk3f">
		<xsl:choose>
			<xsl:when test="COND_ZK3F">
				<xsl:choose>
					<xsl:when test="contains(COND_ZK3F/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZK3F/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZK3F/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="zcp0">
		<xsl:choose>
			<xsl:when test="COND_ZCP0">
				<xsl:choose>
					<xsl:when test="contains(COND_ZCP0/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZCP0/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZCP0/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="zk3e">
		<xsl:choose>
			<xsl:when test="COND_ZK3E">
				<xsl:choose>
					<xsl:when test="contains(COND_ZK3E/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZK3E/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZK3E/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="zdp7">
		<xsl:choose>
			<xsl:when test="COND_ZDP7">
				<xsl:choose>
					<xsl:when test="contains(COND_ZDP7/VALUE3, '-')">
						<xsl:value-of
							select="number(translate(translate(substring-before(COND_ZDP7/VALUE3, '-'), '.', ''), ',', '.'))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="format-number(translate(substring-before(COND_ZDP7/VALUE3, ','), '.', ''), '#0.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				0.00
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- End of variables definition -->

	<tr class="{$bomdisplay}">
		<td>
			<xsl:if test="VBAP_PSTYV/VALUE1 = 'ZGN1'">
				&#160;&#160;
			</xsl:if>
			<xsl:value-of select="number(VBAP_MATNR/VALUE1)" />
		</td>
		<td>
			<xsl:value-of select="VBAP_EAN11/VALUE1" />
		</td>
		<td>
			<xsl:value-of select="VBAP_ARKTX/VALUE1" />
		</td>
		<td align="right">
			<xsl:choose>
				<xsl:when test="COND_ZPP0/VALUE1">
					<xsl:value-of
						select="translate(translate(substring-before(COND_ZPP0/VALUE1, ' '),'.',''),',','.')" />
				</xsl:when>
				<xsl:otherwise>
					0.00
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<td align="center">
			<xsl:value-of select="$quantity" />
		</td>
		<td align="center">
			<xsl:value-of select="format-number(VBAP_KBMENG/VALUE1, '#0')" />
		</td>
		<td align="center">
			<xsl:value-of select="VBAP_VRKME/VALUE1" />
		</td>
		<td align="center">
			<xsl:value-of select="$coversionunit" />
			<!-- <xsl:value-of select="VBAP_MEINS/VALUE1" /> -->
		</td>
		<td>
			<xsl:for-each select="VBEP_EDATU">
				<xsl:sort select="." order="descending" />
				<xsl:if test="position() = 1">
					<xsl:if test="VALUE1">
						<xsl:value-of select="substring(VALUE1,7,2)" />/<xsl:value-of select="substring(VALUE1,5,2)" />/<xsl:value-of select="substring(VALUE1,1,4)" />
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</td>
		<td align="right">
			<xsl:value-of select="$netvalue" />
		</td>
		<td align="right">
			<xsl:value-of select="format-number($netvalue - $paymentdiscount, '#0.00')" />
		</td>
	</tr>
	<tr class="discount">
		<td colspan="9">
			&#160;&#160;
			<xsl:if test="$ztp0 &gt; 0">
				<xsl:value-of select="COND_ZTP0/VALUE1" />
				&#160;Contractual Discount&#160;
			</xsl:if>
			<xsl:if test="$zfr0 &gt; 0">
				<xsl:value-of select="COND_ZFR0/VALUE1" />
				&#160;WE tester free&#160;
			</xsl:if>
			<xsl:if test="$zcp2 &gt; 0">
				<xsl:value-of select="COND_ZCP2/VALUE1" />
				&#160;SC.NAT.ARTT.15-21 DPR 633/72&#160;
			</xsl:if>
			<xsl:if test="$zqtx &gt; 0">
				<xsl:value-of select="COND_ZQTX/VALUE1" />
				&#160;SCONTO QUANTITA’&#160;
			</xsl:if>
			<xsl:if test="$zqtz &gt; 0">
				<xsl:value-of select="COND_ZQTZ/VALUE1" />
				&#160;SCONTO QUANTITA' &#160;
			</xsl:if>
			<xsl:if test="$zk1f &gt; 0">
				<xsl:value-of select="COND_ZK1F/VALUE1" />
				&#160;SC.RIDUZIONE PREZZO&#160;
			</xsl:if>
			<xsl:if test="$zk3f &gt; 0">
				<xsl:value-of select="COND_ZK3F/VALUE1" />
				&#160;SC.RIDUZIONE PREZZO&#160;
			</xsl:if>
			<xsl:if test="$zcp0 &gt; 0">
				<xsl:value-of select="COND_ZCP0/VALUE1" />
				&#160;SC.RIDUZIONE PREZZO&#160;
			</xsl:if>
			<xsl:if test="$zk3e &gt; 0">
				<xsl:value-of select="COND_ZK3E/VALUE1" />
				&#160;SC.RIDUZIONE PREZZO&#160;
			</xsl:if>
			<xsl:if test="$zdp7 &gt; 0">
				<xsl:value-of select="COND_ZK3E/VALUE1" />
				&#160;SC.RIDUZIONE PREZZO&#160;
			</xsl:if>
		</td>
		<td align="right">
			<xsl:value-of select="format-number(number(VBAP_NETPR/VALUE1) * (1+$paymentdiscountpercentage), '#0.00')" />
		</td>
		<td align="right">
			<xsl:value-of
				select="format-number(number(VBAP_NETPR/VALUE1), '#0.00')" />
		</td>
	</tr>
</xsl:template>

</xsl:stylesheet>
