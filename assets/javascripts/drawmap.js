function set_size(selector, width, height){
  return selector.attr("width", width).attr("height", height);
}
function request_note(url, formdata, method="post"){
  var token = "";
  try{
    token = d3.select('meta[name="csrf-token"]').attr('content');
  }catch(e){
    token = "";
  }
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
  const NOTE_NODE = d3.select(this);

  NOTE_NODE.append("rect").call(set_size, NOTE_WIDTH, NOTE_HEIGHT)
  .attr("filter","url(#drop-shadow)");

  const NOTE_COLOR = d3.schemePastel1[d["issue"]["tracker_id"] % 10];
  NOTE_NODE
    .attr("cursor", "move")
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
      .style("float","left")
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
    note_formdata.append("id",d["id"]);
    note_formdata.append("x",d["x"])
    note_formdata.append("y",d["y"]);
    request_note(params['notes_link'] + "/" + d["id"] + "/update_pos" ,note_formdata);
  }
  NOTE_NODE.call(
    d3.drag()
      .on("drag",notedrag)
      .on("end",notedragend)
  );

  NOTE_NODE.call(
    create_del_btn, params["notes_link"], params["message_conform_del_note"], request_note
  );
}

function update_notes(data, svg){
  const NOTE = svg
    .selectAll("g.note")
    .data(data, function(d){ return d['id']})
  
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

