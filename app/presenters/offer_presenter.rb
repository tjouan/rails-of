class OfferPresenter
  extend Forwardable
  def_delegators :@offer, :name, :ref, :price

  def initialize(offer)
    @offer = offer
  end
end
