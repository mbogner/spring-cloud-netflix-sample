#!/bin/bash
#
# Copyright 2022 mbo.dev
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e
set -u

echo "adding uuid-ossp to database ${POSTGRES_DB}"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" "${POSTGRES_DB}" <<-EOSQL
	    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

function create_user_and_database() {
	local database=$1
	echo "  Creating user and database '$database' with uuid-ossp"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $POSTGRES_USER;
	    \c $database;
	    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
		create_user_and_database $db
	done
	echo "Multiple databases created"
fi
