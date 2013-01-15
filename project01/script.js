function check() {
	var check = document.getElementById('feeling');
	if(check.value.size == 0 || check.value == "" || check.value == null) {
		alert("Surely you feel something!");
	} 
}