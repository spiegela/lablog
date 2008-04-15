module Vanderbrew
  module Helpers
    module JavaScriptHelper

      ##
      # Helper to make it easier to embed anonymous JavaScript functions in RJS templates
      #
      #  anonymous_javascript_function :parameters => ['foo', 'bar'], :body => 'return true;'
      #    => function(foo,bar){return true;}
      #
      #  anonymous_javascript_function :parameters => 'win', :body => [ %[alert('foo')], 'return true' ]
      #    => function(win){alert('foo');return true}
      #
      # Intended for usage where you're passing arguments to page.call and "to_json" will get called on each one.
      #
      def anonymous_javascript_function(options = {})
        javascript_function '', options
      end

      ##
      # Helper to make it easier to embed JavaScript functions in RJS templates
      #
      #  anonymous_javascript_function 'foo', :parameters => win, :body => 'return true;'
      #    => foo = function(win){return true;}
      #
      #  anonymous_javascript_function 'foobar', :parameters => ['foo', 'bar'], :body => [ %[$(foo) = bar], 'return true;]'
      #    => foobar = function(foo,bar){$(foo) = bar;return true;}
      #
      # Intended for usage where you're passing arguments to page.call and "to_json" will get called on each one.
      #
      def javascript_function(name = '', options = {})
        Vanderbrew::JavaScriptFunction.new name, options
      end

    end
  end
end
  