var check;

function checkValidity() {
	check = document.getElementById('feeling').value;
	if(check.size == 0 || check == "" || check == null) {
		alert("Surely you feel something!");
	} 
	return false;
}