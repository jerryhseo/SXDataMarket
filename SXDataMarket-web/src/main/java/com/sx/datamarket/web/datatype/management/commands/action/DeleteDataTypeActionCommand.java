package com.sx.datamarket.web.datatype.management.commands.action;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCActionCommand;
import com.liferay.portal.kernel.util.LocalizationUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.sx.icecap.datatype.constants.IcecapDataTypeAttributes;
import com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebKeys;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebPortletKeys;

import java.util.Locale;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;

import org.osgi.service.component.annotations.Component;

@Component(
		property = {
				"javax.portlet.name=" + IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT,
				"mvc.command.name=" + IcecapDataTypeMVCCommands.ACTION_DATATYPE_DELETE
		},
		service = MVCActionCommand.class
)
public class DeleteDataTypeActionCommand implements MVCActionCommand {

	@Override
	public boolean processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws PortletException {
		
		String cmd = ParamUtil.getString(actionRequest, IcecapDataTypeWebKeys.CMD);
		
		long dataTypeId = dataTypeId = ParamUtil.getLong(actionRequest, IcecapDataTypeAttributes.DATATYPE_ID, 0);
		
		String dataTypeName = ParamUtil.getString(actionRequest, IcecapDataTypeAttributes.DATATYPE_NAME);
		String dataTypeVersion = ParamUtil.getString(actionRequest, IcecapDataTypeAttributes.DATATYPE_VERSION);
		String extension = ParamUtil.getString(actionRequest, IcecapDataTypeAttributes.EXTENSION);
		Map<Locale, String> descriptionMap = LocalizationUtil.getLocalizationMap(actionRequest, IcecapDataTypeAttributes.DESCRIPTION);
		Map<Locale, String> tooltipMap = LocalizationUtil.getLocalizationMap(actionRequest, IcecapDataTypeAttributes.TOOLTIP);
		
		System.out.println("CMD: "+cmd);
		
		return false;
	}

}
