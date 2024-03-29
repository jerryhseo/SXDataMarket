
<%@page import="com.liferay.portal.kernel.util.DateUtil"%>
<%@page import="com.sx.datamarket.web.datatype.management.taglib.clay.DataTypeVerticalCard"%>
<%@page import="com.liferay.portal.kernel.dao.search.RowChecker"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands"%>
<%@page import="com.sx.icecap.datatype.constants.IcecapDataTypeConstants"%>
<%@page import="com.sx.icecap.datatype.constants.IcecapDataTypeWebKeys"%>
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
		<aui:form 
					action="" 
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
							
					<%
						Map<String, Object> rowData = new HashMap<>();

								row.setData(rowData);

								PortletURL rowURL = renderResponse.createRenderURL();

								rowURL.setParameter(IcecapDataTypeWebKeys.MVC_RENDER_COMMAND_NAME, IcecapDataTypeMVCCommands.RENDER_DATATYPE_VIEW);
								rowURL.setParameter(IcecapDataTypeWebKeys.REDIRECT, currentURL);
								rowURL.setParameter(IcecapDataTypeWebKeys.DATATYPE_ID, String.valueOf(dataType.getDataTypeId()));
					%>
					<c:choose>
						<c:when test="<%= viewStyle.equals(IcecapDataTypeConstants.VIEW_TYPE_CARDS) %>">
							<%
								row.setCssClass("lfr-asset-item col-md-3 col-sm-4 col-xs-6");
								RowChecker rowChecker = searchContainer.getRowChecker();
								rowChecker.setData( rowData );
								DataTypeVerticalCard dataTypeVerticalCard = new DataTypeVerticalCard(
										dataType, 
										renderRequest, 
										renderResponse, 
										rowChecker, 
										rowURL.toString(),
										dataTypeManagementToolbarDisplayContext.getDataTypeActionDropdownItems(dataType.getDataTypeId()));
							%>
							<liferay-ui:search-container-column-text>
								<clay:vertical-card
										verticalCard="<%= dataTypeVerticalCard %>"
								/>
							</liferay-ui:search-container-column-text>
						</c:when>
						<c:when test="<%= viewStyle.equals(IcecapDataTypeConstants.VIEW_TYPE_LIST) %>">
							<liferay-ui:search-container-column-text href="<%=rowURL.toString() %>" >
								<h5 class=“text-default”><%= dataType.getDisplayName(locale) %></h5>
								<h5><%= dataType.getDataTypeVersion() %></h5>
							</liferay-ui:search-container-column-text>
							<liferay-ui:search-container-column-text  colspan="3" >
	  							<h6 class=“text-default”>
	    							<%= dataType.getDataTypeName() %>
	  							</h6>
	  							<h6>
	  								<%= dataType.getDescription(locale) %>
	  							</h6>
							</liferay-ui:search-container-column-text>
							<liferay-ui:search-container-column-text>
								<clay:dropdown-actions
									dropdownItems="<%= dataTypeManagementToolbarDisplayContext.getDataTypeActionDropdownItems(dataType.getDataTypeId()) %>"
								/>
							</liferay-ui:search-container-column-text>
						</c:when>
						<c:otherwise>
							<%
								row.setCssClass("col-md-12 "+row.getCssClass() );
							%>
							<liferay-ui:search-container-column-text
							 			name="display-name"
							 			href="<%=rowURL.toString() %>"
										value="<%=dataType.getDisplayName(locale)%>"/>
							<liferay-ui:search-container-column-text 
										name="parameter-name" 
										property="dataTypeName" />
							<liferay-ui:search-container-column-text 
										name="version" 
										property="dataTypeVersion"/>
			
							<liferay-ui:search-container-column-text 
										name="description" 
										value="<%= dataType.getDescription(locale)%>" />
							
							<liferay-ui:search-container-column-text 
										name="modified-date"
										value="<%= DateUtil.getDate(dataType.getModifiedDate(), "yyyy-MM-dd", locale) %>"/>
							
							<liferay-ui:search-container-column-status 
										name="status" 
										property="status" />
			
							<liferay-ui:search-container-column-text name="actions">
								<clay:dropdown-actions
									dropdownItems="<%= dataTypeManagementToolbarDisplayContext.getDataTypeActionDropdownItems(dataType.getDataTypeId()) %>"
								/>
							</liferay-ui:search-container-column-text>
						</c:otherwise>
					</c:choose>
				</liferay-ui:search-container-row>
					
				<c:choose>
					<c:when test="<%= viewStyle.equals(IcecapDataTypeConstants.VIEW_TYPE_TABLE) %>">
						<liferay-ui:search-iterator
								markupView="lexicon" />
					</c:when>
					<c:otherwise>
						<liferay-ui:search-iterator
								displayStyle = "<%= viewStyle %>"
								markupView="lexicon" />
					</c:otherwise>
				</c:choose>
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
