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
						value="<%= dataType.getDataTypeName() %>" 
						disabled="true">
			</aui:input>
		</aui:col>
		<aui:col md="2" id="versionCol">
			<aui:input 
						type="text" 
						name="dataTypeVersion" 
						value="<%= dataType.getDataTypeVersion() %>" 
						disabled="true">
			</aui:input>
		</aui:col>
		<aui:col md="2" id="extensionCol">
			<aui:input 
						type="text" 
						name="dataTypeExtension" 
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
		<aui:col md="2">
			<aui:input 
						type="text" 
						name="termDelimiter" 
						required="true"
						helpMessage="term-delimiter-help"
						value="<%= hasDataStructure ? dataStructure.get("termDelimiter") : ";" %>">
			</aui:input>
		</aui:col>
		<aui:col md="2">
			<aui:select 
						name="termDelimiterPosition"
						helpMessage="term-delimiter-position-help">
				<aui:option label="start" value="false"></aui:option>
				<aui:option label="end" value="true" selected="true"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="2">
			<aui:select 
						name="termValueDelimiter"
						helpMessage="term-value-delimiter-help">
				<aui:option label="Equal" value="equal"  selected="true"></aui:option>
				<aui:option label="Space" value="space"></aui:option>
				<aui:option label="Colon" value="colon"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="2">
			<aui:select 
						name="matrixBracket"
						helpMessage="matrix-bracket-help">
				<aui:option label="parenthesis" value="parenthesis"  selected="true"></aui:option>
				<aui:option label="curly-bracket" value="curlyBracket"></aui:option>
				<aui:option label="square-bracket" value="squareBracket"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="2">
			<aui:select 
						name="matrixElementDelimiter"
						helpMessage="matrix-element-delimiter-help">
				<aui:option label="Space" value="space"  selected="true"></aui:option>
				<aui:option label="Comma" value="comma"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="2">
			<aui:input 
						type="text" 
						name="commentChar" 
						required="true"
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
					<aui:button value="import-term" cssClass="right"></aui:button>
				</aui:button-row>
				
				<aui:select name="termType" label="term-type" helpMessage="term-type-select-help">
					<aui:option label="String" value="String" selected="true"/>
					<aui:option label="Numeric" value="Numeric"/>
					<aui:option label="List" value="List"/>
					<aui:option label="ListArray" value="ListArray"/>
					<aui:option label="Boolean" value="Boolean"/>
					<aui:option label="Address" value="Address"/>
					<aui:option label="Phone" value="Phone"/>
					<aui:option label="EMail" value="EMail"/>
					<aui:option label="Date" value="Date"/>
					<aui:option label="Comment" value="Comment"/>
					<aui:option label="Group" value="Group"/>
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
	
				<script id="<portlet:namespace/>templateStringAttrs" type="text/template">
					<aui:fieldset label="{{ fieldSetLabel }}" id="typeSpecific">
						<aui:input 
									type="number"
									name="minLength" 
									label="min-length" 
									helpMessage="min-length-help">
						</aui:input>
						<aui:input 
									type="number"
									name="maxLength" 
									label="max-length" 
									helpMessage="string-max-length-help">
						</aui:input>
						<aui:input 
									type="checkbox"
									name="multiLine" 
									label="multiple-line" 
									helpMessage="string-multiple-line-help">
						</aui:input>
						<aui:input 
									type="text"
									name="validationRule" 
									label="validation-rule" 
									helpMessage="string-validation-rule-help">
						</aui:input>
					</aui:fieldSet>
				</script>
				
				<aui:fieldset-group markupView="lexicon" id="typeSpecific">
					<aui:fieldset label="string-attributes">
						<div id="<portlet:namespace/>Numeric" class="specific-attributes hide">
							<aui:col md="6">
							<aui:input name="minValue" label="min-value" type="number" ></aui:input>
							</aui:col>
							<aui:col md="6">
							<aui:input name="lowerBoundary" label="include-boundary" type="checkbox"></aui:input>
							</aui:col>
							<aui:col md="6">
							<aui:input name="maxValue" label="max-value" type="number"></aui:input>
							</aui:col>
							<aui:col md="6">
							<aui:input name="upperBoundary" label="include-boundary" type="checkbox"></aui:input>
							</aui:col>
							<aui:col md="8">
							<aui:input name="unit" label="unit" helpMessage="numeric-unit-help"></aui:input>
							</aui:col>
							<aui:col md="4">
							<div id="<portlet:namespace/>unitPreview"disabled="true" class="full" style="background-color:yellow;"></div>
							</aui:col>
							<aui:input name="uncertainty" label="allow-uncertainty" type="checkbox" helpMessage="numeric-allow-uncertainty-help"></aui:input>
							<aui:input name="sweepable" label="sweepable" type="checkbox" helpMessage="numeric-sweepable-help"></aui:input>
						</div>
						<div id="<portlet:namespace/>List" class="specific-attributes hide">
						</div>
						<div id="<portlet:namespace/>ListArray" class="specific-attributes hide">
						</div>
					</aui:fieldset>
				</aui:fieldset-group>
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

<script>
$(document).ready(function(){
	StationX.config( {
		namespace: '<portlet:namespace/>',
		defaultLanguage: '<%= defaultLocale.toString() %>',
		currentLanguage: '<%= locale.toString() %>',
		availableLanguages: <%= jsonLocales.toJSONString() %>
	});
	
	let dataStructure = StationX.newDataStructure();
	let hasDataStructure = <%= hasDataStructure %>;

	let termType = $('#<portlet:namespace/>termType').val();
	let currentTerm = dataStructure.createTerm( termType );

	let typeSpecificTemplate;
	let typeSpecificParams;
	switch( termType ){
	case: 'String':
		typeSpecificTemplate = $('#<portlet:namespace/>templateStringAttr').html();
		typeSpecificParams = {
			fieldSetLabel: '<liferay-ui:message key="string-attributes"/>'	
		};
		break;
	}
	
	let typeSpecificHtml = Mustache.render(typeSpecificTemplate, typeSpecificTemplate);
	
	let setFormData = function( term ){
		Object.keys( term ).forEach( function(key, index){
			switch( key ){
			case 'termType':
				$('<portlet:namespace/>termType').val( term.termType );
				replaceTypeSpecificSection( term.termType );
				break;
			case 'termName':
				$('<portlet:namespace/>termName').val( term.termName );
				break;
			case 'termVersion':
				$('<portlet:namespace/>termVersion').val( term.termVersion );
				break;
			case 'displayName':
				$('<portlet:namespace/>termVersion').val( term.termVersion );
				StationX.LocalizationUtil.setLocalizedValue( 'displayName', term.displayName.localizedMap );
				break;
			case 'definition':
				this.definition = new LocalizedObject(); 
				this.definition.setLocalizedMap( term.definition );
				break;
			case 'tooltip':
				this.tooltip = new LocalizedObject(); 
				this.tooltip.setLocalizedMap( term.tooltip );
				break;
			case 'synonyms':
				this.synonyms = term.synonyms;
				break;
			case 'mandatory':
				this.mandatory = term.mandatory;
				break;
			case 'value':
				this.value = term.value;
				break;
			case 'active':
				this.active = term.active;
				break;
			case 'order':
				this.order = term.order;
				break;
			
			}
		});
	};
	
	$('#<portlet:namespace/>dataTypeDefiner').change(function(eventObj){
		let prevTerm = currentTerm;
		
		switch( eventObj.originalEvent.target.id ){
		case '<portlet:namespace/>termDelimiter':
			dataStructure.termDelimiter = $('#<portlet:namespace/>termDelimiter').val();
			break;
		case '<portlet:namespace/>termDelimiterPosition':
			dataStructure.termDelimiterPosition = $('#<portlet:namespace/>termDelimiterPosition').val();
			break;
		case '<portlet:namespace/>termValueDelimiter':
			dataStructure.termValueDelimiter = $('#<portlet:namespace/>termValueDelimiter').val();
			break;
		case '<portlet:namespace/>matrixBracket':
			dataStructure.matrixBracket = $('#<portlet:namespace/>matrixBracket').val();
			break;
		case '<portlet:namespace/>matrixElementDelimiter':
			dataStructure.matrixElementDelimiter = $('#<portlet:namespace/>matrixElementDelimiter').val();
			break;
		case '<portlet:namespace/>termType':
			currentTerm.termType = $('#<portlet:namespace/>termType').val();
			
			switch( currentTerm.termType ){
			case 'String': 
				$('#typeSpecificTitle').text('string-attribute');
				break;
			case 'Numeric':
				$('#typeSpecificTitle').text('numeric-attribute');
				break;
			case 'List':
				$('#typeSpecificTitle').text('list-attribute');
				break;
			case 'ListArray':
				$('#typeSpecificTitle').text('list-array-attribute');
				break;
			case 'Array':
				$('#typeSpecificTitle').text('array-attribute');
				break;
			case 'Boolean':
				$('#typeSpecificTitle').text('boolean-attribute');
				break;
			case 'Date':
				$('#typeSpecificTitle').text('date-attribute');
				break;
			case 'Email':
				$('#typeSpecificTitle').text('email-attribute');
				break;
			case 'Address':
				$('#typeSpecificTitle').text('address-attribute');
				break;
			case 'Phone':
				$('#typeSpecificTitle').text('phone-attribute');
				break;
			case 'Matrix':
				$('#typeSpecificTitle').text('matrix-attribute');
				break;
			case 'Group':
				$('#typeSpecificTitle').text('group-attribute');
				break;
			case 'Object':
				$('#typeSpecificTitle').text('object-attribute');
				break;
			case 'ObjectArray':
				$('#typeSpecificTitle').text('object-array-attribute');
				break;
			case 'File':
				$('#typeSpecificTitle').text('file-attribute');
				break;
			case 'FileArray':
				$('#typeSpecificTitle').text('file-array-attribute');
				break;
			case 'DataLink':
				$('#typeSpecificTitle').text('data-link-attribute');
				break;
			case 'DataLinkArray':
				$('#typeSpecificTitle').text('data-link-array-attribute');
				break;
			case 'Comment':
				$('#typeSpecificTitle').text('comment-attribute');
				break;
			}
		
			
			break;
		case '<portlet:namespace/>termName':
			let changedName = $('#<portlet:namespace/>termName').val(); 
			console.log('Changed Term Name: '+changedName);
			if( dataStructure.exist( changedName ) ){
				alert( changedName + 'already exist. Should be changed another name.' );
				$('#<portlet:namespace/>termName').val(currentTerm.termName);
			}
			else{
				currentTerm.termName = changedName;
			} 
			
			break;
		case '<portlet:namespace/>termVersion':
			let changedVersion = $('#<portlet:namespace/>termVersion').val();
			const validated = dataStructure.validateTermVersion( changedVersion, currentTerm.termVersion );  
			if( validated === true ){
				currentTerm.termVersion = changedVersion;
				console.log('changedVersion: '+changedVersion);
				console.log( 'currentTerm.termVersion: '+currentTerm.termVersion);
				console.log('Current Term: ' + JSON.stringify( currentTerm, null, 4 ) );
			}
			else{
				alert( changedVersion + ' ' + validated );
				$('#<portlet:namespace/>termVersion').val(currentTerm.termVersion);
			} 
			
			break;
		case '<portlet:namespace/>displayName':
			currentTerm.displayName.localizedMap = StationX.LocalizationUtil.getLocalizeMap('displayName');
			break;
		case '<portlet:namespace/>definition':
			currentTerm.definition.localizedMap = StationX.LocalizationUtil.getLocalizeMap('definition');
			break;
		case '<portlet:namespace/>tooltip':
			currentTerm.tooltip.localizedMap = StationX.LocalizationUtil.getLocalizeMap('tooltip');
			break;
		case '<portlet:namespace/>synonyms':
			currentTerm.synonyms = $('#<portlet:namespace/>synonyms').val();
			break;
		case '<portlet:namespace/>mandatory':
			console.log('mandatory: ', );
			currentTerm.mandatory = $('#<portlet:namespace/>mandatory')[0].checked;
			break;
		case '<portlet:namespace/>value':
			currentTerm.value = $('#<portlet:namespace/>value').val();
			break;
		case '<portlet:namespace/>minLength':
			console.log('min:', $('#<portlet:namespace/>minLength').val());
			currentTerm.minLength = $('#<portlet:namespace/>minLength').val();
			break;
		case '<portlet:namespace/>maxLength':
			currentTerm.maxLength = $('#<portlet:namespace/>maxLength').val();
			break;
		case '<portlet:namespace/>multiLine':
			currentTerm.multiLine = $('#<portlet:namespace/>multiLine')[0].checked;
			break;
		case '<portlet:namespace/>validationRule':
			currentTerm.validationRule = $('#<portlet:namespace/>validationRule').val();
			break;
			
		}
		
		console.log('Data Structure: ' + JSON.stringify( dataStructure, null, 4 ) );
		console.log('Current Term: ' + JSON.stringify( currentTerm, null, 4 ) );
		
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
		
		dataStructure.addTerm( currentTerm );

		console.log( 'dataStrucyture: ', dataStructure );
		let template;
		if( currentTerm.mandatory ){
			template = $('#templateStringRequired').html();
		}
		else{
			template = $('#templateString').html();
		}
		
		//dataStructure.render( "preview", template, currentTerm );
		dataStructure.render( "preview", $('#templateString').html(), currentTerm );
	});
});
</script>

<script id="templateString" type="text/template">
	<tr>
		<td class="controlPreview">
			{{#required}}
				<aui:input type="text" id="{{name}}" name="{{name}}" label="{{label}}" required="true" helpMessage="{{helpMessage}}"></aui:input>
			{{/required}}
			{{^required}}
				<aui:input type="text" id="{{name}}" name="{{name}}" label="{{label}}" helpMessage="{{helpMessage}}"></aui:input>
			{{/required}}
		</td>
		<td>
			<button type="button" class="btn btn-default">
				<i class="icon-remove" />
			</button>
		</td>
	</tr>
</script>

