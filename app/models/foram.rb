class Foram
  include Mongoid::Document

  field :kx,   type: Float
  field :ky,   type: Float
  field :kz,   type: Float
  field :tf,   type: Float
  field :phi,  type: Float
  field :beta, type: Float

  validates :kx, :ky, :kz, :tf, :phi, :beta, presence: true
end
