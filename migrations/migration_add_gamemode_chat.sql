-- Migration for adding GameMode and ChatMessage tables

-- Create GameMode table
CREATE TABLE "GameModes" (
    "Id" uuid NOT NULL PRIMARY KEY,
    "Name" character varying(255) NOT NULL,
    "Description" character varying(1024),
    "Number" integer NOT NULL,
    "ImageUrl" character varying(1024),
    "MinLevel" integer NOT NULL DEFAULT 1,
    "MaxPlayers" integer NOT NULL DEFAULT 4,
    "RewardMoney" numeric(18,2) NOT NULL DEFAULT 0,
    "RewardExp" integer NOT NULL DEFAULT 0,
    "Type" character varying(100) NOT NULL,
    "IsActive" boolean NOT NULL DEFAULT true,
    "CreatedAt" timestamp without time zone NOT NULL DEFAULT (NOW()),
    "UpdatedAt" timestamp without time zone
);

-- Create index on GameMode Number
CREATE UNIQUE INDEX "IX_GameModes_Number" ON "GameModes" ("Number");

-- Create ChatMessage table
CREATE TABLE "ChatMessages" (
    "Id" uuid NOT NULL PRIMARY KEY,
    "UserId" uuid NOT NULL,
    "UserName" character varying(255) NOT NULL,
    "Message" text NOT NULL,
    "Channel" character varying(100) NOT NULL DEFAULT 'General',
    "CreatedAt" timestamp without time zone NOT NULL DEFAULT (NOW()),
    CONSTRAINT "FK_ChatMessages_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

-- Create index on ChatMessage Channel and CreatedAt
CREATE INDEX "IX_ChatMessages_Channel_CreatedAt" ON "ChatMessages" ("Channel", "CreatedAt" DESC);

-- Add GameModeId to Games table
ALTER TABLE "Games" ADD COLUMN "GameModeId" uuid;

-- Add foreign key for Games.GameModeId
ALTER TABLE "Games" ADD CONSTRAINT "FK_Games_GameModes_GameModeId" FOREIGN KEY ("GameModeId") REFERENCES "GameModes" ("Id") ON DELETE RESTRICT;

-- Create index on Games.GameModeId
CREATE INDEX "IX_Games_GameModeId" ON "Games" ("GameModeId");

-- Seed sample game modes (optional)
INSERT INTO "GameModes" ("Id", "Name", "Description", "Number", "ImageUrl", "MinLevel", "MaxPlayers", "RewardMoney", "RewardExp", "Type", "IsActive", "CreatedAt")
VALUES
(gen_random_uuid(), 'Solo', 'Solo adventure mode', 1, 'assets/modes/solo.jpg', 1, 1, 1000, 100, 'Solo', true, NOW()),
(gen_random_uuid(), 'Tag', 'Tag team battle mode', 2, 'assets/modes/tag.jpg', 5, 2, 2500, 250, 'Tag', true, NOW()),
(gen_random_uuid(), 'Score', 'Score-based competitive mode', 3, 'assets/modes/score.jpg', 10, 4, 5000, 500, 'Score', true, NOW()),
(gen_random_uuid(), 'Jewel', 'Jewel hunting and collection mode', 4, 'assets/modes/jewel.jpg', 15, 4, 7500, 750, 'Jewel', true, NOW());
