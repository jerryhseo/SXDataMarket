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

<script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/2.3.0/mustache.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>

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

<portlet:resourceURL id="<%= IcecapDataTypeMVCCommands.RESOURCE_DATATYPE_RENDER_TERM_ATTR %>" var="renderTermResourceCommandURL">
</portlet:resourceURL>


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
			<aui:form action="" name="editTermForm" method="POST">
				<aui:button-row>
					<aui:button name="btnNewTerm" value="new-term" cssClass="left"></aui:button>
					<aui:button name="btnCopyTerm" value="copy-term" cssClass="left"></aui:button>
					<aui:button name="btnClear" value="clear" cssClass="left"></aui:button>
					<aui:button name="btnImportTerm" value="import-term" cssClass="right"></aui:button>
				</aui:button-row>
				
				<aui:select name="termType" label="term-type" helpMessage="term-type-select-help">
					<aui:option label="String" value="String" selected="true"/>
					<aui:option label="Numeric" value="Numeric"/>
					<aui:option label="Integer" value="Integer"/>
					<aui:option label="List" value="List"/>
					<aui:option label="ListArray" value="ListArray"/>
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
				<aui:field-wrapper name="displayName" required="true" label="term-display-name" helpMessage="term-display-name-help">
						<liferay-ui:input-localized 
										name="displayName"
										xml="">
						</liferay-ui:input-localized>
				</aui:field-wrapper>
				<aui:field-wrapper name="definition" label="definition" helpMessage="definition-help">
						<liferay-ui:input-localized 
										type="textarea"
										name="definition"
										xml="">
						</liferay-ui:input-localized>
				</aui:field-wrapper>
				<aui:field-wrapper name="tooltip" label="tooltip" helpMessage="term-tooltip-help">
						<liferay-ui:input-localized 
										name="tooltip"
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
	
				<div id="<portlet:namespace/>typeSpecific"></div>
			</aui:form>
		</aui:col>
		<aui:col md="1" id="buttonSection" cssClass="vertical-center-side-border">
			<aui:button id="add" value="add" icon="icon-double-angle-right" iconAlign="right"></aui:button>
		</aui:col>
		<aui:col md="6" id="previewSection">
			<aui:form action="" name="previewForm" method="POST">
				<!-- div id="templateString" cssClass="hide" -->
				
				<table class="table table-striped" id="<portlet:namespace/>preview">
					<tbody>
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

<%@include file="../templates/type-specific-string.jspf" %>
<%@include file="../templates/type-specific-numeric.jspf" %>

<%@include file="../templates/string.jspf" %>
<%@include file="../templates/numeric.jspf" %>

<%@include file="../templates/term-type-selector.jspf" %>

<script>
$(document).ready(function(){
	let SX = StationX(  '<portlet:namespace/>', 
								'<%= defaultLocale.toString() %>',
								'<%= locale.toString() %>',
								<%= jsonLocales.toJSONString() %> );
	
	let getTypeSpecificSectionTitle = function( termType ){
		switch( termType ){
		case SX.TermTypes.STRING:
			return '<liferay-ui:message key="string-attributes" />' ;
		case SX.TermTypes.NUMERIC:
			return '<liferay-ui:message key="numeric-attributes" />';
		case SX.TermTypes.LIST:
			return '<liferay-ui:message key="list-attributes" />';
		}
	};
	
	let dataStructure = SX.newDataStructure( 'preview' );
	let hasDataStructure = <%= hasDataStructure %>;

	if( hasDataStructure ){
		
	}
	else{
		
	}
	
	let termType = $('#<portlet:namespace/>termType').val();
	let currentTerm = dataStructure.createTerm( termType );
	
	currentTerm.renderAttributeSection( 'typeSpecific',  '<liferay-ui:message key="string-attributes"/>' );
	
	$('#<portlet:namespace/>dataTypeDefiner').change(function(eventObj){
		let prevTerm = currentTerm;
		
		switch( eventObj.originalEvent.target.id ){
		case '<portlet:namespace/>termDelimiter':
			dataStructure.getTermDelimiterFormValue( true );
			break;
		case '<portlet:namespace/>termDelimiterPosition':
			dataStructure.getTermDelimiterPositionFormValue( true );
			break;
		case '<portlet:namespace/>termValueDelimiter':
			dataStructure.getTermValueDelimiterFormValue( true );
			break;
		case '<portlet:namespace/>matrixBracketType':
			dataStructure.getMatrixBracketTypeFormValue( true );
			break;
		case '<portlet:namespace/>matrixElementDelimiter':
			dataStructure.getMatrixElementDelimiterFormValue( true );
			break;
		case '<portlet:namespace/>commentChar':
			dataStructure.getCommentCharFormValue( true );
			break;
		case '<portlet:namespace/>termType':
			let selectedTermType = currentTerm.getTermTypeFormValue();
			
			if( selectedTermType === currentTerm.termType ){
				// Do nothing
				break;
			}
			
			if( dataStructure.exist( currentTerm.termName ) ){
				$.alert({
					title: '<liferay-ui:message key="term-type-change-alert"/>',
					content: 'how-to-term-type-change'
				});
				
				currentTerm.setTermTypeFormValue();
			}
			else{
				currentTerm = dataStructure.createTerm( selectedTermType );
				currentTerm.renderAttributeSection( 'typeSpecific', getTypeSpecificSectionTitle(currentTerm.termType) );
			}
			break;
		case '<portlet:namespace/>termName':
			if( dataStructure.previewed( currentTerm.termName ) ){
				// It means the current term is one of the data structure and previewed on the preview panel.
				// Therefore, we must confirm that the term's name be changed and change preview.
				$.confirm({
					title: '<liferay-ui:message key="select-term-type" />',
					content: '<liferay-ui:message key="this-term-is-previewed-are-you-sure-to-change-the-name-of-the-term" />',
					type: 'orange',
					typeAnimated: true,
					buttons:{
						ok: {
							text: 'OK',
							btnClass: 'btn-blue',
							action: function(){
								let changedName = currentTerm.getTermNameFormValue();
								if( dataStructure.exist( changedName ) ){
									$.alert( changedName + 'already exist. Should be changed another name.' );
									currentTerm.setTermNameFormValue();
								}
								else{
									if( currentTerm.validateNameExpression( changedName ) === true ){
										currentTerm.termName = changedName;
										
										dataStructure.refreshSelectedTermPreview();
									}
									else{
										$.alert( 'Term Name[' + changedName +'] is unvalid. Try another one.');
										currentTerm.setTermNameFormValue();
									}
								} 
							}
						},
						cancel: function(){
							currentTerm.setTermNameFormValue();
						}
					},
					draggable: true
				}); 
			}
			else{
				currentTerm.getTermNameFormValue( true );
			}
		
			break;
		case '<portlet:namespace/>termVersion':
			const changedVersion = currentTerm.getTermVersionFormValue();
		
			const validated = dataStructure.validateTermVersion( changedVersion, currentTerm.termVersion );
			
			if( validated === true ){
				currentTerm.termVersion = changedVersion;
			}
			else{
				$.alert( changedVersion + ' ' + validated );
				currentTerm.setTermVersionFormValue();
			} 
			
			break;
		case '<portlet:namespace/>displayName':
			currentTerm.getDisplayNameFormValue(true);
			dataStructure.refreshSelectedTermPreview();
			break;
		case '<portlet:namespace/>definition':
			currentTerm.getDefinitionFormValue(true);
			break;
		case '<portlet:namespace/>tooltip':
			currentTerm.getTooltipFormValue(true);
			dataStructure.refreshSelectedTermPreview();
			break;
		case '<portlet:namespace/>synonyms':
			currentTerm.getSynonymsFormValue(true);
			break;
		case '<portlet:namespace/>mandatory':
			currentTerm.getMandatoryFormValue(true);
			dataStructure.refreshSelectedTermPreview();
			break;
		case '<portlet:namespace/>value':
			currentTerm.getValueFormValue(true);
			dataStructure.refreshSelectedTermPreview();
			break;
		case '<portlet:namespace/>minLength':
			currentTerm.getMinLengthFormValue(true);
			dataStructure.refreshSelectedTermPreview();
			break;
		case '<portlet:namespace/>maxLength':
			const minValue = currentTerm.getMinLengthFormValue();
			const maxValue = currentTerm.getMaxLengthFormValue();
			if( maxValue < minValue ){
				$.alert('Maximum value should be larger than minimum value.');
				currentTerm.setMaxLengthFormValue();
			}
			else{
				currentTerm.getMaxLengthFormValue(true);
				dataStructure.refreshSelectedTermPreview();
			}
			break;
		case '<portlet:namespace/>multipleLine':
			currentTerm.getMultipleLineFormValue(true);
			dataStructure.refreshSelectedTermPreview();
			break;
		case '<portlet:namespace/>validationRule':
			currentTerm.getValidationruleFormValue(true);
			break;
			
		}
		
		console.log('Data Structure: ' + JSON.stringify( dataStructure, null, 4 ) );
		console.log('Current Term: ' + JSON.stringify( currentTerm, null, 4 ) );
		
	});
	
	let validateMandatoryFields = function(){
		
	}
	
	/*******************************************************************************
	* Event handlers for buttons
	*******************************************************************************/
	$('#<portlet:namespace/>btnNewTerm').click(function(){
		$.confirm({
			title: '<liferay-ui:message key="select-term-type" />',
			content: Mustache.render( $('#<portlet:namespace/>termTypeSelectorDlg' ).html(), {} ),
			type: 'orange',
			typeAnimated: true,
			buttons:{
				ok: {
					text: 'OK',
					btnClass: 'btn-blue',
					action: function(){
						currentTerm = dataStructure.createTerm( $('#<portlet:namespace/>dlgTermType').val() );
						$('#<portlet:namespace/>termType').val( currentTerm.termType );
						currentTerm.renderAttributeSection( 'typeSpecific', getTypeSpecificSectionTitle(currentTerm.termType) );
						currentTerm.setAllFormValues();
						
						dataStructure.setSelectedTerm( null );
						
						$('#<portlet:namespace/>add').prop('disabled', false);
					}
				},
				cancel: function(){
					
				}
			},
			draggable: true
		});
	});

	$('#<portlet:namespace/>btnCopyTerm').click(function(){
		
	});
	
	$('#<portlet:namespace/>btnClear').click(function(){
		
	});

	$('#<portlet:namespace/>btnImportTerm').click(function(){
		
	});
	
	$('#<portlet:namespace/>add').click(function(){
		/*
		$.ajax({
			url: '<%= renderTermResourceCommandURL.toString() %>',
			method: 'post',
			dataType: 'text',
			data: {
				<portlet:namespace/>termType: currentTerm.termType,
				<portlet:namespace/>mandatory: currentTerm.mandatory,
				<portlet:namespace/>displayName: currentTerm.displayName.localizedMap['<%= locale.toString() %>'],
				<portlet:namespace/>tooltip: currentTerm.tooltip.localizedMap['<%= locale.toString() %>']
			},
			success: function( result ){
				console.log( result );
			},
			error: function(){
				console.log('error');
			}
		});
		*/
		
		dataStructure.addTerm( currentTerm, true );
		
		$('#<portlet:namespace/>add').prop('disabled', true);
		console.log( 'dataStrucyture: ', dataStructure );
	});
	
	
	/*******************************************************************************
	* Event handlers from the preview section
	*******************************************************************************/
	
	Liferay.on(SX.SXIcecapEvents.DATATYPE_PREVIEW_TERM_SELECTED, function(eventData){
		currentTerm = eventData.selectedTerm;
	});
	
});
</script>

