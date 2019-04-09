function drawrect(selector){
  function dragstarted(){
    d3.select(".range").select("rect").remove();
    d3.select(".range")
      .append("rect")
        .attr("stroke", "red").attr("fill","gray").attr("fill-opacity", 0.3)
        .attr("x", d3.event.x).attr("y", d3.event.y)
        .attr("width", 0).attr("height", 0)
        .on("dragover", function(e){
          d3.event.stopPropagation();
          d3.event.preventDefault();
        });
  }
  function dragged(){
    const start_x = Number(d3.select(".range").select("rect").attr("x"));
    const start_y = Number(d3.select(".range").select("rect").attr("y"));
    d3.select(".range").select("rect")
      .attr("width", d3.max([0,d3.event.sourceEvent.offsetX - start_x]))
      .attr("height",d3.max([0,d3.event.sourceEvent.offsetY - start_y]))
  }
  const svg = d3.select("svg")
  selector
    .append("rect")
      .attr("x", 0).attr("y", 0)
      .attr("width", svg.attr("width")).attr("height", svg.attr("height"))
      .attr("fill", "white").attr("fill-opacity",0)
      .call(
        d3.drag()
          .on("start",dragstarted)
          .on("drag", dragged)
      );
}
