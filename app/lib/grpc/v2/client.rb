require 'grpc/v2/services/tag_services_pb'

module Grpc::V2::Client
  def start
    hostname = 'localhost:50051'
    stub = ::Grpc::V2::TagPb::TagService::Stub.new(hostname, :this_channel_is_insecure)
    begin
      message = stub.get_tag_list(::Grpc::V2::TagPb::GetTagListRequest.new(name: "hahaha", state: 22))
      p "Greeting: #{message}"
      byebug
    rescue GRPC::BadStatus => e
      abort "ERROR: #{e.message}"
    end
  end

  module_function :start
end