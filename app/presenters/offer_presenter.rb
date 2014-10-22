class OfferPresenter
  extend Forwardable
  def_delegators :@offer, :name, :ref, :price, :quota

  def initialize(offer)
    @offer = offer
  end
end
