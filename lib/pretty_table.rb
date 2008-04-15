class Object
  def opp(arr, fields=nil, options={})
    if arr.size > 0 and arr[0].is_a?ActiveRecord::Base
      fields ||= arr[0].class.content_columns.map(&:name)
    end
    puts arr.pretty_table(fields, options)
  end
end

class Array
  protected
    def pretty_table_row(fields, sizes, obj = nil, p_methods = {})
      ret = []
      fields.each_with_index do |field,i|
        p_method = p_methods[field] && obj && obj.send(field) ? p_methods[field] : "to_s"
        ret << sprintf("%0-#{sizes[i]}s", (obj ? obj.send(field).send(p_method) : field.to_s.humanize).to_s.first(sizes[i]) )
      end
      ret = '| ' + ret.join(' | ') + ' |'
    end

  public

    # usage:
    # @some_array.pretty_table([:id, :login, :email], { 
    #    :max_width => 5, 
    #    :line_spacer => '-', 
    #    :find => { :conditions => ['activated=?',true] } 
    #    :print_methods => { :<field> => "name" }
    #  })
    def pretty_table(fields=nil, options = {})
      fields ||= self.first.attributes.keys
      sizes = [0] * fields.size # set up a nice empty array

      # determine the longest string in each column
      self.each do |ar|
        fields.each_with_index do |f,i|
          p_method = options[:print_methods] && options[:print_methods][f] && ar.send(f) ? options[:print_methods][f] : "to_s"
          sizes[i] = [sizes[i], ar.send(f).send(p_method).size, f.to_s.size].max
          sizes[i] = [ options[:max_width].to_i, sizes[i] ].min if options[:max_width]
          sizes[i] = [ options[:max_width].to_i, sizes[i] ].min if options[:max_width]
        end
      end

      ret = []
      ret << header = pretty_table_row(fields, sizes)
      ret << header.gsub(/./, options[:line_spacer] || '=')

      self.each do |ar|
        opts = [fields, sizes, ar]
        opts << options[:print_methods] if options[:print_methods]
        ret << pretty_table_row(*opts)
      end
      ret.join("\n")
    end    
end

class ActiveRecord::Base
  class << self
    # usage:
    # User.pretty_table([:id, :login, :email], { 
    #    :max_width => 5, 
    #    :line_spacer => '-', 
    #    :find => { :conditions => ['activated=?',true] } 
    #  })
    # All args are optional

    def pretty_table(fields = nil, options = {})
      all = find(:all, options[:find])
      all.pretty_table(fields, options)
    end    
  end 
end
