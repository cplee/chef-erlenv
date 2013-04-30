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


def whyrun_supported?
  true
end

action :create do  
  installdir = node['erlenv']['installdir'] || ::File.join(
    node['erlenv']['user_home'],
    new_resource.user,
    new_resource.destination
  )

  git_url = new_resource.git_url || node['erlenv']['git_url']
  version = new_resource.version || node['erlenv']['version']
  
  if ::File.directory? "#{installdir}/bin"
    Chef::Log.info "#{new_resource} already exists"
  else
    converge_by("Create erlenv") do
      git "erlenv" do
        repository git_url
        reference version
        destination installdir
        user new_resource.user
        group "admin"
        action :sync
      end

      if node['erlenv']['create_profiled']
        file "etc/profile.d/erlenv.sh" do
          owner new_resource.user
          group "admin"
          content <<-EOS
# prepend .erlenv/bin to path if it exists and init erlenv

if [ -d "#{installdir}/bin" ]; then
  export PATH="#{installdir}/bin:$PATH"
  eval "$(erlenv init -)"
fi
EOS
        end
      end
    end
  end
end

