# ==================================================================================
#       Copyright (c) 2019 Nokia
#       Copyright (c) 2018-2019 AT&T Intellectual Property.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#          http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
# ==================================================================================
FROM python:3.7

ADD . /tmp

# Install RMR
RUN apt-get update && apt-get install -y gcc git cmake
RUN git clone https://gerrit.oran-osc.org/r/ric-plt/lib/rmr
WORKDIR rmr
RUN git checkout a012cf63dfdad3656c995cb06c316fd208c63b98
RUN mkdir .build; cd .build; cmake ..; make install

# Install python-rmr
RUN pip install --upgrade pip

#install a1
WORKDIR /tmp

# Run our unit tests
RUN pip install tox
RUN tox

# do the actual install
RUN pip install .
EXPOSE 10000

# rmr setups
RUN mkdir -p /opt/route/
ENV LD_LIBRARY_PATH /usr/local/lib
ENV RMR_SEED_RT /opt/route/local.rt

CMD run.py