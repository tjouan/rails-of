class OffersPresenter
  extend Forwardable
  def_delegators :@offers, :any?, :each

  def initialize(offers)
    @offers = offers.map { |e| OfferPresenter.new(e) }
  end
end
