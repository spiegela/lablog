class ReservationsCartController < ApplicationController
  def new
    session[:cart].clear
    respond_to do |wants|
      wants.js  { render :update do |page|
        page['reservations_cart'].replace_html :partial => 'reservations_cart/cart' end }
      wants.html{ render :partial => 'reservations_cart/cart' }
    end
  end
  
  def add
    @asset = Asset.find params[:id]
    session[:cart] << @asset unless session[:cart].include? @asset
  end
  
  def destroy
    session[:cart].delete Usage.find(params[:id])
    respond_to do |wants|
      wants.html{ redirect_to(:controller => 'reservations', :action => 'index') }
      wants.js {render :update do |page| 
        page['reservations_cart'].replace_html :partial => 'reservations_cart/cart'
        page.visual_effect( :highlight, "reservations_cart" )
        end}
    end
  end
end
