, getLastCachedResult() { const emptyArray = []; if
(!Array.isArray(this.cachedResults) || !this.cachedResults.length) {
console.log("returning empty array"); return emptyArray; } else { console.log(
"RETURNING:", this.cachedResults[this.cachedResults - 1].result ); return
this.cachedResults[this.cachedResults - 1].result; } },
