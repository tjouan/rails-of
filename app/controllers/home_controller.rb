class HomeController < ApplicationController
  skip_before_filter :authenticate!

  def index
    @user   = User.new
    @offers = OffersPresenter.new(Offer.visible.sorted)
  end
end
