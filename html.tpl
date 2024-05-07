<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
{{- if . }}
    <style>
      * {
        font-family: Arial, sans-serif;
        font-size: 14px;
        color: #333;
      }
      h1 {
        text-align: center;
        font-size: 20px;
        margin: 0;
        display: block;
        margin-block-start: 0.67em;
        margin-block-end: 0.67em;
        margin-inline-start: 0px;
        margin-inline-end: 0px;
        font-weight: bold;
        unicode-bidi: isolate;
      }
      table {
          width: 100%;
          margin: 20px 0;
          border-spacing: 2px;
      }
      th, td {
          border: 1px solid #ddd;
          padding: 10px;
          text-align: left;
      }
      th {
          text-align: center;
          font-weight: bold;
          font-size: 15px;
          background-color: #f2f2f2;
      }
      .severity {
        text-align: center;
        font-weight: bold;
        color: #fafafa;
      }
      .severity-LOW .severity { background-color: #5fbb31; }
      .severity-MEDIUM .severity { background-color: #e9c600; }
      .severity-HIGH .severity { background-color: #ff8800; }
      .severity-CRITICAL .severity { background-color: #e40000; }
      .severity-UNKNOWN .severity { background-color: #747474; }
      .severity-LOW { background-color: #5fbb3160; }
      .severity-MEDIUM { background-color: #e9c60060; }
      .severity-HIGH { background-color: #ff880060; }
      .severity-CRITICAL { background-color: #e4000060; }
      .severity-UNKNOWN { background-color: #74747460; }
      table tr td:first-of-type {
        font-weight: bold;
      }
      .links a,
      .links[data-more-links=on] a {
        display: block;
      }
      .links[data-more-links=off] a:nth-of-type(1n+5) {
        display: none;
      }
      a.toggle-more-links { cursor: pointer; }
    </style>
    <title>{{- escapeXML ( index . 0 ).Target }}</title>
  </head>
  <body>
    <h1>{{- escapeXML ( index . 0 ).Target }}</h1>
    <table>
    {{- range . }}
      <tr class="group-header"><th colspan="5">{{ .Type | toString | escapeXML }}</th></tr>
      {{- if (eq (len .Vulnerabilities) 0) }}
      <tr><th colspan="5">No Vulnerabilities found</th></tr>
      {{- else }}
      <tr class="sub-header">
        <th>Package</th>
        <th>Vulnerability ID</th>
        <th>Severity</th>
        <th>Installed Version</th>
        <th>Fixed Version</th>
      </tr>
        {{- range .Vulnerabilities }}
      <tr class="severity-{{ escapeXML .Vulnerability.Severity }}">
        <td class="pkg-name">{{ escapeXML .PkgName }}</td>
        <td>{{ escapeXML .VulnerabilityID }}</td>
        <td class="severity">{{ escapeXML .Vulnerability.Severity }}</td>
        <td class="pkg-version">{{ escapeXML .InstalledVersion }}</td>
        <td>{{ escapeXML .FixedVersion }}</td>
      </tr>
        {{- end }}
      {{- end }}
      {{- if (eq (len .Misconfigurations ) 0) }}
      <tr><th colspan="6">No Misconfigurations found</th></tr>
      {{- else }}
      <tr class="sub-header">
        <th>Type</th>
        <th>Misconf ID</th>
        <th>Check</th>
        <th>Severity</th>
        <th>Message</th>
      </tr>
        {{- range .Misconfigurations }}
      <tr class="severity-{{ escapeXML .Severity }}">
        <td class="misconf-type">{{ escapeXML .Type }}</td>
        <td>{{ escapeXML .ID }}</td>
        <td class="misconf-check">{{ escapeXML .Title }}</td>
        <td class="severity">{{ escapeXML .Severity }}</td>
        <td class="link" data-more-links="off"  style="white-space:normal;">
          {{ escapeXML .Message }}
          <br>
            <a href={{ escapeXML .PrimaryURL | printf "%q" }}>{{ escapeXML .PrimaryURL }}</a>
          </br>
        </td>
      </tr>
        {{- end }}
      {{- end }}
    {{- end }}
    </table>
{{- else }}
  </head>
  <body>
    <h1>Trivy Returned Empty Report</h1>
{{- end }}
  </body>
</html>