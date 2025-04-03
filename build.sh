HARBOR_GIT_BRANCH="v2.3.5"

# first step: clone harbor ARM code
git clone https://github.com/alanpeng/harbor-arm.git

# Replace dev-arm image tag
sed -i "s#dev-arm#${HARBOR_GIT_BRANCH}-arm#g" harbor-arm/Makefile

# execute build command：Download harbor source code
cd harbor-arm
git clone --branch ${HARBOR_GIT_BRANCH} https://github.com/goharbor/harbor.git src/github.com/goharbor/harbor

# 替换 harbor make
# cp -f ../harbor/Makefile src/github.com/goharbor/harbor/
# 替换photon make
# 替换 base image
cp -f ../harbor/make/photon/db/Dockerfile.base src/github.com/goharbor/harbor/make/photon/db/
cp -f ../harbor/make/photon/nginx/Dockerfile.base src/github.com/goharbor/harbor/make/photon/nginx/
cp -f ../harbor/make/photon/portal/Dockerfile.base src/github.com/goharbor/harbor/make/photon/portal/
cp -f ../harbor/make/photon/portal/Dockerfile src/github.com/goharbor/harbor/make/photon/portal/

# 替换 photon
# cp -f ../harbor/make/photon/Makefile src/github.com/goharbor/harbor/make/photon/
# cp -f ../harbor/make/photon/registry/builder src/github.com/goharbor/harbor/make/photon/registry/
# cp -f ../harbor/src/portal/src/app/shared/components/about-dialog/about-dialog.component.html src/github.com/goharbor/harbor/src/portal/src/app/shared/components/about-dialog/

# compile redis
# make compile_redis

# Prepare to build arm architecture image data:
make prepare_arm_data

# Replace build arm image parameters：
make pre_update

# Compile harbor components:
make compile COMPILETAG=compile_golangimage

# Build harbor arm image:
make build GOBUILDTAGS="include_oss include_gcs" BUILDBIN=true TRIVYFLAG=true GEN_TLS=true PULL_BASE_FROM_DOCKERHUB=false