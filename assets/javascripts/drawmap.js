function update_notes(data,svg){
  var note = svg.selectAll("g").data(data)
  
  note.exit().remove();
  
  note
  .enter().append("g")
  .attr("transform",function(d){return "translate(0,0)"})
  .each(function(d){
    var note_width = 150;
    var note_height= 120;
    var div_style = "font-size:10px;word-wrap:break-word;width:" + (note_width-10) + "px;height:" + (note_height-10)+"px;";
    var note_node = d3.select(this);
    note_node.append("rect").attr("width", note_width).attr("height", note_height).attr("stroke","black").attr("fill","white")
    .attr("filter","url(#drop-shadow)");
    note_node.append("rect").attr("width", note_width).attr("height", note_height).attr("stroke","black").attr("fill","white");
    svg.append("foreignObject").attr("x",5).attr("y",5).attr("width",note_width-10).attr("height",note_height-10)
    .append("xhtml:div").attr("style",div_style);
  })
  .merge(note)
  .transition()
  .duration(750)
  .attr("transform",function(d){return "translate(" + d.x + "," + d.y + ")"})
}

