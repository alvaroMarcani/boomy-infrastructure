-- Database initialization script
-- Create boomy_user role
CREATE ROLE boomy_user WITH LOGIN PASSWORD 'Boomy123!@#';

-- Create boomy_db database
CREATE DATABASE boomy_db OWNER boomy_user;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE boomy_db TO boomy_user;
GRANT CONNECT ON DATABASE boomy_db TO boomy_user;

-- Note: Tables are created by Entity Framework on first run
-- This script only sets up the database and user
