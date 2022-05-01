<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaiden listaus</title>
</head>
<body>
	<table id="listaus">
		<thead>	
			<tr>
				<th colspan="2" class="oikealle">Hakusana:</th>
				<th><input type="text" id="hakusana"></th>
				<th><input type="button" id="hae" value="Hae"></th>
				<th colspan="5" class="oikealle"><span id="takaisin">Lisää uusi asiakas</span></th>
			</tr>		
			
			
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>	
				<th></th>			
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
<script>

$(document).ready(function(){	
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ //Enteriä painettu, ajetaan haku
			  haeTiedot();
		  }
		  
		  
	$("#uusiAsiakas").click(function(){
		document.location="lisaaasiakas.jsp";
	});
	
	});	
	$("#hae").click(function(){	
		haeTiedot();
	});
	$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
	haeTiedot();
	
	$("#takaisin").click(function(){
		document.location="lisaaasiakas.jsp";
	});
});
function haeTiedot(){	
	$("#listaus tbody").empty();
	//$.getJSON on $.ajax:n alifunktio, joka on erikoistunut jsonin hakemiseen. Kumpaakin voi tässä käyttää.
	//$.getJSON({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", success:function(result){
	$.ajax({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){
		$.each(result.asiakkaat, function(i, field){  
        	var htmlStr;
        	htmlStr+="<tr id='rivi_"+field.sposti+"'>";
        	htmlStr+="<td>"+field.etunimi+"</td>";
        	htmlStr+="<td>"+field.sukunimi+"</td>";
        	htmlStr+="<td>"+field.puhelin+"</td>";
        	htmlStr+="<td>"+field.sposti+"</td>";     
        	htmlStr+="<td><span class='poista' onclick=poista('"+field.sposti+"')>Poista</span></td>";
        	htmlStr+="</tr>";
        	$("#listaus tbody").append(htmlStr);
        });
    }});	
}
function poista(sposti){
	if(confirm("Poista asiakas " + sposti +"?")){
		$.ajax({url:"asiakkaat/"+sposti, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
	        if(result.response==0){
	        	$("#ilmo").html("Asiakkaan poisto epäonnistui.");
	        }else if(result.response==1){
	        	$("#rivi_"+sposti).css("background-color", "red"); //V�rj�t��n poistetun asiakkaan rivi
	        	alert("Asiakkaan " + sposti +" poisto onnistui.");
				haeTiedot();        	
			}
	    }});
	}
}
</script>
</body>
</html>