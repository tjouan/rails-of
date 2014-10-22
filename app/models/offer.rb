class Offer < ActiveRecord::Base
  FREE_OFFER_DAY_COUNT  = 15
  ORDER_BY              = %w[bronze silver gold].freeze
  FEATURES              = {
    firstnames: {
      name:   'Scoring Prénom',
      bronze: true,
      silver: true,
      gold:   true
    },
    profile: {
      name:   'Scoring Profil',
      bronze: true,
      silver: true,
      gold:   true
    },
    geoscore: {
      name:   'Scoring Géographique',
      bronze: true,
      silver: true,
      gold:   true
    },
    opticible: {
      name:   'Optimisation Ciblage',
      bronze: true,
      silver: true,
      gold:   true
    },
    support_mail: {
      name:   'Support email',
      bronze: true,
      silver: true,
      gold:   true
    },
    support_chat: {
      name:   'Support chat',
      bronze: false,
      silver: true,
      gold:   true
    },
    support_phone: {
      name:   'Formation téléphonique 1H',
      bronze: false,
      silver: true,
      gold:   true
    }
  }.freeze

  class << self
    def free_offer
      find_by_ref 'free'
    end

    def order_by_case
      ORDER_BY.each_with_object('CASE').with_index do |(e, m), i|
        m << " WHEN ref = '#{e}' THEN #{i}"
      end << ' END'
    end
  end

  scope :visible, -> { where visible: true }

  scope :sorted, -> { order order_by_case }


  def to_s
    '%s %s' % [ref, price ? '(%.2f)' % price : nil]
  end

  def description
    'Offre %s' % name
  end
end
