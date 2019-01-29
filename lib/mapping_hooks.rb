module Mapping
  class Hooks < Redmine::Hook::ViewListener
    def view_issues_show_details_bottom(context={ })
      begin
        issue = context[:issue]

        begin
          note_number = Note.find_by(:issue => issue).number
        rescue => e
          note_number = ""
        end

        div = "<div class='splitcontent'><div class='splitcontentleft'>"
        div += "<div class='attribute'>"
        div += "<div class='label'><span>note id</span></div>"
        div += "<div class='value'>#{note_number}</div>"
        div += "</div>"
        div += "</div></div>"
        return div
      rescue => e
        return e
      end
    end
    def view_issues_form_details_bottom(context={ })
      begin
        issue = context[:issue]
        controller = context[:controller]
        params =  controller.params

        begin
          note_number = params[:note_id]
          if note_number.nil? then
            if issue.id.nil? then
              note_number = ""
            else
              note_number = Note.find_by(:issue => issue).number
            end
          end
        rescue => e
          note_number = ""
        end

        div = "<div class='attribute'>"
        div += "<div class='splitcontent'><div class='splitcontentleft'>"
        div += "<p><label for='issue_note_id'><span>note id</span></label>"
        div += "<input size='10' maxlength='10' type='text' name='issue_note_id' id='issue_note_id' value='#{note_number}'></input>"
        div += "</p></div></div>"
        div += "</div>"
        return div
      rescue => e
        return ""
      end
    end
    def controller_issues_edit_after_save(context={ })
        params = context[:params]
        issue = context[:issue]

        note_id = params[:issue_note_id].to_i

        note = Note.find_by(number: note_id)
        print note.issue
        note.issue = issue
        note.save
        print note.issue
    end

  end
end
