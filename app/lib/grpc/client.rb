require 'k1/tag_services_pb'

module Grpc::Client
  def start
    hostname = 'localhost:50051'
    stub = K1::TagPb::TagService::Stub.new(hostname, :this_channel_is_insecure)
    begin
      message = stub.get_tag_list(K1::TagPb::GetTagListRequest.new(name: "hahaha", state: 22))
      p "Greeting: #{message}"
      byebug
    rescue GRPC::BadStatus => e
      abort "ERROR: #{e.message}"
    end
  end

  module_function :start
end