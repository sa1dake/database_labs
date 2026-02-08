-- CreateEnum
CREATE TYPE "consumer_type" AS ENUM ('residential', 'business', 'critical');

-- CreateEnum
CREATE TYPE "outage_reason" AS ENUM ('scheduled', 'emergency', 'maintenance');

-- CreateEnum
CREATE TYPE "region_type" AS ENUM ('city', 'region');

-- CreateTable
CREATE TABLE "address" (
    "address_id" SERIAL NOT NULL,
    "district_id" INTEGER NOT NULL,
    "group_id" INTEGER NOT NULL,
    "street" TEXT NOT NULL,
    "building_number" TEXT NOT NULL,

    CONSTRAINT "address_pkey" PRIMARY KEY ("address_id")
);

-- CreateTable
CREATE TABLE "consumer" (
    "consumer_id" SERIAL NOT NULL,
    "address_id" INTEGER NOT NULL,
    "consumer_type" "consumer_type" NOT NULL,

    CONSTRAINT "consumer_pkey" PRIMARY KEY ("consumer_id")
);

-- CreateTable
CREATE TABLE "district" (
    "district_id" SERIAL NOT NULL,
    "region_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "district_pkey" PRIMARY KEY ("district_id")
);

-- CreateTable
CREATE TABLE "group_schedule_assignment" (
    "assignment_id" SERIAL NOT NULL,
    "group_id" INTEGER NOT NULL,
    "template_id" INTEGER NOT NULL,
    "valid_from" DATE NOT NULL,
    "valid_to" DATE,

    CONSTRAINT "group_schedule_assignment_pkey" PRIMARY KEY ("assignment_id")
);

-- CreateTable
CREATE TABLE "notification" (
    "notification_id" SERIAL NOT NULL,
    "event_id" INTEGER NOT NULL,
    "message" TEXT NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notification_pkey" PRIMARY KEY ("notification_id")
);

-- CreateTable
CREATE TABLE "outage_event" (
    "event_id" SERIAL NOT NULL,
    "group_id" INTEGER NOT NULL,
    "start_datetime" TIMESTAMP(6) NOT NULL,
    "end_datetime" TIMESTAMP(6) NOT NULL,
    "reason" "outage_reason" NOT NULL,

    CONSTRAINT "outage_event_pkey" PRIMARY KEY ("event_id")
);

-- CreateTable
CREATE TABLE "power_group" (
    "group_id" SERIAL NOT NULL,
    "district_id" INTEGER NOT NULL,
    "code" TEXT NOT NULL,

    CONSTRAINT "power_group_pkey" PRIMARY KEY ("group_id")
);

-- CreateTable
CREATE TABLE "region" (
    "region_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "type" "region_type" NOT NULL,

    CONSTRAINT "region_pkey" PRIMARY KEY ("region_id")
);

-- CreateTable
CREATE TABLE "schedule_template" (
    "template_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "schedule_template_pkey" PRIMARY KEY ("template_id")
);

-- CreateTable
CREATE TABLE "schedule_time_slot" (
    "slot_id" SERIAL NOT NULL,
    "template_id" INTEGER NOT NULL,
    "day_of_week" INTEGER NOT NULL,
    "start_time" TIME(6) NOT NULL,
    "end_time" TIME(6) NOT NULL,

    CONSTRAINT "schedule_time_slot_pkey" PRIMARY KEY ("slot_id")
);

-- CreateTable
CREATE TABLE "review" (
    "review_id" SERIAL NOT NULL,
    "consumer_id" INTEGER NOT NULL,
    "event_id" INTEGER,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "review_pkey" PRIMARY KEY ("review_id")
);

-- AddForeignKey
ALTER TABLE "address" ADD CONSTRAINT "address_district_id_fkey" FOREIGN KEY ("district_id") REFERENCES "district"("district_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "address" ADD CONSTRAINT "address_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "power_group"("group_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "consumer" ADD CONSTRAINT "consumer_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "address"("address_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "district" ADD CONSTRAINT "district_region_id_fkey" FOREIGN KEY ("region_id") REFERENCES "region"("region_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "group_schedule_assignment" ADD CONSTRAINT "group_schedule_assignment_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "power_group"("group_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "group_schedule_assignment" ADD CONSTRAINT "group_schedule_assignment_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "schedule_template"("template_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "notification" ADD CONSTRAINT "notification_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "outage_event"("event_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "outage_event" ADD CONSTRAINT "outage_event_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "power_group"("group_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "power_group" ADD CONSTRAINT "power_group_district_id_fkey" FOREIGN KEY ("district_id") REFERENCES "district"("district_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "schedule_time_slot" ADD CONSTRAINT "schedule_time_slot_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "schedule_template"("template_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_consumer_id_fkey" FOREIGN KEY ("consumer_id") REFERENCES "consumer"("consumer_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "outage_event"("event_id") ON DELETE SET NULL ON UPDATE NO ACTION;
