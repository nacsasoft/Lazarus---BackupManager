<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eproms="http://www.siplace.com/Eprom">
<xsl:output method="html" version="2.0" encoding="iso-8859-1" indent="yes" />
<xsl:template match="/">
<html>
    <head>
    </head>
    <body bgcolor="#8888ee">
        <h1>Electronic Card Logging</h1>
        <xsl:apply-templates mode="machineinfo"/>
        <br/>
        <h2>Current Machine</h2>
        <table border="1" bgcolor="#e0e0e0" cellpadding="5">
            <tr bgcolor="#9acd32">
                <th align="left">Hardware Name</th>
                <th align="left">EEprom Name</th>
                <th align="left">SerialNumber</th>
                <th align="left">Production Date</th>
                <th align="left">Appearance Date</th>
                <th align="left">Location</th>
                <th align="left">SegNo</th>
            </tr>
            <xsl:for-each select="ElectronicCardLogging/CurrentMachine/ElectronicCard">
                <xsl:sort select="@DateOfAppearance" order="descending"/>
                <xsl:sort select="@IssName" order="ascending"/>
                <tr bgcolor="#fafad2">
                    <td>
                        <xsl:value-of select="@IssName" />
                    </td>
                    <td>
                        <xsl:value-of select="@EpromName" />
                    </td>
                    <td>
                        <xsl:value-of select="@SerialNumber" />
                    </td>
                    <td>
                        <xsl:value-of select="@ProductionDate" />
                    </td>
                    <td>
                        <xsl:value-of select="@DateOfAppearance" />
                    </td>
                    <td align="center">
                        <xsl:value-of select="@Location" />
                    </td>
                    <td align="center">
                        <xsl:value-of select="@SegmentNumber" />
                    </td>
                </tr>
            </xsl:for-each>
        </table>
        <br />
        <h2>History</h2>
        <table border="1" bgcolor="#e0e0e0" cellpadding="4">
            <tr bgcolor="#9acd32">
                <th align="left">Hardware Name</th>
                <th align="left">EEprom Name</th>
                <th align="left">SerialNumber</th>
                <th align="left">Production Date</th>
                <th align="left">Appearance Date</th>
                <th align="left">Removal Date</th>
                <th align="left">Location</th>
                <th align="left">SegNo</th>
            </tr>
            <xsl:for-each select="ElectronicCardLogging/MachineHistory/ElectronicCard">
                <xsl:sort select="@DateOfRemoval" order="descending"/>
                <xsl:sort select="@IssName" order="ascending"/>
                <tr bgcolor="#9acdFF">
                    <td>
                        <xsl:value-of select="@IssName" />
                    </td>
                    <td>
                        <xsl:value-of select="@EpromName" />
                    </td>
                    <td>
                        <xsl:value-of select="@SerialNumber" />
                    </td>
                    <td>
                        <xsl:value-of select="@ProductionDate" />
                    </td>
                    <td>
                        <xsl:value-of select="@DateOfAppearance" />
                    </td>
                    <td>
                        <xsl:value-of select="@DateOfRemoval" />
                    </td>
                    <td align="center">
                        <xsl:value-of select="@Location" />
                    </td>
                    <td align="center">
                        <xsl:value-of select="@SegmentNumber" />
                    </td>
                </tr>
            </xsl:for-each>
        </table>
        <br />
        <br />
    </body>
</html>
</xsl:template>
<xsl:template match="ElectronicCardLogging" mode="machineinfo">
    <h4>
        Machine type:       <span style="color:yellow"> &#160;
                                <xsl:value-of select="@MachineType"/> 
                            </span> &#160; &#160; -- &#160; &#160;
        Machine ID:         <span style="color:yellow"> &#160;
                                <xsl:value-of select="@MachineIdAndFrameSerialNumber"/> 
                            </span> &#160; &#160; -- &#160; &#160;
        Logfile Version:  <xsl:value-of select="@Version"/>
    </h4>
</xsl:template>
</xsl:stylesheet>