#!/usr/bin/env bash

set -e

dump_path=$1
if [ -z "${dump_path}" ]; then
   echo "dump_path is required"
   exit 1
fi
pgpassword='p@ssw0rd'
db_dns=localhost

echo "clean db ${db_dns}, make sure siglusapi is down before restoring"
PGPASSWORD="${pgpassword}" psql -h "${db_dns}" -U postgres open_lmis -c "drop schema if exists auth cascade;drop schema if exists fulfillment cascade;drop schema if exists notification cascade;drop schema if exists referencedata cascade;drop schema if exists report cascade;drop schema if exists requisition cascade;drop schema if exists siglusintegration cascade;drop schema if exists stockmanagement cascade;drop schema if exists dashboard cascade;drop schema if exists datamigration cascade;drop schema if exists localmachine cascade;"
PGPASSWORD="${pgpassword}" psql -h "${db_dns}" -U postgres open_lmis -c "drop publication if exists dbz_publication;select pg_drop_replication_slot('debezium');" || echo "fail to drop debezium slot"

echo "restore open_lmis"
gunzip -c "${dump_path}" | PGPASSWORD="${pgpassword}" psql -h "${db_dns}" -U postgres open_lmis

echo "delete cdc_offset_backing"
PGPASSWORD="${pgpassword}" psql -h "${db_dns}" -U postgres open_lmis -c "drop publication if exists dbz_publication;DELETE FROM localmachine.cdc_offset_backing;" || echo "fail to reset publication and offset backing"

echo "reset password to 'password1'"
PGPASSWORD="${pgpassword}" psql -h "${db_dns}" -U postgres open_lmis -c "update auth.auth_users set password='\$2a\$10\$P3B2GMVoZ44ViizInjnXi.u53oYaq73By4JJ5/1rBhEshFOP2gN0S'

echo "restore done, need to clean cache"
