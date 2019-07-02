module MappingissuesHelper
  include ApplicationHelper

  def mapping_issue_flg(mappingboard_id, issue)
    if Note.exists?(mappingboard_id: mappingboard_id, issue_id: issue.id)
      tag = "<td><span style='margin-left:15px;' class='icon icon-checked'></span>"
    else
      tag = "<td class='checkbox hide-when-print'>"
      tag += check_box_tag("ids[#{mappingboard_id}][]", issue.id, false, :id => "issue_#{mappingboard_id}_#{issue.id}")
    end
    tag += "</td>"
    tag.html_safe
  end
end
