---
toc: false
theme: cotton
---

```js
const dt = FileAttachment("data/tideData.csv").csv({typed: true})
```

```js
//Inputs.table(dt)
```

```js
let fdate = "a" + new Date().toISOString().slice(0, 10).replace(/-/g,"");
```

```js
let dt_date = dt.filter(function(dt) {
    return dt.dateFactor == fdate; });
```

```js
//Inputs.table(dt_date)
```

```js
var today = new Date()
// Create date.  Left empty, will default to 'now'
var time_min = new Date();
var time_max = new Date();

// Set hours
time_min.setHours(4);
time_min.setMinutes(0);
time_min.setSeconds(0);

time_max.setHours(21);
time_max.setMinutes(0);
time_max.setSeconds(0);
```

```js

```


```js

Plot.plot({
  y: {
    grid: true,
    label: "Tide Height (m)"
  },
  x: {
    type: "time",
    //domain: [time_min, time_max],
    grid: true,
    nice: true,
    //tickFormat: (d) => d.convertTZ("America/New_York")
  },
  marks: [
    //Plot.ruleY([0]),
    Plot.lineY(dt, {x: "time", y: "TideHeight", z:"dateFactor", curve: "catmull-rom",strokeWidth: 30, opacity: 0.05, stroke: "grey"}),
    Plot.lineY(dt_date, {x: "time", y: "TideHeight", stroke: "TideHeight", z:null, curve: "catmull-rom", strokeWidth: 10}),
    Plot.ruleX(dt_date, Plot.pointerX({x: "time", py: "TideHeight", stroke: "#1d1936", strokeWidth: 2})),
    Plot.dot(dt_date, Plot.pointerX({x: "time", y: "TideHeight", fill: "#1d1936", stroke: "white", strokeWidth: 1, r:4})),
    Plot.text(dt_date, Plot.pointerX({px: "time", py: "TideHeight", dy: -17, frameAnchor: "top-right", fontVariant: "tabular-nums", text: (d) => [`${d.time.toLocaleTimeString([], {year: 'numeric', month: 'numeric', day: 'numeric', hour: '2-digit', minute: '2-digit'})}`, `Tide Height ${d.TideHeight.toFixed(1)} m`].join("   ")}))
  ],
  color: {
    type: "diverging",
    scheme: "brbg", 
    legend: false, 
    pivot: 1.5, 
    symmetric: false
  },
})
```
