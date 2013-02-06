#!/usr/bin/ruby

puts 'Installing the dotfiles'

path = File.expand_path('./', File.dirname(__FILE__))
bin_path = File.symlink?(path) ? File.readlink(path) : path
workbench_path = File.expand_path('./', bin_path)

Dir.chdir(workbench_path) do
  puts "  Working in #{Dir.pwd}"
  puts '  Pulling latest ...'
  puts "  #{`git pull`}"
  puts '  Updating submodules ...'
  puts "  #{`git submodule -q foreach git pull -q origin master`}"
end

Dir.chdir(workbench_path + '/rcs') do
  puts "  Working in #{Dir.pwd}"
  puts '  Creating symlinks ...'

  Dir.glob('*') do |item|
    `ln -sfh #{workbench_path}/rcs/#{item} ~/.#{item}`
  end
end

puts "  linking #{workbench_path}/vim to .vim"
`ln -sfh #{workbench_path}/vim ~/.vim`

puts "  linking #{workbench_path}/git_template to .git_template"
`ln -sfh #{workbench_path}/git_template ~/.git_template`

# regenerate vim help tags with pathogen :Helptags
puts '  Updating vim help tags'
`vim -c 'call pathogen#helptags()|qa' > /dev/null`

# make sure vim backup dir exists
puts `mkdir -p ~/.vim/tmp`

# change shell to zsh
puts `chsh -s /bin/zsh`

# # setting crontab
# `crontab #{workbench_path}/crontab`
# 
puts '  All done!'
