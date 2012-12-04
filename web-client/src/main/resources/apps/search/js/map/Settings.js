OpenLayers.DOTS_PER_INCH = 90.71;
//OpenLayers.ImgPath = '../js/OpenLayers/theme/default/img/';
OpenLayers.ImgPath = '../js/OpenLayers/img/';

OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;

// Define a constant with the base url to the MapFish web service.
//mapfish.SERVER_BASE_URL = '../../../../../'; // '../../';

// Remove pink background when a tile fails to load
OpenLayers.Util.onImageLoadErrorColor = "transparent";

// Lang
OpenLayers.Lang.setCode(GeoNetwork.defaultLocale);

OpenLayers.Util.onImageLoadError = function () {
	this._attempts = (this._attempts) ? (this._attempts + 1) : 1;
	if (this._attempts <= OpenLayers.IMAGE_RELOAD_ATTEMPTS) {
		this.src = this.src;
	} else {
		this.style.backgroundColor = OpenLayers.Util.onImageLoadErrorColor;
		this.style.display = "none";
	}
};

// add Proj4js.defs here
// Proj4js.defs["EPSG:27572"] = "+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs";
Proj4js.defs["EPSG:2154"] = "+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs";
//new OpenLayers.Projection("EPSG:900913")


GeoNetwork.map.printCapabilities = "../../pdf";

// Config for WGS84 based maps
//GeoNetwork.map.PROJECTION = "EPSG:4326";
////GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-180,-90,180,90);
//GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-5.1,41,9.7,51);


// France Extent in Lambert Zone II 
// GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-22841,1712212,1087335,2703971);
// Guadeloupe Extent 
// GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-61.923110556507261,15.638450453434646,-60.89882855155793,16.733329887987498);
// Guyane Extent 
// GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-55.021871380568264,2.010650405791685,-51.290955696038872,6.000970747951597);
// Martinique Extent 
// GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-61.292310412948595,14.34656891402657,-60.749391841477684,14.926907507956782);
// Reunion Extent 
// GeoNetwork.map.EXTENT = new OpenLayers.Bounds(55.191558854627800,-21.483429620283132,55.873778462321622,-20.753776363928615);

//
//GeoNetwork.map.BACKGROUND_LAYERS = [
//    new OpenLayers.Layer.WMS("Background layer", "/geoserver/wms", {layers: 'gn:world,gn:gboundaries', format: 'image/jpeg'}, {isBaseLayer: true})
//    ];

// Config for OSM based maps
GeoNetwork.map.PROJECTION = "EPSG:900913";
//GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-20037508, -32487565, 20037508, 25479824);
GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-550000, 5000000, 1200000, 7000000);
GeoNetwork.map.BACKGROUND_LAYERS = [
    new OpenLayers.Layer.OSM()
    //new OpenLayers.Layer.Google("Google Streets");
    ];
//GeoNetwork.map.RESOLUTIONS = [];

GeoNetwork.map.MAP_OPTIONS = {
    projection: GeoNetwork.map.PROJECTION,
    maxExtent: GeoNetwork.map.EXTENT,
    restrictedExtent: GeoNetwork.map.EXTENT,
    resolutions: GeoNetwork.map.RESOLUTIONS,
    controls: []
};
GeoNetwork.map.MAIN_MAP_OPTIONS = {
    projection: GeoNetwork.map.PROJECTION,
    maxExtent: GeoNetwork.map.EXTENT,
    restrictedExtent: GeoNetwork.map.EXTENT,
    resolutions: GeoNetwork.map.RESOLUTIONS,
    controls: []
};