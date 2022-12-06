class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price, :merchant_id

  belongs_to :merchant

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
end
