<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://fonts.googleapis.com/css?family=Varela+Round&display=swap" rel="stylesheet">
<head>

<script>
window.onload = function() {
	if (!("Notification" in window)) {
	    alert("This browser does not support system notifications");
	    // This is not how you would really do things if they aren't supported. :)
	}
	// Otherwise, we need to ask the user for permission
	else if (Notification.permission !== 'denied') {
	  Notification.requestPermission(function (permission) {
	    // If the user accepts, let's create a notification
	  });
	}

	if(sessionStorage.getItem("log")!=null){
		document.getElementById("login").innerHTML = "Logout"
		document.getElementById("login").onclick = 	function signout(){
			sessionStorage.removeItem("log");
			sessionStorage.removeItem('username');
			document.getElementById("welcome").innerHTML = "WELCOME!";
			document.getElementById("profile").style.display = "none";
			document.getElementById("login").innerHTML = "Login"
			document.getElementById("login").href = "login.jsp";
			document.getElementById("signup").innerHTML = "Sign Up"
			document.getElementById("signup").href= "register.jsp";
		}
		document.getElementById("profile").style.display = "block";
		//setInterval(checkRequest, 1000);
	//do something to change based on login
	}else {
		document.getElementById("profile").style.display = "none";
		document.getElementById("login").innerHTML = "Login";
		document.getElementById("login").href = "login.jsp";
		document.getElementById("signup").innerHTML = "Sign Up"
		document.getElementById("signup").href= "register.jsp";
	}
}
function deletesession(){
	sessionStorage.clear();
	
}
function checkRequest() {
	var xhttp = new XMLHttpRequest();
	xhttp.open("GET", "CheckRequest?src=/Home.jsp" +
			"&un=" + sessionStorage.getItem("log"), true);
	xhttp.send();
	xhttp.onreadystatechange = function() {
		if(xhttp.responseText.trim().length > 0){
			let requests = xhttp.responseText.split(",");
			for(let i=0; i<requests.length; ++i) {
				var notification = new Notification("Friend Request!", {body: requests[i] + " has sent you a friend request!"});
			}
		}
	};
	return false;
}
</script>
<style>
body {
background-image : linear-gradient(#AEECEF, #6D9DC5);
/* background-size: cover;  */
background-repeat:repeat-y;
 
}
.breadcrumb{
background-color: white;
}
.container img{
width:620px;
}
.container{
height: 10em;
  display: flex;
  
  align-items: center;
  justify-content: center; 
}
#inlineFormCustomSelectPref{
margin-top:0;
}
#title-id{
width:40%;
}
.form-control{
margin-top: 10px;
float:left;
margin:0;
}
.navbar-bccolor{
	background-color: #2F4F4F;
}
</style>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>Find My Bills</title>
</head>
<body>
<%
String message = (String) session.getAttribute ("username");
if(message == null || message == ""){
	message = "";
}
%>
<nav class="navbar navbar-expand-md navbar-dark navbar-bccolor">
  <a class="navbar-brand" href="Home.jsp">Find My Bills |</a>
 <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarnav" aria-controls="navbarnav" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
     <div class="collapse navbar-collapse" id="navbarnav">
	    	<ul class="navbar-nav mr-auto">
	      		<li class="nav-item" >
		      		<a class = "nav-link" id="about" href="Aboutus.jsp">About Us</a>
	      		</li>
	      		<li class="nav-item">
		      		<a class = "nav-link" id="profile" href="Profile.jsp">Profile</a>
	      		</li>
	      		<li class="nav-item">
		      		<a class = "nav-link" id="login"></a>
	      		</li>
	      		<li class="nav-item">
		      		<a class = "nav-link" id="signup"></a>
	      		</li>
	    	</ul>
	 </div>
	 
	 <h2 id = "welcome" style= "color: white;"></h2>
</nav>

<div id = "weather" style="font-size: 17px; color: 	#5F5980; text-align: center;padding-top:20px;">
		Today's weather in Los Angeles: <span id="realtemp"></span>° <span id="description"></span>. Feels like <span id = "feelslike"></span>°
</div>

<div class="container">
		<div class="row">
			<h1 class="col-12 mt-4"> <img src ="image/House.jpg"/></h1>
		</div> 
</div>
<br>
<br>
<br>
<div class="d-flex justify-content-center">
<form name="myform" method="POST" action="Servlet" onsubmit= "return selectCheck()">
<input type="text" style = "width:600px; font-size:40px; height:50px;" class="form-control" id="search" name="search" placeholder = "Search Bills">
<select name="select" id="select" style= "width: 150px;height: 50px;" onmouseout="return placeholder()" >
    <option value="selectnon">--SELECT--</option>
    <option value="bills">Bill</option>
    <option value="users">User</option>
    
  </select>
<input type = "submit" style = "height:50px;"value = "Search" class="btn btn-primary">

</form>
</div>

<div class="container" id = "news" style="padding-top:5%;font-size: 28px; color: #1F2232; text-align: center;">
		<span>Today's breaking news: <span id="topnews"></span></span>
</div>
<script>
//Using AJAX with jQuery
$.ajax({
	method: "GET",
	url: "https://api.weatherbit.io/v2.0/current?city=Los+Angeles,CA",
	data:{
		key: "6342b64454ef425e8481fc45afafdee8",
		units: "I"
	}
})
.done(function(results){

	console.log(results);
	$("#realtemp").text(results.data[0].temp);
	$("#feelslike").text(results.data[0].app_temp);
	$("#description").text(results.data[0].weather.description);


})
.fail(function() {
				console.log("ERROR");
	})

$.ajax({
	method: "GET",
	url: 'https://newsapi.org/v2/top-headlines?' +
	'country=us&' +
	'apiKey=110d1f37d7e44a67adc114faf33b8bfc', 
	success: function(result) {
		document.getElementById("topnews").innerHTML = result.articles[0].title;
	}
})



	
function placeholder() {
   if(document.myform.select.value == "bills"){
	   document.getElementById("search").setAttribute("placeholder", "Search Bills with keywords");
   }
   if(document.myform.select.value == "users"){
	   document.getElementById("search").setAttribute("placeholder", "Search Users with First Name or Last Name");
   }
 
}
function selectCheck(){
	if(document.myform.select.value == "selectnon"){
		alert("Please select option for search!.");
		return false;
	}
}
if(sessionStorage.getItem("log")== null){
	sessionStorage.setItem("log")=="";
}
document.getElementById("welcome").innerHTML = "Welcome! " + sessionStorage.getItem("log");
</script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

<div class = "col-sm-12 footer">
	<p class = "footer">© 2019 Find My Bills, Inc. By 201 Trojans<br><br></p>
</div>

</body>
</html>
