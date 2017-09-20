CREATE TABLE IF NOT EXISTS GeoCache (
    Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    Timestamp DATETIME,
    Name TEXT,
    Lat DOUBLE,
    Lon DOUBLE,
    Street TEXT,
    City TEXT,
    Area TEXT,
    State TEXT,
    Country TEXT,
    Notes TEXT
);
CREATE TABLE IF NOT EXISTS Tags (
    Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    Tag TEXT
);