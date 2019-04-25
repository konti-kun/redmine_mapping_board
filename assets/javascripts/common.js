function create_del_btn(selector,url,message,request_func){
  const rect = selector.node().getBBox();
  const DEL_BTN = selector
    .append("g")
      .attr("transform", "translate(" + [ rect.width,0 ] + ")")
      .attr("class","del_btn")
      .attr("display","none");
  const DEL_ICON = "M 0 0 m -3 -3 l 6 6 m 0 -6 l -6 6"
  DEL_BTN
    .append("circle")
      .attr("r",7).attr("cx", 0).attr("cy", 0)
      .attr("fill","white").attr("stroke","black")
      .attr("cursor","pointer");
  DEL_BTN
    .append("path")
      .attr("d", DEL_ICON)
      .attr("fill","none").attr("stroke","black")
      .attr("cursor","pointer");

  DEL_BTN
    .on("click", function(d){
      if(window.confirm(message)){
        request_func(url + "/" + d["id"], null, "delete");
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
  selector
    .on("mouseover", make_delete_btn)
    .on("mouseout", hide_delete_btn)

}
