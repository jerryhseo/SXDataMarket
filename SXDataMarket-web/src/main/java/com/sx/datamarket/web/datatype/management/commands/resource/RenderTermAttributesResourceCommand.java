package com.sx.datamarket.web.datatype.management.commands.resource;

import com.liferay.portal.kernel.io.unsync.UnsyncStringWriter;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCResourceCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.template.Template;
import com.liferay.portal.kernel.template.TemplateConstants;
import com.liferay.portal.kernel.template.TemplateManagerUtil;
import com.liferay.portal.kernel.template.URLTemplateResource;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.FileUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebPortletKeys;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.portlet.PortletContext;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.http.HttpServletRequest;

import org.osgi.service.component.annotations.Component;

@Component(
	    immediate = true,
	    property = {
	        "javax.portlet.name=" + IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT,
	        "mvc.command.name="+IcecapDataTypeMVCCommands.RESOURCE_DATATYPE_RENDER_TERM_ATTR
	    },
	    service = MVCResourceCommand.class
)
public class RenderTermAttributesResourceCommand extends BaseMVCResourceCommand{

	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {
		
		System.out.println("doServeResource()");
		
		String termType = ParamUtil.getString(resourceRequest, "termType");
		System.out.println("Term Type: "+termType);
		boolean mandatory = ParamUtil.getBoolean(resourceRequest, "mandatory");
		System.out.println("Mandatory: "+mandatory);
		String displayName = ParamUtil.getString(resourceRequest, "displayName");
		System.out.println("displayName: "+displayName);
		String tooltip = ParamUtil.getString(resourceRequest, "tooltip");
		System.out.println("tooltip: "+tooltip);
		
		String contextPath = resourceRequest.getContextPath();
		System.out.println("Context Path: "+contextPath );
		
		PortletContext pc = resourceRequest.getPortletSession().getPortletContext();
		InputStream templatePath = pc.getResourceAsStream("/html/DataTypeManagement/max-length.jsp");
//				contextPath+"/com/sx/datamarket/web/datatype/management/templates/string-attributes.ftl");
		System.out.println("Real Path: "+ templatePath.available() );
		String result = new BufferedReader(new InputStreamReader(templatePath))
			    .lines().parallel().collect(Collectors.joining("\n"));
		System.out.println("result: "+result);
		
//		List<String> templateFile = Files.readAllLines(Paths.get(contextPath) );
//		templateFile.stream().forEach(System.out::println);
		
		String name = "/com/sx/datamarket/web/datatype/management/templates/string-attributes.ftl";
		Map<String, Object> context = new HashMap<>();
		Writer writer = resourceResponse.getWriter();
		
		ThemeDisplay themeDisplay = (ThemeDisplay)resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		String namespace = themeDisplay.getPortletDisplay().getNamespace();
	
			Class<?> clazz = getClass();

			URLTemplateResource urlTemplateResource = new URLTemplateResource(
				name, clazz.getResource(name));

			Template template = TemplateManagerUtil.getTemplate(
				TemplateConstants.LANG_TYPE_FTL, urlTemplateResource, false);

			template.put("namespace", namespace);
			template.put("mandatory", mandatory);
			template.put("displayName", displayName);
			template.put("tooltip", tooltip);

			UnsyncStringWriter unsyncStringWriter = new UnsyncStringWriter();

			template.processTemplate(unsyncStringWriter);

//			System.out.println(unsyncStringWriter);
		
//		include(resourceRequest, resourceResponse, "/html/DataTypeManagement/string-attributes.jsp" );
	}
}
