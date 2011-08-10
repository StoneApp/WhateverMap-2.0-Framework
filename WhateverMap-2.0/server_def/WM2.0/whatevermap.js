[	
	{
		"title":"iKatastr",
		"maps":
		[
		{
			"title":"Open Street Maps",
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

			"address":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=KN&TRANSPARENT=TRUE", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],


			"visibleFromLevel":17,
			"visibleToLevel":22,
			"addressSRS":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
								
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"mapResolution":[536870912, 536870912],
			
			"alphaLock":true,
			
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",			

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924],
						
			
			
			

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
			

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"round(-{selectedcoord.x})", 
				"round(-{selectedcoord.y})"],
			"infoType":"web"
		}
		]
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
		"title":"Mapy.cz + katastr",
		"maps":
		[
		{
            "title":"MapyCZ",
            "typeOfService":"TMS",
            "address":["http://m1.mapserver.mapy.cz/base/%@_%@000_%@000", 
                       "{zoom}", 
                       "hex:{column} * (2 ^ (16 - ({zoom}))) + 8192", 
                       "hex:(3 * (2 ^ (({zoom})-2)) - {row}) * (2 ^ (16-({zoom}))) + 8192 - (2 ^ (16-({zoom})))"],
            "minLevel":3,
            "maxLevel":16,
            "deltaLevel":1,
            "tileResolution":[256, 256],
            "mapResolution":[12582912, 12582912],

            "projectionKey":"+proj=tmerc +lat_0=0 +lon_0=15 +k=0.9996 +x_0=4200000 +y_0=-1300000 +ellps=WGS84 +datum=WGS84 +to_meter=0.03125 +no_defs",
            "georeferencingType":2,
            "boundingBox":[33554432, 33554432, 234881024, 234881024],
            
            
            "infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"-{selectedcoord.x}", 
				"-{selectedcoord.y}"],
			"infoType":"web"
          
        }
        ,
        {
			"title":"ČÚZK - Katastr - mapy",
			"typeOfService":"TMS",
			"address":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:32633&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=KN&TRANSPARENT=TRUE", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],
            "addressSRS-epsg:4326":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
			"addressSRS":"+proj=utm +zone=33 +ellps=WGS84 +datum=WGS84 +units=m +no_defs",
			
			"minLevel":3,
            "maxLevel":16,
            "deltaLevel":1,
            "tileResolution":[256, 256],
            "mapResolution":[12582912, 12582912],

            "projectionKey":"+proj=tmerc +lat_0=0 +lon_0=15 +k=0.9996 +x_0=4200000 +y_0=-1300000 +ellps=WGS84 +datum=WGS84 +to_meter=0.03125 +no_defs",
            "georeferencingType":2,
            "boundingBox":[33554432, 33554432, 234881024, 234881024],
            
			"visibleFromLevel":13,
			"visibleToLevel":16,

	

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"-{selectedcoord.x}", 
				"-{selectedcoord.y}"],
			"infoType":"web"
		}
		]
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
	{
		"title":"iKatastr - Google",
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
			
			"coordToPixelX":"({x}+180)/360",
			"coordToPixelY":"0.5-ln((1+sin({y}*pi/180))/(1-sin({y}*pi/180)))/(4*pi)",
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


			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"-{selectedcoord.x}", 
				"-{selectedcoord.y}"],
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
			
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
						
			"coordToPixelX":"({x}+180)/360",
			"coordToPixelY":"0.5-ln((1+sin({y}*pi/180))/(1-sin({y}*pi/180)))/(4*pi)",
			"pixelToCoordX44":"rtod(360*{x}-180)",
			"pixelToCoordY44":"rtod(90 - 360 * atan(exp(-(0.5-{y}) * 2 * pi)) / pi)",
			"pixelToCoordX":"(360*{x}-180)",
			"pixelToCoordY":"(90 - 360 * atan(exp(-(0.5-{y}) * 2 * pi)) / pi)",


			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			
			"mapResolution":[536870912, 536870912],


			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"-{selectedcoord.x}", 
				"-{selectedcoord.y}"],
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

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"-{selectedcoord.x}", 
				"-{selectedcoord.y}"],
			"infoType":"web"
		}		
		,
		{
			"title":"Katastr - mapy",
			"typeOfService":"TMS",

			"address":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=KN&TRANSPARENT=TRUE", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],


			"visibleFromLevel":17,
			"visibleToLevel":22,
			"addressSRS":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
								
			"minLevel":1,
			"maxLevel":21,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"mapResolution":[536870912, 536870912],
			
			"alphaLock":true,
			
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			

			"georeferencingType":2,	
			"boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924],
			

			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"-{selectedcoord.x}", 
				"-{selectedcoord.y}"],
			"infoType":"web"
		}	
		]
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
		"title":"Bing Maps + Katastr ČÚZK",
		"maps":
		[
		{
			"title":"Bing Maps",
			"typeOfService":"TMS",
			"address1":["http://ecn.t%@.tiles.virtualearth.net/tiles/r%@?g=559&mkt=en-us&lbl=l1&stl=h&shading=hill&n=z",
				"({column}+{row})%4",
				"{quadKey}"],
			"address":["http://ecn.t%@.tiles.virtualearth.net/tiles/h%@?g=559&mkt=en-us&lbl=l1&stl=h&shading=hill&n=z",
				"({column}+{row})%4",
				"{quadKey}"],

			"minLevel":1,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey2":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"projectionKey3":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"projectionKey":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
			"boundingBox":[-180, -85.05112878, 180, 85.05112878],
			"mapResolution":[67108864, 67108864],
			"georeferencingType3":0,
			"coordToPixelX":"({x}+180)/360",
			"coordToPixelY":"0.5-ln((1+sin({y}*pi/180))/(1-sin({y}*pi/180)))/(4*pi)",
			"pixelToCoordX":"360*{x}-180",
			"pixelToCoordY":"90 - 360 * atan(exp(-(0.5-{y}) * 2 * pi)) / pi",
			"infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
				"-{selectedcoord.x}", 
				"-{selectedcoord.y}"],
			"infoType":"web"
		}
		,
		{
			"title":"Katastr ČÚZK",
			"typeOfService":"TMS",
			"address":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=hranice_parcel&TRANSPARENT=TRUE", 
				"{tileLU.x}", 
				"{tileRB.y}", 
				"{tileRB.x}", 
				"{tileLU.y}"],
			"minLevel":1,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey2":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"projectionKey":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
			
			"projectionKey3":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"boundingBox":[-180, -85.05112878, 180, 85.05112878],
			"mapResolution":[67108864, 67108864],
			"georeferencingType":0,
			"coordToPixelX":"({x}+180)/360",
			"coordToPixelY":"0.5-ln((1+sin({y}*pi/180))/(1-sin({y}*pi/180)))/(4*pi)",
			"pixelToCoordX":"360*{x}-180",
			"pixelToCoordY":"90 - 360 * atan(exp(-(0.5-{y}) * 2 * pi)) / pi",
			"infoSRS":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"infoAddress":["http://maps.google.com/maps/api/geocode/json?latlng=%@,%@&sensor=false", 
				"{selectedcoord.y}", 
				"{selectedcoord.x}"],
			"infoType":"text"
		}
		]
	},

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
			"title":"OSM + GetFeatureInfo",
			"typeOfService":"TMS",
			"address":["http://tile.openstreetmap.org/%@/%@/%@.png", 
				"{zoom}", 
				"{column}", 
				"{row}"],
			"minLevel":1,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"alpha":1.0,
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"mapResolution":[67108864, 67108864],
			
			"georeferencingType":2,	
			"boundingBox":[-20037508.342789244, -20037508.342789244, 20037508.342789244, 20037508.342789244],

			"infoSRS":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"infoAddress":["http://webmapping.mgis.psu.edu/geoserver/wms?version=1.1.1&request=getfeatureinfo&layers=topp:states&styles=population&SRS=EPSG:4326&bbox=%@,%@,%@,%@&width=%@&height=%@&format=text/html&X=%@&y=%@&query_layers=topp:states", 
				"{windowlu.x}", 
				"{windowlu.y}", 
				"{windowrb.x}", 
				"{windowrb.y}", 
				"{windowresolution.x}", 
				"{windowresolution.y}", 
				"{selectedpixelinscreen.x}", 
				"{selectedpixelinscreen.y}"],
			"infoType":"text"
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
			"title":"OSM + Geocoding info",
			"typeOfService":"TMS",
			"address":["http://tile.openstreetmap.org/%@/%@/%@.png", 
				"{zoom}", 
				"{column}", 
				"{row}"],
			"minLevel":1,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
			"mapResolution":[67108864, 67108864],

			"georeferencingType":2,	
			"boundingBox":[-20037508.342789244, -20037508.342789244, 20037508.342789244, 20037508.342789244],

			"infoSRS":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"infoAddress":["http://maps.google.com/maps/api/geocode/json?latlng=%@,%@&sensor=false", 
				"{selectedcoord.y}", 
				"{selectedcoord.x}"],
			"infoType":"text"
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
		"title":"USGS Terrain Map",
		"maps":
		[
		{
			"title":"USGS Terrain",
			"address":["http://imsref.cr.usgs.gov/wmsconnector/com.esri.wms.Esrimap/USGS_EDC_Elev_GTOPO?&request=getMap&version=1.1.1&bbox=%@,%@,%@,%@&srs=EPSG:4326&layers=GTOPO60+Color+Shaded+Relief&format=image/png&height=256&width=256&bgcolor=0xFFFFFF&transparent=true&exception=application/vnd.ogc.se_xml&styles=", 
				"{tileLB.x}", 
				"{tileLB.y}", 
				"{tileRU.x}", 
				"{tileRU.y}"],	
			"minLevel":2,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution":[67108864, 33554432],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [67108864, 0.0], [0.0, 33554432], [67108864, 33554432] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		,
		{
			"title":"USGS Ortophoto",
			"address":["http://ims.cr.usgs.gov/wmsconnector/com.esri.wms.Esrimap/USGS_EDC_Ortho_Landsat7?&request=getMap&version=1.1.1&bbox=%@,%@,%@,%@&&srs=EPSG:4326&layers=LANDSAT7&format=image/png&height=256&width=256&bgcolor=0xFFFFFF&transparent=true&exception=application/vnd.ogc.se_xml", 
				"{tileLB.x}", 
				"{tileLB.y}", 
				"{tileRU.x}", 
				"{tileRU.y}"],	
			"minLevel":2,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution":[67108864, 33554432],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [67108864, 0.0], [0.0, 33554432], [67108864, 33554432] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		,
		{
			"title":"USGS Border",
			"address":["http://usgs-catalog4.srv.mst.edu/cgi-bin/basevector?&request=getMap&version=1.1.1&bbox=%@,%@,%@,%@&srs=EPSG:4326&layers=worldregions,stateprovince&format=image/png&height=256&width=256&bgcolor=0xFFFFFF&transparent=true&exception=application/vnd.ogc.se_xml&styles=", 
				"{tileLB.x}", 
				"{tileLB.y}", 
				"{tileRU.x}", 
				"{tileRU.y}"],	
			"minLevel":2,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution":[67108864, 33554432],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [67108864, 0.0], [0.0, 33554432], [67108864, 33554432] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		,
		{
			"title":"USGS Transit",
			"address":["http://ms1.er.usgs.gov/cgi-bin/mapserv?map=/mapserv/data/NTAD_trans.map&request=getMap&version=1.1.1&bbox=%@,%@,%@,%@&srs=EPSG:4326&layers=NTAD_roads&format=image/png&height=256&width=256&bgcolor=0xFFFFFF&transparent=true&exception=application/vnd.ogc.se_xml", 
				"{tileLB.x}", 
				"{tileLB.y}", 
				"{tileRU.x}", 
				"{tileRU.y}"],	
			"minLevel":2,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution":[67108864, 33554432],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [67108864, 0.0], [0.0, 33554432], [67108864, 33554432] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		]
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
		"title":"Zlín - sítě + automapa",
		"ss":"http://geoportal.cenia.cz/wmsconnector/com.esri.wms.Esrimap/cenia_b_auto_sde?SRS=EPSG:102067&LAYERS=0&TRANSPARENT=true&FORMAT=image/png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application/vnd.ogc.se_inimage&BBOX=-529673.4274374607,-1169341.0269891787,-514098.2969591423,-1160697.9761008709&WIDTH=883&HEIGHT=490",
		"maps":
		[
		{
			"title":"Zlín - automapa",
			"typeOfService":"Coordinates",
			"address":["http://geoportal.cenia.cz/wmsconnector/com.esri.wms.Esrimap/cenia_b_auto_sde?SRS=EPSG:102067&LAYERS=0&TRANSPARENT=true&FORMAT=image/png&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application/vnd.ogc.se_inimage&BBOX=%@,%@,%@,%@&WIDTH=256&HEIGHT=256", 
				"-{tileLB.x}", 
				"-{tileLB.y}", 
				"-{tileRU.x}", 
				"-{tileRU.y}"],	
			"minLevel":0,
			"maxLevel":19,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"boundingBox":[529673.4274374607,1169341.0269891787,514098.2969591423,1160697.9761008709],
			"mapResolution":[88300000, 49000000],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [88300000, 0.0], [0.0, 49000000], [88300000, 49000000] ],
			"coordinatePoints":[ [529673.4274374607, 1160697.9761008709], [514098.2969591423, 1160697.9761008709], [529673.4274374607, 1169341.0269891787], [514098.2969591423, 1169341.0269891787] ]
		}
		,
		{
			"title":"Zlín - Technické sítě",
			"typeOfService":"Coordinates",
			"address":["http://194.228.224.66/jdtm-zk/html/cgi-bin/gsa10.cgi?map=c:/inetpub/194_228_224_66/Jdtm-zk/html/map//ms-new.map&layer=ISITE&layer=KATASTR&layer=PLH&layer=ULICE&layer=CP&format=image%%2Fpng&login=psumbera&pass=sumbera16128&gsasker=2&mode=map&map_imagetype=png&mapext=%@+%@+%@+%@&imgext=%@+%@+%@+%@&map_size=256+256&imgx=128&imgy=128&imgxy=256+256", 
				"-{tileLB.x}", 
				"-{tileLB.y}", 
				"-{tileRU.x}", 
				"-{tileRU.y}", 
				"-{tileLB.x}", 
				"-{tileLB.y}", 
				"-{tileRU.x}", 
				"-{tileRU.y}"],	
			"minLevel":1,
			"maxLevel":19,
			"deltaLevel":1,
			"alpha":0.7,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"boundingBox":[529673.4274374607,1169341.0269891787,514098.2969591423,1160697.9761008709],
			"mapResolution":[88300000, 49000000],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [88300000, 0.0], [0.0, 49000000], [88300000, 49000000] ],
			"coordinatePoints":[ [529673.4274374607, 1160697.9761008709], [514098.2969591423, 1160697.9761008709], [529673.4274374607, 1169341.0269891787], [514098.2969591423, 1169341.0269891787] ]
		}
		]
	
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
			"title":"ŠLP-DMT",
			"typeOfService":"Coordinates",
			"address":["http://mapserver-slp.mendelu.cz/cgi-bin/mapserv?map=/var/local/slp/krtinyWMS.map&SRS=EPSG:102067&LAYERS=dmt&TRANSPARENT=true&FORMAT=image%%2Fpng&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%%2Fvnd.ogc.se_inimage&BBOX=%@,%@,%@,%@&WIDTH=256&HEIGHT=256", 
				"-{tileLB.x}", 
				"-{tileLB.y}", 
				"-{tileRU.x}", 
				"-{tileRU.y}"],	
			"minLevel":0,
			"maxLevel":7,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
			"boundingBox":[614279.2676280853, 1160482.9070792294, 571028.7354278171, 1137940.4192521728],
			"boundingBox2":[571028.7354278171, 1137940.4192521728, 614279.2676280853, 1160482.9070792294],
			"mapResolution":[12260, 6390],
			"georeferencingType":2,					
			"pixelPoints":[ [0.0, 0.0], [12260, 0.0], [0.0, 6390], [12260, 6390] ],
			"coordinatePoints":[ [614279.2676280853, 1137940.4192521728], [571028.7354278171, 1137940.4192521728], [614279.2676280853, 1160482.9070792294], [571028.7354278171, 1160482.9070792294] ]
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
			"title":"NightEarth - Zoomify",
			"typeOfService":"TMS",
			"address":["http://mapserver.mendelu.cz/sites/default/files/data/USERS/kaminek/NightEarth/NightEarth/TileGroup%@/%@-%@-%@.jpg", 
				   "{zoomifyIndex}",
				   "{zoom}", 
				   "{column}", 
				   "{row}"],	
			"minLevel":0,
			"maxLevel":6,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution":[16384, 8192],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [16384, 0.0], [0.0, 8192], [16384, 8192] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
			"title":"Markrabství Moravské - Zoomify",
			"typeOfService":"TMS",
			"address":["http://mapy.vkol.cz/mapy/iii86014/TileGroup%@/%@-%@-%@.jpg", 
				   "{zoomifyIndex}",
				   "{zoom}", 
				   "{column}", 
				   "{row}"],	
			"minLevel":0,
			"maxLevel":6,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution":[12650, 9761],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [12650, 0.0], [0.0, 9761], [12650, 9761] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
			"title":"Paris, ortofoto - Zoomify",
			"typeOfService":"TMS",
			"address":["http://www.zoomify.com/images/folders/parisSatellite/TileGroup%@/%@-%@-%@.jpg", 
				   "{zoomifyIndex}",
				   "{zoom}", 
				   "{column}", 
				   "{row}"],	
			"minLevel":0,
			"maxLevel":6,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution":[9665, 9335],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [12650, 0.0], [0.0, 9761], [12650, 9761] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
		"title":"WMS - Metakarta World",
		"maps":
		[
		{
			"title":"WMS - Metacarta",
			"typeOfService":"WMS",
			"address":["http://labs.metacarta.com/wms/vmap0?service=wms"],	
			"layers":"basic",
			"minLevel":0,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution2":[67108864, 33554432],
			"mapResolution":[134217728, 67108864],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [134217728, 0.0], [0.0, 67108864], [134217728, 67108864] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		]
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	{
		"title":"WMS - Metakarta + SK + ŠLP",
		"maps":
		[
		{
			"title":"WMS - Metacarta",
			"typeOfService":"WMS",
			"address":["http://labs.metacarta.com/wms/vmap0?service=wms"],	
			"layers":"basic",
			"minLevel":0,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution":[134217728, 67108864],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [134217728, 0.0], [0.0, 67108864], [134217728, 67108864] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		,
		{
			"title":"WMS - SK",
			"typeOfService":"WMS",
			"address":["http://atlas.sazp.sk/wmsconnector/com.esri.wms.Esrimap?ServiceName=corine_v3sk&"],
			"layers":"9",
			"minLevel":0,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution2":[67108864, 33554432],
			"mapResolution":[134217728, 67108864],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [134217728, 0.0], [0.0, 67108864], [134217728, 67108864] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		,		
		{
			"title":"WMS - SK - 6",
			"typeOfService":"WMS",
			"address":["http://atlas.sazp.sk/wmsconnector/com.esri.wms.Esrimap?ServiceName=corine_v3sk&"],	
			"layers":"6",
			"minLevel":0,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution2":[67108864, 33554432],
			"mapResolution":[134217728, 67108864],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [134217728, 0.0], [0.0, 67108864], [134217728, 67108864] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		,	
		{
			"title":"WMS - SK - 5",
			"typeOfService":"WMS",
			"address":["http://atlas.sazp.sk/wmsconnector/com.esri.wms.Esrimap?ServiceName=corine_v3sk&"],	
			"layers":"5",
			"minLevel":0,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution2":[67108864, 33554432],
			"mapResolution":[134217728, 67108864],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [134217728, 0.0], [0.0, 67108864], [134217728, 67108864] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		,
		{
			"title":"WMS - SK - 3",
			"typeOfService":"WMS",
			"address":["http://atlas.sazp.sk/wmsconnector/com.esri.wms.Esrimap?ServiceName=corine_v3sk&"],	
			"layers":"3",
			"minLevel":0,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution2":[67108864, 33554432],
			"mapResolution":[134217728, 67108864],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [134217728, 0.0], [0.0, 67108864], [134217728, 67108864] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}		
		,
		{
			"title":"WMS - ŠLP",
			"typeOfService":"WMS",
			"address":["http://mapserver-slp.mendelu.cz/cgi-bin/mapserv?map=/var/local/slp/krtinyWMS.map&"],	
			"layers":"dmt",
			"minLevel":0,
			"maxLevel":18,
			"deltaLevel":1,
			"tileResolution":[256, 256],
			"projectionKey":"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
			"boundingBox":[-180, -90, 180, 90],
			"mapResolution2":[67108864, 33554432],
			"mapResolution":[134217728, 67108864],
			"georeferencingType":1,					
			"pixelPoints":[ [0.0, 0.0], [134217728, 0.0], [0.0, 67108864], [134217728, 67108864] ],
			"coordinatePoints":[ [-180.0, 90.0], [180.0, 90.0], [-180, -90], [180, -90] ]
		}
		]
	}	
	
		
]