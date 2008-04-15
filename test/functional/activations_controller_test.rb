require File.dirname(__FILE__) + '/../test_helper'
require 'logins_controller'

# Re-raise errors caught by the controller.
class LoginsController; def rescue_action(e) raise e end; end

class LoginsControllerTest < Test::Unit::TestCase
  def setup
    @controller = LoginsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
