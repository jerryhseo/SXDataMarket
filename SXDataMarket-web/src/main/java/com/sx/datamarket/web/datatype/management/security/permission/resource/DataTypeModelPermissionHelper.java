package com.sx.datamarket.web.datatype.management.security.permission.resource;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.security.permission.resource.ModelResourcePermission;
import com.sx.icecap.datatype.constants.IcecapDataTypeConstants;
import com.sx.icecap.datatype.model.DataType;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

@Component(
		immediate = true
)
public class DataTypeModelPermissionHelper{
	
	@Reference(
			target = "(model.class.name="+ IcecapDataTypeConstants.DATATYPE_CLASS_NAME+")",
			unbind = "-"
	)
	protected void setDataTypeModelResourcePermission(
			ModelResourcePermission<DataType> modelResourcePermission) {
		System.out.println("Model Resource Permission Injected: "+modelResourcePermission.getModelName());
		_dataTypeModelResourcePermission = modelResourcePermission;
	}
	private static ModelResourcePermission<DataType> _dataTypeModelResourcePermission;
	
	public static boolean contains(
			PermissionChecker permissionChecker, 
			DataType dataType,
			String actionId) throws PortalException{

		return _dataTypeModelResourcePermission.contains(
				permissionChecker, 
				dataType, 
				actionId);
	}

	public static boolean contains(
			PermissionChecker permissionChecker, 
			long dataTypeId, 
			String actionId) throws PortalException{
		
		return _dataTypeModelResourcePermission.contains(
				permissionChecker, 
				dataTypeId, 
				actionId);
	}

}
