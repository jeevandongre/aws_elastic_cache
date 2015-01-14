require 'rubygems'
require 'trollop'
require 'parseconfig'
require 'aws-sdk-core'

config = ParseConfig.new('/path/to/config')
c1 = config['default']['aws_access_key_id']
c2 = config['default']['aws_secret_access_key']
c3 = config['default']['region']


opts = Trollop::options do
  opt :cache_cluster_id,"name of the cluster", :type => :string		#default nil, required true "Set the name of the cache cluster"            
  opt :num_cache_nodes, "number of nodes", :default => 1            	#set the number of cache nodes, default is 1
  opt :cache_node_type,"node type", :type => :string			#set the node type eg cache.t1.micro
  opt :engine, "engine type",:type => :string				#set the engine type redis/memcached
  opt :port, "port number", :type => :string				#set the port number
end

aws = Aws::ElastiCache::Client.new(access_key_id: c1, secret_access_key: c2,region: c3)
aws.create_cache_cluster({:cache_cluster_id => opts[:cache_cluster_id],:num_cache_nodes => opts[:num_cache_nodes],
:cache_node_type => opts[:cache_node_type],:engine =>opts[:engine],:port => opts[:port]})


