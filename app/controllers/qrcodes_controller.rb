class QrcodesController < ApplicationController
  def index
    qrcodes_pdf = QrcodePdf.new.render
    send_data qrcodes_pdf,
      filename: 'test.pdf',
      type: 'application/pdf',
      disposition: 'inline'
  end
end
