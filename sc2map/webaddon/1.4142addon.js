(f = () => setTimeout(() => (x => x.innerHTML = x.innerHTML.replace(/.+DPS/g, y => y.replace(/\d+(\.\d+)?/g, z => (1.4142 * z).toFixed(2))))(document.getElementById("statsContent")), 1000));

setInterval(() => { e = document.getElementById("recalculate"); e && e.addEventListener("click", f) }, 1000)