-- Database initialization script
-- Create gunbound_user role
CREATE ROLE gunbound_user WITH LOGIN PASSWORD 'GunBound123!@#';

-- Create gunbound_db database
CREATE DATABASE gunbound_db OWNER gunbound_user;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE gunbound_db TO gunbound_user;
GRANT CONNECT ON DATABASE gunbound_db TO gunbound_user;

-- Note: Tables are created by Entity Framework on first run
-- This script only sets up the database and user
