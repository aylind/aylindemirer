﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="changing_the_colour_and_detail_on_your_map.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html>

<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<title>UK Festivals</title>

<!--Set up the CSS styles-->
<style type="text/css">
      html { 
	      height: 100%;
	  }
      
	  body {
		  height: 100%; 
		  margin: 0; 
		  padding: 0;
		  background-image: url('background9.jpg');
		  background-color: #B3CDE6;
		  background-repeat: no-repeat;
		  background-attachment: fixed;
		  background-position: right bottom; 
	      background-size: cover;
	  }
      
	  /*Adapt the following styling depending on where you want to put your map. If you want a 'full screen' map, then set the width and height to 100 percent and remove the margins.*/
	  #festival-map { 
	  	  height: 100%;
		  width: 65%; 
		  margin-left: auto;
          margin-right: auto;
		  border-right-width: 2px;
		  border-right-color: #ffffff;
		  border-right-style: solid;
		  border-left-width: 2px;
		  border-left-color: #ffffff;
		  border-left-style: solid;
	  }
	  
	  .pop_up_box_text {
	 	  font-family: Georgia, 'Times New Roman', Times, serif; 
		  font-size: 16px; 
		  line-height: 22px; 
		  color: #ffffff; 
		  display: inline; 
	  }

</style>



<!--Connect to the google maps api using your api key-->
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?&sensor=false"></script>

<!--Connect to the infobox javascript library. This is used later to create the pop-up windows -->
<script src="infobox/infobox.js" type="text/javascript"></script>

<!--Main chunk of javascript that creates and controls the map.-->
<script type="text/javascript">

    //Set up the custom styles for the map. I've created two styles so the map can switch between them depending on the zoom level. i.e. there is far less detail when the map is zoomed out.
    //First, we read in the data describing style.
    var style_festival = [
      {
          "featureType": "administrative",
          "stylers": [
            { "visibility": "off" }
          ]
      }, {
          "featureType": "poi",
          "stylers": [
            { "visibility": "off" }
          ]
      }, {
          "featureType": "transit",
          "stylers": [
            { "visibility": "off" }
          ]
      }, {
          "featureType": "road",
          "stylers": [
            { "visibility": "off" }
          ]
      }, {
          "featureType": "landscape",
          "stylers": [
            { "color": "#FFE200" }
          ]
      }, {
          "featureType": "water",
          "stylers": [
            { "visibility": "on" },
            { "color": "#4f92c6" }
          ]
      }
    ];

    var style_festival_zoomed = [
      {
          "featureType": "administrative",
          "stylers": [
            { "visibility": "on" }
          ]
      }, {
          "featureType": "poi",
          "stylers": [
            { "visibility": "on" }
          ]
      }, {
          "featureType": "transit",
          "stylers": [
            { "visibility": "on" }
          ]
      }, {
          "featureType": "road",
          "stylers": [
            { "visibility": "on" }
          ]
      }, {
          "featureType": "landscape",
          "stylers": [
            { "color": "#FFE200" }
          ]
      }, {
          "featureType": "water",
          "stylers": [
            { "visibility": "on" },
            { "color": "#4f92c6" }
          ]
      }, {
          "featureType": "poi.park",
          "elementType": "geometry",
          "stylers": [
            { "color": "#FFFF00" }
          ]
      }
    ];

    //Then we use this data to create the styles. 
    var styled_festival = new google.maps.StyledMapType(style_festival, { name: "Festival style" });
    var styled_festival_zoomed = new google.maps.StyledMapType(style_festival_zoomed, { name: "Festival style zoomed" });

    //Create the variables that will be used within the map configuration options.
    //The latitude and longitude of the center of the map.
    var festivalMapCenter = new google.maps.LatLng(54.722439, -0.252686);
    //The degree to which the map is zoomed in. This can range from 0 (least zoomed) to 21 and above (most zoomed).
    var festivalMapZoom = 6;
    //The max and min zoom levels that are allowed.
    var festivalMapZoomMax = 12;
    var festivalMapZoomMin = 6;

    //These options configure the setup of the map. 
    var festivalMapOptions = {
        center: festivalMapCenter,
        zoom: festivalMapZoom,
        maxZoom: festivalMapZoomMax,
        minZoom: festivalMapZoomMin,
        //Turn off the map controls as we will be adding our own later.
        panControl: false,
        mapTypeControl: false,
        mapTypeControlOptions: {
            mapTypeIds: ['map_styles_festival', 'map_styles_festival_zoomed']
        }
    };

    //Create the variable for the main map itself.
    var festivalMap;

    //When the page loads, the line below calls the function below called 'loadFestivalMap' to load up the map.
    google.maps.event.addDomListener(window, 'load', loadFestivalMap);



    //THE MAIN FUNCTION THAT IS CALLED WHEN THE WEB PAGE LOADS--------------------------------------------------------------------------------
    function loadFestivalMap() {

        //The empty map variable ('festivalMap') was created above. The line below creates the map, assigning it to this variable. The line below also loads the map into the div with the id 'festival-map' (see code within the 'body' tags below), and applies the 'festivalMapOptions' (above) to configure this map. 
        festivalMap = new google.maps.Map(document.getElementById("festival-map"), festivalMapOptions);

        //Assigning the two map styles defined above to the map.
        festivalMap.mapTypes.set('map_styles_festival', styled_festival);
        festivalMap.mapTypes.set('map_styles_festival_zoomed', styled_festival_zoomed);
        //Setting the one of the styles to display as default as the map loads.
        festivalMap.setMapTypeId('map_styles_festival');

        //Calls the function below to load up all the map markers and pop-up boxes.
        loadMapMarkers();

    }



    //Function that loads the map markers.
    function loadMapMarkers() {

        //GLASTONBURY -----------------

        //Setting the position of the Glastonbury map marker.
        var markerPositionGlastonbury = new google.maps.LatLng(51.159803, -2.585585);

        //Setting the icon to be used with the Glastonbury map marker.
        var markerIconGlastonbury = {
            url: 'icons/icon_glas_uk.png',
            //The size image file.
            size: new google.maps.Size(225, 120),
            //The point on the image to measure the anchor from. 0, 0 is the top left.
            origin: new google.maps.Point(0, 0),
            //The x y coordinates of the anchor point on the marker. e.g. If your map marker was a drawing pin then the anchor would be the tip of the pin.
            anchor: new google.maps.Point(189, 116)
        };

        //Setting the shape to be used with the Glastonbury map marker.
        var markerShapeGlastonbury = {
            coord: [12, 4, 216, 22, 212, 74, 157, 70, 184, 111, 125, 67, 6, 56],
            type: 'poly'
        };

        //Creating the Glastonbury map marker.
        markerGlastonbury = new google.maps.Marker({
            //uses the position set above.
            position: markerPositionGlastonbury,
            //adds the marker to the map.
            map: festivalMap,
            title: 'Glastonbury Festival',
            //assigns the icon image set above to the marker.
            icon: markerIconGlastonbury,
            //assigns the icon shape set above to the marker.
            shape: markerShapeGlastonbury,
            //sets the z-index of the map marker.
            zIndex: 102
        });


        //ISLE OF WIGHT-----------

        var markerPositionIsleOfWight = new google.maps.LatLng(50.708571, -1.285615);

        var markerIconIsleOfWight = {
            url: 'icons/icon_iow.png',
            size: new google.maps.Size(198, 108),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(103, 102)
        };

        var markerShapeIsleOfWight = {
            coord: [6, 30, 180, 4, 192, 70, 103, 82, 105, 105, 82, 85, 15, 93],
            type: 'poly'
        };

        markerIsleOfWight = new google.maps.Marker({
            position: markerPositionIsleOfWight,
            map: festivalMap,
            title: 'Isle of Wight Festival',
            icon: markerIconIsleOfWight,
            shape: markerShapeIsleOfWight,
            zIndex: 108
        });


        //LEEDS ------------

        var markerPositionLeeds = new google.maps.LatLng(53.868083, -1.381359);

        var markerIconLeeds = {
            url: 'icons/icon_leeds.png',
            size: new google.maps.Size(216, 151),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(192, 148)
        };

        var markerShapeLeeds = {
            coord: [18, 8, 208, 28, 200, 113, 162, 110, 190, 145, 128, 109, 6, 93],
            type: 'poly'
        };

        markerLeeds = new google.maps.Marker({
            position: markerPositionLeeds,
            map: festivalMap,
            title: 'Leeds Festival',
            icon: markerIconLeeds,
            shape: markerShapeLeeds,
            zIndex: 103
        });


        //READING -------------
        var markerPositionReading = new google.maps.LatLng(51.465602, -0.987096);

        var markerIconReading = {
            url: 'icons/icon_reading.png',
            size: new google.maps.Size(196, 114),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(46, 109)
        };

        var markerShapeReading = {
            coord: [8, 54, 177, 7, 189, 49, 65, 88, 44, 110, 47, 91, 20, 98],
            type: 'poly'
        };

        markerReading = new google.maps.Marker({
            position: markerPositionReading,
            map: festivalMap,
            title: 'Reading Festival',
            icon: markerIconReading,
            shape: markerShapeReading,
            zIndex: 106
        });


        //LATITUDE -------------
        var markerPositionLatitude = new google.maps.LatLng(52.337013, 1.595228);

        var markerIconLatitude = {
            url: 'icons/icon_lat.png',
            size: new google.maps.Size(192, 128),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(82, 125)
        };

        var markerShapeLatitude = {
            coord: [8, 8, 184, 10, 182, 70, 111, 70, 82, 122, 87, 71, 9, 71],
            type: 'poly'
        };

        markerLatitude = new google.maps.Marker({
            position: markerPositionLatitude,
            map: festivalMap,
            title: 'Latitude Festival',
            icon: markerIconLatitude,
            shape: markerShapeLatitude,
            zIndex: 105
        });


        //SECRET GARDEN ------------
        var markerPositionGarden = new google.maps.LatLng(52.383126, -0.181189);

        var markerIconGarden = {
            url: 'icons/icon_green2.png',
            size: new google.maps.Size(139, 138),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(117, 134)
        };

        var markerShapeGarden = {
            coord: [7, 16, 128, 5, 133, 110, 107, 113, 117, 133, 82, 116, 15, 120],
            type: 'poly'
        };

        markerGarden = new google.maps.Marker({
            position: markerPositionGarden,
            map: festivalMap,
            title: 'Seceret Garden Festival',
            icon: markerIconGarden,
            shape: markerShapeGarden,
            zIndex: 104
        });


        //T IN THE PARK ------------
        var markerPositionTPark = new google.maps.LatLng(56.208772, -3.474255);

        var markerIconTPark = {
            url: 'icons/icon_tpark.png',
            size: new google.maps.Size(173, 110),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(31, 108)
        };

        var markerShapeTPark = {
            coord: [17, 6, 168, 27, 157, 105, 53, 91, 32, 105, 26, 86, 7, 83],
            type: 'poly'
        };

        markerTPark = new google.maps.Marker({
            position: markerPositionTPark,
            map: festivalMap,
            title: 'T-Park Festival',
            icon: markerIconTPark,
            shape: markerShapeTPark,
            zIndex: 101
        });


        //ROCKNESS -------------
        var markerPositionRockness = new google.maps.LatLng(57.383732, -4.331617);

        var markerIconRockness = {
            url: 'icons/icon_rockness.png',
            size: new google.maps.Size(214, 82),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(182, 77)
        };

        var markerShapeRockness = {
            coord: [10, 7, 205, 7, 205, 57, 183, 57, 183, 76, 164, 58, 8, 58],
            type: 'poly'
        };

        markerRockness = new google.maps.Marker({
            position: markerPositionRockness,
            map: festivalMap,
            title: 'Rockness Festival',
            icon: markerIconRockness,
            shape: markerShapeRockness,
            zIndex: 100
        });


        //GLASGOBURY -----------
        var markerPositionGlasgowbury = new google.maps.LatLng(54.822809, -6.842251);

        var markerIconGlasgowbury = {
            url: 'icons/icon_glas_ni.png',
            size: new google.maps.Size(222, 102),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(152, 102)
        };

        var markerShapeGlasgowbury = {
            coord: [7, 47, 206, 6, 210, 55, 140, 68, 147, 98, 120, 75, 17, 94],
            type: 'poly'
        };

        markerGlasgowbury = new google.maps.Marker({
            position: markerPositionGlasgowbury,
            map: festivalMap,
            title: 'Glasgowbury Festival',
            icon: markerIconGlasgowbury,
            shape: markerShapeGlasgowbury,
            zIndex: 102
        });

    }




</script>

</head>
<body>  
     <!--Create the div to hold the map.-->
    <div id="festival-map"></div>   
</body>
</html>
