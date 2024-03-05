---
toc: false
theme: [air, midnight]
---

<head>
<link rel="apple-touch-icon" sizes="180x180" href="https://github.com/rbcavanaugh/observable-tide/blob/main/icon/apple-touch-icon.png?raw=true">
<link rel="icon" type="image/png" sizes="32x32" href="https://github.com/rbcavanaugh/observable-tide/blob/main/icon/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="https://github.com/rbcavanaugh/observable-tide/blob/main/icon/favicon-16x16.png">
<link rel="manifest" href="https://github.com/rbcavanaugh/observable-tide/blob/main/icon/site.webmanifest">
<link rel="mask-icon" href="https://github.com/rbcavanaugh/observable-tide/blob/main/icon/safari-pinned-tab.svg" color="#5bbad5">
<meta name="msapplication-TileColor" content="#da532c">
<meta name="theme-color" content="#ffffff">
</head>

<!-- Here's the css for the button. need to move to a separate file.  -->
<style>
/* CSS */
button {
  align-items: center;
  background-color: var(--theme-background);
  border: 1px solid var(--theme-foreground);
  border-radius: .25rem;
  box-shadow: rgba(0, 0, 0, 0.02) 0 1px 3px 0;
  box-sizing: border-box;
  color: rgba(0, 0, 0, 0.85);
  cursor: pointer;
  display: inline-flex;
  font-family: system-ui,-apple-system,system-ui,"Helvetica Neue",Helvetica,Arial,sans-serif;
  font-size: 16px;
  font-weight: 600;
  justify-content: center;
  line-height: 1.25;
  margin: 0;
  min-height: 3rem;
  padding: calc(.875rem - 2px) calc(1.5rem - 2px);
  position: relative;
  text-decoration: none;
  transition: all 250ms;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  vertical-align: baseline;
  width: auto;
}

button:hover,
button:focus {
  box-shadow: rgba(0, 0, 0, 0.1) 0 4px 12px;
}

button:active {
  background-color: var(--theme-foreground);
  border-color: rgba(0, 0, 0, 0.15);
  box-shadow: rgba(0, 0, 0, 0.06) 0 2px 4px;
  color: rgba(0, 0, 0, 0.65);
  transform: translateY(0);
}
</style>

<!-- Title and Date -->

<div style="justify-content: space-around; display:flex;">
        <h2>Portland Tide</h2>
</div>
<div style="justify-content: space-around; display:flex; margin-bottom: 24px;">
        <div>${currentDate}</div>
</div>

<!-- Read in the data -->
```js
const dt = FileAttachment("data/tideData.csv").csv({typed: true})
//Inputs.table(dt)
```

<!-- Need to create a string variable that can separate the selected day IN EAST COAST TIME! -->
<!-- Data comes in in EST. js doesn't like anything other than UTC. -->

```js
let fdate = "a" + new Date(new Date().setDate(new Date().getDate()+counter)).toISOString().slice(0, 10).replace(/-/g,"");
```

<!-- annoying code to get the date selected to display at the top -->
```js
const fdate_txt = new Date(new Date().setDate(new Date().getDate()+counter))
const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
const dayOfWeek = daysOfWeek[fdate_txt.getDay()];
const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
const currentDate = fdate_txt.toLocaleDateString('en-US', options);
```

<!-- Create a separate dataframe using the datefactor string to select the right day to show in color -->
<!-- also going to limit just to a +/- 15 days around the selected date -->

```js
let dt_date = dt.filter(function(dt) {
    return dt.dateFactor == fdate; });

const fdate_min = new Date(new Date().setDate(new Date().getDate()+counter-15));
const fdate_max = new Date(new Date().setDate(new Date().getDate()+counter+15));

let dt_viz = dt.filter(function(dt) {
   return new Date(dt.DateTime) > fdate_min && new Date(dt.DateTime) < fdate_max;
});
```

```js
const mode_opp = () => window?.matchMedia?.('(prefers-color-scheme:dark)')?.matches ? '#ffffff' : "#1d1936";
const mode = () => window?.matchMedia?.('(prefers-color-scheme:dark)')?.matches ? "#1d1936" : "#ffffff";

```

<!-- Plot code!! -->

<div style="touch-action: none;justify-content: space-around; display:flex;">
${Plot.plot({
    height: 700,
    style: {fontSize: "20px"},
    marginTop: 40,
  y: {
    grid: true,
    label: "Tide Height (m)"
  },
  x: {
    type: "time",
    grid: true,
    nice: true,
  },
  marks: [
    //Plot.ruleY([0]),
    Plot.lineY(dt_viz, {x: "time", y: "TideHeight", z:"dateFactor", curve: "catmull-rom",strokeWidth: 30, opacity: 0.05, stroke: "grey"}),
    Plot.lineY(dt_date, {x: "time", y: "TideHeight", stroke: "TideHeight", z:null, curve: "catmull-rom", strokeWidth: 10}),
    Plot.ruleX(dt_date, Plot.pointerX({x: "time", py: "TideHeight", stroke: mode_opp, strokeWidth: 2})),
    Plot.dot(dt_date, Plot.pointerX({x: "time", y: "TideHeight", fill: mode_opp, stroke: mode, strokeWidth: 1, r:4})),
    Plot.text(dt_date, Plot.pointerX({px: "time", py: "TideHeight", dy: -17, frameAnchor: "top-right", fontVariant: "tabular-nums", text: (d) => [`${d.time.toLocaleTimeString([], {year: 'numeric', month: 'numeric', day: 'numeric', hour: '2-digit', minute: '2-digit'})}`, `Tide Height ${d.TideHeight.toFixed(1)} m`].join("   ")}))
  ],
  color: {
    type: "diverging",
    scheme: "brbg", 
    legend: false, 
    pivot: 1.5, 
    symmetric: false
  }
})
}
</div>


<!-- Button for changing the day shown and the counter -->

```js
const counterInput = Inputs.button([
    ["-1 Day", value => value - 1],
    ["Today", value => 0],
    ["+1 Day", value => value + 1]
    ], {value: 0});

const counter = Generators.input(counterInput);
```

<div style="justify-content: space-around; display:flex;margin-top: 24px;">
    <div>
        ${counterInput}
    </div>
</div>



