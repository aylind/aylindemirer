﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="form1.aspx.vb" Inherits="form1" %>

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
		  background-color: #CCC;
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

<!--Main chunk of javascript that creates and controls the map.-->
<script type="text/javascript">

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
        //The type of map. In addition to ROADMAP, the other 'premade' map styles are SATELLITE, TERRAIN and HYBRID. 
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        maxZoom: festivalMapZoomMax,
        minZoom: festivalMapZoomMin,
        //Turn off the map controls as we will be adding our own later.
        panControl: false,
        mapTypeControl: false,
    };

    //Create the variable for the main map itself.
    var festivalMap;

    //When the page loads, the line below calls the function below called 'loadFestivalMap' to load up the map.
    google.maps.event.addDomListener(window, 'load', loadFestivalMap);



    //THE MAIN FUNCTION THAT IS CALLED WHEN THE WEB PAGE LOADS--------------------------------------------------------------------------------
    function loadFestivalMap() {

        //The empty map variable ('festivalMap') was created above. The line below creates the map, assigning it to this variable. The line below also loads the map into the div with the id 'festival-map' (see code within the 'body' tags below), and applies the 'festivalMapOptions' (above) to configure this map. 
        festivalMap = new google.maps.Map(document.getElementById("festival-map"), festivalMapOptions);


        //Calls the function below to load up all the map markers.
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

    }




</script>

</head>
<body>  
     <!--Create the div to hold the map.-->
    <div id="festival-map"></div>   
</body>
</html>
