require 'grpc/v2/services/tag_services_pb'

module Grpc
  module V2
    class Main < TagPb::TagService::Service
      def get_tag_list(tag_request, _unused_call)
        list = [{
                  id: 1,
                  name: tag_request.name,
                  state: 1
                }]
        pager = {
          page: 1,
          page_size: 2,
          total_rows: tag_request.state
        }
        TagPb::GetTagListReply.new(list: list, pager: pager)
      end
    end

    module Server
      # main starts an RpcServer that receives requests to GreeterServer at the sample
      # server port.
      def start
        s = GRPC::RpcServer.new
        s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
        s.handle(Grpc::V2::Main)
        # Runs the server with SIGHUP, SIGINT and SIGQUIT signal handlers to
        #   gracefully shutdown.
        # User could also choose to run server via call to run_till_terminated
        s.run_till_terminated
      end

      module_function :start

    end
  end
end

