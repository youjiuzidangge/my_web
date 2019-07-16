# frozen_string_literal: true

module DailyPushers
  class ShanbeiPusher < Base
    BASE_URI        = 'https://api.tecchen.xyz/api/quote/'
    SERVER_CUTE_URI = 'https://sc.ftqq.com/SCU55413T7122f3389e198bfd04e58c3d742e6eb85d2d69863e45b.send'

    def call
      conn = Faraday.new
      conn.post do |req|
        req.url SERVER_CUTE_URI
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded; charset=utf-8'
        req.params['text'] = '每日鸡汤'
        req.params['desp'] = generate_markdown
      end
    end

    private
      def content
        #current_date = Time.zone.today.strftime('%Y-%m-%d')
        current_date="2019-06-30"
        url = "#{BASE_URI}/#{current_date}/"
        conn = Faraday.new
        resp = conn.get do |req|
          req.url url
        end

        res = JSON.parse(resp.body)
        
        {
          author: res['data']['author'],
          content: res['data']['content'],
          translation: res['data']['translation'],
          share_img: res['data']['trackObject']['share_url'],
          origin_img: res['data']['originImgUrls'].last.split('?')[0]
        }
      end

      def generate_markdown
        <<-EOF.strip_heredoc
          > #{content[:content]}

          > #{content[:translation]}

          >  --#{content[:author]}

          ![markdown](#{content[:origin_img]})
        EOF
      end
  end
end