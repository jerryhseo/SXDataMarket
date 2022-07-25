
<%@ include file="../init.jsp" %>

<%
	String name = ParamUtil.getString(request, "controlName" );
	String label = ParamUtil.getString(request, "controlLabel");
	boolean required = ParamUtil.getBoolean(request, "controlRequired" );
	String helpMessage = ParamUtil.getString(request, "controlHelpMessage");
	String defaultValue = ParamUtil.getString(request, "controlDefaultValue", "");
	
%>

<div id="<portlet:namespace/>templateLocalizedInput">
	<aui:field-wrapper name="<%= name %>" label="<%= label %>" helpMessage="<%= helpMessage %>"> 
		<liferay-ui:input-localized  name="<%= name %>" xml="<%=defaultValue %>"></liferay-ui:input-localized>
	</aui:field-wrapper>
</div>