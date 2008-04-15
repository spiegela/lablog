class ReservationObserver < ActiveRecord::Observer
  def after_create(reservation)
    if reservation.auto_approvable

      auto_approval_str = <<-END_OF_STRING
This reservation has been automatically approved according
to programmatically defined rules.  If we are unable to
fulfill this reservation, a lab administrator will contact you.
      END_OF_STRING

      reservation.approval_status = "Automatically Approved"
      reservation.approvers_comments = auto_approval_str
      reservation.approved_at = Time.now
      reservation.save

      ReservationNotifier.deliver_approval_notification(reservation)
    else
      ReservationNotifier.deliver_approval_request(reservation)
    end
  end

  def after_save(reservation)
    if reservation.recently_approved? and not reservation.approval_status == "Automatically Approved"
      ReservationNotifier.deliver_approval_notification(reservation)
    elsif reservation.recently_rejected?
      ReservationNotifier.deliver_rejection_notification(reservation)
    end
  end
end
