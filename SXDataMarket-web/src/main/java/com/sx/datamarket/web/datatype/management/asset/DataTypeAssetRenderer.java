package com.sx.datamarket.web.datatype.management.asset;

import com.liferay.asset.kernel.model.BaseJSPAssetRenderer;
import com.liferay.petra.string.StringUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.model.LayoutConstants;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.PortletURLFactoryUtil;
import com.liferay.portal.kernel.security.permission.resource.ModelResourcePermission;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.sx.icecap.datatype.constants.IcecapDataTypeConstants;
import com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebKeys;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebPortletKeys;
import com.sx.icecap.datatype.model.DataType;

import java.util.Locale;

import javax.portlet.PortletRequest;
import javax.portlet.PortletResponse;
import javax.portlet.PortletURL;
import javax.portlet.WindowState;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DataTypeAssetRenderer extends BaseJSPAssetRenderer<DataType> {

	private final ModelResourcePermission<DataType> _dataTypeModelResourcePermission;
    private DataType _dataType;
    
    public DataTypeAssetRenderer( DataType dataType, ModelResourcePermission<DataType> modelResoucePermission ) {
    	_dataType = dataType;
    	_dataTypeModelResourcePermission = modelResoucePermission;
    }

	@Override
	public DataType getAssetObject() {
		return _dataType;
	}

	@Override
	public long getGroupId() {
		return _dataType.getGroupId();
	}

	@Override
	public long getUserId() {
		return _dataType.getUserId();
	}

	@Override
	public String getUserName() {
		return _dataType.getUserName();
	}

	@Override
	public String getUuid() {
		return _dataType.getUuid();
	}

	@Override
	public String getClassName() {
		return DataType.class.getName();
	}

	@Override
	public long getClassPK() {
		return _dataType.getDataTypeId();
	}

	@Override
	public String getSummary(PortletRequest portletRequest, PortletResponse portletResponse) {
		ThemeDisplay themeDisplay = (ThemeDisplay)portletRequest.getAttribute(WebKeys.THEME_DISPLAY);

		return _dataType.getDescription( themeDisplay.getLocale() );
	}

	@Override
	public String getTitle(Locale locale) {
		return _dataType.getDisplayTitle(locale);
	}

	@Override
	public String getJspPath(HttpServletRequest httpServletRequest, String template) {
		if( template.equals(TEMPLATE_FULL_CONTENT) || 
			template.equals(TEMPLATE_ABSTRACT )) {
			
			httpServletRequest.setAttribute(IcecapDataTypeWebKeys.DATATYPE, _dataType);
			
			return IcecapDataTypeConstants.DATATYPE_MANAGEMENT_JSP_ROOT + "/" + template + ".jsp";
		}
		return null;
	}

	@Override
	public boolean include(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
			String template) throws Exception {
		httpServletRequest.setAttribute(IcecapDataTypeWebKeys.DATATYPE, _dataType);
		httpServletRequest.setAttribute(IcecapDataTypeWebKeys.HTML_UTIL, HtmlUtil.getHtml());
		httpServletRequest.setAttribute(IcecapDataTypeWebKeys.STRING_UTIL, new StringUtil());
		return super.include(httpServletRequest, httpServletResponse, template);
	}

	@Override
	public PortletURL getURLEdit(LiferayPortletRequest liferayPortletRequest,
			LiferayPortletResponse liferayPortletResponse) throws Exception {
		PortletURL portletURL = liferayPortletResponse.createLiferayPortletURL(
                getControlPanelPlid(liferayPortletRequest), IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT,
                PortletRequest.RENDER_PHASE);
        portletURL.setParameter(IcecapDataTypeWebKeys.MVC_RENDER_COMMAND_NAME, IcecapDataTypeMVCCommands.RENDER_DATATYPE_EDIT);
        portletURL.setParameter(IcecapDataTypeWebKeys.DATATYPE_ID, String.valueOf(_dataType.getDataTypeId()));
        portletURL.setParameter(IcecapDataTypeWebKeys.SHOW_BACK, Boolean.FALSE.toString());
        
        return portletURL;
	}

	@Override
	public String getURLView(LiferayPortletResponse liferayPortletResponse, WindowState windowState) throws Exception {
		return super.getURLView(liferayPortletResponse, windowState);
	}

	@Override
	public String getURLViewInContext(LiferayPortletRequest liferayPortletRequest,
			LiferayPortletResponse liferayPortletResponse, String noSuchEntryRedirect) throws Exception {
		try {
            long plid = PortalUtil.getPlidFromPortletId(
            		_dataType.getGroupId(),
                    IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT);

            PortletURL portletURL;
            if (plid == LayoutConstants.DEFAULT_PLID) {
                portletURL = liferayPortletResponse.createLiferayPortletURL(
                		getControlPanelPlid(liferayPortletRequest),
                		IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT, 
                		PortletRequest.RENDER_PHASE);
            } else {
                portletURL = PortletURLFactoryUtil.create(
                		liferayPortletRequest,
                		IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT, 
                		plid, 
                		PortletRequest.RENDER_PHASE);
            }

            portletURL.setParameter(IcecapDataTypeWebKeys.MVC_RENDER_COMMAND_NAME, IcecapDataTypeMVCCommands.RENDER_DATATYPE_VIEW);
            portletURL.setParameter(IcecapDataTypeWebKeys.DATATYPE_ID, String.valueOf(_dataType.getDataTypeId()));

            String currentUrl = PortalUtil.getCurrentURL(liferayPortletRequest);

            portletURL.setParameter(IcecapDataTypeWebKeys.REDIRECT, currentUrl);

            return portletURL.toString();

        } catch (PortalException e) {

        } catch (SystemException e) {
        }

        return noSuchEntryRedirect;
    }

	@Override
	public boolean isPrintable() {
		return true;
	}
    
    
}
