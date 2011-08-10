// JavaScript Document
function download_content(show, nadpis, prvek) {

  function GetXmlHttpObject()
  { 
	 var objXMLHttp=null;
    if (window.XMLHttpRequest) { // Mozilla, Safari,...
      objXMLHttp = new XMLHttpRequest();
    } else if (window.ActiveXObject) { // IE
      try {
        objXMLHttp = new ActiveXObject('Msxml2.XMLHTTP');
      } catch (e) {
        try {
          objXMLHttp = new ActiveXObject('Microsoft.XMLHTTP');
        } catch (e) {}
      }
    }
	 return objXMLHttp
  }

  function use_contents() {
    if (xmlHttp.readyState == 4) {
      if (xmlHttp.status == 200) {
        document.getElementById(prvek).innerHTML = xmlHttp.responseText; 
      } else {
        alert('Error downloading content. Please try again...');
        return false;
      }
    }
  }


  document.getElementById(prvek).title = nadpis; 
  document.getElementById(prvek).innerHTML = "<img src='iphone/loading.gif' alt='loading'> vydrž chvilku, stahují se data..."; 
	xmlHttp=GetXmlHttpObject();
	if (xmlHttp==null){
    alert ('Browser does not support HTTP Request');
		return;
  } 
  vysledek=xmlHttp.onreadystatechange = use_contents;
  var url='iphone/getdata.php';
	xmlHttp.open('POST', url, true);
	xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
  xmlHttp.send('show='+show);
}

  var semafor = false;
  var animace = new Array;
  var aktual = 0;

  function nextImage(){
    document.getElementById('radarimg').src = 'http://portal.chmi.cz/files/portal/docs/meteo/rad/data_tr_png_1km/'+animace[aktual];
    document.getElementById('select').value = animace[aktual];
    aktual ++;
    if(semafor){
      document.getElementById('bargraf').style.width= 150/animace.length*aktual;
    }else{
      document.getElementById('bargraf').style.width='0'; 
    }
    if(aktual == animace.length){
      aktual = 0;
    }                 
    if(semafor){
      setTimeout('nextImage()', 1000);
    }
  }
