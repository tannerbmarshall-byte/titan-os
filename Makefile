.PHONY: test audit validate-package-list doctor configure build clean metadata validate-release validate-iso

LIVE_BUILD_DIR := build/live-build

test: validate-package-list
	@tests/shell/test-zram-files.sh
	@tests/shell/test-user-tools.sh
	@tests/shell/test-live-build-config.sh
	@tests/shell/test-desktop-config.sh

audit:
	@scripts/audit-mvp.sh

validate-package-list:
	@scripts/validate-package-list.sh

doctor:
	@scripts/doctor.sh

configure:
	@cd $(LIVE_BUILD_DIR) && ./auto/config

build: test configure
	@cd $(LIVE_BUILD_DIR) && ./auto/build

clean:
	@cd $(LIVE_BUILD_DIR) && ./auto/clean

metadata:
	@scripts/record-build-metadata.sh

validate-release:
	@scripts/validate-release.sh $(ISO) $(CHECKSUM)

validate-iso:
	@scripts/validate-iso.sh $(ISO) $(CHECKSUM)
