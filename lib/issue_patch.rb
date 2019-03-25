module IssuePatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable

      after_destroy :remove_note
    end

  end
  
  module ClassMethods
    
  end
  
  module InstanceMethods
    def remove_note
      Note.where(issue_id: self.id).destroy_all
    end
  end    
end

