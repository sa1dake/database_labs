/*
  Warnings:

  - You are about to drop the column `building_number` on the `address` table. All the data in the column will be lost.
  - Added the required column `house_number` to the `address` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "address" DROP COLUMN "building_number",
ADD COLUMN     "house_number" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "consumer" ADD COLUMN     "email" TEXT;
