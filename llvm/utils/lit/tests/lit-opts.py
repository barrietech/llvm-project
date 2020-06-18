# Check cases where LIT_OPTS has no effect.
#
# RUN:                 %{lit} -j 1 -s %{inputs}/lit-opts | FileCheck %s
# RUN: env LIT_OPTS=   %{lit} -j 1 -s %{inputs}/lit-opts | FileCheck %s
# RUN: env LIT_OPTS=-s %{lit} -j 1 -s %{inputs}/lit-opts | FileCheck %s

# Check that LIT_OPTS can override command-line options.
#
# RUN: env LIT_OPTS=-a \
# RUN: %{lit} -j 1 -s %{inputs}/lit-opts \
# RUN: | FileCheck -check-prefix=SHOW-ALL -DVAR= %s

# Check that LIT_OPTS understands multiple options with arbitrary spacing.
#
# RUN: env LIT_OPTS='-a -v  -Dvar=foobar' \
# RUN: %{lit} -j 1 -s %{inputs}/lit-opts \
# RUN: | FileCheck -check-prefix=SHOW-ALL -DVAR=foobar %s

# Check that LIT_OPTS parses shell-like quotes and escapes.
#
# RUN: env LIT_OPTS='-a   -v -Dvar="foo bar"\ baz' \
# RUN: %{lit} -j 1 -s %{inputs}/lit-opts \
# RUN: | FileCheck -check-prefix=SHOW-ALL -DVAR="foo bar baz" %s

# CHECK:      Testing: 1 tests
# CHECK-NOT:  PASS
# CHECK:      Passed: 1

# SHOW-ALL:     Testing: 1 tests
# SHOW-ALL:     PASS: lit-opts :: test.txt (1 of 1)
# SHOW-ALL:     {{^}}[[VAR]]
# SHOW-ALL-NOT: PASS
# SHOW-ALL:     Passed: 1
