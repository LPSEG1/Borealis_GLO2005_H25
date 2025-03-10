/* Get current year */

document.addEventListener("DOMContentLoaded", function() {
  var currentYear = new Date().getFullYear();
  document.getElementById('currentYear').textContent = currentYear;
});
