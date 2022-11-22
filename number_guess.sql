CREATE DATABASE number_guess;

CREATE TABLE number_guess(user_name VARCHAR(20) NOT NULL,
                            guessing_attempts INT,
                            guess_id SERIAL);
