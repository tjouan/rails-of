class OfferPresenter
  extend Forwardable
  def_delegators :@offer, :description, :name, :price

  def initialize(offer)
    @offer = offer
  end
end
