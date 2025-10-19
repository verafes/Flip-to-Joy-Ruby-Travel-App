module TripsHelper
  def cloudinary_image(public_id, width:, height:, crop: 'fit')
    "https://res.cloudinary.com/dmamyuv0u/image/upload/c_#{crop},w_#{width},h_#{height}/#{public_id}.jpg"
  end
  
  def extract_public_id(image_url)
    image_url.split('/upload/').last.split('.').first
  end
end
