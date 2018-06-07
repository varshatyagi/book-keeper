class AddDisplayNameToLedgerHeadings < ActiveRecord::Migration[5.0]
  def change
    add_column :ledger_headings, :display_name, :string

    ledger_headings = LedgerHeading.all
    ledger_headings.each do | heading |
      heading.display_name = heading.name
      heading.name = heading.name.gsub(/( )/, '_').upcase
      heading.save
    end
  end

end
