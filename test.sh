#!/bin/bash -e
cd "$(dirname "$0")"

echo "TEST: mopm-bash update"

rm -rf ~/.mopm-bash
./mopm-bash update
find ~/.mopm-bash/repos/github.com/basd4g/mopm-bash/test.sh

$( cd ~/.mopm-bash/repos/github.com/basd4g/mopm-bash && git reset --hard bc1d70 > /dev/null 2>&1 )
# bc1d70 ... initial commit
! find ~/.mopm-bash/repos/github.com/basd4g/mopm-bash/test.sh
./mopm-bash update
find ~/.mopm-bash/repos/github.com/basd4g/mopm-bash/test.sh



echo "TEST: mopm-bash lint"

test -z "`./mopm-bash lint mopm-bash-test-a`" # 'a' will be passed (put nothing)
test -z "`./mopm-bash lint mopm-bash-test-common`" # 'a' will be passed (put nothing)

diff - <(./mopm-bash lint mopm-bash-test-failed 2>&1 ) << 'EOF'
The line 'mopm-url' is not found or invalid..
The line 'mopm-description' is not found
The line 'mopm-dependencies' is not found or invalid..
The line 'mopm-verification' is not found

EOF

diff - <(./mopm-bash lint mopm-bash-test-not-found 2>&1) << 'EOF'
The package 'mopm-bash-test-not-found' is not found
EOF



echo "TEST: mopm-bash search"

! ./mopm-bash search mopm-bash-test-not-found > /dev/null 2>&1

diff - <(./mopm-bash search mopm-bash-test-not-found 2>&1) << 'EOF'
The package 'mopm-bash-test-not-found' is not found
EOF

./mopm-bash search mopm-bash-test-a > /dev/null

diff - <(./mopm-bash search mopm-bash-test-a) << 'EOF'
# mopm-url: https://github.com/basd4g/mopm-bash
# mopm-description: A installation testing package for mopm-bash
# mopm-dependencies: mopm-bash-test-b, mopm-bash-test-c, mopm-bash-test-d
# mopm-verification: find /tmp/mopm-defs-test/a-is-installed
EOF



echo "TEST: mopm-bash dependencies"

diff - <( ./mopm-bash dependencies mopm-bash-test-a ) << 'EOF'
mopm-bash-test-b
mopm-bash-test-c
mopm-bash-test-d
EOF

diff - <( ./mopm-bash dependencies mopm-bash-test-f ) << 'EOF'
EOF

diff - <(./mopm-bash dependencies mopm-bash-test-not-found 2>&1) << 'EOF'
The package 'mopm-bash-test-not-found' is not found
EOF



echo "TEST: mopm-bash all-dependencies"

diff - <( ./mopm-bash all-dependencies mopm-bash-test-a ) << 'EOF'
mopm-bash-test-d
mopm-bash-test-g
mopm-bash-test-e
mopm-bash-test-c
mopm-bash-test-f
mopm-bash-test-b
mopm-bash-test-a
EOF

diff - <( ./mopm-bash all-dependencies mopm-bash-test-f ) << 'EOF'
mopm-bash-test-f
EOF

diff - <(./mopm-bash all-dependencies mopm-bash-test-not-found 2>&1) << 'EOF'
The package 'mopm-bash-test-not-found' is not found
EOF



echo "TEST: mopm-bash verify"

rm -f /tmp/mopm-defs-test/a-is-installed
diff - <( ./mopm-bash verify mopm-bash-test-a ) << 'EOF'
false
EOF
./mopm-bash install mopm-bash-test-a
diff - <( ./mopm-bash verify mopm-bash-test-a ) << 'EOF'
true
EOF

diff - <(./mopm-bash verify mopm-bash-test-not-found 2>&1) << 'EOF'
The package 'mopm-bash-test-not-found' is not found
EOF



echo "TEST: mopm-bash install"

rm -rf /tmp/mopm-defs-test
./mopm-bash install mopm-bash-test-a
find /tmp/mopm-defs-test/a-is-installed

diff - <(./mopm-bash install mopm-bash-test-not-found 2>&1) << 'EOF'
The package 'mopm-bash-test-not-found' is not found
EOF



echo "TEST: Passed all test cases!!"
