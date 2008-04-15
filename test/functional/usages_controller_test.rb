require File.dirname(__FILE__) + '/../test_helper'
require 'usages_controller'

# Re-raise errors caught by the controller.
class UsagesController; def rescue_action(e) raise e end; end

class UsagesControllerTest < Test::Unit::TestCase
  def setup
    @controller = UsagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
