(this.webpackJsonpapp4ucu=this.webpackJsonpapp4ucu||[]).push([[0],{15:function(e,a,t){e.exports=t(26)},20:function(e,a,t){},25:function(e,a,t){},26:function(e,a,t){"use strict";t.r(a);var l=t(0),n=t.n(l),c=t(2),r=t.n(c),o=t(12),s=t(35),i=t(9),u=t.n(i),m=(t(20),[{value:0,label:"0"},{value:50,label:"50"},{value:100,label:"100"}]);var p=!1;function d(){p=!p,console.log("Switch button is turned "+(p?"on":"off"))}function h(){var e=Object(l.useState)(30),a=Object(o.a)(e,2),t=a[0],c=a[1];return n.a.createElement("div",{className:"Ucu"},n.a.createElement("h1",{className:"welcomeHeader"},"This is the welcome page of the UCU microcontroller. ",n.a.createElement("br",null),"You can control it through this application. Just use the options below"),n.a.createElement("div",{className:"switchButtonDiv"},n.a.createElement("h2",null,"Turn On and Off",n.a.createElement(u.a,{checked:p,onstyle:"success",size:"sm",offstyle:"danger",onChange:d}))),n.a.createElement("h2",null,n.a.createElement("div",{className:"sliderHeader"},"Slide left or write by clicking on the point",n.a.createElement(s.a,{defaultValue:30,"aria-labelledby":"discrete-slider",valueLabelDisplay:"auto",step:1,color:"primary",track:"inverted",onChange:function(e,a){c(a),console.log("Value is "+a,"Type is "+typeof a)},marks:m,min:0,max:100})),n.a.createElement("span",{className:"sliderValue"},"Slider value ",t,"%")),n.a.createElement("div",{className:"xml"},"HERE is the place for the XML table, upload, etc."))}t(25);r.a.render(n.a.createElement((function(){return n.a.createElement("div",{className:"App"},n.a.createElement(h,null))}),null),document.getElementById("root"))}},[[15,1,2]]]);
//# sourceMappingURL=main.06d61c42.chunk.js.map