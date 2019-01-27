class QrcodePdf < Prawn::Document
  def initialize
    super()

    for i in 0..224 do 
      qr = RQRCode::QRCode.new(i.to_s, size: 1, level: :l)
      png = StringIO.new(Base64.decode64(qr.to_img.to_data_url.split(',', 2).last))
      x_add = (i/25)*60
      image png, at: [5 + x_add, 730-30*(i%25)]
      draw_text i.to_s, at: [35 + x_add , 715-30*(i%25)]
    end
    
  end
end
