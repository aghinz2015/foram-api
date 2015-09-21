module MongoHelpers
  class MongoServer
    attr_reader :port, :job

    def initialize(port)
      @port = port
    end

    def start
      FileUtils.mkpath dbpath
      @job = fork do
        exec `mongod --dbpath #{dbpath} --pidfilepath #{pidfilepath} --port #{port}`
      end
      Process.detach(job)
    end

    def stop
      Process.kill("SIGKILL", pid)
      Process.kill("SIGKILL", job)
      cleanup
    end

    private

    def pid
      File.read(pidfilepath).to_i
    end

    def dbpath
      @dbpath ||= "tmp/db_#{port}"
    end

    def pidfilepath
      @pidfilepath ||= "tmp/pids/mongo_test_#{port}.pid"
    end

    def cleanup
      FileUtils.rm_rf(dbpath) rescue nil
      FileUtils.rm(pidfilepath) rescue nil
    end
  end

  def start_mongo_server(port)
    server = MongoServer.new(port)
    server.start
    server
  end
end
