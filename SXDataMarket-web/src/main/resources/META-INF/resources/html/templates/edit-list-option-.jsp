
<%@ include file="../init.jsp" %>

<div id="templateEditListOptionDlg">
		<aui:field-wrapper name="optionLabel" label="option-label" required="true" helpMessage="option-label-help">
		<liferay-ui:input-localized name="optionLabel" xml=""></liferay-ui:input-localized>
		</aui:field-wrapper> 
		<aui:input id="optionValue" name="optionValue" label="option-value" required="true" helpMessage="option-value-help"></aui:input> 
		<aui:input type="checkbox" id="optionSelected" name="optionSelected" label="selected" helpMessage="option-selected-help"></aui:input>
		<div id="<portlet:namespace/>activeTerms" ></div>
</div>