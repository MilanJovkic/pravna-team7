-- Schema for CBR case base

CREATE TABLE IF NOT EXISTS cases (
    id SERIAL PRIMARY KEY,
    case_number VARCHAR(50) NOT NULL,
    injury_type VARCHAR(100),
    location VARCHAR(100),
    weapon VARCHAR(100),
    weapon_used BOOLEAN,
    severe_consequence BOOLEAN,
    death_result BOOLEAN,
    negligence BOOLEAN,
    provocation BOOLEAN,
    fight_participation BOOLEAN,
    fight_consequence VARCHAR(50),
    left_without_help BOOLEAN,
    outcome VARCHAR(50)
);

CREATE INDEX idx_case_number ON cases(case_number);
CREATE INDEX idx_injury_type ON cases(injury_type);
CREATE INDEX idx_location ON cases(location);
