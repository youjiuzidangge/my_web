require 'grpc'
require 'grpc/v1/tag_services_pb'

# GreeterServer is simple server that implements the Helloworld Greeter server.
class Grpc::Main < V1::TagPb::TagService::Service
  # say_hello implements the SayHello rpc method.
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
    ::V1::TagPb::GetTagListReply.new(list: list, pager: pager)
  end
end
#
# grpcurl -d '{"id": 1234, "tags": ["foo","bar"]}' \
#     -plaintext grpc.server.com:80 localhost:50051.Service/Method


# grpcurl -plaintext localhost:50051 list




