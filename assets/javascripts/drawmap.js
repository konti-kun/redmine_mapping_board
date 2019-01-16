var svg = d3.select(".svg_panel").append("svg").attr("width",1000).attr("height",500);
svg.selectAll("g").data(datas).enter().append("g")
.attr("transform",function(d){return "translate(" + d.x + "," + d.y + ")"})
.each(function(d){
  d3.select(this).append("rect")
  .attr("x",0).attr("y",0)
  .attr("height",100).attr("width",200)
  .attr("stroke","black").attr("fill", "#F9F5E8"); 
});

