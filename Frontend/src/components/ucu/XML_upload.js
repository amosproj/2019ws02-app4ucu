var readXml=null;
$('#xmlForm').submit(function(event) {
    event.preventDefault();
    var selectedFile = document.getElementById('input').files[0];
    console.log(selectedFile);
    var reader = new FileReader();
    reader.onload = function(e) {
        readXml=e.target.result;
        console.log(readXml);
        var parser = new DOMParser();
        var doc = parser.parseFromString(readXml, "application/xml");
        console.log(doc);
        var table="<tr><th>Name</th><th>Init.</th><th>Max</th><th>Type</th></tr>";
var x = doc.getElementsByTagName("book");
for (i = 0; i <x.length; i++) { 
table += "<tr><td>" +
x[i].getElementsByTagName("title")[0].childNodes[0].nodeValue +
"</td><td>" +
x[i].getElementsByTagName("author")[0].childNodes[0].nodeValue +
"</td><td>" +
x[i].getElementsByTagName("year")[0].childNodes[0].nodeValue +
"</td><td>" +
x[i].getElementsByTagName("price")[0].childNodes[0].nodeValue +
"</td></tr>";
}


document.getElementById("demo").innerHTML = table;
    }
    reader.readAsText(selectedFile);

});