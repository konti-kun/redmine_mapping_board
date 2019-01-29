function update_notes(data,svg, params){
  var note = svg.selectAll("g").data(data, function(d){ return d['number']})
  
  note.exit().remove();
  
  note
  .enter().append("g")
  .attr("transform",function(d){return "translate(0,0)"})
  .each(function(d){
    var note_width = 110;
    var note_height= 80;
    var number = d["number"];
    var div_style = "font-size:10px;word-wrap:break-word;width:" + (note_width-10) + "px;height:" + (note_height-10)+"px;";
    var note_node = d3.select(this);
    note_node.append("rect").attr("width", note_width).attr("height", note_height).attr("stroke","black").attr("fill","white")
    .attr("filter","url(#drop-shadow)");
    note_node.append("rect").attr("width", note_width).attr("height", note_height).attr("stroke","black").attr("fill","white");
    var div = note_node.append("foreignObject").attr("x",5).attr("y",5).attr("width",note_width-10).attr("height",note_height-10)
    .append("xhtml:div").attr("style",div_style)
    div.append("div").text(number);
    if(d["issue_id"] == null){
      var sub_div = div.append("div").html(params['issue_new_link'])
      .style("padding-top","3px").style("padding-bottom","3px");
      sub_div.select("a").style("padding-top","3px").style("padding-bottom","3px");
      sub_div.select("a").attr("href", sub_div.select("a").attr("href") + "?note_id=" + d["number"])
    }else{
      var sub_div = div.append("div")
      .style("padding-top","3px").style("padding-bottom","3px");
      sub_div.append("a").style("padding-top","3px").style("padding-bottom","3px")
      .attr("href", params['issue_link'].replace("0",d["issue_id"])).text("#" + d["issue_id"]);
      sub_div.append("div").text(d["issue"]["subject"]);
    }
  })
  .merge(note)
  .transition()
  .duration(750)
  .attr("transform",function(d){return "translate(" + d.x + "," + d.y + ")"})
  .on("end",function(){
    d3.select(".range").select("image")
    .transition()
    .ease(d3.easePoly)
    .duration(300)
    .attr("opacity",0)
    .on("end",function(){
      d3.select(".range").select("image").remove();
    });
  });
  
}

