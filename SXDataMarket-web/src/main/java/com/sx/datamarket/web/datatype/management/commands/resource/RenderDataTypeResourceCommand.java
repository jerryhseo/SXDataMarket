package com.sx.datamarket.web.datatype.management.commands.resource;

import com.liferay.portal.kernel.io.unsync.UnsyncStringWriter;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
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
import com.sx.icecap.datatype.constants.IcecapDataTypeConstants;
import com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebKeys;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebPortletKeys;
import com.sx.icecap.sss.constants.IcecapSSSTermAttributes;
import com.sx.icecap.sss.constants.IcecapSSSTermTypes;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
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
	        "mvc.command.name="+IcecapDataTypeMVCCommands.RESOURCE_DATATYPE_RENDER_TERM,
	        "mvc.command.name="+IcecapDataTypeMVCCommands.RESOURCE_DATATYPE_RENDER_DATATYPE
	    },
	    service = MVCResourceCommand.class
)
public class RenderDataTypeResourceCommand extends BaseMVCResourceCommand{

	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {

				
		String termName = ParamUtil.getString(resourceRequest, "termName", "");
		String controlType = ParamUtil.getString(resourceRequest, "controlType", "");
		String controlName = ParamUtil.getString(resourceRequest, "controlName", "");
		boolean renderType = ParamUtil.getBoolean(resourceRequest, "renderType", true);
		String label = ParamUtil.getString(resourceRequest, "label", "");
		boolean required = ParamUtil.getBoolean(resourceRequest, "required", false);
		String helpMessage = ParamUtil.getString(resourceRequest, "helpMessage", "");
		String value = ParamUtil.getString(resourceRequest, "value", "");
		
		String templatePath = "/com/sx/datamarket/web/datatype/management/templates/" + controlType + ".ftl";
		System.out.println("Template Path: "+templatePath );

		Class<?> clazz = getClass();

		URLTemplateResource urlTemplateResource = new URLTemplateResource(templatePath, clazz.getResource(templatePath));

		UnsyncStringWriter unsyncStringWriter = new UnsyncStringWriter();

		Template template = TemplateManagerUtil.getTemplate(
				TemplateConstants.LANG_TYPE_FTL, urlTemplateResource, false);

		template.put("termName", termName);
		template.put(IcecapDataTypeWebKeys.CONTROL_TYPE, controlType);
		template.put(IcecapDataTypeWebKeys.CONTROL_NAME, controlName);
		template.put(IcecapDataTypeWebKeys.RENDER_TYPE, renderType);
		template.put(IcecapDataTypeWebKeys.LABEL, label);
		template.put(IcecapDataTypeWebKeys.REQUIRED, required);
		template.put(IcecapDataTypeWebKeys.HELP_MESSAGE, helpMessage);
		template.put(IcecapDataTypeWebKeys.VALUE, value);
		
		String namespace = resourceResponse.getNamespace();
		String dsNamespace = namespace.replaceAll("_", "__");
		template.put("namespace",  namespace);
		template.put("dsNamespace",  dsNamespace);

		if( controlType.equalsIgnoreCase(IcecapSSSTermTypes.STRING) ) {
			template = getStringTemplate( resourceRequest, template );
		}
		else if( controlType.equalsIgnoreCase(IcecapSSSTermTypes.NUMERIC) ) {
			template = getNumericTemplate( resourceRequest, template );
		}
		else if( controlType.equalsIgnoreCase(IcecapSSSTermTypes.LIST) ) {
			template = getListTemplate( resourceRequest, template );
		}
		
		Writer writer = resourceResponse.getWriter();
		
		template.processTemplate(unsyncStringWriter);

//		System.out.println(unsyncStringWriter);
		writer.write(unsyncStringWriter.toString());
//		include(resourceRequest, resourceResponse, "/html/DataTypeManagement/string-attributes.jsp" );
	}
	
	private Template getStringTemplate( ResourceRequest resourceRequest, Template template ) {

		String inputType = ParamUtil.getString(resourceRequest, IcecapDataTypeWebKeys.INPUT_TYPE, "text");
		String placeHolder = ParamUtil.getString(resourceRequest, IcecapDataTypeWebKeys.PLACE_HOLDER, "");
		
		template.put(IcecapDataTypeWebKeys.INPUT_TYPE, inputType);
		template.put(IcecapDataTypeWebKeys.PLACE_HOLDER, placeHolder);
		
		return template;
	}
	
	private Template getNumericTemplate( ResourceRequest resourceRequest, Template template ) {

		String minValue = ParamUtil.getString(resourceRequest, IcecapSSSTermAttributes.MIN_VALUE, "");
		boolean minBoundary = ParamUtil.getBoolean(resourceRequest, IcecapSSSTermAttributes.MIN_BOUNDARY, false);
		String maxValue = ParamUtil.getString(resourceRequest, IcecapSSSTermAttributes.MAX_VALUE, "");
		boolean maxBoundary = ParamUtil.getBoolean(resourceRequest, IcecapSSSTermAttributes.MAX_BOUNDARY, false);
		String unit = ParamUtil.getString(resourceRequest, IcecapSSSTermAttributes.UNIT, "");
		boolean uncertainty = ParamUtil.getBoolean(resourceRequest, IcecapSSSTermAttributes.UNCERTAINTY, false);
		String uncertaintyValue = ParamUtil.getString(resourceRequest, IcecapSSSTermAttributes.UNCERTAINTY_VALUE, "");
		
		template.put("minValue", minValue);
		template.put("minBoundary", minBoundary);
		template.put("maxValue", maxValue);
		template.put("maxBoundary", maxBoundary);
		template.put("unit", unit);
		template.put("uncertainty", uncertainty);
		template.put("uncertaintyValue", uncertaintyValue);
		
		return template;
	}

	private Template getListTemplate( ResourceRequest resourceRequest, Template template ) throws JSONException {
		
		String displayStyle = ParamUtil.getString(resourceRequest, IcecapSSSTermAttributes.DISPLAY_STYLE, "select");
		System.out.println("displayStyle: "+displayStyle);
		template.put("displayStyle", displayStyle);
		
		String options = ParamUtil.getString(resourceRequest, IcecapSSSTermAttributes.OPTIONS, "");
		System.out.println("options: "+options);
		template.put("options", optionsString2List(options));
		
		String dependentTerms = ParamUtil.getString(resourceRequest, IcecapSSSTermAttributes.DEPENDENT_TERMS, "");
		System.out.println("dependentTerms: "+dependentTerms);
		template.put("dependentTerms", dependentTermsString2List(dependentTerms));
		
		return template;
	}
	
	private List<String> dependentTermsString2List( String strDependentTerms ) throws JSONException{
		List<String> list = new ArrayList<>();
		
		JSONArray ja = JSONFactoryUtil.createJSONArray(strDependentTerms);
		for( int i=0; i< ja.length(); i++) {
			list.add( ja.getString(i) );
		}
		
		System.out.println(list);
		return list;
	}
	
	private  List<Map<String, Object>> optionsString2List(  String aryString ) throws JSONException{
		List<Map<String, Object>> list = new ArrayList<>();
		
		JSONArray ja = JSONFactoryUtil.createJSONArray( aryString );
		
		for( int i=0; i < ja.length(); i++ ) {
			JSONObject jo = ja.getJSONObject(i);
			
			Map<String, Object> optionMap = new HashMap<>();
			optionMap.put(IcecapSSSTermAttributes.LABEL, jo.getString(IcecapSSSTermAttributes.LABEL));
			optionMap.put(IcecapSSSTermAttributes.VALUE, jo.getString(IcecapSSSTermAttributes.VALUE));
			optionMap.put(IcecapSSSTermAttributes.SELECTED, jo.getBoolean(IcecapSSSTermAttributes.SELECTED));
			
			JSONArray jaActiveTerms = jo.getJSONArray(IcecapSSSTermAttributes.ACTIVE_TERMS);
			ArrayList<String> aryActiveTerms = new ArrayList<>();
			for( int j=0; j< jaActiveTerms.length(); j++) {
				aryActiveTerms.add(jaActiveTerms.getString(j));
			}
			
			optionMap.put(IcecapSSSTermAttributes.ACTIVE_TERMS, aryActiveTerms);
			
			JSONArray jaInactiveTerms = jo.getJSONArray("inactiveTerms");
			ArrayList<String> aryInactiveTerms = new ArrayList<>();
			for( int j=0; j< jaInactiveTerms.length(); j++) {
				aryInactiveTerms.add(jaInactiveTerms.getString(j));
			}
			
			optionMap.put("inactiveTerms", aryInactiveTerms);
			
			list.add(optionMap);
		}
		
		System.out.println(list);

		return list;
	}
}
