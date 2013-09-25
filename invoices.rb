require 'sqlite3'
require 'active_record'
require_relative 'mailer'

SQLite3::Database.new("invoices.db") unless File.exists?("invoices.db")

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'invoices.db'
)

unless ActiveRecord::Base.connection.table_exists?("invoices")
  ActiveRecord::Migration.create_table :invoices do |t|
    t.string   :vendor_name
    t.string   :mailing_address
    t.string   :payee_name
    t.string   :billed_to
    t.text     :description
    t.integer  :amount
    t.date     :sent_at
    t.date     :start_date, :end_date
    t.boolean  :paid, default: false
  end
end

class Invoice < ActiveRecord::Base

  def self.paid_invoices
    self.where(:paid => true)
  end

  def self.total_amount_earned
    self.all.map(&:amount).inject(:+)
  end

  def self.total_paid
    self.paid_invoices.map(&:amount).inject(:+) || 0
  end

  def self.balance_remaining
    self.total_amount_earned - self.total_paid
  end

  def self.invoice_methods
    self.methods - ActiveRecord::Base.methods - Object.methods
  end

end

puts "Welcome to your Invoice Checker, I hope you fired me up in a REPL"
