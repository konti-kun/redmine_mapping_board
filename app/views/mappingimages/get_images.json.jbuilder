json.array!(@images) do |image|
    json.url download_named_attachment_path(image, image.filename)
end
