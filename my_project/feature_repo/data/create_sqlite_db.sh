#!/usr/bin/env bash
set -u
cd "$(realpath "$(dirname "${0}")")" || exit

DBFILE='registry.db'

if [ -f ${DBFILE} ]; then
  echo "${DBFILE} exist, abort." && exit 1
  # rm -f registry.db
fi

echo "creating sqlite database file ${DBFILE}..."
sqlite3 "${DBFILE}" "VACUUM;"
sqlite3 "${DBFILE}" "SELECT 1;" > /dev/null 2>&1 || {
    echo "failed to access ${DBFILE}"
    exit 1
}

echo "creating an example table..."

rm -f create_sqlite_table.sql
cat > create_sqlite_table.sql << 'EOF'
BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price REAL NOT NULL CHECK(price > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (name, price) VALUES
    ('Laptop', 999.99),
    ('Mouse', 29.99),
    ('Keyboard', 79.99);

-- Validate data
SELECT
    CASE
        WHEN COUNT(*) = 3 THEN 'COMMIT'
        ELSE 'ROLLBACK'
    END as action
FROM products;

COMMIT;
EOF

sqlite3 "${DBFILE}" ".read ./create_sqlite_table.sql"

