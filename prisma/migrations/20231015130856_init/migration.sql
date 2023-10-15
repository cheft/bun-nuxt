/*
  Warnings:

  - You are about to drop the column `graphIndex` on the `Village` table. All the data in the column will be lost.
  - You are about to drop the column `nameIndex` on the `Village` table. All the data in the column will be lost.

*/
-- CreateTable
CREATE TABLE "Token" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "uid" TEXT NOT NULL,
    "accessToken" TEXT NOT NULL,
    "refreshToken" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "VillageMark" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "desc" TEXT NOT NULL,
    "networkNum" INTEGER NOT NULL,
    "creator" INTEGER NOT NULL,
    "updateTime" DATETIME NOT NULL
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Village" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "desc" TEXT NOT NULL,
    "networkNum" INTEGER NOT NULL,
    "creator" INTEGER NOT NULL,
    "updateTime" DATETIME NOT NULL
);
INSERT INTO "new_Village" ("creator", "desc", "id", "name", "networkNum", "updateTime") SELECT "creator", "desc", "id", "name", "networkNum", "updateTime" FROM "Village";
DROP TABLE "Village";
ALTER TABLE "new_Village" RENAME TO "Village";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
