# The MIT License (MIT)

# Copyright (c) 2013 alisdair sullivan <alisdairsullivan@yahoo.ca>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


include_recipe "git"

Array(node['erlenv']['users']).each do |u|
  git_url = u['git_url'] || node['erlenv']['git_url']
  version = u['version'] || node['erlenv']['version']
  homedir = u['homedir'] || ::File.join(
    node['erlenv']['user_home'],
    u['user']
  )
  installdir = u['installdir'] || ::File.join(
    homedir,
    ".erlenv"
  )
  
  erlenv u['user'] do
    destination installdir
    git_url git_url
    version version
  end
  
end