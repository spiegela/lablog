require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class JavascriptFunctionTest < Test::Unit::TestCase

  include Vanderbrew::Helpers::JavaScriptHelper

  def test_default_create
    f = Vanderbrew::JavaScriptFunction.new
    assert_equal 'function(){return false;}', f.to_json
    assert_equal 'function(){return false;}', f.to_s
  end
  
  def test_basic_create
    f = Vanderbrew::JavaScriptFunction.new('foo')
    assert_equal 'foo = function(){return false;}', f.to_json
  end

  def test_basic_create_with_parameters
    f = Vanderbrew::JavaScriptFunction.new('foo', :parameters => ['a', 'b', 'c'])
    assert_equal 'foo = function(a,b,c){return false;}', f.to_json
  end

  def test_basic_create_with_body
    f = Vanderbrew::JavaScriptFunction.new('foo', :body => 'return true;')
    assert_equal 'foo = function(){return true;}', f.to_json
  end

  def test_basic_create_with_parameters_and_body
    f = Vanderbrew::JavaScriptFunction.new('foo', :parameters => ['a', 'b', 'c'], :body => 'return true;')
    assert_equal 'foo = function(a,b,c){return true;}', f.to_json
  end
  
  def test_anonymous_create_with_parameters
    f = Vanderbrew::JavaScriptFunction.new('', :parameters => ['bar', 'baz'])
    assert_equal %[function(bar,baz){return false;}], f.to_json
  end

  def test_anonymous_create_with_body
    f = Vanderbrew::JavaScriptFunction.new('', :body => %{alert('foo');})
    assert_equal %[function(){alert('foo');}], f.to_json
  end

  def test_anonymous_create_with_parameters_and_body
    f = Vanderbrew::JavaScriptFunction.new('', :parameters => ['foobar', 'foobaz'], :body => %{alert('foobar: ' + foobar + ' && 'foobaz: ' + foobaz);})
    assert_equal %[function(foobar,foobaz){alert('foobar: ' + foobar + ' && 'foobaz: ' + foobaz);}], f.to_json
  end


  def test_anonymous_create_with_array_body
    f = Vanderbrew::JavaScriptFunction.new('', :body => [ %{alert('foo')}, 'return true'])
    assert_equal %[function(){alert('foo');return true}], f.to_json
  end
  
  def test_anonymous_create_with_single_parameter_and_body
    f = Vanderbrew::JavaScriptFunction.new('', :body => %{alert('foo')}, :parameters => 'baz')
    assert_equal %[function(baz){alert('foo')}], f.to_json
  end
  
  def test_default_create_with_helper
    f = javascript_function
    assert_equal 'function(){return false;}', f.to_json
  end
  
  def test_default_create_with_anonymous_helper
    f = anonymous_javascript_function
    assert_equal 'function(){return false;}', f.to_json
  end
  
  def test_helper_create
    f = javascript_function 'foo'
    assert_equal 'foo = function(){return false;}', f.to_json
  end

  def test_helper_create_with_body
    f = javascript_function 'foo', :body => %[$('foobar') = true;]
    assert_equal %[foo = function(){$('foobar') = true;}], f.to_json
  end

  def test_helper_create_with_body_and_parameters
    f = javascript_function 'foo', :parameters => ['bar', 'baz'], :body => %[$('foobar') = baz;]
    assert_equal %[foo = function(bar,baz){$('foobar') = baz;}], f.to_json
  end

  def test_anonymous_helper_create_with_body
    f = anonymous_javascript_function :body => %[$('foobar') = true;]
    assert_equal %[function(){$('foobar') = true;}], f.to_json
  end

  def test_anonymous_helper_create_with_body_and_parameters
    f = anonymous_javascript_function :parameters => ['bar', 'baz'], :body => %[$('foobar') = baz;]
    assert_equal %[function(bar,baz){$('foobar') = baz;}], f.to_json
  end
  
  def test_helper_create_with_array_body
    f = javascript_function 'foo', :body => [ %[$('foobar') = true], 'return true']
    assert_equal %[foo = function(){$('foobar') = true;return true}], f.to_json
  end

  def test_anonymous_helper_create_with_array_body
    f = anonymous_javascript_function :body => [ %[$('foobar') = true], 'return true']
    assert_equal %[function(){$('foobar') = true;return true}], f.to_json
  end
  
  def test_helper_create_with_single_parameter_and_body
    f = javascript_function 'bar', :parameters => 'elm', :body => %[alert('foo')]
    assert_equal %[bar = function(elm){alert('foo')}], f.to_json
  end
  
  def test_helper_create_with_single_parameter_and_array_body
    f = javascript_function 'bar', :parameters => 'elm', :body => [ %[$(elm) = 'foo'], %[alert('bar')], 'return true']
    assert_equal %[bar = function(elm){$(elm) = 'foo';alert('bar');return true}], f.to_json
  end
  
  def test_anonymous_helper_create_with_single_parameter_and_body
    f = anonymous_javascript_function :parameters => 'elm', :body => %[alert('foo')]
    assert_equal %[function(elm){alert('foo')}], f.to_json
  end
  
  def test_anonymous_helper_create_with_single_parameter_and_array_body
    f = anonymous_javascript_function :parameters => 'elm', :body => [ %[$(elm) = 'foo'], %[alert('bar')], 'return true']
    assert_equal %[function(elm){$(elm) = 'foo';alert('bar');return true}], f.to_json
  end

end
