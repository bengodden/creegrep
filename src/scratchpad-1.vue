, getLastCachedResult() { const emptyArray = []; if
(!Array.isArray(this.cachedResults) || !this.cachedResults.length) {
console.log("returning empty array"); return emptyArray; } else { console.log(
"RETURNING:", this.cachedResults[this.cachedResults - 1].result ); return
this.cachedResults[this.cachedResults - 1].result; } }, databases: [ { name:
"Dictionary", data: this.dictionary }, { name: "Results", data:
this.getLastCachedResult }, ], .flexcontainer { display: flex; /* or inline-flex
*/ flex-direction: row; flex-wrap: wrap; } .container { display: flex; /* or
inline-flex */ flex-direction: row; flex-wrap: wrap; } .button:hover {
background-color: #002ead; transition: 0.7s; } .button:active {
background-color: #ffbf00; } button:focus { background: olive; } .button:hover {
background-color: #002ead; transition: 0.7s; } .button:active {
background-color: #ffbf00; } button:focus { background: olive; }
this.searchTypes.forEach((el) => {
document.getElementById(el.Lang).classList.remove("stactive"); });
document.getElementById(type.Lang).classList.add("stactive");
this.$refs.parentOfDatabases.lastElementChild.appendChild(
document.getElementById("flexcontainer") );
