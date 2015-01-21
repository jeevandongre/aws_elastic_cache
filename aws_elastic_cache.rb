require 'rubygems'
require 'trollop'
require 'parseconfig'
require 'aws-sdk-core'

config = ParseConfig.new('/path/to/config/file')
c1 = config['default']['aws_access_key_id']
c2 = config['default']['aws_secret_access_key']
c3 = config['default']['region']

def create_cache_cluster(aws,opts)
	cache_cluster_create = aws.create_cache_cluster({:cache_cluster_id => opts[:cache_cluster_id],:num_cache_nodes => opts[:num_cache_nodes],
	:cache_node_type => opts[:cache_node_type],:engine =>opts[:engine],:port => opts[:port]})
puts "#{cache_cluster_create}"

end

def delete_cache_cluster(aws,opts)
cache_cluster_delete = aws.delete_cache_cluster({cache_cluster_id => opts[:cache_cluster_id],:final_snapshot_identifier => opts[:final_snapshot_identifier]})
puts "#{cache_cluster_delete}"
end

opts = Trollop::options do
	opt :cache_cluster,"create or delete",:type => :string #create or delete cache cluster
  opt :cache_cluster_id,"name of the cluster", :type => :string		#default nil, required true "Set the name of the cache cluster"            
  opt :num_cache_nodes, "number of nodes", :type => :string          	#set the number of cache nodes, default is 1
  opt :cache_node_type,"node type", :type => :string			#set the node type eg cache.t1.micro
  opt :engine, "engine type",:type => :string				#set the engine type redis/memcached
  opt :port, "port number", :type => :string				#set the port number
  opt :final_snapshot_identifier, "final snapshot name", :type => :string  
end

aws = Aws::ElastiCache::Client.new(access_key_id: c1, secret_access_key: c2,region: c3)

if opts[:cache_cluster].to_s == "create"
	create_cache_cluster(aws,opts)
else
	puts "invalid enter. Either create or delete cache cluster"

end

if opts[:cache_cluster].to_s == "delete"
	delete_cache_cluster(aws,opts)
else 
	puts "invalid enter. Either create or delete cache cluster"
end

p opts

