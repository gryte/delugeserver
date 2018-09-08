desc 'Define default task'
task default: [:cookstyle, :foodcritic, :berksupdate, :kitchentest, :berksupload]

desc 'Run cookstyle'
task :cookstyle do
  sh 'cookstyle'
end

desc 'Run foodcritic in current directory'
task :foodcritic do
  # ignore databag helper rule: http://www.foodcritic.io/#FC086
  # it is not clear how to perform this work outside of the .erb file
  sh 'foodcritic . --tags ~FC086'
end

desc 'Run berks update in current directory'
task :berksupdate do
  sh 'berks update'
end

desc 'Run kitchen test in current directory'
task :kitchentest do
  sh 'kitchen test'
end

desc 'Berks upload deluge cookbook'
task :berksupload do
  sh 'berks upload'
end

desc 'Delete testserver node'
task :deletenode_test do
  sh 'knife node delete testserver -y'
end

desc 'Delete testserver client'
task :deleteclient_test do
  sh 'knife client delete testserver -y'
end

desc 'Remove testserver from chef server'
task remove_test: [:deletenode_test, :deleteclient_test]

desc 'Bootstrap test server'
task bootstrap_test: [:berksupload, :remove_test] do
  sh 'knife bootstrap 192.168.1.234 -E test -N testserver -r role[base_role],role[delugeserver_role] --sudo --ssh-user test --ssh-password test --use-sudo-password --bootstrap-version 14.4.56 --bootstrap-vault-item slack:webhooks'
end
