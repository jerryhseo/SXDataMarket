package com.sx.datamarket.web.datatype.management.commands.render;

import com.liferay.portal.kernel.json.JSONException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
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
	        "mvc.command.name="+IcecapDataTypeMVCCommands.RENDER_DEFINE_DATA_STRUCTURE
	    },
	    service = MVCRenderCommand.class
)
public class DefineDataStructureRenderCommand implements MVCRenderCommand {

	@Override
	public String render(RenderRequest renderRequest, RenderResponse renderResponse) throws PortletException {
		
		long dataTypeId = ParamUtil.getLong(renderRequest, IcecapDataTypeWebKeys.DATATYPE_ID);
		
		
		if( dataTypeId <= 0 ) {
			throw new PortletException("A data type should be specified!");
		}
			
		DataType dataType = null;
			
		try {
			dataType = _dataTypeLocalService.getDataType(dataTypeId);
			renderRequest.setAttribute(IcecapDataTypeWebKeys.DATATYPE, dataType);
		} catch (Exception e) {
			throw new PortletException( "Cannot find data type: " + dataTypeId );
		}
		
		if( dataType.getHasDataStructure() ) {
			String strDataStructure = _dataTypeLocalService.getDataTypeStructure(dataTypeId);

			JSONObject jsonDataStructure = null;
			try{
				jsonDataStructure = JSONFactoryUtil.createJSONObject(strDataStructure);
			} catch( JSONException e ) {
				throw new PortletException(e.getMessage());
			}
			
			renderRequest.setAttribute(IcecapDataTypeWebKeys.DATA_STRUCTURE, jsonDataStructure);
		}

		return IcecapDataTypeConstants.JSP_DATATYPE_DEFINE_STRUTURE;
	}

	@Reference
	DataTypeLocalService _dataTypeLocalService;
}
