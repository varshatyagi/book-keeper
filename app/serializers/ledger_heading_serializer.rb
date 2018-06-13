class LedgerHeadingSerializer < ActiveModel::Serializer
  attributes :id, :revenue, :asset, :display_name, :name, :transaction_type
end
