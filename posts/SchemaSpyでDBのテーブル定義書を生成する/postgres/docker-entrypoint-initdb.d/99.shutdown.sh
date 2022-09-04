#!/bin/bash

nohup bash -c "sleep ${WAIT_FOR_SCHEMASPY}; pg_ctl stop -D ${PGDATA};" &
