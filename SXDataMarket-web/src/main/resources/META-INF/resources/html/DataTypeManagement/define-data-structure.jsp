<%@page import="com.sx.icecap.datatype.constants.IcecapDataTypeConstants"%>
<%@page import="com.liferay.portal.kernel.workflow.WorkflowConstants"%>
<%@page import="com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@page import="com.sx.icecap.datatype.model.DataTypeStructure"%>
<%@page import="com.liferay.portal.kernel.json.JSONFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.json.JSONArray"%>
<%@page import="com.liferay.portal.kernel.util.LocaleUtil"%>
<%@page import="java.util.Set"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="java.util.Locale"%>
<%@page import="com.sx.icecap.datatype.constants.IcecapDataTypeWebKeys"%>
<%@page import="com.sx.icecap.datatype.model.DataType"%>
<%@ include file="../init.jsp" %>

<%
	long dataTypeId = ParamUtil.getLong(renderRequest, IcecapDataTypeWebKeys.DATATYPE_ID, 0);

	DataType dataType = (DataType)renderRequest.getAttribute(IcecapDataTypeWebKeys.DATATYPE);
	JSONObject dataStructure = null;
	boolean hasDataStructure = dataType.getHasDataStructure();
	
	if( hasDataStructure ){
		dataStructure = (JSONObject)renderRequest.getAttribute(IcecapDataTypeWebKeys.DATA_STRUCTURE);
	}
	
	Locale defaultLocale = PortalUtil.getSiteDefaultLocale(themeDisplay.getScopeGroupId());
	
	Set<Locale> availableLocales = LanguageUtil.getAvailableLocales();
	
	JSONArray jsonLocales = JSONFactoryUtil.createJSONArray();
	availableLocales.forEach( jsonLocales::put );
	
	System.out.println("Available Locales: " + jsonLocales.toJSONString());
%>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/main.css">

<script>
</script>

<portlet:resourceURL var="loadDataStructureResourceCommandURL">
	<portlet:param name="dataTypeId" value="<%= String.valueOf(dataType.getDataTypeId()) %>"/>
</portlet:resourceURL>

<portlet:resourceURL id="<%= IcecapDataTypeMVCCommands.RESOURCE_DATATYPE_RENDER_TERM %>" var="renderTermResourceCommandURL">
	<portlet:param name="cmd" value="<%= IcecapDataTypeConstants.RENDER_TERM %>"/>
</portlet:resourceURL>

<portlet:resourceURL id="<%= IcecapDataTypeMVCCommands.RESOURCE_DATATYPE_RENDER_DATATYPE %>" var="renderDataTypeResourceCommandURL">
	<portlet:param name="cmd" value="<%= IcecapDataTypeConstants.RENDER_DATATYPE %>"/>
</portlet:resourceURL>

<portlet:renderURL var="templateRenderURL">
	<portlet:param name="jspPath" value="/html/templates/list.jsp"></portlet:param>
</portlet:renderURL>

<aui:container cssClass="SXDataMarket-web" id="dataTypeDefiner">
	<aui:row id="infoSection">
		<aui:col md="3" id="nameCol">
			<aui:input 
						type="text" 
						name="dataTypeName" 
						label="datatype-name"
						value="<%= dataType.getDataTypeName() %>" 
						disabled="true">
			</aui:input>
		</aui:col>
		<aui:col md="2" id="versionCol">
			<aui:input 
						type="text" 
						name="dataTypeVersion"
						label="datatype-version" 
						value="<%= dataType.getDataTypeVersion() %>" 
						disabled="true">
			</aui:input>
		</aui:col>
		<aui:col md="2" id="extensionCol">
			<aui:input 
						type="text" 
						name="dataTypeExtension"
						label="datatype-extension" 
						value="<%= dataType.getExtension() %>" 
						disabled="true">
			</aui:input>
		</aui:col>
		<aui:col md="5" id="naviCol">
			<div class="right">
			<liferay-ui:icon image="back" />
			<aui:a href="#" label="back-to-list"></aui:a>
			</div>
		</aui:col>
	</aui:row>
	<aui:row>
		<aui:col>
			<hr class="title-horizontal-line">
		</aui:col>
	</aui:row>
	<aui:row id="headerSection">
		<aui:col md="4">
			<aui:input 
						type="text" 
						name="termDelimiter" 
						helpMessage="term-delimiter-help"
						value="<%= hasDataStructure ? dataStructure.get("termDelimiter") : ";" %>">
			</aui:input>
		</aui:col>
		<aui:col md="4">
			<aui:select 
						name="termDelimiterPosition"
						helpMessage="term-delimiter-position-help">
				<aui:option label="start" value="false"></aui:option>
				<aui:option label="end" value="true" selected="true"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="4">
			<aui:select 
						name="termValueDelimiter"
						helpMessage="term-value-delimiter-help">
				<aui:option label="Equal" value="equal"  selected="true"></aui:option>
				<aui:option label="Space" value="space"></aui:option>
				<aui:option label="Colon" value="colon"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="4">
			<aui:select 
						name="matrixBracketType"
						helpMessage="matrix-bracket-type-help">
				<aui:option label="parenthesis-()" value="()"  selected="true"></aui:option>
				<aui:option label="curly-bracket-{}" value="{}"></aui:option>
				<aui:option label="square-bracket-[]" value="[]"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="4">
			<aui:select 
						name="matrixElementDelimiter"
						helpMessage="matrix-element-delimiter-help">
				<aui:option label="Space" value="space"  selected="true"></aui:option>
				<aui:option label="Comma" value="comma"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="4">
			<aui:input 
						type="text" 
						name="commentChar" 
						helpMessage="comment-character-help"
						value="#">
			</aui:input>
		</aui:col>
	</aui:row>
	<aui:row>
		<aui:col>
			<hr class="title-horizontal-line">
		</aui:col>
	</aui:row>
	<aui:row id="editSection" cssClass="border">
		<aui:col md="5" id="termProperties" cssClass="bottom-margin">
			<aui:container>
			<aui:form action="" name="editTermForm" method="POST">
				<aui:button-row>
					<aui:button name="btnNewTerm" value="new-term" cssClass="left"></aui:button>
					<aui:button name="btnCopyTerm" value="copy-term" cssClass="left"></aui:button>
					<aui:button name="btnClear" value="clear" cssClass="left"></aui:button>
					<aui:button name="btnImportTerm" value="import-term" cssClass="right"></aui:button>
				</aui:button-row>
				<aui:row>
				<aui:col>
				<aui:select name="termType" label="term-type" helpMessage="term-type-select-help">
					<aui:option label="String" value="String"  selected="true"/>
					<aui:option label="Numeric" value="Numeric"/>
					<aui:option label="Integer" value="Integer"/>
					<aui:option label="List" value="List" selected="true"/>
					<aui:option label="Matrix" value="Matrix"/>
					<aui:option label="Boolean" value="Boolean"/>
					<aui:option label="Array" value="Array"/>
					<aui:option label="Address" value="Address"/>
					<aui:option label="Phone" value="Phone"/>
					<aui:option label="EMail" value="EMail"/>
					<aui:option label="Date" value="Date"/>
					<aui:option label="Comment" value="Comment"/>
					<aui:option label="Group" value="Group"/>
					<aui:option label="File" value="File"/>
					<aui:option label="FileArray" value="FileArray"/>
					<aui:option label="Object" value="Object"/>
					<aui:option label="ObjectArray" value="ObjectArray"/>
					<aui:option label="DataLink" value="DataLink"/>
					<aui:option label="DataLinkArray" value="DataLinkArray"/>
				</aui:select>
				
				<aui:input  
								name="termName" 
								label="term-name"  
								required="true" 
								placeholder="ex) termName"
								helpMessage="term-name-help">
				</aui:input>
				<aui:input  
								name="termVersion" 
								label="term-version" 
								required="true"
								helpMessage="term-version-help">
				</aui:input>
				<aui:field-wrapper name="termDisplayName" required="true" label="term-display-name" helpMessage="term-display-name-help">
						<liferay-ui:input-localized 
										name="termDisplayName"
										xml="">
						</liferay-ui:input-localized>
				</aui:field-wrapper>
				<aui:field-wrapper name="termDefinition" label="definition" helpMessage="definition-help">
						<liferay-ui:input-localized 
										type="textarea"
										name="termDefinition"
										xml="">
						</liferay-ui:input-localized>
				</aui:field-wrapper>
				<aui:field-wrapper name="termTooltip" label="tooltip" helpMessage="term-tooltip-help">
						<liferay-ui:input-localized 
										name="termTooltip"
										xml="">
						</liferay-ui:input-localized>
				</aui:field-wrapper>
				<aui:input 
							type="text"
							name="synonyms" 
							label="synonyms" 
							helpMessage="term-synonyms-help">
				</aui:input>
				<aui:input 
							type="checkbox"
							name="mandatory" 
							label="mandatory" 
							helpMessage="term-mandatory-help">
				</aui:input>
				<aui:input 
							type="text"
							name="value" 
							label="default-value" 
							helpMessage="default-value-help">
				</aui:input>
	
				<hr class="content-horizontal-line">
				
				<%@include file="../templates/type-specific-attributes.jspf" %>
				</aui:col>
				</aui:row>
			</aui:form>
			</aui:container>
		</aui:col>
		<aui:col md="1" id="buttonSection" cssClass="vertical-center-side-border">
			<aui:button id="add" value="add" icon="icon-double-angle-right" iconAlign="right"></aui:button>
		</aui:col>
		<aui:col md="6" id="previewSection">
			<aui:form action="" name="previewForm" method="POST">
				<!-- div id="templateString" cssClass="hide" -->
				<aui:button-row>
					<aui:button id="btnRefresh" value="refresh"></aui:button>
					<aui:button id="btnShowSDE" value="structured-datatype-editor"></aui:button>
				</aui:button-row>
				<hr class="content-horizontal-line">
				
				<table class="table table-striped">
					<tbody id="<portlet:namespace/>previewPanel">
					</tbody>
				</table>
			</aui:form>
		</aui:col>
	</aui:row>
	<aui:button-row>
		<aui:button id="save" value="save"></aui:button>
		<aui:button id="saveAndViewDataTypeList" value="save-and-view-datatype-list"></aui:button>
	</aui:button-row>

</aui:container>

<%@include file="../templates/term-type-selector.jspf" %>

<%@include file="script-bottom.jspf" %>



