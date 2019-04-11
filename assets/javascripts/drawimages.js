function plusint(d){
  return (d>0)?d:0;
}
function getTranslation(sel) {
  const matrix = sel.node().transform.baseVal.consolidate().matrix;
  return [matrix.e, matrix.f];
}
function drawimages(){
  function set_image(d,i){
    const image_g = d3.select(this)
      .attr("cursor","move")
      .attr("transform", "translate(0,0)");
    const image = image_g
      .append("image")
        .attr("preserveAspectRatio", "none")
        .attr("xlink:href", function(d){return d.url})
    const rect = image.node().getBBox();
    const pos = getTranslation(image_g);
    function image_drag(d){
      const x = d3.event.x;
      d.x = d3.event.x;
      const y = d3.event.y;
      d.y = d3.event.y;
      image_g
        .attr("transform", function(d,i){
          return "translate(" + [ x,y ] + ")"
        });
    }
    image_g
      .call(d3.drag().on("drag", image_drag));

    image.attr("width", rect.width).attr("height", rect.height);
    function w_drag(d){
      const x = d3.mouse(image_g.node())[0];
      image
        .attr("width", x);
      image_g.select(".image_width")
        .attr("x1", x)
        .attr("x2", x);
    }
    image_g
      .append("line")
        .attr("class","image_width")
        .attr("x1", rect.width).attr("y1", 0)
        .attr("x2", rect.width).attr("y2", rect.height)
        .attr("stroke", "black").attr("stroke-opacity",0).attr("stroke-width",3)
        .attr("cursor", "w-resize")
        .call(d3.drag().on("drag", w_drag));
    function h_drag(d){
      const y = d3.mouse(image_g.node())[1];
      image
        .attr("height", y);
      image_g.select(".image_height")
        .attr("y1", y)
        .attr("y2", y);
    }
    image_g
      .append("line")
        .attr("class","image_height")
        .attr("x1", 0).attr("y1", rect.height)
        .attr("x2", rect.width).attr("y2", rect.height)
        .attr("stroke", "black").attr("stroke-opacity",0).attr("stroke-width",3)
        .attr("cursor", "s-resize")
        .call(d3.drag().on("drag", h_drag));
  }
  const svg = d3.select("svg");
  d3.json(params["get_images_link"],function(data){
    const WIDTH = svg.attr("width");
    const HEIGHT = svg.attr("height");
    const PADDING = 50;
    const W_DIFF = (WIDTH - PADDING) / data.length;

    d3.select(".selector")
      .append("rect")
        .attr("x",0).attr("y",0)
        .attr("width", WIDTH).attr("height", HEIGHT)
        .attr("fill", "black")
        .attr("opacity", 0.6);
    d3.select(".selector").selectAll("image").data(data).enter()
      .append("image")
        .attr("xlink:href", function(d){return d.url})
        .attr("preserveAspectRatio", "xMidYMin meet")
        .attr("width", W_DIFF - PADDING)
        .attr("height", HEIGHT/2 - PADDING)
        .attr("cursor","pointer")
        .attr("y", -300).attr("x", 0)
        .on("click", function(d){
          d.x = 0;
          d.y = 0;
          d3.select(".selector").select("rect").remove();
          d3.select(".selector").selectAll("image").remove();
          d3.select(".images")
            .selectAll("g").data([d]).enter()
            .append("g").each(set_image);
        })
        .transition()
        .duration(750)
        .attr("y", HEIGHT/4+PADDING)
        .attr("x", function(d,i){return W_DIFF*i + PADDING});
  });
}
