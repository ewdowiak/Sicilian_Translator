function copyTranslation() {
  // Get the text field
  var copyText = document.getElementById("myTranslation");

  // Select the text field
  copyText.select();
  copyText.setSelectionRange(0, 99999); // For mobile devices

   // Copy the text inside the text field
  navigator.clipboard.writeText(copyText.value);

  // Alert the copied text
  // alert("copiata la traduzzioni: " + copyText.value);
  var tooltip = document.getElementById("myTooltip");
  // tooltip.innerHTML = "cupiata: " + copyText.value;
  tooltip.innerHTML = "cupiata!"
}

function outFunc() {
  var tooltip = document.getElementById("myTooltip");
  tooltip.innerHTML = "copia la traduzzioni";
}
