module Grpc::Server

  # main starts an RpcServer that receives requests to GreeterServer at the sample
  # server port.
  def start
    s = GRPC::RpcServer.new
    s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
    s.handle(Grpc::Main)
    # Runs the server with SIGHUP, SIGINT and SIGQUIT signal handlers to
    #   gracefully shutdown.
    # User could also choose to run server via call to run_till_terminated
    s.run_till_terminated
  end

  module_function :start

end