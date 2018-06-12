class LedgerHeadingSerializer < ActiveModel::Serializer
  attributes :id, :name, :revenue, :asset, :display_name, :transaction_type
end
