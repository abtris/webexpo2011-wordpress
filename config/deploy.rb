require 'railsless-deploy'
require 'capistrano/ext/multistage'

# GENERIC
set :user,     "vagrant"
set :runner,   "vagrant"
set :sudo,     false
#set :use_sudo, true
set :projects_dir,      "/srv/www"
set :ssh_options, {:forward_agent => true}
# ENV
set :stages, %w(production development)
set :default_stage,     "development"
# SCM
set :scm, :git
set :repository,  "git@github.com:abtris/webexpo2011-wordpress.git"
set :branch, "master"
set :scm_verbose, true
set :git_shallow_clone, 1


def relative_path(from_str, to_str)
  require 'pathname'
  Pathname.new(to_str).relative_path_from(Pathname.new(from_str)).to_s
end

namespace :deploy do
  desc "Relative symlinks for current/"
  task :symlink, :except => { :no_release => true } do
    if releases[-2] # not the first release
      previous_release_relative = relative_path(deploy_to,previous_release)
      on_rollback { run "rm -f #{current_path}; ln -s #{previous_release_relative} #{current_path}; true" }
    end
    latest_release_relative = relative_path(deploy_to,latest_release)
    run "rm -f #{current_path} && ln -s #{latest_release_relative} #{current_path}"
  end
end
