
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands"%>
<%@page import="com.sx.icecap.datatype.constants.IcecapDataTypeConstants"%>
<%@page import="com.sx.icecap.datatype.constants.IcecapDataTypeWebKeys"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.sx.datamarket.web.datatype.management.display.context.DataTypeManagementToolbarDisplayContext"%>
<%@ include file="../init.jsp" %>

<%
	DataTypeManagementToolbarDisplayContext dataTypeManagementToolbarDisplayContext = 
		(DataTypeManagementToolbarDisplayContext)renderRequest.getAttribute(
		DataTypeManagementToolbarDisplayContext.class.getName());

	String viewStyle = ParamUtil.getString(
							renderRequest, 
							IcecapDataTypeWebKeys.DISPLAY_STYLE, 
							IcecapDataTypeConstants.VIEW_TYPE_TABLE);
%>

<portlet:renderURL var="createDataTypeURL">
    <portlet:param 
    		name="<%= IcecapDataTypeWebKeys.MVC_RENDER_COMMAND_NAME %>" 
    		value="<%= IcecapDataTypeMVCCommands.RENDER_DATATYPE_EDIT %>"/>
    <portlet:param 
    		name="<%= IcecapDataTypeWebKeys.REDIRECT %>" 
    		value="<%= currentURL %>"/>
</portlet:renderURL>

<portlet:renderURL var="searchViewURL">
    <portlet:param name="<%= IcecapDataTypeWebKeys.MVC_RENDER_COMMAND_NAME %>" 
    value="<%= IcecapDataTypeMVCCommands.RENDER_DATATYPE_VIEW %>" />
</portlet:renderURL>

<portlet:renderURL var="searchTermsURL">
    <portlet:param name="<%= IcecapDataTypeWebKeys.MVC_RENDER_COMMAND_NAME %>" 
    value="<%= IcecapDataTypeMVCCommands.RENDER_SEARCH_DATATYPES %>" />
</portlet:renderURL>

<clay:management-toolbar
	displayContext="<%= dataTypeManagementToolbarDisplayContext %>"
/>
	
<div class="closed container-fluid container-fluid-max-xl sidenav-container sidenav-right" id="<portlet:namespace />dataTypeInfoPanelId">
	<liferay-frontend:sidebar-panel
		searchContainerId="<%= IcecapDataTypeConstants.SEARCH_CONTAINER_ID %>"
	>	</liferay-frontend:sidebar-panel>
	
	<div class="sidenav-content">
		<aui:form action="" 
				method="<%= dataTypeManagementToolbarDisplayContext.getSearchFormMethod() %>" 
				name="<%= dataTypeManagementToolbarDisplayContext.getSearchFormName() %>">
			<aui:input name="cmd" type="hidden"></aui:input>
			<aui:input name="redirect" type="hidden"></aui:input>
		
		 	<liferay-ui:search-container 
		 		id="<%= IcecapDataTypeConstants.SEARCH_CONTAINER_ID %>"
			    searchContainer="<%= dataTypeManagementToolbarDisplayContext.getSearchContainer() %>" >
			    
			        <liferay-ui:search-container-row
								className="com.sx.icecap.datatype.model.DataType" 
								keyProperty="dataTypeId" 
								modelVar="dataType"
								escapedModel="<%=true%>">
								
					</liferay-ui:search-container-row>
					
			</liferay-ui:search-container>
		</aui:form>
	</div>
</div>

<script type="text/javascript">
Liferay.componentReady('dataTypeManagementToolbar').then(function(
		managementToolbar
	) {

		managementToolbar.on('actionItemClicked', function(event) {
			confirm('confirm...');
			console.log('Data CMD: ', event.data.item.data.cmd );
			var form = document.getElementById('<portlet:namespace />fm');

			Liferay.Util.postForm(form, {
				data:{
					cmd: event.data.item.data.cmd,
					redirect: '<%= currentURL %>'
				},
				url: '<portlet:actionURL name="<%=IcecapDataTypeMVCCommands.ACTION_BULK %>" />'
			});
		});
	});
</script>
