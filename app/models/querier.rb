require 'base64'
require 'json'
require 'net/https'
API_URL = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEYssss']}"

class Querier
    def self.query(image_url)
        base64_image = Base64.strict_encode64(File.new("public/"+image_url, 'rb').read)

        body = {
            requests: [{
                image: {
                content: base64_image
                },
                features: [
                {
                    type: 'LABEL_DETECTION',
                    maxResults: 3
                }
                ]
            }]
        }
        uri = URI.parse(API_URL)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request["Content-Type"] = "application/json"
        response = https.request(request, body.to_json)

        ret = nil

        if response.message == "OK"
            ret = response.body
        end

        return ret
    end
end