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
    var div_style = "font-size:10px;word-wrap:break-word;overflow:hidden;width:" + (note_width-10) + "px;height:" + (note_height-10)+"px;";
    var note_node = d3.select(this);
    note_node.append("rect").attr("width", note_width).attr("height", note_height).attr("stroke","black").attr("fill","white")
    .attr("filter","url(#drop-shadow)");
    if(d["issue_id"] == null){
      col = "white";
    }else{
      col = d3.schemePastel1[d["issue"]["tracker_id"] % 10];
    }
    var node_rect = note_node.append("rect").attr("width", note_width).attr("height", note_height).attr("stroke","black").attr("fill",col);

    var div = note_node.append("foreignObject").attr("x",5).attr("y",5).attr("width",note_width-10).attr("height",note_height-10)
    .append("xhtml:div").attr("style",div_style)
    var col;
    div.append("div").attr("class","note_id").append("div").attr("style","float:left;").text(number);

    var notedrag = function(d){
      var x = d3.event.x;
      d.x = d3.event.x;
      var y = d3.event.y;
      d.y = d3.event.y;
      note_node.attr("transform", function(d,i){
        return "translate(" + [ x,y ] + ")"
      });
    }
    note_node.call(
      d3.drag().on("drag",notedrag).on("end",function(d){
        var note_formdata = new FormData();
        note_formdata.append("number",d["number"]);
        note_formdata.append("x",d["x"])
        note_formdata.append("y",d["y"]);
        var token = d3.select('meta[name="csrf-token"]').attr('content');
        d3.request(params['update_pos'])
        .header('X-CSRF-Token', token)
        .post(note_formdata,function(data){
          var notes = d3.select(".svg_panel").select(".notes");
          update_notes(JSON.parse(data.response),notes, params);
        })
      })
    );
    if(d["issue_id"] == null){
      var sub_div = div.append("div").html(params['issue_new_link'])
      .style("padding-top","3px").style("padding-bottom","3px").style("float","left");
      sub_div.select("a").style("padding-top","3px").style("padding-bottom","3px");
      sub_div.select("a").attr("href", sub_div.select("a").attr("href") + "?note_id=" + d["number"])
    }else{
      var sub_div = div.select(".note_id").append("div")
      .style("float","right");
      sub_div.append("a")
      .attr("href", params['issue_link'].replace("0",d["issue_id"])).text("#" + d["issue_id"]);
      div.append("div")
      .style("float","left").style("padding-top","3px")
      .style("width",(note_width-10)+"px")
      .attr("title", d["issue"]["subject"])
      .text(d["issue"]["subject"]);
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

