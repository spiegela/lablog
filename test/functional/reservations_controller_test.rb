require File.dirname(__FILE__) + '/../test_helper'
require 'reservations_controller'

# Re-raise errors caught by the controller.
class ReservationsController; def rescue_action(e) raise e end; end

class ReservationsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ReservationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
