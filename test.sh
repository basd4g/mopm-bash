#!/bin/bash -e
cd "$(dirname "$0")"

echo "TEST: mopm-bash update"
rm -rf ~/.mopm-bash
./mopm-bash update
find ~/.mopm-bash/repos/github.com/basd4g/mopm-bash/test.sh
$(cd ~/.mopm-bash/repos/github.com/basd4g/mopm-bash && git reset --hard bc1d70) # initial commit
! find ~/.mopm-bash/repos/github.com/basd4g/mopm-bash/test.sh
./mopm-bash update
find ~/.mopm-bash/repos/github.com/basd4g/mopm-bash/test.s



echo "TEST: mopm-bash lint"

test -z "`./mopm-bash lint a`" # 'a' will be passed (put nothing)

diff - <(./mopm-bash lint mopm-bash-test-failed 2>&1 ) << 'EOF'
The line 'mopm-url' is not found or invalid..
The line 'mopm-description' is not found
The line 'mopm-dependencies' is not found or invalid..
The line 'mopm-verification' is not found

EOF



echo "TEST: mopm-bash search"

! ./mopm-bash search mopm-bash-test-not-found >dev/null 2>&1

diff - <(./mopm-bash search mopm-bash-test-not-found 2>&1) << 'EOF'
The package 'mopm-bash-test-not-found' is not found
EOF

./mopm-bash search mopm-bash-test-a >dev/null

diff - <(./mopm-bash search mopm-bash-test-a) << 'EOF'
# mopm-url: https://github.com/basd4g/mopm-bash
# mopm-description: A installation testing package for mopm-bash
# mopm-dependencies: mopm-bash-test-b, mopm-bash-test-c, mopm-bash-test-d
# mopm-verification: find /tmp/mopm-defs-test/a-is-installed
EOF

#./mopm-bash dependencies
#./mopm-bash all-dependencies
#./mopm-bash verify
#./mopm-bash install
