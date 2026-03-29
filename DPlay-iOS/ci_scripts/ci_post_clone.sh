#!/bin/bash
cat <<INNER > "$CI_PRIMARY_REPOSITORY_PATH/DPlay-iOS/DPlay-iOS/Config.xcconfig"
BASE_URL = $BASE_URL
INNER
