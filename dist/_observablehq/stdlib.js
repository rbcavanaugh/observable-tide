var k=Object.defineProperty;var i=(t,e)=>k(t,"name",{value:e,configurable:!0});var z=Object.defineProperty,l=i((t,e)=>z(t,"name",{value:e,configurable:!0}),"o$3");const m=new Map;function b(t,e){const r=new URL(t,location).href;e==null?m.delete(r):m.set(r,e)}i(b,"h"),l(b,"registerFile");function h(t,e=location.href){if(new.target!==void 0)throw new TypeError("FileAttachment is not a constructor");const r=new URL(t,e).href,n=m.get(r);if(!n)throw new Error(`File not found: ${t}`);const{path:a,mimeType:o,lastModified:c}=n;return new p(new URL(a,location).href,t.split("/").pop(),o,c)}i(h,"f$3"),l(h,"FileAttachment");async function s(t){const e=await fetch(await t.url());if(!e.ok)throw new Error(`Unable to load file: ${t.name}`);return e}i(s,"i$5"),l(s,"remote_fetch");async function y(t,e,{array:r=!1,typed:n=!1}={}){const[a,o]=await Promise.all([t.text(),import("../_npm/d3-dsv@3.0.1/_esm.js")]);return(e==="	"?r?o.tsvParseRows:o.tsvParse:r?o.csvParseRows:o.csvParse)(a,n&&o.autoType)}i(y,"m$1"),l(y,"dsv");let w=class{static{i(this,"w")}static{l(this,"AbstractFile")}constructor(e,r="application/octet-stream",n){Object.defineProperty(this,"mimeType",{value:`${r}`,enumerable:!0}),Object.defineProperty(this,"name",{value:`${e}`,enumerable:!0}),n!==void 0&&Object.defineProperty(this,"lastModified",{value:Number(n),enumerable:!0})}async blob(){return(await s(this)).blob()}async arrayBuffer(){return(await s(this)).arrayBuffer()}async text(e){return e===void 0?(await s(this)).text():new TextDecoder(e).decode(await this.arrayBuffer())}async json(){return(await s(this)).json()}async stream(){return(await s(this)).body}async csv(e){return y(this,",",e)}async tsv(e){return y(this,"	",e)}async image(e){const r=await this.url();return new Promise((n,a)=>{const o=new Image;new URL(r,document.baseURI).origin!==new URL(location).origin&&(o.crossOrigin="anonymous"),Object.assign(o,e),o.onload=()=>n(o),o.onerror=()=>a(new Error(`Unable to load file: ${this.name}`)),o.src=r})}async arrow(){const[e,r]=await Promise.all([import("../_npm/apache-arrow@16.0.0/_esm.js"),s(this)]);return e.tableFromIPC(r)}async parquet(){const[e,r,n]=await Promise.all([import("../_npm/apache-arrow@16.0.0/_esm.js"),import("../_npm/parquet-wasm@0.5.0/esm/arrow1.js").then(async a=>(await a.default(),a)),this.arrayBuffer()]);return e.tableFromIPC(r.readParquet(new Uint8Array(n)).intoIPCStream())}async sqlite(){const[{SQLiteDatabaseClient:e},r]=await Promise.all([import("./stdlib/sqlite.js"),this.arrayBuffer()]);return e.open(r)}async zip(){const[{ZipArchive:e},r]=await Promise.all([import("./stdlib/zip.js"),this.arrayBuffer()]);return e.from(r)}async xml(e="application/xml"){return new DOMParser().parseFromString(await this.text(),e)}async html(){return this.xml("text/html")}async xlsx(){const[{Workbook:e},r]=await Promise.all([import("./stdlib/xlsx.js"),this.arrayBuffer()]);return e.load(r)}},p=class extends w{static{i(this,"l")}static{l(this,"FileAttachmentImpl")}constructor(e,r,n,a){super(r,n,a),Object.defineProperty(this,"_url",{value:e})}async url(){return`${await this._url}`}};Object.defineProperty(p,"name",{value:"FileAttachment"}),h.prototype=p.prototype;var U=Object.defineProperty,B=i((t,e)=>U(t,"name",{value:e,configurable:!0}),"r$3");async function*u(t){let e,r,n=!1;const a=t(o=>(r=o,e?(e(o),e=null):n=!0,o));if(a!=null&&typeof a!="function")throw new Error(typeof a.then=="function"?"async initializers are not supported":"initializer returned something, but not a dispose function");try{for(;;)yield n?(n=!1,r):new Promise(o=>e=o)}finally{a?.()}}i(u,"u"),B(u,"observe");var C=Object.defineProperty,g=i((t,e)=>C(t,"name",{value:e,configurable:!0}),"o$2");function P(){return u(t=>{let e;const r=matchMedia("(prefers-color-scheme: dark)"),n=g(()=>{const a=getComputedStyle(document.body).getPropertyValue("color-scheme")==="dark";e!==a&&t(e=a)},"changed");return n(),r.addEventListener("change",n),()=>r.removeEventListener("change",n)})}i(P,"m"),g(P,"dark");var M=Object.defineProperty,f=i((t,e)=>M(t,"name",{value:e,configurable:!0}),"e$1");function $(t){return u(e=>{const r=O(t);let n=v(t);const a=f(()=>e(v(t)),"inputted");return t.addEventListener(r,a),n!==void 0&&e(n),()=>t.removeEventListener(r,a)})}i($,"o$1"),f($,"input");function v(t){switch(t.type){case"range":case"number":return t.valueAsNumber;case"date":return t.valueAsDate;case"checkbox":return t.checked;case"file":return t.multiple?t.files:t.files[0];case"select-multiple":return Array.from(t.selectedOptions,e=>e.value);default:return t.value}}i(v,"a"),f(v,"valueof");function O(t){switch(t.type){case"button":case"submit":case"checkbox":return"click";case"file":return"change";default:return"input"}}i(O,"f$2"),f(O,"eventof");var _=Object.defineProperty,I=i((t,e)=>_(t,"name",{value:e,configurable:!0}),"e");async function*j(){for(;;)yield Date.now()}i(j,"i$3"),I(j,"now");var T=Object.defineProperty,q=i((t,e)=>T(t,"name",{value:e,configurable:!0}),"r$2");async function*x(t){let e;const r=[],n=t(a=>(r.push(a),e&&(e(r.shift()),e=null),a));if(n!=null&&typeof n!="function")throw new Error(typeof n.then=="function"?"async initializers are not supported":"initializer returned something, but not a dispose function");try{for(;;)yield r.length?r.shift():new Promise(a=>e=a)}finally{n?.()}}i(x,"l"),q(x,"queue");var D=Object.defineProperty,S=i((t,e)=>D(t,"name",{value:e,configurable:!0}),"i$2");function F(t,e){return u(r=>{let n;const a=new ResizeObserver(([o])=>{const c=o.contentRect.width;c!==n&&r(n=c)});return a.observe(t,e),()=>a.disconnect()})}i(F,"d$1"),S(F,"width");var N=Object.freeze({__proto__:null,dark:P,input:$,now:j,observe:u,queue:x,width:F}),G=Object.defineProperty,Q=i((t,e)=>G(t,"name",{value:e,configurable:!0}),"r$1");function A(t){let e;return Object.defineProperty(u(r=>{e=r,t!==void 0&&e(t)}),"value",{get:()=>t,set:r=>void e(t=r)})}i(A,"f$1"),Q(A,"Mutable");var V=Object.defineProperty,E=i((t,e)=>V(t,"name",{value:e,configurable:!0}),"o");function L(t,e){const r=document.createElement("div");r.style.position="relative",t.length!==1&&(r.style.height="100%");const n=new ResizeObserver(([a])=>{const{width:o,height:c}=a.contentRect;for(;r.lastChild;)r.lastChild.remove();if(o>0){const d=t(o,c);t.length!==1&&R(d)&&(d.style.position="absolute"),r.append(d)}});return n.observe(r),e?.then(()=>n.disconnect()),r}i(L,"d"),E(L,"resize");function R(t){return t.nodeType===1}i(R,"v"),E(R,"isElement");var W=Object.defineProperty,Z=i((t,e)=>W(t,"name",{value:e,configurable:!0}),"t");class H{static{i(this,"p")}static{Z(this,"Library")}}const J=void 0;export{w as AbstractFile,h as FileAttachment,J as FileAttachments,N as Generators,H as Library,A as Mutable,b as registerFile,L as resize};
