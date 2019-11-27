<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
		document.getElementById("login").onclick = function signout(){
			sessionStorage.removeItem("log");
		}
		document.getElementById("profile").style.display = "block";
		document.getElementById("welcome").innerHTML = "Welcome " + sessionStorage.getItem("log");
		document.getElementById("image").innerHTML = sessionStorage.getItem("log") + "'s Profile";
		document.getElementById("initials").innerHTML = sessionStorage.getItem("log").substring(0,2).toLocaleUpperCase();
		document.getElementById("favbill").innerHTML = "Following Bills";
		document.getElementById("friends").innerHTML = "Friends";
	 	
		//setInterval(checkRequest, 1000);
	//do something to change based on login
	}else {
		alert("Please Login!");
		window.location.replace("login.jsp");
	}
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
	
function toggle(x){
	x.classList.toggle("fa-thumbs-down");
	
}
</script>
<meta charset="UTF-8">
<title>Profile</title>
</head>
<style>
.fa {
  font-size: 50px;
  border: 2px solid;
  padding: 3px;
  cursor: pointer;
  user-select: none;
}
.fa:hover {
  color: darkblue;
}
.navbar-bccolor{
	background-color: #2F4F4F;
}
#profile{
	float:left;
}
#image{
	float:left;
}
#search{
	float:left;
}
.circle {
  width: 200px;
  height: 200px;
  border-radius: 50%;
  font-size: 80px;
  color: #fff;
  line-height: 200px;
  text-align: center;
  background: #000
}
</style>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.6.3/css/font-awesome.min.css">

<body>

<nav class="navbar navbar-expand-md navbar-dark navbar-bccolor">
  <a class="navbar-brand" href="Home.jsp">Home</a>
 <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarnav" aria-controls="navbarnav" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
     <div class="collapse navbar-collapse" id="navbarnav">
	    	<ul class="navbar-nav mr-auto">
	    	
	      		<li class="nav-item ">
		      		<a class = "nav-link" id="about" href="Aboutus.jsp">About Us</a>
	      		</li>
	      		<li class="nav-item">
		      		<a class = "nav-link" id="profile" href="Profile.jsp">Profile</a>
	      		</li>
	      		<li class="nav-item">
		      		<a class = "nav-link" id="login" href="login.jsp">Sign Out</a>
	      		</li>
	      		
	    	</ul>
	    	<h2 id = "welcome" style= "color: white;"> </h2>
	 </div>
</nav>
<br>
	<div class="container">	
		<div class="row" style="padding-left: 10%">
			<div class="circle" id="initials"></div>
			<h1 id="image" style="padding-left:10%; padding-top: 9%"></h1>
		</div> 
	</div> 
	<br>
	<br>
	<div class="container" >
	
		<div class="row">
		
			<div class="col-12 col-md-6" style="border-right: 6px solid; padding:15px; width: 33%;">
				<h2 id="favbill" style="text-align: center;"></h2>
					<table id="favBills"></table>
			</div>	
			<div class="col-12 col-md-5" style="border-bottom: 6px solid; padding:15px; width: 33%;">
				<h2 id="friends" style="text-align: center;"></h2>
					<table id="friendsTable"></table>						
			</div>
			
			<br><br>
			
			<div class="col-12 col-md-5" style="padding-left: 5%; border-top: 6px solid; padding:15px; width: 33%;">
				<h2 style="text-align: center;">Requests</h2>
					<table id="requestsTable"></table>						
			</div>
	
		</div> 
	</div> 
</body>
<script>
let xhttp = new XMLHttpRequest();
xhttp.open("GET", "Profile?acn=follow" +
		"&un=" + sessionStorage.getItem("log"), false);
xhttp.send();
if(xhttp.responseText.length > 0) {
	let idresults = xhttp.responseText.toString().split(",");
	let favbills = document.querySelector("#favBills");
	for(var i=0; i<idresults.length; ++i) {
		let xhr = new XMLHttpRequest();
		xhr.open("GET", "Detail?billid=" + idresults[i], false);
		xhr.send();
		let billresult = JSON.parse(xhr.responseText);
		let billRow = document.createElement("tr");
		let billContent = document.createElement("td");
		let buttonWrapper = document.createElement("td");
		let button =document.createElement("i");
		button.setAttribute("class", "fa fa-star");
		button.style.fontSize = "24px";
		button.style.color = "yellow";
		buttonWrapper.appendChild(button);
		let billtitle = document.createElement("p");
		billtitle.innerHTML = billresult.results[0].title;
		billContent.appendChild(billtitle);
		billRow.appendChild(buttonWrapper);
		billRow.appendChild(billContent);
		favbills.appendChild(billRow); 
	}
}
xhttp.open("GET", "Profile?acn=friends" +
		"&un=" + sessionStorage.getItem("log"), false);
xhttp.send();
if(xhttp.responseText.length > 0) {
	let friendresults = xhttp.responseText.toString().split(",");
	let friends = document.querySelector("#friendsTable");
	for(var i=0; i<friendresults.length; ++i) {
		console.log(friendresults[i]);
		let friendRow = document.createElement("tr");
		let friendContent = document.createElement("td");
		let buttonWrapper = document.createElement("td");
		let button = document.createElement("i");
		button.setAttribute("class", "fa fa-close");
		button.innerHTML = "<h6 style='font-family: arial;'>Delete</h6>";
		button.style.fontSize = "24px";
		button.value = friendresults[i];
		button.onclick = function() {
			alert(this.value + " is no longer your friend!")
			xhr = new XMLHttpRequest();
			xhr.open("GET", "Addfriend?src=/Profile.jsp" +
					"&un="+ sessionStorage.getItem("log") +
					"&friend=" + this.value +
					"&action=delete", false);
			xhr.send();
			location.reload();
		}
		buttonWrapper.appendChild(button);
		let friendname = document.createElement("p");
		friendname.innerHTML = friendresults[i];
		friendContent.appendChild(friendname);
		friendRow.appendChild(buttonWrapper);
		friendRow.appendChild(friendContent);
		friends.appendChild(friendRow);
	}
}

xhttp.open("GET", "Profile?acn=friendrequests" +
		"&un=" + sessionStorage.getItem("log"), false);
xhttp.send();
if(xhttp.responseText.length > 0) {
	let requestresults = xhttp.responseText.toString().split(",");
	let requests = document.querySelector("#requestsTable");
	for(var i=0; i<requestresults.length; ++i) {
		let requestRow = document.createElement("tr");
		let requestContent = document.createElement("td");
		let buttonWrapper = document.createElement("td");
		let check = document.createElement("i");
		check.value = requestresults[i];
		check.setAttribute("class", "fa fa-check");
		check.innerHTML = "<h6 style='font-family: arial;'>Accept</h6>";
		check.style.fontSize = "24px";
		check.onclick = function() {
			alert(this.value + " is now your friend!");
			xhr = new XMLHttpRequest();
			xhr.open("GET", "Addfriend?src=/Profile.jsp" +
					"&un="+ sessionStorage.getItem("log") +
					"&friend=" + this.value  +
					"&action=accept", false);
			xhr.send();
			location.reload();
		}
		let close = document.createElement("i");
		close.value = requestresults[i];
		close.setAttribute("class", "fa fa-close");
		close.innerHTML = "<h6 style='font-family: arial;'>Reject</h6>";
		close.style.fontSize = "24px";
		close.onclick = function() {
			alert("You deleted " + this.value + "'s friend request!");
			xhr = new XMLHttpRequest();
			xhr.open("GET", "Addfriend?src=/Profile.jsp" +
					"&un="+ sessionStorage.getItem("log") +
					"&friend=" + this.value  +
					"&action=delete", false);
			xhr.send();
			location.reload();
		}
		buttonWrapper.appendChild(check);
		buttonWrapper.appendChild(close);
		let request = document.createElement("p");
		request.innerHTML = requestresults[i];
		requestContent.appendChild(request);
		requestRow.appendChild(buttonWrapper);
		requestRow.appendChild(requestContent);
		requests.appendChild(requestRow);
	}
}
 
</script>
</html>
