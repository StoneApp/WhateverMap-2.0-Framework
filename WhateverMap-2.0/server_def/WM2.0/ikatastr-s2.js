[	
	{
		"title":"iKatastr Seznam + EPSG:32633",
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
			"title":"Katastr - mapy",
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
	}	
]