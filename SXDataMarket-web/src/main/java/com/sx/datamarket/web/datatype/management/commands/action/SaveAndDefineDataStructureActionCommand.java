package com.sx.datamarket.web.datatype.management.commands.action;

import com.liferay.portal.kernel.portlet.PortletURLFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCActionCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCActionCommand;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.LocalizationUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.sx.icecap.datatype.constants.IcecapDataTypeAttributes;
import com.sx.icecap.datatype.constants.IcecapDataTypeConstants;
import com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebKeys;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebPortletKeys;

import java.util.Locale;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;

import org.osgi.service.component.annotations.Component;

@Component(
		property = {
				"javax.portlet.name=" + IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT,
				"mvc.command.name=" + IcecapDataTypeMVCCommands.ACTION_DATATYPE_CREATE_AND_DEFINE_STRUCTURE,
				"mvc.command.name=" + IcecapDataTypeMVCCommands.ACTION_DATATYPE_UPDATE_AND_DEFINE_STRUCTURE
		},
		service = MVCActionCommand.class
)
public class SaveAndDefineDataStructureActionCommand extends BaseMVCActionCommand {

	@Override
	public void doProcessAction(ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {
		
		String cmd = ParamUtil.getString(actionRequest, IcecapDataTypeWebKeys.CMD);
		
		long dataTypeId = dataTypeId = ParamUtil.getLong(actionRequest, IcecapDataTypeAttributes.DATATYPE_ID, 0);
		
		String dataTypeName = ParamUtil.getString(actionRequest, IcecapDataTypeAttributes.DATATYPE_NAME);
		String dataTypeVersion = ParamUtil.getString(actionRequest, IcecapDataTypeAttributes.DATATYPE_VERSION);
		String extension = ParamUtil.getString(actionRequest, IcecapDataTypeAttributes.EXTENSION);
		Map<Locale, String> displayNameMap = LocalizationUtil.getLocalizationMap(actionRequest, IcecapDataTypeAttributes.DISPLAY_NAME);
		Map<Locale, String> descriptionMap = LocalizationUtil.getLocalizationMap(actionRequest, IcecapDataTypeAttributes.DESCRIPTION);
		Map<Locale, String> tooltipMap = LocalizationUtil.getLocalizationMap(actionRequest, IcecapDataTypeAttributes.TOOLTIP);
		
		String renderCommand = IcecapDataTypeMVCCommands.RENDER_DATATYPE_LIST;
		if( IcecapDataTypeConstants.CMD_REDIRECT_TO_DEFINE_STRUCTURE.equals(cmd) ) {
			renderCommand = IcecapDataTypeMVCCommands.RENDER_DEFINE_DATA_STRUCTURE;
		}
		
		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		
		PortletURL renderURL = PortletURLFactoryUtil.create(
				actionRequest, 
				themeDisplay.getPortletDisplay().getId(), 
				themeDisplay.getPlid(),
				PortletRequest.RENDER_PHASE);
		renderURL.setParameter(IcecapDataTypeWebKeys.DATATYPE_ID, String.valueOf(dataTypeId) );
		renderURL.setParameter(IcecapDataTypeWebKeys.MVC_RENDER_COMMAND_NAME, renderCommand);
		
		System.out.println("Render URL: "+renderURL.toString());
		
		actionResponse.sendRedirect(renderURL.toString());
		
	}

}
