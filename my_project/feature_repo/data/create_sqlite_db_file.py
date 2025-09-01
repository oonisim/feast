import sqlite3

# Create empty database file
conn = sqlite3.connect('registry.db')
conn.close()

print("Empty database file created: registry.db")
