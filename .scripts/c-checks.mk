# Each C tool keeps its own sources, flags and test entry point.
.PHONY: analyze sanitize coverage

analyze:
	cppcheck --std=c11 --enable=warning,performance,portability --error-exitcode=1 \
		$(CPPFLAGS) src tests

sanitize:
	UBSAN_OPTIONS=halt_on_error=1 $(MAKE) test \
		CFLAGS="$(CFLAGS) -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer"

coverage:
	rm -f ./*.gcda ./*.gcno
	$(MAKE) build test CFLAGS="$(CFLAGS) -O0 -g --coverage"
	gcovr --root . --filter 'src/' --txt --print-summary
