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
  d3.select("#ajax-indicator").style("display","block");
  d3.json(url)
  .header('X-CSRF-Token', token)
  .send(method,formdata,function(data){
    const notes = d3.select(".svg_panel").select(".notes");
    update_notes(data,notes);
    update_lines(params['lines_link']);
  })
}

function create_note(d){
  const NOTE_WIDTH = 110;
  const NOTE_HEIGHT= 80;
  const DIV_STYLE = (NOTE_WIDTH-10) + "px;height:" + (NOTE_HEIGHT-10)+"px;";
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
      .attr("class", "note_div")

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

  BODY_DIV
    .append("div")
    .attr("class","note_div_background");

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
    .data(data, d => d['id'])
  
  NOTE.exit().remove();
  
  NOTE
    .enter().append("g")
      .attr("class", "note")
      .attr("id", d => "issue_" + d['issue_id'])
      .attr("transform",d => "translate(0,0)")
    .each(create_note)
    .merge(NOTE)
    .transition()
    .on("end", d => {d3.select("#ajax-indicator").style("display","none"); })
    .duration(750)
    .attr("transform",d => "translate(" + [d.x,d.y] + ")")
    .each(function(d){
      d3.select(this).select(".note_div_background")
      .classed("is_closed", d => d["issue"]["status"]["is_closed"])
    });
}

function update_lines(url){
  const token = d3.select('meta[name="csrf-token"]').attr('content');

  d3.json(url)
  .header('X-CSRF-Token', token)
  .get(data => {
    const NOTE_WIDTH = 110;
    const NOTE_HEIGHT= 80;
    const line_values = [];
    data.forEach(line => {
      from_value = d3.select("#issue_" + line.issue_from_id).data()
      to_value = d3.select("#issue_" + line.issue_to_id).data()
      if(from_value.length != 0 && to_value.length != 0){
        line_values.push([from_value[0], to_value[0]]);
      }
    });
    const lines = d3.select(".lines")
    .selectAll("path")
    .data(line_values, d => { return d[0].id +"_" + d[1].id});

    var line = d3.line()
    .x(d => d.x + NOTE_WIDTH/2)
    .y(d => d.y + NOTE_HEIGHT/2)

    lines.exit().remove();
    enter_lines = lines.enter()
    .append("path")
    .attr("stroke", "black")
    .attr("stroke-width", 3)
    .attr("stroke-opacity", 0.2)
    .merge(lines)
    .transition()
    .duration(750)
    .attr("d", line);

  });

}
