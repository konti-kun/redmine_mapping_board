class QrcodesController < ApplicationController
  def index
    qrcodes_pdf = QrcodePdf.new.render
    send_data qrcodes_pdf,
      filename: 'qrcodes.pdf',
      type: 'application/pdf'
  end
end
