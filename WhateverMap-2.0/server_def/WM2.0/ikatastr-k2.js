[	
	{
		"title":"iKatastr - EPSG:32633",
		"maps":
		[
		{
			"title":"Open Street Map",
			"typeOfService":"TMS",
			"addressGoogle":["http://mt0.google.com/vt/lyrs=m&z=%@&x=%@&y=%@", 
				"{zoom}", 
				"{column}", 
				"{row}"],

			"address":["http://tile.openstreetmap.org/%@/%@/%@.png", 
				"{zoom}", 
				"{column}", 
				"{row}"],
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],

			"alphaLock":true,
			"visible":false,
			
			"projectionKey44":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",							 			
			"projectionKey44":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			
			
			"georeferencingType44":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]
			"boundingBox2":[-20037508.3392, -20037508.3392, 20037508.3392, 20037508.3392],
			
			
			"boundingBox":[-180, -85.05112878, 180, 85.05112878],			
			"georeferencingType88":0,	
			"coordToPixelX1":"(16777216 + 5340354 * dtor({x})) / (2 ^ zoom)",
			"coordToPixelY1":"(16777216 - 5340354 * log((1 + sin(dtor({y}))) / (1 - sin(dtor({y})))) / 2) / (2^zoom)",
			"coordToPixelX4":"({x}+180)/360",
			"coordToPixelY4":"0.5-ln((1+sin({y}*pi/180))/(1-sin({y}*pi/180)))/(4*pi)",
			"pixelToCoordX4":"({x}/256)/(2^{zoom})*360.0-180.0",
			"pixelToCoordY4":"(arctan(sinh(pi*(1-2*({y}/256)/(2^{zoom})))))*180.0/pi",

			"coordToPixelX":"({x}+180)/360",
			"coordToPixelY":"0.5-ln((1+sin({y}*pi/180))/(1-sin({y}*pi/180)))/(4*pi)",
			"pixelToCoordX44":"rtod(360*{x}-180)",
			"pixelToCoordY44":"rtod(90 - 360 * atan(exp(-(0.5-{y}) * 2 * pi)) / pi)",
			"pixelToCoordX":"(360*{x}-180)",
			"pixelToCoordY":"(90 - 360 * atan(exp(-(0.5-{y}) * 2 * pi)) / pi)",


"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
"georeferencingType":2,	
"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			
			"mapResolution18":[67108864, 67108864],
			"mapResolution20":[268435456, 268435456],
			"mapResolution21":[536870912, 536870912],
			"mapResolution22":[1073741824, 1073741824],
			"mapResolution23":[2147483648, 2147483648],
			"mapResolution24":[4294967296, 4294967296],
			
			"mapResolution":[536870912, 536870912],


			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +alpha=0 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +units=m +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round({selectedcoord.x})", 
				"round({selectedcoord.y})"],
			"infoType":"web"
		}
		,
		{
			"title":"Google Maps",
			"typeOfService":"TMS",
			"address":["http://mt0.google.com/vt/lyrs=m&z=%@&x=%@&y=%@", 
				"{zoom}", 
				"{column}", 
				"{row}"],

			"addressOSM":["http://tile.openstreetmap.org/%@/%@/%@.png", 
				"{zoom}", 
				"{column}", 
				"{row}"],
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],

			"alphaLock":true,
			
			"projectionKey44":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",							 			
			"projectionKey44":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			
			
			"georeferencingType44":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]
			"boundingBox2":[-20037508.3392, -20037508.3392, 20037508.3392, 20037508.3392],
			
			
			"boundingBox":[-180, -85.05112878, 180, 85.05112878],			
			"georeferencingType88":0,	
			"coordToPixelX1":"(16777216 + 5340354 * dtor({x})) / (2 ^ zoom)",
			"coordToPixelY1":"(16777216 - 5340354 * log((1 + sin(dtor({y}))) / (1 - sin(dtor({y})))) / 2) / (2^zoom)",
			"coordToPixelX4":"({x}+180)/360",
			"coordToPixelY4":"0.5-ln((1+sin({y}*pi/180))/(1-sin({y}*pi/180)))/(4*pi)",
			"pixelToCoordX4":"({x}/256)/(2^{zoom})*360.0-180.0",
			"pixelToCoordY4":"(arctan(sinh(pi*(1-2*({y}/256)/(2^{zoom})))))*180.0/pi",

			"coordToPixelX":"({x}+180)/360",
			"coordToPixelY":"0.5-ln((1+sin({y}*pi/180))/(1-sin({y}*pi/180)))/(4*pi)",
			"pixelToCoordX44":"rtod(360*{x}-180)",
			"pixelToCoordY44":"rtod(90 - 360 * atan(exp(-(0.5-{y}) * 2 * pi)) / pi)",
			"pixelToCoordX":"(360*{x}-180)",
			"pixelToCoordY":"(90 - 360 * atan(exp(-(0.5-{y}) * 2 * pi)) / pi)",


"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
"georeferencingType":2,	
"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			
			"mapResolution18":[67108864, 67108864],
			"mapResolution20":[268435456, 268435456],
			"mapResolution21":[536870912, 536870912],
			"mapResolution22":[1073741824, 1073741824],
			"mapResolution23":[2147483648, 2147483648],
			"mapResolution24":[4294967296, 4294967296],
			
			"mapResolution":[536870912, 536870912],


			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +alpha=0 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +units=m +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round({selectedcoord.x})", 
				"round({selectedcoord.y})"],
			"infoType":"web"
		}
		,
		{
			"title":"Google Maps - Satellite",
			"typeOfService":"TMS",
			"address":["http://mt0.google.com/vt/lyrs=y&z=%@&x=%@&y=%@", 
				"{zoom}", 
				"{column}", 
				"{row}"],
				
			"visible":false,
			"alpha":1.0,
			"alphaLock":true,
			
			"addressSRS":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
								
			"minLevel":1,
			"maxLevel":22,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"mapResolution":[536870912, 536870912],
			
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"boundingBox22":[-180, -85.05112878, 180, 85.05112878],
			

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round(-{selectedcoord.x})", 
				"round(-{selectedcoord.y})"],
			"infoType":"web"
		}
		,
		{
			"title":"Kontaminovaná místa",
			"typeOfService":"TMS",
			"address":["http://geoportal.cenia.cz/wmsconnector/com.esri.wms.Esrimap/cenia_sez?&LAYERS=0,3,2,1,4,5,6,7,8,9&QUERYABLE=true&&REQUEST=GetMap&SERVICE=WMS&VERSION=1.1.1&FORMAT=image/png&TRANSPARENT=TRUE&SRS=EPSG:4326&BBOX=%@,%@,%@,%@&WIDTH=256&HEIGHT=256", 
				"{tileLU.x}+0.0013", 
				"{tileRB.y}+0.00058", 
				"{tileRB.x}+0.0013", 
				"{tileLU.y}+0.00058"],

			"visibleFromLevel":16,
			"visibleToLevel":22,
			"visible":false,
			"addressSRS":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
								
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"mapResolution":[536870912, 536870912],
			
			"alphaLock":true,
			
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"boundingBox22":[-180, -85.05112878, 180, 85.05112878],
			

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round(-{selectedcoord.x})", 
				"round(-{selectedcoord.y})"],
			"infoType":"web"
		}
		,
		{
			"title":"Chráněné zóny",
			"typeOfService":"TMS",
			"address":["http://geoportal2.uhul.cz/wms_oprl/?&LAYERS=Biocentrum_USES,Biokoridor_NR_NF,Biokoridor_NR_F,Biokoridor_R_NF,Biokoridor_R_F,Biokoridor_L_NF,Biokoridor_L_F&QUERYABLE=true&REQUEST=GetMap&SERVICE=WMS&VERSION=1.1.1&FORMAT=image/png&TRANSPARENT=TRUE&SRS=EPSG:4326&BBOX=%@,%@,%@,%@&WIDTH=256&HEIGHT=256", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],

			"visibleFromLevel":16,
			"visibleToLevel":22,
			"visible":false,
			"addressSRS":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
								
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"mapResolution":[536870912, 536870912],
			
			"alphaLock":true,
			
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"boundingBox":[-20037508.3392, -20037508.3392, 20037508.3392, 20037508.3392],
			

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round(-{selectedcoord.x})", 
				"round(-{selectedcoord.y})"],
			"infoType":"web"
		}
		,
		{
			"title":"Katastr - mapy",
			"typeOfService":"TMS",
			"address44":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=KN&TRANSPARENT=TRUE", 
				"rtod({tileLU.x})", 
				"rtod({tileRB.y})", 
				"rtod({tileRB.x})", 
				"rtod({tileLU.y})"],

			"address-puv":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=KN&TRANSPARENT=TRUE", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],

			"address":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:32633&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=KN&TRANSPARENT=TRUE", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],


			"visibleFromLevel":17,
			"visibleToLevel":22,
			"addressSRS-puv":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
			"addressSRS":"+proj=utm +zone=33 +ellps=WGS84 +datum=WGS84 +units=m +no_defs",
								
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"mapResolution":[536870912, 536870912],
			
			"alphaLock":true,
			
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"projectionKey-32633":"+proj=utm +zone=33 +ellps=WGS84 +datum=WGS84 +units=m +no_defs",
			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924],
			"boundingBox11111":[166021.4431, 0.0000, 833978.5569, 9329005.1825],
			
			
			
			

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round(-{selectedcoord.x})", 
				"round(-{selectedcoord.y})"],
			"infoType":"web"
		}
		,
		{
			"title":"Katastr - mapy inverzní",
			"typeOfService":"TMS",
			"address":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=DKM_I&TRANSPARENT=TRUE", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],

			"visibleFromLevel":17,
			"visibleToLevel":22,
			"visible":false,
			"addressSRS":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
								
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"mapResolution":[536870912, 536870912],
			
			"alphaLock":true,
			
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"boundingBox22":[-180, -85.05112878, 180, 85.05112878],
			

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round(-{selectedcoord.x})", 
				"round(-{selectedcoord.y})"],
			"infoType":"web"
		}	
		,
		{
			"title":"Katastr - čísla budov",
			"typeOfService":"TMS",
			"address":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=DEF_BUDOVY&TRANSPARENT=TRUE", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],

			"visibleFromLevel":17,
			"visibleToLevel":22,
			"visible":false,
			"addressSRS":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
								
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"mapResolution":[536870912, 536870912],
			
			"alphaLock":true,
			
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"boundingBox22":[-180, -85.05112878, 180, 85.05112878],
			

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round(-{selectedcoord.x})", 
				"round(-{selectedcoord.y})"],
			"infoType":"web"
		}
		,
		{
			"title":"Katastr - čísla parcel",
			"typeOfService":"TMS",
			"address":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=DEF_PARCELY&TRANSPARENT=TRUE", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],

			"visibleFromLevel":17,
			"visibleToLevel":22,
			"visible":false,
			"addressSRS":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
								
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"mapResolution":[536870912, 536870912],
			
			"alphaLock":true,
			
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"boundingBox22":[-180, -85.05112878, 180, 85.05112878],
			

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round(-{selectedcoord.x})", 
				"round(-{selectedcoord.y})"],
			"infoType":"web"
		}
		
			
		
		]
	}	
]