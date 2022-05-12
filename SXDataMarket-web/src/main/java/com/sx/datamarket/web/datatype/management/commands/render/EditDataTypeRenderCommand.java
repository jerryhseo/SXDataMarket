package com.sx.datamarket.web.datatype.management.commands.render;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCRenderCommand;
import com.liferay.portal.kernel.util.ParamUtil;
import com.sx.icecap.datatype.constants.IcecapDataTypeConstants;
import com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebKeys;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebPortletKeys;
import com.sx.icecap.datatype.model.DataType;
import com.sx.icecap.datatype.service.DataTypeLocalService;

import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

@Component(
	    immediate = true,
	    property = {
	        "javax.portlet.name=" + IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT,
	        "mvc.command.name="+IcecapDataTypeMVCCommands.RENDER_DATATYPE_EDIT
	    },
	    service = MVCRenderCommand.class
)
public class EditDataTypeRenderCommand implements MVCRenderCommand {

	@Override
	public String render(RenderRequest renderRequest, RenderResponse renderResponse) throws PortletException {
		
		long dataTypeId = ParamUtil.getLong(renderRequest, IcecapDataTypeWebKeys.DATATYPE_ID, 0);
		
		DataType dataType = null;
		if( dataTypeId > 0 ) {
			try {
				dataType = _dataTypeLocalService.getDataType(dataTypeId);
			} catch (Exception e) {
				throw new PortletException( "Cannot find data type: " + dataTypeId );
			}
			
			renderRequest.setAttribute(IcecapDataTypeWebKeys.DATATYPE, dataType);
		}
		
		return IcecapDataTypeConstants.JSP_DATATYPE_EDIT;
	}

	
	@Reference
	DataTypeLocalService _dataTypeLocalService;
}
