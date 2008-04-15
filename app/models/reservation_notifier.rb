class ReservationNotifier < ActionMailer::Base

  def initialize_template_class_with_includes(assigns)
    template = initialize_template_class_without_includes(assigns)
    class << template
      include ReservationsHelper
    end
    template
  end
  alias_method_chain :initialize_template_class, :includes

  def approval_notification(reservation)
    setup_email(reservation)
    @recipients  = "#{reservation.user.email}"
    @subject    += "Your reservation beginning #{reservation.start_time.to_short_s} has been approved"
    @body[:url]  = "http://kcgs.isus.emc.com/lablog"
    @body[:reservation]  = reservation
  end
  
  def rejection_notification(reservation)
    setup_email(reservation)
    @recipients  = "#{reservation.user.email}"
    @subject    += "Your reservation beginning #{reservation.start_time.to_short_s} has been rejected"
    @body[:url]  = "http://kcgs.isus.emc.com/lablog"
    @body[:reservation]  = reservation
  end

  def approval_request(reservation)
    setup_email(reservation)
    @recipients  = reservation.lab.approvers.collect{|a| a.email}
    @subject    += "Please evaluate a request for reservation from #{reservation.user.login}"
    @body[:reservation]  = reservation
    @body[:url]  = "http://kcgs.isus.emc.com/lablog/"
    @body[:review_url]  = "#{@body[:url]}reservations/review/#{reservation.id}?approval_code=#{reservation.approval_code}"
  end
  
  protected
  def setup_email(reservation)
    @from        = "spiegel_aaron@emc.com"
    @subject     = "[KCLab Lablog] "
    @sent_on     = Time.now
    @body[:user] = reservation.user
  end
end
