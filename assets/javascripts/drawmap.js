function set_size(selector, width, height){
  return selector.attr("width", width).attr("height", height);
}
function request_note(url, formdata, method="post"){
  const token = d3.select('meta[name="csrf-token"]').attr('content');
  d3.request(url)
  .header('X-CSRF-Token', token)
  .send(method,formdata,function(data){
    const notes = d3.select(".svg_panel").select(".notes");
    update_notes(JSON.parse(data.response),notes);
  })
}

function create_note(d){
  const NOTE_WIDTH = 110;
  const NOTE_HEIGHT= 80;
  const DIV_STYLE = "font-size:10px;word-wrap:break-word;overflow:hidden;width:" + (NOTE_WIDTH-10) + "px;height:" + (NOTE_HEIGHT-10)+"px;";
  const DEL_ICON = "M " + NOTE_WIDTH + " 0 m -3 -3 l 6 6 m 0 -6 l -6 6"
  const NOTE_NODE = d3.select(this);

  NOTE_NODE.append("rect").call(set_size, NOTE_WIDTH, NOTE_HEIGHT)
  .attr("filter","url(#drop-shadow)");

  const NOTE_COLOR = d3.schemePastel1[d["issue"]["tracker_id"] % 10];
  NOTE_NODE
    .append("rect")
      .call(set_size, NOTE_WIDTH, NOTE_HEIGHT)
      .attr("stroke","black").attr("fill",NOTE_COLOR);

  const BODY_DIV = NOTE_NODE
    .append("foreignObject")
      .call(set_size, NOTE_WIDTH-10, NOTE_HEIGHT-10)
      .attr("x",5).attr("y",5)
    .append("xhtml:div")
      .attr("style",DIV_STYLE)

  BODY_DIV
    .append("div")
      .attr("class","note_id")
    .append("div")
      .attr("style","float:left;")
      .text(d["number"]);

  BODY_DIV.select(".note_id")
    .append("div")
      .style("float","right")
    .append("a")
      .attr("href", params['issue_link'].replace("0",d["issue_id"]))
      .text("#" + d["issue_id"]);

  BODY_DIV
    .append("div")
      .style("float","left")
      .style("padding-top","3px")
      .style("width",(NOTE_WIDTH-10)+"px")
      .attr("title", d["issue"]["subject"])
      .text(d["issue"]["subject"]);

   function notedrag(d){
    const x = d3.event.x;
    d.x = d3.event.x;
    const y = d3.event.y;
    d.y = d3.event.y;
    NOTE_NODE
      .attr("transform", function(d,i){
        return "translate(" + [ x,y ] + ")"
      });
  }
  function notedragend(d){
    const note_formdata = new FormData();
    note_formdata.append("number",d["number"]);
    note_formdata.append("x",d["x"])
    note_formdata.append("y",d["y"]);
    request_note(params['update_pos'],note_formdata);
  }

  NOTE_NODE.call(
    d3.drag()
      .on("drag",notedrag)
      .on("end",notedragend)
  );
  const DEL_BTN = NOTE_NODE
    .append("g")
      .attr("class","del_btn")
      .attr("display","none");
  DEL_BTN
    .append("circle")
      .attr("r",7).attr("cx", NOTE_WIDTH).attr("cy", 0)
      .attr("fill","white").attr("stroke","black")
      .attr("cursor","pointer");
  DEL_BTN
    .append("path")
      .attr("d", DEL_ICON)
      .attr("fill","none").attr("stroke","black")
      .attr("cursor","pointer");

  DEL_BTN
    .on("click", function(){
      if(window.confirm(params["message_conform_del_note"])){
        var note_formdata = new FormData();
        note_formdata.append("number",d["number"]);
        request_note(params['del_note'].replace(/(.*)0/,"$1" + d["number"]),note_formdata, "delete");
      }
    });
  function make_delete_btn(d,i){
    d3.select(this).select(".del_btn")
      .attr("display","inline");

  }
  function hide_delete_btn(d,i){
    d3.select(this).select(".del_btn")
      .attr("display","none");
  }
  NOTE_NODE
    .on("mouseover", make_delete_btn)
    .on("mouseout", hide_delete_btn)
}

function update_notes(data, svg){
  const NOTE = svg
    .selectAll("g.note")
    .data(data, function(d){ return d['number']})
  
  NOTE.exit().remove();
  
  NOTE
    .enter().append("g")
      .attr("class", "note")
      .attr("transform",function(d){return "translate(0,0)"})
    .each(create_note)
    .merge(NOTE)
    .transition()
    .duration(750)
    .attr("transform",function(d){return "translate(" + [d.x,d.y] + ")"})
}

