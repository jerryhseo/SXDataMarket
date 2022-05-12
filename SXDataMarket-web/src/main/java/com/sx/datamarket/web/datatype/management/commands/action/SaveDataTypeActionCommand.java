package com.sx.datamarket.web.datatype.management.commands.action;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.portlet.PortletURLFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCActionCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCActionCommand;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.LocalizationUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.sx.icecap.datatype.constants.IcecapDataTypeAttributes;
import com.sx.icecap.datatype.constants.IcecapDataTypeConstants;
import com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebKeys;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebPortletKeys;
import com.sx.icecap.datatype.model.DataType;
import com.sx.icecap.datatype.service.DataTypeLocalService;
import com.sx.icecap.sss.constants.IcecapSSSWebKeys;

import java.util.Locale;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

@Component(
		property = {
				"javax.portlet.name=" + IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT,
				"mvc.command.name=" + IcecapDataTypeMVCCommands.ACTION_DATATYPE_ADD,
				"mvc.command.name=" + IcecapDataTypeMVCCommands.ACTION_DATATYPE_UPDATE
		},
		service = MVCActionCommand.class
)
public class SaveDataTypeActionCommand extends BaseMVCActionCommand {

	@Override
	public void doProcessAction(ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {
		
		System.out.println("SaveDataTypeActionCommand");
		String cmd = ParamUtil.getString(actionRequest, IcecapDataTypeWebKeys.CMD);
		
		long dataTypeId = dataTypeId = ParamUtil.getLong(actionRequest, IcecapDataTypeAttributes.DATATYPE_ID, 0);
		
		String dataTypeName = ParamUtil.getString(actionRequest, IcecapDataTypeAttributes.DATATYPE_NAME);
		String dataTypeVersion = ParamUtil.getString(actionRequest, IcecapDataTypeAttributes.DATATYPE_VERSION);
		String extension = ParamUtil.getString(actionRequest, IcecapDataTypeAttributes.EXTENSION);
		Map<Locale, String> displayNameMap = LocalizationUtil.getLocalizationMap(actionRequest, IcecapDataTypeAttributes.DISPLAY_NAME);
		Map<Locale, String> descriptionMap = LocalizationUtil.getLocalizationMap(actionRequest, IcecapDataTypeAttributes.DESCRIPTION);
		Map<Locale, String> tooltipMap = LocalizationUtil.getLocalizationMap(actionRequest, IcecapDataTypeAttributes.TOOLTIP);
		int status = ParamUtil.getInteger(actionRequest, IcecapDataTypeAttributes.STATUS, WorkflowConstants.STATUS_DRAFT);
		String backURL = ParamUtil.getString(actionRequest, IcecapDataTypeWebKeys.BACK_URL, "");
		
		DataType savedDataType = null;
		
		ServiceContext sc = ServiceContextFactory.getInstance(DataType.class.getName(), actionRequest);
		
		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		
		PortletURL renderURL = PortletURLFactoryUtil.create(
				actionRequest, 
				themeDisplay.getPortletDisplay().getId(), 
				themeDisplay.getPlid(),
				PortletRequest.RENDER_PHASE);
		
		String renderCommand = IcecapDataTypeMVCCommands.RENDER_DATATYPE_LIST; 
		if( cmd.equals( IcecapDataTypeConstants.CMD_REDIRECT_TO_DEFINE_STRUCTURE ) ) {
			renderCommand = IcecapDataTypeMVCCommands.RENDER_DEFINE_DATA_STRUCTURE;
			renderURL.setParameter(IcecapDataTypeWebKeys.BACK_URL, backURL);
		}
		renderURL.setParameter(IcecapSSSWebKeys.MVC_RENDER_COMMAND_NAME, renderCommand);
		
		if( dataTypeId == 0 ) {
			savedDataType = _dataTypeLocalService.addDataType (
					dataTypeName, 
					dataTypeVersion,
					extension,
					displayNameMap, 
					descriptionMap, 
					tooltipMap,
					status, 
					sc );
		}
		else {
			savedDataType = _dataTypeLocalService.updateDataType(
					dataTypeId, 
					dataTypeName, 
					dataTypeVersion, 
					extension, 
					displayNameMap, 
					descriptionMap, 
					tooltipMap, 
					status, 
					sc);
		}
		
		renderURL.setParameter(IcecapDataTypeWebKeys.DATATYPE_ID, String.valueOf(savedDataType.getDataTypeId()) );
		
		actionResponse.sendRedirect(renderURL.toString());
	}
	
	@Reference
	private DataTypeLocalService _dataTypeLocalService;

}
