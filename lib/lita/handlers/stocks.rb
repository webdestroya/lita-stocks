require "lita"
require "cgi"

module Lita
  module Handlers
    class Stocks < Handler
      route %r{^stock ([\w .-_]+)$}i, :stock_info, command: true, help: {
        "stock <symbol>" => "Returns stock price information about the provided stock symbol."
      }



      def stock_info(response)
        symbol = response.matches[0][0]
        data = get_stock_data(symbol)

        response.reply format_response(data)

      rescue Exception => e
        Lita.logger.error("Stock information error: #{e.message}")
        response.reply "Sorry, but there was a problem retrieving stock information."
      end

      private 


      def get_stock_data(symbol)
        resp = http.get("https://www.google.com/finance/info?infotype=infoquoteall&q=#{symbol}")
        raise 'RequestFail' unless resp.status == 200
        body = resp.body.gsub(/\/\//, '')

        # Google sends hex encoded data, we need to fix that
        (33..47).each do |char|
          body.gsub!(/\\x#{char.to_s(16)}/, char.chr)
        end
        MultiJson.load(body)[0]
      end

      def format_response(data)
        line = []
        line << "#{data['name']} (#{data['e']}:#{data['t']})"
        line << "#{data['l']} (#{data['c']}, #{data['cp']}%)"
        line << "52week high/low: (#{data['hi52']}/#{data['lo52']})"

        # don't include these sections if they don't exist
        line << "MktCap: #{data['mc']}" unless data['mc'].empty?
        line << "P/E: #{data['pe']}" unless data['pe'].empty?

        line.join ' - '
      end


    end

    Lita.register_handler(Stocks)
  end
end
