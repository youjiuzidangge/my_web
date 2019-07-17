# frozen_string_literal: true

module DailyPushers
  class ShanbeiPusher < Base
    BASE_URI = 'https://api.tecchen.xyz/api/quote/'

    def call
      push_to_wechat('每日鸡汤', generate_markdown)
    end

    private
      def content
        current_date = Time.zone.today.strftime('%Y-%m-%d')
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
        push_content = content
        <<-EOF.strip_heredoc
          > #{push_content[:content]}

          > #{push_content[:translation]}

          >  --#{push_content[:author]}

          ![markdown](#{push_content[:origin_img]})
        EOF
      end
  end
end