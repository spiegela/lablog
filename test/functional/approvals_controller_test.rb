require File.dirname(__FILE__) + '/../test_helper'
require 'approvals_controller'

# Re-raise errors caught by the controller.
class ApprovalsController; def rescue_action(e) raise e end; end

class ApprovalsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ApprovalsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
