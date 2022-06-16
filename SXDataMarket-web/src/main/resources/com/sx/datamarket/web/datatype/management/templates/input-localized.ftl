<div class="lfr-ddm-field-group field-wrapper">
	<label class="control-label" for="${controlName}">
		${label}
<#if required == true>
		<span class="reference-mark text-warning">
			<svg class="lexicon-icon lexicon-icon-asterisk" focusable="false" role="presentation" viewBox="0 0 512 512">
				<path class="lexicon-icon-outline" d="M323.6,190l146.7-48.8L512,263.9l-149.2,47.6l93.6,125.2l-104.9,76.3l-96.1-126.4l-93.6,126.4L56.9,435.3l92.3-123.9L0,263.8l40.4-122.6L188.4,190v-159h135.3L323.6,190L323.6,190z"></path>
			</svg>
		</span>
		<span class="hide-accessible">Required</span>
</#if>
<#if helpMessage?has_content>	
		<span class="taglib-icon-help lfr-portal-tooltip" title="${helpMessage}">
			<span>
				<svg class="lexicon-icon lexicon-icon-question-circle-full" focusable="false" role="presentation" viewBox="0 0 512 512">
					<path class="lexicon-icon-outline" d="M256 0c-141.37 0-256 114.6-256 256 0 141.37 114.629 256 256 256s256-114.63 256-256c0-141.4-114.63-256-256-256zM269.605 360.769c-4.974 4.827-10.913 7.226-17.876 7.226s-12.873-2.428-17.73-7.226c-4.857-4.827-7.285-10.708-7.285-17.613 0-6.933 2.428-12.844 7.285-17.788 4.857-4.915 10.767-7.402 17.73-7.402s12.932 2.457 17.876 7.402c4.945 4.945 7.431 10.854 7.431 17.788 0 6.905-2.457 12.786-7.431 17.613zM321.038 232.506c-5.705 8.923-13.283 16.735-22.791 23.464l-12.99 9.128c-5.5 3.979-9.714 8.455-12.668 13.37-2.955 4.945-4.447 10.649-4.447 17.145v1.901h-34.202c-0.439-2.106-0.731-4.184-0.936-6.291s-0.321-4.301-0.321-6.612c0-8.397 1.901-16.413 5.705-24.079s10.24-14.834 19.309-21.563l15.185-11.322c9.070-6.7 13.605-15.009 13.605-24.869 0-3.57-0.644-7.080-1.901-10.533s-3.219-6.495-5.851-9.128c-2.633-2.633-5.969-4.71-9.977-6.291s-8.66-2.369-13.927-2.369c-5.705 0-10.561 1.054-14.571 3.16s-7.343 4.769-9.977 8.017c-2.633 3.247-4.594 7.022-5.851 11.322s-1.901 8.66-1.901 13.049c0 4.213 0.41 7.548 1.258 10.065l-39.877-1.58c-0.644-2.311-1.054-4.652-1.258-7.080-0.205-2.399-0.321-4.769-0.321-7.080 0-8.397 1.58-16.619 4.74-24.693s7.812-15.214 13.927-21.416c6.114-6.173 13.663-11.176 22.645-14.951s19.368-5.676 31.188-5.676c12.229 0 22.996 1.785 32.3 5.355 9.274 3.57 17.087 8.25 23.435 14.014 6.319 5.764 11.089 12.434 14.248 19.982s4.74 15.331 4.74 23.289c0.058 12.581-2.809 23.347-8.514 32.27z"></path>
				</svg>
			</span>
			<span class="taglib-text hide-accessible">${helpMessage}</span>
		</span>
</#if>
	</label>
	<div class="input-group input-localized input-localized-input" id="${controlName}">
		<div class="input-group-item">
			<input 
					aria-describedby="${controlName}_desc" 
					class="form-control language-value " 
					dir="ltr" 
					id="${controlName}" 
					name="${controlName}" 
					type="text"
<#if value?has_content> 
					value="${value}"
</#if>
			>
		</div>
		<div class="hide-accessible" id="${controlName}_desc">English (United States) Translation</div>
		<input class="field form-control" id="${controlName}_en_US" name="${controlName}_en_US" type="hidden" value="" dir="ltr">
		<div class="input-group-item input-group-item-shrink input-localized-content" role="menu">
			<div class="dropdown lfr-icon-menu ">
				<button aria-expanded="false" aria-haspopup="true" class="btn btn-monospaced btn-secondary dropdown-toggle input-localized-trigger" id="${controlName}${controlName}Menu" title="" type="button">
					<span class="inline-item" id="mhaw__column1__0">
						<svg class="lexicon-icon lexicon-icon-en-us" focusable="false" role="presentation" viewBox="0 0 512 512">
							<rect y="64" fill="#C0CFD8" width="512" height="384"></rect>
							<rect x="16" y="80" fill="#E03232" width="480" height="32"></rect>
							<rect x="16" y="112" fill="#FFFFFF" width="480" height="32"></rect>
							<rect x="16" y="144" fill="#E03232" width="480" height="32"></rect>
							<rect x="16" y="176" fill="#FFFFFF" width="480" height="32"></rect>
							<rect x="16" y="208" fill="#E03232" width="480" height="32"></rect>
							<rect x="16" y="240" fill="#FFFFFF" width="480" height="32"></rect>
							<rect x="16" y="272" fill="#E03232" width="480" height="32"></rect>
							<rect x="16" y="304" fill="#FFFFFF" width="480" height="32"></rect>
							<rect x="16" y="336" fill="#E03232" width="480" height="32"></rect>
							<rect x="16" y="368" fill="#FFFFFF" width="480" height="32"></rect>
							<rect x="16" y="400" fill="#E03232" width="480" height="32"></rect>
							<rect x="16" y="80" fill="#66A1CC" width="256" height="192"></rect>
							<rect x="16" y="80" fill="#0035A0" width="256" height="192"></rect>
						</svg>
					</span>
					<span class="btn-section">en-US</span>
				</button>
				<script type="text/javascript">
					// 	<![CDATA[
					AUI().use('liferay-menu', function(A) {(function() {var $ = AUI.$;var _ = AUI._;
							Liferay.Menu.register('${controlName}${controlName}Menu');
						})();});
					// ]]>
				</script>
				<ul class="dropdown-menu dropdown-menu-left-side">
					<div id="${controlName}PaletteBoundingBox">
						<div class="input-localized-palette-container palette-container" id="${controlName}PaletteContentBox">
							<li class="" role="presentation">
								<a href="javascript:;" target="_self" class="dropdown-item palette-item active lfr-icon-item taglib-icon" id="${controlName}${controlName}Menu__en_2d_us_2d_span_2d_class_2d_label_2d_label_2d_info_2d_default_2d__2f_span_2d_" role="menuitem" data-languageid="en_US" data-index="0" data-value="en_US">
									<span class="inline-item inline-item-before">
										<svg class="lexicon-icon lexicon-icon-en-us" focusable="false" role="presentation" viewBox="0 0 512 512">
											<rect y="64" fill="#C0CFD8" width="512" height="384"></rect>
											<rect x="16" y="80" fill="#E03232" width="480" height="32"></rect>
											<rect x="16" y="112" fill="#FFFFFF" width="480" height="32"></rect>
											<rect x="16" y="144" fill="#E03232" width="480" height="32"></rect>
											<rect x="16" y="176" fill="#FFFFFF" width="480" height="32"></rect>
											<rect x="16" y="208" fill="#E03232" width="480" height="32"></rect>
											<rect x="16" y="240" fill="#FFFFFF" width="480" height="32"></rect>
											<rect x="16" y="272" fill="#E03232" width="480" height="32"></rect>
											<rect x="16" y="304" fill="#FFFFFF" width="480" height="32"></rect>
											<rect x="16" y="336" fill="#E03232" width="480" height="32"></rect>
											<rect x="16" y="368" fill="#FFFFFF" width="480" height="32"></rect>
											<rect x="16" y="400" fill="#E03232" width="480" height="32"></rect>
											<rect x="16" y="80" fill="#66A1CC" width="256" height="192"></rect>
											<rect x="16" y="80" fill="#0035A0" width="256" height="192"></rect>
										</svg>
									</span>
									<span class="taglib-text-icon">
										en-US
										<span class="label label-info">Default</span>
									</span>
								</a>
							</li>
							<li class="" role="presentation">
								<a href="javascript:;" target="_self" class="dropdown-item palette-item lfr-icon-item taglib-icon" id="${controlName}${controlName}Menu__ko_2d_kr_2d_span_2d_class_2d_label_2d_label_2d_warning_2d_untranslated_2d__2f_span_2d_" role="menuitem" data-languageid="ko_KR" data-index="1" data-value="ko_KR">
									<span class="inline-item inline-item-before">
										<svg class="lexicon-icon lexicon-icon-ko-kr" focusable="false" role="presentation" viewBox="0 0 512 512">
											<rect y="64" fill="#B0BEC9" width="512" height="384"></rect>
											<rect x="16" y="81.3" fill="#FFFFFF" width="480" height="352"></rect>
											<path fill="#E03232" d="M256,176c-44.2,0-80,35.8-80,80h160C336,211.8,300.2,176,256,176z"></path>
											<path fill="#0035A0" d="M256,336c44.2,0,80-35.8,80-80H176C176,300.2,211.8,336,256,336z"></path>
											<line fill="none" stroke="#000000" stroke-width="16" stroke-miterlimit="10" x1="384" y1="128" x2="448" y2="192"></line>
											<line fill="none" stroke="#000000" stroke-width="16" stroke-miterlimit="10" x1="64" y1="192" x2="128" y2="128"></line>
											<line fill="none" stroke="#000000" stroke-width="16" stroke-miterlimit="10" x1="128" y1="384" x2="64" y2="320"></line>
											<line fill="none" stroke="#000000" stroke-width="16" stroke-miterlimit="10" x1="448" y1="320" x2="384" y2="384"></line>
										</svg>
									</span>
									<span class="taglib-text-icon">
										ko-KR
										<span class="label label-warning">Untranslated</span>
									</span>
								</a>
							</li>
						</div>
					</div>
				</ul>
			</div>
		</div>
	</div>

	<div class="form-text"></div>
</div>