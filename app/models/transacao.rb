class Transacao < ApplicationRecord
  belongs_to :conta_bancaria

  validates :valor, presence: true, numericality: { greater_than: 0 }
  validates :descricao, presence: true
  validates :data, presence: true

  scope :recent, -> { order(data: :desc) }

  def formatted_date
    data.strftime('%d/%m/%Y')
  end
end
