package com.sx.datamarket.web.datatype.management.commands.resource;

import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCResourceCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.sx.icecap.datatype.constants.IcecapDataTypeMVCCommands;
import com.sx.icecap.datatype.constants.IcecapDataTypeWebPortletKeys;
import com.sx.icecap.datatype.search.DataTypeSearchRegistrar;
import com.sx.icecap.datatype.service.DataTypeLocalService;
import com.sx.icecap.sss.constants.IcecapSSSTermTypes;
import com.sx.icecap.sss.model.Term;
import com.sx.icecap.sss.service.TermLocalService;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.function.Consumer;

import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
@Component(
	    immediate = true,
	    property = {
	        "javax.portlet.name=" + IcecapDataTypeWebPortletKeys.DATATYPE_MANAGEMENT,
	        "mvc.command.name="+IcecapDataTypeMVCCommands.RESOURCE_DATATYPE_SAVE_STRUCTURE
	    },
	    service = MVCResourceCommand.class
)
public class SaveDataStructureResourceCommand extends BaseMVCResourceCommand {

	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {
		
		long dataTypeId = ParamUtil.getLong(resourceRequest, "dataTypeId");
		String dataStructure = ParamUtil.getString(resourceRequest, "dataStructure");
		
		System.out.println("dataTypeId: " + dataTypeId);
		//System.out.println(dataStructure);
		
		JSONObject jsonDataStructure = JSONFactoryUtil.createJSONObject(dataStructure);

		//System.out.println(jsonDataStructure.toString(4));
		
		JSONArray terms = jsonDataStructure.getJSONArray("terms");
		System.out.println(terms.toString(4));
		System.out.println("Term Count: "+terms.length());
		
		ServiceContext sc = ServiceContextFactory.getInstance(Term.class.getName(), resourceRequest);
		Date now = new Date();
		sc.setCreateDate(now);
		sc.setModifiedDate(now);
		
		for( int i=0; i<terms.length(); i++ ) {
			JSONObject term = terms.getJSONObject(i);
			
			String termType = term.getString("termType");
			String termName = term.getString("termName");
			String termVersion = term.getString("termVersion");
			if( termVersion.isEmpty() ) {
				termVersion = "1.0.0";
			}
			
			Set<Locale> availableLocales = LanguageUtil.getAvailableLocales();
			
			Map<String, String> displayNameMap = _jsonObject2Map( term.getJSONObject("displayName") );
			Map<String, String> definitionMap = _jsonObject2Map( term.getJSONObject("definition") );
			Map<String, String> tooltipMap = _jsonObject2Map( term.getJSONObject("tooltip") );
			
			String synonyms = term.getString("synonyms");
			JSONObject parent = term.getJSONObject("parent");
			long parentId = 0;
			if( parent.length() > 0 ) {
				parentId = _termLocalService.getTermIdByNameVersion( parent.getString("name"), parent.getString("version") );
			}
			
			
			String typeAttributes = _extractTermTypeAttributes(term, termType);
			System.out.println(termType + " Type Attribute: " + typeAttributes);
			/*
			_termLocalService.addTerm(
					term.getString("termName"),
					termVersion, termType, displayNameMap, definitionMap, tooltipMap, synonyms, attributes, status, sc)
			*/
		}
		//_dataTypeLocalService.setDataTypeStructure(dataTypeId, dataStructure);
	}
	
	private String _extractTermTypeAttributes( JSONObject jsonObj, String termType ) {
		
		if( termType.equalsIgnoreCase(IcecapSSSTermTypes.STRING) ) {
			return _extractStringAttributes(jsonObj);
		}
		else if( termType.equalsIgnoreCase(IcecapSSSTermTypes.NUMERIC) ) {
			return _extractNumericAttributes(jsonObj);
		}
		else if( termType.equalsIgnoreCase(IcecapSSSTermTypes.LIST) || 
				   termType.equalsIgnoreCase(IcecapSSSTermTypes.BOOLEAN) ) {
			return _extractListAttributes(jsonObj);
		}
		else {
			return "";
		}
		
	}
	
	private String _extractStringAttributes( JSONObject jsonObj ) {
		JSONObject json = JSONFactoryUtil.createJSONObject();
		
		if( !jsonObj.isNull("placeHolder") ) {
			JSONObject jsonPlaceHolder = jsonObj.getJSONObject("placeHolder");
			System.out.println( "jsonPlaceHolder: " + jsonPlaceHolder.toJSONString() );
			json.put("placeHolder",  jsonPlaceHolder.toJSONString() );
		}
		
		if( !jsonObj.isNull("minLength") ) {
			json.put("minLength",  jsonObj.getInt("minLength"));
		}

		if( !jsonObj.isNull("maxLength") ) {
			json.put("maxLength",  jsonObj.getInt("maxLength"));
		}

		if( !jsonObj.isNull("multiLine") ) {
			json.put("multiLine",  jsonObj.getBoolean("multiLine"));
		}
		
		if( !jsonObj.isNull("validationRule") ) {
			json.put("validationRule",  jsonObj.getString("validationRule"));
		}
		return json.toJSONString();
	}
	
	private String _extractNumericAttributes( JSONObject jsonObj ) {
		JSONObject json = JSONFactoryUtil.createJSONObject();
		
		if( !jsonObj.isNull("minValue") ) {
			json.put("minValue",  jsonObj.getDouble("minValue"));
		}
		
		if( !jsonObj.isNull("minBoundary") ) {
			json.put("minBoundary",  jsonObj.getBoolean("minBoundary"));
		}

		if( !jsonObj.isNull("maxValue") ) {
			json.put("maxValue",  jsonObj.getDouble("maxValue"));
		}
		
		if( !jsonObj.isNull("maxBoundary") ) {
			json.put("maxBoundary",  jsonObj.getBoolean("maxBoundary"));
		}

		if( !jsonObj.isNull("unit") ) {
			json.put("unit",  jsonObj.getString("unit"));
		}

		if( !jsonObj.isNull("uncertainty") ) {
			json.put("uncertainty",  jsonObj.getBoolean("uncertainty"));
		}

		if( !jsonObj.isNull("sweepable") ) {
			json.put("sweepable",  jsonObj.getBoolean("sweepable"));
		}

		return json.toJSONString();
	}
	
	/**
	 * This function is shared by ListTerm and BooleanTerm 
	 * because BooleanTerm is a kind of special cases of the ListTerm. 
	 * 
	 * @param jsonObj
	 * @return
	 */
	private String _extractListAttributes( JSONObject jsonObj ) {
		JSONObject json = JSONFactoryUtil.createJSONObject();
		
		if( !jsonObj.isNull("displayStyle") ) {
			json.put("displayStyle",  jsonObj.getString("displayStyle"));
		}
		
		if( !jsonObj.isNull("options") ) {
			JSONObject jsonOptions = jsonObj.getJSONObject("options");
			
			json.put("options",  jsonOptions.toJSONString());
		}

		return json.toJSONString();
	}
	
	private Map<String, String> _jsonObject2Map( JSONObject jsonObj ){
		Map<String, String> map = new HashMap<String, String>();
		Iterator<String> keyIterator = jsonObj.keys();
		while( keyIterator.hasNext() ) {
			String key = keyIterator.next();
			map.put(key, jsonObj.getString(key));
		}

		return map;
	}
	
	@Reference
	private DataTypeLocalService _dataTypeLocalService;
	
	@Reference
	private TermLocalService _termLocalService;
}
