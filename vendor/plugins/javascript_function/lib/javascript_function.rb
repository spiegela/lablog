module Vanderbrew  

  # Represents a JavaScript function that will be output in an RJS
  # template so that we can have an appropriate JSON conversion.
  #
  # Examples:
  #
  #  f = JavaScriptFunction.new "", :body => 'return true;'   # empty name means anonmymous function
  #  f.to_json  # function(){return true;}
  #
  #  f = JavaScriptFunction.new "foo", :parameters => ['bar','baz'], :body => %[$(bar).innerHTML = baz;]
  #  f.to_json  # foo = function(bar,baz){$(bar).innerHTML = baz;}
  #
  class JavaScriptFunction

    # Create a new JavaScriptFunction object
    def initialize(name = "", options = {})
      @name = name
      @options = options
      @body = @options.has_key?(:body) ? @options[:body] : nil
    end

    # Get a string representation of the function suitable for embedding in a JSON response
    def to_json
      result = ""
      if (!@name.nil? && @name != "")
        result << "#{@name} = "
      end
      result << "function(#{build_parameters})"
      result << "{#{build_body}}"
    end
    
    # Get a string representation of the function
    def to_s
      to_json
    end
    
    private
      def build_body
        if @body.nil?
          "return false;"
        elsif @body.is_a? Array
          @body.join(';')
        else
          @body
        end
      end
      
      def build_parameters
        if @options.has_key?(:parameters)
          parameters = @options[:parameters]
          if parameters.is_a? Array
            parameters.join(',')
          elsif parameters.is_a? String
            parameters
          else
            raise "Invalid parameter type #{parameters}"
          end
        end
      end
  end
end