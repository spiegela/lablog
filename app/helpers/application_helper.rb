# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  module ActionView
    module Helpers
      module UrlHelper
        def popup_javascript_function(popup)
          popup.is_a?(Array) ? "new Window({title: '#{popup.first}', url: this.href width:700, height:400}).showCenter();" : "new Window({url: this.href, width:700, height:400}).showCenter();"
        end
      end
    end
  end 
end
