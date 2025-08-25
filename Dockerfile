# https://swiftonserver.com/faster-github-actions-ci-for-swift-projects/
# ================================
# Build image
# ================================
FROM swift:6.0-noble AS build

WORKDIR /staging

# Copy entire repo into container
COPY . .

RUN ls -lah

RUN ls -lah "$(swift build -c release --show-bin-path)/HaTrmnlVapor"

RUN ls -lah .build

# Copy main executable to staging area
RUN cp "$(swift build -c release --show-bin-path)/HaTrmnlVapor" ./

# Copy static swift backtracer binary to staging area
RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" ./

# Copy resources bundled by SPM to staging area
RUN find -L "$(swift build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

# Copy any resources from the public directory and views directory if the directories exist
# Ensure that by default, neither the directory nor any of its contents are writable.
RUN [ -d ./Public ] && { chmod -R a-w ./Public; } || true
RUN [ -d ./Resources ] && { chmod -R a-w ./Resources; } || true
