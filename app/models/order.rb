class Order < ApplicationRecord
  self.inheritance_column = nil
  validates :type, inclusion: { in: %w(buy sell), message: "invalid order type: %{value}" }
  validates :quantity, comparison: { greater_than: 0 }
end
