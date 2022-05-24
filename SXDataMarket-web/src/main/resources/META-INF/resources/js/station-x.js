(function (w, factory) {
	w.StationX = factory();
}(window, function () {
	let NAMESPACE;
	let CONFIG;
	let DEFAULT_LANGUAGE;
	let CURRENT_LANGUAGE;
	let AVAILABLE_LANGUAGES = [];
	let MULTI_LANGUAGE = true;

	let Util = {
	};
	
	let UIUtil = {
			getMandatorySpan: function(){
				let $span = $('<span>').attr({
					'class': 'reference-mark text-warning'
				});
				let $svg = $('<svg>').attr({
					'class': 'lexicon-icon lexicon-icon-asterisk',
					'focusable': false,
					'role': 'presentation',
					'viewBox': '0 0 512 512'
				});
				$span.append( $svg );
				console.log( '$svg: ', $svg );
				
				$svg.append( $('<path>').attr({
					'd': 'M323.6,190l146.7-48.8L512,263.9l-149.2,47.6l93.6,125.2l-104.9,76.3l-96.1-126.4l-93.6,126.4L56.9,435.3l92.3-123.9L0,263.8l40.4-122.6L188.4,190v-159h135.3L323.6,190L323.6,190z',
					'class': 'lexicon-icon-outline'
				}) )

				console.log( '$span: ', $span );

				return $span;
			},
			getTooltipSpan: function( tooltip ){
				
			}
	};
	
	class DataType {
		static DEFAULT_HAS_DATA_STRUCTURE = false;
		static DEFAULT_SHOW_TOOLTIP = true;
		
		constructor( dataTypeName, dataTypeVersion ){
			this.dataTypeName = dataTypeName;
			this.dataTypeVersion = dataTypeVersion;
			this.hasDataStructure = DataType.DEFAULT_HAS_DATA_STRUCTURE;
			this.showTooltip = DataType.DEFAULT_SHOW_TOOLTIP;
		}
	}
	
	let TermTypes = {
		STRING : 'String',
		NUMERIC : 'Numeric',
		BOOLEAN : 'Boolean',
		LIST : 'List',
		LIST_ARRAY : 'ListArray',
		MATRIX : 'Matrix',
		FILE : 'File',
		FILE_ARRAY : 'FileArray',
		OBJECT : 'Object',
		OBJECT_ARRAY : 'ObjectArray',
		ARRAY : 'Array',
		DATA_LINK : 'DataLink',
		DATA_LINK_ARRAY : 'DataLinkArray',
		ADDRESS : 'Address',
		DATE : 'Date',
		PHONE : 'Phone',
		EMAIL : 'EMail',
		GROUP : 'Group',
		COMMENT : 'Comment',
		
		DEFAULT_TERM_TYPE: 'String',


		TERM_TYPES : [ 
				'String',
				'Numeric',
				'Boolean',
				'List',
				'ListArray',
				'Matrix',
				'File',
				'FileArray',
				'Object',
				'ObjectArray',
				'Array',
				'DataLink',
				'DataLinkArray',
				'Address',
				'Date',
				'Phone',
				'EMail',
				'Group',
				'Comment'
			]
	};
	
	class TermAttributes{
		constructor(){
		}
		
		static ACTIVE = 'active';
		static AVAILABLE_LANGUAGE_IDS = 'availableLanguageIds';
		static COUNTRY_CODE = 'countryCode';
		static DATATYPE_NAME = 'dataTypeName';
		static DATATYPE_VERSION = 'dataTypeVersion';
		static DEFINITION = 'definition';
		static DEFAULT_LANGUAGE_ID = 'defaultLanguageId';
		static DEFAULT_LOCALE = 'defaultLocale';
		static DEPENDENT_TERMS = 'dependentTerms';
		static DIMENSION_X = 'dimensionX';
		static DIMENSION_Y = 'dimensionY';
		static DISABLED = 'disabled';
		static DISPLAY_NAME = 'displayName';
		static DISPLAY_STYLE = 'displayStyle';
		static ELEMENT_TYPE = 'elementType';
		static FILE_ID = 'fileId';
		static FORMAT = 'format';
		static ID = 'id';
		static LIST_ITEM = 'listItem';
		static LIST_ITEM_VALUE = 'listItemValue';
		static LIST_ITEMS = 'listItems';
		static LOWER_BOUNDARY = 'lowerBoundary';
		static LOWER_OPERAND = 'lowerOperand';
		static MANDATORY = 'mandatory';
		static NAME = 'name';
		static MAX_LENGTH ="maxLength_";
		static MAX_VALUE ="maxValue_";
		static MIN_LENGTH ="minLength_";
		static MIN_VALUE ="minValue_";
		static NAME_TEXT = 'nameText';
		static NEW_LINE ="newLine_";
		static OPERAND = 'operand';
		static ORDER = 'order';
		static PATH = 'path';
		static PATH_TYPE = 'pathType';
		static RANGE = 'range';
		static REF_DATATYPES = 'refDataTypes';
		static REF_DATABASES = 'refDatabases';
		static SWEEPABLE = 'sweepable';
		static SYNONYMS = 'synonyms';
		static TERM_NAME = 'termName';
		static TERM_TYPE = 'termType';
		static TERM_VERSION = 'termVersion';
		static TEXT = 'text';
		static TOOLTIP = 'tooltip';
		static UNCERTAINTY = 'uncertainty';
		static UNCERTAINTY_VALUE = 'uncertaintyValue';
		static UNIT = 'unit';
		static UPPER_BOUNDARY = 'upperBoundary';
		static UPPER_OPERAND = 'upperOperand';
		static URI = 'uri';
		static URI_TYPE = 'uriType';
		static URL = 'url';
		static VALIDATION_RULE  = 'validationRule';
		static VALUE = 'value';
		static VALUE_DELIMITER = 'valueDelimiter';
		static VERSION = 'version';
	}
	
	class LocalizationUtil {
		constructor(){}
		
		static getSelectedLanguage( inputId ){
			if( MULTI_LANGUAGE === false ){
				return CURRENT_LANGUAGE;
			}
			
			let baseId = NAMESPACE + inputId;
			const $languageContainer = $('#'+baseId+'BoundingBox');
			const selectedLanguage = $languageContainer.find('.btn-section').text().replace('-', '_');
			
			return selectedLanguage;
		}
		
		static getLocalizeMap( inputId ){
			let baseId = NAMESPACE + inputId;
			const selectedLanguage = LocalizationUtil.getSelectedLanguage( inputId ).trim();
			
			return AVAILABLE_LANGUAGES.reduce( ( obj, locale ) => {
				let localizedInputId = NAMESPACE+inputId+'_'+locale;
				
				if( selectedLanguage === locale ){
					obj[locale] = $('#'+baseId).val();
				}
				else{
					let value = $('#'+localizedInputId).val();
					if( value ){
						obj[locale] = value;
					}
				}
				
				return obj;
			}, {} );
		}
		
	}
	
	let SXIcecapEvents = {
		DATATYPE_PREVIEW_TERM_DELETED: 'DATATYPE_PREVIEW_TERM_DELETED'
	}
	
	class LocalizedObject {
		constructor( jsonContent  ){
			this.localizedMap = {};
			
			if( jsonContent ){
				parseJSON( jsonContent );
			}
		}
		
		isEmpty(){
			return Object.keys( this.localizedMap ).length ? false : true;
		}
		
		getLocalizedMap(){
			return this.localizedMap;
		}
		
		setLocalizedMap( map ){
			this.localizedMap = map;
		}
		
		getText( locale ){
			return this.localizedMap[locale];
		}
		
		addText( locale, text, force ){
			this.localizedMap[locale] = text;
		}
		
		updateText( locale, text ){
			this.localizedMap[locale] = text;
		}
		
		removeText( locale ){
			delete this.localizedMap[locale];
		}
		
		
		
		toXML(){
			
		}
		
		toJSON(){
			return this.localizedMap;
		}
		
		parseXML( xml ){
			
		}
		
		parseJSON( jsonContent ){
			let content = jsonContent;
			if( typeof jsonContent === 'string' ){
				content = JSON.parse( jsonContent );
			}
			
			for( key in content ){
				this.localizedMap[key] = content[key];
			}
		}
	}
	
	class Term {
		static DEFAULT_TERM_ID = 0;
		static VALID_NAME_PATTERN=/^[_a-zA-Z]([_a-zA-Z0-9])*$/;
		
		constructor( termType ){
			this.termId = 0;
			if( termType ){
				this.termType = termType;
			}
			else{
				this.termType = 'Sting';
			}
				
			this.termName = '';
			this.termVersion = '';
			this.displayName = new LocalizedObject();
			this.definition = new LocalizedObject();
			this.tooltip = new LocalizedObject();
			this.synonyms = new Array();
			this.mandatory = false;
			this.value = null;
			this.dependentTerms = [];
			this.activeTerms = [];
			this.ative = true;
			this.order = null;
		}
		
		getSynonyms(){
			return this.synonyms;
		}
		
		setSynonyms( synonyms ){
			this.synonyms = synonyms;
		}
		
		addSynonym( synonym ){
			this.synonyms.push( synonym );
		}
		
		removeSynonym( synonym ){
			this.synonyms.every( (item, index, arr ) => {
				if( item === synonym ){
					this.synonyms.splice( index, 1 );
					return false;
				}
				
				return true;
			});
		}
		
		addDependentTerm( termName ){
			this.dependentTerms.push( termName );
		}
		
		removeDependentTerm( termName ){
			this.dependentTerms.every( (item, index, arr ) => {
				if( item === termName ){
					this.dependentTerms.splice( index, 1 );
					return false;
				}
				return true;
			});
		}
		
		addActiveTerm( termName ){
			this.activeTerms.push( termName );
		}
		
		removeActiveTerm( termName ){
			this.activeTerms.every( (item, index, arr ) => {
				if( item === termName ){
					this.activeTerms.splice( index, 1 );
					return false;
				}
				return true;
			});
		}
		
		/**
		 *  Validate the term name matches naming pattern.
		 *  If it is needed to change naming pattern, 
		 *  change VALID_NAME_PATTERN static value.
		 *  
		 *   @return
		 *   		true,		if matched
		 *   		false,		when not matched
		 */
		validateNameExpression( name ){
			if( name ){
				return Term.VALID_NAME_PATTERN.test( name );
			}
			else{
				return Term.VALID_NAME_PATTERN.test(this.termName);
			}
		}
		
		validateMandatoryFields(){
			if( !this.termName )	return 'termName';
			if( !this.termVersion )	return 'termVersion';
			if( this.displayName.isEmpty() )	return 'displayName';
			
			return true;
		}
		
		validate(){
			let result = this.validateMandatoryFields();
			if( result !== true ){
				alert( result + ' should be not empty.' );
				$('#'+NAMESPACE+result).focus();
				
				let eventData = {
						termName: this.termName
				};
				
				return false;
			}
			
			if( this.validateNameExpression() === false ){
				alert( 'Invalid term name. Please try another one.' );
				$('#'+NAMESPACE+result).focus();
				return false;
			}
			
			return true;
		}
		
		toJSON(){
			let json = {};
			
			json.termType = this.termType;
			if( this.termName )		json.termName = this.termName;	
			if( this.termVersion )	json.termVersion = this.termVersion;
			if( ! this.displayName.isEmpty() ) json.displayName = this.displayName.localizedMap;
			if( ! this.definition.isEmpty() ) json.definition = this.definition.localizedMap;
			if( ! this.tooltip.isEmpty() ) json.tooltip = this.tooltip.localizedMap;
			if( this.synonyms.length ) json.synonyms = this.synonyms;
			if( this.mandatory )	json.mandatory = this.mandatory;
			if( this.value )	json.value = this.value;
			if( this.order )	json.order = this.order;
			if( this.dependentTerms.length ) json.dependentTerms = this.dependentTerms;
			if( this.activeTerms.length ) json.activeTerms = this.activeTerms;
			
			return json;
		}
		
		parse( json ){
			let content = json;
			if( typeof json === 'string' ){
				content = JSON.parse( json );
			}
			
			let unparsed = {};
			
			Objet.keys( content ).forEach(function(key, index){
				switch( key ){
				case 'termType':
					this.termType = content.termType;
					break;
				case 'termName':
					this.termName = content.termName;
					break;
				case 'termVersion':
					this.termVersion = content.termVersion;
					break;
				case 'displayName':
					this.displayName = new LocalizedObject(); 
					this.displayName.setLocalizedMap( content.displayName );
					break;
				case 'definition':
					this.definition = new LocalizedObject(); 
					this.definition.setLocalizedMap( content.definition );
					break;
				case 'tooltip':
					this.tooltip = new LocalizedObject(); 
					this.tooltip.setLocalizedMap( content.tooltip );
					break;
				case 'synonyms':
					this.synonyms = content.synonyms;
					break;
				case 'mandatory':
					this.mandatory = content.mandatory;
					break;
				case 'value':
					this.value = content.value;
					break;
				case 'active':
					this.active = content.active;
					break;
				case 'order':
					this.order = content.order;
					break;
				default:
					unparsed[key] = content[key];
				}
			});
			
			return unparsed;
		}
		
		/**
		 * Render User Interface of the term.
		 * 
		 * Developers must follow these rules on a JSP for the UI before call this function:
		 * 		1. Include template JSPFs, 'type-specipic-[term type]'
		 * 		2. Create <table> and <tbody> tags under the 'panelId'
		 * 
		 * @params
		 * 		panelId,		string, id of the container
		 * 
		 * @returns
		 * 		void
		 */
		render( panelId ){
			let template = $('#template'+this.termType).html();
			
			let params = {
					name: this.termName,
					label: this.displayName.getText(CURRENT_LANGUAGE),
					required: this.mandatory,
					multipleLine: this.multipleLine,
					helpMessage: this.tooltip.getText(CURRENT_LANGUAGE)
			};

			console.log('params: ', params);
			
			this.$row = $( Mustache.render(template, params) );
			
			let $panel = $('#'+NAMESPACE+panelId );
			
			let $tbody = $panel.find('tbody');
			
			// Change the previous highlighted border to normal 
			$tbody.find('.highlight-border').each( function(){
				$(this).removeClass('highlight-border');
			});
			
			this.$row.addClass('highlight-border');
			
			const that = this;
			this.$row.click( function( event ){
				console.log( 'click event: ', event );
				if( $(event.target).is('button') || $(event.target).is('i') ){
					let idToBeRemoved = NAMESPACE+'toBeRemoved';
					$(event.currentTarget).attr('id', idToBeRemoved);
					$tbody.find('#'+idToBeRemoved).remove();
					
					const eventData = {
							termName: that.termName
					};
					
					Liferay.fire (SXIcecapEvents.DATATYPE_PREVIEW_TERM_DELETED, eventData );
				}
				else{
					// Change the previous highlighted border to normal 
					$tbody.find('.highlight-border').each( function(){
						$(this).removeClass('highlight-border');
					});
				}
				$(this).addClass('highlight-border');
			});
			
			$tbody.append( this.$row );
		}
		
		getRenderParams(){
			return {
					'termId': this.termId,
					'termType': this.termType,
					'termName': this.termName,
					'termVersion': this.termVersion
			};
		}
	}
	
	/* 1. String */
	class StringTerm extends Term {
		constructor(){
			super( 'String' );
			
			this.minLength = 1;
			this.maxLength = null;
			this.multipleLine = false;
			this.validationRule = '';
		}
		
		setLocalizedMap ( attrName, controlId ){
			
			defaultLocales.forEach( function( locale ) {
				let localizedInputId = NAMESPACE+id+'_'+locale;
				
				this.localizedMap[locale] = $('#localizedInputId').val();
			});
			
			return this.localizedMap;
		}
		
		
		toJSON(){
			let json = super.toJSON();
			
			if( this.minLength > 1 )	json.minLength = this.minLength;
			if( this.maxLength )	json.maxLength = this.maxLength;
			if( this.multipleLine )	json.multipleLine = this.multipleLine;
			if( this.validationRule )	json.validationRule = this.validationRule;
			
			return json;
		}
		
		toJSONString(){
			return JSON.stringify( toJSON() );
		}
		
		parse( json ){
			let unparsed = super.parse( json );
			let unvalid = {};
			
			Object.keys( unparsed ).forEach( (key, index) => {
				switch( key ){
				case 'minLength':
					this.minLength = unparsed.minLength;
					break;
				case 'maxLength':
					this.maxLength = unparsed.maxLength;
					break;
				case 'multipleLine':
					this.multipleLine = unparsed.multipleLine;
					break;
				case 'validationRule':
					this.validationRule = unparsed.validationRule;
					break;
				default:
					console.log('Un-identified Attribute: '+key);
					unvalid[key] = unparsed[key];
				}
			});
			
			return unvalid;
		}
		
		render( panelId ){
			super.render( panelId );
		}
		
		renderAttributeSection( $panelId, template, params ){
			
			let $html = Mustache.render(template, params);
			
			$panelId.append( $html );
		}
		
		validation(){
			
		}
	}
	
	/* 2. NumericTerm */
	class NumericTerm extends Term{
		constructor(){
			super('Numeric');
			
			this.minValue = null;
			this.minBoundary = false;
			this.maxValue = null;
			this.maxBoundary = false;
			this.unit = null;
			this.applyUncertainty = false;
			this.sweepable = false;
		}
	}
	
	/* 20. IntergerTerm */
	class IntegerTerm extends NumericTerm{
		constructor(){
			
		}
	}
	
	/* 3. ListTerm */
	class ListTerm extends Term {
		constructor(){
			
		}
	}
	
	/* 4. ListArrayTerm */
	class ListArrayTerm extends Term {
		constructor(){
			
		}
	}
	
	/* 5. EMailTerm */
	class EMailTerm  extends Term{
		constructor(){
			
		}
	}
	
	/* 6. AddressTerm */
	class AddressTerm extends Term{
		constructor(){
			
		}
	}

	/* 7. ArrayTerm */
	class ArrayTerm extends Term{
		constructor(){
			
		}
	}
	
	/* 8. MatrixTerm */
	class MatrixTerm extends Term{
		constructor(){
			
		}
	}
	
	/* 9. ObjectTerm */
	class ObjectTerm extends Term{
		constructor(){
			
		}
	}
	
	/* 10. ObjectArrayTerm */
	class ObjectArrayTerm extends Term{
		constructor(){
			
		}
	}


	/* 11. PhoneTerm */
	class PhoneTerm extends Term{
		constructor(){
			
		}
	}
	
	/* 12. DateTerm */
	class DateTerm extends Term{
		constructor(){
			
		}
	}
	
	/* 13. FileTerm */
	class FileTerm extends Term{
		constructor(){
			
		}
	}

	/* 14. FileArrayTerm */
	class FileArrayTerm extends Term{
		constructor(){
			
		}
	}

	/* 15. DataLinkTerm */
	class DataLinkTerm extends Term{
		constructor(){
			
		}
	}

	/* 16. DataLinkArrayTerm */
	class DataLinkArrayTerm extends Term{
		constructor(){
			
		}
	}

	/* 17. CommentTerm */
	class CommentTerm extends Term{
		constructor(){
			
		}
	}

	/* 18. GroupTerm */
	class GroupTerm extends Term{
		constructor(){
			
		}
	}

	/* 19. BooleanTerm */
	class BooleanTerm extends Term{
		constructor(){
			
		}
	}

	class DataStructure {
		constructor(){
			this.dataTypeId = 0;
			this.termDelimiter='\n';
			this.termDelimiterPosition = true;
			this.matrixBracket='[';
			this.matrixDelimiter=' ';
			this.commentString='#';
			this.tooltip = new LocalizedObject();
			this.terms = new Array();
			
			let that = this;
			Liferay.on(SXIcecapEvents.DATATYPE_PREVIEW_TERM_DELETED, function(eventData){
				that.terms = that.terms.filter( function( term, index, ary ){
					console.log('Compare: ', term.termName, eventData.termName );
					if( term.termName === eventData.termName )	return false;
					else	return true;
					
				});
				
				console.log( 'Filtered Terms: ', that.terms );
			});
		}
		
		loadDataStructure( url, paramData ){
			let params = Liferay.Util.ns( NAMESPACE, paramData);
			
			$.ajax({
				url: url,
				method: 'post',
				data: params,
				dataType: 'json',
				success: function( dataStructure ){
					console.log( dataStruture );
					parse( dataStruture );
				},
				error: function( data, e ){
					console.log(data);
					console.log('AJAX ERROR-->' + e);
				}
			});
		}
		
		createTerm( termType ){
			switch( termType ){
			case 'String':
				return new StringTerm();
			case 'Numeric':
				return new NumericTerm();
			case 'List':
				return new ListTerm();
			case 'ListArray':
				return new ListArrayTerm();
			case 'Array':
				return new ArrayTerm();
			case 'EMail':
				return new EMailTerm();
			case 'Date':
				return new DateTerm();
			case 'Address':
				return new AddressTerm();
			case 'Phone':
				return new PhoneTerm();
			case 'Object':
				return new ObjectTerm();
			case 'ObjectArray':
				return new ObjectArrayTerm();
			case 'File':
				return new FileTerm();
			case 'FileArray':
				return new FileArrayTerm();
			case 'DataLink':
				return new FileTerm();
			case 'DataLinkArray':
				return new DataLinkArrayTerm();
			case 'Comment':
				return new CommentTerm();
			case 'Group':
				return new GroupTerm();
			default:
				return new StringTerm();
			}
		}
		
		getTerm( termName ){
			if( !termName ){
				return null;
			}
			
			let searchedTerm = null;
			
			this.terms.forEach( (term) => {
				if( term.termName === termName ){
					searhedTerm = term;
				}
			});
			
			return searchedTerm;
		}
		
		addTerm( term ){
			if( term.validate() === false ){
				return false;
			}
			
			this.terms.push( term );
			
			return true;
		}
		
		removeTerm( termName ){
			this.terms.forEach( (element, index, array) => {
				console.log( array );
				if( element.name === termName ){
					this.terms.splice( index, 1 );
				}
			});
			
			console.log( this.terms );
		}
		
		updateTerm( term ){
			this.terms.forEach( (element, index, array) => {
				if( element.name === term.name ){
					this.terms[index] = term;
				}
			});
			
			console.log( this.terms );
		}
		
		exist( termName ){
			let exist = false;
			
			const STOP = false;
			const CONTINUE = true;
			
			this.terms.every( (element) => {
				if( element.name === termName ){
					exist = true;
					return STOP;
				}
				
				return CONTINUE;
			});
			
			return exist;
		}
		
		validateTermVersion( updated, previous ){
			let updatedParts = updated.split('.');
			console.log( 'updatedParts: ', updatedParts);
			
			let ok = true;
			
			// Check valid format
			if( updatedParts.length !== 3 )		return false;
			
			updatedParts.every((part)=>{
				
				let int = Number(part); 
				
				if( Number.isInteger(int) ){
					return true;
				}
				else{
					ok = false;
					return false;
				}
			});
			
			if( !ok )		return false;
			
			// updated version should be bigger than previous versison
			if( previous ){
				console.log( 'Previous: '+previous);
				
				let previousParts = previous.split('.');
				
				if( Number(updatedParts[0]) < Number(previousParts[0]) ){
					console.log('0: ', Number(updatedParts[0]), Number(previousParts[0]));
					ok = false;
				}
				else if( Number(updatedParts[1]) < Number(previousParts[1]) ){
					console.log('1: ', Number(updatedParts[1]), Number(previousParts[1]));
					ok = false;
				}
				else if( Number(updatedParts[2]) <= Number(previousParts[2]) ){
					console.log('2: ', Number(updatedParts[2]), Number(previousParts[2]));
					ok = false;
				}
			}
			
			return ok;
		}
		
		parse( json ){
			
		}
		
		render( panelId ){
			this.terms.forEach((term)=>{
					term.render( panelId );
			});
		}
		
		countTerms(){
			return this.terms.length;
		}
		
		toJSON(){
			return{
				dataTypeId : this.dataTypeId,
				termDelimiter : this.termDelimiter,
				termDelimiterPosition : this.termDelimiterPosition,
				matrixBracket : this.matrixBracket,
				matrixDelimiter : this.matrixDelimiter,
				commentString : this.commentString,
				tooltip : this.tooltip.localizedMap,
				terms : this.terms 
			};
		}
		
	}
	
    return {
    	namespace: NAMESPACE,
    	defaultLanguage: DEFAULT_LANGUAGE,
    	availableLanguages: AVAILABLE_LANGUAGES,
    	config: function( attributes ){
    		CONFIG = attributes;
    		NAMESPACE = CONFIG.namespace;
    		DEFAULT_LANGUAGE = CONFIG.defaultLanguage;
    		CURRENT_LANGUAGE = CONFIG.currentLanguage,
    		AVAILABLE_LANGUAGES = CONFIG.availableLanguages;
    		
    		if( AVAILABLE_LANGUAGES.length < 2 ){
    			MULTI_LANGUAGE = false;
    		}
    	},
    	LocalizationUtil: LocalizationUtil,
    	DataType: DataType,
    	newDataType: function(){
    		return new DataType();
    	},
    	DataStructure: DataStructure,
    	newDataStructure: function ( jsonDataStructure ){
    		return new DataStructure( jsonDataStructure );
    	},
    	TermTypes: TermTypes,
    	Term: Term,
    	newTerm: function( termType ){
    		if( !termType ){
    			return new StringTerm();
    		}
    		
    		switch( termType ){
	    		case TermTypes.STRING:
	    			return new StringTerm();
	    		case TermTypes.NUMERIC:
	    			return new NumericTerm();
	    		case TermTypes.LIST:
	    			return new ListTerm();
	    		case TermTypes.LIST_ARRAY:
	    			return new ListArrayTerm();
	    		case TermTypes.EMAIL:
	    			return new EMailTerm();
	    		case TermTypes.ADDRESS:
	    			return new AddressTerm();
	    		case TermTypes.ARRAY:
	    			return new ArrayTerm();
	    		case TermTypes.Matrix:
	    			return new MatrixTerm();
	    		case TermTypes.OBJECT:
	    			return new ObjectTerm();
	    		case TermTypes.OBJECT_ARRAY:
	    			return new ObjectArrayTerm();
	    		case TermTypes.PHONE:
	    			return new PhoneTerm();
	    		case TermTypes.DATE:
	    			return new DateTerm();
	    		case TermTypes.FILE:
	    			return new FileTerm();
	    		case TermTypes.FILEArray:
	    			return new FileArrayTerm();
	    		case TermTypes.DATA_LINK:
	    			return new DataLinkTerm();
	    		case TermTypes.DATA_LINK_ARRAY:
	    			return new DataLinkArrayTerm();
	    		case TermTypes.COMMENT:
	    			return new CommentTerm();
	    		case TermTypes.GROUP:
	    			return new GroupTerm();
	    		default:
	    			return null;
    		}
    	},
    	StringTerm: StringTerm,
    	Util: Util
    };
}
));


