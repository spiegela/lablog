  def details(reservation)
    <<-END_OF_STRING
      Reason for Reservation:  #{reservation.reason}
      Reservation Start :      #{reservation.start_time}
      Reservation End :        #{reservation.end_time}
      User Comments :          #{reservation.comment}
      Requesting User :        #{reservation.user.login}
      
      Asset Usages:
      #{ reservation.usages.pretty_table(
        [:asset, :version, :exclusive, :destructive, :active?, :at_version?, :no_prior_reservations?],
        :print_methods => {:asset => :to_label, :version => :to_label} }
  
    Notes:
      Active?                 indicates that the requested asset is listed as currently active
      At Version?             indicates that the requested asset is at the requested version
      No Prior Reservations?  indicates that no *destructive* reservations are curretnly scheduled
                                prior to the requested reservation
    END_OF_STRING
  end
