DOCKER_RUN=docker run -it --platform linux/amd64 --rm --mount type=bind,source=$(shell pwd),target=/usr/src/myapp -w /usr/src/myapp perl:5.34
ifeq ($(NO_DOCKER), 1)
	DOCKER_RUN=
endif

clean:
	$(DOCKER_RUN) rm -rf extlib
install:
	$(DOCKER_RUN) cpanm -L extlib Data::Dump
	$(DOCKER_RUN) cpanm -L extlib Data::Types
	$(DOCKER_RUN) cpanm -L extlib Text::CSV
	$(DOCKER_RUN) cpanm -L extlib Geo::Coder::Google::V3
	$(DOCKER_RUN) cpanm -L extlib LWP::Protocol::https
test:
	$(DOCKER_RUN) prove -rlv -Iextlib/lib/perl5 t
run:
	$(DOCKER_RUN) /usr/local/bin/perl -Ilib -Iextlib/lib/perl5 bin/search_airports.pl --token=$(shell cat .gapi_token) --filename ./t/data/airports1.csv $(ARGS)

