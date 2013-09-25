require 'pony'

def send_invoice(send_to, invoice)
  Pony.mail({
    :to => send_to,
    :via => :smtp,
    :via_options => {
      :address => 'smtp.gmail.com',
      :port    => '587',
      :enable_starttls_auto => true,
      :user_name => 'allareri',
      :password => 'erik6767',
      :authentication => :plain,
      :domain => "localhost.localdomain"
    },
    :subject => "Invoice - Erik Allar #{Date.today.strftime("%D")}",
    :body => setup_email_body(invoice)
  })
end

def setup_email_body(invoice)
  body =
   <<-THING

    Date of Invoice: #{Date.today.strftime("%D")}
    #{invoice.vendor_name}
    For the Period: #{invoice.start_date} - #{invoice.end_date}

    Description of Services Rendered:
        #{invoice.description}

    Amount: $#{invoice.amount}

    Please make check payable to "#{invoice.vendor_name}" and mail to:

      #{invoice.mailing_address}

  THING
end
