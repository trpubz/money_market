class Vendor < ApplicationRecord
  validates_presence_of :name, :description, :contact_name, :contact_phone
  validate :credit_accepted_must_be_boolean

  def credit_accepted_must_be_boolean
    unless [true, false].include?(credit_accepted)
      errors.add(:credit_accepted, "must be a boolean")
    end
  end

  has_many :market_vendors
  has_many :markets, through: :market_vendors
end
