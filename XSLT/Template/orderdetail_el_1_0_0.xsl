<?xml version="1.0" encoding="UTF-8"?>
<!-- Order Price Report XSL Template -->
<!-- PHARMA Version 1.8.8 (IT) -->
<!-- Owner: GEM WU -->
<!-- Updated on 13/03/2014 -->
<!-- Updated on 24-FEB-2015 building VAT sum from header (not: item, as this is sometimes not idential with VBAK header -->
<!-- Updated on 08-APR-2015 by Marcel masuhr (Y&R Group Switzerland AG, marcel.masuhr@yrbrands.com) Translated labels from IT template (including payment terms, discounts not included) -->

<!-- change begin on 24-FEB-2015 -->
<!-- <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl"> 

<xsl:variable name="mwstsum"> 
   <xsl:for-each select="/PayloadRecord/PayloadItem[@posnr = '000000']/COND_MWST">
       <number><xsl:value-of select="number(translate(translate(translate(VALUE3, '.', ''), ',', '.'), 'EUR', ''))"/></number>
   </xsl:for-each>  
</xsl:variable>
<!-- change end on 24-FEB-2015 -->

<xsl:variable name="version">Price Report V1.0.0 (GR)</xsl:variable> <!-- version number of this XSL Template -->
<xsl:variable name="plcount" select="count(//PayloadItem) - 1" /><!-- Count of PayloadItem -->
<xsl:variable name="maxrow">15</xsl:variable><!-- Constant of Max Row allowed in 1 page -->

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
			table-layout:fixed;
			}
			td {
			padding:3px 7px 2px 7px;
			}
			.colheader {
			font-size:9px;
			background-color:0070C0;
			color:#ffffff;
			}
			.colheader td {
			line-height:10px;
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
			.hiderow {			
			}
			.discount {
			font-size:10px;			
			text-overflow:ellipsis;
			overflow:hidden;
			white-space:nowrap;
			}
			#orderheader td {			
			text-overflow:ellipsis;
			overflow:hidden;
			white-space:nowrap;
			}
			.longtext {			
			text-overflow:ellipsis;
			overflow:hidden;
			white-space:nowrap;
			}
			.pagefooter {
			text-align:center;
			font-size:12px;
			}
			.spacerow1 {
			font-size:11px;
			text-align:center;
			color:#ffffff;
			}
			.spacerow2 {
			font-size:10px;
			text-align:center;
			color:#ffffff;
			}
			.version {
			background-color:DDEBF7;
			font-size:10px;
			text-align:center;
			color:#ffffff;
			}
			.pagefooterholder {
			width:100%;
			border-collapse:collapse;
			border:0px;			
			}
			.pagefooterholder td {
			padding: 0px;			
			}
			hr {
			width:100%;
			height:38px;
			border:none;
			color:FDFDFD;
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
		<tr class="colheader">
			<td width="10%" rowspan="2">ΚΩΔΙΚΟΣ ΠΡΟΪΟΝΤΟΣ (ECAS)</td>
			<td width="10%" rowspan="2">EAN ΜΟΝΑΔΑΣ ΠΑΡΑΔΟΣΗΣ</td>
			<td width="27%" rowspan="2">ΠΕΡΙΓΡΑΦΗ ΠΡΟΪΟΝΤΟΣ</td>
			<td width="5%" align="right" rowspan="2">ΤΙΜΗ ΚΑΤΑΛΟΓΟΥ</td>
			<td width="6%" align="center" rowspan="2">ΠΟΣΟΤΗΤΑ ΣΤΗΝ ΠΑΡΑΓΓΕΛΙΑ</td>
			<td width="7%" align="center" rowspan="2">QTA CONFER- MATA</td>
			<td width="7%" align="center" rowspan="2">UM DESCRIZ- IONE</td>
			<td width="5%" align="center" rowspan="2"># ΤΕΜΑΧΙΑ</td>
			<td width="8%" rowspan="2">ΕΠΙΒΕΒΑΙΩΜΕΝΗ ΗΜΕΡΟΜΗΝΙΑ ΠΑΡΑΔΟΣΗΣ</td>
			<td width="8%" align="right">ΚΑΘΑΡΗ ΤΙΜΗ ΕΚΤΟΣ ΕΚΠΤΩΣΗΣ ΠΛΗΡΩΜΗΣ</td>
			<td width="7%" align="right">ΚΑΘΑΡΗ ΤΙΜΗ (ΓΡΑΜΜΗ ΠΑΡΑΓΓΕΛΙΑΣ)</td>
		</tr>
		<tr class="colheader">
			<td align="right">ΚΑΘΑΡΗ ΤΙΜΗ ΤΕΜΑΧΙΟΥ ΕΚΤΟΣ ΕΚΠΤΩΣΗΣ ΠΛΗΡΩΜΗΣ</td>
			<td align="right">ΚΑΘΑΡΗ ΤΙΜΗ (ΜΟΝΑΔΙΚΟ ΤΕΜΑΧΙΟ)</td>
		</tr>
		<xsl:apply-templates select="PayloadItem[@posnr &gt;'000000']" mode="item" />
	</table>
	<xsl:apply-templates select="PayloadItem[@posnr='000000']" mode="footer" />
</xsl:template>

<!-- Report Content Header -->
<xsl:template match="PayloadItem" mode="header">
	<table id="orderheader">
		<tr>
			<td width="30%">
				ΣΗΜΕΙΟ ΠΑΡΑΔΟΣΗΣ:
				<xsl:value-of select="VBPA_AG_KUNNR/VALUE1" />
			</td>
			<td width="28%">
				<xsl:value-of select="VBAK_VKORG/VALUE1" />/<xsl:value-of select="VBAK_VTWEG/VALUE1" />/<xsl:value-of select="VBAK_SPART/VALUE1" />
			</td>
			<td width="22%">
				ΗΜΕΡΟΜΗΝΙΑ ΠΑΡΑΔΟΣΗΣ:
				<xsl:if test="VBAK_VDATU">
					<xsl:value-of select="substring(VBAK_VDATU/VALUE1,7,2)" />/<xsl:value-of select="substring(VBAK_VDATU/VALUE1,5,2)" />/<xsl:value-of select="substring(VBAK_VDATU/VALUE1,1,4)" />
				</xsl:if>				
			</td>
			<td width="20%">
				ΚΑΤΑΣΤΑΣΗ ΠΑΡΑΓΓΕΛΙΑΣ:
				<xsl:choose>
					<xsl:when test="VBUK_GBSTK/VALUE1 = 'A'">
						Ανοιχτή
					</xsl:when>
					<xsl:when test="VBUK_GBSTK/VALUE1 = 'B'">
						Μη ολοκληρωμένη
					</xsl:when>
					<xsl:when test="VBUK_GBSTK/VALUE1 = 'C'">
						Ολοκληρωμένη
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>
				<xsl:value-of select="VBPA_AG_NAME1/VALUE1" />
				&#160;
				<xsl:value-of select="VBPA_AG_NAME2/VALUE1" />
			</td>
			<td>
				SAP ΑΡΙΘΜΟΣ ΠΑΡΑΓΓΕΛΙΑΣ:
				<xsl:value-of select="VBAK_VBELN/VALUE1" />
			</td>
			<td>
				ΗΜΕΡΟΜΗΝΙΑ ΠΑΡΑΓΓΕΛΙΑΣ:
				<xsl:if test="VBAK_AUDAT">
					<xsl:value-of select="substring(VBAK_AUDAT/VALUE1,7,2)" />/<xsl:value-of select="substring(VBAK_AUDAT/VALUE1,5,2)" />/<xsl:value-of select="substring(VBAK_AUDAT/VALUE1,1,4)" />
				</xsl:if>
			</td>
			<td>
				ΜΠΛΟΚ ΠΑΡΑΔΟΣΗΣ (LOGISTICS):
				<xsl:choose>
					<xsl:when test="VBUK_LSSTK/VALUE1 = 'A'">
						Όχι
					</xsl:when>
					<xsl:when test="VBUK_LSSTK/VALUE1 = 'B'">
						Όχι
					</xsl:when>
					<xsl:when test="VBUK_LSSTK/VALUE1 = 'C'">
						Όχι
					</xsl:when>
					<xsl:otherwise>
						Όχι
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>
				<xsl:value-of select="VBPA_AG_STREET/VALUE1" />
			</td>
			<td>
				ΕΣΩΤΕΡΙΚΟΣ ΑΡΙΘΜΟΣ ΠΑΡΑΓΓΕΛΙΑΣ:
				<xsl:value-of select="VBKD_BSTKD/VALUE1" />
			</td>
			<td>
				ΗΜΕΡΟΜΗΝΙΑ ΔΗΜΙΟΥΡΓΙΑΣ ΠΑΡΑΓΓΕΛΙΑΣ:
				<xsl:if test="VBAK_ERDAT">
					<xsl:value-of select="substring(VBAK_ERDAT/VALUE1,7,2)" />/<xsl:value-of select="substring(VBAK_ERDAT/VALUE1,5,2)" />/<xsl:value-of select="substring(VBAK_ERDAT/VALUE1,1,4)" />
				</xsl:if>
			</td>
			<td>
				ΔΙΑΧΕΙΡΙΣΤΙΚΟ ΜΠΛΟΚ:
				<xsl:choose>
					<xsl:when test="VBUK_CMGST/VALUE1 = 'A'">
						Όχι
					</xsl:when>
					<xsl:when test="VBUK_CMGST/VALUE1 = 'B'">
						Ναι
					</xsl:when>
					<xsl:when test="VBUK_CMGST/VALUE1 = 'C'">
						Ναι
					</xsl:when>
					<xsl:when test="VBUK_CMGST/VALUE1 = 'D'">
						Όχι
					</xsl:when>
					<xsl:otherwise>
						Όχι
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>
				<xsl:value-of select="VBPA_AG_PCODE/VALUE1" />
				&#160;
				<xsl:value-of select="VBPA_AG_CITY/VALUE1" />
				&#160;
				<xsl:value-of select="VBPA_AG_REGION/VALUE1" />
			</td>
			<td colspan="3">
				ΟΡΟΙ ΠΛΗΡΩΜΗΣ:
				<xsl:choose>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'T260'">
					  30 ΗΜΕΡΕΣ
					</xsl:when>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'T559'">
					  ΑΜΕΣΑ ΑΠΑΙΤΗΤΑ
					</xsl:when>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'T560'">
					  ΑΝΤΙΚΑΤΑΒΟΛΗ ΕΠΙΤΑΓΗΣ 60 ΗΜΕΡΩΝ
					</xsl:when>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V152'">
					  4 ΗΜΕΡΕΣ
					</xsl:when>
					<xsl:when test="VBKD_ZTERM/VALUE1 = 'V738'">
					  14 ΗΜΕΡΕΣ
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
				ΕΚΠΤΩΣΗ ΠΛΗΡΩΜΗΣ:
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
				ΣΥΝΟΛΟ ΕΚΤΟΣ ΦΠΑ:
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
				ΦΠΑ:
				<xsl:choose>
					<xsl:when test="COND_MWST">
                  <!-- change begin on 24-FEB-2015 -->
                     <xsl:value-of select="format-number(sum(exsl:node-set($mwstsum)/number), '#.00')"/>
						   <!-- <xsl:value-of select="format-number(translate(translate(translate(normalize-space(COND_MWST/VALUE3), VBAK_WAERK/VALUE1, ''),'.',''),',','.'),'#0.00')" /> -->
                  <!-- change end   on 24-FEB-2015 -->
					</xsl:when>
					<xsl:otherwise>
						0.00
					</xsl:otherwise>
				</xsl:choose>
				&#160;
				<xsl:value-of select="VBAK_WAERK/VALUE1" />
			</td>			
			<td width="25%">
				ΣΥΝΟΛΟ ΜΕ ΦΠΑ:
				<xsl:choose>
					<xsl:when test="COND_MWST">
                  <!-- change begin on 24-FEB-2015 -->
						<xsl:value-of select="format-number( number(VBAK_NETWR/VALUE1) + number(sum(exsl:node-set($mwstsum)/number)) ,'#0.00')" />
						<!-- <xsl:value-of select="format-number(number(VBAK_NETWR/VALUE1) + number(translate(translate(translate(normalize-space(COND_MWST/VALUE3), VBAK_WAERK/VALUE1, ''),'.',''),',','.')),'#0.00')" /> -->
                  <!-- change end   on 24-FEB-2015 -->
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
	<table class="version">
		<tr><td><xsl:value-of select="$version" /></td></tr>
	</table>
</xsl:template>

<!-- Report Line Item Details -->
<xsl:template match="PayloadItem" mode="item">
	<!-- Start of variable definitions -->
	<xsl:variable name="posnum" select="position()"/>
	<xsl:variable name="netvalue" select="VBAP_KZWI2/VALUE1" />
	<xsl:variable name="bomdisplay">
		<xsl:choose>
			<xsl:when test="VBAP_PSTYV/VALUE1 = 'ZACP'">bomheader</xsl:when>
			<xsl:when test="VBAP_PSTYV/VALUE1 = 'ZGN1'">bomitem</xsl:when>
			<xsl:when test="VBAP_PSTYV/VALUE1 = 'ZAPS'">hiderow</xsl:when>
			<xsl:when test="VBAP_PSTYV/VALUE1 = 'ZNG2'">hiderow</xsl:when>
			<xsl:when test="VBAP_PSTYV/VALUE1 = 'ZPPS'">hiderow</xsl:when>
			<xsl:otherwise>notbom</xsl:otherwise>
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
	
	<!-- Page footer & next page header -->
	<xsl:if test="$posnum mod $maxrow = $maxrow - 1">
		<!-- <tr class="pagefooter">
			<td colspan="11"><xsl:value-of select="format-number(ceiling($posnum div $maxrow), '#0')" />/<xsl:value-of select="format-number(ceiling($plcount div $maxrow) + 1, '#0')" /></td>
		</tr>-->
		
		<!-- Insert blank row for page footer -->
		<tr>
			<td colspan="11">
				<table class="pagefooterholder">
					<tr> 
						<td><hr/></td>
					</tr>
					<xsl:if test="$posnum &gt; $maxrow - 1">
					<tr> 
						<td>&#160;</td>
					</tr>
					</xsl:if>
				</table>
			</td>
		</tr>
		
		<!-- Insert page header for next page -->
		<tr class="colheader">
			<td rowspan="2">ΚΩΔΙΚΟΣ ΠΡΟΪΟΝΤΟΣ (ECAS)</td>
			<td rowspan="2">EAN ΜΟΝΑΔΑΣ ΠΑΡΑΔΟΣΗΣ</td>
			<td rowspan="2">ΠΕΡΙΓΡΑΦΗ ΠΡΟΪΟΝΤΟΣ</td>
			<td align="right" rowspan="2">ΤΙΜΗ ΚΑΤΑΛΟΓΟΥ</td>
			<td align="center" rowspan="2">ΠΟΣΟΤΗΤΑ ΣΤΗΝ ΠΑΡΑΓΓΕΛΙΑ</td>
			<td align="center" rowspan="2">ΕΠΙΒΕΒΑΙΩΜΕΝΗ ΠΟΣΟΤΗΤΑ</td>
			<td align="center" rowspan="2">ΠΕΡΙΓΡΑΦΗ ΜΟΝΑΔΑΣ ΠΑΡΑΔΟΣΗΣ</td>
			<td align="center" rowspan="2"># ΤΕΜΑΧΙΑ</td>
			<td rowspan="2">ΕΠΙΒΕΒΑΙΩΜΕΝΗ ΗΜΕΡΟΜΗΝΙΑ ΠΑΡΑΔΟΣΗΣ</td>
			<td align="right">ΚΑΘΑΡΗ ΤΙΜΗ ΕΚΤΟΣ ΕΚΠΤΩΣΗΣ ΠΛΗΡΩΜΗΣ</td>
			<td align="right">ΚΑΘΑΡΗ ΤΙΜΗ (ΓΡΑΜΜΗ ΠΑΡΑΓΓΕΛΙΑΣ)</td>
		</tr>
		<tr class="colheader">
			<td align="right">ΚΑΘΑΡΗ ΤΙΜΗ ΤΕΜΑΧΙΟΥ ΕΚΤΟΣ ΕΚΠΤΩΣΗΣ ΠΛΗΡΩΜΗΣ</td>
			<td align="right">ΚΑΘΑΡΗ ΤΙΜΗ (ΓΡΑΜΜΗ ΠΑΡΑΓΓΕΛΙΑΣ)</td>
		</tr>
		<tr></tr>
	</xsl:if>
	
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
		<td class="longtext">
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
	<xsl:if test="$bomdisplay">
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
	</xsl:if>
</xsl:template>

</xsl:stylesheet>