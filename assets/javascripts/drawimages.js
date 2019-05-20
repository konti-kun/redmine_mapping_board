function getTranslation(sel) {
  const matrix = sel.node().transform.baseVal.consolidate().matrix;
  return [matrix.e, matrix.f];
}
function set_image(d,i){
  const svg = d3.select("svg");
      
  const image_g = d3.select(this)
    .attr("class", "image_g")
    .attr("id", "image" + d.id)
    .attr("cursor","move")
    .attr("transform", "translate("+ [d.x,d.y] +")")
  const image = image_g
    .append("image")
      .attr("preserveAspectRatio", "none")
      .attr("xlink:href", function(d){return d.url})
  const rect = image.node().getBBox();
  const pos = getTranslation(image_g);
  function enddrag(d){
    const formdata = new FormData();
    formdata.append("mappingimage[x]", d.x);
    formdata.append("mappingimage[y]", d.y);
    formdata.append("mappingimage[width]", image.attr("width"));
    formdata.append("mappingimage[height]", image.attr("height"));
    update_url = params['images_link'] + "/" + d["id"];
    request_mappingimage(update_url,formdata,"put");
  }
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
    .call(d3.drag()
	    .on("drag", image_drag)
      .on("end", enddrag)
    );

  if(rect.width > svg.attr("width") -10 ){
      rect.width = svg.attr("width") -10;
  }
  if(rect.height > svg.attr("height") -10 ){
      rect.height = svg.attr("height") -10;
  }

  if(d["width"]){
      rect.width = d["width"];
  }
  if(d["height"]){
      rect.height = d["height"];
  }
  image.attr("width", rect.width).attr("height", rect.height);

  function w_drag(d){
    const x = d3.mouse(image_g.node())[0];
    image
      .attr("width", x);
    image_g.select(".image_width")
      .attr("x1", x)
      .attr("x2", x);
    image_g.select(".del_btn")
      .attr("transform", "translate(" + [x,0] + ")");
  }
  image_g
    .append("line")
      .attr("class","image_width")
      .attr("x1", rect.width).attr("y1", 0)
      .attr("x2", rect.width).attr("y2", rect.height)
      .attr("stroke", "black").attr("stroke-opacity",0).attr("stroke-width",3)
      .attr("cursor", "w-resize")
      .call(
	d3.drag()
	  .on("drag", w_drag)
	  .on("end", enddrag)
      );
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
      .call(
        d3.drag()
          .on("drag", h_drag)
          .on("end", enddrag)
      );
  image_g.call(
    create_del_btn, params['images_link'], params["message_conform_del_image"], request_mappingimage
  );
}
function request_mappingimage(link, formdata, method){
  d3.select("#ajax-indicator").style("display","block");
  const token = d3.select('meta[name="csrf-token"]').attr('content');
  d3.json(link)
  .header('X-CSRF-Token', token)
  .send(method, formdata, function(data){
  const images = d3.select(".images")
  .selectAll(".image_g").data(data, function(d){return d.id});
  images.exit().remove();
  images.enter()
  .append("g").each(set_image)
  d3.select("#ajax-indicator").style("display","none");
  });
}
function drawimages(){
  const svg = d3.select("svg");
  d3.json(params["get_images_link"],function(data){
    if(data.length == 0){
      alert(params["message_conform_zero_image"]);
      return
    }
    const WIDTH = svg.attr("width");
    const HEIGHT = svg.attr("height");
    const PADDING = 50;
    const W_DIFF = (WIDTH - PADDING) / data.length;

    d3.select(".selector")
      .append("rect")
        .attr("x",0).attr("y",0)
        .attr("width", WIDTH).attr("height", HEIGHT)
        .attr("fill", "black")
        .attr("opacity", 0.6)
        .on("click", function(d){
          d3.select(".selector").select("rect").remove();
          d3.select(".selector").selectAll("image").remove();
        });
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
	        const formdata = new FormData();
	        formdata.append("mappingimage[url]",d['url']);
          request_mappingimage(params['images_link'],formdata,"post");
        })
        .transition()
        .duration(750)
        .attr("y", HEIGHT/4+PADDING)
        .attr("x", function(d,i){return W_DIFF*i + PADDING});
  });
}
