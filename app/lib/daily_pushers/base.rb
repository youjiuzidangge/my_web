module DailyPushers
  class Base
    SERVER_CUTE_URI = 'https://sc.ftqq.com/SCU55413T7122f3389e198bfd04e58c3d742e6eb85d2d69863e45b.send'

    def self.call(*args)
      new(*args).call
    end
    
    def call
      raise NotImplementedError
    end

    private
      def push_to_wechat(text, desp)
        conn = Faraday.new
        conn.post do |req|
          req.url SERVER_CUTE_URI
          req.headers['Content-Type'] = 'application/x-www-form-urlencoded; charset=utf-8'
          req.params['text'] = text
          req.params['desp'] = desp
        end
      end
  end
end