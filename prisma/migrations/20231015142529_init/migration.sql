-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_VillageMark" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "desc" TEXT NOT NULL,
    "networkNum" INTEGER NOT NULL,
    "creator" INTEGER,
    "updateTime" DATETIME
);
INSERT INTO "new_VillageMark" ("creator", "desc", "id", "name", "networkNum", "updateTime") SELECT "creator", "desc", "id", "name", "networkNum", "updateTime" FROM "VillageMark";
DROP TABLE "VillageMark";
ALTER TABLE "new_VillageMark" RENAME TO "VillageMark";
CREATE TABLE "new_Village" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "desc" TEXT NOT NULL,
    "networkNum" INTEGER NOT NULL,
    "creator" INTEGER,
    "updateTime" DATETIME
);
INSERT INTO "new_Village" ("creator", "desc", "id", "name", "networkNum", "updateTime") SELECT "creator", "desc", "id", "name", "networkNum", "updateTime" FROM "Village";
DROP TABLE "Village";
ALTER TABLE "new_Village" RENAME TO "Village";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
