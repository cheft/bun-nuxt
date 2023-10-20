/*
  Warnings:

  - You are about to drop the column `networkNum` on the `VillageMark` table. All the data in the column will be lost.
  - Added the required column `lat` to the `VillageMark` table without a default value. This is not possible if the table is not empty.
  - Added the required column `lng` to the `VillageMark` table without a default value. This is not possible if the table is not empty.
  - Added the required column `region` to the `VillageMark` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_VillageMark" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "desc" TEXT NOT NULL,
    "region" TEXT NOT NULL,
    "lng" REAL NOT NULL,
    "lat" REAL NOT NULL,
    "creator" INTEGER,
    "updateTime" DATETIME
);
INSERT INTO "new_VillageMark" ("creator", "desc", "id", "name", "updateTime") SELECT "creator", "desc", "id", "name", "updateTime" FROM "VillageMark";
DROP TABLE "VillageMark";
ALTER TABLE "new_VillageMark" RENAME TO "VillageMark";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
