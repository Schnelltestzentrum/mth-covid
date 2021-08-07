require 'spreadsheet'
class CustomerSpreadsheet
  def initialize(customers, sign_url)
    @sign_url = sign_url
    @customers = customers
    @book = Spreadsheet::Workbook.new
    @sheet = @book.create_worksheet :name => 'customers'
    @file = 'public/template/customers.xls'
  end
  
  def genarate
    headings
    @customers.each_with_index do |customer, index|
      i = index + 1
      row = @sheet.row(i)
      row[0] = i
      row[1] = customer.name
      row[2] = customer.first_name
      row[3] = customer.dob
      row[4] = customer.address
      row[5] = customer.post
      row[6] = customer.phone
      row[7] = customer.email    
      row[8] = customer.test_result
      row[9] = customer.test_type
      row[10] = customer.test_date
      row[11] = customer.test_time
      row[12] = customer.test_day
      row[13] = customer.result_type
      row[14] = customer.test_id
      row[15] = customer.form_date
      row[16] = customer.test_by
      row[17] = customer.total_person
      row[18] = Spreadsheet::Link.new("#{@sign_url}?id=#{customer.id}&type=customer", 'Open')
      row[19] = Spreadsheet::Link.new("#{@sign_url}?id=#{customer.id}&type=user", 'Open')
    end
    column_width
    @book.write(@file)
    @file
  end

  def headings
    @format = Spreadsheet::Format.new pattern_fg_color: :yellow, pattern: 1,
                                 weight: :bold, size: 12, color: :blue
    row = @sheet.row(0)
    row[0] = 'Sl. No.'
    row[1] = 'Name'
    row[2] = 'Vorname'
    row[3] = 'Geb'
    row[4] = 'Straße / Hausnummer'
    row[5] = 'Postleitzahl / Ort'
    row[6] = 'Telefon'
    row[7] = 'Email addresse'    
    row[8] = 'Ergebnis des Tests'
    row[9] = 'Art der Leistung'
    row[10] = 'Testdatum'
    row[11] = 'Testzeit'
    row[12] = 'Testtag'
    row[13] = 'Mitteilungsweg'
    row[14] = 'Test-ID'
    row[15] = 'Formulardatum'
    row[16] = 'Testen von'
    row[17] = 'Gesamtperson'
    row[18] = 'Unterschrift des Kunden'
    row[19] = 'Angestelltenunterschrift'
    @sheet.row(0).default_format = @format
  end

  def column_width
    @sheet.column(0).width = 8
    @sheet.column(1).width = 30
    @sheet.column(2).width = 30
    @sheet.column(3).width = 10
    @sheet.column(4).width = 40
    (5..19).each do |i|
      @sheet.column(i).width = 30
    end
  end

end