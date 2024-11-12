class PendingOrder < ApplicationRecord
  self.inheritance_column = nil
  validates :type, inclusion: { in: %w(buy sell), message: "invalid order type: %{value}" }
  validates :quantity, comparison: { greater_than: 0 }
  validates :expires_at, comparison: { greater_than: Time.current }

  after_create :execute_if_possible

  def execute_if_possible
    ExecuteOrdersJob.perform_now(self)
  end
  
  def buy?
    type == "buy"
  end
end
